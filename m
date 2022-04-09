Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4EFDC433EF
	for <fio@archiver.kernel.org>; Sat,  9 Apr 2022 12:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbiDIMCR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 9 Apr 2022 08:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiDIMCR (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 9 Apr 2022 08:02:17 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2217B26565
        for <fio@vger.kernel.org>; Sat,  9 Apr 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=atByBPEfrCm1HAgU1RQzDWOgyq2e+3n37cwRVnw8D2Y=; b=mbsODdL6T0MD2LnSKEl6Bs3IUN
        FPT+vj9pnm5IK4vYlbn6U49kfR1RJdPxpAKA4QY/YYCZ3ci0Xl3IoKRPGw4oSbuFUQLasHXDSBD2c
        Huaj8RL+mKekj8zh4cm1gDZGeZXz+aDWnxWGowjg1HobG5LZEOdVjtd5ZdJ4tA4u74esLfx8MQMpH
        SBaHSTbNxmzPhXXP93AjQUydMYQGjZdqPDhmbya62+7RVn8ekR2AItgNW7Q9yv/WUYzozNflwMNYJ
        yccCmz9x6dtQWAI0zP6TSpjfWVAn2yiIDyHz8jmCLFnJ8Qa8J3VxTmDzfIlIFGVuV3jzZgun5Kba1
        dCdnM45g==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nd9l6-003Juq-3Z
        for fio@vger.kernel.org; Sat, 09 Apr 2022 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id D215B1BC0135; Sat,  9 Apr 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220409120001.D215B1BC0135@kernel.dk>
Date:   Sat,  9 Apr 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit a3e48f483db27d20e02cbd81e3a8f18c6c5c50f5:

  Fio 3.30 (2022-04-06 17:10:00 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6d01ac19170fadaf46a6db6b4cc347f1b389f422:

  iolog: Use %llu for 64-bit (2022-04-08 12:46:44 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      iolog: fix warning for 32-bit compilation
      iolog: Use %llu for 64-bit

Mohamad Gebai (3):
      iolog: add version 3 to support timestamp-based replay
      iolog: add iolog_write for version 3
      iolog: update man page for version 3

 HOWTO.rst  |  29 +++++++++++++++-
 blktrace.c |  17 ++--------
 fio.1      |  35 +++++++++++++++++++-
 fio.h      |   4 ++-
 iolog.c    | 109 ++++++++++++++++++++++++++++++++++++++++++++++++-------------
 iolog.h    |   8 ++---
 6 files changed, 158 insertions(+), 44 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 0978879c..a5fa432e 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4398,7 +4398,9 @@ given in bytes. The `action` can be one of these:
 
 **wait**
 	   Wait for `offset` microseconds. Everything below 100 is discarded.
-	   The time is relative to the previous `wait` statement.
+	   The time is relative to the previous `wait` statement. Note that
+	   action `wait` is not allowed as of version 3, as the same behavior
+	   can be achieved using timestamps.
 **read**
 	   Read `length` bytes beginning from `offset`.
 **write**
@@ -4411,6 +4413,31 @@ given in bytes. The `action` can be one of these:
 	   Trim the given file from the given `offset` for `length` bytes.
 
 
+Trace file format v3
+~~~~~~~~~~~~~~~~~~~~
+
+The third version of the trace file format was added in fio version 3.31. It
+forces each action to have a timestamp associated with it.
+
+The first line of the trace file has to be::
+
+    fio version 3 iolog
+
+Following this can be lines in two different formats, which are described below.
+
+The file management format::
+
+    timestamp filename action
+
+The file I/O action format::
+
+    timestamp filename action offset length
+
+The `timestamp` is relative to the beginning of the run (ie starts at 0). The
+`filename`, `action`, `offset` and `length`  are identical to version 2, except
+that version 3 does not allow the `wait` action.
+
+
 I/O Replay - Merging Traces
 ---------------------------
 
diff --git a/blktrace.c b/blktrace.c
index ead60130..619121c7 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -313,25 +313,14 @@ static bool queue_trace(struct thread_data *td, struct blk_io_trace *t,
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
 
@@ -422,7 +411,7 @@ bool init_blktrace_read(struct thread_data *td, const char *filename, int need_s
 		goto err;
 	}
 	td->io_log_blktrace_swap = need_swap;
-	td->io_log_blktrace_last_ttime = 0;
+	td->io_log_last_ttime = 0;
 	td->o.size = 0;
 
 	free_release_files(td);
diff --git a/fio.1 b/fio.1
index 98410655..a2ec836f 100644
--- a/fio.1
+++ b/fio.1
@@ -4117,7 +4117,9 @@ given in bytes. The `action' can be one of these:
 .TP
 .B wait
 Wait for `offset' microseconds. Everything below 100 is discarded.
-The time is relative to the previous `wait' statement.
+The time is relative to the previous `wait' statement. Note that action `wait`
+is not allowed as of version 3, as the same behavior can be achieved using
+timestamps.
 .TP
 .B read
 Read `length' bytes beginning from `offset'.
@@ -4135,6 +4137,37 @@ Write `length' bytes beginning from `offset'.
 Trim the given file from the given `offset' for `length' bytes.
 .RE
 .RE
+.RE
+.TP
+.B Trace file format v3
+The third version of the trace file format was added in fio version 3.31. It
+forces each action to have a timestamp associated with it.
+.RS
+.P
+The first line of the trace file has to be:
+.RS
+.P
+"fio version 3 iolog"
+.RE
+.P
+Following this can be lines in two different formats, which are described below.
+.P
+.B
+The file management format:
+.RS
+timestamp filename action
+.P
+.RE
+.B
+The file I/O action format:
+.RS
+timestamp filename action offset length
+.P
+The `timestamp` is relative to the beginning of the run (ie starts at 0). The
+`filename`, `action`, `offset` and `length`  are identical to version 2, except
+that version 3 does not allow the `wait` action.
+.RE
+.RE
 .SH I/O REPLAY \- MERGING TRACES
 Colocation is a common practice used to get the most out of a machine.
 Knowing which workloads play nicely with each other and which ones don't is
diff --git a/fio.h b/fio.h
index 776fb51f..de7eca79 100644
--- a/fio.h
+++ b/fio.h
@@ -431,10 +431,12 @@ struct thread_data {
 	FILE *io_log_rfile;
 	unsigned int io_log_blktrace;
 	unsigned int io_log_blktrace_swap;
-	unsigned long long io_log_blktrace_last_ttime;
+	unsigned long long io_log_last_ttime;
+	struct timespec io_log_start_time;
 	unsigned int io_log_current;
 	unsigned int io_log_checkmark;
 	unsigned int io_log_highmark;
+	unsigned int io_log_version;
 	struct timespec io_log_highmark_time;
 
 	/*
diff --git a/iolog.c b/iolog.c
index 724ec1fe..37e799a1 100644
--- a/iolog.c
+++ b/iolog.c
@@ -31,6 +31,7 @@
 static int iolog_flush(struct io_log *log);
 
 static const char iolog_ver2[] = "fio version 2 iolog";
+static const char iolog_ver3[] = "fio version 3 iolog";
 
 void queue_io_piece(struct thread_data *td, struct io_piece *ipo)
 {
@@ -40,18 +41,24 @@ void queue_io_piece(struct thread_data *td, struct io_piece *ipo)
 
 void log_io_u(const struct thread_data *td, const struct io_u *io_u)
 {
+	struct timespec now;
+
 	if (!td->o.write_iolog_file)
 		return;
 
-	fprintf(td->iolog_f, "%s %s %llu %llu\n", io_u->file->file_name,
-						io_ddir_name(io_u->ddir),
-						io_u->offset, io_u->buflen);
+	fio_gettime(&now, NULL);
+	fprintf(td->iolog_f, "%llu %s %s %llu %llu\n",
+		(unsigned long long) utime_since_now(&td->io_log_start_time),
+		io_u->file->file_name, io_ddir_name(io_u->ddir), io_u->offset,
+		io_u->buflen);
+
 }
 
 void log_file(struct thread_data *td, struct fio_file *f,
 	      enum file_log_act what)
 {
 	const char *act[] = { "add", "open", "close" };
+	struct timespec now;
 
 	assert(what < 3);
 
@@ -65,7 +72,10 @@ void log_file(struct thread_data *td, struct fio_file *f,
 	if (!td->iolog_f)
 		return;
 
-	fprintf(td->iolog_f, "%s %s\n", f->file_name, act[what]);
+	fio_gettime(&now, NULL);
+	fprintf(td->iolog_f, "%llu %s %s\n",
+		(unsigned long long) utime_since_now(&td->io_log_start_time),
+		f->file_name, act[what]);
 }
 
 static void iolog_delay(struct thread_data *td, unsigned long delay)
@@ -116,6 +126,10 @@ static int ipo_special(struct thread_data *td, struct io_piece *ipo)
 
 	f = td->files[ipo->fileno];
 
+	if (ipo->delay)
+		iolog_delay(td, ipo->delay);
+	if (fio_fill_issue_time(td))
+		fio_gettime(&td->last_issue, NULL);
 	switch (ipo->file_action) {
 	case FIO_LOG_OPEN_FILE:
 		if (td->o.replay_redirect && fio_file_open(f)) {
@@ -134,6 +148,11 @@ static int ipo_special(struct thread_data *td, struct io_piece *ipo)
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
@@ -142,7 +161,25 @@ static int ipo_special(struct thread_data *td, struct io_piece *ipo)
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
@@ -158,7 +195,7 @@ int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 					if (!read_blktrace(td))
 						return 1;
 				} else {
-					if (!read_iolog2(td))
+					if (!read_iolog(td))
 						return 1;
 				}
 			}
@@ -388,14 +425,20 @@ int64_t iolog_items_to_fetch(struct thread_data *td)
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
@@ -422,14 +465,28 @@ static bool read_iolog2(struct thread_data *td)
 	while ((p = fgets(str, 4096, td->io_log_rfile)) != NULL) {
 		struct io_piece *ipo;
 		int r;
+		unsigned long long ttime;
 
-		r = sscanf(p, "%256s %256s %llu %u", rfname, act, &offset,
-									&bytes);
+		if (td->io_log_version == 3) {
+			r = sscanf(p, "%llu %256s %256s %llu %u", &ttime, rfname, act,
+							&offset, &bytes);
+			delay = delay_since_ttime(td, ttime);
+			td->io_log_last_ttime = ttime;
+			/*
+			 * "wait" is not allowed with version 3
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
@@ -451,7 +508,7 @@ static bool read_iolog2(struct thread_data *td)
 				continue;
 			}
 			fileno = get_fileno(td, fname);
-		} else if (r == 2) {
+		} else if (file_act(td, r)) {
 			rw = DDIR_INVAL;
 			if (!strcmp(act, "add")) {
 				if (td->o.replay_redirect &&
@@ -462,7 +519,6 @@ static bool read_iolog2(struct thread_data *td)
 					fileno = add_file(td, fname, td->subjob_number, 1);
 					file_action = FIO_LOG_ADD_FILE;
 				}
-				continue;
 			} else if (!strcmp(act, "open")) {
 				fileno = get_fileno(td, fname);
 				file_action = FIO_LOG_OPEN_FILE;
@@ -475,7 +531,7 @@ static bool read_iolog2(struct thread_data *td)
 				continue;
 			}
 		} else {
-			log_err("bad iolog2: %s\n", p);
+			log_err("bad iolog%d: %s\n", td->io_log_version, p);
 			continue;
 		}
 
@@ -506,6 +562,8 @@ static bool read_iolog2(struct thread_data *td)
 		ipo = calloc(1, sizeof(*ipo));
 		init_ipo(ipo);
 		ipo->ddir = rw;
+		if (td->io_log_version == 3)
+			ipo->delay = delay;
 		if (rw == DDIR_WAIT) {
 			ipo->delay = offset;
 		} else {
@@ -650,18 +708,22 @@ static bool init_iolog_read(struct thread_data *td, char *fname)
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
@@ -685,11 +747,12 @@ static bool init_iolog_write(struct thread_data *td)
 	td->iolog_f = f;
 	td->iolog_buf = malloc(8192);
 	setvbuf(f, td->iolog_buf, _IOFBF, 8192);
+	fio_gettime(&td->io_log_start_time, NULL);
 
 	/*
 	 * write our version line
 	 */
-	if (fprintf(f, "%s\n", iolog_ver2) < 0) {
+	if (fprintf(f, "%s\n", iolog_ver3) < 0) {
 		perror("iolog init\n");
 		return false;
 	}
diff --git a/iolog.h b/iolog.h
index a3986309..62cbd1b0 100644
--- a/iolog.h
+++ b/iolog.h
@@ -227,10 +227,8 @@ struct io_piece {
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
@@ -259,6 +257,8 @@ extern int iolog_compress_init(struct thread_data *, struct sk_out *);
 extern void iolog_compress_exit(struct thread_data *);
 extern size_t log_chunk_sizes(struct io_log *);
 extern int init_io_u_buffers(struct thread_data *);
+extern unsigned long long delay_since_ttime(const struct thread_data *,
+					     unsigned long long);
 
 #ifdef CONFIG_ZLIB
 extern int iolog_file_inflate(const char *);
