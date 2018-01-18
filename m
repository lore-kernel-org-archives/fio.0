Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t2353.austin.hpe.com ([15.233.44.26]:34104 "EHLO
        g2t2353.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932166AbeARXxx (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 18 Jan 2018 18:53:53 -0500
Received: from g2t2360.austin.hpecorp.net (g2t2360.austin.hpecorp.net [16.196.225.135])
        by g2t2353.austin.hpe.com (Postfix) with ESMTP id 1A02989
        for <fio@vger.kernel.org>; Thu, 18 Jan 2018 23:53:53 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 2/3] memcpytest: add more memcpy tests
Date: Thu, 18 Jan 2018 17:53:46 -0600
Message-Id: <20180118235347.30370-3-elliott@hpe.com>
In-Reply-To: <20180118235347.30370-1-elliott@hpe.com>
References: <20180118235347.30370-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

From: Robert Elliott <elliott@hpe.com>

Add more memcpy tests:
    memcpy = copy with libc memcpy() (d = s)(one read, one write)
    memcsum = read memory to registers (one read)
    memset = write memory from registers with libc memset() (one write)
    wmemset = write memory from registers with libc wmemset() (one write)
    streamcopy = STREAM copy (d = s)(one read, one write)
    streamadd = STREAM add (d = s1 + s2)(two reads, add, one write)
    streamscale = STREAM scale (d = 3 * s1)(one read, multiply, one write)
    streamtriad = STREAM triad (d = s1 + 3 * s2)(two reads, add and multiply, one write)
---
 engines/dev-dax.c |  12 +-
 engines/libpmem.c |  18 +--
 engines/mmap.c    |  13 ++-
 lib/memcpy.c      | 323 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 lib/memcpy.h      |   4 +
 5 files changed, 320 insertions(+), 50 deletions(-)

diff --git a/engines/dev-dax.c b/engines/dev-dax.c
index caae1e09..fc169450 100644
--- a/engines/dev-dax.c
+++ b/engines/dev-dax.c
@@ -73,19 +73,19 @@ static int fio_devdax_file(struct thread_data *td, struct fio_file *f,
 			   size_t length, off_t off)
 {
 	struct fio_devdax_data *fdd = FILE_ENG_DATA(f);
-	int flags = 0;
+	int prot = 0;
 
 	if (td_rw(td))
-		flags = PROT_READ | PROT_WRITE;
+		prot = PROT_READ | PROT_WRITE;
 	else if (td_write(td)) {
-		flags = PROT_WRITE;
+		prot = PROT_WRITE;
 
 		if (td->o.verify != VERIFY_NONE)
-			flags |= PROT_READ;
+			prot |= PROT_READ;
 	} else
-		flags = PROT_READ;
+		prot = PROT_READ;
 
-	fdd->devdax_ptr = mmap(NULL, length, flags, MAP_SHARED, f->fd, off);
+	fdd->devdax_ptr = mmap(NULL, length, prot, MAP_SHARED, f->fd, off);
 	if (fdd->devdax_ptr == MAP_FAILED) {
 		fdd->devdax_ptr = NULL;
 		td_verror(td, errno, "mmap");
diff --git a/engines/libpmem.c b/engines/libpmem.c
index aa0a36f9..a6fdf964 100644
--- a/engines/libpmem.c
+++ b/engines/libpmem.c
@@ -318,31 +318,31 @@ static int fio_libpmem_file(struct thread_data *td, struct fio_file *f,
 			    size_t length, off_t off)
 {
 	struct fio_libpmem_data *fdd = FILE_ENG_DATA(f);
-	int flags = 0;
+	int prot = 0;
 	void *addr = NULL;
 
 	dprint(FD_IO, "DEBUG fio_libpmem_file\n");
 
 	if (td_rw(td))
-		flags = PROT_READ | PROT_WRITE;
+		prot = PROT_READ | PROT_WRITE;
 	else if (td_write(td)) {
-		flags = PROT_WRITE;
+		prot = PROT_WRITE;
 
 		if (td->o.verify != VERIFY_NONE)
-			flags |= PROT_READ;
+			prot |= PROT_READ;
 	} else
-		flags = PROT_READ;
+		prot = PROT_READ;
 
 	dprint(FD_IO, "f->file_name = %s  td->o.verify = %d \n", f->file_name,
 			td->o.verify);
-	dprint(FD_IO, "length = %ld  flags = %d  f->fd = %d off = %ld \n",
-			length, flags, f->fd,off);
+	dprint(FD_IO, "length = %ld  prot = %d  f->fd = %d off = %ld \n",
+			length, prot, f->fd,off);
 
 	addr = util_map_hint(length, 0);
 
 	dprint(FD_IO, "DEBUG mmap addr=%p length=0x%lx prot=0x%x\n",
-	       addr, length, flags);
-	fdd->libpmem_ptr = mmap(addr, length, flags, MAP_SHARED, f->fd, off);
+	       addr, length, prot);
+	fdd->libpmem_ptr = mmap(addr, length, prot, MAP_SHARED, f->fd, off);
 	if (fdd->libpmem_ptr == MAP_FAILED) {
 		fdd->libpmem_ptr = NULL;
 		td_verror(td, errno, "mmap");
diff --git a/engines/mmap.c b/engines/mmap.c
index 77556588..54b5b11d 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -31,19 +31,20 @@ static int fio_mmap_file(struct thread_data *td, struct fio_file *f,
 			 size_t length, off_t off)
 {
 	struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
-	int flags = 0;
+	int prot = 0;
+	int flags = MAP_SHARED;
 
 	if (td_rw(td) && !td->o.verify_only)
-		flags = PROT_READ | PROT_WRITE;
+		prot = PROT_READ | PROT_WRITE;
 	else if (td_write(td) && !td->o.verify_only) {
-		flags = PROT_WRITE;
+		prot = PROT_WRITE;
 
 		if (td->o.verify != VERIFY_NONE)
-			flags |= PROT_READ;
+			prot |= PROT_READ;
 	} else
-		flags = PROT_READ;
+		prot = PROT_READ;
 
-	fmd->mmap_ptr = mmap(NULL, length, flags, MAP_SHARED, f->fd, off);
+	fmd->mmap_ptr = mmap(NULL, length, prot, flags, f->fd, off);
 	if (fmd->mmap_ptr == MAP_FAILED) {
 		fmd->mmap_ptr = NULL;
 		td_verror(td, errno, "mmap");
diff --git a/lib/memcpy.c b/lib/memcpy.c
index a79d7c50..e52a08fd 100644
--- a/lib/memcpy.c
+++ b/lib/memcpy.c
@@ -1,7 +1,10 @@
+#include <stdint.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <wchar.h>
 
+#include "memalign.h"
 #include "memcpy.h"
 #include "rand.h"
 #include "../fio_time.h"
@@ -23,6 +26,7 @@
 struct memcpy_test {
 	const char *name;
 	void *src;
+	void *src2;
 	void *dst;
 	size_t size;
 };
@@ -140,14 +144,22 @@ static struct memcpy_test tests[] = {
 struct memcpy_type {
 	const char *name;
 	unsigned int mask;
-	void (*fn)(struct memcpy_test *);
+	void (*fn)(struct memcpy_type *, struct memcpy_test *);
 };
 
 enum {
 	T_MEMCPY	= 1U << 0,
 	T_MEMMOVE	= 1U << 1,
-	T_SIMPLE	= 1U << 2,
+	T_SIMPLE_MEMCPY	= 1U << 2,
 	T_HYBRID	= 1U << 3,
+	T_MEMSET	= 1U << 4,
+	T_WMEMSET	= 1U << 5,
+	T_SIMPLE_MEMSET	= 1U << 6,
+	T_MEMCSUM	= 1U << 7,
+	T_STREAMCOPY	= 1U << 8,
+	T_STREAMSCALE	= 1U << 9,
+	T_STREAMADD	= 1U << 10,
+	T_STREAMTRIAD	= 1U << 11,
 };
 
 #define do_test(test, fn)	do {					\
@@ -171,31 +183,61 @@ enum {
 	}								\
 } while (0)
 
-static void t_memcpy(struct memcpy_test *test)
+#define do_test_twosources(t, test, fn)	do {				\
+	size_t left, this;						\
+	void *src, *src2, *dst;						\
+	int i;								\
+									\
+	for (i = 0; i < NR_ITERS; i++) {				\
+		left = BUF_SIZE;					\
+		src = test->src;					\
+		src2 = test->src2;					\
+		dst = test->dst;					\
+		while (left) {						\
+			this = test->size;				\
+			if (this > left)				\
+				this = left;				\
+			(fn)(dst, src, src2, this);			\
+			left -= this;					\
+			src += this;					\
+			src2 += this;					\
+			dst += this;					\
+		}							\
+	}								\
+} while (0)
+
+static void flush_caches(struct memcpy_type *t, struct memcpy_test *test)
+{
+	__builtin___clear_cache(test->src, test->src + BUF_SIZE);
+	__builtin___clear_cache(test->src2, test->src2 + BUF_SIZE);
+	__builtin___clear_cache(test->dst, test->dst + BUF_SIZE);
+}
+
+static void t_memcpy(struct memcpy_type *t, struct memcpy_test *test)
 {
 	do_test(test, memcpy);
 }
 
-static void t_memmove(struct memcpy_test *test)
+static void t_memmove(struct memcpy_type *t, struct memcpy_test *test)
 {
 	do_test(test, memmove);
 }
 
 static void simple_memcpy(void *dst, void const *src, size_t len)
 {
- 	char *d = dst;
+	char *d = dst;
 	const char *s = src;
 
 	while (len--)
 		*d++ = *s++;
 }
 
-static void t_simple(struct memcpy_test *test)
+static void t_simple_memcpy(struct memcpy_type *t, struct memcpy_test *test)
 {
 	do_test(test, simple_memcpy);
 }
 
-static void t_hybrid(struct memcpy_test *test)
+static void t_hybrid(struct memcpy_type *t, struct memcpy_test *test)
 {
 	if (test->size >= 64)
 		do_test(test, simple_memcpy);
@@ -203,6 +245,186 @@ static void t_hybrid(struct memcpy_test *test)
 		do_test(test, memcpy);
 }
 
+static void t_memset(struct memcpy_type *t, struct memcpy_test *test)
+{
+	size_t left, this;
+	void *dst;
+	int i;
+
+	for (i = 0; i < NR_ITERS; i++) {
+		left = BUF_SIZE;
+		dst = test->dst;
+		// NOTE: test->size must divide into BUF_SIZE or this will loop forever
+		while (left) {
+			this = test->size;
+			if (this > left)
+				this = left;
+			memset(dst, 0x00, this);
+			left -= this;
+			dst += this;
+		}
+	}
+}
+
+static void t_wmemset(struct memcpy_type *t, struct memcpy_test *test)
+{
+	size_t left, this;
+	void *dst;
+	int i;
+
+	for (i = 0; i < NR_ITERS; i++) {
+		left = BUF_SIZE;
+		dst = test->dst;
+		// NOTE: test->size must divide into BUF_SIZE or this will loop forever
+		while (left) {
+			this = test->size;
+			if (this > left)
+				this = left;
+			wmemset(dst, 0x0000, this / sizeof(wchar_t));
+			left -= this;
+			dst += this;
+		}
+	}
+}
+static void simple_memset(void *dst, uint8_t val, size_t len)
+{
+	uint8_t *d = dst;
+
+	// assert len is multiple of 8
+	while (len) {
+		*d++ = val + len;
+		len -= sizeof(uint8_t);
+	}
+}
+
+static void t_simple_memset(struct memcpy_type *t, struct memcpy_test *test)
+{
+	size_t left, this;
+	uint8_t *dst;
+	int i;
+
+	for (i = 0; i < NR_ITERS; i++) {
+		left = BUF_SIZE;
+		dst = test->dst;
+		// NOTE: test->size must divide into BUF_SIZE or this will loop forever
+		while (left) {
+			this = test->size;
+			if (this > left)
+				this = left;
+			simple_memset(dst, 0x00, this);
+			left -= this;
+			dst += this;
+		}
+	}
+}
+
+volatile uint64_t csum;
+static void simple_memcsum(void const *src, size_t len)
+{
+	const uint64_t *s = src;
+
+	// assert len is multiple of 8
+	while (len) {
+		csum += *s++;
+		len -= sizeof(uint64_t);
+	}
+}
+
+// read memory, but use all the results so it is not optimized away
+// to benchmark read performance
+static void t_memcsum(struct memcpy_type *t, struct memcpy_test *test)
+{
+	size_t left, this;
+	void *src;
+	int i;
+
+	if (test->size < sizeof csum)
+		return;
+	for (i = 0; i < NR_ITERS; i++) {
+		left = BUF_SIZE;
+		src = test->src;
+		while (left) {
+			this = test->size;
+			if (this > left)
+				this = left;
+			simple_memcsum(src, this);
+			left -= this;
+			src += this;
+		}
+	}
+}
+
+const double scalar = 3.0;
+void streamcopy(void *dst, void const *src, size_t len)
+{
+	double *d = dst;
+	const double *s = src;
+
+	while (len -= sizeof(double))
+		*d++ = *s++;
+}
+
+static void t_streamcopy(struct memcpy_type *t, struct memcpy_test *test)
+{
+	if (test->size < sizeof scalar)
+		return;
+	do_test(test, streamcopy);
+}
+
+void streamscale(void *dst, void const *src, size_t len)
+{
+	double *d = dst;
+	const double *s = src;
+
+	while (len -= sizeof(double))
+		*d++ = scalar * *s++;
+}
+
+static void t_streamscale(struct memcpy_type *t, struct memcpy_test *test)
+{
+	if (test->size < sizeof scalar)
+		return;
+	do_test(test, streamscale);
+}
+
+void streamadd(void *dst, void const *src, void const *src2, size_t len)
+{
+	double *d = dst;
+	const double *s = src;
+	const double *s2 = src2;
+
+	while (len) {
+		*d++ = *s++ + *s2++;
+		len -= sizeof(double);
+	}
+}
+
+static void t_streamadd(struct memcpy_type *t, struct memcpy_test *test)
+{
+	if (test->size < sizeof scalar)
+		return;
+	do_test_twosources(t, test, streamadd);
+}
+
+void streamtriad(void *dst, void const *src, void const *src2, size_t len)
+{
+	double *d = dst;
+	const double *s = src;
+	const double *s2 = src2;
+
+	while (len) {
+		*d++ = *s++ + scalar * *s2++;
+		len -= sizeof(double);
+	}
+}
+
+static void t_streamtriad(struct memcpy_type *t, struct memcpy_test *test)
+{
+	if (test->size < sizeof scalar)
+		return;
+	do_test_twosources(t, test, streamtriad);
+}
+
 static struct memcpy_type t[] = {
 	{
 		.name = "memcpy",
@@ -215,9 +437,49 @@ static struct memcpy_type t[] = {
 		.fn = t_memmove,
 	},
 	{
-		.name = "simple",
-		.mask = T_SIMPLE,
-		.fn = t_simple,
+		.name = "simple_memcpy",
+		.mask = T_SIMPLE_MEMCPY,
+		.fn = t_simple_memcpy,
+	},
+	{
+		.name = "memset",
+		.mask = T_MEMSET,
+		.fn = t_memset,
+	},
+	{
+		.name = "wmemset",
+		.mask = T_WMEMSET,
+		.fn = t_wmemset,
+	},
+	{
+		.name = "simple_memset",
+		.mask = T_SIMPLE_MEMSET,
+		.fn = t_simple_memset,
+	},
+	{
+		.name = "memcsum",
+		.mask = T_MEMCSUM,
+		.fn = t_memcsum,
+	},
+	{
+		.name = "streamcopy",
+		.mask = T_STREAMCOPY,
+		.fn = t_streamcopy,
+	},
+	{
+		.name = "streamscale",
+		.mask = T_STREAMSCALE,
+		.fn = t_streamscale,
+	},
+	{
+		.name = "streamadd",
+		.mask = T_STREAMADD,
+		.fn = t_streamadd,
+	},
+	{
+		.name = "streamtriad",
+		.mask = T_STREAMTRIAD,
+		.fn = t_streamtriad,
 	},
 	{
 		.name = "hybrid",
@@ -265,23 +527,27 @@ static int setup_tests(void)
 {
 	struct memcpy_test *test;
 	struct frand_state state;
-	void *src, *dst;
+	void *src, *src2, *dst;
 	int i;
 
-	src = malloc(BUF_SIZE);
-	dst = malloc(BUF_SIZE);
-	if (!src || !dst) {
-		free(src);
-		free(dst);
+	// align to multiple of cache line size so library functions take the
+	// optimized paths
+	// e.g., __memmove_avx_erms rather than _mmmemmove_avs_unaligned_erms
+	src = fio_memalign(BUF_ALIGN, BUF_SIZE);
+	src2 = fio_memalign(BUF_ALIGN, BUF_SIZE);
+	dst = fio_memalign(BUF_ALIGN, BUF_SIZE);
+	if (!src || !src2 || !dst)
+		// FIXFIX free too
 		return 1;
-	}
 
 	init_rand_seed(&state, 0x8989, 0);
 	fill_random_buf(&state, src, BUF_SIZE);
+	fill_random_buf(&state, src2, BUF_SIZE);
 
 	for (i = 0; tests[i].name; i++) {
 		test = &tests[i];
 		test->src = src;
+		test->src2 = src2;
 		test->dst = dst;
 	}
 
@@ -290,8 +556,9 @@ static int setup_tests(void)
 
 static void free_tests(void)
 {
-	free(tests[0].src);
-	free(tests[0].dst);
+	fio_memfree(tests[0].src, BUF_SIZE);
+	fio_memfree(tests[0].src2, BUF_SIZE);
+	fio_memfree(tests[0].dst, BUF_SIZE);
 }
 
 int fio_memcpy_test(const char *type)
@@ -316,6 +583,9 @@ int fio_memcpy_test(const char *type)
 		return 1;
 	}
 
+	printf("memcpytest compile-time options: BUF_SIZE=%lld MiB, NR_INTERS=%d\n",
+	       BUF_SIZE / 1024 / 1024, NR_ITERS);
+
 	for (i = 0; t[i].name; i++) {
 		struct timespec ts;
 		double mb_sec;
@@ -324,18 +594,13 @@ int fio_memcpy_test(const char *type)
 		if (!(t[i].mask & test_mask))
 			continue;
 
-		/*
-		 * For first run, make sure CPUs are spun up and that
-		 * we've touched the data.
-		 */
-		usec_spin(100000);
-		t[i].fn(&tests[0]);
-
 		printf("%s\n", t[i].name);
 
 		for (j = 0; tests[j].name; j++) {
+			flush_caches(&t[i], &tests[j]);
 			fio_gettime(&ts, NULL);
-			t[i].fn(&tests[j]);
+			t[i].fn(&t[i], &tests[j]);
+			flush_caches(&t[i], &tests[j]);
 			usec = utime_since_now(&ts);
 
 			if (usec) {
@@ -343,9 +608,9 @@ int fio_memcpy_test(const char *type)
 
 				mb_sec = (double) mb / (double) usec;
 				mb_sec /= (1.024 * 1.024);
-				printf("\t%s:\t%8.2f MiB/sec\n", tests[j].name, mb_sec);
+				printf("\t%s:\t%8.2f MiB/s\n", tests[j].name, mb_sec);
 			} else
-				printf("\t%s:inf MiB/sec\n", tests[j].name);
+				printf("\t%s:\tinf MiB/s\n", tests[j].name);
 		}
 	}
 
diff --git a/lib/memcpy.h b/lib/memcpy.h
index f61a4a09..86006e71 100644
--- a/lib/memcpy.h
+++ b/lib/memcpy.h
@@ -2,5 +2,9 @@
 #define FIO_MEMCPY_H
 
 int fio_memcpy_test(const char *type);
+void streamcopy(void *dst, void const *src, size_t len);
+void streamscale(void *dst, void const *src, size_t len);
+void streamadd(void *dst, void const *src, void const *src2, size_t len);
+void streamtriad(void *dst, void const *src, void const *src2, size_t len);
 
 #endif
-- 
2.14.3

