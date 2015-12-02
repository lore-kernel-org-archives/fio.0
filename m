Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56609 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465AbbLBNAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 Dec 2015 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1a470u-0000eS-5F
	for fio@vger.kernel.org; Wed, 02 Dec 2015 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151202130002.9FD8D2C2852@kernel.dk>
Date: Wed,  2 Dec 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b9c8a72a5795a58bd6bf060a79393e835db57a95:

  Makefile: missing conversion, and oslib/ dep cleanup (2015-11-30 19:46:20 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a655bbc42903e27775600dc4d359ed8ac9d0992d:

  configure: add --disable-lex (2015-12-01 09:25:08 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      Add 'bool' type
      mutex: use bool
      workqueue: bool
      configure: add --disable-lex

 backend.c   | 114 ++++++++++++++++++++++++++++++------------------------------
 configure   |  26 ++++++++++++++
 io_u.c      |  56 ++++++++++++++---------------
 ioengine.h  |   2 +-
 lib/axmap.c |  45 ++++++++++++------------
 lib/axmap.h |   3 +-
 lib/types.h |  16 +++++++++
 mutex.c     |   8 ++---
 mutex.h     |   3 +-
 os/os.h     |   1 +
 workqueue.c |   6 ++--
 11 files changed, 163 insertions(+), 117 deletions(-)
 create mode 100644 lib/types.h

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 9a142e8..4a689eb 100644
--- a/backend.c
+++ b/backend.c
@@ -144,8 +144,8 @@ static void set_sig_handlers(void)
 /*
  * Check if we are above the minimum rate given.
  */
-static int __check_min_rate(struct thread_data *td, struct timeval *now,
-			    enum fio_ddir ddir)
+static bool __check_min_rate(struct thread_data *td, struct timeval *now,
+			     enum fio_ddir ddir)
 {
 	unsigned long long bytes = 0;
 	unsigned long iops = 0;
@@ -158,13 +158,13 @@ static int __check_min_rate(struct thread_data *td, struct timeval *now,
 	assert(ddir_rw(ddir));
 
 	if (!td->o.ratemin[ddir] && !td->o.rate_iops_min[ddir])
-		return 0;
+		return false;
 
 	/*
 	 * allow a 2 second settle period in the beginning
 	 */
 	if (mtime_since(&td->start, now) < 2000)
-		return 0;
+		return false;
 
 	iops += td->this_io_blocks[ddir];
 	bytes += td->this_io_bytes[ddir];
@@ -178,7 +178,7 @@ static int __check_min_rate(struct thread_data *td, struct timeval *now,
 	if (td->rate_bytes[ddir] || td->rate_blocks[ddir]) {
 		spent = mtime_since(&td->lastrate[ddir], now);
 		if (spent < td->o.ratecycle)
-			return 0;
+			return false;
 
 		if (td->o.rate[ddir] || td->o.ratemin[ddir]) {
 			/*
@@ -187,7 +187,7 @@ static int __check_min_rate(struct thread_data *td, struct timeval *now,
 			if (bytes < td->rate_bytes[ddir]) {
 				log_err("%s: min rate %u not met\n", td->o.name,
 								ratemin);
-				return 1;
+				return true;
 			} else {
 				if (spent)
 					rate = ((bytes - td->rate_bytes[ddir]) * 1000) / spent;
@@ -199,7 +199,7 @@ static int __check_min_rate(struct thread_data *td, struct timeval *now,
 					log_err("%s: min rate %u not met, got"
 						" %luKB/sec\n", td->o.name,
 							ratemin, rate);
-					return 1;
+					return true;
 				}
 			}
 		} else {
@@ -209,7 +209,7 @@ static int __check_min_rate(struct thread_data *td, struct timeval *now,
 			if (iops < rate_iops) {
 				log_err("%s: min iops rate %u not met\n",
 						td->o.name, rate_iops);
-				return 1;
+				return true;
 			} else {
 				if (spent)
 					rate = ((iops - td->rate_blocks[ddir]) * 1000) / spent;
@@ -221,7 +221,7 @@ static int __check_min_rate(struct thread_data *td, struct timeval *now,
 					log_err("%s: min iops rate %u not met,"
 						" got %lu\n", td->o.name,
 							rate_iops_min, rate);
-					return 1;
+					return true;
 				}
 			}
 		}
@@ -230,12 +230,12 @@ static int __check_min_rate(struct thread_data *td, struct timeval *now,
 	td->rate_bytes[ddir] = bytes;
 	td->rate_blocks[ddir] = iops;
 	memcpy(&td->lastrate[ddir], now, sizeof(*now));
-	return 0;
+	return false;
 }
 
-static int check_min_rate(struct thread_data *td, struct timeval *now)
+static bool check_min_rate(struct thread_data *td, struct timeval *now)
 {
-	int ret = 0;
+	bool ret = false;
 
 	if (td->bytes_done[DDIR_READ])
 		ret |= __check_min_rate(td, now, DDIR_READ);
@@ -286,20 +286,20 @@ static void cleanup_pending_aio(struct thread_data *td)
  * Helper to handle the final sync of a file. Works just like the normal
  * io path, just does everything sync.
  */
-static int fio_io_sync(struct thread_data *td, struct fio_file *f)
+static bool fio_io_sync(struct thread_data *td, struct fio_file *f)
 {
 	struct io_u *io_u = __get_io_u(td);
 	int ret;
 
 	if (!io_u)
-		return 1;
+		return true;
 
 	io_u->ddir = DDIR_SYNC;
 	io_u->file = f;
 
 	if (td_io_prep(td, io_u)) {
 		put_io_u(td, io_u);
-		return 1;
+		return true;
 	}
 
 requeue:
@@ -307,25 +307,25 @@ requeue:
 	if (ret < 0) {
 		td_verror(td, io_u->error, "td_io_queue");
 		put_io_u(td, io_u);
-		return 1;
+		return true;
 	} else if (ret == FIO_Q_QUEUED) {
 		if (io_u_queued_complete(td, 1) < 0)
-			return 1;
+			return true;
 	} else if (ret == FIO_Q_COMPLETED) {
 		if (io_u->error) {
 			td_verror(td, io_u->error, "td_io_queue");
-			return 1;
+			return true;
 		}
 
 		if (io_u_sync_complete(td, io_u) < 0)
-			return 1;
+			return true;
 	} else if (ret == FIO_Q_BUSY) {
 		if (td_io_commit(td))
-			return 1;
+			return true;
 		goto requeue;
 	}
 
-	return 0;
+	return false;
 }
 
 static int fio_file_fsync(struct thread_data *td, struct fio_file *f)
@@ -354,16 +354,16 @@ static inline void update_tv_cache(struct thread_data *td)
 		__update_tv_cache(td);
 }
 
-static inline int runtime_exceeded(struct thread_data *td, struct timeval *t)
+static inline bool runtime_exceeded(struct thread_data *td, struct timeval *t)
 {
 	if (in_ramp_time(td))
-		return 0;
+		return false;
 	if (!td->o.timeout)
-		return 0;
+		return false;
 	if (utime_since(&td->epoch, t) >= td->o.timeout)
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 
 /*
@@ -383,8 +383,8 @@ static inline void update_runtime(struct thread_data *td,
 	td->ts.runtime[ddir] += (elapsed_us[ddir] + 999) / 1000;
 }
 
-static int break_on_this_error(struct thread_data *td, enum fio_ddir ddir,
-			       int *retptr)
+static bool break_on_this_error(struct thread_data *td, enum fio_ddir ddir,
+				int *retptr)
 {
 	int ret = *retptr;
 
@@ -397,7 +397,7 @@ static int break_on_this_error(struct thread_data *td, enum fio_ddir ddir,
 
 		eb = td_error_type(ddir, err);
 		if (!(td->o.continue_on_error & (1 << eb)))
-			return 1;
+			return true;
 
 		if (td_non_fatal_error(td, eb, err)) {
 		        /*
@@ -407,7 +407,7 @@ static int break_on_this_error(struct thread_data *td, enum fio_ddir ddir,
 			update_error_count(td, err);
 			td_clear_error(td);
 			*retptr = 0;
-			return 0;
+			return false;
 		} else if (td->o.fill_device && err == ENOSPC) {
 			/*
 			 * We expect to hit this error if
@@ -415,18 +415,18 @@ static int break_on_this_error(struct thread_data *td, enum fio_ddir ddir,
 			 */
 			td_clear_error(td);
 			fio_mark_td_terminate(td);
-			return 1;
+			return true;
 		} else {
 			/*
 			 * Stop the I/O in case of a fatal
 			 * error.
 			 */
 			update_error_count(td, err);
-			return 1;
+			return true;
 		}
 	}
 
-	return 0;
+	return false;
 }
 
 static void check_update_rusage(struct thread_data *td)
@@ -552,7 +552,7 @@ sync_done:
 	return 0;
 }
 
-static inline int io_in_polling(struct thread_data *td)
+static inline bool io_in_polling(struct thread_data *td)
 {
 	return !td->o.iodepth_batch_complete_min &&
 		   !td->o.iodepth_batch_complete_max;
@@ -713,12 +713,12 @@ reap:
 	dprint(FD_VERIFY, "exiting loop\n");
 }
 
-static unsigned int exceeds_number_ios(struct thread_data *td)
+static bool exceeds_number_ios(struct thread_data *td)
 {
 	unsigned long long number_ios;
 
 	if (!td->o.number_ios)
-		return 0;
+		return false;
 
 	number_ios = ddir_rw_sum(td->io_blocks);
 	number_ios += td->io_u_queued + td->io_u_in_flight;
@@ -726,7 +726,7 @@ static unsigned int exceeds_number_ios(struct thread_data *td)
 	return number_ios >= (td->o.number_ios * td->loops);
 }
 
-static int io_issue_bytes_exceeded(struct thread_data *td)
+static bool io_issue_bytes_exceeded(struct thread_data *td)
 {
 	unsigned long long bytes, limit;
 
@@ -748,7 +748,7 @@ static int io_issue_bytes_exceeded(struct thread_data *td)
 	return bytes >= limit || exceeds_number_ios(td);
 }
 
-static int io_complete_bytes_exceeded(struct thread_data *td)
+static bool io_complete_bytes_exceeded(struct thread_data *td)
 {
 	unsigned long long bytes, limit;
 
@@ -1247,20 +1247,20 @@ static int switch_ioscheduler(struct thread_data *td)
 	return 0;
 }
 
-static int keep_running(struct thread_data *td)
+static bool keep_running(struct thread_data *td)
 {
 	unsigned long long limit;
 
 	if (td->done)
-		return 0;
+		return false;
 	if (td->o.time_based)
-		return 1;
+		return true;
 	if (td->o.loops) {
 		td->o.loops--;
-		return 1;
+		return true;
 	}
 	if (exceeds_number_ios(td))
-		return 0;
+		return false;
 
 	if (td->o.io_limit)
 		limit = td->o.io_limit;
@@ -1276,15 +1276,15 @@ static int keep_running(struct thread_data *td)
 		 */
 		diff = limit - ddir_rw_sum(td->io_bytes);
 		if (diff < td_max_bs(td))
-			return 0;
+			return false;
 
 		if (fio_files_done(td))
-			return 0;
+			return false;
 
-		return 1;
+		return true;
 	}
 
-	return 0;
+	return false;
 }
 
 static int exec_string(struct thread_options *o, const char *string, const char *mode)
@@ -1867,29 +1867,29 @@ reaped:
 		fio_terminate_threads(TERMINATE_ALL);
 }
 
-static int __check_trigger_file(void)
+static bool __check_trigger_file(void)
 {
 	struct stat sb;
 
 	if (!trigger_file)
-		return 0;
+		return false;
 
 	if (stat(trigger_file, &sb))
-		return 0;
+		return false;
 
 	if (unlink(trigger_file) < 0)
 		log_err("fio: failed to unlink %s: %s\n", trigger_file,
 							strerror(errno));
 
-	return 1;
+	return true;
 }
 
-static int trigger_timedout(void)
+static bool trigger_timedout(void)
 {
 	if (trigger_timeout)
 		return time_since_genesis() >= trigger_timeout;
 
-	return 0;
+	return false;
 }
 
 void exec_trigger(const char *cmd)
@@ -1945,13 +1945,13 @@ static void do_usleep(unsigned int usecs)
 	usleep(usecs);
 }
 
