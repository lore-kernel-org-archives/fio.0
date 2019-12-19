Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56658 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfLSNAU (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 19 Dec 2019 08:00:20 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ihvPf-0004x0-Em
        for fio@vger.kernel.org; Thu, 19 Dec 2019 13:00:19 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191219130001.DCA851BC016A@kernel.dk>
Date: Thu, 19 Dec 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 397dddce43664df92101350f1fe5cd4c9cd2a2c7:

  Merge branch 'travis-xcode11.2-python' of https://github.com/vincentkfu/fio (2019-12-16 16:08:35 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8d853d0bbf4487af9445f7253c1951970ce75200:

  Merge branch 'mine/patch-2' of https://github.com/hannesweisbach/fio (2019-12-19 05:38:30 -0700)

----------------------------------------------------------------
Hannes Weisbach (2):
      Expand choices for exitall
      Add example job file for exit_what

Jens Axboe (4):
      Merge branch 'cygwin-build-error' of https://github.com/vincentkfu/fio
      Merge branch 'issue-878' of https://github.com/vincentkfu/fio
      Merge branch 'windows_mkdir' of https://github.com/sitsofe/fio
      Merge branch 'mine/patch-2' of https://github.com/hannesweisbach/fio

Sitsofe Wheeler (1):
      filesetup: fix directory creation issues

Vincent Fu (2):
      Makefile: add libssp for Windows
      client/server: add missing fsync data structures

 HOWTO                 | 18 ++++++++++++++---
 Makefile              |  4 ++--
 backend.c             | 12 +++++------
 cconv.c               |  6 ++++--
 client.c              |  8 +++++++-
 configure             | 19 -----------------
 examples/exitwhat.fio | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++
 filesetup.c           | 22 +++++++-------------
 fio.1                 | 17 +++++++++++++---
 fio.h                 | 10 +++++++--
 libfio.c              |  7 +++++--
 options.c             | 27 ++++++++++++++++++++++++-
 os/os-windows.h       | 19 +++++++++++++++++
 os/os.h               |  4 ++++
 server.c              | 12 ++++++++---
 thread_options.h      |  6 ++++--
 16 files changed, 186 insertions(+), 61 deletions(-)
 create mode 100644 examples/exitwhat.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 88dbb03f..41a667af 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2814,9 +2814,21 @@ Threads, processes and job synchronization
 
 .. option:: exitall
 
-	By default, fio will continue running all other jobs when one job finishes
-	but sometimes this is not the desired action.  Setting ``exitall`` will
-	instead make fio terminate all other jobs when one job finishes.
+	By default, fio will continue running all other jobs when one job finishes.
+	Sometimes this is not the desired action.  Setting ``exitall`` will instead
+	make fio terminate all jobs in the same group, as soon as one job of that
+	group finishes.
+
+.. option:: exit_what
+
+	By default, fio will continue running all other jobs when one job finishes.
+	Sometimes this is not the desired action. Setting ``exit_all`` will
+	instead make fio terminate all jobs in the same group. The option
+        ``exit_what`` allows to control which jobs get terminated when ``exitall`` is
+        enabled. The default is ``group`` and does not change the behaviour of
+        ``exitall``. The setting ``all`` terminates all jobs. The setting ``stonewall``
+        terminates all currently running jobs across all groups and continues execution
+        with the next stonewalled group.
 
 .. option:: exec_prerun=str
 
diff --git a/Makefile b/Makefile
index 7aab6abd..4a07fab3 100644
--- a/Makefile
+++ b/Makefile
@@ -209,7 +209,7 @@ ifeq ($(CONFIG_TARGET_OS), Darwin)
 endif
 ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
   SOURCE += os/windows/posix.c
-  LIBS	 += -lpthread -lpsapi -lws2_32
+  LIBS	 += -lpthread -lpsapi -lws2_32 -lssp
   CFLAGS += -DPSAPI_VERSION=1 -Ios/windows/posix/include -Wno-format
 endif
 
@@ -506,7 +506,7 @@ t/time-test: $(T_TT_OBJS)
 
 ifdef CONFIG_HAVE_CUNIT
 unittests/unittest: $(UT_OBJS) $(UT_TARGET_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(UT_OBJS) $(UT_TARGET_OBJS) -lcunit
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(UT_OBJS) $(UT_TARGET_OBJS) -lcunit $(LIBS)
 endif
 
 clean: FORCE
diff --git a/backend.c b/backend.c
index 1c339408..d0d691b3 100644
--- a/backend.c
+++ b/backend.c
@@ -81,7 +81,7 @@ static void sig_int(int sig)
 			exit_value = 128;
 		}
 
-		fio_terminate_threads(TERMINATE_ALL);
+		fio_terminate_threads(TERMINATE_ALL, TERMINATE_ALL);
 	}
 }
 
