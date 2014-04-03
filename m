Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56475 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaDCMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 3 Apr 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WVgJQ-0001QV-4m
	for fio@vger.kernel.org; Thu, 03 Apr 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140403120002.E9518400AA@strynoevaenget.dk>
Date: Thu,  3 Apr 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 10aa136bddbaa7c845ab4eacb4a9a4a88d6657a3:

  Cleanup symbols that should be static (2014-04-01 21:10:36 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2e80228232afc9cf90ad06b360a33a05637978f3:

  Use setvbuf() for log writing (2014-04-02 21:47:27 -0600)

----------------------------------------------------------------
Erwan Velu (3):
      iolog: Keep full path for logs files
      stat: fixing bw_agg reporting
      io_u: Using initialized local variable

Jens Axboe (12):
      Merge branch 'erwan/nobasename' of https://github.com/enovance/fio
      Merge branch 'erwan/clang' of https://github.com/enovance/fio
      Fix propagation of error value on failure to connect to fio server
      Add missing crc/test.h file
      Don't crash when using filehash lock before init
      mutex: add open init function and down_trylock() variant
      Add 'f' (Finishing) flag to status output
      iolog: don't serialize the writing of all logs
      Cleanup the parallellized log writing
      crc: add test.h header to test.c
      iolog: invert log_mask bits
      Use setvbuf() for log writing

 HOWTO      |    1 +
 Makefile   |    2 +-
 backend.c  |   44 +--------------
 configure  |   20 +++++++
 crc/test.c |    2 +
 crc/test.h |    6 ++
 eta.c      |    6 +-
 filehash.c |    6 +-
 filelock.c |  157 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 filelock.h |   11 ++++
 fio.h      |    1 +
 init.c     |    9 ++-
 io_u.c     |    4 +-
 iolog.c    |  179 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 iolog.h    |    3 +-
 libfio.c   |    6 ++
 mutex.c    |   55 +++++++++++++------
 mutex.h    |    2 +
 stat.c     |    2 +-
 19 files changed, 432 insertions(+), 84 deletions(-)
 create mode 100644 crc/test.h
 create mode 100644 filelock.c
 create mode 100644 filelock.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 47eff96..7db7b89 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1590,6 +1590,7 @@ I		Thread initialized, waiting or generating necessary data.
 	M	Running, doing mixed sequential reads/writes.
 	m	Running, doing mixed random reads/writes.
 	F	Running, currently waiting for fsync()
+	f	Running, finishing up (writing IO logs, etc)
 	V	Running, doing verification of written data.
 E		Thread exited, not reaped by main thread yet.
 _		Thread reaped, or
diff --git a/Makefile b/Makefile
index 1113c2f..231b4ab 100644
--- a/Makefile
+++ b/Makefile
@@ -35,7 +35,7 @@ SOURCE := gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		cconv.c lib/prio_tree.c json.c lib/zipf.c lib/axmap.c \
 		lib/lfsr.c gettime-thread.c helpers.c lib/flist_sort.c \
 		lib/hweight.c lib/getrusage.c idletime.c td_error.c \
-		profiles/tiobench.c profiles/act.c io_u_queue.c
+		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c
 
 ifdef CONFIG_64BIT_LLP64
   CFLAGS += -DBITS_PER_LONG=32
diff --git a/backend.c b/backend.c
index 1ff8b3f..5ac3659 100644
--- a/backend.c
+++ b/backend.c
@@ -57,7 +57,6 @@
 static pthread_t disk_util_thread;
 static struct fio_mutex *disk_thread_mutex;
 static struct fio_mutex *startup_mutex;
-static struct fio_mutex *writeout_mutex;
 static struct flist_head *cgroup_list;
 static char *cgroup_mnt;
 static int exit_value;
@@ -1490,45 +1489,8 @@ static void *thread_main(void *data)
 
 	fio_unpin_memory(td);
 
-	fio_mutex_down(writeout_mutex);
-	finalize_logs(td);
-	if (td->bw_log) {
-		if (o->bw_log_file) {
-			finish_log_named(td, td->bw_log,
-						o->bw_log_file, "bw");
-		} else
-			finish_log(td, td->bw_log, "bw");
-	}
-	if (td->lat_log) {
-		if (o->lat_log_file) {
-			finish_log_named(td, td->lat_log,
-						o->lat_log_file, "lat");
-		} else
-			finish_log(td, td->lat_log, "lat");
-	}
-	if (td->slat_log) {
-		if (o->lat_log_file) {
-			finish_log_named(td, td->slat_log,
-						o->lat_log_file, "slat");
-		} else
-			finish_log(td, td->slat_log, "slat");
-	}
-	if (td->clat_log) {
-		if (o->lat_log_file) {
-			finish_log_named(td, td->clat_log,
-						o->lat_log_file, "clat");
-		} else
-			finish_log(td, td->clat_log, "clat");
-	}
-	if (td->iops_log) {
-		if (o->iops_log_file) {
-			finish_log_named(td, td->iops_log,
-						o->iops_log_file, "iops");
-		} else
-			finish_log(td, td->iops_log, "iops");
-	}
+	fio_writeout_logs(td);
 
-	fio_mutex_up(writeout_mutex);
 	if (o->exec_postrun)
 		exec_string(o, o->exec_postrun, (const char *)"postrun");
 
@@ -2033,9 +1995,6 @@ int fio_backend(void)
 	startup_mutex = fio_mutex_init(FIO_MUTEX_LOCKED);
 	if (startup_mutex == NULL)
 		return 1;
-	writeout_mutex = fio_mutex_init(FIO_MUTEX_UNLOCKED);
-	if (writeout_mutex == NULL)
-		return 1;
 
 	set_genesis_time();
 	stat_init();
@@ -2066,7 +2025,6 @@ int fio_backend(void)
 	sfree(cgroup_mnt);
 
 	fio_mutex_remove(startup_mutex);
-	fio_mutex_remove(writeout_mutex);
 	fio_mutex_remove(disk_thread_mutex);
 	stat_exit();
 	return exit_value;
diff --git a/configure b/configure
index 63aa02d..05f985b 100755
--- a/configure
+++ b/configure
@@ -1163,6 +1163,23 @@ if compile_prog "" "-lrbd -lrados" "rbd"; then
 fi
 echo "Rados Block Device engine     $rbd"
 
+##########################################
+# Check whether we have setvbuf
+setvbuf="no"
+cat > $TMPC << EOF
+#include <stdio.h>
+int main(int argc, char **argv)
+{
+  FILE *f = NULL;
+  char buf[80];
+  setvbuf(f, buf, _IOFBF, sizeof(buf));
+  return 0;
+}
+EOF
+if compile_prog "" "" "setvbuf"; then
+  setvbuf="yes"
+fi
+echo "setvbuf                       $setvbuf"
 
 #############################################################################
 
@@ -1291,6 +1308,9 @@ fi
 if test "$cpu_count" = "yes" ; then
   output_sym "CONFIG_CPU_COUNT"
 fi
+if test "$setvbuf" = "yes" ; then
+  output_sym "CONFIG_SETVBUF"
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "CFLAGS+=$CFLAGS" >> $config_host_mak
diff --git a/crc/test.c b/crc/test.c
index 174bea3..2cc7c0f 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -18,6 +18,8 @@
 #include "../crc/sha512.h"
 #include "../crc/xxhash.h"
 
+#include "test.h"
+
 #define CHUNK		131072U
 #define NR_CHUNKS	  2048U
 
diff --git a/crc/test.h b/crc/test.h
new file mode 100644
index 0000000..2b52d6a
--- /dev/null
+++ b/crc/test.h
@@ -0,0 +1,6 @@
+#ifndef FIO_CRC_TEST_H
+#define FIO_CRC_TEST_H
+
+int fio_crctest(const char *type);
+
+#endif
diff --git a/eta.c b/eta.c
index b050102..42066e0 100644
--- a/eta.c
+++ b/eta.c
@@ -74,6 +74,9 @@ static void check_str_update(struct thread_data *td)
 	case TD_FSYNCING:
 		c = 'F';
 		break;
+	case TD_FINISHING:
+		c = 'f';
+		break;
 	case TD_CREATED:
 		c = 'C';
 		break;
@@ -331,7 +334,8 @@ int calc_thread_status(struct jobs_eta *je, int force)
 			bw_avg_time = td->o.bw_avg_time;
 		if (td->runstate == TD_RUNNING || td->runstate == TD_VERIFYING
 		    || td->runstate == TD_FSYNCING
-		    || td->runstate == TD_PRE_READING) {
+		    || td->runstate == TD_PRE_READING
+		    || td->runstate == TD_FINISHING) {
 			je->nr_running++;
 			if (td_read(td)) {
 				je->t_rate[0] += td->o.rate[DDIR_READ];
diff --git a/filehash.c b/filehash.c
index c6ebe76..0d61f54 100644
--- a/filehash.c
+++ b/filehash.c
@@ -21,12 +21,14 @@ static unsigned short hash(const char *name)
 
 void fio_file_hash_lock(void)
 {
-	fio_mutex_down(hash_lock);
+	if (hash_lock)
+		fio_mutex_down(hash_lock);
 }
 
 void fio_file_hash_unlock(void)
 {
-	fio_mutex_up(hash_lock);
+	if (hash_lock)
+		fio_mutex_up(hash_lock);
 }
 
 void remove_file_hash(struct fio_file *f)
diff --git a/filelock.c b/filelock.c
new file mode 100644
index 0000000..b252a97
--- /dev/null
+++ b/filelock.c
@@ -0,0 +1,157 @@
+/*
+ * Really simple exclusive file locking based on filename.
+ * No hash indexing, just a list, so only works well for < 100 files or
+ * so. But that's more than what fio needs, so should be fine.
+ */
+#include <inttypes.h>
+#include <string.h>
+#include <assert.h>
+
+#include "flist.h"
+#include "filelock.h"
+#include "smalloc.h"
+#include "mutex.h"
+#include "hash.h"
+#include "log.h"
+
+struct fio_filelock {
+	uint32_t hash;
+	struct fio_mutex lock;
+	struct flist_head list;
+	unsigned int references;
+};
+	
+static struct flist_head *filelock_list;
+static struct fio_mutex *filelock_lock;
+
+int fio_filelock_init(void)
+{
+	filelock_list = smalloc(sizeof(*filelock_list));
+	if (!filelock_list)
+		return 1;
+
+	INIT_FLIST_HEAD(filelock_list);
+	filelock_lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+	if (!filelock_lock) {
+		sfree(filelock_list);
+		return 1;
+	}
+
+	return 0;
+}
+
+void fio_filelock_exit(void)
+{
+	if (!filelock_list)
+		return;
+
+	assert(flist_empty(filelock_list));
+	sfree(filelock_list);
+	filelock_list = NULL;
+	fio_mutex_remove(filelock_lock);
+	filelock_lock = NULL;
+}
+
+static struct fio_filelock *fio_hash_find(uint32_t hash)
+{
+	struct flist_head *entry;
+	struct fio_filelock *ff;
+
+	flist_for_each(entry, filelock_list) {
+		ff = flist_entry(entry, struct fio_filelock, list);
+		if (ff->hash == hash)
+			return ff;
+	}
+
+	return NULL;
+}
+
+static struct fio_filelock *fio_hash_get(uint32_t hash)
+{
+	struct fio_filelock *ff;
+
+	ff = fio_hash_find(hash);
+	if (!ff) {
+		ff = smalloc(sizeof(*ff));
+		ff->hash = hash;
+		__fio_mutex_init(&ff->lock, FIO_MUTEX_UNLOCKED);
+		ff->references = 0;
+		flist_add(&ff->list, filelock_list);
+	}
+
+	return ff;
+}
+
+int fio_trylock_file(const char *fname)
+{
+	struct fio_filelock *ff;
+	uint32_t hash;
+
+	hash = jhash(fname, strlen(fname), 0);
+
+	fio_mutex_down(filelock_lock);
+	ff = fio_hash_get(hash);
+	ff->references++;
+	fio_mutex_up(filelock_lock);
+
+	if (!fio_mutex_down_trylock(&ff->lock))
+		return 0;
+
+	fio_mutex_down(filelock_lock);
+
+	/*
+	 * If we raced and the only reference to the lock is us, we can
+	 * grab it
+	 */
+	if (ff->references != 1) {
+		ff->references--;
+		ff = NULL;
+	}
+
+	fio_mutex_up(filelock_lock);
+
+	if (ff) {
+		fio_mutex_down(&ff->lock);
+		return 0;
+	}
+
+	return 1;
+}
+
+void fio_lock_file(const char *fname)
+{
+	struct fio_filelock *ff;
+	uint32_t hash;
+
+	hash = jhash(fname, strlen(fname), 0);
+
+	fio_mutex_down(filelock_lock);
+	ff = fio_hash_get(hash);
+	ff->references++;
+	fio_mutex_up(filelock_lock);
+
+	fio_mutex_down(&ff->lock);
+}
+
+void fio_unlock_file(const char *fname)
+{
+	struct fio_filelock *ff;
+	uint32_t hash;
+
+	hash = jhash(fname, strlen(fname), 0);
+
+	fio_mutex_down(filelock_lock);
+
+	ff = fio_hash_find(hash);
+	if (ff) {
+		ff->references--;
+		fio_mutex_up(&ff->lock);
+		if (!ff->references) {
+			flist_del(&ff->list);
+			sfree(ff);
+		}
+	} else
+		log_err("fio: file not found for unlocking\n");
+
+	fio_mutex_up(filelock_lock);
+}
diff --git a/filelock.h b/filelock.h
new file mode 100644
index 0000000..97d13b7
--- /dev/null
+++ b/filelock.h
@@ -0,0 +1,11 @@
+#ifndef FIO_LOCK_FILE_H
+#define FIO_LOCK_FILE_H
+
+extern void fio_lock_file(const char *);
+extern int fio_trylock_file(const char *);
+extern void fio_unlock_file(const char *);
+
+extern int fio_filelock_init(void);
+extern void fio_filelock_exit(void);
+
+#endif
diff --git a/fio.h b/fio.h
index befdce3..a539f21 100644
--- a/fio.h
+++ b/fio.h
@@ -471,6 +471,7 @@ enum {
 	TD_PRE_READING,
 	TD_VERIFYING,
 	TD_FSYNCING,
+	TD_FINISHING,
 	TD_EXITED,
 	TD_REAPED,
 };
diff --git a/init.c b/init.c
index c3996a7..910f2ba 100644
--- a/init.c
+++ b/init.c
@@ -24,6 +24,7 @@
 #include "profile.h"
 #include "server.h"
 #include "idletime.h"
+#include "filelock.h"
 
 #include "lib/getopt.h"
 #include "lib/strcasestr.h"
@@ -259,6 +260,7 @@ static void free_shm(void)
 	}
 
 	options_free(fio_options, &def_thread);
+	fio_filelock_exit();
 	scleanup();
 }
 
@@ -1963,11 +1965,8 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 	if (do_exit && !(is_backend || nr_clients))
 		exit(exit_val);
 
-	if (nr_clients && fio_clients_connect()) {
-		do_exit++;
-		exit_val = 1;
-		return -1;
-	}
+	if (nr_clients && fio_clients_connect())
+		exit(1);
 
 	if (is_backend && backend)
 		return fio_start_server(pid_file);
diff --git a/io_u.c b/io_u.c
index 2f6aecf..411da32 100644
--- a/io_u.c
+++ b/io_u.c
@@ -426,12 +426,10 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 	unsigned int minbs, maxbs;
 	unsigned long r, rand_max;
 
-	assert(ddir_rw(io_u->ddir));
+	assert(ddir_rw(ddir));
 
 	if (td->o.bs_is_seq_rand)
 		ddir = is_random ? DDIR_WRITE: DDIR_READ;
-	else
-		ddir = io_u->ddir;
 
 	minbs = td->o.min_bs[ddir];
 	maxbs = td->o.max_bs[ddir];
diff --git a/iolog.c b/iolog.c
index b8ee067..e805eae 100644
--- a/iolog.c
+++ b/iolog.c
@@ -10,6 +10,7 @@
 #include "fio.h"
 #include "verify.h"
 #include "trim.h"
+#include "filelock.h"
 
 static const char iolog_ver2[] = "fio version 2 iolog";
 
@@ -515,9 +516,36 @@ void setup_log(struct io_log **log, unsigned long avg_msec, int log_type)
 	*log = l;
 }
 
