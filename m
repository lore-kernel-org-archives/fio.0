Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58240 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751851AbeFFMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Jun 2018 08:00:12 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fQX6p-0006IL-FC
        for fio@vger.kernel.org; Wed, 06 Jun 2018 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180606120001.D21372C0311@kernel.dk>
Date: Wed,  6 Jun 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 182cab24328ab22a5b76ba1edac2c801b83aeffb:

  Fix issue with rate_process=poisson and ramp time (2018-06-04 13:51:47 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a43f4461d5716c4c46018dd45cecf0a896d05dbd:

  Fix variable shadowing (2018-06-05 13:44:47 -0600)

----------------------------------------------------------------
Bart Van Assche (4):
      Remove show_run_stats() because it has no callers
      Rename appveyor.yml into .appveyor.yml
      Suppress gcc 8 compiler warnings
      Make nowarn_snprintf() call va_end()

Jens Axboe (14):
      Merge branch 'remove-show-run-stats' of https://github.com/bvanassche/fio
      Merge branch 'appveyor' of https://github.com/bvanassche/fio
      Merge branch 'suppress-gcc-8-warnings' of https://github.com/bvanassche/fio
      Move nowarn_snprintf.h to lib/
      Merge branch 'make-nowarn-snprintf-call-va-end' of https://github.com/bvanassche/fio
      fallocate: use 'offset' parameter
      Cleanup should_check_rate()
      x86: don't need 'level' passed to amd/intel init functions
      gettime: remove 'is_thread' variable to local clock init
      log: fix signedness issue
      options: remove unused function parameters
      client: remove 'cmd' argument to stop handler
      iolog: remove 'td' from trim_io_piece()
      Fix variable shadowing

 appveyor.yml => .appveyor.yml |  0
 arch/arch-x86-common.h        |  8 ++++----
 backend.c                     | 24 ++++++++++--------------
 client.c                      |  6 +++---
 client.h                      |  3 ++-
 diskutil.c                    | 13 +++++++++----
 fio.h                         | 18 ++++++++----------
 gclient.c                     |  2 +-
 gettime.c                     |  4 ++--
 gettime.h                     |  2 +-
 iolog.c                       | 12 ++++++------
 iolog.h                       |  2 +-
 lib/nowarn_snprintf.h         | 27 +++++++++++++++++++++++++++
 log.c                         | 10 +++++-----
 log.h                         |  4 ++--
 options.c                     | 14 +++++---------
 os/os-linux.h                 |  2 +-
 parse.c                       |  4 ++--
 server.c                      |  6 +++---
 stat.c                        | 13 +++----------
 stat.h                        |  1 -
 verify-state.h                |  3 ++-
 22 files changed, 97 insertions(+), 81 deletions(-)
 rename appveyor.yml => .appveyor.yml (100%)
 create mode 100644 lib/nowarn_snprintf.h

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
new file mode 100644
index 0000000..ca8b2ab
--- /dev/null
+++ b/.appveyor.yml
@@ -0,0 +1,30 @@
+clone_depth: 1 # NB: this stops FIO-VERSION-GEN making tag based versions
+
+environment:
+  CYG_MIRROR: http://cygwin.mirror.constant.com
+  CYG_ROOT: C:\cygwin64
+  MAKEFLAGS: -j 2
+  matrix:
+    - platform: x64
+      PACKAGE_ARCH: x86_64
+      CONFIGURE_OPTIONS:
+    - platform: x86
+      PACKAGE_ARCH: i686
+      CONFIGURE_OPTIONS: --build-32bit-win --target-win-ver=xp
+
+install:
+  - '%CYG_ROOT%\setup-x86_64.exe --quiet-mode --no-shortcuts --only-site --site "%CYG_MIRROR%" --packages "mingw64-%PACKAGE_ARCH%-zlib" > NUL'
+  - SET PATH=%CYG_ROOT%\bin;%PATH% #��NB: Changed env variables persist to later sections
+
+build_script:
+  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && ./configure --disable-native --extra-cflags=\"-Werror\" ${CONFIGURE_OPTIONS} && make.exe'
+
+after_build:
+  - cd os\windows && dobuild.cmd %PLATFORM%
+
+test_script:
+  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && file.exe fio.exe && make.exe test'
+
+artifacts:
+  - path: os\windows\*.msi
+    name: msi
diff --git a/appveyor.yml b/appveyor.yml
deleted file mode 100644
index ca8b2ab..0000000
--- a/appveyor.yml
+++ /dev/null
@@ -1,30 +0,0 @@
-clone_depth: 1 # NB: this stops FIO-VERSION-GEN making tag based versions
-
-environment:
-  CYG_MIRROR: http://cygwin.mirror.constant.com
-  CYG_ROOT: C:\cygwin64
-  MAKEFLAGS: -j 2
-  matrix:
-    - platform: x64
-      PACKAGE_ARCH: x86_64
-      CONFIGURE_OPTIONS:
-    - platform: x86
-      PACKAGE_ARCH: i686
-      CONFIGURE_OPTIONS: --build-32bit-win --target-win-ver=xp
-
-install:
-  - '%CYG_ROOT%\setup-x86_64.exe --quiet-mode --no-shortcuts --only-site --site "%CYG_MIRROR%" --packages "mingw64-%PACKAGE_ARCH%-zlib" > NUL'
-  - SET PATH=%CYG_ROOT%\bin;%PATH% #��NB: Changed env variables persist to later sections
-
-build_script:
-  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && ./configure --disable-native --extra-cflags=\"-Werror\" ${CONFIGURE_OPTIONS} && make.exe'
-
-after_build:
-  - cd os\windows && dobuild.cmd %PLATFORM%
-
-test_script:
-  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && file.exe fio.exe && make.exe test'
-
-artifacts:
-  - path: os\windows\*.msi
-    name: msi
diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
index c51c04c..5140f23 100644
--- a/arch/arch-x86-common.h
+++ b/arch/arch-x86-common.h
@@ -17,7 +17,7 @@ static inline void cpuid(unsigned int op,
 extern bool tsc_reliable;
 extern int arch_random;
 
-static inline void arch_init_intel(unsigned int level)
+static inline void arch_init_intel(void)
 {
 	unsigned int eax, ebx, ecx = 0, edx;
 
@@ -44,7 +44,7 @@ static inline void arch_init_intel(unsigned int level)
 	arch_random = (ecx & (1U << 30)) != 0;
 }
 
-static inline void arch_init_amd(unsigned int level)
+static inline void arch_init_amd(void)
 {
 	unsigned int eax, ebx, ecx, edx;
 
@@ -69,9 +69,9 @@ static inline void arch_init(char *envp[])
 
 	str[12] = '\0';
 	if (!strcmp(str, "GenuineIntel"))
-		arch_init_intel(level);
+		arch_init_intel();
 	else if (!strcmp(str, "AuthenticAMD"))
-		arch_init_amd(level);
+		arch_init_amd();
 }
 
 #endif
diff --git a/backend.c b/backend.c
index 180348f..c52eba5 100644
--- a/backend.c
+++ b/backend.c
@@ -432,9 +432,7 @@ static int wait_for_completions(struct thread_data *td, struct timespec *time)
 	if ((full && !min_evts) || !td->o.iodepth_batch_complete_min)
 		min_evts = 1;
 
-	if (time && (__should_check_rate(td, DDIR_READ) ||
-	    __should_check_rate(td, DDIR_WRITE) ||
-	    __should_check_rate(td, DDIR_TRIM)))
+	if (time && __should_check_rate(td))
 		fio_gettime(time, NULL);
 
 	do {
@@ -463,7 +461,7 @@ int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 				*bytes_issued += bytes;
 
 			if (!from_verify)
-				trim_io_piece(td, io_u);
+				trim_io_piece(io_u);
 
 			/*
 			 * zero read, fail
@@ -489,9 +487,7 @@ int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 			requeue_io_u(td, &io_u);
 		} else {
 sync_done:
-			if (comp_time && (__should_check_rate(td, DDIR_READ) ||
-			    __should_check_rate(td, DDIR_WRITE) ||
-			    __should_check_rate(td, DDIR_TRIM)))
+			if (comp_time && __should_check_rate(td))
 				fio_gettime(comp_time, NULL);
 
 			*ret = io_u_sync_complete(td, io_u);
@@ -1038,7 +1034,7 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 
 		if (td->o.io_submit_mode == IO_MODE_OFFLOAD) {
 			const unsigned long blen = io_u->xfer_buflen;
-			const enum fio_ddir ddir = acct_ddir(io_u);
+			const enum fio_ddir __ddir = acct_ddir(io_u);
 
 			if (td->error)
 				break;
@@ -1046,14 +1042,14 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 			workqueue_enqueue(&td->io_wq, &io_u->work);
 			ret = FIO_Q_QUEUED;
 
-			if (ddir_rw(ddir)) {
-				td->io_issues[ddir]++;
-				td->io_issue_bytes[ddir] += blen;
-				td->rate_io_issue_bytes[ddir] += blen;
+			if (ddir_rw(__ddir)) {
+				td->io_issues[__ddir]++;
+				td->io_issue_bytes[__ddir] += blen;
+				td->rate_io_issue_bytes[__ddir] += blen;
 			}
 
 			if (should_check_rate(td))
-				td->rate_next_io_time[ddir] = usec_for_io(td, ddir);
+				td->rate_next_io_time[__ddir] = usec_for_io(td, __ddir);
 
 		} else {
 			ret = io_u_submit(td, io_u);
@@ -1533,7 +1529,7 @@ static void *thread_main(void *data)
 	} else
 		td->pid = gettid();
 
-	fio_local_clock_init(o->use_thread);
+	fio_local_clock_init();
 
 	dprint(FD_PROCESS, "jobs pid=%d started\n", (int) td->pid);
 
diff --git a/client.c b/client.c
index ea1a4d2..96cc35e 100644
--- a/client.c
+++ b/client.c
@@ -28,7 +28,7 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd);
 static void handle_gs(struct fio_client *client, struct fio_net_cmd *cmd);
 static void handle_probe(struct fio_client *client, struct fio_net_cmd *cmd);
 static void handle_text(struct fio_client *client, struct fio_net_cmd *cmd);
-static void handle_stop(struct fio_client *client, struct fio_net_cmd *cmd);
+static void handle_stop(struct fio_client *client);
 static void handle_start(struct fio_client *client, struct fio_net_cmd *cmd);
 
 static void convert_text(struct fio_net_cmd *cmd);
@@ -1441,7 +1441,7 @@ static void handle_start(struct fio_client *client, struct fio_net_cmd *cmd)
 	sum_stat_clients += client->nr_stat;
 }
 
-static void handle_stop(struct fio_client *client, struct fio_net_cmd *cmd)
+static void handle_stop(struct fio_client *client)
 {
 	if (client->error)
 		log_info("client <%s>: exited with error %d\n", client->hostname, client->error);
@@ -1744,7 +1744,7 @@ int fio_handle_client(struct fio_client *client)
 		client->state = Client_stopped;
 		client->error = le32_to_cpu(pdu->error);
 		client->signal = le32_to_cpu(pdu->signal);
-		ops->stop(client, cmd);
+		ops->stop(client);
 		break;
 		}
 	case FIO_NET_CMD_ADD_JOB: {
diff --git a/client.h b/client.h
index 29e84d0..a597449 100644
--- a/client.h
+++ b/client.h
@@ -77,6 +77,7 @@ struct fio_client {
 };
 
 typedef void (client_cmd_op)(struct fio_client *, struct fio_net_cmd *);
+typedef void (client_op)(struct fio_client *);
 typedef void (client_eta_op)(struct jobs_eta *je);
 typedef void (client_timed_out_op)(struct fio_client *);
 typedef void (client_jobs_eta_op)(struct fio_client *client, struct jobs_eta *je);
@@ -95,7 +96,7 @@ struct client_ops {
 	client_cmd_op		*add_job;
 	client_cmd_op		*update_job;
 	client_timed_out_op	*timed_out;
-	client_cmd_op		*stop;
+	client_op		*stop;
 	client_cmd_op		*start;
 	client_cmd_op		*job_start;
 	client_timed_out_op	*removed;
diff --git a/diskutil.c b/diskutil.c
index b973120..5b4eb46 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -242,7 +242,8 @@ static void find_add_disk_slaves(struct thread_data *td, char *path,
 		    !strcmp(dirent->d_name, ".."))
 			continue;
 
-		sprintf(temppath, "%s/%s", slavesdir, dirent->d_name);
+		nowarn_snprintf(temppath, sizeof(temppath), "%s/%s", slavesdir,
+				dirent->d_name);
 		/* Can we always assume that the slaves device entries
 		 * are links to the real directories for the slave
 		 * devices?
@@ -255,9 +256,12 @@ static void find_add_disk_slaves(struct thread_data *td, char *path,
 		}
 		slavepath[linklen] = '\0';
 
-		sprintf(temppath, "%s/%s/dev", slavesdir, slavepath);
+		nowarn_snprintf(temppath, sizeof(temppath), "%s/%s/dev",
+				slavesdir, slavepath);
 		if (access(temppath, F_OK) != 0)
-			sprintf(temppath, "%s/%s/device/dev", slavesdir, slavepath);
+			nowarn_snprintf(temppath, sizeof(temppath),
+					"%s/%s/device/dev", slavesdir,
+					slavepath);
 		if (read_block_dev_entry(temppath, &majdev, &mindev)) {
 			perror("Error getting slave device numbers");
 			closedir(dirhandle);
@@ -271,7 +275,8 @@ static void find_add_disk_slaves(struct thread_data *td, char *path,
 		if (slavedu)
 			continue;
 
-		sprintf(temppath, "%s/%s", slavesdir, slavepath);
+		nowarn_snprintf(temppath, sizeof(temppath), "%s/%s", slavesdir,
+				slavepath);
 		__init_per_file_disk_util(td, majdev, mindev, temppath);
 		slavedu = disk_util_exists(majdev, mindev);
 
diff --git a/fio.h b/fio.h
index 4ce4991..9f3140a 100644
--- a/fio.h
+++ b/fio.h
@@ -44,6 +44,7 @@
 #include "io_u_queue.h"
 #include "workqueue.h"
 #include "steadystate.h"
+#include "lib/nowarn_snprintf.h"
 
 #ifdef CONFIG_SOLARISAIO
 #include <sys/asynch.h>
@@ -468,7 +469,9 @@ enum {
 			break;						\
 		(td)->error = ____e;					\
 		if (!(td)->first_error)					\
-			snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=%s, error=%s", __FILE__, __LINE__, (func), (msg));		\
+			nowarn_snprintf(td->verror, sizeof(td->verror),	\
+					"file:%s:%d, func=%s, error=%s", \
+					__FILE__, __LINE__, (func), (msg)); \
 	} while (0)
 
 
@@ -718,22 +721,17 @@ static inline bool option_check_rate(struct thread_data *td, enum fio_ddir ddir)
 	return false;
 }
 
-static inline bool __should_check_rate(struct thread_data *td,
-				       enum fio_ddir ddir)
+static inline bool __should_check_rate(struct thread_data *td)
 {
 	return (td->flags & TD_F_CHECK_RATE) != 0;
 }
 
 static inline bool should_check_rate(struct thread_data *td)
 {
-	if (__should_check_rate(td, DDIR_READ) && td->bytes_done[DDIR_READ])
-		return true;
-	if (__should_check_rate(td, DDIR_WRITE) && td->bytes_done[DDIR_WRITE])
-		return true;
-	if (__should_check_rate(td, DDIR_TRIM) && td->bytes_done[DDIR_TRIM])
-		return true;
+	if (!__should_check_rate(td))
+		return false;
 
-	return false;
+	return ddir_rw_sum(td->bytes_done) != 0;
 }
 
 static inline unsigned int td_max_bs(struct thread_data *td)
diff --git a/gclient.c b/gclient.c
index 5087b6b..bcd7a88 100644
--- a/gclient.c
+++ b/gclient.c
@@ -641,7 +641,7 @@ static void gfio_client_timed_out(struct fio_client *client)
 	gdk_threads_leave();
 }
 
-static void gfio_client_stop(struct fio_client *client, struct fio_net_cmd *cmd)
+static void gfio_client_stop(struct fio_client *client)
 {
 	struct gfio_client *gc = client->client_data;
 
diff --git a/gettime.c b/gettime.c
index 87fc29b..c0f2638 100644
--- a/gettime.c
+++ b/gettime.c
@@ -373,7 +373,7 @@ static int calibrate_cpu_clock(void)
 #endif // ARCH_HAVE_CPU_CLOCK
 
 #ifndef CONFIG_TLS_THREAD
-void fio_local_clock_init(int is_thread)
+void fio_local_clock_init(void)
 {
 	struct tv_valid *t;
 
@@ -389,7 +389,7 @@ static void kill_tv_tls_key(void *data)
 	free(data);
 }
 #else
-void fio_local_clock_init(int is_thread)
+void fio_local_clock_init(void)
 {
 }
 #endif
diff --git a/gettime.h b/gettime.h
index 1c4a25c..f92ee8c 100644
--- a/gettime.h
+++ b/gettime.h
@@ -20,7 +20,7 @@ extern void fio_gtod_init(void);
 extern void fio_clock_init(void);
 extern int fio_start_gtod_thread(void);
 extern int fio_monotonic_clocktest(int debug);
-extern void fio_local_clock_init(int);
+extern void fio_local_clock_init(void);
 
 extern struct timespec *fio_ts;
 
diff --git a/iolog.c b/iolog.c
index 6e44119..5be3e84 100644
--- a/iolog.c
+++ b/iolog.c
@@ -315,7 +315,7 @@ void unlog_io_piece(struct thread_data *td, struct io_u *io_u)
 	td->io_hist_len--;
 }
 
-void trim_io_piece(struct thread_data *td, const struct io_u *io_u)
+void trim_io_piece(const struct io_u *io_u)
 {
 	struct io_piece *ipo = io_u->ipo;
 
@@ -619,12 +619,12 @@ void setup_log(struct io_log **log, struct log_params *p,
 	}
 
 	if (l->td && l->td->o.io_submit_mode != IO_MODE_OFFLOAD) {
-		struct io_logs *p;
+		struct io_logs *__p;
 
-		p = calloc(1, sizeof(*l->pending));
-		p->max_samples = DEF_LOG_ENTRIES;
-		p->log = calloc(p->max_samples, log_entry_sz(l));
-		l->pending = p;
+		__p = calloc(1, sizeof(*l->pending));
+		__p->max_samples = DEF_LOG_ENTRIES;
+		__p->log = calloc(__p->max_samples, log_entry_sz(l));
+		l->pending = __p;
 	}
 
 	if (l->log_offset)
diff --git a/iolog.h b/iolog.h
index 60b4f01..a4e335a 100644
--- a/iolog.h
+++ b/iolog.h
@@ -237,7 +237,7 @@ extern void log_file(struct thread_data *, struct fio_file *, enum file_log_act)
 extern bool __must_check init_iolog(struct thread_data *td);
 extern void log_io_piece(struct thread_data *, struct io_u *);
 extern void unlog_io_piece(struct thread_data *, struct io_u *);
-extern void trim_io_piece(struct thread_data *, const struct io_u *);
+extern void trim_io_piece(const struct io_u *);
 extern void queue_io_piece(struct thread_data *, struct io_piece *);
 extern void prune_io_piece_log(struct thread_data *);
 extern void write_iolog_close(struct thread_data *);
diff --git a/lib/nowarn_snprintf.h b/lib/nowarn_snprintf.h
new file mode 100644
index 0000000..81a6d10
--- /dev/null
+++ b/lib/nowarn_snprintf.h
@@ -0,0 +1,27 @@
+#ifndef _NOWARN_SNPRINTF_H_
+#define _NOWARN_SNPRINTF_H_
+
+#include <stdio.h>
+#include <stdarg.h>
+
+static inline int nowarn_snprintf(char *str, size_t size, const char *format,
+				  ...)
+{
+	va_list args;
+	int res;
+
+	va_start(args, format);
+#if __GNUC__ -0 >= 8
+#pragma GCC diagnostic push "-Wformat-truncation"
+#pragma GCC diagnostic ignored "-Wformat-truncation"
+#endif
+	res = vsnprintf(str, size, format, args);
+#if __GNUC__ -0 >= 8
+#pragma GCC diagnostic pop "-Wformat-truncation"
+#endif
+	va_end(args);
+
+	return res;
+}
+
+#endif
diff --git a/log.c b/log.c
index 46e5034..6c36813 100644
--- a/log.c
+++ b/log.c
@@ -15,7 +15,7 @@ size_t log_info_buf(const char *buf, size_t len)
 		return 0;
 
 	if (is_backend) {
-		size_t ret = fio_server_text_output(FIO_LOG_INFO, buf, len);
+		ssize_t ret = fio_server_text_output(FIO_LOG_INFO, buf, len);
 		if (ret != -1)
 			return ret;
 	}
@@ -65,10 +65,10 @@ void log_prevalist(int type, const char *fmt, va_list args)
 	free(buf2);
 }
 
-size_t log_info(const char *format, ...)
+ssize_t log_info(const char *format, ...)
 {
 	va_list args;
-	size_t ret;
+	ssize_t ret;
 
 	va_start(args, format);
 	ret = log_valist(format, args);
@@ -102,9 +102,9 @@ int log_info_flush(void)
 	return fflush(f_out);
 }
 
-size_t log_err(const char *format, ...)
+ssize_t log_err(const char *format, ...)
 {
-	size_t ret;
+	ssize_t ret;
 	int len;
 	char *buffer;
 	va_list args;
diff --git a/log.h b/log.h
index 8163f97..b50d448 100644
--- a/log.h
+++ b/log.h
@@ -9,8 +9,8 @@
 extern FILE *f_out;
 extern FILE *f_err;
 
-extern size_t log_err(const char *format, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
-extern size_t log_info(const char *format, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
+extern ssize_t log_err(const char *format, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
+extern ssize_t log_info(const char *format, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
 extern size_t __log_buf(struct buf_output *, const char *format, ...) __attribute__ ((__format__ (__printf__, 2, 3)));
 extern size_t log_valist(const char *str, va_list);
 extern void log_prevalist(int type, const char *str, va_list);
diff --git a/options.c b/options.c
index 047e493..9fbcd96 100644
--- a/options.c
+++ b/options.c
@@ -57,8 +57,7 @@ struct split {
 };
 
 static int split_parse_ddir(struct thread_options *o, struct split *split,
-			    enum fio_ddir ddir, char *str, bool absolute,
-			    unsigned int max_splits)
+			    char *str, bool absolute, unsigned int max_splits)
 {
 	unsigned long long perc;
 	unsigned int i;
@@ -125,7 +124,7 @@ static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str,
 
 	memset(&split, 0, sizeof(split));
 
-	if (split_parse_ddir(o, &split, ddir, str, data, BSSPLIT_MAX))
+	if (split_parse_ddir(o, &split, str, data, BSSPLIT_MAX))
 		return 1;
 	if (!split.nr)
 		return 0;
@@ -882,7 +881,7 @@ static int zone_split_ddir(struct thread_options *o, enum fio_ddir ddir,
 
 	memset(&split, 0, sizeof(split));
 
-	if (split_parse_ddir(o, &split, ddir, str, absolute, ZONESPLIT_MAX))
+	if (split_parse_ddir(o, &split, str, absolute, ZONESPLIT_MAX))
 		return 1;
 	if (!split.nr)
 		return 0;
@@ -1047,8 +1046,6 @@ static int parse_zoned_distribution(struct thread_data *td, const char *input,
 	}
 
 	if (parse_dryrun()) {
-		int i;
-
 		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 			free(td->o.zone_split[i]);
 			td->o.zone_split[i] = NULL;
@@ -5162,8 +5159,7 @@ struct fio_option *fio_option_find(const char *name)
 	return find_option(fio_options, name);
 }
 
-static struct fio_option *find_next_opt(struct thread_options *o,
-					struct fio_option *from,
+static struct fio_option *find_next_opt(struct fio_option *from,
 					unsigned int off1)
 {
 	struct fio_option *opt;
@@ -5200,7 +5196,7 @@ bool __fio_option_is_set(struct thread_options *o, unsigned int off1)
 	struct fio_option *opt, *next;
 
 	next = NULL;
-	while ((opt = find_next_opt(o, next, off1)) != NULL) {
+	while ((opt = find_next_opt(next, off1)) != NULL) {
 		if (opt_is_set(o, opt))
 			return true;
 
diff --git a/os/os-linux.h b/os/os-linux.h
index a550bba..6b63d12 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -403,7 +403,7 @@ static inline bool fio_fallocate(struct fio_file *f, uint64_t offset,
 				 uint64_t len)
 {
 	int ret;
-	ret = fallocate(f->fd, 0, 0, len);
+	ret = fallocate(f->fd, 0, offset, len);
 	if (ret == 0)
 		return true;
 
diff --git a/parse.c b/parse.c
index 9685f1e..6261fca 100644
--- a/parse.c
+++ b/parse.c
@@ -69,7 +69,7 @@ static void posval_sort(const struct fio_option *o, struct value_pair *vpmap)
 }
 
 static void show_option_range(const struct fio_option *o,
-			      size_t (*logger)(const char *format, ...))
+			      ssize_t (*logger)(const char *format, ...))
 {
 	if (o->type == FIO_OPT_FLOAT_LIST) {
 		const char *sep = "";
@@ -132,7 +132,7 @@ static void show_option_help(const struct fio_option *o, int is_err)
 		"deprecated",
 		"unsupported",
 	};
-	size_t (*logger)(const char *format, ...);
+	ssize_t (*logger)(const char *format, ...);
 
 	if (is_err)
 		logger = log_err;
diff --git a/server.c b/server.c
index 12c8d68..7e7ffed 100644
--- a/server.c
+++ b/server.c
@@ -1594,7 +1594,7 @@ void fio_server_send_gs(struct group_run_stats *rs)
 }
 
 void fio_server_send_job_options(struct flist_head *opt_list,
-				 unsigned int groupid)
+				 unsigned int gid)
 {
 	struct cmd_job_option pdu;
 	struct flist_head *entry;
@@ -1609,12 +1609,12 @@ void fio_server_send_job_options(struct flist_head *opt_list,
 		p = flist_entry(entry, struct print_option, list);
 		memset(&pdu, 0, sizeof(pdu));
 
-		if (groupid == -1U) {
+		if (gid == -1U) {
 			pdu.global = __cpu_to_le16(1);
 			pdu.groupid = 0;
 		} else {
 			pdu.global = 0;
-			pdu.groupid = cpu_to_le32(groupid);
+			pdu.groupid = cpu_to_le32(gid);
 		}
 		len = strlen(p->name);
 		if (len >= sizeof(pdu.name)) {
diff --git a/stat.c b/stat.c
index c89a7f0..5b49ddd 100644
--- a/stat.c
+++ b/stat.c
@@ -1398,7 +1398,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	if (ts->ss_dur) {
 		struct json_object *data;
 		struct json_array *iops, *bw;
-		int i, j, k;
+		int j, k, l;
 		char ss_buf[64];
 
 		snprintf(ss_buf, sizeof(ss_buf), "%s%s:%f%s",
@@ -1434,8 +1434,8 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 			j = ts->ss_head;
 		else
 			j = ts->ss_head == 0 ? ts->ss_dur - 1 : ts->ss_head - 1;
-		for (i = 0; i < ts->ss_dur; i++) {
-			k = (j + i) % ts->ss_dur;
+		for (l = 0; l < ts->ss_dur; l++) {
+			k = (j + l) % ts->ss_dur;
 			json_array_add_value_int(bw, ts->ss_bw_data[k]);
 			json_array_add_value_int(iops, ts->ss_iops_data[k]);
 		}
@@ -1940,13 +1940,6 @@ void __show_run_stats(void)
 	free(opt_lists);
 }
 
-void show_run_stats(void)
-{
-	fio_sem_down(stat_sem);
-	__show_run_stats();
-	fio_sem_up(stat_sem);
-}
-
 void __show_running_run_stats(void)
 {
 	struct thread_data *td;
diff --git a/stat.h b/stat.h
index 8e7bcdb..c5b8185 100644
--- a/stat.h
+++ b/stat.h
@@ -288,7 +288,6 @@ extern struct json_object * show_thread_status(struct thread_stat *ts, struct gr
 extern void show_group_stats(struct group_run_stats *rs, struct buf_output *);
 extern bool calc_thread_status(struct jobs_eta *je, int force);
 extern void display_thread_status(struct jobs_eta *je);
-extern void show_run_stats(void);
 extern void __show_run_stats(void);
 extern void __show_running_run_stats(void);
 extern void show_running_run_stats(void);
diff --git a/verify-state.h b/verify-state.h
index 1586f63..6da1585 100644
--- a/verify-state.h
+++ b/verify-state.h
@@ -4,6 +4,7 @@
 #include <stdint.h>
 #include <string.h>
 #include <limits.h>
+#include "lib/nowarn_snprintf.h"
 
 struct thread_rand32_state {
 	uint32_t s[4];
@@ -101,7 +102,7 @@ static inline void verify_state_gen_name(char *out, size_t size,
 		name++;
 	} while (1);
 
-	snprintf(out, size, "%s-%s-%d-verify.state", prefix, ename, num);
+	nowarn_snprintf(out, size, "%s-%s-%d-verify.state", prefix, ename, num);
 	out[size - 1] = '\0';
 }
 
