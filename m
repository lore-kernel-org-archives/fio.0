Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55857 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaGYMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 25 Jul 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XAeAP-0007Xa-3h
	for fio@vger.kernel.org; Fri, 25 Jul 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140725120003.0CFBB400D5@lyth.info>
Date: Fri, 25 Jul 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5c57c084346fbfe6f3f45236c151ad1c83b6b398:

  null: add FIO_FAKEIO flag (2014-07-23 16:19:48 +0200)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 24ef7a61bc7b9ec0f479980b6b219ef7d986d708:

  crc/test: cleanup and better precision (2014-07-25 10:12:26 +0200)

----------------------------------------------------------------
Jens Axboe (3):
      Add test case for previous verify crash
      Don't grab stat mutex for final stat output
      crc/test: cleanup and better precision

Jiri Horky (1):
      Allow reset of offset_increment counter

 HOWTO                     |   11 ++--
 backend.c                 |    2 +-
 crc/test.c                |  132 +++++++++++++++------------------------------
 filesetup.c               |    2 +-
 fio.1                     |    9 ++--
 fio.h                     |    1 +
 init.c                    |    2 +
 stat.c                    |    2 +-
 stat.h                    |    1 +
 t/jobs/t0009-f8b0bd10.fio |   40 ++++++++++++++
 10 files changed, 101 insertions(+), 101 deletions(-)
 create mode 100644 t/jobs/t0009-f8b0bd10.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index ac96069..1c4b308 100644
--- a/HOWTO
+++ b/HOWTO
@@ -736,11 +736,12 @@ offset=int	Start io at the given offset in the file. The data before
 		caps the file size at real_size - offset.
 
 offset_increment=int	If this is provided, then the real offset becomes
-		the offset + offset_increment * thread_number, where the
-		thread number is a counter that starts at 0 and is incremented
-		for each job. This option is useful if there are several jobs
-		which are intended to operate on a file in parallel in disjoint
-		segments, with even spacing between the starting points.
+		offset + offset_increment * thread_number, where the thread
+		number is a counter that starts at 0 and is incremented for
+		each sub-job (i.e. when numjobs option is specified). This
+		option is useful if there are several jobs which are intended
+		to operate on a file in parallel disjoint segments, with
+		even spacing between the starting points.
 
 number_ios=int	Fio will normally perform IOs until it has exhausted the size
 		of the region set by size=, or if it exhaust the allocated
