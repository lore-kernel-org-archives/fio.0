Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E55EC433EF
	for <fio@archiver.kernel.org>; Fri, 21 Jan 2022 13:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380504AbiAUNAH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Jan 2022 08:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238446AbiAUNAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jan 2022 08:00:06 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D8FC061574
        for <fio@vger.kernel.org>; Fri, 21 Jan 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=K1P7gMCspTwX3NVN1To6bfFysjL0EFeZhKWIHFCZ4fw=; b=cpOavVr4gPtw0bj8yfgjkm4Qek
        27MPC/2Uk6zmVC4BskC3Fpr+mR6mjxui9hEBddj1zUSlWU8E52cKYo3mece8vHvV2+Ww8r2aWngJ4
        C95nqfg8mNrhTIS6O3jQHuwK3N5me6vBm/L0uQtdSn2xm4lu2KnuNODGXEGOZke/87fZE6VMzp1dC
        xXGTAgWKMfQsPXxBRmb2Pm2/T+kRohxPVuWn+ybszZ3ZPI73niro65zrfrEp6M0CheE+nqCy7Qbef
        34+VHTfx4ZxzH9P7DBG9DnAzhLWARew09YJm94iRHqvN3RyVgSCnqXZxGlXrW7mDrLOw0hYfVgo9B
        jRK5zWOw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nAtWO-002a8C-Gn
        for fio@vger.kernel.org; Fri, 21 Jan 2022 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id D81741BC0123; Fri, 21 Jan 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220121130001.D81741BC0123@kernel.dk>
