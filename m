Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38090 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751769AbcLMNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Dec 2016 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cGmge-0007GW-2O
        for fio@vger.kernel.org; Tue, 13 Dec 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161213130002.3FC962C029F@kernel.dk>
Date: Tue, 13 Dec 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 487197d9e8f3aa0f135a6d88e5f222a1a930723a:

  mmap engine: remove unused variable mmap_map_mask (2016-12-05 09:48:08 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a79f17bf3bfa20b83424c2301de092bdcfbaaea4:

  iolog: add support for replay_scale option (2016-12-12 22:23:28 +0000)

----------------------------------------------------------------
Sitsofe Wheeler (3):
      iolog: Ignore re-add/re-open with replay_redirect
      blktrace: Fix replay_align 32 bit truncation
      iolog: add support for replay_scale option

 blktrace.c | 13 ++-----------
 iolog.c    | 22 +++++++++++++++++++---
 iolog.h    |  8 ++++++++
 3 files changed, 29 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/blktrace.c b/blktrace.c
index deb8b2d..a3474cb 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -216,15 +216,6 @@ static void t_bytes_align(struct thread_options *o, struct blk_io_trace *t)
 	t->bytes = (t->bytes + o->replay_align - 1) & ~(o->replay_align - 1);
 }
 
-static void ipo_bytes_align(struct thread_options *o, struct io_piece *ipo)
-{
-	if (!o->replay_align)
-		return;
-
-	ipo->offset &= ~(o->replay_align - 1);
-}
-
-
 /*
  * Store blk_io_trace data in an ipo for later retrieval.
  */
@@ -239,7 +230,7 @@ static void store_ipo(struct thread_data *td, unsigned long long offset,
 	ipo->offset = offset * bs;
 	if (td->o.replay_scale)
 		ipo->offset = ipo->offset / td->o.replay_scale;
-	ipo_bytes_align(&td->o, ipo);
+	ipo_bytes_align(td->o.replay_align, ipo);
 	ipo->len = bytes;
 	ipo->delay = ttime / 1000;
 	if (rw)
@@ -297,7 +288,7 @@ static void handle_trace_discard(struct thread_data *td,
 	ipo->offset = t->sector * bs;
 	if (td->o.replay_scale)
 		ipo->offset = ipo->offset / td->o.replay_scale;
-	ipo_bytes_align(&td->o, ipo);
+	ipo_bytes_align(td->o.replay_align, ipo);
 	ipo->len = t->bytes;
 	ipo->delay = ttime / 1000;
 	ipo->ddir = DDIR_TRIM;
diff --git a/iolog.c b/iolog.c
index 2bc3e3a..9393890 100644
--- a/iolog.c
+++ b/iolog.c
@@ -109,6 +109,11 @@ static int ipo_special(struct thread_data *td, struct io_piece *ipo)
 
 	switch (ipo->file_action) {
 	case FIO_LOG_OPEN_FILE:
+		if (td->o.replay_redirect && fio_file_open(f)) {
+			dprint(FD_FILE, "iolog: ignoring re-open of file %s\n",
+					f->file_name);
+			break;
+		}
 		ret = td_io_open_file(td, f);
 		if (!ret)
 			break;
@@ -396,8 +401,14 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 		} else if (r == 2) {
 			rw = DDIR_INVAL;
 			if (!strcmp(act, "add")) {
-				fileno = add_file(td, fname, 0, 1);
-				file_action = FIO_LOG_ADD_FILE;
+				if (td->o.replay_redirect &&
+				    get_fileno(td, fname) != -1) {
+					dprint(FD_FILE, "iolog: ignoring"
+						" re-add of file %s\n", fname);
+				} else {
+					fileno = add_file(td, fname, 0, 1);
+					file_action = FIO_LOG_ADD_FILE;
+				}
 				continue;
 			} else if (!strcmp(act, "open")) {
 				fileno = get_fileno(td, fname);
@@ -443,7 +454,12 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 		if (rw == DDIR_WAIT) {
 			ipo->delay = offset;
 		} else {
-			ipo->offset = offset;
+			if (td->o.replay_scale)
+				ipo->offset = offset / td->o.replay_scale;
+			else
+				ipo->offset = offset;
+			ipo_bytes_align(td->o.replay_align, ipo);
+
 			ipo->len = bytes;
 			if (rw != DDIR_INVAL && bytes > td->o.max_bs[rw])
 				td->o.max_bs[rw] = bytes;
diff --git a/iolog.h b/iolog.h
index ee28944..60ee3e9 100644
--- a/iolog.h
+++ b/iolog.h
@@ -269,6 +269,14 @@ static inline bool inline_log(struct io_log *log)
 		log->log_type == IO_LOG_TYPE_SLAT;
 }
 
+static inline void ipo_bytes_align(unsigned int replay_align, struct io_piece *ipo)
+{
+	if (replay_align)
+		return;
+
+	ipo->offset &= ~(replay_align - (uint64_t)1);
+}
+
 extern void finalize_logs(struct thread_data *td, bool);
 extern void setup_log(struct io_log **, struct log_params *, const char *);
 extern void flush_log(struct io_log *, bool);
