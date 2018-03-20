Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34990 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751084AbeCTMAU (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Mar 2018 08:00:20 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1eyFwA-0005jr-9k
        for fio@vger.kernel.org; Tue, 20 Mar 2018 12:00:19 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180320120001.BF48A2C0116@kernel.dk>
Date: Tue, 20 Mar 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 69b98f11d62cb12482130fac79b8ebf00c0bb139:

  io_u: only rewind file position if it's non-zero (2018-03-13 11:49:55 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 96344ff00349422172de6fa57899c66dc3c00391:

  optgroup: add check for optgroup bit numbers being within range (2018-03-19 15:56:20 -0600)

----------------------------------------------------------------
Bart Van Assche (7):
      Split mutex.c and .h each into three files
      Rename fio_mutex into fio_sem
      Improve Valgrind instrumentation of memory allocations
      gettime: Rework the clock thread starting mechanism
      Suppress uninteresting data race reports
      Make sure that assert() expressions do not have side effects
      Signal td->free_cond with the associated mutex held

Jens Axboe (3):
      Merge branch 'pthread-cond' of https://github.com/bvanassche/fio
      Merge branch 'master' of https://github.com/bvanassche/fio
      optgroup: add check for optgroup bit numbers being within range

Kris Davis (1):
      sg: add read/write FUA options

 HOWTO            |  12 +++
 Makefile         |  16 +--
 backend.c        |  49 ++++-----
 cgroup.c         |  14 +--
 configure        |  21 ++++
 diskutil.c       |  44 ++++----
 diskutil.h       |   7 +-
 engines/sg.c     |  45 ++++++++
 eta.c            |   6 ++
 file.h           |   2 +-
 filehash.c       |  26 ++---
 filelock.c       |  38 +++----
 filesetup.c      |   7 +-
 fio.1            |  10 +-
 fio.h            |   7 +-
 fio_sem.c        | 178 ++++++++++++++++++++++++++++++
 fio_sem.h        |  31 ++++++
 flow.c           |  18 ++--
 gettime-thread.c |  22 ++--
 gettime.c        |  20 ++--
 helper_thread.c  |  23 ++--
 helper_thread.h  |   2 +-
 init.c           |  11 +-
 io_u.c           |   8 +-
 iolog.c          |   1 +
 mutex.c          | 322 -------------------------------------------------------
 mutex.h          |  47 --------
 optgroup.c       |   3 +
 optgroup.h       |   8 +-
 profiles/act.c   |  14 +--
 pshared.c        |  76 +++++++++++++
 pshared.h        |  10 ++
 rwlock.c         |  83 ++++++++++++++
 rwlock.h         |  19 ++++
 server.c         |  34 +++---
 server.h         |   6 +-
 smalloc.c        |  50 +++++++--
 stat.c           |  18 ++--
 stat.h           |   2 +-
 t/dedupe.c       |  26 ++---
 verify.c         |  11 +-
 workqueue.c      |   1 +
 42 files changed, 766 insertions(+), 582 deletions(-)
 create mode 100644 fio_sem.c
 create mode 100644 fio_sem.h
 delete mode 100644 mutex.c
 delete mode 100644 mutex.h
 create mode 100644 pshared.c
 create mode 100644 pshared.h
 create mode 100644 rwlock.c
 create mode 100644 rwlock.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index acb9e97..dbbbfaa 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1747,6 +1747,7 @@ I/O engine
 			:manpage:`read(2)` and :manpage:`write(2)` for asynchronous
 			I/O. Requires :option:`filename` option to specify either block or
 			character devices.
+			The sg engine includes engine specific options.
 
 		**null**
 			Doesn't transfer any data, just pretends to.  This is mainly used to
@@ -2068,6 +2069,17 @@ with the caveat that when used on the command line, they must come after the
 	multiple paths exist between the client and the server or in certain loopback
 	configurations.
 
+.. option:: readfua=bool : [sg]
+
+	With readfua option set to 1, read operations include
+	the force unit access (fua) flag. Default is 0.
+
+.. option:: writefua=bool : [sg]
+
+	With writefua option set to 1, write operations include
+	the force unit access (fua) flag. Default is 0.
+
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/Makefile b/Makefile
index d73b944..eb3bddd 100644
--- a/Makefile
+++ b/Makefile
@@ -41,7 +41,8 @@ endif
 SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/lib/*.c))) \
 		gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
-		eta.c verify.c memory.c io_u.c parse.c mutex.c options.c \
+		eta.c verify.c memory.c io_u.c parse.c fio_sem.c rwlock.c \
+		pshared.c options.c \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
 		engines/ftruncate.c engines/filecreate.c \
@@ -211,7 +212,8 @@ endif
 -include $(OBJS:.o=.d)
 
 T_SMALLOC_OBJS = t/stest.o
-T_SMALLOC_OBJS += gettime.o mutex.o smalloc.o t/log.o t/debug.o t/arch.o
+T_SMALLOC_OBJS += gettime.o fio_sem.o pshared.o smalloc.o t/log.o t/debug.o \
+		  t/arch.o
 T_SMALLOC_PROGS = t/stest
 
 T_IEEE_OBJS = t/ieee754.o
@@ -229,7 +231,8 @@ T_AXMAP_OBJS += lib/lfsr.o lib/axmap.o
 T_AXMAP_PROGS = t/axmap
 
 T_LFSR_TEST_OBJS = t/lfsr-test.o
-T_LFSR_TEST_OBJS += lib/lfsr.o gettime.o t/log.o t/debug.o t/arch.o
+T_LFSR_TEST_OBJS += lib/lfsr.o gettime.o fio_sem.o pshared.o \
+		    t/log.o t/debug.o t/arch.o
 T_LFSR_TEST_PROGS = t/lfsr-test
 
 T_GEN_RAND_OBJS = t/gen-rand.o
@@ -244,9 +247,10 @@ T_BTRACE_FIO_PROGS = t/fio-btrace2fio
 endif
 
 T_DEDUPE_OBJS = t/dedupe.o
-T_DEDUPE_OBJS += lib/rbtree.o t/log.o mutex.o smalloc.o gettime.o crc/md5.o \
-		lib/memalign.o lib/bloom.o t/debug.o crc/xxhash.o t/arch.o \
-		crc/murmur3.o crc/crc32c.o crc/crc32c-intel.o crc/crc32c-arm64.o crc/fnv.o
+T_DEDUPE_OBJS += lib/rbtree.o t/log.o fio_sem.o pshared.o smalloc.o gettime.o \
+		crc/md5.o lib/memalign.o lib/bloom.o t/debug.o crc/xxhash.o \
+		t/arch.o crc/murmur3.o crc/crc32c.o crc/crc32c-intel.o \
+		crc/crc32c-arm64.o crc/fnv.o
 T_DEDUPE_PROGS = t/fio-dedupe
 
 T_VS_OBJS = t/verify-state.o t/log.o crc/crc32c.o crc/crc32c-intel.o crc/crc32c-arm64.o t/debug.o
diff --git a/backend.c b/backend.c
index b4a09ac..d82d494 100644
--- a/backend.c
+++ b/backend.c
@@ -58,8 +58,9 @@
 #include "lib/mountcheck.h"
 #include "rate-submit.h"
 #include "helper_thread.h"
+#include "pshared.h"
 
-static struct fio_mutex *startup_mutex;
+static struct fio_sem *startup_sem;
 static struct flist_head *cgroup_list;
 static char *cgroup_mnt;
 static int exit_value;
@@ -426,7 +427,7 @@ static void check_update_rusage(struct thread_data *td)
 	if (td->update_rusage) {
 		td->update_rusage = 0;
 		update_rusage_stat(td);
-		fio_mutex_up(td->rusage_sem);
+		fio_sem_up(td->rusage_sem);
 	}
 }
 
@@ -1569,11 +1570,11 @@ static void *thread_main(void *data)
 	}
 
 	td_set_runstate(td, TD_INITIALIZED);
-	dprint(FD_MUTEX, "up startup_mutex\n");
-	fio_mutex_up(startup_mutex);
-	dprint(FD_MUTEX, "wait on td->mutex\n");
-	fio_mutex_down(td->mutex);
-	dprint(FD_MUTEX, "done waiting on td->mutex\n");
+	dprint(FD_MUTEX, "up startup_sem\n");
+	fio_sem_up(startup_sem);
+	dprint(FD_MUTEX, "wait on td->sem\n");
+	fio_sem_down(td->sem);
+	dprint(FD_MUTEX, "done waiting on td->sem\n");
 
 	/*
 	 * A new gid requires privilege, so we need to do this before setting
@@ -1802,11 +1803,11 @@ static void *thread_main(void *data)
 		deadlock_loop_cnt = 0;
 		do {
 			check_update_rusage(td);
-			if (!fio_mutex_down_trylock(stat_mutex))
+			if (!fio_sem_down_trylock(stat_sem))
 				break;
 			usleep(1000);
 			if (deadlock_loop_cnt++ > 5000) {
-				log_err("fio seems to be stuck grabbing stat_mutex, forcibly exiting\n");
+				log_err("fio seems to be stuck grabbing stat_sem, forcibly exiting\n");
 				td->error = EDEADLK;
 				goto err;
 			}
@@ -1819,7 +1820,7 @@ static void *thread_main(void *data)
 		if (td_trim(td) && td->io_bytes[DDIR_TRIM])
 			update_runtime(td, elapsed_us, DDIR_TRIM);
 		fio_gettime(&td->start, NULL);
-		fio_mutex_up(stat_mutex);
+		fio_sem_up(stat_sem);
 
 		if (td->error || td->terminate)
 			break;
@@ -1843,10 +1844,10 @@ static void *thread_main(void *data)
 		 */
 		check_update_rusage(td);
 
-		fio_mutex_down(stat_mutex);
+		fio_sem_down(stat_sem);
 		update_runtime(td, elapsed_us, DDIR_READ);
 		fio_gettime(&td->start, NULL);
-		fio_mutex_up(stat_mutex);
+		fio_sem_up(stat_sem);
 
 		if (td->error || td->terminate)
 			break;
@@ -2317,7 +2318,7 @@ reap:
 
 			init_disk_util(td);
 
-			td->rusage_sem = fio_mutex_init(FIO_MUTEX_LOCKED);
+			td->rusage_sem = fio_sem_init(FIO_SEM_LOCKED);
 			td->update_rusage = 0;
 
 			/*
@@ -2362,8 +2363,8 @@ reap:
 				} else if (i == fio_debug_jobno)
 					*fio_debug_jobp = pid;
 			}
-			dprint(FD_MUTEX, "wait on startup_mutex\n");
-			if (fio_mutex_down_timeout(startup_mutex, 10000)) {
+			dprint(FD_MUTEX, "wait on startup_sem\n");
+			if (fio_sem_down_timeout(startup_sem, 10000)) {
 				log_err("fio: job startup hung? exiting.\n");
 				fio_terminate_threads(TERMINATE_ALL);
 				fio_abort = 1;
@@ -2371,7 +2372,7 @@ reap:
 				free(fd);
 				break;
 			}
-			dprint(FD_MUTEX, "done waiting on startup_mutex\n");
+			dprint(FD_MUTEX, "done waiting on startup_sem\n");
 		}
 
 		/*
@@ -2430,7 +2431,7 @@ reap:
 			m_rate += ddir_rw_sum(td->o.ratemin);
 			t_rate += ddir_rw_sum(td->o.rate);
 			todo--;
-			fio_mutex_up(td->mutex);
+			fio_sem_up(td->sem);
 		}
 
 		reap_threads(&nr_running, &t_rate, &m_rate);
@@ -2479,13 +2480,13 @@ int fio_backend(struct sk_out *sk_out)
 		setup_log(&agg_io_log[DDIR_TRIM], &p, "agg-trim_bw.log");
 	}
 
-	startup_mutex = fio_mutex_init(FIO_MUTEX_LOCKED);
-	if (startup_mutex == NULL)
+	startup_sem = fio_sem_init(FIO_SEM_LOCKED);
+	if (startup_sem == NULL)
 		return 1;
 
 	set_genesis_time();
 	stat_init();
-	helper_thread_create(startup_mutex, sk_out);
+	helper_thread_create(startup_sem, sk_out);
 
 	cgroup_list = smalloc(sizeof(*cgroup_list));
 	INIT_FLIST_HEAD(cgroup_list);
@@ -2510,11 +2511,11 @@ int fio_backend(struct sk_out *sk_out)
 		steadystate_free(td);
 		fio_options_free(td);
 		if (td->rusage_sem) {
-			fio_mutex_remove(td->rusage_sem);
+			fio_sem_remove(td->rusage_sem);
 			td->rusage_sem = NULL;
 		}
-		fio_mutex_remove(td->mutex);
-		td->mutex = NULL;
+		fio_sem_remove(td->sem);
+		td->sem = NULL;
 	}
 
 	free_disk_util();
@@ -2522,7 +2523,7 @@ int fio_backend(struct sk_out *sk_out)
 	sfree(cgroup_list);
 	sfree(cgroup_mnt);
 
-	fio_mutex_remove(startup_mutex);
+	fio_sem_remove(startup_sem);
 	stat_exit();
 	return exit_value;
 }
diff --git a/cgroup.c b/cgroup.c
index a297e2a..4fab977 100644
--- a/cgroup.c
+++ b/cgroup.c
@@ -11,7 +11,7 @@
 #include "cgroup.h"
 #include "smalloc.h"
 
-static struct fio_mutex *lock;
+static struct fio_sem *lock;
 
 struct cgroup_member {
 	struct flist_head list;
@@ -70,9 +70,9 @@ err:
 	}
 	if (td->o.cgroup_nodelete)
 		cm->cgroup_nodelete = 1;
-	fio_mutex_down(lock);
+	fio_sem_down(lock);
 	flist_add_tail(&cm->list, clist);
-	fio_mutex_up(lock);
+	fio_sem_up(lock);
 }
 
 void cgroup_kill(struct flist_head *clist)
@@ -83,7 +83,7 @@ void cgroup_kill(struct flist_head *clist)
 	if (!lock)
 		return;
 
-	fio_mutex_down(lock);
+	fio_sem_down(lock);
 
 	flist_for_each_safe(n, tmp, clist) {
 		cm = flist_entry(n, struct cgroup_member, list);
@@ -94,7 +94,7 @@ void cgroup_kill(struct flist_head *clist)
 		sfree(cm);
 	}
 
-	fio_mutex_up(lock);
+	fio_sem_up(lock);
 }
 
 static char *get_cgroup_root(struct thread_data *td, char *mnt)
@@ -198,12 +198,12 @@ void cgroup_shutdown(struct thread_data *td, char **mnt)
 
 static void fio_init cgroup_init(void)
 {
-	lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+	lock = fio_sem_init(FIO_SEM_UNLOCKED);
 	if (!lock)
 		log_err("fio: failed to allocate cgroup lock\n");
 }
 
 static void fio_exit cgroup_exit(void)
 {
-	fio_mutex_remove(lock);
+	fio_sem_remove(lock);
 }
diff --git a/configure b/configure
index f38e9c7..ddf03a6 100755
--- a/configure
+++ b/configure
@@ -2050,6 +2050,24 @@ fi
 print_config "strndup" "$strndup"
 
 ##########################################
+# <valgrind/drd.h> probe
+# Note: presence of <valgrind/drd.h> implies that <valgrind/valgrind.h> is
+# also available but not the other way around.
+if test "$valgrind_dev" != "yes" ; then
+  valgrind_dev="no"
+fi
+cat > $TMPC << EOF
+#include <valgrind/drd.h>
+int main(int argc, char **argv)
+{
+  return 0;
+}
+EOF
+if compile_prog "" "" "valgrind_dev"; then
+  valgrind_dev="yes"
+fi
+print_config "Valgrind headers" "$valgrind_dev"
+
 # check march=armv8-a+crc+crypto
 if test "$march_armv8_a_crc_crypto" != "yes" ; then
   march_armv8_a_crc_crypto="no"
@@ -2354,6 +2372,9 @@ fi
 if test "$disable_opt" = "yes" ; then
   output_sym "CONFIG_DISABLE_OPTIMIZATIONS"
 fi
+if test "$valgrind_dev" = "yes"; then
+  output_sym "CONFIG_VALGRIND_DEV"
+fi
 if test "$zlib" = "no" ; then
   echo "Consider installing zlib-dev (zlib-devel, some fio features depend on it."
   if test "$build_static" = "yes"; then
diff --git a/diskutil.c b/diskutil.c
index 789071d..dd8fc6a 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -8,6 +8,11 @@
 #include <libgen.h>
 #include <math.h>
 #include <assert.h>
+#ifdef CONFIG_VALGRIND_DEV
+#include <valgrind/drd.h>
+#else
+#define DRD_IGNORE_VAR(x) do { } while (0)
+#endif
 
 #include "fio.h"
 #include "smalloc.h"
@@ -17,7 +22,7 @@
 static int last_majdev, last_mindev;
 static struct disk_util *last_du;
 
-static struct fio_mutex *disk_util_mutex;
+static struct fio_sem *disk_util_sem;
 
 static struct disk_util *__init_per_file_disk_util(struct thread_data *td,
 		int majdev, int mindev, char *path);
@@ -35,7 +40,7 @@ static void disk_util_free(struct disk_util *du)
 		slave->users--;
 	}
 
-	fio_mutex_remove(du->lock);
+	fio_sem_remove(du->lock);
 	free(du->sysfs_root);
 	sfree(du);
 }
@@ -120,7 +125,7 @@ int update_io_ticks(void)
 
 	dprint(FD_DISKUTIL, "update io ticks\n");
 
-	fio_mutex_down(disk_util_mutex);
+	fio_sem_down(disk_util_sem);
 
 	if (!helper_should_exit()) {
 		flist_for_each(entry, &disk_list) {
@@ -130,7 +135,7 @@ int update_io_ticks(void)
 	} else
 		ret = 1;
 
-	fio_mutex_up(disk_util_mutex);
+	fio_sem_up(disk_util_sem);
 	return ret;
 }
 
@@ -139,18 +144,18 @@ static struct disk_util *disk_util_exists(int major, int minor)
 	struct flist_head *entry;
 	struct disk_util *du;
 
-	fio_mutex_down(disk_util_mutex);
+	fio_sem_down(disk_util_sem);
 
 	flist_for_each(entry, &disk_list) {
 		du = flist_entry(entry, struct disk_util, list);
 
 		if (major == du->major && minor == du->minor) {
-			fio_mutex_up(disk_util_mutex);
+			fio_sem_up(disk_util_sem);
 			return du;
 		}
 	}
 
-	fio_mutex_up(disk_util_mutex);
+	fio_sem_up(disk_util_sem);
 	return NULL;
 }
 
@@ -297,6 +302,7 @@ static struct disk_util *disk_util_add(struct thread_data *td, int majdev,
 	if (!du)
 		return NULL;
 
+	DRD_IGNORE_VAR(du->users);
 	memset(du, 0, sizeof(*du));
 	INIT_FLIST_HEAD(&du->list);
 	l = snprintf(du->path, sizeof(du->path), "%s/stat", path);
@@ -312,10 +318,10 @@ static struct disk_util *disk_util_add(struct thread_data *td, int majdev,
 	du->minor = mindev;
 	INIT_FLIST_HEAD(&du->slavelist);
 	INIT_FLIST_HEAD(&du->slaves);
-	du->lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+	du->lock = fio_sem_init(FIO_SEM_UNLOCKED);
 	du->users = 0;
 
-	fio_mutex_down(disk_util_mutex);
+	fio_sem_down(disk_util_sem);
 
 	flist_for_each(entry, &disk_list) {
 		__du = flist_entry(entry, struct disk_util, list);
@@ -324,7 +330,7 @@ static struct disk_util *disk_util_add(struct thread_data *td, int majdev,
 
 		if (!strcmp((char *) du->dus.name, (char *) __du->dus.name)) {
 			disk_util_free(du);
-			fio_mutex_up(disk_util_mutex);
+			fio_sem_up(disk_util_sem);
 			return __du;
 		}
 	}
@@ -335,7 +341,7 @@ static struct disk_util *disk_util_add(struct thread_data *td, int majdev,
 	get_io_ticks(du, &du->last_dus);
 
 	flist_add_tail(&du->list, &disk_list);
-	fio_mutex_up(disk_util_mutex);
+	fio_sem_up(disk_util_sem);
 
 	find_add_disk_slaves(td, path, du);
 	return du;
@@ -559,7 +565,7 @@ static void aggregate_slaves_stats(struct disk_util *masterdu)
 
 void disk_util_prune_entries(void)
 {
-	fio_mutex_down(disk_util_mutex);
+	fio_sem_down(disk_util_sem);
 
 	while (!flist_empty(&disk_list)) {
 		struct disk_util *du;
@@ -570,8 +576,8 @@ void disk_util_prune_entries(void)
 	}
 
 	last_majdev = last_mindev = -1;
-	fio_mutex_up(disk_util_mutex);
-	fio_mutex_remove(disk_util_mutex);
+	fio_sem_up(disk_util_sem);
+	fio_sem_remove(disk_util_sem);
 }
 
 void print_disk_util(struct disk_util_stat *dus, struct disk_util_agg *agg,
@@ -693,13 +699,13 @@ void show_disk_util(int terse, struct json_object *parent,
 	struct disk_util *du;
 	bool do_json;
 
-	if (!disk_util_mutex)
+	if (!disk_util_sem)
 		return;
 
-	fio_mutex_down(disk_util_mutex);
+	fio_sem_down(disk_util_sem);
 
 	if (flist_empty(&disk_list)) {
-		fio_mutex_up(disk_util_mutex);
+		fio_sem_up(disk_util_sem);
 		return;
 	}
 
@@ -722,10 +728,10 @@ void show_disk_util(int terse, struct json_object *parent,
 		}
 	}
 
-	fio_mutex_up(disk_util_mutex);
+	fio_sem_up(disk_util_sem);
 }
 
 void setup_disk_util(void)
 {
-	disk_util_mutex = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+	disk_util_sem = fio_sem_init(FIO_SEM_UNLOCKED);
 }
diff --git a/diskutil.h b/diskutil.h
index 91b4202..c103578 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -5,6 +5,7 @@
 
 #include "lib/output_buffer.h"
 #include "helper_thread.h"
+#include "fio_sem.h"
 
 struct disk_util_stats {
 	uint64_t ios[2];
@@ -66,7 +67,7 @@ struct disk_util {
 
 	struct timespec time;
 
-	struct fio_mutex *lock;
+	struct fio_sem *lock;
 	unsigned long users;
 };
 
@@ -75,7 +76,7 @@ static inline void disk_util_mod(struct disk_util *du, int val)
 	if (du) {
 		struct flist_head *n;
 
-		fio_mutex_down(du->lock);
+		fio_sem_down(du->lock);
 		du->users += val;
 
 		flist_for_each(n, &du->slavelist) {
@@ -84,7 +85,7 @@ static inline void disk_util_mod(struct disk_util *du, int val)
 			slave = flist_entry(n, struct disk_util, slavelist);
 			slave->users += val;
 		}
-		fio_mutex_up(du->lock);
+		fio_sem_up(du->lock);
 	}
 }
 static inline void disk_util_inc(struct disk_util *du)
diff --git a/engines/sg.c b/engines/sg.c
index 4540b57..f240755 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -12,9 +12,43 @@
 #include <sys/poll.h>
 
 #include "../fio.h"
+#include "../optgroup.h"
 
 #ifdef FIO_HAVE_SGIO
 
+
+struct sg_options {
+	void *pad;
+	unsigned int readfua;
+	unsigned int writefua;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	= "readfua",
+		.lname	= "sg engine read fua flag support",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct sg_options, readfua),
+		.help	= "Set FUA flag (force unit access) for all Read operations",
+		.def	= "0",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_SG,
+	},
+	{
+		.name	= "writefua",
+		.lname	= "sg engine write fua flag support",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct sg_options, writefua),
+		.help	= "Set FUA flag (force unit access) for all Write operations",
+		.def	= "0",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_SG,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
 #define MAX_10B_LBA  0xFFFFFFFFULL
 #define SCSI_TIMEOUT_MS 30000   // 30 second timeout; currently no method to override
 #define MAX_SB 64               // sense block maximum return size
@@ -267,6 +301,7 @@ static int fio_sgio_doio(struct thread_data *td, struct io_u *io_u, int do_sync)
 static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct sg_io_hdr *hdr = &io_u->hdr;
+	struct sg_options *o = td->eo;
 	struct sgio_data *sd = td->io_ops_data;
 	long long nr_blocks, lba;
 
@@ -286,6 +321,10 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 			hdr->cmdp[0] = 0x28; // read(10)
 		else
 			hdr->cmdp[0] = 0x88; // read(16)
+
+		if (o->readfua)
+			hdr->cmdp[1] |= 0x08;
+
 	} else if (io_u->ddir == DDIR_WRITE) {
 		sgio_hdr_init(sd, hdr, io_u, 1);
 
@@ -294,6 +333,10 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 			hdr->cmdp[0] = 0x2a; // write(10)
 		else
 			hdr->cmdp[0] = 0x8a; // write(16)
+
+		if (o->writefua)
+			hdr->cmdp[1] |= 0x08;
+
 	} else {
 		sgio_hdr_init(sd, hdr, io_u, 0);
 		hdr->dxfer_direction = SG_DXFER_NONE;
@@ -822,6 +865,8 @@ static struct ioengine_ops ioengine = {
 	.close_file	= generic_close_file,
 	.get_file_size	= fio_sgio_get_file_size,
 	.flags		= FIO_SYNCIO | FIO_RAWIO,
+	.options	= options,
+	.option_struct_size	= sizeof(struct sg_options)
 };
 
 #else /* FIO_HAVE_SGIO */
diff --git a/eta.c b/eta.c
index 0b79526..3126f21 100644
--- a/eta.c
+++ b/eta.c
@@ -4,6 +4,11 @@
 #include <unistd.h>
 #include <fcntl.h>
 #include <string.h>
+#ifdef CONFIG_VALGRIND_DEV
+#include <valgrind/drd.h>
+#else
+#define DRD_IGNORE_VAR(x) do { } while (0)
+#endif
 
 #include "fio.h"
 #include "lib/pow2.h"
@@ -668,6 +673,7 @@ void print_thread_status(void)
 
 void print_status_init(int thr_number)
 {
+	DRD_IGNORE_VAR(__run_str);
 	__run_str[thr_number] = 'P';
 	update_condensed_str(__run_str, run_str);
 }
diff --git a/file.h b/file.h
index cc721ee..8fd34b1 100644
--- a/file.h
+++ b/file.h
@@ -125,7 +125,7 @@ struct fio_file {
 	 * if io is protected by a semaphore, this is set
 	 */
 	union {
-		struct fio_mutex *lock;
+		struct fio_sem *lock;
 		struct fio_rwlock *rwlock;
 	};
 
diff --git a/filehash.c b/filehash.c
index edeeab4..b55ab73 100644
--- a/filehash.c
+++ b/filehash.c
@@ -16,7 +16,7 @@
 static unsigned int file_hash_size = HASH_BUCKETS * sizeof(struct flist_head);
 
 static struct flist_head *file_hash;
-static struct fio_mutex *hash_lock;
+static struct fio_sem *hash_lock;
 static struct bloom *file_bloom;
 
 static unsigned short hash(const char *name)
@@ -27,18 +27,18 @@ static unsigned short hash(const char *name)
 void fio_file_hash_lock(void)
 {
 	if (hash_lock)
-		fio_mutex_down(hash_lock);
+		fio_sem_down(hash_lock);
 }
 
 void fio_file_hash_unlock(void)
 {
 	if (hash_lock)
-		fio_mutex_up(hash_lock);
+		fio_sem_up(hash_lock);
 }
 
 void remove_file_hash(struct fio_file *f)
 {
-	fio_mutex_down(hash_lock);
+	fio_sem_down(hash_lock);
 
 	if (fio_file_hashed(f)) {
 		assert(!flist_empty(&f->hash_list));
@@ -46,7 +46,7 @@ void remove_file_hash(struct fio_file *f)
 		fio_file_clear_hashed(f);
 	}
 
-	fio_mutex_up(hash_lock);
+	fio_sem_up(hash_lock);
 }
 
 static struct fio_file *__lookup_file_hash(const char *name)
@@ -73,9 +73,9 @@ struct fio_file *lookup_file_hash(const char *name)
 {
 	struct fio_file *f;
 
-	fio_mutex_down(hash_lock);
+	fio_sem_down(hash_lock);
 	f = __lookup_file_hash(name);
-	fio_mutex_up(hash_lock);
+	fio_sem_up(hash_lock);
 	return f;
 }
 
@@ -88,7 +88,7 @@ struct fio_file *add_file_hash(struct fio_file *f)
 
 	INIT_FLIST_HEAD(&f->hash_list);
 
-	fio_mutex_down(hash_lock);
+	fio_sem_down(hash_lock);
 
 	alias = __lookup_file_hash(f->file_name);
 	if (!alias) {
@@ -96,7 +96,7 @@ struct fio_file *add_file_hash(struct fio_file *f)
 		flist_add_tail(&f->hash_list, &file_hash[hash(f->file_name)]);
 	}
 
-	fio_mutex_up(hash_lock);
+	fio_sem_up(hash_lock);
 	return alias;
 }
 
@@ -109,17 +109,17 @@ void file_hash_exit(void)
 {
 	unsigned int i, has_entries = 0;
 
-	fio_mutex_down(hash_lock);
+	fio_sem_down(hash_lock);
 	for (i = 0; i < HASH_BUCKETS; i++)
 		has_entries += !flist_empty(&file_hash[i]);
-	fio_mutex_up(hash_lock);
+	fio_sem_up(hash_lock);
 
 	if (has_entries)
 		log_err("fio: file hash not empty on exit\n");
 
 	sfree(file_hash);
 	file_hash = NULL;
-	fio_mutex_remove(hash_lock);
+	fio_sem_remove(hash_lock);
 	hash_lock = NULL;
 	bloom_free(file_bloom);
 	file_bloom = NULL;
@@ -134,6 +134,6 @@ void file_hash_init(void)
 	for (i = 0; i < HASH_BUCKETS; i++)
 		INIT_FLIST_HEAD(&file_hash[i]);
 
-	hash_lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+	hash_lock = fio_sem_init(FIO_SEM_UNLOCKED);
 	file_bloom = bloom_new(BLOOM_SIZE);
 }
diff --git a/filelock.c b/filelock.c
index 6e84970..cc98aaf 100644
--- a/filelock.c
+++ b/filelock.c
@@ -11,13 +11,13 @@
 #include "flist.h"
 #include "filelock.h"
 #include "smalloc.h"
-#include "mutex.h"
+#include "fio_sem.h"
 #include "hash.h"
 #include "log.h"
 
 struct fio_filelock {
 	uint32_t hash;
-	struct fio_mutex lock;
+	struct fio_sem lock;
 	struct flist_head list;
 	unsigned int references;
 };
@@ -26,7 +26,7 @@ struct fio_filelock {
 	
 static struct filelock_data {
 	struct flist_head list;
-	struct fio_mutex lock;
+	struct fio_sem lock;
 
 	struct flist_head free_list;
 	struct fio_filelock ffs[MAX_FILELOCKS];
@@ -58,9 +58,9 @@ static struct fio_filelock *get_filelock(int trylock, int *retry)
 		if (ff || trylock)
 			break;
 
-		fio_mutex_up(&fld->lock);
+		fio_sem_up(&fld->lock);
 		usleep(1000);
-		fio_mutex_down(&fld->lock);
+		fio_sem_down(&fld->lock);
 		*retry = 1;
 	} while (1);
 
@@ -78,13 +78,13 @@ int fio_filelock_init(void)
 	INIT_FLIST_HEAD(&fld->list);
 	INIT_FLIST_HEAD(&fld->free_list);
 
-	if (__fio_mutex_init(&fld->lock, FIO_MUTEX_UNLOCKED))
+	if (__fio_sem_init(&fld->lock, FIO_SEM_UNLOCKED))
 		goto err;
 
 	for (i = 0; i < MAX_FILELOCKS; i++) {
 		struct fio_filelock *ff = &fld->ffs[i];
 
-		if (__fio_mutex_init(&ff->lock, FIO_MUTEX_UNLOCKED))
+		if (__fio_sem_init(&ff->lock, FIO_SEM_UNLOCKED))
 			goto err;
 		flist_add_tail(&ff->list, &fld->free_list);
 	}
@@ -101,7 +101,7 @@ void fio_filelock_exit(void)
 		return;
 
 	assert(flist_empty(&fld->list));
-	__fio_mutex_remove(&fld->lock);
+	__fio_sem_remove(&fld->lock);
 
 	while (!flist_empty(&fld->free_list)) {
 		struct fio_filelock *ff;
@@ -109,7 +109,7 @@ void fio_filelock_exit(void)
 		ff = flist_first_entry(&fld->free_list, struct fio_filelock, list);
 
 		flist_del_init(&ff->list);
-		__fio_mutex_remove(&ff->lock);
+		__fio_sem_remove(&ff->lock);
 	}
 
 	sfree(fld);
@@ -172,11 +172,11 @@ static bool __fio_lock_file(const char *fname, int trylock)
 
 	hash = jhash(fname, strlen(fname), 0);
 
-	fio_mutex_down(&fld->lock);
+	fio_sem_down(&fld->lock);
 	ff = fio_hash_get(hash, trylock);
 	if (ff)
 		ff->references++;
-	fio_mutex_up(&fld->lock);
+	fio_sem_up(&fld->lock);
 
 	if (!ff) {
 		assert(!trylock);
@@ -184,14 +184,14 @@ static bool __fio_lock_file(const char *fname, int trylock)
 	}
 
 	if (!trylock) {
-		fio_mutex_down(&ff->lock);
+		fio_sem_down(&ff->lock);
 		return false;
 	}
 
-	if (!fio_mutex_down_trylock(&ff->lock))
+	if (!fio_sem_down_trylock(&ff->lock))
 		return false;
 
-	fio_mutex_down(&fld->lock);
+	fio_sem_down(&fld->lock);
 
 	/*
 	 * If we raced and the only reference to the lock is us, we can
@@ -202,10 +202,10 @@ static bool __fio_lock_file(const char *fname, int trylock)
 		ff = NULL;
 	}
 
-	fio_mutex_up(&fld->lock);
+	fio_sem_up(&fld->lock);
 
 	if (ff) {
-		fio_mutex_down(&ff->lock);
+		fio_sem_down(&ff->lock);
 		return false;
 	}
 
@@ -229,12 +229,12 @@ void fio_unlock_file(const char *fname)
 
 	hash = jhash(fname, strlen(fname), 0);
 
-	fio_mutex_down(&fld->lock);
+	fio_sem_down(&fld->lock);
 
 	ff = fio_hash_find(hash);
 	if (ff) {
 		int refs = --ff->references;
-		fio_mutex_up(&ff->lock);
+		fio_sem_up(&ff->lock);
 		if (!refs) {
 			flist_del_init(&ff->list);
 			put_filelock(ff);
@@ -242,5 +242,5 @@ void fio_unlock_file(const char *fname)
 	} else
 		log_err("fio: file not found for unlocking\n");
 
-	fio_mutex_up(&fld->lock);
+	fio_sem_up(&fld->lock);
 }
diff --git a/filesetup.c b/filesetup.c
index 1a187ff..7cbce13 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -15,6 +15,7 @@
 #include "os/os.h"
 #include "hash.h"
 #include "lib/axmap.h"
+#include "rwlock.h"
 
 #ifdef CONFIG_LINUX_FALLOCATE
 #include <linux/falloc.h>
@@ -1621,7 +1622,7 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 		f->rwlock = fio_rwlock_init();
 		break;
 	case FILE_LOCK_EXCLUSIVE:
-		f->lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+		f->lock = fio_sem_init(FIO_SEM_UNLOCKED);
 		break;
 	default:
 		log_err("fio: unknown lock mode: %d\n", td->o.file_lock_mode);
@@ -1706,7 +1707,7 @@ void lock_file(struct thread_data *td, struct fio_file *f, enum fio_ddir ddir)
 		else
 			fio_rwlock_write(f->rwlock);
 	} else if (td->o.file_lock_mode == FILE_LOCK_EXCLUSIVE)
-		fio_mutex_down(f->lock);
+		fio_sem_down(f->lock);
 
 	td->file_locks[f->fileno] = td->o.file_lock_mode;
 }
@@ -1719,7 +1720,7 @@ void unlock_file(struct thread_data *td, struct fio_file *f)
 	if (td->o.file_lock_mode == FILE_LOCK_READWRITE)
 		fio_rwlock_unlock(f->rwlock);
 	else if (td->o.file_lock_mode == FILE_LOCK_EXCLUSIVE)
-		fio_mutex_up(f->lock);
+		fio_sem_up(f->lock);
 
 	td->file_locks[f->fileno] = FILE_LOCK_NONE;
 }
diff --git a/fio.1 b/fio.1
index f955167..5ca57ce 100644
--- a/fio.1
+++ b/fio.1
@@ -1523,7 +1523,7 @@ SCSI generic sg v3 I/O. May either be synchronous using the SG_IO
 ioctl, or if the target is an sg character device we use
 \fBread\fR\|(2) and \fBwrite\fR\|(2) for asynchronous
 I/O. Requires \fBfilename\fR option to specify either block or
-character devices.
+character devices. The sg engine includes engine specific options.
 .TP
 .B null
 Doesn't transfer any data, just pretends to. This is mainly used to
@@ -1820,6 +1820,14 @@ server side this will be passed into the rdma_bind_addr() function and
 on the client site it will be used in the rdma_resolve_add()
 function. This can be useful when multiple paths exist between the
 client and the server or in certain loopback configurations.
+.TP
+.BI (sg)readfua \fR=\fPbool
+With readfua option set to 1, read operations include the force
+unit access (fua) flag. Default: 0.
+.TP
+.BI (sg)writefua \fR=\fPbool
+With writefua option set to 1, write operations include the force
+unit access (fua) flag. Default: 0.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
diff --git a/fio.h b/fio.h
index 85546c5..9551048 100644
--- a/fio.h
+++ b/fio.h
@@ -20,7 +20,6 @@
 #include "fifo.h"
 #include "arch/arch.h"
 #include "os/os.h"
-#include "mutex.h"
 #include "log.h"
 #include "debug.h"
 #include "file.h"
@@ -63,6 +62,8 @@
 #include <cuda.h>
 #endif
 
+struct fio_sem;
+
 /*
  * offset generator types
  */
@@ -198,7 +199,7 @@ struct thread_data {
 	struct timespec iops_sample_time;
 
 	volatile int update_rusage;
-	struct fio_mutex *rusage_sem;
+	struct fio_sem *rusage_sem;
 	struct rusage ru_start;
 	struct rusage ru_end;
 
@@ -341,7 +342,7 @@ struct thread_data {
 	uint64_t this_io_bytes[DDIR_RWDIR_CNT];
 	uint64_t io_skip_bytes;
 	uint64_t zone_bytes;
-	struct fio_mutex *mutex;
+	struct fio_sem *sem;
 	uint64_t bytes_done[DDIR_RWDIR_CNT];
 
 	/*
diff --git a/fio_sem.c b/fio_sem.c
new file mode 100644
index 0000000..20fcfcc
--- /dev/null
+++ b/fio_sem.c
@@ -0,0 +1,178 @@
+#include <string.h>
+#include <sys/mman.h>
+#include <assert.h>
+#ifdef CONFIG_VALGRIND_DEV
+#include <valgrind/valgrind.h>
+#else
+#define RUNNING_ON_VALGRIND 0
+#endif
+
+#include "log.h"
+#include "fio_sem.h"
+#include "pshared.h"
+#include "os/os.h"
+#include "fio_time.h"
+#include "gettime.h"
+
+void __fio_sem_remove(struct fio_sem *sem)
+{
+	assert(sem->magic == FIO_SEM_MAGIC);
+	pthread_mutex_destroy(&sem->lock);
+	pthread_cond_destroy(&sem->cond);
+
+	/*
+	 * When not running on Valgrind, ensure any subsequent attempt to grab
+	 * this semaphore will fail with an assert, instead of just silently
+	 * hanging. When running on Valgrind, let Valgrind detect
+	 * use-after-free.
+         */
+	if (!RUNNING_ON_VALGRIND)
+		memset(sem, 0, sizeof(*sem));
+}
+
+void fio_sem_remove(struct fio_sem *sem)
+{
+	__fio_sem_remove(sem);
+	munmap((void *) sem, sizeof(*sem));
+}
+
+int __fio_sem_init(struct fio_sem *sem, int value)
+{
+	int ret;
+
+	sem->value = value;
+	/* Initialize .waiters explicitly for Valgrind. */
+	sem->waiters = 0;
+	sem->magic = FIO_SEM_MAGIC;
+
+	ret = mutex_cond_init_pshared(&sem->lock, &sem->cond);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+struct fio_sem *fio_sem_init(int value)
+{
+	struct fio_sem *sem = NULL;
+
+	sem = (void *) mmap(NULL, sizeof(struct fio_sem),
+				PROT_READ | PROT_WRITE,
+				OS_MAP_ANON | MAP_SHARED, -1, 0);
+	if (sem == MAP_FAILED) {
+		perror("mmap semaphore");
+		return NULL;
+	}
+
+	if (!__fio_sem_init(sem, value))
+		return sem;
+
+	fio_sem_remove(sem);
+	return NULL;
+}
+
+static bool sem_timed_out(struct timespec *t, unsigned int msecs)
+{
+	struct timeval tv;
+	struct timespec now;
+
+	gettimeofday(&tv, NULL);
+	now.tv_sec = tv.tv_sec;
+	now.tv_nsec = tv.tv_usec * 1000;
+
+	return mtime_since(t, &now) >= msecs;
+}
+
+int fio_sem_down_timeout(struct fio_sem *sem, unsigned int msecs)
+{
+	struct timeval tv_s;
+	struct timespec base;
+	struct timespec t;
+	int ret = 0;
+
+	assert(sem->magic == FIO_SEM_MAGIC);
+
+	gettimeofday(&tv_s, NULL);
+	base.tv_sec = t.tv_sec = tv_s.tv_sec;
+	base.tv_nsec = t.tv_nsec = tv_s.tv_usec * 1000;
+
+	t.tv_sec += msecs / 1000;
+	t.tv_nsec += ((msecs * 1000000ULL) % 1000000000);
+	if (t.tv_nsec >= 1000000000) {
+		t.tv_nsec -= 1000000000;
+		t.tv_sec++;
+	}
+
+	pthread_mutex_lock(&sem->lock);
+
+	sem->waiters++;
+	while (!sem->value && !ret) {
+		/*
+		 * Some platforms (FreeBSD 9?) seems to return timed out
+		 * way too early, double check.
+		 */
+		ret = pthread_cond_timedwait(&sem->cond, &sem->lock, &t);
+		if (ret == ETIMEDOUT && !sem_timed_out(&base, msecs))
+			ret = 0;
+	}
+	sem->waiters--;
+
+	if (!ret) {
+		sem->value--;
+		pthread_mutex_unlock(&sem->lock);
+		return 0;
+	}
+
+	pthread_mutex_unlock(&sem->lock);
+	return ret;
+}
+
+bool fio_sem_down_trylock(struct fio_sem *sem)
+{
+	bool ret = true;
+
+	assert(sem->magic == FIO_SEM_MAGIC);
+
+	pthread_mutex_lock(&sem->lock);
+	if (sem->value) {
+		sem->value--;
+		ret = false;
+	}
+	pthread_mutex_unlock(&sem->lock);
+
+	return ret;
+}
+
+void fio_sem_down(struct fio_sem *sem)
+{
+	assert(sem->magic == FIO_SEM_MAGIC);
+
+	pthread_mutex_lock(&sem->lock);
+
+	while (!sem->value) {
+		sem->waiters++;
+		pthread_cond_wait(&sem->cond, &sem->lock);
+		sem->waiters--;
+	}
+
+	sem->value--;
+	pthread_mutex_unlock(&sem->lock);
+}
+
+void fio_sem_up(struct fio_sem *sem)
+{
+	int do_wake = 0;
+
+	assert(sem->magic == FIO_SEM_MAGIC);
+
+	pthread_mutex_lock(&sem->lock);
+	read_barrier();
+	if (!sem->value && sem->waiters)
+		do_wake = 1;
+	sem->value++;
+
+	if (do_wake)
+		pthread_cond_signal(&sem->cond);
+
+	pthread_mutex_unlock(&sem->lock);
+}
diff --git a/fio_sem.h b/fio_sem.h
new file mode 100644
index 0000000..a796ddd
--- /dev/null
+++ b/fio_sem.h
@@ -0,0 +1,31 @@
+#ifndef FIO_SEM_H
+#define FIO_SEM_H
+
+#include <pthread.h>
+#include "lib/types.h"
+
+#define FIO_SEM_MAGIC		0x4d555445U
+
+struct fio_sem {
+	pthread_mutex_t lock;
+	pthread_cond_t cond;
+	int value;
+	int waiters;
+	int magic;
+};
+
+enum {
+	FIO_SEM_LOCKED	= 0,
+	FIO_SEM_UNLOCKED	= 1,
+};
+
+extern int __fio_sem_init(struct fio_sem *, int);
+extern struct fio_sem *fio_sem_init(int);
+extern void __fio_sem_remove(struct fio_sem *);
+extern void fio_sem_remove(struct fio_sem *);
+extern void fio_sem_up(struct fio_sem *);
+extern void fio_sem_down(struct fio_sem *);
+extern bool fio_sem_down_trylock(struct fio_sem *);
+extern int fio_sem_down_timeout(struct fio_sem *, unsigned int);
+
+#endif
diff --git a/flow.c b/flow.c
index 384187e..a8dbfb9 100644
--- a/flow.c
+++ b/flow.c
@@ -1,5 +1,5 @@
 #include "fio.h"
-#include "mutex.h"
+#include "fio_sem.h"
 #include "smalloc.h"
 #include "flist.h"
 
@@ -11,7 +11,7 @@ struct fio_flow {
 };
 
 static struct flist_head *flow_list;
-static struct fio_mutex *flow_lock;
+static struct fio_sem *flow_lock;
 
 int flow_threshold_exceeded(struct thread_data *td)
 {
@@ -49,7 +49,7 @@ static struct fio_flow *flow_get(unsigned int id)
 	if (!flow_lock)
 		return NULL;
 
-	fio_mutex_down(flow_lock);
+	fio_sem_down(flow_lock);
 
 	flist_for_each(n, flow_list) {
 		flow = flist_entry(n, struct fio_flow, list);
@@ -62,7 +62,7 @@ static struct fio_flow *flow_get(unsigned int id)
 	if (!flow) {
 		flow = smalloc(sizeof(*flow));
 		if (!flow) {
-			fio_mutex_up(flow_lock);
+			fio_sem_up(flow_lock);
 			return NULL;
 		}
 		flow->refs = 0;
@@ -74,7 +74,7 @@ static struct fio_flow *flow_get(unsigned int id)
 	}
 
 	flow->refs++;
-	fio_mutex_up(flow_lock);
+	fio_sem_up(flow_lock);
 	return flow;
 }
 
@@ -83,14 +83,14 @@ static void flow_put(struct fio_flow *flow)
 	if (!flow_lock)
 		return;
 
-	fio_mutex_down(flow_lock);
+	fio_sem_down(flow_lock);
 
 	if (!--flow->refs) {
 		flist_del(&flow->list);
 		sfree(flow);
 	}
 
-	fio_mutex_up(flow_lock);
+	fio_sem_up(flow_lock);
 }
 
 void flow_init_job(struct thread_data *td)
@@ -115,7 +115,7 @@ void flow_init(void)
 		return;
 	}
 
-	flow_lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+	flow_lock = fio_sem_init(FIO_SEM_UNLOCKED);
 	if (!flow_lock) {
 		log_err("fio: failed to allocate flow lock\n");
 		sfree(flow_list);
@@ -128,7 +128,7 @@ void flow_init(void)
 void flow_exit(void)
 {
 	if (flow_lock)
-		fio_mutex_remove(flow_lock);
+		fio_sem_remove(flow_lock);
 	if (flow_list)
 		sfree(flow_list);
 }
diff --git a/gettime-thread.c b/gettime-thread.c
index fc52236..87f5060 100644
--- a/gettime-thread.c
+++ b/gettime-thread.c
@@ -35,18 +35,18 @@ static void fio_gtod_update(void)
 }
 
 struct gtod_cpu_data {
-	struct fio_mutex *mutex;
+	struct fio_sem *sem;
 	unsigned int cpu;
 };
 
 static void *gtod_thread_main(void *data)
 {
-	struct fio_mutex *mutex = data;
+	struct fio_sem *sem = data;
 	int ret;
 
 	ret = fio_setaffinity(gettid(), fio_gtod_cpumask);
 
-	fio_mutex_up(mutex);
+	fio_sem_up(sem);
 
 	if (ret == -1) {
 		log_err("gtod: setaffinity failed\n");
@@ -69,17 +69,17 @@ static void *gtod_thread_main(void *data)
 
 int fio_start_gtod_thread(void)
 {
-	struct fio_mutex *mutex;
+	struct fio_sem *sem;
 	pthread_attr_t attr;
 	int ret;
 
-	mutex = fio_mutex_init(FIO_MUTEX_LOCKED);
-	if (!mutex)
+	sem = fio_sem_init(FIO_SEM_LOCKED);
+	if (!sem)
 		return 1;
 
 	pthread_attr_init(&attr);
 	pthread_attr_setstacksize(&attr, 2 * PTHREAD_STACK_MIN);
-	ret = pthread_create(&gtod_thread, &attr, gtod_thread_main, mutex);
+	ret = pthread_create(&gtod_thread, &attr, gtod_thread_main, sem);
 	pthread_attr_destroy(&attr);
 	if (ret) {
 		log_err("Can't create gtod thread: %s\n", strerror(ret));
@@ -92,11 +92,11 @@ int fio_start_gtod_thread(void)
 		goto err;
 	}
 
-	dprint(FD_MUTEX, "wait on startup_mutex\n");
-	fio_mutex_down(mutex);
-	dprint(FD_MUTEX, "done waiting on startup_mutex\n");
+	dprint(FD_MUTEX, "wait on startup_sem\n");
+	fio_sem_down(sem);
+	dprint(FD_MUTEX, "done waiting on startup_sem\n");
 err:
-	fio_mutex_remove(mutex);
+	fio_sem_remove(sem);
 	return ret;
 }
 
diff --git a/gettime.c b/gettime.c
index c256a96..57c66f7 100644
--- a/gettime.c
+++ b/gettime.c
@@ -8,6 +8,7 @@
 #include <time.h>
 
 #include "fio.h"
+#include "fio_sem.h"
 #include "smalloc.h"
 
 #include "hash.h"
@@ -563,8 +564,7 @@ struct clock_thread {
 	pthread_t thread;
 	int cpu;
 	int debug;
-	pthread_mutex_t lock;
-	pthread_mutex_t started;
+	struct fio_sem lock;
 	unsigned long nr_entries;
 	uint32_t *seq;
 	struct clock_entry *entries;
@@ -600,8 +600,7 @@ static void *clock_thread_fn(void *data)
 		goto err;
 	}
 
-	pthread_mutex_lock(&t->lock);
-	pthread_mutex_unlock(&t->started);
+	fio_sem_down(&t->lock);
 
 	first = get_cpu_clock();
 	c = &t->entries[0];
@@ -702,9 +701,7 @@ int fio_monotonic_clocktest(int debug)
 		t->seq = &seq;
 		t->nr_entries = nr_entries;
 		t->entries = &entries[i * nr_entries];
-		pthread_mutex_init(&t->lock, NULL);
-		pthread_mutex_init(&t->started, NULL);
-		pthread_mutex_lock(&t->lock);
+		__fio_sem_init(&t->lock, FIO_SEM_LOCKED);
 		if (pthread_create(&t->thread, NULL, clock_thread_fn, t)) {
 			failed++;
 			nr_cpus = i;
@@ -715,13 +712,7 @@ int fio_monotonic_clocktest(int debug)
 	for (i = 0; i < nr_cpus; i++) {
 		struct clock_thread *t = &cthreads[i];
 
-		pthread_mutex_lock(&t->started);
-	}
-
-	for (i = 0; i < nr_cpus; i++) {
-		struct clock_thread *t = &cthreads[i];
-
-		pthread_mutex_unlock(&t->lock);
+		fio_sem_up(&t->lock);
 	}
 
 	for (i = 0; i < nr_cpus; i++) {
@@ -731,6 +722,7 @@ int fio_monotonic_clocktest(int debug)
 		pthread_join(t->thread, &ret);
 		if (ret)
 			failed++;
+		__fio_sem_remove(&t->lock);
 	}
 	free(cthreads);
 
diff --git a/helper_thread.c b/helper_thread.c
index b05f821..f0c717f 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -1,7 +1,14 @@
+#ifdef CONFIG_VALGRIND_DEV
+#include <valgrind/drd.h>
+#else
+#define DRD_IGNORE_VAR(x) do { } while (0)
+#endif
+
 #include "fio.h"
 #include "smalloc.h"
 #include "helper_thread.h"
 #include "steadystate.h"
+#include "pshared.h"
 
 static struct helper_data {
 	volatile int exit;
@@ -11,7 +18,7 @@ static struct helper_data {
 	pthread_t thread;
 	pthread_mutex_t lock;
 	pthread_cond_t cond;
-	struct fio_mutex *startup_mutex;
+	struct fio_sem *startup_sem;
 } *helper_data;
 
 void helper_thread_destroy(void)
@@ -83,7 +90,7 @@ static void *helper_thread_main(void *data)
 	memcpy(&last_du, &ts, sizeof(ts));
 	memcpy(&last_ss, &ts, sizeof(ts));
 
-	fio_mutex_up(hd->startup_mutex);
+	fio_sem_up(hd->startup_sem);
 
 	msec_to_next_event = DISK_UTIL_MSEC;
 	while (!ret && !hd->exit) {
@@ -151,7 +158,7 @@ static void *helper_thread_main(void *data)
 	return NULL;
 }
 
-int helper_thread_create(struct fio_mutex *startup_mutex, struct sk_out *sk_out)
+int helper_thread_create(struct fio_sem *startup_sem, struct sk_out *sk_out)
 {
 	struct helper_data *hd;
 	int ret;
@@ -167,7 +174,9 @@ int helper_thread_create(struct fio_mutex *startup_mutex, struct sk_out *sk_out)
 	if (ret)
 		return 1;
 
-	hd->startup_mutex = startup_mutex;
+	hd->startup_sem = startup_sem;
+
+	DRD_IGNORE_VAR(helper_data);
 
 	ret = pthread_create(&hd->thread, NULL, helper_thread_main, hd);
 	if (ret) {
@@ -177,8 +186,8 @@ int helper_thread_create(struct fio_mutex *startup_mutex, struct sk_out *sk_out)
 
 	helper_data = hd;
 
-	dprint(FD_MUTEX, "wait on startup_mutex\n");
-	fio_mutex_down(startup_mutex);
-	dprint(FD_MUTEX, "done waiting on startup_mutex\n");
+	dprint(FD_MUTEX, "wait on startup_sem\n");
+	fio_sem_down(startup_sem);
+	dprint(FD_MUTEX, "done waiting on startup_sem\n");
 	return 0;
 }
diff --git a/helper_thread.h b/helper_thread.h
index 78933b1..d7df6c4 100644
--- a/helper_thread.h
+++ b/helper_thread.h
@@ -6,6 +6,6 @@ extern void helper_do_stat(void);
 extern bool helper_should_exit(void);
 extern void helper_thread_destroy(void);
 extern void helper_thread_exit(void);
-extern int helper_thread_create(struct fio_mutex *, struct sk_out *);
+extern int helper_thread_create(struct fio_sem *, struct sk_out *);
 
 #endif
diff --git a/init.c b/init.c
index bb0627b..e47e538 100644
--- a/init.c
+++ b/init.c
@@ -12,6 +12,11 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <dlfcn.h>
+#ifdef CONFIG_VALGRIND_DEV
+#include <valgrind/drd.h>
+#else
+#define DRD_IGNORE_VAR(x) do { } while (0)
+#endif
 
 #include "fio.h"
 #ifndef FIO_NO_HAVE_SHM_H
@@ -333,6 +338,8 @@ static void free_shm(void)
  */
 static int setup_thread_area(void)
 {
+	int i;
+
 	if (threads)
 		return 0;
 
@@ -376,6 +383,8 @@ static int setup_thread_area(void)
 #endif
 
 	memset(threads, 0, max_jobs * sizeof(struct thread_data));
+	for (i = 0; i < max_jobs; i++)
+		DRD_IGNORE_VAR(threads[i]);
 	fio_debug_jobp = (unsigned int *)(threads + max_jobs);
 	*fio_debug_jobp = -1;
 	fio_warned = fio_debug_jobp + 1;
@@ -1471,7 +1480,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			f->real_file_size = -1ULL;
 	}
 
-	td->mutex = fio_mutex_init(FIO_MUTEX_LOCKED);
+	td->sem = fio_sem_init(FIO_SEM_LOCKED);
 
 	td->ts.clat_percentiles = o->clat_percentiles;
 	td->ts.lat_percentiles = o->lat_percentiles;
diff --git a/io_u.c b/io_u.c
index 01b3693..f3b5932 100644
--- a/io_u.c
+++ b/io_u.c
@@ -856,8 +856,8 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
 		assert(!(td->flags & TD_F_CHILD));
 	}
 	io_u_qpush(&td->io_u_freelist, io_u);
-	td_io_u_unlock(td);
 	td_io_u_free_notify(td);
+	td_io_u_unlock(td);
 }
 
 void clear_io_u(struct thread_data *td, struct io_u *io_u)
@@ -889,8 +889,8 @@ void requeue_io_u(struct thread_data *td, struct io_u **io_u)
 	}
 
 	io_u_rpush(&td->io_u_requeues, __io_u);
-	td_io_u_unlock(td);
 	td_io_u_free_notify(td);
+	td_io_u_unlock(td);
 	*io_u = NULL;
 }
 
@@ -1558,6 +1558,7 @@ bool queue_full(const struct thread_data *td)
 struct io_u *__get_io_u(struct thread_data *td)
 {
 	struct io_u *io_u = NULL;
+	int ret;
 
 	if (td->stop_io)
 		return NULL;
@@ -1594,7 +1595,8 @@ again:
 		 * return one
 		 */
 		assert(!(td->flags & TD_F_CHILD));
-		assert(!pthread_cond_wait(&td->free_cond, &td->io_u_lock));
+		ret = pthread_cond_wait(&td->free_cond, &td->io_u_lock);
+		assert(ret == 0);
 		goto again;
 	}
 
diff --git a/iolog.c b/iolog.c
index 7d5a136..460d7a2 100644
--- a/iolog.c
+++ b/iolog.c
@@ -20,6 +20,7 @@
 #include "filelock.h"
 #include "smalloc.h"
 #include "blktrace.h"
+#include "pshared.h"
 
 static int iolog_flush(struct io_log *log);
 
diff --git a/mutex.c b/mutex.c
deleted file mode 100644
index acc88dc..0000000
--- a/mutex.c
+++ /dev/null
@@ -1,322 +0,0 @@
-#include <stdio.h>
-#include <string.h>
-#include <unistd.h>
-#include <stdlib.h>
-#include <fcntl.h>
-#include <time.h>
-#include <errno.h>
-#include <pthread.h>
-#include <sys/mman.h>
-#include <assert.h>
-
-#include "fio.h"
-#include "log.h"
-#include "mutex.h"
-#include "arch/arch.h"
-#include "os/os.h"
-#include "helpers.h"
-#include "fio_time.h"
-#include "gettime.h"
-
-void __fio_mutex_remove(struct fio_mutex *mutex)
-{
-	assert(mutex->magic == FIO_MUTEX_MAGIC);
-	pthread_cond_destroy(&mutex->cond);
-
-	/*
-	 * Ensure any subsequent attempt to grab this mutex will fail
-	 * with an assert, instead of just silently hanging.
-	 */
-	memset(mutex, 0, sizeof(*mutex));
-}
-
-void fio_mutex_remove(struct fio_mutex *mutex)
-{
-	__fio_mutex_remove(mutex);
-	munmap((void *) mutex, sizeof(*mutex));
-}
-
-int cond_init_pshared(pthread_cond_t *cond)
-{
-	pthread_condattr_t cattr;
-	int ret;
-
-	ret = pthread_condattr_init(&cattr);
-	if (ret) {
-		log_err("pthread_condattr_init: %s\n", strerror(ret));
-		return ret;
-	}
-
-#ifdef CONFIG_PSHARED
-	ret = pthread_condattr_setpshared(&cattr, PTHREAD_PROCESS_SHARED);
-	if (ret) {
-		log_err("pthread_condattr_setpshared: %s\n", strerror(ret));
-		return ret;
-	}
-#endif
-	ret = pthread_cond_init(cond, &cattr);
-	if (ret) {
-		log_err("pthread_cond_init: %s\n", strerror(ret));
-		return ret;
-	}
-
-	return 0;
-}
-
-int mutex_init_pshared(pthread_mutex_t *mutex)
-{
-	pthread_mutexattr_t mattr;
-	int ret;
-
-	ret = pthread_mutexattr_init(&mattr);
-	if (ret) {
-		log_err("pthread_mutexattr_init: %s\n", strerror(ret));
-		return ret;
-	}
-
-	/*
-	 * Not all platforms support process shared mutexes (FreeBSD)
-	 */
-#ifdef CONFIG_PSHARED
-	ret = pthread_mutexattr_setpshared(&mattr, PTHREAD_PROCESS_SHARED);
-	if (ret) {
-		log_err("pthread_mutexattr_setpshared: %s\n", strerror(ret));
-		return ret;
-	}
-#endif
-	ret = pthread_mutex_init(mutex, &mattr);
-	if (ret) {
-		log_err("pthread_mutex_init: %s\n", strerror(ret));
-		return ret;
-	}
-
-	return 0;
-}
-
-int mutex_cond_init_pshared(pthread_mutex_t *mutex, pthread_cond_t *cond)
-{
-	int ret;
-
-	ret = mutex_init_pshared(mutex);
-	if (ret)
-		return ret;
-
-	ret = cond_init_pshared(cond);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-int __fio_mutex_init(struct fio_mutex *mutex, int value)
-{
-	int ret;
-
-	mutex->value = value;
-	mutex->magic = FIO_MUTEX_MAGIC;
-
-	ret = mutex_cond_init_pshared(&mutex->lock, &mutex->cond);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-struct fio_mutex *fio_mutex_init(int value)
-{
-	struct fio_mutex *mutex = NULL;
-
-	mutex = (void *) mmap(NULL, sizeof(struct fio_mutex),
-				PROT_READ | PROT_WRITE,
-				OS_MAP_ANON | MAP_SHARED, -1, 0);
-	if (mutex == MAP_FAILED) {
-		perror("mmap mutex");
-		return NULL;
-	}
-
-	if (!__fio_mutex_init(mutex, value))
-		return mutex;
-
-	fio_mutex_remove(mutex);
-	return NULL;
-}
-
-static bool mutex_timed_out(struct timespec *t, unsigned int msecs)
-{
-	struct timeval tv;
-	struct timespec now;
-
-	gettimeofday(&tv, NULL);
-	now.tv_sec = tv.tv_sec;
-	now.tv_nsec = tv.tv_usec * 1000;
-
-	return mtime_since(t, &now) >= msecs;
-}
-
-int fio_mutex_down_timeout(struct fio_mutex *mutex, unsigned int msecs)
-{
-	struct timeval tv_s;
-	struct timespec base;
-	struct timespec t;
-	int ret = 0;
-
-	assert(mutex->magic == FIO_MUTEX_MAGIC);
-
-	gettimeofday(&tv_s, NULL);
-	base.tv_sec = t.tv_sec = tv_s.tv_sec;
-	base.tv_nsec = t.tv_nsec = tv_s.tv_usec * 1000;
-
-	t.tv_sec += msecs / 1000;
-	t.tv_nsec += ((msecs * 1000000ULL) % 1000000000);
-	if (t.tv_nsec >= 1000000000) {
-		t.tv_nsec -= 1000000000;
-		t.tv_sec++;
-	}
-
-	pthread_mutex_lock(&mutex->lock);
-
-	mutex->waiters++;
-	while (!mutex->value && !ret) {
-		/*
-		 * Some platforms (FreeBSD 9?) seems to return timed out
-		 * way too early, double check.
-		 */
-		ret = pthread_cond_timedwait(&mutex->cond, &mutex->lock, &t);
-		if (ret == ETIMEDOUT && !mutex_timed_out(&base, msecs))
-			ret = 0;
-	}
-	mutex->waiters--;
-
-	if (!ret) {
-		mutex->value--;
-		pthread_mutex_unlock(&mutex->lock);
-		return 0;
-	}
-
-	pthread_mutex_unlock(&mutex->lock);
-	return ret;
-}
-
-bool fio_mutex_down_trylock(struct fio_mutex *mutex)
-{
-	bool ret = true;
-
-	assert(mutex->magic == FIO_MUTEX_MAGIC);
-
-	pthread_mutex_lock(&mutex->lock);
-	if (mutex->value) {
-		mutex->value--;
-		ret = false;
-	}
-	pthread_mutex_unlock(&mutex->lock);
-
-	return ret;
-}
-
-void fio_mutex_down(struct fio_mutex *mutex)
-{
-	assert(mutex->magic == FIO_MUTEX_MAGIC);
-
-	pthread_mutex_lock(&mutex->lock);
-
-	while (!mutex->value) {
-		mutex->waiters++;
-		pthread_cond_wait(&mutex->cond, &mutex->lock);
-		mutex->waiters--;
-	}
-
-	mutex->value--;
-	pthread_mutex_unlock(&mutex->lock);
-}
-
-void fio_mutex_up(struct fio_mutex *mutex)
-{
-	int do_wake = 0;
-
-	assert(mutex->magic == FIO_MUTEX_MAGIC);
-
-	pthread_mutex_lock(&mutex->lock);
-	read_barrier();
-	if (!mutex->value && mutex->waiters)
-		do_wake = 1;
-	mutex->value++;
-
-	if (do_wake)
-		pthread_cond_signal(&mutex->cond);
-
-	pthread_mutex_unlock(&mutex->lock);
-}
-
-void fio_rwlock_write(struct fio_rwlock *lock)
-{
-	assert(lock->magic == FIO_RWLOCK_MAGIC);
-	pthread_rwlock_wrlock(&lock->lock);
-}
-
-void fio_rwlock_read(struct fio_rwlock *lock)
-{
-	assert(lock->magic == FIO_RWLOCK_MAGIC);
-	pthread_rwlock_rdlock(&lock->lock);
-}
-
-void fio_rwlock_unlock(struct fio_rwlock *lock)
-{
-	assert(lock->magic == FIO_RWLOCK_MAGIC);
-	pthread_rwlock_unlock(&lock->lock);
-}
-
-void fio_rwlock_remove(struct fio_rwlock *lock)
-{
-	assert(lock->magic == FIO_RWLOCK_MAGIC);
-	munmap((void *) lock, sizeof(*lock));
-}
-
-struct fio_rwlock *fio_rwlock_init(void)
-{
-	struct fio_rwlock *lock;
-	pthread_rwlockattr_t attr;
-	int ret;
-
-	lock = (void *) mmap(NULL, sizeof(struct fio_rwlock),
-				PROT_READ | PROT_WRITE,
-				OS_MAP_ANON | MAP_SHARED, -1, 0);
-	if (lock == MAP_FAILED) {
-		perror("mmap rwlock");
-		lock = NULL;
-		goto err;
-	}
-
-	lock->magic = FIO_RWLOCK_MAGIC;
-
-	ret = pthread_rwlockattr_init(&attr);
-	if (ret) {
-		log_err("pthread_rwlockattr_init: %s\n", strerror(ret));
-		goto err;
-	}
-#ifdef CONFIG_PSHARED
-	ret = pthread_rwlockattr_setpshared(&attr, PTHREAD_PROCESS_SHARED);
-	if (ret) {
-		log_err("pthread_rwlockattr_setpshared: %s\n", strerror(ret));
-		goto destroy_attr;
-	}
-
-	ret = pthread_rwlock_init(&lock->lock, &attr);
-#else
-	ret = pthread_rwlock_init(&lock->lock, NULL);
-#endif
-
-	if (ret) {
-		log_err("pthread_rwlock_init: %s\n", strerror(ret));
-		goto destroy_attr;
-	}
-
-	pthread_rwlockattr_destroy(&attr);
-
-	return lock;
-destroy_attr:
-	pthread_rwlockattr_destroy(&attr);
-err:
-	if (lock)
-		fio_rwlock_remove(lock);
-	return NULL;
-}
diff --git a/mutex.h b/mutex.h
deleted file mode 100644
index 54009ba..0000000
--- a/mutex.h
+++ /dev/null
@@ -1,47 +0,0 @@
-#ifndef FIO_MUTEX_H
-#define FIO_MUTEX_H
-
-#include <pthread.h>
-#include "lib/types.h"
-
-#define FIO_MUTEX_MAGIC		0x4d555445U
-#define FIO_RWLOCK_MAGIC	0x52574c4fU
-
-struct fio_mutex {
-	pthread_mutex_t lock;
-	pthread_cond_t cond;
-	int value;
-	int waiters;
-	int magic;
-};
-
-struct fio_rwlock {
-	pthread_rwlock_t lock;
-	int magic;
-};
-
-enum {
-	FIO_MUTEX_LOCKED	= 0,
-	FIO_MUTEX_UNLOCKED	= 1,
-};
-
-extern int __fio_mutex_init(struct fio_mutex *, int);
-extern struct fio_mutex *fio_mutex_init(int);
-extern void __fio_mutex_remove(struct fio_mutex *);
-extern void fio_mutex_remove(struct fio_mutex *);
-extern void fio_mutex_up(struct fio_mutex *);
-extern void fio_mutex_down(struct fio_mutex *);
-extern bool fio_mutex_down_trylock(struct fio_mutex *);
-extern int fio_mutex_down_timeout(struct fio_mutex *, unsigned int);
-
-extern void fio_rwlock_read(struct fio_rwlock *);
-extern void fio_rwlock_write(struct fio_rwlock *);
-extern void fio_rwlock_unlock(struct fio_rwlock *);
-extern struct fio_rwlock *fio_rwlock_init(void);
-extern void fio_rwlock_remove(struct fio_rwlock *);
-
-extern int mutex_init_pshared(pthread_mutex_t *);
-extern int cond_init_pshared(pthread_cond_t *);
-extern int mutex_cond_init_pshared(pthread_mutex_t *, pthread_cond_t *);
-
-#endif
diff --git a/optgroup.c b/optgroup.c
index 122d24e..1c418f5 100644
--- a/optgroup.c
+++ b/optgroup.c
@@ -1,6 +1,7 @@
 #include <stdio.h>
 #include <inttypes.h>
 #include "optgroup.h"
+#include "compiler/compiler.h"
 
 /*
  * Option grouping
@@ -203,3 +204,5 @@ const struct opt_group *opt_group_cat_from_mask(uint64_t *mask)
 {
 	return group_from_mask(fio_opt_cat_groups, mask, FIO_OPT_G_INVALID);
 }
+
+compiletime_assert(__FIO_OPT_G_NR <= 8 * sizeof(uint64_t), "__FIO_OPT_G_NR");
diff --git a/optgroup.h b/optgroup.h
index 815ac16..d5e968d 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -55,10 +55,11 @@ enum opt_category_group {
 	__FIO_OPT_G_LIBAIO,
 	__FIO_OPT_G_ACT,
 	__FIO_OPT_G_LATPROF,
-        __FIO_OPT_G_RBD,
-        __FIO_OPT_G_GFAPI,
-        __FIO_OPT_G_MTD,
+	__FIO_OPT_G_RBD,
+	__FIO_OPT_G_GFAPI,
+	__FIO_OPT_G_MTD,
 	__FIO_OPT_G_HDFS,
+	__FIO_OPT_G_SG,
 	__FIO_OPT_G_NR,
 
 	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
@@ -93,6 +94,7 @@ enum opt_category_group {
 	FIO_OPT_G_GFAPI		= (1ULL << __FIO_OPT_G_GFAPI),
 	FIO_OPT_G_MTD		= (1ULL << __FIO_OPT_G_MTD),
 	FIO_OPT_G_HDFS		= (1ULL << __FIO_OPT_G_HDFS),
+	FIO_OPT_G_SG		= (1ULL << __FIO_OPT_G_SG),
 	FIO_OPT_G_INVALID	= (1ULL << __FIO_OPT_G_NR),
 };
 
diff --git a/profiles/act.c b/profiles/act.c
index 3fa5afa..5d3bd25 100644
--- a/profiles/act.c
+++ b/profiles/act.c
@@ -38,7 +38,7 @@ struct act_slice {
 };
 
 struct act_run_data {
-	struct fio_mutex *mutex;
+	struct fio_sem *sem;
 	unsigned int pending;
 
 	struct act_slice *slices;
@@ -337,9 +337,9 @@ static int act_io_u_lat(struct thread_data *td, uint64_t nsec)
 
 static void get_act_ref(void)
 {
-	fio_mutex_down(act_run_data->mutex);
+	fio_sem_down(act_run_data->sem);
 	act_run_data->pending++;
-	fio_mutex_up(act_run_data->mutex);
+	fio_sem_up(act_run_data->sem);
 }
 
 static int show_slice(struct act_slice *slice, unsigned int slice_num)
@@ -396,7 +396,7 @@ static void put_act_ref(struct thread_data *td)
 	struct act_prof_data *apd = td->prof_data;
 	unsigned int i, slice;
 
-	fio_mutex_down(act_run_data->mutex);
+	fio_sem_down(act_run_data->sem);
 
 	if (!act_run_data->slices) {
 		act_run_data->slices = calloc(apd->nr_slices, sizeof(struct act_slice));
@@ -416,7 +416,7 @@ static void put_act_ref(struct thread_data *td)
 	if (!--act_run_data->pending)
 		act_show_all_stats();
 
-	fio_mutex_up(act_run_data->mutex);
+	fio_sem_up(act_run_data->sem);
 }
 
 static int act_td_init(struct thread_data *td)
@@ -464,7 +464,7 @@ static struct profile_ops act_profile = {
 static void fio_init act_register(void)
 {
 	act_run_data = calloc(1, sizeof(*act_run_data));
-	act_run_data->mutex = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+	act_run_data->sem = fio_sem_init(FIO_SEM_UNLOCKED);
 
 	if (register_profile(&act_profile))
 		log_err("fio: failed to register profile 'act'\n");
@@ -476,7 +476,7 @@ static void fio_exit act_unregister(void)
 		free((void *) act_opts[++org_idx]);
 
 	unregister_profile(&act_profile);
-	fio_mutex_remove(act_run_data->mutex);
+	fio_sem_remove(act_run_data->sem);
 	free(act_run_data->slices);
 	free(act_run_data);
 	act_run_data = NULL;
diff --git a/pshared.c b/pshared.c
new file mode 100644
index 0000000..74812ed
--- /dev/null
+++ b/pshared.c
@@ -0,0 +1,76 @@
+#include <string.h>
+
+#include "log.h"
+#include "pshared.h"
+
+int cond_init_pshared(pthread_cond_t *cond)
+{
+	pthread_condattr_t cattr;
+	int ret;
+
+	ret = pthread_condattr_init(&cattr);
+	if (ret) {
+		log_err("pthread_condattr_init: %s\n", strerror(ret));
+		return ret;
+	}
+
+#ifdef CONFIG_PSHARED
+	ret = pthread_condattr_setpshared(&cattr, PTHREAD_PROCESS_SHARED);
+	if (ret) {
+		log_err("pthread_condattr_setpshared: %s\n", strerror(ret));
+		return ret;
+	}
+#endif
+	ret = pthread_cond_init(cond, &cattr);
+	if (ret) {
+		log_err("pthread_cond_init: %s\n", strerror(ret));
+		return ret;
+	}
+
+	return 0;
+}
+
+int mutex_init_pshared(pthread_mutex_t *mutex)
+{
+	pthread_mutexattr_t mattr;
+	int ret;
+
+	ret = pthread_mutexattr_init(&mattr);
+	if (ret) {
+		log_err("pthread_mutexattr_init: %s\n", strerror(ret));
+		return ret;
+	}
+
+	/*
+	 * Not all platforms support process shared mutexes (FreeBSD)
+	 */
+#ifdef CONFIG_PSHARED
+	ret = pthread_mutexattr_setpshared(&mattr, PTHREAD_PROCESS_SHARED);
+	if (ret) {
+		log_err("pthread_mutexattr_setpshared: %s\n", strerror(ret));
+		return ret;
+	}
+#endif
+	ret = pthread_mutex_init(mutex, &mattr);
+	if (ret) {
+		log_err("pthread_mutex_init: %s\n", strerror(ret));
+		return ret;
+	}
+
+	return 0;
+}
+
+int mutex_cond_init_pshared(pthread_mutex_t *mutex, pthread_cond_t *cond)
+{
+	int ret;
+
+	ret = mutex_init_pshared(mutex);
+	if (ret)
+		return ret;
+
+	ret = cond_init_pshared(cond);
+	if (ret)
+		return ret;
+
+	return 0;
+}
diff --git a/pshared.h b/pshared.h
new file mode 100644
index 0000000..a58df6f
--- /dev/null
+++ b/pshared.h
@@ -0,0 +1,10 @@
+#ifndef FIO_PSHARED_H
+#define FIO_PSHARED_H
+
+#include <pthread.h>
+
+extern int mutex_init_pshared(pthread_mutex_t *);
+extern int cond_init_pshared(pthread_cond_t *);
+extern int mutex_cond_init_pshared(pthread_mutex_t *, pthread_cond_t *);
+
+#endif
diff --git a/rwlock.c b/rwlock.c
new file mode 100644
index 0000000..00e3809
--- /dev/null
+++ b/rwlock.c
@@ -0,0 +1,83 @@
+#include <stdio.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <assert.h>
+
+#include "log.h"
+#include "rwlock.h"
+#include "os/os.h"
+
+void fio_rwlock_write(struct fio_rwlock *lock)
+{
+	assert(lock->magic == FIO_RWLOCK_MAGIC);
+	pthread_rwlock_wrlock(&lock->lock);
+}
+
+void fio_rwlock_read(struct fio_rwlock *lock)
+{
+	assert(lock->magic == FIO_RWLOCK_MAGIC);
+	pthread_rwlock_rdlock(&lock->lock);
+}
+
+void fio_rwlock_unlock(struct fio_rwlock *lock)
+{
+	assert(lock->magic == FIO_RWLOCK_MAGIC);
+	pthread_rwlock_unlock(&lock->lock);
+}
+
+void fio_rwlock_remove(struct fio_rwlock *lock)
+{
+	assert(lock->magic == FIO_RWLOCK_MAGIC);
+	pthread_rwlock_destroy(&lock->lock);
+	munmap((void *) lock, sizeof(*lock));
+}
+
+struct fio_rwlock *fio_rwlock_init(void)
+{
+	struct fio_rwlock *lock;
+	pthread_rwlockattr_t attr;
+	int ret;
+
+	lock = (void *) mmap(NULL, sizeof(struct fio_rwlock),
+				PROT_READ | PROT_WRITE,
+				OS_MAP_ANON | MAP_SHARED, -1, 0);
+	if (lock == MAP_FAILED) {
+		perror("mmap rwlock");
+		lock = NULL;
+		goto err;
+	}
+
+	lock->magic = FIO_RWLOCK_MAGIC;
+
+	ret = pthread_rwlockattr_init(&attr);
+	if (ret) {
+		log_err("pthread_rwlockattr_init: %s\n", strerror(ret));
+		goto err;
+	}
+#ifdef CONFIG_PSHARED
+	ret = pthread_rwlockattr_setpshared(&attr, PTHREAD_PROCESS_SHARED);
+	if (ret) {
+		log_err("pthread_rwlockattr_setpshared: %s\n", strerror(ret));
+		goto destroy_attr;
+	}
+
+	ret = pthread_rwlock_init(&lock->lock, &attr);
+#else
+	ret = pthread_rwlock_init(&lock->lock, NULL);
+#endif
+
+	if (ret) {
+		log_err("pthread_rwlock_init: %s\n", strerror(ret));
+		goto destroy_attr;
+	}
+
+	pthread_rwlockattr_destroy(&attr);
+
+	return lock;
+destroy_attr:
+	pthread_rwlockattr_destroy(&attr);
+err:
+	if (lock)
+		fio_rwlock_remove(lock);
+	return NULL;
+}
diff --git a/rwlock.h b/rwlock.h
new file mode 100644
index 0000000..2968eed
--- /dev/null
+++ b/rwlock.h
@@ -0,0 +1,19 @@
+#ifndef FIO_RWLOCK_H
+#define FIO_RWLOCK_H
+
+#include <pthread.h>
+
+#define FIO_RWLOCK_MAGIC	0x52574c4fU
+
+struct fio_rwlock {
+	pthread_rwlock_t lock;
+	int magic;
+};
+
+extern void fio_rwlock_read(struct fio_rwlock *);
+extern void fio_rwlock_write(struct fio_rwlock *);
+extern void fio_rwlock_unlock(struct fio_rwlock *);
+extern struct fio_rwlock *fio_rwlock_init(void);
+extern void fio_rwlock_remove(struct fio_rwlock *);
+
+#endif
diff --git a/server.c b/server.c
index 959786f..65d4484 100644
--- a/server.c
+++ b/server.c
@@ -74,7 +74,7 @@ struct fio_fork_item {
 };
 
 struct cmd_reply {
-	struct fio_mutex lock;
+	struct fio_sem lock;
 	void *data;
 	size_t size;
 	int error;
@@ -108,12 +108,12 @@ static const char *fio_server_ops[FIO_NET_CMD_NR] = {
 
 static void sk_lock(struct sk_out *sk_out)
 {
-	fio_mutex_down(&sk_out->lock);
+	fio_sem_down(&sk_out->lock);
 }
 
 static void sk_unlock(struct sk_out *sk_out)
 {
-	fio_mutex_up(&sk_out->lock);
+	fio_sem_up(&sk_out->lock);
 }
 
 void sk_out_assign(struct sk_out *sk_out)
@@ -129,9 +129,9 @@ void sk_out_assign(struct sk_out *sk_out)
 
 static void sk_out_free(struct sk_out *sk_out)
 {
-	__fio_mutex_remove(&sk_out->lock);
-	__fio_mutex_remove(&sk_out->wait);
-	__fio_mutex_remove(&sk_out->xmit);
+	__fio_sem_remove(&sk_out->lock);
+	__fio_sem_remove(&sk_out->wait);
+	__fio_sem_remove(&sk_out->xmit);
 	sfree(sk_out);
 }
 
@@ -558,7 +558,7 @@ static void fio_net_queue_entry(struct sk_entry *entry)
 		flist_add_tail(&entry->list, &sk_out->list);
 		sk_unlock(sk_out);
 
-		fio_mutex_up(&sk_out->wait);
+		fio_sem_up(&sk_out->wait);
 	}
 }
 
@@ -1039,7 +1039,7 @@ static int handle_command(struct sk_out *sk_out, struct flist_head *job_list,
 				memcpy(rep->data, in->data, in->size);
 			}
 		}
-		fio_mutex_up(&rep->lock);
+		fio_sem_up(&rep->lock);
 		break;
 		}
 	default:
@@ -1138,7 +1138,7 @@ static int handle_sk_entry(struct sk_out *sk_out, struct sk_entry *entry)
 {
 	int ret;
 
-	fio_mutex_down(&sk_out->xmit);
+	fio_sem_down(&sk_out->xmit);
 
 	if (entry->flags & SK_F_VEC)
 		ret = send_vec_entry(sk_out, entry);
@@ -1150,7 +1150,7 @@ static int handle_sk_entry(struct sk_out *sk_out, struct sk_entry *entry)
 					entry->size, &entry->tag, NULL);
 	}
 
-	fio_mutex_up(&sk_out->xmit);
+	fio_sem_up(&sk_out->xmit);
 
 	if (ret)
 		log_err("fio: failed handling cmd %s\n", fio_server_op(entry->opcode));
@@ -1215,7 +1215,7 @@ static int handle_connection(struct sk_out *sk_out)
 				break;
 			} else if (!ret) {
 				fio_server_check_jobs(&job_list);
-				fio_mutex_down_timeout(&sk_out->wait, timeout);
+				fio_sem_down_timeout(&sk_out->wait, timeout);
 				continue;
 			}
 
@@ -1361,9 +1361,9 @@ static int accept_loop(int listen_sk)
 		sk_out = smalloc(sizeof(*sk_out));
 		sk_out->sk = sk;
 		INIT_FLIST_HEAD(&sk_out->list);
-		__fio_mutex_init(&sk_out->lock, FIO_MUTEX_UNLOCKED);
-		__fio_mutex_init(&sk_out->wait, FIO_MUTEX_LOCKED);
-		__fio_mutex_init(&sk_out->xmit, FIO_MUTEX_UNLOCKED);
+		__fio_sem_init(&sk_out->lock, FIO_SEM_UNLOCKED);
+		__fio_sem_init(&sk_out->wait, FIO_SEM_LOCKED);
+		__fio_sem_init(&sk_out->xmit, FIO_SEM_UNLOCKED);
 
 		pid = fork();
 		if (pid) {
@@ -2033,7 +2033,7 @@ int fio_server_get_verify_state(const char *name, int threadnumber,
 	if (!rep)
 		return ENOMEM;
 
-	__fio_mutex_init(&rep->lock, FIO_MUTEX_LOCKED);
+	__fio_sem_init(&rep->lock, FIO_SEM_LOCKED);
 	rep->data = NULL;
 	rep->error = 0;
 
@@ -2046,7 +2046,7 @@ int fio_server_get_verify_state(const char *name, int threadnumber,
 	/*
 	 * Wait for the backend to receive the reply
 	 */
-	if (fio_mutex_down_timeout(&rep->lock, 10000)) {
+	if (fio_sem_down_timeout(&rep->lock, 10000)) {
 		log_err("fio: timed out waiting for reply\n");
 		ret = ETIMEDOUT;
 		goto fail;
@@ -2083,7 +2083,7 @@ fail:
 	*datap = data;
 
 	sfree(rep->data);
-	__fio_mutex_remove(&rep->lock);
+	__fio_sem_remove(&rep->lock);
 	sfree(rep);
 	return ret;
 }
diff --git a/server.h b/server.h
index bd892fc..d652d31 100644
--- a/server.h
+++ b/server.h
@@ -17,10 +17,10 @@ struct sk_out {
 				 * protected by below ->lock */
 
 	int sk;			/* socket fd to talk to client */
-	struct fio_mutex lock;	/* protects ref and below list */
+	struct fio_sem lock;	/* protects ref and below list */
 	struct flist_head list;	/* list of pending transmit work */
-	struct fio_mutex wait;	/* wake backend when items added to list */
-	struct fio_mutex xmit;	/* held while sending data */
+	struct fio_sem wait;	/* wake backend when items added to list */
+	struct fio_sem xmit;	/* held while sending data */
 };
 
 /*
diff --git a/smalloc.c b/smalloc.c
index cab7132..13995ac 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -12,9 +12,16 @@
 #include <sys/types.h>
 #include <limits.h>
 #include <fcntl.h>
+#ifdef CONFIG_VALGRIND_DEV
+#include <valgrind/valgrind.h>
+#else
+#define RUNNING_ON_VALGRIND 0
+#define VALGRIND_MALLOCLIKE_BLOCK(addr, size, rzB, is_zeroed) do { } while (0)
+#define VALGRIND_FREELIKE_BLOCK(addr, rzB) do { } while (0)
+#endif
 
 #include "fio.h"
-#include "mutex.h"
+#include "fio_sem.h"
 #include "arch/arch.h"
 #include "os/os.h"
 #include "smalloc.h"
@@ -40,7 +47,7 @@ static const int int_mask = sizeof(int) - 1;
 #endif
 
 struct pool {
-	struct fio_mutex *lock;			/* protects this pool */
+	struct fio_sem *lock;			/* protects this pool */
 	void *map;				/* map of blocks */
 	unsigned int *bitmap;			/* blocks free/busy map */
 	size_t free_blocks;		/* free blocks */
@@ -49,6 +56,12 @@ struct pool {
 	size_t mmap_size;
 };
 
+#ifdef SMALLOC_REDZONE
+#define REDZONE_SIZE sizeof(unsigned int)
+#else
+#define REDZONE_SIZE 0
+#endif
+
 struct block_hdr {
 	size_t size;
 #ifdef SMALLOC_REDZONE
@@ -192,7 +205,7 @@ static bool add_pool(struct pool *pool, unsigned int alloc_size)
 	pool->bitmap = (unsigned int *)((char *) ptr + (pool->nr_blocks * SMALLOC_BPL));
 	memset(pool->bitmap, 0, bitmap_blocks * sizeof(unsigned int));
 
-	pool->lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+	pool->lock = fio_sem_init(FIO_SEM_UNLOCKED);
 	if (!pool->lock)
 		goto out_fail;
 
@@ -232,7 +245,7 @@ static void cleanup_pool(struct pool *pool)
 	munmap(pool->map, pool->mmap_size);
 
 	if (pool->lock)
-		fio_mutex_remove(pool->lock);
+		fio_sem_remove(pool->lock);
 }
 
 void scleanup(void)
@@ -258,6 +271,10 @@ static void fill_redzone(struct block_hdr *hdr)
 {
 	unsigned int *postred = postred_ptr(hdr);
 
+	/* Let Valgrind fill the red zones. */
+	if (RUNNING_ON_VALGRIND)
+		return;
+
 	hdr->prered = SMALLOC_PRE_RED;
 	*postred = SMALLOC_POST_RED;
 }
@@ -266,6 +283,10 @@ static void sfree_check_redzone(struct block_hdr *hdr)
 {
 	unsigned int *postred = postred_ptr(hdr);
 
+	/* Let Valgrind check the red zones. */
+	if (RUNNING_ON_VALGRIND)
+		return;
+
 	if (hdr->prered != SMALLOC_PRE_RED) {
 		log_err("smalloc pre redzone destroyed!\n"
 			" ptr=%p, prered=%x, expected %x\n",
@@ -309,12 +330,12 @@ static void sfree_pool(struct pool *pool, void *ptr)
 	i = offset / SMALLOC_BPL;
 	idx = (offset % SMALLOC_BPL) / SMALLOC_BPB;
 
-	fio_mutex_down(pool->lock);
+	fio_sem_down(pool->lock);
 	clear_blocks(pool, i, idx, size_to_blocks(hdr->size));
 	if (i < pool->next_non_full)
 		pool->next_non_full = i;
 	pool->free_blocks += size_to_blocks(hdr->size);
-	fio_mutex_up(pool->lock);
+	fio_sem_up(pool->lock);
 }
 
 void sfree(void *ptr)
@@ -333,6 +354,7 @@ void sfree(void *ptr)
 	}
 
 	if (pool) {
+		VALGRIND_FREELIKE_BLOCK(ptr, REDZONE_SIZE);
 		sfree_pool(pool, ptr);
 		return;
 	}
@@ -348,7 +370,7 @@ static void *__smalloc_pool(struct pool *pool, size_t size)
 	unsigned int last_idx;
 	void *ret = NULL;
 
-	fio_mutex_down(pool->lock);
+	fio_sem_down(pool->lock);
 
 	nr_blocks = size_to_blocks(size);
 	if (nr_blocks > pool->free_blocks)
@@ -391,7 +413,7 @@ static void *__smalloc_pool(struct pool *pool, size_t size)
 		ret = pool->map + offset;
 	}
 fail:
-	fio_mutex_up(pool->lock);
+	fio_sem_up(pool->lock);
 	return ret;
 }
 
@@ -423,7 +445,7 @@ static void *smalloc_pool(struct pool *pool, size_t size)
 	return ptr;
 }
 
-void *smalloc(size_t size)
+static void *__smalloc(size_t size, bool is_zeroed)
 {
 	unsigned int i, end_pool;
 
@@ -439,6 +461,9 @@ void *smalloc(size_t size)
 
 			if (ptr) {
 				last_pool = i;
+				VALGRIND_MALLOCLIKE_BLOCK(ptr, size,
+							  REDZONE_SIZE,
+							  is_zeroed);
 				return ptr;
 			}
 		}
@@ -456,9 +481,14 @@ void *smalloc(size_t size)
 	return NULL;
 }
 
+void *smalloc(size_t size)
+{
+	return __smalloc(size, false);
+}
+
 void *scalloc(size_t nmemb, size_t size)
 {
-	return smalloc(nmemb * size);
+	return __smalloc(nmemb * size, true);
 }
 
 char *smalloc_strdup(const char *str)
diff --git a/stat.c b/stat.c
index 8a242c9..98ab638 100644
--- a/stat.c
+++ b/stat.c
@@ -20,7 +20,7 @@
 
 #define LOG_MSEC_SLACK	1
 
-struct fio_mutex *stat_mutex;
+struct fio_sem *stat_sem;
 
 void clear_rusage_stat(struct thread_data *td)
 {
@@ -1946,9 +1946,9 @@ void __show_run_stats(void)
 
 void show_run_stats(void)
 {
-	fio_mutex_down(stat_mutex);
+	fio_sem_down(stat_sem);
 	__show_run_stats();
-	fio_mutex_up(stat_mutex);
+	fio_sem_up(stat_sem);
 }
 
 void __show_running_run_stats(void)
@@ -1958,7 +1958,7 @@ void __show_running_run_stats(void)
 	struct timespec ts;
 	int i;
 
-	fio_mutex_down(stat_mutex);
+	fio_sem_down(stat_sem);
 
 	rt = malloc(thread_number * sizeof(unsigned long long));
 	fio_gettime(&ts, NULL);
@@ -1984,7 +1984,7 @@ void __show_running_run_stats(void)
 			continue;
 		if (td->rusage_sem) {
 			td->update_rusage = 1;
-			fio_mutex_down(td->rusage_sem);
+			fio_sem_down(td->rusage_sem);
 		}
 		td->update_rusage = 0;
 	}
@@ -2001,7 +2001,7 @@ void __show_running_run_stats(void)
 	}
 
 	free(rt);
-	fio_mutex_up(stat_mutex);
+	fio_sem_up(stat_sem);
 }
 
 static bool status_interval_init;