Date:   Fri, 21 Jan 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 71efbed61dfb157dfa7fe550f500b53f9731e1cb:

  docs: documentation for sg WRITE STREAM(16) (2022-01-18 06:37:39 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3a3e5c6e7606e727df1788a73d04db56d77ba00d:

  iolog.c: Fix memory leak for blkparse case (2022-01-20 11:40:42 -0700)

----------------------------------------------------------------
Lukas Straub (8):
      blktrace.c: Use file stream interface instead of fifo
      iolog.c: Make iolog_items_to_fetch public
      blktrace.c: Add support for read_iolog_chunked
      linux-dev-lookup.c: Put the check for replay_redirect in the beginning
      blktrace.c: Don't hardcode direct-io
      blktrace.c: Don't sleep indefinitely if there is a wrong timestamp
      blktrace.c: Make thread-safe by removing local static variables
      iolog.c: Fix memory leak for blkparse case

 blktrace.c               | 325 ++++++++++++++++++++++++-----------------------
 blktrace.h               |  14 +-
 fio.h                    |   2 +
 iolog.c                  |  18 ++-
 iolog.h                  |   1 +
 oslib/linux-dev-lookup.c |  21 ++-
 6 files changed, 203 insertions(+), 178 deletions(-)

---

Diff of recent changes:

diff --git a/blktrace.c b/blktrace.c
index 64a610a9..e1804765 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -4,71 +4,34 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <errno.h>
 
 #include "flist.h"
 #include "fio.h"
+#include "iolog.h"
 #include "blktrace.h"
 #include "blktrace_api.h"
 #include "oslib/linux-dev-lookup.h"
 
-#define TRACE_FIFO_SIZE	8192
-
-/*
- * fifo refill frontend, to avoid reading data in trace sized bites
- */
-static int refill_fifo(struct thread_data *td, struct fifo *fifo, int fd)
-{
-	char buf[TRACE_FIFO_SIZE];
-	unsigned int total;
-	int ret;
-
-	total = sizeof(buf);
-	if (total > fifo_room(fifo))
-		total = fifo_room(fifo);
-
-	ret = read(fd, buf, total);
-	if (ret < 0) {
-		int read_err = errno;
-
-		assert(read_err > 0);
-		td_verror(td, read_err, "read blktrace file");
-		return -read_err;
-	}
-
-	if (ret > 0)
-		ret = fifo_put(fifo, buf, ret);
-
-	dprint(FD_BLKTRACE, "refill: filled %d bytes\n", ret);
-	return ret;
-}
-
-/*
- * Retrieve 'len' bytes from the fifo, refilling if necessary.
- */
-static int trace_fifo_get(struct thread_data *td, struct fifo *fifo, int fd,
-			  void *buf, unsigned int len)
-{
-	if (fifo_len(fifo) < len) {
-		int ret = refill_fifo(td, fifo, fd);
-
-		if (ret < 0)
-			return ret;
-	}
-
-	return fifo_get(fifo, buf, len);
-}
+struct file_cache {
+	unsigned int maj;
+	unsigned int min;
+	unsigned int fileno;
+};
 
 /*
  * Just discard the pdu by seeking past it.
  */
-static int discard_pdu(struct thread_data *td, struct fifo *fifo, int fd,
-		       struct blk_io_trace *t)
+static int discard_pdu(FILE* f, struct blk_io_trace *t)
 {
 	if (t->pdu_len == 0)
 		return 0;
 
 	dprint(FD_BLKTRACE, "discard pdu len %u\n", t->pdu_len);
-	return trace_fifo_get(td, fifo, fd, NULL, t->pdu_len);
+	if (fseek(f, t->pdu_len, SEEK_CUR) < 0)
+		return -errno;
+
+	return t->pdu_len;
 }
 
 /*
@@ -130,28 +93,28 @@ static void trace_add_open_close_event(struct thread_data *td, int fileno, enum
 	flist_add_tail(&ipo->list, &td->io_log_list);
 }
 
-static int trace_add_file(struct thread_data *td, __u32 device)
+static int trace_add_file(struct thread_data *td, __u32 device,
+			  struct file_cache *cache)
 {
-	static unsigned int last_maj, last_min, last_fileno;
 	unsigned int maj = FMAJOR(device);
 	unsigned int min = FMINOR(device);
 	struct fio_file *f;
 	char dev[256];
 	unsigned int i;
 
-	if (last_maj == maj && last_min == min)
-		return last_fileno;
+	if (cache->maj == maj && cache->min == min)
+		return cache->fileno;
 
-	last_maj = maj;
-	last_min = min;
+	cache->maj = maj;
+	cache->min = min;
 
 	/*
 	 * check for this file in our list
 	 */
 	for_each_file(td, f, i)
 		if (f->major == maj && f->minor == min) {
-			last_fileno = f->fileno;
-			return last_fileno;
+			cache->fileno = f->fileno;
+			return cache->fileno;
 		}
 
 	strcpy(dev, "/dev");
@@ -171,10 +134,10 @@ static int trace_add_file(struct thread_data *td, __u32 device)
 		td->files[fileno]->major = maj;
 		td->files[fileno]->minor = min;
 		trace_add_open_close_event(td, fileno, FIO_LOG_OPEN_FILE);
-		last_fileno = fileno;
+		cache->fileno = fileno;
 	}
 
-	return last_fileno;
+	return cache->fileno;
 }
 
 static void t_bytes_align(struct thread_options *o, struct blk_io_trace *t)
@@ -215,7 +178,7 @@ static void store_ipo(struct thread_data *td, unsigned long long offset,
 	queue_io_piece(td, ipo);
 }
 
-static void handle_trace_notify(struct blk_io_trace *t)
+static bool handle_trace_notify(struct blk_io_trace *t)
 {
 	switch (t->action) {
 	case BLK_TN_PROCESS:
@@ -232,22 +195,24 @@ static void handle_trace_notify(struct blk_io_trace *t)
 		dprint(FD_BLKTRACE, "unknown trace act %x\n", t->action);
 		break;
 	}
+	return false;
 }
 
