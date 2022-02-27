Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E575C433F5
	for <fio@archiver.kernel.org>; Sun, 27 Feb 2022 13:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiB0NAp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 27 Feb 2022 08:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiB0NAp (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 27 Feb 2022 08:00:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728B039B8A
        for <fio@vger.kernel.org>; Sun, 27 Feb 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=4HHDIRN1ZD+Tb0pKBjKuBJEwtTiHybuyHpqRj378pc8=; b=g/lprae+dgqslD+9ghAEiHcBxx
        n+lq8kPnZaF4jXhfe9AQ8Yl1Xzq3d8SD5w18lRnTQJc1dNadZUfPlJBJSskuhlxpXH4swAMm/S5D5
        atPCk8LZhyqtC0kj1+8HqZMn5+iUotBQ22cPvkt7Nu1yg2TTRptY3zjLy7n9KI0yh1KCLsMzRYmkP
        Xz37WSa9xBxDEm/Ws5cJJAtoBii2GPiu+sj2jDsXej4qtOnE5synB1SjBy0AiW0IrKOTXeWm6Fwjj
        BtPyI57SVyYvyorIA2xWIV+aKerYgM+CFFMrpaAsIBtPjUCJT6NqpzFm2QW7YZgZWjzSpA35MeBvu
        lDO8E9Qg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOJ9g-007ZQ6-Ma
        for fio@vger.kernel.org; Sun, 27 Feb 2022 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id C13CF1BC017F; Sun, 27 Feb 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220227130001.C13CF1BC017F@kernel.dk>
Date:   Sun, 27 Feb 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit cf2511565f40be1b78b3fc1194e823baf305f0a0:

  Merge branch 'master' of https://github.com/bvanassche/fio (2022-02-24 12:40:19 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c3773c171dffb79f771d213d94249cefc4b9b6de:

  windowsaio: open file for write if we have syncs (2022-02-26 10:43:20 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Add TD_F_SYNCS thread flag
      windowsaio: open file for write if we have syncs

 blktrace.c           | 4 ++++
 engines/windowsaio.c | 2 +-
 fio.h                | 6 ++++--
 ioengines.h          | 2 +-
 iolog.c              | 9 +++++++--
 5 files changed, 17 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/blktrace.c b/blktrace.c
index e1804765..ead60130 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -297,6 +297,10 @@ static bool handle_trace_flush(struct thread_data *td, struct blk_io_trace *t,
 
 	ios[DDIR_SYNC]++;
 	dprint(FD_BLKTRACE, "store flush delay=%lu\n", ipo->delay);
+
+	if (!(td->flags & TD_F_SYNCS))
+		td->flags |= TD_F_SYNCS;
+
 	queue_io_piece(td, ipo);
 	return true;
 }
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index d82c8053..6681f8bb 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -248,7 +248,7 @@ static int fio_windowsaio_open_file(struct thread_data *td, struct fio_file *f)
 		log_err("fio: unknown fadvise type %d\n", td->o.fadvise_hint);
 	}
 
-	if (!td_write(td) || read_only)
+	if ((!td_write(td) && !(td->flags & TD_F_SYNCS)) || read_only)
 		access = GENERIC_READ;
 	else
 		access = (GENERIC_READ | GENERIC_WRITE);
diff --git a/fio.h b/fio.h
index 88df117d..c314f0a8 100644
--- a/fio.h
+++ b/fio.h
@@ -97,6 +97,7 @@ enum {
 	__TD_F_MMAP_KEEP,
 	__TD_F_DIRS_CREATED,
 	__TD_F_CHECK_RATE,
+	__TD_F_SYNCS,
 	__TD_F_LAST,		/* not a real bit, keep last */
 };
 
@@ -118,6 +119,7 @@ enum {
 	TD_F_MMAP_KEEP		= 1U << __TD_F_MMAP_KEEP,
 	TD_F_DIRS_CREATED	= 1U << __TD_F_DIRS_CREATED,
 	TD_F_CHECK_RATE		= 1U << __TD_F_CHECK_RATE,
+	TD_F_SYNCS		= 1U << __TD_F_SYNCS,
 };
 
 enum {
@@ -678,8 +680,8 @@ enum {
 	TD_NR,
 };
 
-#define TD_ENG_FLAG_SHIFT	17
-#define TD_ENG_FLAG_MASK	((1U << 17) - 1)
+#define TD_ENG_FLAG_SHIFT	18
+#define TD_ENG_FLAG_MASK	((1U << 18) - 1)
 
 static inline void td_set_ioengine_flags(struct thread_data *td)
 {
diff --git a/ioengines.h b/ioengines.h
index b3f755b4..acdb0071 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -8,7 +8,7 @@
 #include "io_u.h"
 #include "zbd_types.h"
 
-#define FIO_IOOPS_VERSION	30
+#define FIO_IOOPS_VERSION	31
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
diff --git a/iolog.c b/iolog.c
index a2cf0c1c..724ec1fe 100644
--- a/iolog.c
+++ b/iolog.c
@@ -402,6 +402,7 @@ static bool read_iolog2(struct thread_data *td)
 	enum fio_ddir rw;
 	bool realloc = false;
 	int64_t items_to_fetch = 0;
+	int syncs;
 
 	if (td->o.read_iolog_chunked) {
 		items_to_fetch = iolog_items_to_fetch(td);
@@ -417,7 +418,7 @@ static bool read_iolog2(struct thread_data *td)
 	rfname = fname = malloc(256+16);
 	act = malloc(256+16);
 
-	reads = writes = waits = 0;
+	syncs = reads = writes = waits = 0;
 	while ((p = fgets(str, 4096, td->io_log_rfile)) != NULL) {
 		struct io_piece *ipo;
 		int r;
@@ -492,7 +493,9 @@ static bool read_iolog2(struct thread_data *td)
 				continue;
 			waits++;
 		} else if (rw == DDIR_INVAL) {
-		} else if (!ddir_sync(rw)) {
+		} else if (ddir_sync(rw)) {
+			syncs++;
+		} else {
 			log_err("bad ddir: %d\n", rw);
 			continue;
 		}
@@ -547,6 +550,8 @@ static bool read_iolog2(struct thread_data *td)
 			" read-only\n", td->o.name, writes);
 		writes = 0;
 	}
+	if (syncs)
+		td->flags |= TD_F_SYNCS;
 
 	if (td->o.read_iolog_chunked) {
 		if (td->io_log_current == 0) {