@@ -1091,7 +1091,7 @@ reap:
 		if (!in_ramp_time(td) && should_check_rate(td)) {
 			if (check_min_rate(td, &comp_time)) {
 				if (exitall_on_terminate || td->o.exitall_error)
-					fio_terminate_threads(td->groupid);
+					fio_terminate_threads(td->groupid, td->o.exit_what);
 				td_verror(td, EIO, "check_min_rate");
 				break;
 			}
@@ -1898,7 +1898,7 @@ static void *thread_main(void *data)
 		exec_string(o, o->exec_postrun, (const char *)"postrun");
 
 	if (exitall_on_terminate || (o->exitall_error && td->error))
-		fio_terminate_threads(td->groupid);
+		fio_terminate_threads(td->groupid, td->o.exit_what);
 
 err:
 	if (td->error)
@@ -2050,7 +2050,7 @@ reaped:
 	}
 
 	if (*nr_running == cputhreads && !pending && realthreads)
-		fio_terminate_threads(TERMINATE_ALL);
+		fio_terminate_threads(TERMINATE_ALL, TERMINATE_ALL);
 }
 
 static bool __check_trigger_file(void)
@@ -2100,7 +2100,7 @@ void check_trigger_file(void)
 			fio_clients_send_trigger(trigger_remote_cmd);
 		else {
 			verify_save_state(IO_LIST_ALL);
-			fio_terminate_threads(TERMINATE_ALL);
+			fio_terminate_threads(TERMINATE_ALL, TERMINATE_ALL);
 			exec_trigger(trigger_cmd);
 		}
 	}
@@ -2373,7 +2373,7 @@ reap:
 			dprint(FD_MUTEX, "wait on startup_sem\n");
 			if (fio_sem_down_timeout(startup_sem, 10000)) {
 				log_err("fio: job startup hung? exiting.\n");
-				fio_terminate_threads(TERMINATE_ALL);
+				fio_terminate_threads(TERMINATE_ALL, TERMINATE_ALL);
 				fio_abort = true;
 				nr_started--;
 				free(fd);
diff --git a/cconv.c b/cconv.c
index bff5e34f..04854b0e 100644
--- a/cconv.c
+++ b/cconv.c
@@ -236,7 +236,8 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->loops = le32_to_cpu(top->loops);
 	o->mem_type = le32_to_cpu(top->mem_type);
 	o->mem_align = le32_to_cpu(top->mem_align);
-	o->stonewall = le32_to_cpu(top->stonewall);
+	o->exit_what = le16_to_cpu(top->exit_what);
+	o->stonewall = le16_to_cpu(top->stonewall);
 	o->new_group = le32_to_cpu(top->new_group);
 	o->numjobs = le32_to_cpu(top->numjobs);
 	o->cpus_allowed_policy = le32_to_cpu(top->cpus_allowed_policy);
@@ -433,7 +434,8 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->loops = cpu_to_le32(o->loops);
 	top->mem_type = cpu_to_le32(o->mem_type);
 	top->mem_align = cpu_to_le32(o->mem_align);
-	top->stonewall = cpu_to_le32(o->stonewall);
+	top->exit_what = cpu_to_le16(o->exit_what);
+	top->stonewall = cpu_to_le16(o->stonewall);
 	top->new_group = cpu_to_le32(o->new_group);
 	top->numjobs = cpu_to_le32(o->numjobs);
 	top->cpus_allowed_policy = cpu_to_le32(o->cpus_allowed_policy);
diff --git a/client.c b/client.c
index e0047af0..55d89a0e 100644
--- a/client.c
+++ b/client.c
@@ -960,6 +960,7 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 		convert_io_stat(&dst->bw_stat[i], &src->bw_stat[i]);
 		convert_io_stat(&dst->iops_stat[i], &src->iops_stat[i]);
 	}
