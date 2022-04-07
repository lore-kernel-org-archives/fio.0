Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C700EC4332F
	for <fio@archiver.kernel.org>; Thu,  7 Apr 2022 14:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344285AbiDGOwV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 7 Apr 2022 10:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241089AbiDGOwU (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Apr 2022 10:52:20 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFA11C9B72
        for <fio@vger.kernel.org>; Thu,  7 Apr 2022 07:50:13 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 237EAEow031008
        for <fio@vger.kernel.org>; Thu, 7 Apr 2022 07:50:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=M11u8lUayZi9sEpLg8k+YMlp9V6WrUdPtcxkL0pqXLA=;
 b=ghexvBU3gM6KfN5dNl8dlio5NNUIq2J1MsCOydaYB/UHa9LO6OVVahIrY1V2sVrbFH9z
 rde2BSzOPIIJgQrl25xeAcF2Vs7ANTSIRzhomHzPx7CxC6ZEy1xMn/J4HqFUTu7ZHNKh
 NFK69vVp4q7qGY03Ziiohj4JYh54PKVe8m8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fa1fvg9r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Thu, 07 Apr 2022 07:50:05 -0700
Received: from twshared19572.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 7 Apr 2022 07:50:04 -0700
Received: by devvm4279.ftw0.facebook.com (Postfix, from userid 199637)
        id 78D8D20E9FF76; Thu,  7 Apr 2022 07:50:00 -0700 (PDT)
From:   Mohamad Gebai <mogeb@fb.com>
To:     <fio@vger.kernel.org>
CC:     Mohamad Gebai <mogeb@fb.com>
Subject: [PATCH v2 1/3] iolog: add version 3 to support timestamp-based replay
Date:   Thu, 7 Apr 2022 07:49:56 -0700
Message-ID: <20220407144958.3975622-2-mogeb@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220407144958.3975622-1-mogeb@fb.com>
References: <20220407144958.3975622-1-mogeb@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: kdU0Fu-mDVd3powCah_p82SDyBp-VtQF
X-Proofpoint-ORIG-GUID: kdU0Fu-mDVd3powCah_p82SDyBp-VtQF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-07_03,2022-04-07_01,2022-02-23_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Version 3 format looks as follows:

    timestamp filename action offset length

All file and IO actions must have timestamps, including 'add'. The 'wait'
action is not allowed with version 3 so that we can leave all timing
functionality to timestamps.

Signed-off-by: Mohamad Gebai <mogeb@fb.com>
---
 blktrace.c | 17 ++---------
 fio.h      |  3 +-
 iolog.c    | 89 +++++++++++++++++++++++++++++++++++++++++++-----------
 iolog.h    |  8 ++---
 4 files changed, 80 insertions(+), 37 deletions(-)

diff --git a/blktrace.c b/blktrace.c
index ead60130..619121c7 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -306,39 +306,28 @@ static bool handle_trace_flush(struct thread_data *=
td, struct blk_io_trace *t,
 }
=20
 /*
  * We only care for queue traces, most of the others are side effects
  * due to internal workings of the block layer.
  */
 static bool queue_trace(struct thread_data *td, struct blk_io_trace *t,
 			 unsigned long *ios, unsigned long long *bs,
 			 struct file_cache *cache)
 {
-	unsigned long long *last_ttime =3D &td->io_log_blktrace_last_ttime;
+	unsigned long long *last_ttime =3D &td->io_log_last_ttime;
 	unsigned long long delay =3D 0;
=20
 	if ((t->action & 0xffff) !=3D __BLK_TA_QUEUE)
 		return false;
=20
 	if (!(t->action & BLK_TC_ACT(BLK_TC_NOTIFY))) {
-		if (!*last_ttime || td->o.no_stall || t->time < *last_ttime)
-			delay =3D 0;
-		else if (td->o.replay_time_scale =3D=3D 100)
-			delay =3D t->time - *last_ttime;
-		else {
-			double tmp =3D t->time - *last_ttime;
-			double scale;
-
-			scale =3D (double) 100.0 / (double) td->o.replay_time_scale;
-			tmp *=3D scale;
-			delay =3D tmp;
-		}
+		delay =3D delay_since_ttime(td, t->time);
 		*last_ttime =3D t->time;
 	}
=20
 	t_bytes_align(&td->o, t);
=20
 	if (t->action & BLK_TC_ACT(BLK_TC_NOTIFY))
 		return handle_trace_notify(t);
 	else if (t->action & BLK_TC_ACT(BLK_TC_DISCARD))
 		return handle_trace_discard(td, t, delay, ios, bs, cache);
 	else if (t->action & BLK_TC_ACT(BLK_TC_FLUSH))
@@ -415,21 +404,21 @@ static void depth_end(struct blk_io_trace *t, int *=
this_depth, int *depth)
 bool init_blktrace_read(struct thread_data *td, const char *filename, in=
t need_swap)
 {
 	int old_state;
=20
 	td->io_log_rfile =3D fopen(filename, "rb");
 	if (!td->io_log_rfile) {
 		td_verror(td, errno, "open blktrace file");
 		goto err;
 	}
 	td->io_log_blktrace_swap =3D need_swap;
-	td->io_log_blktrace_last_ttime =3D 0;
+	td->io_log_last_ttime =3D 0;
 	td->o.size =3D 0;
=20
 	free_release_files(td);
=20
 	old_state =3D td_bump_runstate(td, TD_SETTING_UP);
=20
 	if (!read_blktrace(td)) {
 		goto err;
 	}
=20
diff --git a/fio.h b/fio.h
index 776fb51f..8830ff34 100644
--- a/fio.h
+++ b/fio.h
@@ -424,24 +424,25 @@ struct thread_data {
 	struct flist_head io_hist_list;
 	unsigned long io_hist_len;
=20
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
=20
 	/*
 	 * For tracking/handling discards
 	 */
 	struct flist_head trim_list;
 	unsigned long trim_entries;
=20
 	/*
 	 * for fileservice, how often to switch to a new file
diff --git a/iolog.c b/iolog.c
index 724ec1fe..f6023ee2 100644
--- a/iolog.c
+++ b/iolog.c
@@ -24,20 +24,21 @@
 #include <netinet/in.h>
 #include <netinet/tcp.h>
 #include <arpa/inet.h>
 #include <sys/stat.h>
 #include <sys/socket.h>
 #include <sys/un.h>
=20
 static int iolog_flush(struct io_log *log);
=20
 static const char iolog_ver2[] =3D "fio version 2 iolog";
+static const char iolog_ver3[] =3D "fio version 3 iolog";
=20
 void queue_io_piece(struct thread_data *td, struct io_piece *ipo)
 {
 	flist_add_tail(&ipo->list, &td->io_log_list);
 	td->total_io_size +=3D ipo->len;
 }
=20
 void log_io_u(const struct thread_data *td, const struct io_u *io_u)
 {
 	if (!td->o.write_iolog_file)
@@ -109,63 +110,90 @@ static int ipo_special(struct thread_data *td, stru=
ct io_piece *ipo)
 	int ret;
=20
 	/*
 	 * Not a special ipo
 	 */
 	if (ipo->ddir !=3D DDIR_INVAL)
 		return 0;
=20
 	f =3D td->files[ipo->fileno];
=20
+	if (ipo->delay)
+		iolog_delay(td, ipo->delay);
+	if (fio_fill_issue_time(td))
+		fio_gettime(&td->last_issue, NULL);
 	switch (ipo->file_action) {
 	case FIO_LOG_OPEN_FILE:
 		if (td->o.replay_redirect && fio_file_open(f)) {
 			dprint(FD_FILE, "iolog: ignoring re-open of file %s\n",
 					f->file_name);
 			break;
 		}
 		ret =3D td_io_open_file(td, f);
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
=20
 	return 1;
 }
=20
-static bool read_iolog2(struct thread_data *td);
+static bool read_iolog(struct thread_data *td);
+
+unsigned long long delay_since_ttime(const struct thread_data *td,
+	       unsigned long long time)
+{
+	double tmp;
+	double scale;
+	const unsigned long long *last_ttime =3D &td->io_log_last_ttime;
+
+	if (!*last_ttime || td->o.no_stall || time < *last_ttime)
+		return 0;
+	else if (td->o.replay_time_scale =3D=3D 100)
+		return time - *last_ttime;
+
+
+	scale =3D (double) 100.0 / (double) td->o.replay_time_scale;
+	tmp =3D time - *last_ttime;
+	return tmp * scale;
+}
=20
 int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 {
 	struct io_piece *ipo;
 	unsigned long elapsed;
=20
 	while (!flist_empty(&td->io_log_list)) {
 		int ret;
=20
 		if (td->o.read_iolog_chunked) {
 			if (td->io_log_checkmark =3D=3D td->io_log_current) {
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
 		ipo =3D flist_first_entry(&td->io_log_list, struct io_piece, list);
 		flist_del(&ipo->list);
 		remove_trim_entry(td, ipo);
=20
 		ret =3D ipo_special(td, ipo);
@@ -381,28 +409,34 @@ int64_t iolog_items_to_fetch(struct thread_data *td=
)
 	} else
 		items_to_fetch =3D 0;
=20
 	td->io_log_highmark =3D td->io_log_current + items_to_fetch;
 	td->io_log_checkmark =3D (td->io_log_highmark + 1) / 2;
 	fio_gettime(&td->io_log_highmark_time, NULL);
=20
 	return items_to_fetch;
 }
=20
+#define io_act(_td, _r) (((_td)->io_log_version =3D=3D 3 && (r) =3D=3D 5=
) || \
+					((_td)->io_log_version =3D=3D 2 && (r) =3D=3D 4))
+#define file_act(_td, _r) (((_td)->io_log_version =3D=3D 3 && (r) =3D=3D=
 3) || \
+					((_td)->io_log_version =3D=3D 2 && (r) =3D=3D 2))
+
 /*
- * Read version 2 iolog data. It is enhanced to include per-file logging=
,
+ * Read version 2 and 3 iolog data. It is enhanced to include per-file l=
ogging,
  * syncs, etc.
  */
-static bool read_iolog2(struct thread_data *td)
+static bool read_iolog(struct thread_data *td)
 {
 	unsigned long long offset;
 	unsigned int bytes;
+	unsigned long long delay =3D 0;
 	int reads, writes, waits, fileno =3D 0, file_action =3D 0; /* stupid gc=
c */
 	char *rfname, *fname, *act;
 	char *str, *p;
 	enum fio_ddir rw;
 	bool realloc =3D false;
 	int64_t items_to_fetch =3D 0;
 	int syncs;
=20
 	if (td->o.read_iolog_chunked) {
 		items_to_fetch =3D iolog_items_to_fetch(td);
@@ -415,28 +449,42 @@ static bool read_iolog2(struct thread_data *td)
 	 * for doing verifications.
 	 */
 	str =3D malloc(4096);
 	rfname =3D fname =3D malloc(256+16);
 	act =3D malloc(256+16);
=20
 	syncs =3D reads =3D writes =3D waits =3D 0;
 	while ((p =3D fgets(str, 4096, td->io_log_rfile)) !=3D NULL) {
 		struct io_piece *ipo;
 		int r;
+		unsigned long long ttime;
=20
-		r =3D sscanf(p, "%256s %256s %llu %u", rfname, act, &offset,
-									&bytes);
+		if (td->io_log_version =3D=3D 3) {
+			r =3D sscanf(p, "%llu %256s %256s %llu %u", &ttime, rfname, act,
+							&offset, &bytes);
+			delay =3D delay_since_ttime(td, ttime);
+			td->io_log_last_ttime =3D ttime;
+			/*
+			 * "wait" is not allowed with version 3
+			 */
+			if (!strcmp(act, "wait")) {
+				log_err("iolog: ignoring wait command with"
+					" version 3 for file %s\n", fname);
+				continue;
+			}
+		} else /* version 2 */
+			r =3D sscanf(p, "%256s %256s %llu %u", rfname, act, &offset, &bytes);
=20
 		if (td->o.replay_redirect)
 			fname =3D td->o.replay_redirect;
=20
-		if (r =3D=3D 4) {
+		if (io_act(td, r)) {
 			/*
 			 * Check action first
 			 */
 			if (!strcmp(act, "wait"))
 				rw =3D DDIR_WAIT;
 			else if (!strcmp(act, "read"))
 				rw =3D DDIR_READ;
 			else if (!strcmp(act, "write"))
 				rw =3D DDIR_WRITE;
 			else if (!strcmp(act, "sync"))
@@ -444,45 +492,44 @@ static bool read_iolog2(struct thread_data *td)
 			else if (!strcmp(act, "datasync"))
 				rw =3D DDIR_DATASYNC;
 			else if (!strcmp(act, "trim"))
 				rw =3D DDIR_TRIM;
 			else {
 				log_err("fio: bad iolog file action: %s\n",
 									act);
 				continue;
 			}
 			fileno =3D get_fileno(td, fname);
-		} else if (r =3D=3D 2) {
+		} else if (file_act(td, r)) {
 			rw =3D DDIR_INVAL;
 			if (!strcmp(act, "add")) {
 				if (td->o.replay_redirect &&
 				    get_fileno(td, fname) !=3D -1) {
 					dprint(FD_FILE, "iolog: ignoring"
 						" re-add of file %s\n", fname);
 				} else {
 					fileno =3D add_file(td, fname, td->subjob_number, 1);
 					file_action =3D FIO_LOG_ADD_FILE;
 				}
-				continue;
 			} else if (!strcmp(act, "open")) {
 				fileno =3D get_fileno(td, fname);
 				file_action =3D FIO_LOG_OPEN_FILE;
 			} else if (!strcmp(act, "close")) {
 				fileno =3D get_fileno(td, fname);
 				file_action =3D FIO_LOG_CLOSE_FILE;
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
=20
 		if (rw =3D=3D DDIR_READ)
 			reads++;
 		else if (rw =3D=3D DDIR_WRITE) {
 			/*
 			 * Don't add a write for ro mode
 			 */
 			if (read_only)
@@ -499,20 +546,22 @@ static bool read_iolog2(struct thread_data *td)
 			log_err("bad ddir: %d\n", rw);
 			continue;
 		}
=20
 		/*
 		 * Make note of file
 		 */
 		ipo =3D calloc(1, sizeof(*ipo));
 		init_ipo(ipo);
 		ipo->ddir =3D rw;
+		if (td->io_log_version =3D=3D 3)
+			ipo->delay =3D delay;
 		if (rw =3D=3D DDIR_WAIT) {
 			ipo->delay =3D offset;
 		} else {
 			if (td->o.replay_scale)
 				ipo->offset =3D offset / td->o.replay_scale;
 			else
 				ipo->offset =3D offset;
 			ipo_bytes_align(td->o.replay_align, ipo);
=20
 			ipo->len =3D bytes;
@@ -643,32 +692,36 @@ static bool init_iolog_read(struct thread_data *td,=
 char *fname)
=20
 	p =3D fgets(buffer, sizeof(buffer), f);
 	if (!p) {
 		td_verror(td, errno, "iolog read");
 		log_err("fio: unable to read iolog\n");
 		fclose(f);
 		return false;
 	}
=20
 	/*
-	 * version 2 of the iolog stores a specific string as the
+	 * versions 2 and 3 of the iolog store a specific string as the
 	 * first line, check for that
 	 */
-	if (!strncmp(iolog_ver2, buffer, strlen(iolog_ver2))) {
-		free_release_files(td);
-		td->io_log_rfile =3D f;
-		return read_iolog2(td);
+	if (!strncmp(iolog_ver2, buffer, strlen(iolog_ver2)))
+		td->io_log_version =3D 2;
+	else if (!strncmp(iolog_ver3, buffer, strlen(iolog_ver3)))
+		td->io_log_version =3D 3;
+	else {
+		log_err("fio: iolog version 1 is no longer supported\n");
+		fclose(f);
+		return false;
 	}
=20
-	log_err("fio: iolog version 1 is no longer supported\n");
-	fclose(f);
-	return false;
+	free_release_files(td);
+	td->io_log_rfile =3D f;
+	return read_iolog(td);
 }
=20
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
=20
 /*
  * Log exports
  */
 enum file_log_act {
 	FIO_LOG_ADD_FILE,
 	FIO_LOG_OPEN_FILE,
 	FIO_LOG_CLOSE_FILE,
 	FIO_LOG_UNLINK_FILE,
@@ -252,20 +250,22 @@ extern void log_io_piece(struct thread_data *, stru=
ct io_u *);
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
=20
 #ifdef CONFIG_ZLIB
 extern int iolog_file_inflate(const char *);
 #endif
=20
 /*
  * Logging
  */
 struct log_params {
 	struct thread_data *td;
--=20
2.30.2