+#ifdef CONFIG_SETVBUF
+static void *set_file_buffer(FILE *f)
+{
+	size_t size = 1048576;
+	void *buf;
+
+	buf = malloc(size);
+	setvbuf(f, buf, _IOFBF, size);
+	return buf;
+}
+
+static void clear_file_buffer(void *buf)
+{
+	free(buf);
+}
+#else
+static void *set_file_buffer(FILE *f)
+{
+	return NULL;
+}
+
+static void clear_file_buffer(void *buf)
+{
+}
+#endif
+
 void __finish_log(struct io_log *log, const char *name)
 {
 	unsigned int i;
+	void *buf;
 	FILE *f;
 
 	f = fopen(name, "a");
@@ -526,6 +554,8 @@ void __finish_log(struct io_log *log, const char *name)
 		return;
 	}
 
+	buf = set_file_buffer(f);
+
 	for (i = 0; i < log->nr_samples; i++) {
 		fprintf(f, "%lu, %lu, %u, %u\n",
 				(unsigned long) log->log[i].time,
@@ -534,27 +564,160 @@ void __finish_log(struct io_log *log, const char *name)
 	}
 
 	fclose(f);
+	clear_file_buffer(buf);
 	free(log->log);
 	free(log);
 }
 
-void finish_log_named(struct thread_data *td, struct io_log *log,
-		       const char *prefix, const char *postfix)
+static int finish_log_named(struct thread_data *td, struct io_log *log,
+			    const char *prefix, const char *postfix,
+			    int trylock)
 {
-	char file_name[256], *p;
+	char file_name[256];
 
 	snprintf(file_name, sizeof(file_name), "%s_%s.log", prefix, postfix);
-	p = basename(file_name);
+
+	if (trylock) {
+		if (fio_trylock_file(file_name))
+			return 1;
+	} else
+		fio_lock_file(file_name);
 
 	if (td->client_type == FIO_CLIENT_TYPE_GUI) {
-		fio_send_iolog(td, log, p);
+		fio_send_iolog(td, log, file_name);
 		free(log->log);
 		free(log);
 	} else
-		__finish_log(log, p);
+		__finish_log(log, file_name);
+
+	fio_unlock_file(file_name);
+	return 0;
+}
+
+static int finish_log(struct thread_data *td, struct io_log *log,
+		      const char *name, int trylock)
+{
+	return finish_log_named(td, log, td->o.name, name, trylock);
+}
+
+static int write_this_log(struct thread_data *td, struct io_log *log,
+			  const char *log_file, const char *name, int try)
+{
+	int ret;
+
+	if (!log)
+		return 0;
+
+	if (log_file)
+		ret = finish_log_named(td, log, log_file, name, try);
+	else
+		ret = finish_log(td, log, name, try);
+
+	return ret;
 }
 