-static int check_mount_writes(struct thread_data *td)
+static bool check_mount_writes(struct thread_data *td)
 {
 	struct fio_file *f;
 	unsigned int i;
 
 	if (!td_write(td) || td->o.allow_mounted_write)
-		return 0;
+		return false;
 
 	for_each_file(td, f, i) {
 		if (f->filetype != FIO_TYPE_BD)
@@ -1960,10 +1960,10 @@ static int check_mount_writes(struct thread_data *td)
 			goto mounted;
 	}
 
-	return 0;
+	return false;
 mounted:
 	log_err("fio: %s appears mounted, and 'allow_mounted_write' isn't set. Aborting.", f->file_name);
-	return 1;
+	return true;
 }
 
 /*
diff --git a/configure b/configure
index 7489775..af26165 100755
--- a/configure
+++ b/configure
@@ -135,6 +135,7 @@ show_help="no"
 exit_val=0
 gfio_check="no"
 libhdfs="no"
+disable_lex="no"
 prefix=/usr/local
 
 # parse options
@@ -168,6 +169,8 @@ for opt do
   ;;
   --enable-libhdfs) libhdfs="yes"
   ;;
+  --disable-lex) disable_lex="yes"
+  ;;
   --disable-shm) no_shm="yes"
   ;;
   --disable-optimizations) disable_opt="yes"
@@ -194,6 +197,7 @@ if test "$show_help" = "yes" ; then
   echo "--disable-numa         Disable libnuma even if found"
   echo "--disable-gfapi        Disable gfapi"
   echo "--enable-libhdfs       Enable hdfs support"
+  echo "--disable-lex          Disable use of lex/yacc for math"
   echo "--disable-shm          Disable SHM support"
   echo "--disable-optimizations Don't enable compiler optimizations"
   exit $exit_val
@@ -1451,6 +1455,7 @@ yacc="no"
 yacc_is_bison="no"
 lex="no"
 arith="no"
+if test "$disable_lex" = "no"; then
 if test "$targetos" != "SunOS" ; then
 LEX=$(which lex 2> /dev/null)
 if test -x "$LEX" ; then
@@ -1487,6 +1492,7 @@ else
 fi
 fi
 fi
+fi
 
 echo "lex/yacc for arithmetic       $arith"
 
@@ -1558,6 +1564,23 @@ if compile_prog "" "" "static_assert"; then
     static_assert="yes"
 fi
 echo "Static Assert                 $static_assert"
+
+##########################################
+# Check whether we have bool / stdbool.h
+have_bool="no"
+cat > $TMPC << EOF
+#include <stdbool.h>
+int main(int argc, char **argv)
+{
+  bool var = true;
+  return var != false;
+}
+EOF
+if compile_prog "" "" "bool"; then
+  have_bool="yes"
+fi
+echo "bool                          $have_bool"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -1743,6 +1766,9 @@ fi
 if test "$static_assert" = "yes" ; then
   output_sym "CONFIG_STATIC_ASSERT"
 fi
+if test "$have_bool" = "yes" ; then
+  output_sym "CONFIG_HAVE_BOOL"
+fi
 
 if test "$zlib" = "no" ; then
   echo "Consider installing zlib-dev (zlib-devel), some fio features depend on it."
diff --git a/io_u.c b/io_u.c
index 3b27d5e..d45a6f0 100644
--- a/io_u.c
+++ b/io_u.c
@@ -27,7 +27,7 @@ struct io_completion_data {
  * The ->io_axmap contains a map of blocks we have or have not done io
  * to yet. Used to make sure we cover the entire range in a fair fashion.
  */
