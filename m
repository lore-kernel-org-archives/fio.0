Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B52ECDFA1
	for <fio@archiver.kernel.org>; Tue, 25 Oct 2022 12:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJYMAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 25 Oct 2022 08:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiJYMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Oct 2022 08:00:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE683ED74
        for <fio@vger.kernel.org>; Tue, 25 Oct 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=nKZdJisYCCCfy3tMeDfHxWMpscGqQun+3zrezVgV9AI=; b=v87KB8DUXtBeCQ/uc9IQyjZN4r
        nFgkgq9wCbhZb/0VYHyuoMRJiauxQD8kjix7/WbSrTiOuMxA7Olc7/KoQl8/4IfMgCRmdPXT/B45L
        5MWckE5dmjFZ7G1Im/a+RaYlE+pqA2ShNeqSWDyZXu/cBcnxz3XFPl9TxhYZ6NipLluG52F4sClU3
        kN1v6vuMa8Uky7cYWDNAYiGfMk3Br5LBvlAwXdeVDA2ilqHZMykSWYdPCHbR8n3Ha3JU2ZBd/GH53
        bHF6cZsKO1ztOTFAHH6vCnBZKJ1UnIpquTjZd2XyTJwfuFIUfzDD8+4rZKSk/ZMju2Jt05/FGsD4X
        GQEE/OIA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1onIbJ-00GEvZ-OJ
        for fio@vger.kernel.org; Tue, 25 Oct 2022 12:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 0A8D51BC0145; Tue, 25 Oct 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221025120002.0A8D51BC0145@kernel.dk>
