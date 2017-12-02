Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50176 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751683AbdLBNAS (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 2 Dec 2017 08:00:18 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eL7Oz-0007VJ-6X
        for fio@vger.kernel.org; Sat, 02 Dec 2017 13:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171202130002.2E3F12C0137@kernel.dk>
Date: Sat,  2 Dec 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e1c325d25dd977c28c9489c542a51ee05dfc620e:

  io_u: don't account io issue blocks for verify backlog (2017-11-30 21:48:12 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e0409d5ffe6127961ddc4c495ec32b72a65e11bf:

  thread_options: drop fadvise_stream from thread_options (2017-12-01 14:54:49 -0700)

----------------------------------------------------------------
Jens Axboe (5):
      Add basic memcpy test
      fio_time: should include time.h
      memcpy: use malloc
      memcpy: free buffer in case of failure
      memcpy: add hybrid

Vincent Fu (1):
      thread_options: drop fadvise_stream from thread_options

 fio_time.h       |   1 +
 init.c           |  11 +++
 lib/memcpy.c     | 286 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/memcpy.h     |   6 ++
 server.h         |   2 +-
 thread_options.h |   3 -
 6 files changed, 305 insertions(+), 4 deletions(-)
 create mode 100644 lib/memcpy.c
 create mode 100644 lib/memcpy.h

---

Diff of recent changes:

diff --git a/fio_time.h b/fio_time.h
index c7c3dbb..ee8087e 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -1,6 +1,7 @@
 #ifndef FIO_TIME_H
 #define FIO_TIME_H
 
+#include <time.h>
 #include "lib/types.h"
 
 struct thread_data;
diff --git a/init.c b/init.c
index 607f7e0..c34bd15 100644
--- a/init.c
+++ b/init.c
@@ -32,6 +32,7 @@
 
 #include "crc/test.h"
 #include "lib/pow2.h"
+#include "lib/memcpy.h"
 
 const char fio_version_string[] = FIO_VERSION;
 
@@ -234,6 +235,11 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.val		= 'G',
 	},
 	{
+		.name		= (char *) "memcpytest",
+		.has_arg	= optional_argument,
+		.val		= 'M',
+	},
+	{
 		.name		= (char *) "idle-prof",
 		.has_arg	= required_argument,
 		.val		= 'I',
@@ -2731,6 +2737,11 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			do_exit++;
 			exit_val = fio_crctest(optarg);
 			break;
+		case 'M':
+			did_arg = true;
+			do_exit++;
+			exit_val = fio_memcpy_test(optarg);
+			break;
 		case 'L': {
 			long long val;
 
diff --git a/lib/memcpy.c b/lib/memcpy.c
new file mode 100644
index 0000000..00e65aa
--- /dev/null
+++ b/lib/memcpy.c
@@ -0,0 +1,286 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "memcpy.h"
+#include "rand.h"
+#include "../fio_time.h"
+#include "../gettime.h"
+#include "../fio.h"
+
+#define BUF_SIZE	32 * 1024 * 1024ULL
+
+#define NR_ITERS	64
+
+struct memcpy_test {
+	const char *name;
+	void *src;
+	void *dst;
+	size_t size;
+};
+
+static struct memcpy_test tests[] = {
+	{
+		.name		= "8 bytes",
+		.size		= 8,
+	},
+	{
+		.name		= "16 bytes",
+		.size		= 16,
+	},
+	{
+		.name		= "96 bytes",
+		.size		= 96,
+	},
+	{
+		.name		= "128 bytes",
+		.size		= 128,
+	},
+	{
+		.name		= "256 bytes",
+		.size		= 256,
+	},
+	{
+		.name		= "512 bytes",
+		.size		= 512,
+	},
+	{
+		.name		= "2048 bytes",
+		.size		= 2048,
+	},
+	{
+		.name		= "8192 bytes",
+		.size		= 8192,
+	},
+	{
+		.name		= "131072 bytes",
+		.size		= 131072,
+	},
+	{
+		.name		= "262144 bytes",
+		.size		= 262144,
+	},
+	{
+		.name		= "524288 bytes",
+		.size		= 524288,
+	},
+	{
+		.name		= NULL,
+	},
+};
+
+struct memcpy_type {
+	const char *name;
+	unsigned int mask;
+	void (*fn)(struct memcpy_test *);
+};
+
+enum {
+	T_MEMCPY	= 1U << 0,
+	T_MEMMOVE	= 1U << 1,
+	T_SIMPLE	= 1U << 2,
+	T_HYBRID	= 1U << 3,
+};
+
+#define do_test(test, fn)	do {					\
+	size_t left, this;						\
+	void *src, *dst;						\
+	int i;								\
+									\
+	for (i = 0; i < NR_ITERS; i++) {				\
+		left = BUF_SIZE;					\
+		src = test->src;					\
+		dst = test->dst;					\
+		while (left) {						\
+			this = test->size;				\
+			if (this > left)				\
+				this = left;				\
+			(fn)(dst, src, this);				\
+			left -= this;					\
+			src += this;					\
+			dst += this;					\
+		}							\
+	}								\
+} while (0)
+
+static void t_memcpy(struct memcpy_test *test)
+{
+	do_test(test, memcpy);
+}
+
+static void t_memmove(struct memcpy_test *test)
+{
+	do_test(test, memmove);
+}
+
+static void simple_memcpy(void *dst, void const *src, size_t len)
+{
+ 	char *d = dst;
+	const char *s = src;
+
+	while (len--)
+		*d++ = *s++;
+}
+
+static void t_simple(struct memcpy_test *test)
+{
+	do_test(test, simple_memcpy);
+}
+
+static void t_hybrid(struct memcpy_test *test)
+{
+	if (test->size >= 64)
+		do_test(test, simple_memcpy);
+	else
+		do_test(test, memcpy);
+}
+
+static struct memcpy_type t[] = {
+	{
+		.name = "memcpy",
+		.mask = T_MEMCPY,
+		.fn = t_memcpy,
+	},
+	{
+		.name = "memmove",
+		.mask = T_MEMMOVE,
+		.fn = t_memmove,
+	},
+	{
+		.name = "simple",
+		.mask = T_SIMPLE,
+		.fn = t_simple,
+	},
+	{
+		.name = "hybrid",
+		.mask = T_HYBRID,
+		.fn = t_hybrid,
+	},
+	{
+		.name = NULL,
+	},
+};
+
+static unsigned int get_test_mask(const char *type)
+{
+	char *ostr, *str = strdup(type);
+	unsigned int mask;
+	char *name;
+	int i;
+
+	ostr = str;
+	mask = 0;
+	while ((name = strsep(&str, ",")) != NULL) {
+		for (i = 0; t[i].name; i++) {
+			if (!strcmp(t[i].name, name)) {
+				mask |= t[i].mask;
+				break;
+			}
+		}
+	}
+
+	free(ostr);
+	return mask;
+}
+
+static int list_types(void)
+{
+	int i;
+
+	for (i = 0; t[i].name; i++)
+		printf("%s\n", t[i].name);
+
+	return 1;
+}
+
+static int setup_tests(void)
+{
+	struct memcpy_test *test;
+	struct frand_state state;
+	void *src, *dst;
+	int i;
+
+	src = malloc(BUF_SIZE);
+	dst = malloc(BUF_SIZE);
+	if (!src || !dst) {
+		free(src);
+		free(dst);
+		return 1;
+	}
+
+	init_rand_seed(&state, 0x8989, 0);
+	fill_random_buf(&state, src, BUF_SIZE);
+
+	for (i = 0; tests[i].name; i++) {
+		test = &tests[i];
+		test->src = src;
+		test->dst = dst;
+	}
+
+	return 0;
+}
+
+static void free_tests(void)
+{
+	free(tests[0].src);
+	free(tests[0].dst);
+}
+
+int fio_memcpy_test(const char *type)
+{
+	unsigned int test_mask = 0;
+	int j, i;
+
+	if (!type)
+		test_mask = ~0U;
+	else if (!strcmp(type, "help") || !strcmp(type, "list"))
+		return list_types();
+	else
+		test_mask = get_test_mask(type);
+
+	if (!test_mask) {
+		fprintf(stderr, "fio: unknown hash `%s`. Available:\n", type);
+		return list_types();
+	}
+
+	if (setup_tests()) {
+		fprintf(stderr, "setting up mem regions failed\n");
+		return 1;
+	}
+
+	for (i = 0; t[i].name; i++) {
+		struct timespec ts;
+		double mb_sec;
+		uint64_t usec;
+
+		if (!(t[i].mask & test_mask))
+			continue;
+
+		/*
+		 * For first run, make sure CPUs are spun up and that
+		 * we've touched the data.
+		 */
+		usec_spin(100000);
+		t[i].fn(&tests[0]);
+
+		printf("%s\n", t[i].name);
+
+		for (j = 0; tests[j].name; j++) {
+			fio_gettime(&ts, NULL);
+			t[i].fn(&tests[j]);
+			usec = utime_since_now(&ts);
+
+			if (usec) {
+				unsigned long long mb = NR_ITERS * BUF_SIZE;
+
+				mb_sec = (double) mb / (double) usec;
+				mb_sec /= (1.024 * 1.024);
+				printf("\t%s:\t%8.2f MiB/sec\n", tests[j].name, mb_sec);
+			} else
+				printf("\t%s:inf MiB/sec\n", tests[j].name);
+		}
+	}
+
+	free_tests();
+	return 0;
+}
diff --git a/lib/memcpy.h b/lib/memcpy.h
new file mode 100644
index 0000000..f61a4a0
--- /dev/null
+++ b/lib/memcpy.h
@@ -0,0 +1,6 @@
+#ifndef FIO_MEMCPY_H
+#define FIO_MEMCPY_H
+
+int fio_memcpy_test(const char *type);
+
+#endif
diff --git a/server.h b/server.h
index dbd5c27..438a6c3 100644
--- a/server.h
+++ b/server.h
@@ -49,7 +49,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 67,
+	FIO_SERVER_VER			= 68,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index a9c3bee..793df8a 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -218,7 +218,6 @@ struct thread_options {
 	unsigned int group_reporting;
 	unsigned int stats;
 	unsigned int fadvise_hint;
-	unsigned int fadvise_stream;
 	enum fio_fallocate_mode fallocate_mode;
 	unsigned int zero_buffers;
 	unsigned int refill_buffers;
@@ -494,7 +493,6 @@ struct thread_options_pack {
 	uint32_t group_reporting;
 	uint32_t stats;
 	uint32_t fadvise_hint;
-	uint32_t fadvise_stream;
 	uint32_t fallocate_mode;
 	uint32_t zero_buffers;
 	uint32_t refill_buffers;
@@ -520,7 +518,6 @@ struct thread_options_pack {
 	uint64_t trim_backlog;
 	uint32_t clat_percentiles;
 	uint32_t percentile_precision;
-	uint32_t pad;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