+	convert_io_stat(&dst->sync_stat, &src->sync_stat);
 
 	dst->usr_time		= le64_to_cpu(src->usr_time);
 	dst->sys_time		= le64_to_cpu(src->sys_time);
@@ -994,8 +995,13 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 		for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
 			dst->io_u_plat[i][j] = le64_to_cpu(src->io_u_plat[i][j]);
 
-	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+	for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
+		dst->io_u_sync_plat[j] = le64_to_cpu(src->io_u_sync_plat[j]);
+
+	for (i = 0; i < DDIR_RWDIR_SYNC_CNT; i++)
 		dst->total_io_u[i]	= le64_to_cpu(src->total_io_u[i]);
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		dst->short_io_u[i]	= le64_to_cpu(src->short_io_u[i]);
 		dst->drop_io_u[i]	= le64_to_cpu(src->drop_io_u[i]);
 	}
diff --git a/configure b/configure
index e32d5dcf..a1279693 100755
--- a/configure
+++ b/configure
@@ -2316,22 +2316,6 @@ if test "$enable_cuda" = "yes" && compile_prog "" "-lcuda" "cuda"; then
 fi
 print_config "cuda" "$cuda"
 
-##########################################
-# mkdir() probe. mingw apparently has a one-argument mkdir :/
-mkdir_two="no"
-cat > $TMPC << EOF
-#include <sys/stat.h>
-#include <sys/types.h>
-int main(int argc, char **argv)
-{
-  return mkdir("/tmp/bla", 0600);
-}
-EOF
-if compile_prog "" "" "mkdir(a, b)"; then
-  mkdir_two="yes"
-fi
-print_config "mkdir(a, b)" "$mkdir_two"
-
 ##########################################
 # check for cc -march=native
 build_native="no"
@@ -2705,9 +2689,6 @@ fi
 if test "$cuda" = "yes" ; then
   output_sym "CONFIG_CUDA"
 fi
-if test "$mkdir_two" = "yes" ; then
-  output_sym "CONFIG_HAVE_MKDIR_TWO"
-fi
 if test "$march_set" = "no" && test "$build_native" = "yes" ; then
   output_sym "CONFIG_BUILD_NATIVE"
 fi