@@ -2690,7 +2690,7 @@ int calc_log_samples(void)
 
 void stat_init(void)
 {
-	stat_mutex = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+	stat_sem = fio_sem_init(FIO_SEM_UNLOCKED);
 }
 
 void stat_exit(void)
@@ -2699,8 +2699,8 @@ void stat_exit(void)
 	 * When we have the mutex, we know out-of-band access to it
 	 * have ended.
 	 */
-	fio_mutex_down(stat_mutex);
-	fio_mutex_remove(stat_mutex);
+	fio_sem_down(stat_sem);
+	fio_sem_remove(stat_sem);
 }
 
 /*
diff --git a/stat.h b/stat.h
index 7580f0d..8e7bcdb 100644
--- a/stat.h
+++ b/stat.h
@@ -277,7 +277,7 @@ struct io_u_plat_entry {
 	uint64_t io_u_plat[FIO_IO_U_PLAT_NR];
 };
 
-extern struct fio_mutex *stat_mutex;
+extern struct fio_sem *stat_sem;
 
 extern struct jobs_eta *get_jobs_eta(bool force, size_t *size);
 
diff --git a/t/dedupe.c b/t/dedupe.c
index 9a50821..1b4277c 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -16,7 +16,7 @@
 
 #include "../flist.h"
 #include "../log.h"
-#include "../mutex.h"
+#include "../fio_sem.h"
 #include "../smalloc.h"
 #include "../minmax.h"
 #include "../crc/md5.h"
@@ -62,7 +62,7 @@ struct item {
 
 static struct rb_root rb_root;
 static struct bloom *bloom;
-static struct fio_mutex *rb_lock;
+static struct fio_sem *rb_lock;
 
 static unsigned int blocksize = 4096;
 static unsigned int num_threads;
@@ -75,7 +75,7 @@ static unsigned int use_bloom = 1;
 
 static uint64_t total_size;
 static uint64_t cur_offset;
-static struct fio_mutex *size_lock;
+static struct fio_sem *size_lock;
 
 static struct fio_file file;
 
@@ -102,7 +102,7 @@ static int get_work(uint64_t *offset, uint64_t *size)
 	uint64_t this_chunk;
 	int ret = 1;
 
-	fio_mutex_down(size_lock);
+	fio_sem_down(size_lock);
 
 	if (cur_offset < total_size) {
 		*offset = cur_offset;
@@ -112,7 +112,7 @@ static int get_work(uint64_t *offset, uint64_t *size)
 		ret = 0;
 	}
 
-	fio_mutex_up(size_lock);
+	fio_sem_up(size_lock);
 	return ret;
 }
 
@@ -215,9 +215,9 @@ static void insert_chunk(struct item *i)
 			if (!collision_check)
 				goto add;
 
-			fio_mutex_up(rb_lock);
+			fio_sem_up(rb_lock);
 			ret = col_check(c, i);
-			fio_mutex_down(rb_lock);
+			fio_sem_down(rb_lock);
 
 			if (!ret)
 				goto add;
@@ -241,7 +241,7 @@ static void insert_chunks(struct item *items, unsigned int nitems,
 {
 	int i;
 
-	fio_mutex_down(rb_lock);
+	fio_sem_down(rb_lock);
 
 	for (i = 0; i < nitems; i++) {
 		if (bloom) {
@@ -255,7 +255,7 @@ static void insert_chunks(struct item *items, unsigned int nitems,
 			insert_chunk(&items[i]);
 	}
 
-	fio_mutex_up(rb_lock);
+	fio_sem_up(rb_lock);
 }
 
 static void crc_buf(void *buf, uint32_t *hash)
@@ -383,7 +383,7 @@ static int run_dedupe_threads(struct fio_file *f, uint64_t dev_size,
 	total_size = dev_size;
 	total_items = dev_size / blocksize;
 	cur_offset = 0;
-	size_lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+	size_lock = fio_sem_init(FIO_SEM_UNLOCKED);
 
 	threads = malloc(num_threads * sizeof(struct worker_thread));
 	for (i = 0; i < num_threads; i++) {
@@ -414,7 +414,7 @@ static int run_dedupe_threads(struct fio_file *f, uint64_t dev_size,
 	*nextents = nitems;
 	*nchunks = nitems - *nchunks;
 
-	fio_mutex_remove(size_lock);
+	fio_sem_remove(size_lock);
 	free(threads);
 	return err;
 }
@@ -581,7 +581,7 @@ int main(int argc, char *argv[])
 	sinit();
 
 	rb_root = RB_ROOT;
-	rb_lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+	rb_lock = fio_sem_init(FIO_SEM_UNLOCKED);
 
 	ret = dedupe_check(argv[optind], &nextents, &nchunks);
 
@@ -592,7 +592,7 @@ int main(int argc, char *argv[])
 		show_stat(nextents, nchunks);
 	}
 
-	fio_mutex_remove(rb_lock);
+	fio_sem_remove(rb_lock);
 	if (bloom)
 		bloom_free(bloom);
 	scleanup();
diff --git a/verify.c b/verify.c
index 17af3bb..d10670b 100644
--- a/verify.c
+++ b/verify.c
@@ -1454,9 +1454,9 @@ static void *verify_async_thread(void *data)
 done:
 	pthread_mutex_lock(&td->io_u_lock);
 	td->nr_verify_threads--;
+	pthread_cond_signal(&td->free_cond);
 	pthread_mutex_unlock(&td->io_u_lock);
 
-	pthread_cond_signal(&td->free_cond);
 	return NULL;
 }
 
@@ -1492,9 +1492,12 @@ int verify_async_init(struct thread_data *td)
 
 	if (i != td->o.verify_async) {
 		log_err("fio: only %d verify threads started, exiting\n", i);
+
+		pthread_mutex_lock(&td->io_u_lock);
 		td->verify_thread_exit = 1;
-		write_barrier();
 		pthread_cond_broadcast(&td->verify_cond);
+		pthread_mutex_unlock(&td->io_u_lock);
+
 		return 1;
 	}
 
@@ -1503,12 +1506,10 @@ int verify_async_init(struct thread_data *td)
 
 void verify_async_exit(struct thread_data *td)
 {
+	pthread_mutex_lock(&td->io_u_lock);
 	td->verify_thread_exit = 1;
-	write_barrier();
 	pthread_cond_broadcast(&td->verify_cond);
 
-	pthread_mutex_lock(&td->io_u_lock);
-
 	while (td->nr_verify_threads)
 		pthread_cond_wait(&td->free_cond, &td->io_u_lock);
 
diff --git a/workqueue.c b/workqueue.c
index 18ec198..841dbb9 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -10,6 +10,7 @@
 #include "flist.h"
 #include "workqueue.h"
 #include "smalloc.h"
+#include "pshared.h"
 
 enum {
 	SW_F_IDLE	= 1 << 0,