-static void handle_trace_discard(struct thread_data *td,
+static bool handle_trace_discard(struct thread_data *td,
 				 struct blk_io_trace *t,
 				 unsigned long long ttime,
-				 unsigned long *ios, unsigned int *bs)
+				 unsigned long *ios, unsigned long long *bs,
+				 struct file_cache *cache)
 {
 	struct io_piece *ipo;
 	int fileno;
 
 	if (td->o.replay_skip & (1u << DDIR_TRIM))
-		return;
+		return false;
 
 	ipo = calloc(1, sizeof(*ipo));
 	init_ipo(ipo);
-	fileno = trace_add_file(td, t->device);
+	fileno = trace_add_file(td, t->device, cache);
 
 	ios[DDIR_TRIM]++;
 	if (t->bytes > bs[DDIR_TRIM])
@@ -270,6 +235,7 @@ static void handle_trace_discard(struct thread_data *td,
 							ipo->offset, ipo->len,
 							ipo->delay);
 	queue_io_piece(td, ipo);
+	return true;
 }
 
 static void dump_trace(struct blk_io_trace *t)
@@ -277,29 +243,29 @@ static void dump_trace(struct blk_io_trace *t)
 	log_err("blktrace: ignoring zero byte trace: action=%x\n", t->action);
 }
 