-void finish_log(struct thread_data *td, struct io_log *log, const char *name)
+static int write_iops_log(struct thread_data *td, int try)
 {
-	finish_log_named(td, log, td->o.name, name);
+	struct thread_options *o = &td->o;
+
+	return write_this_log(td, td->iops_log, o->iops_log_file, "iops", try);
+}
+
+static int write_slat_log(struct thread_data *td, int try)
+{
+	struct thread_options *o = &td->o;
+
+	return write_this_log(td, td->slat_log, o->lat_log_file, "slat", try);
+}
+
+static int write_clat_log(struct thread_data *td, int try)
+{
+	struct thread_options *o = &td->o;
+
+	return write_this_log(td, td->clat_log, o->lat_log_file, "clat" , try);
+}
+
+static int write_lat_log(struct thread_data *td, int try)
+{
+	struct thread_options *o = &td->o;
+
+	return write_this_log(td, td->lat_log, o->lat_log_file, "lat", try);
+}
+
+static int write_bandw_log(struct thread_data *td, int try)
+{
+	struct thread_options *o = &td->o;
+
+	return write_this_log(td, td->bw_log, o->bw_log_file, "bw", try);
+}
+
+enum {
+	BW_LOG_MASK	= 1,
+	LAT_LOG_MASK	= 2,
+	SLAT_LOG_MASK	= 4,
+	CLAT_LOG_MASK	= 8,
+	IOPS_LOG_MASK	= 16,
+
+	ALL_LOG_NR	= 5,
+};
+
+struct log_type {
+	unsigned int mask;
+	int (*fn)(struct thread_data *, int);
+};
+
+static struct log_type log_types[] = {
+	{
+		.mask	= BW_LOG_MASK,
+		.fn	= write_bandw_log,
+	},
+	{
+		.mask	= LAT_LOG_MASK,
+		.fn	= write_lat_log,
+	},
+	{
+		.mask	= SLAT_LOG_MASK,
+		.fn	= write_slat_log,
+	},
+	{
+		.mask	= CLAT_LOG_MASK,
+		.fn	= write_clat_log,
+	},
+	{
+		.mask	= IOPS_LOG_MASK,
+		.fn	= write_iops_log,
+	},
+};
+
+void fio_writeout_logs(struct thread_data *td)
+{
+	unsigned int log_mask = 0;
+	unsigned int log_left = ALL_LOG_NR;
+	int old_state, i;
+
+	old_state = td_bump_runstate(td, TD_FINISHING);
+
+	finalize_logs(td);
+
+	while (log_left) {
+		int prev_log_left = log_left;
+
+		for (i = 0; i < ALL_LOG_NR && log_left; i++) {
+			struct log_type *lt = &log_types[i];
+			int ret;
+
+			if (!(log_mask & lt->mask)) {
+				ret = lt->fn(td, log_left != 1);
+				if (!ret) {
+					log_left--;
+					log_mask |= lt->mask;
+				}
+			}
+		}
+
+		if (prev_log_left == log_left)
+			usleep(5000);
+	}
+
+	td_restore_runstate(td, old_state);
 }