Date:   Tue, 25 Oct 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit d72244761b2230fbb2d6eaec59cdedd3ea651d4f:

  stat: fix segfault with fio option --bandwidth-log (2022-10-21 13:23:41 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c4704c081a54160621227b42238f6e439c28fba3:

  test: add test for experimental verify with loops and time_based options (2022-10-24 10:34:57 -0400)

----------------------------------------------------------------
Shin'ichiro Kawasaki (4):
      verify: fix bytes_done accounting of experimental verify
      verify: fix numberio accounting of experimental verify
      test: add test for verify read back of experimental verify
      test: add test for experimental verify with loops and time_based options

Vincent Fu (1):
      Merge branch 'fix-cpus_allowed' of https://github.com/roxma/fio

mayuanpeng (1):
      cpus_allowed: use __NRPROCESSORS_CONF instead of __SC_NPROCESSORS_ONLN for non-sequential CPU ids

 backend.c                 |  8 ++++++--
 fio.h                     |  2 ++
 gettime.c                 |  2 +-
 idletime.c                |  2 +-
 io_u.c                    | 23 +++++++++++++++++------
 libfio.c                  |  1 +
 options.c                 |  8 ++++----
 os/os-hpux.h              |  4 ++--
 os/os-linux.h             |  8 --------
 os/os-solaris.h           |  2 +-
 os/os-windows.h           |  5 +----
 os/os.h                   |  8 ++++----
 os/windows/cpu-affinity.c |  6 ------
 os/windows/posix.c        | 16 ++++++++++++----
 rate-submit.c             |  2 ++
 server.c                  |  2 +-
 t/dedupe.c                |  2 +-
 t/jobs/t0025.fio          |  7 +++++++
 t/jobs/t0026.fio          | 19 +++++++++++++++++++
 t/run-fio-tests.py        | 31 +++++++++++++++++++++++++++++++
 verify.c                  |  2 --
 21 files changed, 113 insertions(+), 47 deletions(-)
 create mode 100644 t/jobs/t0025.fio
 create mode 100644 t/jobs/t0026.fio

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index d8f4f2a5..ba954a6b 100644
--- a/backend.c
+++ b/backend.c
@@ -682,7 +682,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 				break;
 			}
 		} else {
-			if (ddir_rw_sum(td->bytes_done) + td->o.rw_min_bs > verify_bytes)
+			if (td->bytes_verified + td->o.rw_min_bs > verify_bytes)
 				break;
 
 			while ((io_u = get_io_u(td)) != NULL) {
@@ -711,6 +711,8 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 					break;
 				} else if (io_u->ddir == DDIR_WRITE) {
 					io_u->ddir = DDIR_READ;
+					io_u->numberio = td->verify_read_issues;
+					td->verify_read_issues++;
 					populate_verify_io_u(td, io_u);
 					break;
 				} else {
@@ -1030,8 +1032,10 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 			break;
 		}
 
-		if (io_u->ddir == DDIR_WRITE && td->flags & TD_F_DO_VERIFY)
+		if (io_u->ddir == DDIR_WRITE && td->flags & TD_F_DO_VERIFY) {
+			io_u->numberio = td->io_issues[io_u->ddir];
 			populate_verify_io_u(td, io_u);
+		}
 
 		ddir = io_u->ddir;
 
diff --git a/fio.h b/fio.h
index de7eca79..8da77640 100644
--- a/fio.h
+++ b/fio.h
@@ -356,6 +356,7 @@ struct thread_data {
 	 * Issue side
 	 */
 	uint64_t io_issues[DDIR_RWDIR_CNT];
+	uint64_t verify_read_issues;
 	uint64_t io_issue_bytes[DDIR_RWDIR_CNT];
 	uint64_t loops;
 
@@ -370,6 +371,7 @@ struct thread_data {
 	uint64_t zone_bytes;
 	struct fio_sem *sem;
 	uint64_t bytes_done[DDIR_RWDIR_CNT];
+	uint64_t bytes_verified;
 
 	uint64_t *thinktime_blocks_counter;
 	struct timespec last_thinktime;
diff --git a/gettime.c b/gettime.c
index 8993be16..bc66a3ac 100644
--- a/gettime.c
+++ b/gettime.c
@@ -671,7 +671,7 @@ static int clock_cmp(const void *p1, const void *p2)
 int fio_monotonic_clocktest(int debug)
 {
 	struct clock_thread *cthreads;
-	unsigned int seen_cpus, nr_cpus = cpus_online();
+	unsigned int seen_cpus, nr_cpus = cpus_configured();
 	struct clock_entry *entries;
 	unsigned long nr_entries, tentries, failed = 0;
 	struct clock_entry *prev, *this;
diff --git a/idletime.c b/idletime.c
index fc1df8e9..90ed77ea 100644
--- a/idletime.c
+++ b/idletime.c
@@ -189,7 +189,7 @@ void fio_idle_prof_init(void)
 	pthread_condattr_t cattr;
 	struct idle_prof_thread *ipt;
 
-	ipc.nr_cpus = cpus_online();
+	ipc.nr_cpus = cpus_configured();
 	ipc.status = IDLE_PROF_STATUS_OK;
 
 	if (ipc.opt == IDLE_PROF_OPT_NONE)
diff --git a/io_u.c b/io_u.c
index 91f1a358..8035f4b7 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2121,13 +2121,26 @@ static void ios_completed(struct thread_data *td,
 	}
 }
 
+static void io_u_update_bytes_done(struct thread_data *td,
+				   struct io_completion_data *icd)
+{
+	int ddir;
+
+	if (td->runstate == TD_VERIFYING) {
+		td->bytes_verified += icd->bytes_done[DDIR_READ];
+		return;
+	}
+
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
+		td->bytes_done[ddir] += icd->bytes_done[ddir];
+}
+
 /*
  * Complete a single io_u for the sync engines.
  */
 int io_u_sync_complete(struct thread_data *td, struct io_u *io_u)
 {
 	struct io_completion_data icd;
-	int ddir;
 
 	init_icd(td, &icd, 1);
 	io_completed(td, &io_u, &icd);
@@ -2140,8 +2153,7 @@ int io_u_sync_complete(struct thread_data *td, struct io_u *io_u)
 		return -1;
 	}
 
-	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
-		td->bytes_done[ddir] += icd.bytes_done[ddir];
+	io_u_update_bytes_done(td, &icd);
 
 	return 0;
 }
@@ -2153,7 +2165,7 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
 {
 	struct io_completion_data icd;
 	struct timespec *tvp = NULL;
-	int ret, ddir;
+	int ret;
 	struct timespec ts = { .tv_sec = 0, .tv_nsec = 0, };
 
 	dprint(FD_IO, "io_u_queued_complete: min=%d\n", min_evts);
@@ -2179,8 +2191,7 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
 		return -1;
 	}
 
-	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
-		td->bytes_done[ddir] += icd.bytes_done[ddir];
+	io_u_update_bytes_done(td, &icd);
 
 	return ret;
 }
diff --git a/libfio.c b/libfio.c
index 1a891776..ac521974 100644
--- a/libfio.c
+++ b/libfio.c
@@ -94,6 +94,7 @@ static void reset_io_counters(struct thread_data *td, int all)
 			td->rate_next_io_time[ddir] = 0;
 			td->last_usec[ddir] = 0;
 		}
