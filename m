Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48618 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgAQNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 17 Jan 2020 08:00:07 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1isREL-0007JC-AI
        for fio@vger.kernel.org; Fri, 17 Jan 2020 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200117130002.4EFE41BC0EAC@kernel.dk>
Date: Fri, 17 Jan 2020 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3f1e3af7cff07d4aedcd9a58ae00cb1a2189fcc2:

  engines/io_uring: use fixed opcodes for pre-mapped buffers (2020-01-14 14:27:22 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e08e2dd7b77f99e4bb904fc1df2395c2fe2ffbbe:

  Merge branch 'fix_verify_push' of https://github.com/gwendalcr/fio (2020-01-16 15:44:44 -0700)

----------------------------------------------------------------
Andrey Kuzmin (1):
      Use aux_path, if set, when loading verify state

Bart Van Assche (7):
      blktrace: Pass a positive error code to td_verror()
      blktrace: Check value of 'merge_buf' pointer before using it
      blktrace: Fix memory leaks in error paths
      server: Make it explicit that the setsockopt() return value is ignored
      t/memlock: Verify 'threads' argument
      t/read-to-pipe-async: Do not divide by zero
      t/read-to-pipe-async: Complain if pthread_detach() fails

Gwendal Grignou (1):
      verify: Fix test to not check for numberio when verify_only is true

Jens Axboe (3):
      Merge branch 'issue-825' of https://github.com/LeaflessMelospiza/fio
      Merge branch 'master' of https://github.com/bvanassche/fio
      Merge branch 'fix_verify_push' of https://github.com/gwendalcr/fio

LeaflessMelospiza (1):
      Moved diskutil reporting functions to stat.c

 backend.c              |  12 ++-
 blktrace.c             |  23 ++++--
 diskutil.c             | 217 -------------------------------------------------
 diskutil.h             |  12 ---
 server.c               |   3 +-
 stat.c                 | 212 +++++++++++++++++++++++++++++++++++++++++++++++
 stat.h                 |   8 +-
 t/memlock.c            |   4 +
 t/read-to-pipe-async.c |  16 ++--
 verify.c               |   6 +-
 10 files changed, 264 insertions(+), 249 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 0d1f4734..936203dc 100644
--- a/backend.c
+++ b/backend.c
@@ -2120,8 +2120,16 @@ static int fio_verify_load_state(struct thread_data *td)
 					td->thread_number - 1, &data);
 		if (!ret)
 			verify_assign_state(td, data);
-	} else
-		ret = verify_load_state(td, "local");
+	} else {
+		char prefix[PATH_MAX];
+
+		if (aux_path)
+			sprintf(prefix, "%s%clocal", aux_path,
+					FIO_OS_PATH_SEPARATOR);
+		else
+			strcpy(prefix, "local");
+		ret = verify_load_state(td, prefix);
+	}
 
 	return ret;
 }
diff --git a/blktrace.c b/blktrace.c
index 8a246613..64a610a9 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -28,8 +28,11 @@ static int refill_fifo(struct thread_data *td, struct fifo *fifo, int fd)
 
 	ret = read(fd, buf, total);
 	if (ret < 0) {
-		td_verror(td, errno, "read blktrace file");
-		return -1;
+		int read_err = errno;
+
+		assert(read_err > 0);
+		td_verror(td, read_err, "read blktrace file");
+		return -read_err;
 	}
 
 	if (ret > 0)