diff --git a/examples/exitwhat.fio b/examples/exitwhat.fio
new file mode 100644
index 00000000..a1099f0f
--- /dev/null
+++ b/examples/exitwhat.fio
@@ -0,0 +1,56 @@
+# We want to run fast1 as long as slow1 is running, but also have a cumulative
+# report of fast1 (group_reporting=1/new_group=1).  exitall=1 would not cause
+# fast1 to stop after slow1 is done. Setting exit_what=stonewall will cause
+# alls jobs up until the next stonewall=1 setting to be stopped, when job slow1
+# finishes.
+# In this example skipping forward to slow2/fast2. slow2 has exit_what=all set,
+# which means all jobs will be cancelled when slow2 finishes. In particular,
+# runsnever will never run.
+
+[global]
+filename=/tmp/test
+filesize=1G
+blocksize=4096
+group_reporting=1
+exitall=1
+
+[slow1]
+rw=r
+numjobs=1
+ioengine=sync
+new_group=1
+thinktime=2000
+number_ios=1000
+exit_what=stonewall
+
+[fast1]
+new_group=1
+rw=randrw
+numjobs=3
+ioengine=libaio
+iodepth=32
+rate=300,300,300
+
+[slow2]
+stonewall=1
+rw=w
+numjobs=1
+ioengine=sync
+new_group=1
+thinktime=2000
+number_ios=1000
+exit_what=all
+
+[fast2]
+rw=randrw
+numjobs=3
+ioengine=libaio
+iodepth=32
+rate=300,300,300
+
+[runsnever]
+rw=randrw
+numjobs=3
+ioengine=libaio
+iodepth=32
+rate=300,300,300
diff --git a/filesetup.c b/filesetup.c
index ed3646a4..b45a5826 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -918,26 +918,18 @@ static bool create_work_dirs(struct thread_data *td, const char *fname)
 	char path[PATH_MAX];
 	char *start, *end;
 