diff --git a/iolog.h b/iolog.h
index 0716391..50d09e2 100644
--- a/iolog.h
+++ b/iolog.h
@@ -131,12 +131,11 @@ extern void add_iops_sample(struct thread_data *, enum fio_ddir, unsigned int,
 extern void init_disk_util(struct thread_data *);
 extern void update_rusage_stat(struct thread_data *);
 extern void setup_log(struct io_log **, unsigned long, int);
-extern void finish_log(struct thread_data *, struct io_log *, const char *);
-extern void finish_log_named(struct thread_data *, struct io_log *, const char *, const char *);
 extern void __finish_log(struct io_log *, const char *);
 extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
 extern int write_bw_log;
 extern void add_agg_sample(unsigned long, enum fio_ddir, unsigned int);
+extern void fio_writeout_logs(struct thread_data *);
 
 static inline void init_ipo(struct io_piece *ipo)
 {
diff --git a/libfio.c b/libfio.c
index 8eddab8..1fd77e4 100644
--- a/libfio.c
+++ b/libfio.c
@@ -31,6 +31,7 @@
 #include "fio.h"
 #include "smalloc.h"
 #include "os/os.h"
+#include "filelock.h"
 
 /*
  * Just expose an empty list, if the OS does not support disk util stats
@@ -265,6 +266,11 @@ int initialize_fio(char *envp[])
 
 	sinit();
 
+	if (fio_filelock_init()) {
+		log_err("fio: failed initializing filelock subsys\n");
+		return 1;
+	}
+
 	/*
 	 * We need locale for number printing, if it isn't set then just
 	 * go with the US format.
diff --git a/mutex.c b/mutex.c
index e1fbb60..466e20e 100644
--- a/mutex.c
+++ b/mutex.c
@@ -25,29 +25,19 @@ void fio_mutex_remove(struct fio_mutex *mutex)
 	munmap((void *) mutex, sizeof(*mutex));
 }
 
-struct fio_mutex *fio_mutex_init(int value)
+int __fio_mutex_init(struct fio_mutex *mutex, int value)
 {
-	struct fio_mutex *mutex = NULL;
 	pthread_mutexattr_t attr;
 	pthread_condattr_t cond;
 	int ret;
 
-	mutex = (void *) mmap(NULL, sizeof(struct fio_mutex),
-				PROT_READ | PROT_WRITE,
-				OS_MAP_ANON | MAP_SHARED, -1, 0);
-	if (mutex == MAP_FAILED) {
-		perror("mmap mutex");
-		mutex = NULL;
-		goto err;
-	}
-
 	mutex->value = value;
 	mutex->magic = FIO_MUTEX_MAGIC;
 
 	ret = pthread_mutexattr_init(&attr);
 	if (ret) {
 		log_err("pthread_mutexattr_init: %s\n", strerror(ret));
-		goto err;
+		return ret;
 	}
 
 	/*
@@ -57,7 +47,7 @@ struct fio_mutex *fio_mutex_init(int value)
 	ret = pthread_mutexattr_setpshared(&attr, PTHREAD_PROCESS_SHARED);
 	if (ret) {
 		log_err("pthread_mutexattr_setpshared: %s\n", strerror(ret));
-		goto err;
+		return ret;
 	}
 #endif
 
@@ -70,17 +60,30 @@ struct fio_mutex *fio_mutex_init(int value)
 	ret = pthread_mutex_init(&mutex->lock, &attr);
 	if (ret) {
 		log_err("pthread_mutex_init: %s\n", strerror(ret));
-		goto err;
+		return ret;
 	}
 
 	pthread_condattr_destroy(&cond);
 	pthread_mutexattr_destroy(&attr);
+	return 0;
+}
 
-	return mutex;
-err:
-	if (mutex)
-		fio_mutex_remove(mutex);
+struct fio_mutex *fio_mutex_init(int value)
+{
+	struct fio_mutex *mutex = NULL;
+
+	mutex = (void *) mmap(NULL, sizeof(struct fio_mutex),
+				PROT_READ | PROT_WRITE,
+				OS_MAP_ANON | MAP_SHARED, -1, 0);
+	if (mutex == MAP_FAILED) {
+		perror("mmap mutex");
+		return NULL;
+	}
+
+	if (!__fio_mutex_init(mutex, value))
+		return mutex;
 
+	fio_mutex_remove(mutex);
 	return NULL;
 }
 
@@ -125,6 +128,22 @@ int fio_mutex_down_timeout(struct fio_mutex *mutex, unsigned int seconds)
 	return ret;
 }
 
+int fio_mutex_down_trylock(struct fio_mutex *mutex)
+{
+	int ret = 1;
+
+	assert(mutex->magic == FIO_MUTEX_MAGIC);
+
+	pthread_mutex_lock(&mutex->lock);
+	if (mutex->value) {
+		mutex->value--;
+		ret = 0;
+	}
+	pthread_mutex_unlock(&mutex->lock);
+
+	return ret;
+}
+
 void fio_mutex_down(struct fio_mutex *mutex)
 {
 	assert(mutex->magic == FIO_MUTEX_MAGIC);
diff --git a/mutex.h b/mutex.h
index 4f3486d..246afee 100644
--- a/mutex.h
+++ b/mutex.h
@@ -24,10 +24,12 @@ enum {
 	FIO_MUTEX_UNLOCKED	= 1,
 };
 
+extern int __fio_mutex_init(struct fio_mutex *, int);
 extern struct fio_mutex *fio_mutex_init(int);
 extern void fio_mutex_remove(struct fio_mutex *);
 extern void fio_mutex_up(struct fio_mutex *);
 extern void fio_mutex_down(struct fio_mutex *);
+extern int fio_mutex_down_trylock(struct fio_mutex *);
 extern int fio_mutex_down_timeout(struct fio_mutex *, unsigned int);
 
 extern void fio_rwlock_read(struct fio_rwlock *);
diff --git a/stat.c b/stat.c
index 4529f69..509c6f0 100644
--- a/stat.c
+++ b/stat.c
@@ -770,7 +770,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	}
 	json_object_add_value_int(dir_object, "bw_min", min);
 	json_object_add_value_int(dir_object, "bw_max", max);
-	json_object_add_value_float(dir_object, "bw_agg", mean);
+	json_object_add_value_float(dir_object, "bw_agg", p_of_agg);
 	json_object_add_value_float(dir_object, "bw_mean", mean);
 	json_object_add_value_float(dir_object, "bw_dev", dev);
 }