-static int random_map_free(struct fio_file *f, const uint64_t block)
+static bool random_map_free(struct fio_file *f, const uint64_t block)
 {
 	return !axmap_isset(f->io_axmap, block);
 }
@@ -190,29 +190,29 @@ static int get_off_from_method(struct thread_data *td, struct fio_file *f,
  * Sort the reads for a verify phase in batches of verifysort_nr, if
  * specified.
  */
-static inline int should_sort_io(struct thread_data *td)
+static inline bool should_sort_io(struct thread_data *td)
 {
 	if (!td->o.verifysort_nr || !td->o.do_verify)
-		return 0;
+		return false;
 	if (!td_random(td))
-		return 0;
+		return false;
 	if (td->runstate != TD_VERIFYING)
-		return 0;
+		return false;
 	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE ||
 	    td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64)
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 
-static int should_do_random(struct thread_data *td, enum fio_ddir ddir)
+static bool should_do_random(struct thread_data *td, enum fio_ddir ddir)
 {
 	uint64_t frand_max;
 	unsigned int v;
 	unsigned long r;
 
 	if (td->o.perc_rand[ddir] == 100)
-		return 1;
+		return true;
 
 	frand_max = rand_max(&td->seq_rand_state[ddir]);
 	r = __rand(&td->seq_rand_state[ddir]);
@@ -431,8 +431,8 @@ static int get_next_offset(struct thread_data *td, struct io_u *io_u,
 	return __get_next_offset(td, io_u, is_random);
 }
 
-static inline int io_u_fits(struct thread_data *td, struct io_u *io_u,
-			    unsigned int buflen)
+static inline bool io_u_fits(struct thread_data *td, struct io_u *io_u,
+			     unsigned int buflen)
 {
 	struct fio_file *f = io_u->file;
 
@@ -1191,10 +1191,10 @@ static void lat_new_cycle(struct thread_data *td)
  * We had an IO outside the latency target. Reduce the queue depth. If we
  * are at QD=1, then it's time to give up.
  */
-static int __lat_target_failed(struct thread_data *td)
+static bool __lat_target_failed(struct thread_data *td)
 {
 	if (td->latency_qd == 1)
-		return 1;
+		return true;
 
 	td->latency_qd_high = td->latency_qd;
 
@@ -1211,16 +1211,16 @@ static int __lat_target_failed(struct thread_data *td)
 	 */
 	io_u_quiesce(td);
 	lat_new_cycle(td);
-	return 0;
+	return false;
 }
 
-static int lat_target_failed(struct thread_data *td)
+static bool lat_target_failed(struct thread_data *td)
 {
 	if (td->o.latency_percentile.u.f == 100.0)
 		return __lat_target_failed(td);
 
 	td->latency_failed++;
-	return 0;
+	return false;
 }
 
 void lat_target_init(struct thread_data *td)
@@ -1315,14 +1315,14 @@ void lat_target_check(struct thread_data *td)
  * If latency target is enabled, we might be ramping up or down and not
  * using the full queue depth available.
  */
-int queue_full(const struct thread_data *td)
+bool queue_full(const struct thread_data *td)
 {
 	const int qempty = io_u_qempty(&td->io_u_freelist);
 
 	if (qempty)
-		return 1;
+		return true;
 	if (!td->o.latency_target)
-		return 0;
+		return false;
 
 	return td->cur_depth >= td->latency_qd;
 }
@@ -1374,10 +1374,10 @@ again:
 	return io_u;
 }
 
-static int check_get_trim(struct thread_data *td, struct io_u *io_u)
+static bool check_get_trim(struct thread_data *td, struct io_u *io_u)
 {
 	if (!(td->flags & TD_F_TRIM_BACKLOG))
-		return 0;
+		return false;
 
 	if (td->trim_entries) {
 		int get_trim = 0;
@@ -1394,16 +1394,16 @@ static int check_get_trim(struct thread_data *td, struct io_u *io_u)
 		}
 
 		if (get_trim && !get_next_trim(td, io_u))
-			return 1;
+			return true;
 	}
 
-	return 0;
+	return false;
 }
 
-static int check_get_verify(struct thread_data *td, struct io_u *io_u)
+static bool check_get_verify(struct thread_data *td, struct io_u *io_u)
 {
 	if (!(td->flags & TD_F_VER_BACKLOG))
-		return 0;
+		return false;
 
 	if (td->io_hist_len) {
 		int get_verify = 0;
@@ -1420,11 +1420,11 @@ static int check_get_verify(struct thread_data *td, struct io_u *io_u)
 
 		if (get_verify && !get_next_verify(td, io_u)) {
 			td->verify_batch--;
-			return 1;
+			return true;
 		}
 	}
 
-	return 0;
+	return false;
 }
 
 /*
@@ -1597,7 +1597,7 @@ void io_u_log_error(struct thread_data *td, struct io_u *io_u)
 		__io_u_log_error(td, io_u);
 }
 
-static inline int gtod_reduce(struct thread_data *td)
+static inline bool gtod_reduce(struct thread_data *td)
 {
 	return td->o.disable_clat && td->o.disable_lat && td->o.disable_slat
 		&& td->o.disable_bw;
diff --git a/ioengine.h b/ioengine.h
index f7f3ec3..c557f7a 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -221,7 +221,7 @@ extern void fill_io_buffer(struct thread_data *, void *, unsigned int, unsigned
 extern void io_u_fill_buffer(struct thread_data *td, struct io_u *, unsigned int, unsigned int);
 void io_u_mark_complete(struct thread_data *, unsigned int);
 void io_u_mark_submit(struct thread_data *, unsigned int);
-int queue_full(const struct thread_data *);
+bool queue_full(const struct thread_data *);
 
 int do_io_u_sync(const struct thread_data *, struct io_u *);
 int do_io_u_trim(const struct thread_data *, struct io_u *);
diff --git a/lib/axmap.c b/lib/axmap.c
index 9153df5..2ee3a25 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -129,8 +129,8 @@ err:
 	return NULL;
 }
 
-static int axmap_handler(struct axmap *axmap, uint64_t bit_nr,
-			  int (*func)(struct axmap_level *, unsigned long, unsigned int,
+static bool axmap_handler(struct axmap *axmap, uint64_t bit_nr,
+			  bool (*func)(struct axmap_level *, unsigned long, unsigned int,
 			  void *), void *data)
 {
 	struct axmap_level *al;
@@ -144,14 +144,14 @@ static int axmap_handler(struct axmap *axmap, uint64_t bit_nr,
 		al = &axmap->levels[i];
 
 		if (func(al, offset, bit, data))
-			return 1;
+			return true;
 	}
 
-	return 0;
+	return false;
 }
 
-static int axmap_handler_topdown(struct axmap *axmap, uint64_t bit_nr,
-	int (*func)(struct axmap_level *, unsigned long, unsigned int, void *),
+static bool axmap_handler_topdown(struct axmap *axmap, uint64_t bit_nr,
+	bool (*func)(struct axmap_level *, unsigned long, unsigned int, void *),
 	void *data)
 {
 	struct axmap_level *al;
@@ -165,20 +165,20 @@ static int axmap_handler_topdown(struct axmap *axmap, uint64_t bit_nr,
 		al = &axmap->levels[i];
 
 		if (func(al, offset, bit, data))
-			return 1;
+			return true;
 	}
 
-	return 0;
+	return false;
 }
 
-static int axmap_clear_fn(struct axmap_level *al, unsigned long offset,
+static bool axmap_clear_fn(struct axmap_level *al, unsigned long offset,
 			   unsigned int bit, void *unused)
 {
 	if (!(al->map[offset] & (1UL << bit)))
-		return 1;
+		return true;
 
 	al->map[offset] &= ~(1UL << bit);
-	return 0;
+	return false;
 }
 
 void axmap_clear(struct axmap *axmap, uint64_t bit_nr)
@@ -213,7 +213,7 @@ static unsigned long bit_masks[] = {
 #endif
 };
 
-static int axmap_set_fn(struct axmap_level *al, unsigned long offset,
+static bool axmap_set_fn(struct axmap_level *al, unsigned long offset,
 			 unsigned int bit, void *__data)
 {
 	struct axmap_set_data *data = __data;
@@ -229,7 +229,7 @@ static int axmap_set_fn(struct axmap_level *al, unsigned long offset,
 	 */
 	overlap = al->map[offset] & mask;
 	if (overlap == mask)
-		return 1;
+		return true;
 
 	while (overlap) {
 		unsigned long clear_mask = ~(1UL << ffz(~overlap));
@@ -290,7 +290,8 @@ void axmap_set(struct axmap *axmap, uint64_t bit_nr)
 	__axmap_set(axmap, bit_nr, &data);
 }
 
-unsigned int axmap_set_nr(struct axmap *axmap, uint64_t bit_nr, unsigned int nr_bits)
+unsigned int axmap_set_nr(struct axmap *axmap, uint64_t bit_nr,
+			  unsigned int nr_bits)
 {
 	unsigned int set_bits = 0;
 
@@ -315,18 +316,18 @@ unsigned int axmap_set_nr(struct axmap *axmap, uint64_t bit_nr, unsigned int nr_
 	return set_bits;
 }
 
-static int axmap_isset_fn(struct axmap_level *al, unsigned long offset,
-			    unsigned int bit, void *unused)
+static bool axmap_isset_fn(struct axmap_level *al, unsigned long offset,
+			   unsigned int bit, void *unused)
 {
 	return (al->map[offset] & (1UL << bit)) != 0;
 }
 
-int axmap_isset(struct axmap *axmap, uint64_t bit_nr)
+bool axmap_isset(struct axmap *axmap, uint64_t bit_nr)
 {
 	if (bit_nr <= axmap->nr_bits)
 		return axmap_handler_topdown(axmap, bit_nr, axmap_isset_fn, NULL);
 
-	return 0;
+	return false;
 }
 
 static uint64_t axmap_find_first_free(struct axmap *axmap, unsigned int level,
@@ -384,23 +385,23 @@ struct axmap_next_free_data {
 	uint64_t bit;
 };
 
-static int axmap_next_free_fn(struct axmap_level *al, unsigned long offset,
+static bool axmap_next_free_fn(struct axmap_level *al, unsigned long offset,
 			       unsigned int bit, void *__data)
 {
 	struct axmap_next_free_data *data = __data;
 	uint64_t mask = ~bit_masks[(data->bit + 1) & BLOCKS_PER_UNIT_MASK];
 
 	if (!(mask & ~al->map[offset]))
-		return 0;
+		return false;
 
 	if (al->map[offset] != -1UL) {
 		data->level = al->level;
 		data->offset = offset;
-		return 1;
+		return true;
 	}
 
 	data->bit = (data->bit + BLOCKS_PER_UNIT - 1) / BLOCKS_PER_UNIT;
-	return 0;
+	return false;
 }
 
 /*
diff --git a/lib/axmap.h b/lib/axmap.h
index 3705a1d..a7a6f94 100644
--- a/lib/axmap.h
+++ b/lib/axmap.h
@@ -2,6 +2,7 @@
 #define FIO_BITMAP_H
 
 #include <inttypes.h>
+#include "types.h"
 
 struct axmap;
 struct axmap *axmap_new(unsigned long nr_bits);
@@ -10,7 +11,7 @@ void axmap_free(struct axmap *bm);
 void axmap_clear(struct axmap *axmap, uint64_t bit_nr);
 void axmap_set(struct axmap *axmap, uint64_t bit_nr);
 unsigned int axmap_set_nr(struct axmap *axmap, uint64_t bit_nr, unsigned int nr_bits);
-int axmap_isset(struct axmap *axmap, uint64_t bit_nr);
+bool axmap_isset(struct axmap *axmap, uint64_t bit_nr);
 uint64_t axmap_next_free(struct axmap *axmap, uint64_t bit_nr);
 void axmap_reset(struct axmap *axmap);
 
diff --git a/lib/types.h b/lib/types.h
new file mode 100644
index 0000000..287a3b4
--- /dev/null
+++ b/lib/types.h
@@ -0,0 +1,16 @@
+#ifndef FIO_TYPES_H
+#define FIO_TYPES_H
+
+#ifndef CONFIG_HAVE_BOOL
+typedef int bool;
+#ifndef false
+#define false	0
+#endif
+#ifndef true
+#define true	1
+#endif
+#else
+#include <stdbool.h>
+#endif
+
+#endif
diff --git a/mutex.c b/mutex.c
index 53f9651..7612b32 100644
--- a/mutex.c
+++ b/mutex.c
@@ -92,7 +92,7 @@ struct fio_mutex *fio_mutex_init(int value)
 	return NULL;
 }
 
-static int mutex_timed_out(struct timeval *t, unsigned int seconds)
+static bool mutex_timed_out(struct timeval *t, unsigned int seconds)
 {
 	return mtime_since_now(t) >= seconds * 1000;
 }
@@ -133,16 +133,16 @@ int fio_mutex_down_timeout(struct fio_mutex *mutex, unsigned int seconds)
 	return ret;
 }
 
-int fio_mutex_down_trylock(struct fio_mutex *mutex)
+bool fio_mutex_down_trylock(struct fio_mutex *mutex)
 {
-	int ret = 1;
+	bool ret = true;
 
 	assert(mutex->magic == FIO_MUTEX_MAGIC);
 
 	pthread_mutex_lock(&mutex->lock);
 	if (mutex->value) {
 		mutex->value--;
-		ret = 0;
+		ret = false;
 	}
 	pthread_mutex_unlock(&mutex->lock);
 
diff --git a/mutex.h b/mutex.h
index 17380de..8c1a711 100644
--- a/mutex.h
+++ b/mutex.h
@@ -2,6 +2,7 @@
 #define FIO_MUTEX_H
 
 #include <pthread.h>
+#include "lib/types.h"
 
 #define FIO_MUTEX_MAGIC		0x4d555445U
 #define FIO_RWLOCK_MAGIC	0x52574c4fU
@@ -30,7 +31,7 @@ extern void __fio_mutex_remove(struct fio_mutex *);
 extern void fio_mutex_remove(struct fio_mutex *);
 extern void fio_mutex_up(struct fio_mutex *);
 extern void fio_mutex_down(struct fio_mutex *);
-extern int fio_mutex_down_trylock(struct fio_mutex *);
+extern bool fio_mutex_down_trylock(struct fio_mutex *);
 extern int fio_mutex_down_timeout(struct fio_mutex *, unsigned int);
 
 extern void fio_rwlock_read(struct fio_rwlock *);
diff --git a/os/os.h b/os/os.h
index c46d8a3..fd47f22 100644
--- a/os/os.h
+++ b/os/os.h
@@ -9,6 +9,7 @@
 #include <stdlib.h>
 
 #include "../arch/arch.h"
+#include "../lib/types.h"
 
 enum {
 	os_linux = 1,
diff --git a/workqueue.c b/workqueue.c
index 7a69be2..3442375 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -79,7 +79,7 @@ static struct submit_worker *get_submit_worker(struct workqueue *wq)
 	return sw;
 }
 
-static int all_sw_idle(struct workqueue *wq)
+static bool all_sw_idle(struct workqueue *wq)
 {
 	int i;
 
@@ -87,10 +87,10 @@ static int all_sw_idle(struct workqueue *wq)
 		struct submit_worker *sw = &wq->workers[i];
 
 		if (!(sw->flags & SW_F_IDLE))
-			return 0;
+			return false;
 	}
 
-	return 1;
+	return true;
 }
 
 /*