-	if (td->o.directory) {
-		snprintf(path, PATH_MAX, "%s%c%s", td->o.directory,
-			 FIO_OS_PATH_SEPARATOR, fname);
-		start = strstr(path, fname);
-	} else {
-		snprintf(path, PATH_MAX, "%s", fname);
-		start = path;
-	}
+	snprintf(path, PATH_MAX, "%s", fname);
+	start = path;
 
 	end = start;
 	while ((end = strchr(end, FIO_OS_PATH_SEPARATOR)) != NULL) {
-		if (end == start)
-			break;
+		if (end == start) {
+			end++;
+			continue;
+		}
 		*end = '\0';
 		errno = 0;
-#ifdef CONFIG_HAVE_MKDIR_TWO
-		if (mkdir(path, 0600) && errno != EEXIST) {
-#else
-		if (mkdir(path) && errno != EEXIST) {
-#endif
+		if (fio_mkdir(path, 0700) && errno != EEXIST) {
 			log_err("fio: failed to create dir (%s): %d\n",
 				start, errno);
 			return false;
diff --git a/fio.1 b/fio.1
index 14569e9f..a60863f6 100644
--- a/fio.1
+++ b/fio.1
@@ -2509,9 +2509,20 @@ wall also implies starting a new reporting group, see
 \fBgroup_reporting\fR.
 .TP
 .BI exitall
-By default, fio will continue running all other jobs when one job finishes
-but sometimes this is not the desired action. Setting \fBexitall\fR will
-instead make fio terminate all other jobs when one job finishes.
+By default, fio will continue running all other jobs when one job finishes.
+Sometimes this is not the desired action. Setting \fBexitall\fR will instead
+make fio terminate all jobs in the same group, as soon as one job of that
+group finishes.
+.TP
+.BI exit_what
+By default, fio will continue running all other jobs when one job finishes.
+Sometimes this is not the desired action. Setting \fBexit_all\fR will instead
+make fio terminate all jobs in the same group. The option \fBexit_what\fR
+allows to control which jobs get terminated when \fBexitall\fR is enabled. The
+default is \fBgroup\fR and does not change the behaviour of \fBexitall\fR. The
+setting \fBall\fR terminates all jobs. The setting \fBstonewall\fR terminates
+all currently running jobs across all groups and continues execution with the
+next stonewalled group.
 .TP
 .BI exec_prerun \fR=\fPstr
 Before running this job, issue the command specified through
diff --git a/fio.h b/fio.h
index 2094d30b..e943ad16 100644
--- a/fio.h
+++ b/fio.h
@@ -660,8 +660,14 @@ extern const char *runstate_to_name(int runstate);
  */
 #define FIO_REAP_TIMEOUT	300
 
-#define TERMINATE_ALL		(-1U)
-extern void fio_terminate_threads(unsigned int);
+enum {
+	TERMINATE_NONE = 0,
+	TERMINATE_GROUP = 1,
+	TERMINATE_STONEWALL = 2,
+	TERMINATE_ALL = -1,
+};
+
+extern void fio_terminate_threads(unsigned int, unsigned int);
 extern void fio_mark_td_terminate(struct thread_data *);
 
 /*
diff --git a/libfio.c b/libfio.c
index 674bc1dc..7348b164 100644
--- a/libfio.c
+++ b/libfio.c
@@ -233,7 +233,7 @@ void fio_mark_td_terminate(struct thread_data *td)
 	td->terminate = true;
 }
 
-void fio_terminate_threads(unsigned int group_id)
+void fio_terminate_threads(unsigned int group_id, unsigned int terminate)
 {
 	struct thread_data *td;
 	pid_t pid = getpid();
@@ -242,7 +242,10 @@ void fio_terminate_threads(unsigned int group_id)
 	dprint(FD_PROCESS, "terminate group_id=%d\n", group_id);
 
 	for_each_td(td, i) {
-		if (group_id == TERMINATE_ALL || group_id == td->groupid) {
+		if ((terminate == TERMINATE_GROUP && group_id == TERMINATE_ALL) ||
+		    (terminate == TERMINATE_GROUP && group_id == td->groupid) ||
+		    (terminate == TERMINATE_STONEWALL && td->runstate >= TD_RUNNING) ||
+		    (terminate == TERMINATE_ALL)) {
 			dprint(FD_PROCESS, "setting terminate on %s/%d\n",
 						td->o.name, (int) td->pid);
 
diff --git a/options.c b/options.c
index fad1857e..287f0435 100644
--- a/options.c
+++ b/options.c
@@ -1235,7 +1235,8 @@ int set_name_idx(char *target, size_t tlen, char *input, int index,
 		len = snprintf(target, tlen, "%s/%s.", fname,
 				client_sockaddr_str);
 	} else
-		len = snprintf(target, tlen, "%s/", fname);
+		len = snprintf(target, tlen, "%s%c", fname,
+				FIO_OS_PATH_SEPARATOR);
 
 	target[tlen - 1] = '\0';
 	free(p);
@@ -3940,6 +3941,30 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_PROCESS,
 	},
+	{
+		.name	= "exit_what",
+		.lname	= "What jobs to quit on terminate",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct thread_options, exit_what),
+		.help	= "Fine-grained control for exitall",
+		.def	= "group",
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_PROCESS,
+		.posval	= {
+			  { .ival = "group",
+			    .oval = TERMINATE_GROUP,
+			    .help = "exit_all=1 default behaviour",
+			  },
+			  { .ival = "stonewall",
+			    .oval = TERMINATE_STONEWALL,
+			    .help = "quit all currently running jobs; continue with next stonewall",
+			  },
+			  { .ival = "all",
+			    .oval = TERMINATE_ALL,
+			    .help = "Quit everything",
+			  },
+		},
+	},
 	{
 		.name	= "exitall_on_error",
 		.lname	= "Exit-all on terminate in error",
diff --git a/os/os-windows.h b/os/os-windows.h
index 3e9f7341..6061d8c7 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -35,6 +35,7 @@ int rand_r(unsigned *);
 #define FIO_HAVE_CPU_AFFINITY
 #define FIO_HAVE_CHARDEV_SIZE
 #define FIO_HAVE_GETTID
+#define FIO_EMULATED_MKDIR_TWO
 
 #define FIO_PREFERRED_ENGINE		"windowsaio"
 #define FIO_PREFERRED_CLOCK_SOURCE	CS_CGETTIME
@@ -197,6 +198,24 @@ static inline int fio_set_sched_idle(void)
 	return (SetThreadPriority(GetCurrentThread(), THREAD_PRIORITY_IDLE))? 0 : -1;
 }
 
+static inline int fio_mkdir(const char *path, mode_t mode) {
+	DWORD dwAttr = GetFileAttributesA(path);
+
+	if (dwAttr != INVALID_FILE_ATTRIBUTES &&
+	    (dwAttr & FILE_ATTRIBUTE_DIRECTORY)) {
+		errno = EEXIST;
+		return -1;
+	}
+
+	if (CreateDirectoryA(path, NULL) == 0) {
+		log_err("CreateDirectoryA = %d\n", GetLastError());
+		errno = win_to_posix_error(GetLastError());
+		return -1;
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_WINDOWS_XP
 #include "os-windows-xp.h"
 #else
diff --git a/os/os.h b/os/os.h
index dadcd87b..9a280e54 100644
--- a/os/os.h
+++ b/os/os.h
@@ -407,4 +407,8 @@ static inline bool os_cpu_has(cpu_features feature)
 }
 #endif
 
+#ifndef FIO_EMULATED_MKDIR_TWO
+# define fio_mkdir(path, mode)	mkdir(path, mode)
 #endif
+
+#endif /* FIO_OS_H */
diff --git a/server.c b/server.c
index e7846227..b7347b43 100644
--- a/server.c
+++ b/server.c
@@ -975,7 +975,7 @@ static int handle_trigger_cmd(struct fio_net_cmd *cmd, struct flist_head *job_li
 	} else
 		fio_net_queue_cmd(FIO_NET_CMD_VTRIGGER, rep, sz, NULL, SK_F_FREE | SK_F_INLINE);
 
-	fio_terminate_threads(TERMINATE_ALL);
+	fio_terminate_threads(TERMINATE_ALL, TERMINATE_ALL);
 	fio_server_check_jobs(job_list);
 	exec_trigger(buf);
 	return 0;
@@ -992,7 +992,7 @@ static int handle_command(struct sk_out *sk_out, struct flist_head *job_list,
 
 	switch (cmd->opcode) {
 	case FIO_NET_CMD_QUIT:
-		fio_terminate_threads(TERMINATE_ALL);
+		fio_terminate_threads(TERMINATE_ALL, TERMINATE_ALL);
 		ret = 0;
 		break;
 	case FIO_NET_CMD_EXIT:
@@ -1490,6 +1490,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 		convert_io_stat(&p.ts.bw_stat[i], &ts->bw_stat[i]);
 		convert_io_stat(&p.ts.iops_stat[i], &ts->iops_stat[i]);
 	}
+	convert_io_stat(&p.ts.sync_stat, &ts->sync_stat);
 
 	p.ts.usr_time		= cpu_to_le64(ts->usr_time);
 	p.ts.sys_time		= cpu_to_le64(ts->sys_time);
@@ -1524,8 +1525,13 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 		for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
 			p.ts.io_u_plat[i][j] = cpu_to_le64(ts->io_u_plat[i][j]);
 
-	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+	for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
+		p.ts.io_u_sync_plat[j] = cpu_to_le64(ts->io_u_sync_plat[j]);
+
+	for (i = 0; i < DDIR_RWDIR_SYNC_CNT; i++)
 		p.ts.total_io_u[i]	= cpu_to_le64(ts->total_io_u[i]);
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		p.ts.short_io_u[i]	= cpu_to_le64(ts->short_io_u[i]);
 		p.ts.drop_io_u[i]	= cpu_to_le64(ts->drop_io_u[i]);
 	}
diff --git a/thread_options.h b/thread_options.h
index ee6e4d6d..4b131bda 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -201,7 +201,8 @@ struct thread_options {
 
 	unsigned long long max_latency;
 
-	unsigned int stonewall;
+	unsigned short exit_what;
+	unsigned short stonewall;
 	unsigned int new_group;
 	unsigned int numjobs;
 	os_cpu_mask_t cpumask;
@@ -489,7 +490,8 @@ struct thread_options_pack {
 	uint32_t mem_type;
 	uint32_t mem_align;
 
-	uint32_t stonewall;
+	uint16_t exit_what;
+	uint16_t stonewall;
 	uint32_t new_group;
 	uint32_t numjobs;
 	/*

