Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52956 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgADNAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 4 Jan 2020 08:00:03 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1inj2B-0004PM-Gm
        for fio@vger.kernel.org; Sat, 04 Jan 2020 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200104130002.4E6511BC015B@kernel.dk>
Date: Sat,  4 Jan 2020 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit aae515f4e1cb0b3c003e127200d344d807032a79:

  io_uring: Enable io_uring ioengine on aarch64 arch (2019-12-25 08:02:57 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 235b09b68d9bbc5150891faca47f5397d7e806bb:

  Merge branch 'master' of https://github.com/bvanassche/fio (2020-01-03 21:00:17 -0700)

----------------------------------------------------------------
Bart Van Assche (9):
      Micro-optimize __load_ioengine()
      Suppress a Coverity taint warning in check_status_file()
      Makefile: Build more test code
      Use CLOCK_MONOTONIC for condition variables used by pthread_cond_timedwait()
      t/read-to-pipe-async: Use the monotonic clock when measuring time intervals
      Fix a potential deadlock in helper_do_stat()
      .appveyor.yml: Convert to ASCII
      Only build t/read-to-pipe-async if pread() is available
      Improve the pthread_condattr_setclock() test

Jens Axboe (5):
      Merge branch 'unit1' of https://github.com/kusumi/fio
      Merge branch 'master' of https://github.com/bvanassche/fio
      Revert "Fix a potential deadlock in helper_do_stat()"
      Merge branch 'master' of https://github.com/kenbarr1/fio
      Merge branch 'master' of https://github.com/bvanassche/fio

Ken Barr (1):
      io_u: fix rate limiting to handle file wrap-around

Tomohiro Kusumi (2):
      unittests: add unittest suite for oslib/strcasestr.c
      unittests: add unittest suite for oslib/strsep.c

 .appveyor.yml                |   2 +-
 Makefile                     |  11 +++++
 configure                    |  45 ++++++++++++++++++
 fio_sem.c                    |  11 +++--
 helper_thread.c              |  17 ++++---
 idletime.c                   |  16 ++++++-
 io_u.c                       |   2 +-
 ioengines.c                  |  11 ++---
 pshared.c                    |   9 ++++
 stat.c                       |   3 ++
 t/read-to-pipe-async.c       |  68 +++++++++++++++++----------
 unittests/oslib/strcasestr.c |  87 +++++++++++++++++++++++++++++++++++
 unittests/oslib/strsep.c     | 107 +++++++++++++++++++++++++++++++++++++++++++
 unittests/unittest.c         |   2 +
 unittests/unittest.h         |   2 +
 15 files changed, 348 insertions(+), 45 deletions(-)
 create mode 100644 unittests/oslib/strcasestr.c
 create mode 100644 unittests/oslib/strsep.c

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
index f6934096..4fb0a90d 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -14,7 +14,7 @@ environment:
 
 install:
   - '%CYG_ROOT%\setup-x86_64.exe --quiet-mode --no-shortcuts --only-site --site "%CYG_MIRROR%" --packages "mingw64-%PACKAGE_ARCH%-zlib,mingw64-%PACKAGE_ARCH%-CUnit" > NUL'
-  - SET PATH=C:\Python38-x64;%CYG_ROOT%\bin;%PATH% #��NB: Changed env variables persist to later sections
+  - SET PATH=C:\Python38-x64;%CYG_ROOT%\bin;%PATH% # NB: Changed env variables persist to later sections
   - python.exe -m pip install scipy
 
 build_script:
diff --git a/Makefile b/Makefile
index 4a07fab3..dd26afca 100644
--- a/Makefile
+++ b/Makefile
@@ -313,6 +313,13 @@ T_TEST_PROGS += $(T_GEN_RAND_PROGS)
 T_PROGS += $(T_BTRACE_FIO_PROGS)
 T_PROGS += $(T_DEDUPE_PROGS)
 T_PROGS += $(T_VS_PROGS)
+T_TEST_PROGS += $(T_MEMLOCK_PROGS)
+ifdef CONFIG_PREAD
+T_TEST_PROGS += $(T_PIPE_ASYNC_PROGS)
+endif
+ifneq (,$(findstring Linux,$(CONFIG_TARGET_OS)))
+T_TEST_PROGS += $(T_IOU_RING_PROGS)
+endif
 
 PROGS += $(T_PROGS)
 
@@ -322,10 +329,14 @@ UT_OBJS += unittests/lib/memalign.o
 UT_OBJS += unittests/lib/strntol.o
 UT_OBJS += unittests/oslib/strlcat.o
 UT_OBJS += unittests/oslib/strndup.o
+UT_OBJS += unittests/oslib/strcasestr.o
+UT_OBJS += unittests/oslib/strsep.o
 UT_TARGET_OBJS = lib/memalign.o
 UT_TARGET_OBJS += lib/strntol.o
 UT_TARGET_OBJS += oslib/strlcat.o
 UT_TARGET_OBJS += oslib/strndup.o
+UT_TARGET_OBJS += oslib/strcasestr.o
+UT_TARGET_OBJS += oslib/strsep.o
 UT_PROGS = unittests/unittest
 else
 UT_OBJS =
diff --git a/configure b/configure
index a1279693..3a675a46 100755
--- a/configure
+++ b/configure
@@ -704,6 +704,28 @@ if compile_prog "" "$LIBS" "posix_pshared" ; then
 fi
 print_config "POSIX pshared support" "$posix_pshared"
 
+##########################################
+# POSIX pthread_condattr_setclock() probe
+if test "$pthread_condattr_setclock" != "yes" ; then
+  pthread_condattr_setclock="no"
+fi
+cat > $TMPC <<EOF
+#include <pthread.h>
+int main(void)
+{
+  pthread_condattr_t condattr;
+  pthread_condattr_setclock(&condattr, CLOCK_MONOTONIC);
+  return 0;
+}
+EOF
+if compile_prog "" "$LIBS" "pthread_condattr_setclock" ; then
+  pthread_condattr_setclock=yes
+elif compile_prog "" "$LIBS -lpthread" "pthread_condattr_setclock" ; then
+  pthread_condattr_setclock=yes
+  LIBS="$LIBS -lpthread"
+fi
+print_config "pthread_condattr_setclock()" "$pthread_condattr_setclock"
+
 ##########################################
 # solaris aio probe
 if test "$solaris_aio" != "yes" ; then
@@ -1091,6 +1113,23 @@ if compile_prog "" "" "fdatasync"; then
 fi
 print_config "fdatasync" "$fdatasync"
 
+##########################################
+# pread() probe
+if test "$pread" != "yes" ; then
+  pread="no"
+fi
+cat > $TMPC << EOF
+#include <unistd.h>
+int main(int argc, char **argv)
+{
+  return pread(0, NULL, 0, 0);
+}
+EOF
+if compile_prog "" "" "pread"; then
+  pread="yes"
+fi
+print_config "pread()" "$pread"
+
 ##########################################
 # sync_file_range() probe
 if test "$sync_file_range" != "yes" ; then
@@ -2456,6 +2495,9 @@ fi
 if test "$posix_pshared" = "yes" ; then
   output_sym "CONFIG_PSHARED"
 fi
+if test "$pthread_condattr_setclock" = "yes" ; then
+  output_sym "CONFIG_PTHREAD_CONDATTR_SETCLOCK"
+fi
 if test "$have_asprintf" = "yes" ; then
     output_sym "CONFIG_HAVE_ASPRINTF"
 fi
@@ -2471,6 +2513,9 @@ fi
 if test "$fdatasync" = "yes" ; then
   output_sym "CONFIG_FDATASYNC"
 fi
+if test "$pread" = "yes" ; then
+  output_sym "CONFIG_PREAD"
+fi
 if test "$sync_file_range" = "yes" ; then
   output_sym "CONFIG_SYNC_FILE_RANGE"
 fi
diff --git a/fio_sem.c b/fio_sem.c
index 3b48061c..c34d8bf7 100644
--- a/fio_sem.c
+++ b/fio_sem.c
@@ -85,16 +85,19 @@ static bool sem_timed_out(struct timespec *t, unsigned int msecs)
 
 int fio_sem_down_timeout(struct fio_sem *sem, unsigned int msecs)
 {
-	struct timeval tv_s;
 	struct timespec base;
 	struct timespec t;
 	int ret = 0;
 
 	assert(sem->magic == FIO_SEM_MAGIC);
 
-	gettimeofday(&tv_s, NULL);
-	base.tv_sec = t.tv_sec = tv_s.tv_sec;
-	base.tv_nsec = t.tv_nsec = tv_s.tv_usec * 1000;
+#ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
+	clock_gettime(CLOCK_MONOTONIC, &t);
+#else
+	clock_gettime(CLOCK_REALTIME, &t);
+#endif
+
+	base = t;
 
 	t.tv_sec += msecs / 1000;
 	t.tv_nsec += ((msecs * 1000000ULL) % 1000000000);
diff --git a/helper_thread.c b/helper_thread.c
index f0c717f5..eba2898a 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -78,15 +78,16 @@ static void *helper_thread_main(void *data)
 {
 	struct helper_data *hd = data;
 	unsigned int msec_to_next_event, next_log, next_ss = STEADYSTATE_MSEC;
-	struct timeval tv;
 	struct timespec ts, last_du, last_ss;
 	int ret = 0;
 
 	sk_out_assign(hd->sk_out);
 
-	gettimeofday(&tv, NULL);
-	ts.tv_sec = tv.tv_sec;
-	ts.tv_nsec = tv.tv_usec * 1000;
+#ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+#else
+	clock_gettime(CLOCK_REALTIME, &ts);
+#endif
 	memcpy(&last_du, &ts, sizeof(ts));
 	memcpy(&last_ss, &ts, sizeof(ts));
 
@@ -101,9 +102,11 @@ static void *helper_thread_main(void *data)
 		pthread_mutex_lock(&hd->lock);
 		pthread_cond_timedwait(&hd->cond, &hd->lock, &ts);
 
-		gettimeofday(&tv, NULL);
-		ts.tv_sec = tv.tv_sec;
-		ts.tv_nsec = tv.tv_usec * 1000;
+#ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
+		clock_gettime(CLOCK_MONOTONIC, &ts);
+#else
+		clock_gettime(CLOCK_REALTIME, &ts);
+#endif
 
 		if (hd->reset) {
 			memcpy(&last_du, &ts, sizeof(ts));
diff --git a/idletime.c b/idletime.c
index 2f59f510..fc1df8e9 100644
--- a/idletime.c
+++ b/idletime.c
@@ -186,6 +186,7 @@ void fio_idle_prof_init(void)
 	int i, ret;
 	struct timespec ts;
 	pthread_attr_t tattr;
+	pthread_condattr_t cattr;
 	struct idle_prof_thread *ipt;
 
 	ipc.nr_cpus = cpus_online();
@@ -194,6 +195,13 @@ void fio_idle_prof_init(void)
 	if (ipc.opt == IDLE_PROF_OPT_NONE)
 		return;
 
+	ret = pthread_condattr_init(&cattr);
+	assert(ret == 0);
+#ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
+	ret = pthread_condattr_setclock(&cattr, CLOCK_MONOTONIC);
+	assert(ret == 0);
+#endif
+
 	if ((ret = pthread_attr_init(&tattr))) {
 		log_err("fio: pthread_attr_init %s\n", strerror(ret));
 		return;
@@ -239,7 +247,7 @@ void fio_idle_prof_init(void)
 			break;
 		}
 
-		if ((ret = pthread_cond_init(&ipt->cond, NULL))) {
+		if ((ret = pthread_cond_init(&ipt->cond, &cattr))) {
 			ipc.status = IDLE_PROF_STATUS_ABORT;
 			log_err("fio: pthread_cond_init %s\n", strerror(ret));
 			break;
@@ -282,7 +290,11 @@ void fio_idle_prof_init(void)
 		pthread_mutex_lock(&ipt->init_lock);
 		while ((ipt->state != TD_EXITED) &&
 		       (ipt->state!=TD_INITIALIZED)) {
-			fio_gettime(&ts, NULL);
+#ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
+			clock_gettime(CLOCK_MONOTONIC, &ts);
+#else
+			clock_gettime(CLOCK_REALTIME, &ts);
+#endif
 			ts.tv_sec += 1;
 			pthread_cond_timedwait(&ipt->cond, &ipt->init_lock, &ts);
 		}
diff --git a/io_u.c b/io_u.c
index b5c31335..4a0c725a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -644,7 +644,7 @@ static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
 	uint64_t now;
 
 	assert(ddir_rw(ddir));
-	now = utime_since_now(&td->start);
+	now = utime_since_now(&td->epoch);
 
 	/*
 	 * if rate_next_io_time is in the past, need to catch up to rate
diff --git a/ioengines.c b/ioengines.c
index 9e3fcc9f..b9200ba9 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -121,18 +121,15 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 	return ops;
 }
 
-static struct ioengine_ops *__load_ioengine(const char *name)
+static struct ioengine_ops *__load_ioengine(const char *engine)
 {
-	char engine[64];
-
-	snprintf(engine, sizeof(engine), "%s", name);
-
 	/*
 	 * linux libaio has alias names, so convert to what we want
 	 */
 	if (!strncmp(engine, "linuxaio", 8)) {
-		dprint(FD_IO, "converting ioengine name: %s -> libaio\n", name);
-		strcpy(engine, "libaio");
+		dprint(FD_IO, "converting ioengine name: %s -> libaio\n",
+		       engine);
+		engine = "libaio";
 	}
 
 	dprint(FD_IO, "load ioengine %s\n", engine);
diff --git a/pshared.c b/pshared.c
index 74812ede..21192556 100644
--- a/pshared.c
+++ b/pshared.c
@@ -21,6 +21,15 @@ int cond_init_pshared(pthread_cond_t *cond)
 		return ret;
 	}
 #endif
+
+#ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
+	ret = pthread_condattr_setclock(&cattr, CLOCK_MONOTONIC);
+	if (ret) {
+		log_err("pthread_condattr_setclock: %s\n", strerror(ret));
+		return ret;
+	}
+#endif
+
 	ret = pthread_cond_init(cond, &cattr);
 	if (ret) {
 		log_err("pthread_cond_init: %s\n", strerror(ret));
diff --git a/stat.c b/stat.c
index 05663e07..e2bc8ddb 100644
--- a/stat.c
+++ b/stat.c
@@ -2123,6 +2123,9 @@ static int check_status_file(void)
 	}
 	if (temp_dir == NULL)
 		temp_dir = "/tmp";
+#ifdef __COVERITY__
+	__coverity_tainted_data_sanitize__(temp_dir);
+#endif
 
 	snprintf(fio_status_file_path, sizeof(fio_status_file_path), "%s/%s", temp_dir, FIO_STATUS_FILE);
 
diff --git a/t/read-to-pipe-async.c b/t/read-to-pipe-async.c
index ebdd8f10..69799336 100644
--- a/t/read-to-pipe-async.c
+++ b/t/read-to-pipe-async.c
@@ -20,6 +20,7 @@
  * Copyright (C) 2016 Jens Axboe
  *
  */
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -100,13 +101,13 @@ struct work_item {
 static struct reader_thread reader_thread;
 static struct writer_thread writer_thread;
 
-uint64_t utime_since(const struct timeval *s, const struct timeval *e)
+uint64_t utime_since(const struct timespec *s, const struct timespec *e)
 {
 	long sec, usec;
 	uint64_t ret;
 
 	sec = e->tv_sec - s->tv_sec;
-	usec = e->tv_usec - s->tv_usec;
+	usec = (e->tv_nsec - s->tv_nsec) / 1000;
 	if (sec > 0 && usec < 0) {
 		sec--;
 		usec += 1000000;
@@ -218,12 +219,12 @@ static void add_lat(struct stats *s, unsigned int us, const char *name)
 
 static int write_work(struct work_item *work)
 {
-	struct timeval s, e;
+	struct timespec s, e;
 	ssize_t ret;
 
-	gettimeofday(&s, NULL);
+	clock_gettime(CLOCK_MONOTONIC, &s);
 	ret = write(STDOUT_FILENO, work->buf, work->buf_size);
-	gettimeofday(&e, NULL);
+	clock_gettime(CLOCK_MONOTONIC, &e);
 	assert(ret == work->buf_size);
 
 	add_lat(&work->writer->s, utime_since(&s, &e), "write");
@@ -269,13 +270,13 @@ static void *writer_fn(void *data)
 
 static void reader_work(struct work_item *work)
 {
-	struct timeval s, e;
+	struct timespec s, e;
 	ssize_t ret;
 	size_t left;
 	void *buf;
 	off_t off;
 
-	gettimeofday(&s, NULL);
+	clock_gettime(CLOCK_MONOTONIC, &s);
 
 	left = work->buf_size;
 	buf = work->buf;
@@ -294,7 +295,7 @@ static void reader_work(struct work_item *work)
 		buf += ret;
 	}
 
-	gettimeofday(&e, NULL);
+	clock_gettime(CLOCK_MONOTONIC, &e);
 
 	add_lat(&work->reader->s, utime_since(&s, &e), "read");
 
@@ -461,8 +462,17 @@ static void show_latencies(struct stats *s, const char *msg)
 
 static void init_thread(struct thread_data *thread)
 {
-	pthread_cond_init(&thread->cond, NULL);
-	pthread_cond_init(&thread->done_cond, NULL);
+	pthread_condattr_t cattr;
+	int ret;
+
+	ret = pthread_condattr_init(&cattr);
+	assert(ret == 0);
+#ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
+	ret = pthread_condattr_setclock(&cattr, CLOCK_MONOTONIC);
+	assert(ret == 0);
+#endif
+	pthread_cond_init(&thread->cond, &cattr);
+	pthread_cond_init(&thread->done_cond, &cattr);
 	pthread_mutex_init(&thread->lock, NULL);
 	pthread_mutex_init(&thread->done_lock, NULL);
 	thread->exit = 0;
@@ -479,12 +489,14 @@ static void exit_thread(struct thread_data *thread,
 		pthread_mutex_lock(&thread->done_lock);
 
 		if (fn) {
-			struct timeval tv;
 			struct timespec ts;
 
-			gettimeofday(&tv, NULL);
-			ts.tv_sec = tv.tv_sec + 1;
-			ts.tv_nsec = tv.tv_usec * 1000ULL;
+#ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
+			clock_gettime(CLOCK_MONOTONIC, &ts);
+#else
+			clock_gettime(CLOCK_REALTIME, &ts);
+#endif
+			ts.tv_sec++;
 
 			pthread_cond_timedwait(&thread->done_cond, &thread->done_lock, &ts);
 			fn(wt);
@@ -562,7 +574,8 @@ static void prune_done_entries(struct writer_thread *wt)
 
 int main(int argc, char *argv[])
 {
-	struct timeval s, re, we;
+	pthread_condattr_t cattr;
+	struct timespec s, re, we;
 	struct reader_thread *rt;
 	struct writer_thread *wt;
 	unsigned long rate;
@@ -570,6 +583,7 @@ int main(int argc, char *argv[])
 	size_t bytes;
 	off_t off;
 	int fd, seq;
+	int ret;
 
 	if (parse_options(argc, argv))
 		return 1;
@@ -605,13 +619,19 @@ int main(int argc, char *argv[])
 	seq = 0;
 	bytes = 0;
 
-	gettimeofday(&s, NULL);
+	ret = pthread_condattr_init(&cattr);
+	assert(ret == 0);
+#ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
+	ret = pthread_condattr_setclock(&cattr, CLOCK_MONOTONIC);
+	assert(ret == 0);
+#endif
+
+	clock_gettime(CLOCK_MONOTONIC, &s);
 
 	while (sb.st_size) {
 		struct work_item *work;
 		size_t this_len;
 		struct timespec ts;
-		struct timeval tv;
 
 		prune_done_entries(wt);
 
@@ -627,14 +647,16 @@ int main(int argc, char *argv[])
 		work->seq = ++seq;
 		work->writer = wt;
 		work->reader = rt;
-		pthread_cond_init(&work->cond, NULL);
+		pthread_cond_init(&work->cond, &cattr);
 		pthread_mutex_init(&work->lock, NULL);
 
 		queue_work(rt, work);
 
-		gettimeofday(&tv, NULL);
-		ts.tv_sec = tv.tv_sec;
-		ts.tv_nsec = tv.tv_usec * 1000ULL;
+#ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
+		clock_gettime(CLOCK_MONOTONIC, &ts);
+#else
+		clock_gettime(CLOCK_REALTIME, &ts);
+#endif
 		ts.tv_nsec += max_us * 1000ULL;
 		if (ts.tv_nsec >= 1000000000ULL) {
 			ts.tv_nsec -= 1000000000ULL;
@@ -651,10 +673,10 @@ int main(int argc, char *argv[])
 	}
 
 	exit_thread(&rt->thread, NULL, NULL);
-	gettimeofday(&re, NULL);
+	clock_gettime(CLOCK_MONOTONIC, &re);
 
 	exit_thread(&wt->thread, prune_done_entries, wt);
-	gettimeofday(&we, NULL);
+	clock_gettime(CLOCK_MONOTONIC, &we);
 
 	show_latencies(&rt->s, "READERS");
 	show_latencies(&wt->s, "WRITERS");
diff --git a/unittests/oslib/strcasestr.c b/unittests/oslib/strcasestr.c
new file mode 100644
index 00000000..19a2de37
--- /dev/null
+++ b/unittests/oslib/strcasestr.c
@@ -0,0 +1,87 @@
+/*
+ * Copyright (C) 2019 Tomohiro Kusumi <tkusumi@netbsd.org>
+ */
+#include "../unittest.h"
+
+#ifndef CONFIG_STRCASESTR
+#include "../../oslib/strcasestr.h"
+#else
+#include <string.h>
+#endif
+
+static void test_strcasestr_1(void)
+{
+	const char *haystack = "0123456789";
+	const char *p;
+
+	p = strcasestr(haystack, "012");
+	CU_ASSERT_EQUAL(p, haystack);
+
+	p = strcasestr(haystack, "12345");
+	CU_ASSERT_EQUAL(p, haystack + 1);
+
+	p = strcasestr(haystack, "1234567890");
+	CU_ASSERT_EQUAL(p, NULL);
+
+	p = strcasestr(haystack, "");
+	CU_ASSERT_EQUAL(p, haystack); /* is this expected ? */
+}
+
+static void test_strcasestr_2(void)
+{
+	const char *haystack = "ABCDEFG";
+	const char *p;
+
+	p = strcasestr(haystack, "ABC");
+	CU_ASSERT_EQUAL(p, haystack);
+
+	p = strcasestr(haystack, "BCD");
+	CU_ASSERT_EQUAL(p, haystack + 1);
+
+	p = strcasestr(haystack, "ABCDEFGH");
+	CU_ASSERT_EQUAL(p, NULL);
+
+	p = strcasestr(haystack, "");
+	CU_ASSERT_EQUAL(p, haystack); /* is this expected ? */
+}
+
+static void test_strcasestr_3(void)
+{
+	const char *haystack = "ABCDEFG";
+	const char *p;
+
+	p = strcasestr(haystack, "AbC");
+	CU_ASSERT_EQUAL(p, haystack);
+
+	p = strcasestr(haystack, "bCd");
+	CU_ASSERT_EQUAL(p, haystack + 1);
+
+	p = strcasestr(haystack, "AbcdEFGH");
+	CU_ASSERT_EQUAL(p, NULL);
+
+	p = strcasestr(haystack, "");
+	CU_ASSERT_EQUAL(p, haystack); /* is this expected ? */
+}
+
+static struct fio_unittest_entry tests[] = {
+	{
+		.name	= "strcasestr/1",
+		.fn	= test_strcasestr_1,
+	},
+	{
+		.name	= "strcasestr/2",
+		.fn	= test_strcasestr_2,
+	},
+	{
+		.name	= "strcasestr/3",
+		.fn	= test_strcasestr_3,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+CU_ErrorCode fio_unittest_oslib_strcasestr(void)
+{
+	return fio_unittest_add_suite("oslib/strcasestr.c", NULL, NULL, tests);
+}
diff --git a/unittests/oslib/strsep.c b/unittests/oslib/strsep.c
new file mode 100644
index 00000000..7f645f40
--- /dev/null
+++ b/unittests/oslib/strsep.c
@@ -0,0 +1,107 @@
+/*
+ * Copyright (C) 2019 Tomohiro Kusumi <tkusumi@netbsd.org>
+ */
+#include "../unittest.h"
+
+#ifndef CONFIG_STRSEP
+#include "../../oslib/strsep.h"
+#else
+#include <string.h>
+#endif
+
+/*
+ * strsep(3) - "If *stringp is NULL, the strsep() function returns NULL and does
+ * nothing else."
+ */
+static void test_strsep_1(void)
+{
+	char *string = NULL;
+	const char *p;
+
+	p = strsep(&string, "");
+	CU_ASSERT_EQUAL(p, NULL);
+	CU_ASSERT_EQUAL(string, NULL);
+
+	p = strsep(&string, "ABC");
+	CU_ASSERT_EQUAL(p, NULL);
+	CU_ASSERT_EQUAL(string, NULL);
+}
+
+/*
+ * strsep(3) - "In case no delimiter was found, the token is taken to be the
+ * entire string *stringp, and *stringp is made NULL."
+ */
+static void test_strsep_2(void)
+{
+	char src[] = "ABCDEFG";
+	char *string = src;
+	const char *p;
+
+	p = strsep(&string, "");
+	CU_ASSERT_EQUAL(p, src);
+	CU_ASSERT_EQUAL(*p, 'A');
+	CU_ASSERT_EQUAL(string, NULL);
+
+	string = src;
+	p = strsep(&string, "@");
+	CU_ASSERT_EQUAL(p, src);
+	CU_ASSERT_EQUAL(*p, 'A');
+	CU_ASSERT_EQUAL(string, NULL);
+}
+
+/*
+ * strsep(3) - "This token is terminated with a '\0' character (by overwriting
+ * the delimiter) and *stringp is updated to point past the token."
+ */
+static void test_strsep_3(void)
+{
+	char src[] = "ABCDEFG";
+	char *string = src;
+	const char *p;
+
+	p = strsep(&string, "ABC");
+	CU_ASSERT_EQUAL(p, &src[0]);
+	CU_ASSERT_EQUAL(*p, '\0');
+	CU_ASSERT_EQUAL(strcmp(string, "BCDEFG"), 0);
+	CU_ASSERT_EQUAL(*string, 'B');
+
+	p = strsep(&string, "ABC");
+	CU_ASSERT_EQUAL(p, &src[1]);
+	CU_ASSERT_EQUAL(*p, '\0');
+	CU_ASSERT_EQUAL(strcmp(string, "CDEFG"), 0);
+	CU_ASSERT_EQUAL(*string, 'C');
+
+	p = strsep(&string, "ABC");
+	CU_ASSERT_EQUAL(p, &src[2]);
+	CU_ASSERT_EQUAL(*p, '\0');
+	CU_ASSERT_EQUAL(strcmp(string, "DEFG"), 0);
+	CU_ASSERT_EQUAL(*string, 'D');
+
+	p = strsep(&string, "ABC");
+	CU_ASSERT_EQUAL(p, &src[3]);
+	CU_ASSERT_EQUAL(*p, 'D');
+	CU_ASSERT_EQUAL(string, NULL);
+}
+
+static struct fio_unittest_entry tests[] = {
+	{
+		.name	= "strsep/1",
+		.fn	= test_strsep_1,
+	},
+	{
+		.name	= "strsep/2",
+		.fn	= test_strsep_2,
+	},
+	{
+		.name	= "strsep/3",
+		.fn	= test_strsep_3,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+CU_ErrorCode fio_unittest_oslib_strsep(void)
+{
+	return fio_unittest_add_suite("oslib/strsep.c", NULL, NULL, tests);
+}
diff --git a/unittests/unittest.c b/unittests/unittest.c
index 1166e6ef..66789e4f 100644
--- a/unittests/unittest.c
+++ b/unittests/unittest.c
@@ -62,6 +62,8 @@ int main(void)
 	fio_unittest_register(fio_unittest_lib_strntol);
 	fio_unittest_register(fio_unittest_oslib_strlcat);
 	fio_unittest_register(fio_unittest_oslib_strndup);
+	fio_unittest_register(fio_unittest_oslib_strcasestr);
+	fio_unittest_register(fio_unittest_oslib_strsep);
 
 	CU_basic_set_mode(CU_BRM_VERBOSE);
 	CU_basic_run_tests();
diff --git a/unittests/unittest.h b/unittests/unittest.h
index d3e3822f..bbc49613 100644
--- a/unittests/unittest.h
+++ b/unittests/unittest.h
@@ -22,5 +22,7 @@ CU_ErrorCode fio_unittest_lib_memalign(void);
 CU_ErrorCode fio_unittest_lib_strntol(void);
 CU_ErrorCode fio_unittest_oslib_strlcat(void);
 CU_ErrorCode fio_unittest_oslib_strndup(void);
+CU_ErrorCode fio_unittest_oslib_strcasestr(void);
+CU_ErrorCode fio_unittest_oslib_strsep(void);
 
 #endif