diff --git a/backend.c b/backend.c
index 30f78b7..981625b 100644
--- a/backend.c
+++ b/backend.c
@@ -2068,7 +2068,7 @@ int fio_backend(void)
 	run_threads();
 
 	if (!fio_abort) {
-		show_run_stats();
+		__show_run_stats();
 		if (write_bw_log) {
 			int i;
 
diff --git a/crc/test.c b/crc/test.c
index 3ce717a..194bbed 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -26,7 +26,7 @@
 struct test_type {
 	const char *name;
 	unsigned int mask;
-	uint64_t (*fn)(void);
+	uint64_t (*fn)(void *, size_t);
 };
 
 enum {
@@ -50,213 +50,153 @@ static void randomize_buf(void *buf, unsigned int size, int seed)
 	fill_random_buf(&state, buf, size);
 }
 
-static uint64_t t_md5(void)
+static uint64_t t_md5(void *buf, size_t size)
 {
 	uint32_t digest[4];
 	struct fio_md5_ctx ctx = { .hash = digest };
 	struct timeval s;
-	uint64_t ret;
-	void *buf;
 	int i;
 
 	fio_md5_init(&ctx);
 
-	buf = malloc(CHUNK);
-	randomize_buf(buf, CHUNK, 0x8989);
-
 	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
-		fio_md5_update(&ctx, buf, CHUNK);
+		fio_md5_update(&ctx, buf, size);
 
-	ret = utime_since_now(&s);
-	free(buf);
-	return ret;
+	return utime_since_now(&s);
 }
 
-static uint64_t t_crc64(void)
+static uint64_t t_crc64(void *buf, size_t size)
 {
 	struct timeval s;
-	uint64_t ret;
-	void *buf;
 	int i;
 
-	buf = malloc(CHUNK);
-	randomize_buf(buf, CHUNK, 0x8989);
-
 	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
-		fio_crc64(buf, CHUNK);
+		fio_crc64(buf, size);
 
-	ret = utime_since_now(&s);
-	free(buf);
-	return ret;
+	return utime_since_now(&s);
 }
 
-static uint64_t t_crc32(void)
+static uint64_t t_crc32(void *buf, size_t size)
 {
 	struct timeval s;
-	uint64_t ret;
-	void *buf;
 	int i;
 
-	buf = malloc(CHUNK);
-	randomize_buf(buf, CHUNK, 0x8989);
-
 	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
-		fio_crc32(buf, CHUNK);
+		fio_crc32(buf, size);
 
-	ret = utime_since_now(&s);
-	free(buf);
-	return ret;
+	return utime_since_now(&s);
 }
 
-static uint64_t t_crc32c(void)
+static uint64_t t_crc32c(void *buf, size_t size)
 {
 	struct timeval s;
-	uint64_t ret;
-	void *buf;
 	int i;
 
-	buf = malloc(CHUNK);
-	randomize_buf(buf, CHUNK, 0x8989);
-
 	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
-		fio_crc32c(buf, CHUNK);
+		fio_crc32c(buf, size);
 
-	ret = utime_since_now(&s);
-	free(buf);
-	return ret;
+	return utime_since_now(&s);
 }
 
-static uint64_t t_crc16(void)
+static uint64_t t_crc16(void *buf, size_t size)
 {
 	struct timeval s;
-	uint64_t ret;
-	void *buf;
 	int i;
 
-	buf = malloc(CHUNK);
-	randomize_buf(buf, CHUNK, 0x8989);
-
 	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
-		fio_crc16(buf, CHUNK);
+		fio_crc16(buf, size);
 
-	ret = utime_since_now(&s);
-	free(buf);
-	return ret;
+	return utime_since_now(&s);
 }
 
-static uint64_t t_crc7(void)
+static uint64_t t_crc7(void *buf, size_t size)
 {
 	struct timeval s;
 	uint64_t ret;
-	void *buf;
 	int i;
 
-	buf = malloc(CHUNK);
-	randomize_buf(buf, CHUNK, 0x8989);
-
 	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
-		fio_crc7(buf, CHUNK);
+		fio_crc7(buf, size);
 
 	ret = utime_since_now(&s);
-	free(buf);
 	return ret;
 }
 
-static uint64_t t_sha1(void)
+static uint64_t t_sha1(void *buf, size_t size)
 {
 	uint32_t sha[5];
 	struct fio_sha1_ctx ctx = { .H = sha };
 	struct timeval s;
 	uint64_t ret;
-	void *buf;
 	int i;
 
 	fio_sha1_init(&ctx);
 
-	buf = malloc(CHUNK);
-	randomize_buf(buf, CHUNK, 0x8989);
-
 	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
-		fio_sha1_update(&ctx, buf, CHUNK);
+		fio_sha1_update(&ctx, buf, size);
 
 	ret = utime_since_now(&s);
-	free(buf);
 	return ret;
 }
 
-static uint64_t t_sha256(void)
+static uint64_t t_sha256(void *buf, size_t size)
 {
 	uint8_t sha[64];
 	struct fio_sha256_ctx ctx = { .buf = sha };
 	struct timeval s;
 	uint64_t ret;
-	void *buf;
 	int i;
 
 	fio_sha256_init(&ctx);
 
-	buf = malloc(CHUNK);
-	randomize_buf(buf, CHUNK, 0x8989);
-
 	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
-		fio_sha256_update(&ctx, buf, CHUNK);
+		fio_sha256_update(&ctx, buf, size);
 
 	ret = utime_since_now(&s);
-	free(buf);
 	return ret;
 }
 
-static uint64_t t_sha512(void)
+static uint64_t t_sha512(void *buf, size_t size)
 {
 	uint8_t sha[128];
 	struct fio_sha512_ctx ctx = { .buf = sha };
 	struct timeval s;
 	uint64_t ret;
-	void *buf;
 	int i;
 
 	fio_sha512_init(&ctx);
 
-	buf = malloc(CHUNK);
-	randomize_buf(buf, CHUNK, 0x8989);
-
 	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
-		fio_sha512_update(&ctx, buf, CHUNK);
+		fio_sha512_update(&ctx, buf, size);
 
 	ret = utime_since_now(&s);
-	free(buf);
 	return ret;
 }
 
-static uint64_t t_xxhash(void)
+static uint64_t t_xxhash(void *buf, size_t size)
 {
 	void *state;
 	struct timeval s;
 	uint64_t ret;
-	void *buf;
 	int i;
 
 	state = XXH32_init(0x8989);
 
-	buf = malloc(CHUNK);
-	randomize_buf(buf, CHUNK, 0x8989);
-
 	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
-		XXH32_update(state, buf, CHUNK);
+		XXH32_update(state, buf, size);
 
 	XXH32_digest(state);
 	ret = utime_since_now(&s);
-	free(buf);
 	return ret;
 }
 
@@ -345,14 +285,15 @@ static int list_types(void)
 	for (i = 0; t[i].name; i++)
 		printf("%s\n", t[i].name);
 
-	return 0;
+	return 1;
 }
 
 int fio_crctest(const char *type)
 {
 	unsigned int test_mask = 0;
 	uint64_t mb = CHUNK * NR_CHUNKS;
-	int i;
+	int i, first = 1;
+	void *buf;
 
 	crc32c_intel_probe();
 
@@ -363,6 +304,14 @@ int fio_crctest(const char *type)
 	else
 		test_mask = get_test_mask(type);
 
+	if (!test_mask) {
+		fprintf(stderr, "fio: unknown hash `%s`. Available:\n", type);
+		return list_types();
+	}
+
+	buf = malloc(CHUNK);
+	randomize_buf(buf, CHUNK, 0x8989);
+
 	for (i = 0; t[i].name; i++) {
 		double mb_sec;
 		uint64_t usec;
@@ -370,11 +319,16 @@ int fio_crctest(const char *type)
 		if (!(t[i].mask & test_mask))
 			continue;
 
-		usec = t[i].fn();
+		usec = t[i].fn(buf, CHUNK);
+		if (first)
+			usec = t[i].fn(buf, CHUNK);
+
 		mb_sec = (double) mb / (double) usec;
 		mb_sec /= (1.024 * 1.024);
 		printf("%s:\t%8.2f MB/sec\n", t[i].name, mb_sec);
+		first = 0;
 	}
 
+	free(buf);
 	return 0;
 }
diff --git a/filesetup.c b/filesetup.c
index 39c276a..12a43b1 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -758,7 +758,7 @@ uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
 		return f->real_file_size;
 
 	return td->o.start_offset +
-		(td->thread_number - 1) * td->o.offset_increment;
+		td->subjob_number * td->o.offset_increment;
 }
 
 /*
diff --git a/fio.1 b/fio.1
index 22d6b1e..5291126 100644
--- a/fio.1
+++ b/fio.1
@@ -657,10 +657,11 @@ Offset in the file to start I/O. Data before the offset will not be touched.
 .TP
 .BI offset_increment \fR=\fPint
 If this is provided, then the real offset becomes the
-offset + offset_increment * thread_number, where the thread number is a counter
-that starts at 0 and is incremented for each job. This option is useful if
-there are several jobs which are intended to operate on a file in parallel in
-disjoint segments, with even spacing between the starting points.
+offset + offset_increment * thread_number, where the thread number is a
+counter that starts at 0 and is incremented for each sub-job (i.e. when
+numjobs option is specified). This option is useful if there are several jobs
+which are intended to operate on a file in parallel disjoint segments, with
+even spacing between the starting points.
 .TP
 .BI number_ios \fR=\fPint
 Fio will normally perform IOs until it has exhausted the size of the region
diff --git a/fio.h b/fio.h
index c694f2c..dfbad6d 100644
--- a/fio.h
+++ b/fio.h
@@ -102,6 +102,7 @@ struct thread_data {
 	char verror[FIO_VERROR_SIZE];
 	pthread_t thread;
 	unsigned int thread_number;
+	unsigned int subjob_number;
 	unsigned int groupid;
 	struct thread_stat ts;
 
diff --git a/init.c b/init.c
index b4a0cbb..62c7dc2 100644
--- a/init.c
+++ b/init.c
@@ -380,6 +380,7 @@ static struct thread_data *get_new_job(int global, struct thread_data *parent,
 	profile_add_hooks(td);
 
 	td->thread_number = thread_number;
+	td->subjob_number = 0;
 
 	if (jobname)
 		td->o.name = strdup(jobname);
@@ -1288,6 +1289,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		td_new->o.numjobs = 1;
 		td_new->o.stonewall = 0;
 		td_new->o.new_group = 0;
+		td_new->subjob_number = numjobs;
 
 		if (file_alloced) {
 			if (td_new->files) {
diff --git a/stat.c b/stat.c
index d836581..89d7194 100644
--- a/stat.c
+++ b/stat.c
@@ -1169,7 +1169,7 @@ void init_thread_stat(struct thread_stat *ts)
 	ts->groupid = -1;
 }
 
-static void __show_run_stats(void)
+void __show_run_stats(void)
 {
 	struct group_run_stats *runstats, *rs;
 	struct thread_data *td;
diff --git a/stat.h b/stat.h
index 2e46175..90a7fb3 100644
--- a/stat.h
+++ b/stat.h
@@ -218,6 +218,7 @@ extern void show_group_stats(struct group_run_stats *rs);
 extern int calc_thread_status(struct jobs_eta *je, int force);
 extern void display_thread_status(struct jobs_eta *je);
 extern void show_run_stats(void);
+extern void __show_run_stats(void);
 extern void show_running_run_stats(void);
 extern void check_for_running_stats(void);
 extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, int nr);
diff --git a/t/jobs/t0009-f8b0bd10.fio b/t/jobs/t0009-f8b0bd10.fio
new file mode 100644
index 0000000..90e07ad
--- /dev/null
+++ b/t/jobs/t0009-f8b0bd10.fio
@@ -0,0 +1,40 @@
+# Expected result: fio verifies and runs for 1m
+# Buggy result: fio crashes with:
+# __get_io_u: Assertion `io_u->flags & IO_U_F_FREE' failed
+
+[global]
+direct=1
+ioengine=null
+size=20g
+norandommap
+randrepeat=0
+bs=4096
+iodepth=170
+#iodepth=96
+#numjobs=1
+numjobs=1
+#numjobs=24
+# number_ios=1
+# runtime=216000
+runtime=3600
+time_based=1
+group_reporting=1
+thread
+gtod_reduce=1
+iodepth_batch=4
+iodepth_batch_complete=4
+cpus_allowed=0-5
+cpus_allowed_policy=split
+rw=randwrite
+verify=crc32c-intel
+verify_backlog=1m
+do_verify=1
+verify_async=6
+verify_async_cpus=0-5
+runtime=1m
+
+[4_KiB_RR_drive_r]
+
+[4_KiB_RR_drive_s]
+
+