-static void handle_trace_fs(struct thread_data *td, struct blk_io_trace *t,
+static bool handle_trace_fs(struct thread_data *td, struct blk_io_trace *t,
 			    unsigned long long ttime, unsigned long *ios,
-			    unsigned int *bs)
+			    unsigned long long *bs, struct file_cache *cache)
 {
 	int rw;
 	int fileno;
 
-	fileno = trace_add_file(td, t->device);
+	fileno = trace_add_file(td, t->device, cache);
 
 	rw = (t->action & BLK_TC_ACT(BLK_TC_WRITE)) != 0;
 
 	if (rw) {
 		if (td->o.replay_skip & (1u << DDIR_WRITE))
-			return;
+			return false;
 	} else {
 		if (td->o.replay_skip & (1u << DDIR_READ))
-			return;
+			return false;
 	}
 
 	if (!t->bytes) {
 		if (!fio_did_warn(FIO_WARN_BTRACE_ZERO))
 			dump_trace(t);
-		return;
+		return false;
 	}
 
 	if (t->bytes > bs[rw])
@@ -308,20 +274,22 @@ static void handle_trace_fs(struct thread_data *td, struct blk_io_trace *t,
 	ios[rw]++;
 	td->o.size += t->bytes;
 	store_ipo(td, t->sector, t->bytes, rw, ttime, fileno);
+	return true;
 }
 
-static void handle_trace_flush(struct thread_data *td, struct blk_io_trace *t,
-			       unsigned long long ttime, unsigned long *ios)
+static bool handle_trace_flush(struct thread_data *td, struct blk_io_trace *t,
+			       unsigned long long ttime, unsigned long *ios,
+			       struct file_cache *cache)
 {
 	struct io_piece *ipo;
 	int fileno;
 
 	if (td->o.replay_skip & (1u << DDIR_SYNC))
-		return;
+		return false;
 
 	ipo = calloc(1, sizeof(*ipo));
 	init_ipo(ipo);
-	fileno = trace_add_file(td, t->device);
+	fileno = trace_add_file(td, t->device, cache);
 
 	ipo->delay = ttime / 1000;
 	ipo->ddir = DDIR_SYNC;
@@ -330,47 +298,49 @@ static void handle_trace_flush(struct thread_data *td, struct blk_io_trace *t,
 	ios[DDIR_SYNC]++;
 	dprint(FD_BLKTRACE, "store flush delay=%lu\n", ipo->delay);
 	queue_io_piece(td, ipo);
+	return true;
 }
 
 /*
  * We only care for queue traces, most of the others are side effects
  * due to internal workings of the block layer.
  */
-static void handle_trace(struct thread_data *td, struct blk_io_trace *t,
-			 unsigned long *ios, unsigned int *bs)
+static bool queue_trace(struct thread_data *td, struct blk_io_trace *t,
+			 unsigned long *ios, unsigned long long *bs,
+			 struct file_cache *cache)
 {
-	static unsigned long long last_ttime;
+	unsigned long long *last_ttime = &td->io_log_blktrace_last_ttime;
 	unsigned long long delay = 0;
 
 	if ((t->action & 0xffff) != __BLK_TA_QUEUE)
-		return;
+		return false;
 
 	if (!(t->action & BLK_TC_ACT(BLK_TC_NOTIFY))) {
-		if (!last_ttime || td->o.no_stall)
+		if (!*last_ttime || td->o.no_stall || t->time < *last_ttime)
 			delay = 0;
 		else if (td->o.replay_time_scale == 100)
-			delay = t->time - last_ttime;
+			delay = t->time - *last_ttime;
 		else {
-			double tmp = t->time - last_ttime;
+			double tmp = t->time - *last_ttime;
 			double scale;
 
 			scale = (double) 100.0 / (double) td->o.replay_time_scale;
 			tmp *= scale;
 			delay = tmp;
 		}
-		last_ttime = t->time;
+		*last_ttime = t->time;
 	}
 
 	t_bytes_align(&td->o, t);
 
 	if (t->action & BLK_TC_ACT(BLK_TC_NOTIFY))
-		handle_trace_notify(t);
+		return handle_trace_notify(t);
 	else if (t->action & BLK_TC_ACT(BLK_TC_DISCARD))
-		handle_trace_discard(td, t, delay, ios, bs);
+		return handle_trace_discard(td, t, delay, ios, bs, cache);
 	else if (t->action & BLK_TC_ACT(BLK_TC_FLUSH))
-		handle_trace_flush(td, t, delay, ios);
+		return handle_trace_flush(td, t, delay, ios, cache);
 	else
-		handle_trace_fs(td, t, delay, ios, bs);
+		return handle_trace_fs(td, t, delay, ios, bs, cache);
 }
 
 static void byteswap_trace(struct blk_io_trace *t)
@@ -438,43 +408,79 @@ static void depth_end(struct blk_io_trace *t, int *this_depth, int *depth)
  * Load a blktrace file by reading all the blk_io_trace entries, and storing
  * them as io_pieces like the fio text version would do.
  */
-bool load_blktrace(struct thread_data *td, const char *filename, int need_swap)
+bool init_blktrace_read(struct thread_data *td, const char *filename, int need_swap)
+{
+	int old_state;
+
+	td->io_log_rfile = fopen(filename, "rb");
+	if (!td->io_log_rfile) {
+		td_verror(td, errno, "open blktrace file");
+		goto err;
+	}
+	td->io_log_blktrace_swap = need_swap;
+	td->io_log_blktrace_last_ttime = 0;
+	td->o.size = 0;
+
+	free_release_files(td);
+
+	old_state = td_bump_runstate(td, TD_SETTING_UP);
+
+	if (!read_blktrace(td)) {
+		goto err;
+	}
+
+	td_restore_runstate(td, old_state);
+
+	if (!td->files_index) {
+		log_err("fio: did not find replay device(s)\n");
+		return false;
+	}
+
+	return true;
+
+err:
+	if (td->io_log_rfile) {
+		fclose(td->io_log_rfile);
+		td->io_log_rfile = NULL;
+	}
+	return false;
+}
+
+bool read_blktrace(struct thread_data* td)
 {
 	struct blk_io_trace t;
+	struct file_cache cache = { };
 	unsigned long ios[DDIR_RWDIR_SYNC_CNT] = { };
-	unsigned int rw_bs[DDIR_RWDIR_CNT] = { };
+	unsigned long long rw_bs[DDIR_RWDIR_CNT] = { };
 	unsigned long skipped_writes;
-	struct fifo *fifo;
-	int fd, i, old_state, max_depth;
-	struct fio_file *f;
+	FILE *f = td->io_log_rfile;
+	int i, max_depth;
+	struct fio_file *fiof;
 	int this_depth[DDIR_RWDIR_CNT] = { };
 	int depth[DDIR_RWDIR_CNT] = { };
+	int64_t items_to_fetch = 0;
 
-	fd = open(filename, O_RDONLY);
-	if (fd < 0) {
-		td_verror(td, errno, "open blktrace file");
-		return false;
+	if (td->o.read_iolog_chunked) {
+		items_to_fetch = iolog_items_to_fetch(td);
+		if (!items_to_fetch)
+			return true;
 	}
 
-	fifo = fifo_alloc(TRACE_FIFO_SIZE);
-
-	old_state = td_bump_runstate(td, TD_SETTING_UP);
-
-	td->o.size = 0;
 	skipped_writes = 0;
 	do {
-		int ret = trace_fifo_get(td, fifo, fd, &t, sizeof(t));
+		int ret = fread(&t, 1, sizeof(t), f);
 
-		if (ret < 0)
+		if (ferror(f)) {
+			td_verror(td, errno, "read blktrace file");
 			goto err;
-		else if (!ret)
+		} else if (feof(f)) {
 			break;
-		else if (ret < (int) sizeof(t)) {
-			log_err("fio: short fifo get\n");
+		} else if (ret < (int) sizeof(t)) {
+			log_err("fio: iolog short read\n");
 			break;
 		}
 
-		if (need_swap)
+		if (td->io_log_blktrace_swap)
 			byteswap_trace(&t);
 
 		if ((t.magic & 0xffffff00) != BLK_IO_TRACE_MAGIC) {
@@ -487,13 +493,10 @@ bool load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 								t.magic & 0xff);
 			goto err;
 		}
-		ret = discard_pdu(td, fifo, fd, &t);
+		ret = discard_pdu(f, &t);
 		if (ret < 0) {
 			td_verror(td, -ret, "blktrace lseek");
 			goto err;
-		} else if (t.pdu_len != ret) {
-			log_err("fio: discarded %d of %d\n", ret, t.pdu_len);
-			goto err;
 		}
 		if ((t.action & BLK_TC_ACT(BLK_TC_NOTIFY)) == 0) {
 			if ((t.action & 0xffff) == __BLK_TA_QUEUE)
@@ -510,22 +513,53 @@ bool load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 			}
 		}
 
-		handle_trace(td, &t, ios, rw_bs);
-	} while (1);
+		if (!queue_trace(td, &t, ios, rw_bs, &cache))
+			continue;
 
-	for_each_file(td, f, i)
-		trace_add_open_close_event(td, f->fileno, FIO_LOG_CLOSE_FILE);
+		if (td->o.read_iolog_chunked) {
+			td->io_log_current++;
+			items_to_fetch--;
+			if (items_to_fetch == 0)
+				break;
+		}
+	} while (1);
 
-	fifo_free(fifo);
-	close(fd);
+	if (td->o.read_iolog_chunked) {
+		td->io_log_highmark = td->io_log_current;
+		td->io_log_checkmark = (td->io_log_highmark + 1) / 2;
+		fio_gettime(&td->io_log_highmark_time, NULL);
+	}
 
-	td_restore_runstate(td, old_state);
+	if (skipped_writes)
+		log_err("fio: %s skips replay of %lu writes due to read-only\n",
+						td->o.name, skipped_writes);
 
-	if (!td->files_index) {
-		log_err("fio: did not find replay device(s)\n");
-		return false;
+	if (td->o.read_iolog_chunked) {
+		if (td->io_log_current == 0) {
+			return false;
+		}
+		td->o.td_ddir = TD_DDIR_RW;
+		if ((rw_bs[DDIR_READ] > td->o.max_bs[DDIR_READ] ||
+		     rw_bs[DDIR_WRITE] > td->o.max_bs[DDIR_WRITE] ||
+		     rw_bs[DDIR_TRIM] > td->o.max_bs[DDIR_TRIM]) &&
+		    td->orig_buffer)
+		{
+			td->o.max_bs[DDIR_READ] = max(td->o.max_bs[DDIR_READ], rw_bs[DDIR_READ]);
+			td->o.max_bs[DDIR_WRITE] = max(td->o.max_bs[DDIR_WRITE], rw_bs[DDIR_WRITE]);
+			td->o.max_bs[DDIR_TRIM] = max(td->o.max_bs[DDIR_TRIM], rw_bs[DDIR_TRIM]);
+			io_u_quiesce(td);
+			free_io_mem(td);
+			init_io_u_buffers(td);
+		}
+		return true;
 	}
 
+	for_each_file(td, fiof, i)
+		trace_add_open_close_event(td, fiof->fileno, FIO_LOG_CLOSE_FILE);
+
+	fclose(td->io_log_rfile);
+	td->io_log_rfile = NULL;
+
 	/*
 	 * For stacked devices, we don't always get a COMPLETE event so
 	 * the depth grows to insane values. Limit it to something sane(r).
@@ -539,10 +573,6 @@ bool load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 		max_depth = max(depth[i], max_depth);
 	}
 
-	if (skipped_writes)
-		log_err("fio: %s skips replay of %lu writes due to read-only\n",
-						td->o.name, skipped_writes);
-
 	if (!ios[DDIR_READ] && !ios[DDIR_WRITE] && !ios[DDIR_TRIM] &&
 	    !ios[DDIR_SYNC]) {
 		log_err("fio: found no ios in blktrace data\n");
@@ -563,14 +593,6 @@ bool load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 		td->o.max_bs[DDIR_TRIM] = rw_bs[DDIR_TRIM];
 	}
 
-	/*
-	 * We need to do direct/raw ios to the device, to avoid getting
-	 * read-ahead in our way. But only do so if the minimum block size
-	 * is a multiple of 4k, otherwise we don't know if it's safe to do so.
-	 */
-	if (!fio_option_is_set(&td->o, odirect) && !(td_min_bs(td) & 4095))
-		td->o.odirect = 1;
-
 	/*
 	 * If depth wasn't manually set, use probed depth
 	 */
@@ -579,8 +601,7 @@ bool load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 
 	return true;
 err:
-	close(fd);
-	fifo_free(fifo);
+	fclose(f);
 	return false;
 }
 
@@ -625,15 +646,14 @@ static void merge_finish_file(struct blktrace_cursor *bcs, int i, int *nr_logs)
 {
 	bcs[i].iter++;
 	if (bcs[i].iter < bcs[i].nr_iter) {
-		lseek(bcs[i].fd, 0, SEEK_SET);
+		fseek(bcs[i].f, 0, SEEK_SET);
 		return;
 	}
 
 	*nr_logs -= 1;
 
 	/* close file */
-	fifo_free(bcs[i].fifo);
-	close(bcs[i].fd);
+	fclose(bcs[i].f);
 
 	/* keep active files contiguous */
 	memmove(&bcs[i], &bcs[*nr_logs], sizeof(bcs[i]));
@@ -646,15 +666,16 @@ static int read_trace(struct thread_data *td, struct blktrace_cursor *bc)
 
 read_skip:
 	/* read an io trace */
-	ret = trace_fifo_get(td, bc->fifo, bc->fd, t, sizeof(*t));
-	if (ret < 0) {
+	ret = fread(&t, 1, sizeof(t), bc->f);
+	if (ferror(bc->f)) {
+		td_verror(td, errno, "read blktrace file");
 		return ret;
-	} else if (!ret) {
+	} else if (feof(bc->f)) {
 		if (!bc->length)
 			bc->length = bc->t.time;
 		return ret;
 	} else if (ret < (int) sizeof(*t)) {
-		log_err("fio: short fifo get\n");
+		log_err("fio: iolog short read\n");
 		return -1;
 	}
 
@@ -664,14 +685,10 @@ read_skip:
 	/* skip over actions that fio does not care about */
 	if ((t->action & 0xffff) != __BLK_TA_QUEUE ||
 	    t_get_ddir(t) == DDIR_INVAL) {
-		ret = discard_pdu(td, bc->fifo, bc->fd, t);
+		ret = discard_pdu(bc->f, t);
 		if (ret < 0) {
 			td_verror(td, -ret, "blktrace lseek");
 			return ret;
-		} else if (t->pdu_len != ret) {
-			log_err("fio: discarded %d of %d\n", ret,
-				t->pdu_len);
-			return -1;
 		}
 		goto read_skip;
 	}
@@ -729,14 +746,13 @@ int merge_blktrace_iologs(struct thread_data *td)
 	str = ptr = strdup(td->o.read_iolog_file);
 	nr_logs = 0;
 	for (i = 0; (name = get_next_str(&ptr)) != NULL; i++) {
-		bcs[i].fd = open(name, O_RDONLY);
-		if (bcs[i].fd < 0) {
+		bcs[i].f = fopen(name, "rb");
+		if (!bcs[i].f) {
 			log_err("fio: could not open file: %s\n", name);
-			ret = bcs[i].fd;
+			ret = -errno;
 			free(str);
 			goto err_file;
 		}
-		bcs[i].fifo = fifo_alloc(TRACE_FIFO_SIZE);
 		nr_logs++;
 
 		if (!is_blktrace(name, &bcs[i].swap)) {
@@ -761,14 +777,10 @@ int merge_blktrace_iologs(struct thread_data *td)
 		i = find_earliest_io(bcs, nr_logs);
 		bc = &bcs[i];
 		/* skip over the pdu */
-		ret = discard_pdu(td, bc->fifo, bc->fd, &bc->t);
+		ret = discard_pdu(bc->f, &bc->t);
 		if (ret < 0) {
 			td_verror(td, -ret, "blktrace lseek");
 			goto err_file;
-		} else if (bc->t.pdu_len != ret) {
-			log_err("fio: discarded %d of %d\n", ret,
-				bc->t.pdu_len);
-			goto err_file;
 		}
 
 		ret = write_trace(merge_fp, &bc->t);
@@ -786,8 +798,7 @@ int merge_blktrace_iologs(struct thread_data *td)
 err_file:
 	/* cleanup */
 	for (i = 0; i < nr_logs; i++) {
-		fifo_free(bcs[i].fifo);
-		close(bcs[i].fd);
+		fclose(bcs[i].f);
 	}
 err_merge_buf:
 	free(merge_buf);
diff --git a/blktrace.h b/blktrace.h
index a0e82faa..c53b717b 100644
--- a/blktrace.h
+++ b/blktrace.h
@@ -10,7 +10,7 @@
 
 struct blktrace_cursor {
 	struct fifo		*fifo;	// fifo queue for reading
-	int			fd;	// blktrace file
+	FILE			*f;	// blktrace file
 	__u64			length; // length of trace
 	struct blk_io_trace	t;	// current io trace
 	int			swap;	// bitwise reverse required
@@ -20,7 +20,9 @@ struct blktrace_cursor {
 };
 
 bool is_blktrace(const char *, int *);
-bool load_blktrace(struct thread_data *, const char *, int);
+bool init_blktrace_read(struct thread_data *, const char *, int);
+bool read_blktrace(struct thread_data* td);
+
 int merge_blktrace_iologs(struct thread_data *td);
 
 #else
@@ -30,12 +32,18 @@ static inline bool is_blktrace(const char *fname, int *need_swap)
 	return false;
 }
 
-static inline bool load_blktrace(struct thread_data *td, const char *fname,
+static inline bool init_blktrace_read(struct thread_data *td, const char *fname,
 				 int need_swap)
 {
 	return false;
 }
 
+static inline bool read_blktrace(struct thread_data* td)
+{
+	return false;
+}
+
+
 static inline int merge_blktrace_iologs(struct thread_data *td)
 {
 	return false;
diff --git a/fio.h b/fio.h
index 6bb21ebb..1ea3d064 100644
--- a/fio.h
+++ b/fio.h
@@ -428,6 +428,8 @@ struct thread_data {
 	struct flist_head io_log_list;
 	FILE *io_log_rfile;
 	unsigned int io_log_blktrace;
+	unsigned int io_log_blktrace_swap;
+	unsigned long long io_log_blktrace_last_ttime;
 	unsigned int io_log_current;
 	unsigned int io_log_checkmark;
 	unsigned int io_log_highmark;
diff --git a/iolog.c b/iolog.c
index 1aeb7a76..a2cf0c1c 100644
--- a/iolog.c
+++ b/iolog.c
@@ -152,10 +152,15 @@ int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 	while (!flist_empty(&td->io_log_list)) {
 		int ret;
 
-		if (!td->io_log_blktrace && td->o.read_iolog_chunked) {
+		if (td->o.read_iolog_chunked) {
 			if (td->io_log_checkmark == td->io_log_current) {
-				if (!read_iolog2(td))
-					return 1;
+				if (td->io_log_blktrace) {
+					if (!read_blktrace(td))
+						return 1;
+				} else {
+					if (!read_iolog2(td))
+						return 1;
+				}
 			}
 			td->io_log_current--;
 		}
@@ -355,7 +360,7 @@ void write_iolog_close(struct thread_data *td)
 	td->iolog_buf = NULL;
 }
 
-static int64_t iolog_items_to_fetch(struct thread_data *td)
+int64_t iolog_items_to_fetch(struct thread_data *td)
 {
 	struct timespec now;
 	uint64_t elapsed;
@@ -626,8 +631,6 @@ static bool init_iolog_read(struct thread_data *td, char *fname)
 	} else
 		f = fopen(fname, "r");
 
-	free(fname);
-
 	if (!f) {
 		perror("fopen read iolog");
 		return false;
@@ -709,11 +712,12 @@ bool init_iolog(struct thread_data *td)
 		 */
 		if (is_blktrace(fname, &need_swap)) {
 			td->io_log_blktrace = 1;
-			ret = load_blktrace(td, fname, need_swap);
+			ret = init_blktrace_read(td, fname, need_swap);
 		} else {
 			td->io_log_blktrace = 0;
 			ret = init_iolog_read(td, fname);
 		}
+		free(fname);
 	} else if (td->o.write_iolog_file)
 		ret = init_iolog_write(td);
 	else
diff --git a/iolog.h b/iolog.h
index 7d66b7c4..a3986309 100644
--- a/iolog.h
+++ b/iolog.h
@@ -254,6 +254,7 @@ extern void trim_io_piece(const struct io_u *);
 extern void queue_io_piece(struct thread_data *, struct io_piece *);
 extern void prune_io_piece_log(struct thread_data *);
 extern void write_iolog_close(struct thread_data *);
+int64_t iolog_items_to_fetch(struct thread_data *td);
 extern int iolog_compress_init(struct thread_data *, struct sk_out *);
 extern void iolog_compress_exit(struct thread_data *);
 extern size_t log_chunk_sizes(struct io_log *);
diff --git a/oslib/linux-dev-lookup.c b/oslib/linux-dev-lookup.c
index 1dda93f2..4335faf9 100644
--- a/oslib/linux-dev-lookup.c
+++ b/oslib/linux-dev-lookup.c
@@ -16,6 +16,16 @@ int blktrace_lookup_device(const char *redirect, char *path, unsigned int maj,
 	int found = 0;
 	DIR *D;
 
+	/*
+	 * If replay_redirect is set then always return this device
+	 * upon lookup which overrides the device lookup based on
+	 * major minor in the actual blktrace
+	 */
+	if (redirect) {
+		strcpy(path, redirect);
+		return 1;
+	}
+
 	D = opendir(path);
 	if (!D)
 		return 0;
@@ -44,17 +54,6 @@ int blktrace_lookup_device(const char *redirect, char *path, unsigned int maj,
 		if (!S_ISBLK(st.st_mode))
 			continue;
 
-		/*
-		 * If replay_redirect is set then always return this device
-		 * upon lookup which overrides the device lookup based on
-		 * major minor in the actual blktrace
-		 */
-		if (redirect) {
-			strcpy(path, redirect);
-			found = 1;
-			break;
-		}
-
 		if (maj == major(st.st_rdev) && min == minor(st.st_rdev)) {
 			strcpy(path, full_path);
 			found = 1;
