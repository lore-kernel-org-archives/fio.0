Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C54DC433EF
	for <fio@archiver.kernel.org>; Wed,  6 Apr 2022 18:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240286AbiDFSP7 convert rfc822-to-8bit (ORCPT
        <rfc822;fio@archiver.kernel.org>); Wed, 6 Apr 2022 14:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240498AbiDFSPl (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Apr 2022 14:15:41 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7607354BC5
        for <fio@vger.kernel.org>; Wed,  6 Apr 2022 10:05:39 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 236Gn1nG022211
        for <fio@vger.kernel.org>; Wed, 6 Apr 2022 10:05:38 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f9eq285ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Wed, 06 Apr 2022 10:05:38 -0700
Received: from twshared13345.18.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 6 Apr 2022 10:05:37 -0700
Received: by devvm4279.ftw0.facebook.com (Postfix, from userid 199637)
        id B059420D98DAF; Wed,  6 Apr 2022 10:05:32 -0700 (PDT)
From:   Mohamad Gebai <mogeb@fb.com>
To:     <fio@vger.kernel.org>
CC:     Mohamad Gebai <mogeb@fb.com>
Subject: [PATCH 1/3] iolog: add version 3 to support timestamp-based replay
Date:   Wed, 6 Apr 2022 10:05:28 -0700
Message-ID: <20220406170530.2198263-2-mogeb@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406170530.2198263-1-mogeb@fb.com>
References: <20220406170530.2198263-1-mogeb@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

 - Version 3 format looks as follows:

    timestamp filename action offset length

 - File actions must have a timestamp, including add.

 - 'wait' is not allowed with version 3 so we can leave all timing-related
 functions to timestamps.

Signed-off-by: Mohamad Gebai <mogeb@fb.com>
---
 blktrace.c | 17 ++--------
 fio.h      |  3 +-
 iolog.c    | 99 ++++++++++++++++++++++++++++++++++++++++++------------
 iolog.h    |  8 ++---
 4 files changed, 86 insertions(+), 41 deletions(-)

diff --git a/blktrace.c b/blktrace.c
index ead60130..619121c7 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -306,39 +306,28 @@ static bool handle_trace_flush(struct thread_data *td, struct blk_io_trace *t,
 }
 
 /*
  * We only care for queue traces, most of the others are side effects
  * due to internal workings of the block layer.
  */
 static bool queue_trace(struct thread_data *td, struct blk_io_trace *t,
 			 unsigned long *ios, unsigned long long *bs,
 			 struct file_cache *cache)
 {
-	unsigned long long *last_ttime = &td->io_log_blktrace_last_ttime;
+	unsigned long long *last_ttime = &td->io_log_last_ttime;
 	unsigned long long delay = 0;
 
 	if ((t->action & 0xffff) != __BLK_TA_QUEUE)
 		return false;
 
 	if (!(t->action & BLK_TC_ACT(BLK_TC_NOTIFY))) {
-		if (!*last_ttime || td->o.no_stall || t->time < *last_ttime)
-			delay = 0;
-		else if (td->o.replay_time_scale == 100)
-			delay = t->time - *last_ttime;
-		else {
-			double tmp = t->time - *last_ttime;
-			double scale;
-
-			scale = (double) 100.0 / (double) td->o.replay_time_scale;
-			tmp *= scale;
-			delay = tmp;
-		}
+		delay = delay_since_ttime(td, t->time);
 		*last_ttime = t->time;
 	}
 
 	t_bytes_align(&td->o, t);
 
 	if (t->action & BLK_TC_ACT(BLK_TC_NOTIFY))
 		return handle_trace_notify(t);
 	else if (t->action & BLK_TC_ACT(BLK_TC_DISCARD))
 		return handle_trace_discard(td, t, delay, ios, bs, cache);
 	else if (t->action & BLK_TC_ACT(BLK_TC_FLUSH))
@@ -415,21 +404,21 @@ static void depth_end(struct blk_io_trace *t, int *this_depth, int *depth)
 bool init_blktrace_read(struct thread_data *td, const char *filename, int need_swap)
 {
 	int old_state;
 
 	td->io_log_rfile = fopen(filename, "rb");
 	if (!td->io_log_rfile) {
 		td_verror(td, errno, "open blktrace file");
 		goto err;
 	}
 	td->io_log_blktrace_swap = need_swap;
-	td->io_log_blktrace_last_ttime = 0;
+	td->io_log_last_ttime = 0;
 	td->o.size = 0;
 
 	free_release_files(td);
 
 	old_state = td_bump_runstate(td, TD_SETTING_UP);
 
 	if (!read_blktrace(td)) {
 		goto err;
 	}
 
diff --git a/fio.h b/fio.h
index 776fb51f..8830ff34 100644
--- a/fio.h
+++ b/fio.h
@@ -424,24 +424,25 @@ struct thread_data {
 	struct flist_head io_hist_list;
 	unsigned long io_hist_len;
 
 	/*
 	 * For IO replaying
 	 */
 	struct flist_head io_log_list;
 	FILE *io_log_rfile;
 	unsigned int io_log_blktrace;
 	unsigned int io_log_blktrace_swap;
-	unsigned long long io_log_blktrace_last_ttime;
+	unsigned long long io_log_last_ttime;
 	unsigned int io_log_current;
 	unsigned int io_log_checkmark;
 	unsigned int io_log_highmark;
+	unsigned int io_log_version;
 	struct timespec io_log_highmark_time;
 
 	/*
 	 * For tracking/handling discards
 	 */
 	struct flist_head trim_list;
 	unsigned long trim_entries;
 
 	/*
 	 * for fileservice, how often to switch to a new file
diff --git a/iolog.c b/iolog.c
index 724ec1fe..be7eb007 100644
--- a/iolog.c
+++ b/iolog.c
@@ -24,20 +24,21 @@
 #include <netinet/in.h>
 #include <netinet/tcp.h>
 #include <arpa/inet.h>
 #include <sys/stat.h>
 #include <sys/socket.h>
 #include <sys/un.h>
 
 static int iolog_flush(struct io_log *log);
 
 static const char iolog_ver2[] = "fio version 2 iolog";
+static const char iolog_ver3[] = "fio version 3 iolog";
 
 void queue_io_piece(struct thread_data *td, struct io_piece *ipo)
 {
 	flist_add_tail(&ipo->list, &td->io_log_list);
 	td->total_io_size += ipo->len;
 }
 
 void log_io_u(const struct thread_data *td, const struct io_u *io_u)
 {
 	if (!td->o.write_iolog_file)
@@ -109,63 +110,93 @@ static int ipo_special(struct thread_data *td, struct io_piece *ipo)
 	int ret;
 
 	/*
 	 * Not a special ipo
 	 */
 	if (ipo->ddir != DDIR_INVAL)
 		return 0;
 
 	f = td->files[ipo->fileno];
 
+	if (ipo->delay)
+		iolog_delay(td, ipo->delay);
+	if (fio_fill_issue_time(td)) {
+		struct timespec now;
+		fio_gettime(&now, NULL);
+		memcpy(&td->last_issue, &now, sizeof(now));
+	}
 	switch (ipo->file_action) {
 	case FIO_LOG_OPEN_FILE:
 		if (td->o.replay_redirect && fio_file_open(f)) {
 			dprint(FD_FILE, "iolog: ignoring re-open of file %s\n",
 					f->file_name);
 			break;
 		}
 		ret = td_io_open_file(td, f);
 		if (!ret)
 			break;
 		td_verror(td, ret, "iolog open file");
 		return -1;
 	case FIO_LOG_CLOSE_FILE:
 		td_io_close_file(td, f);
 		break;
 	case FIO_LOG_UNLINK_FILE:
 		td_io_unlink_file(td, f);
 		break;
+	case FIO_LOG_ADD_FILE:
+		/*
+		 * Nothing to do
+		 */
+		break;
 	default:
 		log_err("fio: bad file action %d\n", ipo->file_action);
 		break;
 	}
 
 	return 1;
 }
 
-static bool read_iolog2(struct thread_data *td);
+static bool read_iolog(struct thread_data *td);
+
+unsigned long long delay_since_ttime(const struct thread_data *td,
+	       unsigned long long time)
+{
+	double tmp;
+	double scale;
+	const unsigned long long *last_ttime = &td->io_log_last_ttime;
+
+	if (!*last_ttime || td->o.no_stall || time < *last_ttime)
+		return 0;
+	else if (td->o.replay_time_scale == 100)
+		return time - *last_ttime;
+
+
+	scale = (double) 100.0 / (double) td->o.replay_time_scale;
+	tmp = time - *last_ttime;
+	return tmp * scale;
+}
 
 int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 {
 	struct io_piece *ipo;
 	unsigned long elapsed;
 
 	while (!flist_empty(&td->io_log_list)) {
 		int ret;
 
 		if (td->o.read_iolog_chunked) {
 			if (td->io_log_checkmark == td->io_log_current) {
 				if (td->io_log_blktrace) {
 					if (!read_blktrace(td))
 						return 1;
 				} else {
-					if (!read_iolog2(td))
+					if (!read_iolog(td))
 						return 1;
 				}
 			}
 			td->io_log_current--;
 		}
 		ipo = flist_first_entry(&td->io_log_list, struct io_piece, list);
 		flist_del(&ipo->list);
 		remove_trim_entry(td, ipo);
 
 		ret = ipo_special(td, ipo);
@@ -381,28 +412,34 @@ int64_t iolog_items_to_fetch(struct thread_data *td)
 	} else
 		items_to_fetch = 0;
 
 	td->io_log_highmark = td->io_log_current + items_to_fetch;
 	td->io_log_checkmark = (td->io_log_highmark + 1) / 2;
 	fio_gettime(&td->io_log_highmark_time, NULL);
 
 	return items_to_fetch;
 }
 
+#define io_act(_td, _r) (((_td)->io_log_version == 3 && (r) == 5) || \
+					((_td)->io_log_version == 2 && (r) == 4))
+#define file_act(_td, _r) (((_td)->io_log_version == 3 && (r) == 3) || \
+					((_td)->io_log_version == 2 && (r) == 2))
+
 /*
- * Read version 2 iolog data. It is enhanced to include per-file logging,
+ * Read version 2 and 3 iolog data. It is enhanced to include per-file logging,
  * syncs, etc.
  */
-static bool read_iolog2(struct thread_data *td)
+static bool read_iolog(struct thread_data *td)
 {
 	unsigned long long offset;
 	unsigned int bytes;
+	unsigned long long delay = 0;
 	int reads, writes, waits, fileno = 0, file_action = 0; /* stupid gcc */
 	char *rfname, *fname, *act;
 	char *str, *p;
 	enum fio_ddir rw;
 	bool realloc = false;
 	int64_t items_to_fetch = 0;
 	int syncs;
 
 	if (td->o.read_iolog_chunked) {
 		items_to_fetch = iolog_items_to_fetch(td);
@@ -414,29 +451,43 @@ static bool read_iolog2(struct thread_data *td)
 	 * Read in the read iolog and store it, reuse the infrastructure
 	 * for doing verifications.
 	 */
 	str = malloc(4096);
 	rfname = fname = malloc(256+16);
 	act = malloc(256+16);
 
 	syncs = reads = writes = waits = 0;
 	while ((p = fgets(str, 4096, td->io_log_rfile)) != NULL) {
 		struct io_piece *ipo;
-		int r;
+		int r = 0;
+		unsigned long long ttime;
 
-		r = sscanf(p, "%256s %256s %llu %u", rfname, act, &offset,
-									&bytes);
+		if (td->io_log_version == 3) {
+			r = sscanf(p, "%llu %256s %256s %llu %u", &ttime, rfname, act,
+							&offset, &bytes);
+			delay = delay_since_ttime(td, ttime);
+			td->io_log_last_ttime = ttime;
+			/*
+			 * "wait" is not allowed for version 3
+			 */
+			if (!strcmp(act, "wait")) {
+				log_err("iolog: ignoring wait command with"
+					" version 3 for file %s\n", fname);
+				continue;
+			}
+		} else /* version 2 */
+			r = sscanf(p, "%256s %256s %llu %u", rfname, act, &offset, &bytes);
 
 		if (td->o.replay_redirect)
 			fname = td->o.replay_redirect;
 
-		if (r == 4) {
+		if (io_act(td, r)) {
 			/*
 			 * Check action first
 			 */
 			if (!strcmp(act, "wait"))
 				rw = DDIR_WAIT;
 			else if (!strcmp(act, "read"))
 				rw = DDIR_READ;
 			else if (!strcmp(act, "write"))
 				rw = DDIR_WRITE;
 			else if (!strcmp(act, "sync"))
@@ -444,45 +495,44 @@ static bool read_iolog2(struct thread_data *td)
 			else if (!strcmp(act, "datasync"))
 				rw = DDIR_DATASYNC;
 			else if (!strcmp(act, "trim"))
 				rw = DDIR_TRIM;
 			else {
 				log_err("fio: bad iolog file action: %s\n",
 									act);
 				continue;
 			}
 			fileno = get_fileno(td, fname);
-		} else if (r == 2) {
+		} else if (file_act(td, r)) {
 			rw = DDIR_INVAL;
 			if (!strcmp(act, "add")) {
 				if (td->o.replay_redirect &&
 				    get_fileno(td, fname) != -1) {
 					dprint(FD_FILE, "iolog: ignoring"
 						" re-add of file %s\n", fname);
 				} else {
 					fileno = add_file(td, fname, td->subjob_number, 1);
 					file_action = FIO_LOG_ADD_FILE;
 				}
-				continue;
 			} else if (!strcmp(act, "open")) {
 				fileno = get_fileno(td, fname);
 				file_action = FIO_LOG_OPEN_FILE;
 			} else if (!strcmp(act, "close")) {
 				fileno = get_fileno(td, fname);
 				file_action = FIO_LOG_CLOSE_FILE;
 			} else {
 				log_err("fio: bad iolog file action: %s\n",
 									act);
 				continue;
 			}
 		} else {
-			log_err("bad iolog2: %s\n", p);
+			log_err("bad iolog%d: %s\n", td->io_log_version, p);
 			continue;
 		}
 
 		if (rw == DDIR_READ)
 			reads++;
 		else if (rw == DDIR_WRITE) {
 			/*
 			 * Don't add a write for ro mode
 			 */
 			if (read_only)
@@ -499,20 +549,22 @@ static bool read_iolog2(struct thread_data *td)
 			log_err("bad ddir: %d\n", rw);
 			continue;
 		}
 
 		/*
 		 * Make note of file
 		 */
 		ipo = calloc(1, sizeof(*ipo));
 		init_ipo(ipo);
 		ipo->ddir = rw;
+		if (td->io_log_version == 3)
+			ipo->delay = delay;
 		if (rw == DDIR_WAIT) {
 			ipo->delay = offset;
 		} else {
 			if (td->o.replay_scale)
 				ipo->offset = offset / td->o.replay_scale;
 			else
 				ipo->offset = offset;
 			ipo_bytes_align(td->o.replay_align, ipo);
 
 			ipo->len = bytes;
@@ -643,32 +695,36 @@ static bool init_iolog_read(struct thread_data *td, char *fname)
 
 	p = fgets(buffer, sizeof(buffer), f);
 	if (!p) {
 		td_verror(td, errno, "iolog read");
 		log_err("fio: unable to read iolog\n");
 		fclose(f);
 		return false;
 	}
 
 	/*
-	 * version 2 of the iolog stores a specific string as the
+	 * versions 2 and 3 of the iolog store a specific string as the
 	 * first line, check for that
 	 */
-	if (!strncmp(iolog_ver2, buffer, strlen(iolog_ver2))) {
-		free_release_files(td);
-		td->io_log_rfile = f;
-		return read_iolog2(td);
+	if (!strncmp(iolog_ver2, buffer, strlen(iolog_ver2)))
+		td->io_log_version = 2;
+	else if (!strncmp(iolog_ver3, buffer, strlen(iolog_ver3)))
+		td->io_log_version = 3;
+	else {
+		log_err("fio: iolog version 1 is no longer supported\n");
+		fclose(f);
+		return false;
 	}
 
-	log_err("fio: iolog version 1 is no longer supported\n");
-	fclose(f);
-	return false;
+	free_release_files(td);
+	td->io_log_rfile = f;
+	return read_iolog(td);
 }
 
 /*
  * Set up a log for storing io patterns.
  */
 static bool init_iolog_write(struct thread_data *td)
 {
 	struct fio_file *ff;
 	FILE *f;
 	unsigned int i;
diff --git a/iolog.h b/iolog.h
index a3986309..62cbd1b0 100644
--- a/iolog.h
+++ b/iolog.h
@@ -220,24 +220,22 @@ struct io_piece {
 	struct flist_head trim_list;
 	union {
 		int fileno;
 		struct fio_file *file;
 	};
 	unsigned long long offset;
 	unsigned short numberio;
 	unsigned long len;
 	unsigned int flags;
 	enum fio_ddir ddir;
-	union {
-		unsigned long delay;
-		unsigned int file_action;
-	};
+	unsigned long delay;
+	unsigned int file_action;
 };
 
 /*
  * Log exports
  */
 enum file_log_act {
 	FIO_LOG_ADD_FILE,
 	FIO_LOG_OPEN_FILE,
 	FIO_LOG_CLOSE_FILE,
 	FIO_LOG_UNLINK_FILE,
@@ -252,20 +250,22 @@ extern void log_io_piece(struct thread_data *, struct io_u *);
 extern void unlog_io_piece(struct thread_data *, struct io_u *);
 extern void trim_io_piece(const struct io_u *);
 extern void queue_io_piece(struct thread_data *, struct io_piece *);
 extern void prune_io_piece_log(struct thread_data *);
 extern void write_iolog_close(struct thread_data *);
 int64_t iolog_items_to_fetch(struct thread_data *td);
 extern int iolog_compress_init(struct thread_data *, struct sk_out *);
 extern void iolog_compress_exit(struct thread_data *);
 extern size_t log_chunk_sizes(struct io_log *);
 extern int init_io_u_buffers(struct thread_data *);
+extern unsigned long long delay_since_ttime(const struct thread_data *,
+					     unsigned long long);
 
 #ifdef CONFIG_ZLIB
 extern int iolog_file_inflate(const char *);
 #endif
 
 /*
  * Logging
  */
 struct log_params {
 	struct thread_data *td;
-- 
2.30.2