+		td->bytes_verified = 0;
 	}
 
 	td->zone_bytes = 0;
diff --git a/options.c b/options.c
index a668b0e4..9e4d8cd1 100644
--- a/options.c
+++ b/options.c
@@ -627,7 +627,7 @@ static int str_exitall_cb(void)
 int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu_index)
 {
 	unsigned int i, index, cpus_in_mask;
-	const long max_cpu = cpus_online();
+	const long max_cpu = cpus_configured();
 
 	cpus_in_mask = fio_cpu_count(mask);
 	if (!cpus_in_mask)
@@ -666,7 +666,7 @@ static int str_cpumask_cb(void *data, unsigned long long *val)
 		return 1;
 	}
 
-	max_cpu = cpus_online();
+	max_cpu = cpus_configured();
 
 	for (i = 0; i < sizeof(int) * 8; i++) {
 		if ((1 << i) & *val) {
@@ -702,7 +702,7 @@ static int set_cpus_allowed(struct thread_data *td, os_cpu_mask_t *mask,
 	strip_blank_front(&str);
 	strip_blank_end(str);
 
-	max_cpu = cpus_online();
+	max_cpu = cpus_configured();
 
 	while ((cpu = strsep(&str, ",")) != NULL) {
 		char *str2, *cpu2;
@@ -5305,7 +5305,7 @@ void fio_keywords_init(void)
 	sprintf(buf, "%llu", mb_memory);
 	fio_keywords[1].replace = strdup(buf);
 
-	l = cpus_online();
+	l = cpus_configured();
 	sprintf(buf, "%lu", l);
 	fio_keywords[2].replace = strdup(buf);
 }
diff --git a/os/os-hpux.h b/os/os-hpux.h
index a80cb2bc..9f3d76f5 100644
--- a/os/os-hpux.h
+++ b/os/os-hpux.h
@@ -88,9 +88,9 @@ static inline unsigned long long os_phys_mem(void)
 	return ret;
 }
 
-#define FIO_HAVE_CPU_ONLINE_SYSCONF
+#define FIO_HAVE_CPU_CONF_SYSCONF
 
-static inline unsigned int cpus_online(void)
+static inline unsigned int cpus_configured(void)
 {
 	return mpctl(MPC_GETNUMSPUS, 0, NULL);
 }
diff --git a/os/os-linux.h b/os/os-linux.h
index 831f0ad0..bbb1f27c 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -251,14 +251,6 @@ static inline int arch_cache_line_size(void)
 		return atoi(size);
 }
 
-#ifdef __powerpc64__
-#define FIO_HAVE_CPU_ONLINE_SYSCONF
-static inline unsigned int cpus_online(void)
-{
-        return sysconf(_SC_NPROCESSORS_CONF);
-}
-#endif
-
 static inline unsigned long long get_fs_free_size(const char *path)
 {
 	unsigned long long ret;
diff --git a/os/os-solaris.h b/os/os-solaris.h
index ea1f081c..60d4c1ec 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -119,7 +119,7 @@ static inline int fio_set_odirect(struct fio_file *f)
 
 static inline bool fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
 {
-	const unsigned int max_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	const unsigned int max_cpus = sysconf(_SC_NPROCESSORS_CONF);
 	unsigned int num_cpus;
 	processorid_t *cpus;
 	bool ret;
diff --git a/os/os-windows.h b/os/os-windows.h
index 510b8143..12f33486 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -44,7 +44,7 @@
 #define fio_swap64(x)	_byteswap_uint64(x)
 
 #define _SC_PAGESIZE			0x1
-#define _SC_NPROCESSORS_ONLN	0x2
+#define _SC_NPROCESSORS_CONF	0x2
 #define _SC_PHYS_PAGES			0x4
 
 #define SA_RESTART	0
@@ -219,9 +219,6 @@ static inline int fio_mkdir(const char *path, mode_t mode) {
 	return 0;
 }
 
-#define FIO_HAVE_CPU_ONLINE_SYSCONF
-unsigned int cpus_online(void);
-
 int first_set_cpu(os_cpu_mask_t *cpumask);
 int fio_setaffinity(int pid, os_cpu_mask_t cpumask);
 int fio_cpuset_init(os_cpu_mask_t *mask);
diff --git a/os/os.h b/os/os.h
index aba6813f..a6fde1fd 100644
--- a/os/os.h
+++ b/os/os.h
@@ -352,10 +352,10 @@ static inline unsigned long long get_fs_free_size(const char *path)
 }
 #endif
 
-#ifndef FIO_HAVE_CPU_ONLINE_SYSCONF
-static inline unsigned int cpus_online(void)
+#ifndef FIO_HAVE_CPU_CONF_SYSCONF
+static inline unsigned int cpus_configured(void)
 {
-	return sysconf(_SC_NPROCESSORS_ONLN);
+	return sysconf(_SC_NPROCESSORS_CONF);
 }
 #endif
 
@@ -363,7 +363,7 @@ static inline unsigned int cpus_online(void)
 #ifdef FIO_HAVE_CPU_AFFINITY
 static inline int CPU_COUNT(os_cpu_mask_t *mask)
 {
-	int max_cpus = cpus_online();
+	int max_cpus = cpus_configured();
 	int nr_cpus, i;
 
 	for (i = 0, nr_cpus = 0; i < max_cpus; i++)
diff --git a/os/windows/cpu-affinity.c b/os/windows/cpu-affinity.c
index 7601970f..8f3d6a76 100644
--- a/os/windows/cpu-affinity.c
+++ b/os/windows/cpu-affinity.c
@@ -2,12 +2,6 @@
 
 #include <windows.h>
 
-/* Return all processors regardless of processor group */
-unsigned int cpus_online(void)
-{
-	return GetActiveProcessorCount(ALL_PROCESSOR_GROUPS);
-}
-
 static void print_mask(os_cpu_mask_t *cpumask)
 {
 	for (int i = 0; i < FIO_CPU_MASK_ROWS; i++)
diff --git a/os/windows/posix.c b/os/windows/posix.c
index a3a6c89f..a47223da 100644
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -216,10 +216,18 @@ long sysconf(int name)
 	MEMORYSTATUSEX status;
 
 	switch (name) {
-	case _SC_NPROCESSORS_ONLN:
-		val = GetNumLogicalProcessors();
+	case _SC_NPROCESSORS_CONF:
+		/*
+		 * Using GetMaximumProcessorCount introduces a problem in
+		 * gettime.c because Windows does not have
+		 * fio_get_thread_affinity. Log sample (see #1479):
+		 *
+		 *   CPU mask contains processor beyond last active processor index (2)
+		 *   clock setaffinity failed: No error
+		 */
+		val = GetActiveProcessorCount(ALL_PROCESSOR_GROUPS);
 		if (val == -1)
-			log_err("sysconf(_SC_NPROCESSORS_ONLN) failed\n");
+			log_err("sysconf(_SC_NPROCESSORS_CONF) failed\n");
 
 		break;
 
@@ -1201,4 +1209,4 @@ cleanup:
 	DisconnectNamedPipe(hpipe);
 	CloseHandle(hpipe);
 	return ret;
-}
\ No newline at end of file
+}
diff --git a/rate-submit.c b/rate-submit.c
index 268356d1..2fe768c0 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -263,6 +263,8 @@ static void sum_ddir(struct thread_data *dst, struct thread_data *src,
 	sum_val(&dst->this_io_blocks[ddir], &src->this_io_blocks[ddir]);
 	sum_val(&dst->this_io_bytes[ddir], &src->this_io_bytes[ddir]);
 	sum_val(&dst->bytes_done[ddir], &src->bytes_done[ddir]);
+	if (ddir == DDIR_READ)
+		sum_val(&dst->bytes_verified, &src->bytes_verified);
 
 	pthread_double_unlock(&dst->io_wq.stat_lock, &src->io_wq.stat_lock);
 }
diff --git a/server.c b/server.c
index b453be5f..b869d387 100644
--- a/server.c
+++ b/server.c
@@ -999,7 +999,7 @@ static int handle_probe_cmd(struct fio_net_cmd *cmd)
 		.os		= FIO_OS,
 		.arch		= FIO_ARCH,
 		.bpp		= sizeof(void *),
-		.cpus		= __cpu_to_le32(cpus_online()),
+		.cpus		= __cpu_to_le32(cpus_configured()),
 	};
 
 	dprint(FD_NET, "server: sending probe reply\n");
diff --git a/t/dedupe.c b/t/dedupe.c
index d21e96f4..02e52b74 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -688,7 +688,7 @@ int main(int argc, char *argv[])
 		use_bloom = 0;
 
 	if (!num_threads)
-		num_threads = cpus_online();
+		num_threads = cpus_configured();
 
 	if (argc == optind)
 		return usage(argv);
diff --git a/t/jobs/t0025.fio b/t/jobs/t0025.fio
new file mode 100644
index 00000000..29b5fe80
--- /dev/null
+++ b/t/jobs/t0025.fio
@@ -0,0 +1,7 @@
+[job]
+filename=t0025file
+size=128k
+readwrite=write
+do_verify=1
+verify=md5
+experimental_verify=1
diff --git a/t/jobs/t0026.fio b/t/jobs/t0026.fio
new file mode 100644
index 00000000..ee89b140
--- /dev/null
+++ b/t/jobs/t0026.fio
@@ -0,0 +1,19 @@
+[job1]
+filename=t0026file
+size=1M
+readwrite=randwrite
+loops=8
+do_verify=1
+verify=md5
+experimental_verify=1
+
+[job2]
+stonewall=1
+filename=t0026file
+size=1M
+readwrite=randrw
+time_based
+runtime=5
+do_verify=1
+verify=md5
+experimental_verify=1
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index df87ae72..e5b307ac 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -788,6 +788,18 @@ class FioJobTest_t0024(FioJobTest_t0023):
         self.check_all_offsets("bssplit_bw.log", 512, filesize)
 
 
+class FioJobTest_t0025(FioJobTest):
+    """Test experimental verify read backs written data pattern."""
+    def check_result(self):
+        super(FioJobTest_t0025, self).check_result()
+
+        if not self.passed:
+            return
+
+        if self.json_data['jobs'][0]['read']['io_kbytes'] != 128:
+            self.passed = False
+
+
 class FioJobTest_iops_rate(FioJobTest):
     """Test consists of fio test job t0009
     Confirm that job0 iops == 1000
@@ -1183,6 +1195,25 @@ TEST_LIST = [
         'pre_success':      None,
         'requirements':     [],
     },
+    {
+        'test_id':          25,
+        'test_class':       FioJobTest_t0025,
+        'job':              't0025.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [],
+    },
+    {
+        'test_id':          26,
+        'test_class':       FioJobTest,
+        'job':              't0026.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [Requirements.not_windows],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
diff --git a/verify.c b/verify.c
index 0e1e4639..d6a229ca 100644
--- a/verify.c
+++ b/verify.c
@@ -1287,8 +1287,6 @@ void populate_verify_io_u(struct thread_data *td, struct io_u *io_u)
 	if (td->o.verify == VERIFY_NULL)
 		return;
 
-	io_u->numberio = td->io_issues[io_u->ddir];
-
 	fill_pattern_headers(td, io_u, 0, 0);
 }
 