@@ -486,7 +489,7 @@ bool load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 		}
 		ret = discard_pdu(td, fifo, fd, &t);
 		if (ret < 0) {
-			td_verror(td, ret, "blktrace lseek");
+			td_verror(td, -ret, "blktrace lseek");
 			goto err;
 		} else if (t.pdu_len != ret) {
 			log_err("fio: discarded %d of %d\n", ret, t.pdu_len);
@@ -663,7 +666,7 @@ read_skip:
 	    t_get_ddir(t) == DDIR_INVAL) {
 		ret = discard_pdu(td, bc->fifo, bc->fd, t);
 		if (ret < 0) {
-			td_verror(td, ret, "blktrace lseek");
+			td_verror(td, -ret, "blktrace lseek");
 			return ret;
 		} else if (t->pdu_len != ret) {
 			log_err("fio: discarded %d of %d\n", ret,
@@ -716,9 +719,11 @@ int merge_blktrace_iologs(struct thread_data *td)
 	/* setup output file */
 	merge_fp = fopen(td->o.merge_blktrace_file, "w");
 	merge_buf = malloc(128 * 1024);
+	if (!merge_buf)
+		goto err_out_file;
 	ret = setvbuf(merge_fp, merge_buf, _IOFBF, 128 * 1024);
 	if (ret)
-		goto err_out_file;
+		goto err_merge_buf;
 
 	/* setup input files */
 	str = ptr = strdup(td->o.read_iolog_file);
@@ -728,6 +733,7 @@ int merge_blktrace_iologs(struct thread_data *td)
 		if (bcs[i].fd < 0) {
 			log_err("fio: could not open file: %s\n", name);
 			ret = bcs[i].fd;
+			free(str);
 			goto err_file;
 		}
 		bcs[i].fifo = fifo_alloc(TRACE_FIFO_SIZE);
@@ -735,11 +741,13 @@ int merge_blktrace_iologs(struct thread_data *td)
 
 		if (!is_blktrace(name, &bcs[i].swap)) {
 			log_err("fio: file is not a blktrace: %s\n", name);
+			free(str);
 			goto err_file;
 		}
 
 		ret = read_trace(td, &bcs[i]);
 		if (ret < 0) {
+			free(str);
 			goto err_file;
 		} else if (!ret) {
 			merge_finish_file(bcs, i, &nr_logs);
@@ -755,7 +763,7 @@ int merge_blktrace_iologs(struct thread_data *td)
 		/* skip over the pdu */
 		ret = discard_pdu(td, bc->fifo, bc->fd, &bc->t);
 		if (ret < 0) {
-			td_verror(td, ret, "blktrace lseek");
+			td_verror(td, -ret, "blktrace lseek");
 			goto err_file;
 		} else if (bc->t.pdu_len != ret) {
 			log_err("fio: discarded %d of %d\n", ret,
@@ -781,10 +789,11 @@ err_file:
 		fifo_free(bcs[i].fifo);
 		close(bcs[i].fd);
 	}
+err_merge_buf:
+	free(merge_buf);
 err_out_file:
 	fflush(merge_fp);
 	fclose(merge_fp);
-	free(merge_buf);
 err_param:
 	free(bcs);
 
diff --git a/diskutil.c b/diskutil.c
index f0744015..6c6380bb 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -498,72 +498,6 @@ void init_disk_util(struct thread_data *td)
 		f->du = __init_disk_util(td, f);
 }
 
-static void show_agg_stats(struct disk_util_agg *agg, int terse,
-			   struct buf_output *out)
-{
-	if (!agg->slavecount)
-		return;
-
-	if (!terse) {
-		log_buf(out, ", aggrios=%llu/%llu, aggrmerge=%llu/%llu, "
-			 "aggrticks=%llu/%llu, aggrin_queue=%llu, "
-			 "aggrutil=%3.2f%%",
-			(unsigned long long) agg->ios[0] / agg->slavecount,
-			(unsigned long long) agg->ios[1] / agg->slavecount,
-			(unsigned long long) agg->merges[0] / agg->slavecount,
-			(unsigned long long) agg->merges[1] / agg->slavecount,
-			(unsigned long long) agg->ticks[0] / agg->slavecount,
-			(unsigned long long) agg->ticks[1] / agg->slavecount,
-			(unsigned long long) agg->time_in_queue / agg->slavecount,
-			agg->max_util.u.f);
-	} else {
-		log_buf(out, ";slaves;%llu;%llu;%llu;%llu;%llu;%llu;%llu;%3.2f%%",
-			(unsigned long long) agg->ios[0] / agg->slavecount,
-			(unsigned long long) agg->ios[1] / agg->slavecount,
-			(unsigned long long) agg->merges[0] / agg->slavecount,
-			(unsigned long long) agg->merges[1] / agg->slavecount,
-			(unsigned long long) agg->ticks[0] / agg->slavecount,
-			(unsigned long long) agg->ticks[1] / agg->slavecount,
-			(unsigned long long) agg->time_in_queue / agg->slavecount,
-			agg->max_util.u.f);
-	}
-}
-
-static void aggregate_slaves_stats(struct disk_util *masterdu)
-{
-	struct disk_util_agg *agg = &masterdu->agg;
-	struct disk_util_stat *dus;
-	struct flist_head *entry;
-	struct disk_util *slavedu;
-	double util;
-
-	flist_for_each(entry, &masterdu->slaves) {
-		slavedu = flist_entry(entry, struct disk_util, slavelist);
-		dus = &slavedu->dus;
-		agg->ios[0] += dus->s.ios[0];
-		agg->ios[1] += dus->s.ios[1];
-		agg->merges[0] += dus->s.merges[0];
-		agg->merges[1] += dus->s.merges[1];
-		agg->sectors[0] += dus->s.sectors[0];
-		agg->sectors[1] += dus->s.sectors[1];
-		agg->ticks[0] += dus->s.ticks[0];
-		agg->ticks[1] += dus->s.ticks[1];
-		agg->time_in_queue += dus->s.time_in_queue;
-		agg->slavecount++;
-
-		util = (double) (100 * dus->s.io_ticks / (double) slavedu->dus.s.msec);
-		/* System utilization is the utilization of the
-		 * component with the highest utilization.
-		 */
-		if (util > agg->max_util.u.f)
-			agg->max_util.u.f = util;
-
-	}
-
-	if (agg->max_util.u.f > 100.0)
-		agg->max_util.u.f = 100.0;
-}
-
 void disk_util_prune_entries(void)
 {
 	fio_sem_down(disk_util_sem);
@@ -581,157 +515,6 @@ void disk_util_prune_entries(void)
 	fio_sem_remove(disk_util_sem);
 }
 
-void print_disk_util(struct disk_util_stat *dus, struct disk_util_agg *agg,
-		     int terse, struct buf_output *out)
-{
-	double util = 0;
-
-	if (dus->s.msec)
-		util = (double) 100 * dus->s.io_ticks / (double) dus->s.msec;
-	if (util > 100.0)
-		util = 100.0;
-
-	if (!terse) {
-		if (agg->slavecount)
-			log_buf(out, "  ");
-
-		log_buf(out, "  %s: ios=%llu/%llu, merge=%llu/%llu, "
-			 "ticks=%llu/%llu, in_queue=%llu, util=%3.2f%%",
-				dus->name,
-				(unsigned long long) dus->s.ios[0],
-				(unsigned long long) dus->s.ios[1],
-				(unsigned long long) dus->s.merges[0],
-				(unsigned long long) dus->s.merges[1],
-				(unsigned long long) dus->s.ticks[0],
-				(unsigned long long) dus->s.ticks[1],
-				(unsigned long long) dus->s.time_in_queue,
-				util);
-	} else {
-		log_buf(out, ";%s;%llu;%llu;%llu;%llu;%llu;%llu;%llu;%3.2f%%",
-				dus->name,
-				(unsigned long long) dus->s.ios[0],
-				(unsigned long long) dus->s.ios[1],
-				(unsigned long long) dus->s.merges[0],
-				(unsigned long long) dus->s.merges[1],
-				(unsigned long long) dus->s.ticks[0],
-				(unsigned long long) dus->s.ticks[1],
-				(unsigned long long) dus->s.time_in_queue,
-				util);
-	}
-
-	/*
-	 * If the device has slaves, aggregate the stats for
-	 * those slave devices also.
-	 */
-	show_agg_stats(agg, terse, out);
-
-	if (!terse)
-		log_buf(out, "\n");
-}
-
-void json_array_add_disk_util(struct disk_util_stat *dus,
-		struct disk_util_agg *agg, struct json_array *array)
-{
-	struct json_object *obj;
-	double util = 0;
-
-	if (dus->s.msec)
-		util = (double) 100 * dus->s.io_ticks / (double) dus->s.msec;
-	if (util > 100.0)
-		util = 100.0;
-
-	obj = json_create_object();
-	json_array_add_value_object(array, obj);
-
-	json_object_add_value_string(obj, "name", dus->name);
-	json_object_add_value_int(obj, "read_ios", dus->s.ios[0]);
-	json_object_add_value_int(obj, "write_ios", dus->s.ios[1]);
-	json_object_add_value_int(obj, "read_merges", dus->s.merges[0]);
-	json_object_add_value_int(obj, "write_merges", dus->s.merges[1]);
-	json_object_add_value_int(obj, "read_ticks", dus->s.ticks[0]);
-	json_object_add_value_int(obj, "write_ticks", dus->s.ticks[1]);
-	json_object_add_value_int(obj, "in_queue", dus->s.time_in_queue);
-	json_object_add_value_float(obj, "util", util);
-
-	/*
-	 * If the device has slaves, aggregate the stats for
-	 * those slave devices also.
-	 */
-	if (!agg->slavecount)
-		return;
-	json_object_add_value_int(obj, "aggr_read_ios",
-				agg->ios[0] / agg->slavecount);
-	json_object_add_value_int(obj, "aggr_write_ios",
-				agg->ios[1] / agg->slavecount);
-	json_object_add_value_int(obj, "aggr_read_merges",
-				agg->merges[0] / agg->slavecount);
-	json_object_add_value_int(obj, "aggr_write_merge",
-				agg->merges[1] / agg->slavecount);
-	json_object_add_value_int(obj, "aggr_read_ticks",
-				agg->ticks[0] / agg->slavecount);
-	json_object_add_value_int(obj, "aggr_write_ticks",
-				agg->ticks[1] / agg->slavecount);
-	json_object_add_value_int(obj, "aggr_in_queue",
-				agg->time_in_queue / agg->slavecount);
-	json_object_add_value_float(obj, "aggr_util", agg->max_util.u.f);
-}
-
-static void json_object_add_disk_utils(struct json_object *obj,
-				       struct flist_head *head)
-{
-	struct json_array *array = json_create_array();
-	struct flist_head *entry;
-	struct disk_util *du;
-
-	json_object_add_value_array(obj, "disk_util", array);
-
-	flist_for_each(entry, head) {
-		du = flist_entry(entry, struct disk_util, list);
-
-		aggregate_slaves_stats(du);
-		json_array_add_disk_util(&du->dus, &du->agg, array);
-	}
-}
-
-void show_disk_util(int terse, struct json_object *parent,
-		    struct buf_output *out)
-{
-	struct flist_head *entry;
-	struct disk_util *du;
-	bool do_json;
-
-	if (!is_running_backend())
-		return;
-
-	fio_sem_down(disk_util_sem);
-
-	if (flist_empty(&disk_list)) {
-		fio_sem_up(disk_util_sem);
-		return;
-	}
-
-	if ((output_format & FIO_OUTPUT_JSON) && parent)
-		do_json = true;
-	else
-		do_json = false;
-
-	if (!terse && !do_json)
-		log_buf(out, "\nDisk stats (read/write):\n");
-
-	if (do_json)
-		json_object_add_disk_utils(parent, &disk_list);
-	else if (output_format & ~(FIO_OUTPUT_JSON | FIO_OUTPUT_JSON_PLUS)) {
-		flist_for_each(entry, &disk_list) {
-			du = flist_entry(entry, struct disk_util, list);
-
-			aggregate_slaves_stats(du);
-			print_disk_util(&du->dus, &du->agg, terse, out);
-		}
-	}
-
-	fio_sem_up(disk_util_sem);
-}
-
 void setup_disk_util(void)
 {
 	disk_util_sem = fio_sem_init(FIO_SEM_UNLOCKED);
diff --git a/diskutil.h b/diskutil.h
index f6b09d22..83bcbf89 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -1,6 +1,5 @@
 #ifndef FIO_DISKUTIL_H
 #define FIO_DISKUTIL_H
-#include "json.h"
 #define FIO_DU_NAME_SZ		64
 
 #include "helper_thread.h"
@@ -105,26 +104,15 @@ extern struct flist_head disk_list;
  * disk util stuff
  */
 #ifdef FIO_HAVE_DISK_UTIL
-extern void print_disk_util(struct disk_util_stat *, struct disk_util_agg *, int terse, struct buf_output *);
-extern void show_disk_util(int terse, struct json_object *parent, struct buf_output *);
-extern void json_array_add_disk_util(struct disk_util_stat *dus,
-		struct disk_util_agg *agg, struct json_array *parent);
 extern void init_disk_util(struct thread_data *);
 extern int update_io_ticks(void);
 extern void setup_disk_util(void);
 extern void disk_util_prune_entries(void);
 #else
 /* keep this as a function to avoid a warning in handle_du() */
-static inline void print_disk_util(struct disk_util_stat *du,
-				   struct disk_util_agg *agg, int terse,
-				   struct buf_output *out)
-{
-}
-#define show_disk_util(terse, parent, out) do { } while (0)
 #define disk_util_prune_entries()
 #define init_disk_util(td)
 #define setup_disk_util()
-#define json_array_add_disk_util(dus, agg, parent)
 
 static inline int update_io_ticks(void)
 {
diff --git a/server.c b/server.c
index b7347b43..1a070e56 100644
--- a/server.c
+++ b/server.c
@@ -2154,7 +2154,8 @@ static int fio_init_server_ip(void)
 	/*
 	 * Not fatal if fails, so just ignore it if that happens
 	 */
-	setsockopt(sk, SOL_SOCKET, SO_REUSEPORT, &opt, sizeof(opt));
+	if (setsockopt(sk, SOL_SOCKET, SO_REUSEPORT, &opt, sizeof(opt))) {
+	}
 #endif
 
 	if (use_ipv6) {
diff --git a/stat.c b/stat.c
index 2b303494..55d83fcc 100644
--- a/stat.c
+++ b/stat.c
@@ -786,6 +786,218 @@ static void show_ss_normal(struct thread_stat *ts, struct buf_output *out)
 	free(p2);
 }
 
+static void show_agg_stats(struct disk_util_agg *agg, int terse,
+			   struct buf_output *out)
+{
+	if (!agg->slavecount)
+		return;
+
+	if (!terse) {
+		log_buf(out, ", aggrios=%llu/%llu, aggrmerge=%llu/%llu, "
+			 "aggrticks=%llu/%llu, aggrin_queue=%llu, "
+			 "aggrutil=%3.2f%%",
+			(unsigned long long) agg->ios[0] / agg->slavecount,
+			(unsigned long long) agg->ios[1] / agg->slavecount,
+			(unsigned long long) agg->merges[0] / agg->slavecount,
+			(unsigned long long) agg->merges[1] / agg->slavecount,
+			(unsigned long long) agg->ticks[0] / agg->slavecount,
+			(unsigned long long) agg->ticks[1] / agg->slavecount,
+			(unsigned long long) agg->time_in_queue / agg->slavecount,
+			agg->max_util.u.f);
+	} else {
+		log_buf(out, ";slaves;%llu;%llu;%llu;%llu;%llu;%llu;%llu;%3.2f%%",
+			(unsigned long long) agg->ios[0] / agg->slavecount,
+			(unsigned long long) agg->ios[1] / agg->slavecount,
+			(unsigned long long) agg->merges[0] / agg->slavecount,
+			(unsigned long long) agg->merges[1] / agg->slavecount,
+			(unsigned long long) agg->ticks[0] / agg->slavecount,
+			(unsigned long long) agg->ticks[1] / agg->slavecount,
+			(unsigned long long) agg->time_in_queue / agg->slavecount,
+			agg->max_util.u.f);
+	}
+}
+
+static void aggregate_slaves_stats(struct disk_util *masterdu)
+{
+	struct disk_util_agg *agg = &masterdu->agg;
+	struct disk_util_stat *dus;
+	struct flist_head *entry;
+	struct disk_util *slavedu;
+	double util;
+
+	flist_for_each(entry, &masterdu->slaves) {
+		slavedu = flist_entry(entry, struct disk_util, slavelist);
+		dus = &slavedu->dus;
+		agg->ios[0] += dus->s.ios[0];
+		agg->ios[1] += dus->s.ios[1];
+		agg->merges[0] += dus->s.merges[0];
+		agg->merges[1] += dus->s.merges[1];
+		agg->sectors[0] += dus->s.sectors[0];
+		agg->sectors[1] += dus->s.sectors[1];
+		agg->ticks[0] += dus->s.ticks[0];
+		agg->ticks[1] += dus->s.ticks[1];
+		agg->time_in_queue += dus->s.time_in_queue;
+		agg->slavecount++;
+
+		util = (double) (100 * dus->s.io_ticks / (double) slavedu->dus.s.msec);
+		/* System utilization is the utilization of the
+		 * component with the highest utilization.
+		 */
+		if (util > agg->max_util.u.f)
+			agg->max_util.u.f = util;
+
+	}
+
+	if (agg->max_util.u.f > 100.0)
+		agg->max_util.u.f = 100.0;
+}
+
+void print_disk_util(struct disk_util_stat *dus, struct disk_util_agg *agg,
+		     int terse, struct buf_output *out)
+{
+	double util = 0;
+
+	if (dus->s.msec)
+		util = (double) 100 * dus->s.io_ticks / (double) dus->s.msec;
+	if (util > 100.0)
+		util = 100.0;
+
+	if (!terse) {
+		if (agg->slavecount)
+			log_buf(out, "  ");
+
+		log_buf(out, "  %s: ios=%llu/%llu, merge=%llu/%llu, "
+			 "ticks=%llu/%llu, in_queue=%llu, util=%3.2f%%",
+				dus->name,
+				(unsigned long long) dus->s.ios[0],
+				(unsigned long long) dus->s.ios[1],
+				(unsigned long long) dus->s.merges[0],
+				(unsigned long long) dus->s.merges[1],
+				(unsigned long long) dus->s.ticks[0],
+				(unsigned long long) dus->s.ticks[1],
+				(unsigned long long) dus->s.time_in_queue,
+				util);
+	} else {
+		log_buf(out, ";%s;%llu;%llu;%llu;%llu;%llu;%llu;%llu;%3.2f%%",
+				dus->name,
+				(unsigned long long) dus->s.ios[0],
+				(unsigned long long) dus->s.ios[1],
+				(unsigned long long) dus->s.merges[0],
+				(unsigned long long) dus->s.merges[1],
+				(unsigned long long) dus->s.ticks[0],
+				(unsigned long long) dus->s.ticks[1],
+				(unsigned long long) dus->s.time_in_queue,
+				util);
+	}
+
+	/*
+	 * If the device has slaves, aggregate the stats for
+	 * those slave devices also.
+	 */
+	show_agg_stats(agg, terse, out);
+
+	if (!terse)
+		log_buf(out, "\n");
+}
+
+void json_array_add_disk_util(struct disk_util_stat *dus,
+		struct disk_util_agg *agg, struct json_array *array)
+{
+	struct json_object *obj;
+	double util = 0;
+
+	if (dus->s.msec)
+		util = (double) 100 * dus->s.io_ticks / (double) dus->s.msec;
+	if (util > 100.0)
+		util = 100.0;
+
+	obj = json_create_object();
+	json_array_add_value_object(array, obj);
+
+	json_object_add_value_string(obj, "name", dus->name);
+	json_object_add_value_int(obj, "read_ios", dus->s.ios[0]);
+	json_object_add_value_int(obj, "write_ios", dus->s.ios[1]);
+	json_object_add_value_int(obj, "read_merges", dus->s.merges[0]);
+	json_object_add_value_int(obj, "write_merges", dus->s.merges[1]);
+	json_object_add_value_int(obj, "read_ticks", dus->s.ticks[0]);
+	json_object_add_value_int(obj, "write_ticks", dus->s.ticks[1]);
+	json_object_add_value_int(obj, "in_queue", dus->s.time_in_queue);
+	json_object_add_value_float(obj, "util", util);
+
+	/*
+	 * If the device has slaves, aggregate the stats for
+	 * those slave devices also.
+	 */
+	if (!agg->slavecount)
+		return;
+	json_object_add_value_int(obj, "aggr_read_ios",
+				agg->ios[0] / agg->slavecount);
+	json_object_add_value_int(obj, "aggr_write_ios",
+				agg->ios[1] / agg->slavecount);
+	json_object_add_value_int(obj, "aggr_read_merges",
+				agg->merges[0] / agg->slavecount);
+	json_object_add_value_int(obj, "aggr_write_merge",
+				agg->merges[1] / agg->slavecount);
+	json_object_add_value_int(obj, "aggr_read_ticks",
+				agg->ticks[0] / agg->slavecount);
+	json_object_add_value_int(obj, "aggr_write_ticks",
+				agg->ticks[1] / agg->slavecount);
+	json_object_add_value_int(obj, "aggr_in_queue",
+				agg->time_in_queue / agg->slavecount);
+	json_object_add_value_float(obj, "aggr_util", agg->max_util.u.f);
+}
+
+static void json_object_add_disk_utils(struct json_object *obj,
+				       struct flist_head *head)
+{
+	struct json_array *array = json_create_array();
+	struct flist_head *entry;
+	struct disk_util *du;
+
+	json_object_add_value_array(obj, "disk_util", array);
+
+	flist_for_each(entry, head) {
+		du = flist_entry(entry, struct disk_util, list);
+
+		aggregate_slaves_stats(du);
+		json_array_add_disk_util(&du->dus, &du->agg, array);
+	}
+}
+
+void show_disk_util(int terse, struct json_object *parent,
+		    struct buf_output *out)
+{
+	struct flist_head *entry;
+	struct disk_util *du;
+	bool do_json;
+
+	if (!is_running_backend())
+		return;
+
+	if (flist_empty(&disk_list)) {
+		return;
+	}
+
+	if ((output_format & FIO_OUTPUT_JSON) && parent)
+		do_json = true;
+	else
+		do_json = false;
+
+	if (!terse && !do_json)
+		log_buf(out, "\nDisk stats (read/write):\n");
+
+	if (do_json)
+		json_object_add_disk_utils(parent, &disk_list);
+	else if (output_format & ~(FIO_OUTPUT_JSON | FIO_OUTPUT_JSON_PLUS)) {
+		flist_for_each(entry, &disk_list) {
+			du = flist_entry(entry, struct disk_util, list);
+
+			aggregate_slaves_stats(du);
+			print_disk_util(&du->dus, &du->agg, terse, out);
+		}
+	}
+}
+
 static void show_thread_status_normal(struct thread_stat *ts,
 				      struct group_run_stats *rs,
 				      struct buf_output *out)
diff --git a/stat.h b/stat.h
index ba7e290d..2ce91ff0 100644
--- a/stat.h
+++ b/stat.h
@@ -3,6 +3,8 @@
 
 #include "iolog.h"
 #include "lib/output_buffer.h"
+#include "diskutil.h"
+#include "json.h"
 
 struct group_run_stats {
 	uint64_t max_run[DDIR_RWDIR_CNT], min_run[DDIR_RWDIR_CNT];
@@ -332,9 +334,13 @@ extern void add_iops_sample(struct thread_data *, struct io_u *,
 extern void add_bw_sample(struct thread_data *, struct io_u *,
 				unsigned int, unsigned long long);
 extern void add_sync_clat_sample(struct thread_stat *ts,
-					unsigned long long nsec);
+				unsigned long long nsec);
 extern int calc_log_samples(void);
 
+extern void print_disk_util(struct disk_util_stat *, struct disk_util_agg *, int terse, struct buf_output *);
+extern void json_array_add_disk_util(struct disk_util_stat *dus,
+				struct disk_util_agg *agg, struct json_array *parent);
+
 extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
 extern bool write_bw_log;
 
diff --git a/t/memlock.c b/t/memlock.c
index ebedb91d..418dc3c4 100644
--- a/t/memlock.c
+++ b/t/memlock.c
@@ -43,6 +43,10 @@ int main(int argc, char *argv[])
 
 	mib = strtoul(argv[1], NULL, 10);
 	threads = strtoul(argv[2], NULL, 10);
+	if (threads < 1 || threads > 65536) {
+		printf("%s: invalid 'threads' argument\n", argv[0]);
+		return 1;
+	}
 
 	pthreads = calloc(threads, sizeof(pthread_t));
 	td.mib = mib;
diff --git a/t/read-to-pipe-async.c b/t/read-to-pipe-async.c
index bc7986f7..586e3c95 100644
--- a/t/read-to-pipe-async.c
+++ b/t/read-to-pipe-async.c
@@ -392,10 +392,13 @@ static void queue_work(struct reader_thread *rt, struct work_item *work)
 		pthread_cond_signal(&rt->thread.cond);
 	} else {
 		int ret = pthread_create(&work->thread, NULL, reader_one_off, work);
-		if (ret)
+		if (ret) {
 			fprintf(stderr, "pthread_create=%d\n", ret);
-		else
-			pthread_detach(work->thread);
+		} else {
+			ret = pthread_detach(work->thread);
+			if (ret)
+				fprintf(stderr, "pthread_detach=%d\n", ret);
+		}
 	}
 }
 
@@ -581,6 +584,7 @@ int main(int argc, char *argv[])
 	struct reader_thread *rt;
 	struct writer_thread *wt;
 	unsigned long rate;
+	uint64_t elapsed;
 	struct stat sb;
 	size_t bytes;
 	off_t off;
@@ -684,9 +688,11 @@ int main(int argc, char *argv[])
 	show_latencies(&wt->s, "WRITERS");
 
 	bytes /= 1024;
-	rate = (bytes * 1000UL * 1000UL) / utime_since(&s, &re);
+	elapsed = utime_since(&s, &re);
+	rate = elapsed ? (bytes * 1000UL * 1000UL) / elapsed : 0;
 	fprintf(stderr, "Read rate (KiB/sec) : %lu\n", rate);
-	rate = (bytes * 1000UL * 1000UL) / utime_since(&s, &we);
+	elapsed = utime_since(&s, &we);
+	rate = elapsed ? (bytes * 1000UL * 1000UL) / elapsed : 0;
 	fprintf(stderr, "Write rate (KiB/sec): %lu\n", rate);
 
 	close(fd);
diff --git a/verify.c b/verify.c
index a2c0d41d..cf299ebf 100644
--- a/verify.c
+++ b/verify.c
@@ -845,13 +845,11 @@ static int verify_header(struct io_u *io_u, struct thread_data *td,
 	 * For read-only workloads, the program cannot be certain of the
 	 * last numberio written to a block. Checking of numberio will be
 	 * done only for workloads that write data.  For verify_only,
-	 * numberio will be checked in the last iteration when the correct
-	 * state of numberio, that would have been written to each block
-	 * in a previous run of fio, has been reached.
+	 * numberio check is skipped.
 	 */
 	if (td_write(td) && (td_min_bs(td) == td_max_bs(td)) &&
 	    !td->o.time_based)
-		if (!td->o.verify_only || td->o.loops == 0)
+		if (!td->o.verify_only)
 			if (hdr->numberio != io_u->numberio) {
 				log_err("verify: bad header numberio %"PRIu16
 					", wanted %"PRIu16,

