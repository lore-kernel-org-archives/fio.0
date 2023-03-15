Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3E0C6FD1D
	for <fio@archiver.kernel.org>; Wed, 15 Mar 2023 12:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbjCOMAM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 15 Mar 2023 08:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjCOMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Mar 2023 08:00:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BDF10A94
        for <fio@vger.kernel.org>; Wed, 15 Mar 2023 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=bXwgKBoTSoAJSoWnQmfLRCi4Cm3wuDy4D/Z/b8ndAzw=; b=rs8sfi1CD+FpztaNIm0fqulNnY
        kaWiwzPnDUCVhIBaU0vqUqYPlp1jhIOIKXVjEWUKcsbXYI936iHA7oR3XCA/jPtGtufrZzUE/NmN3
        vUeEBQw1GnGwYvIMN0211FR7ZmSe6oCiEjU1+bvlAsQU7VvyaWrBNK0Id1wAcgFAas4lzgMNdW3zW
        hGP67P5SXSN3O9x/tqkwghzWv1UCeRgAA3YkCKJ4s0hwrv/S1RLV2yDmoI/93DvoHuTu/3vc6TAHh
        SbKHOV+EhBPmiYEQB5uGAuiT4mxszSTYZiNreoYs8qIYfQ554mY4L0GUbyT0c4zmMWjHFYPOJexTQ
        7u+1QQuA==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pcPna-00Do7X-Ey
        for fio@vger.kernel.org; Wed, 15 Mar 2023 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 382EF1BC012D; Wed, 15 Mar 2023 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230315120002.382EF1BC012D@kernel.dk>
Date:   Wed, 15 Mar 2023 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 557cfc51068921766e8cd6b242feb4c929cb45ea:

  t/zbd: fix minimum write size to sequential write required zones (2023-03-07 12:45:41 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4ad09b569a2689b3b67744eaccd378d013eb82a7:

  t/io_uring: abstract out init_new_io() helper (2023-03-14 14:03:32 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      Fio 3.34
      t/io_uring: avoid truncation of offset on 32-bit builds
      t/io_uring: use the get_offset() code to retrieve pass-through offset
      t/io_uring: abstract out init_new_io() helper

 FIO-VERSION-GEN |  2 +-
 t/io_uring.c    | 78 ++++++++++++++++++---------------------------------------
 2 files changed, 25 insertions(+), 55 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 5a0822c9..f1585d34 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.33
+DEF_VER=fio-3.34
 
 LF='
 '
diff --git a/t/io_uring.c b/t/io_uring.c
index 1ea0a9da..504f8ce9 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -530,8 +530,11 @@ static unsigned long long get_offset(struct submitter *s, struct file *f)
 	long r;
 
 	if (random_io) {
+		unsigned long long block;
+
 		r = __rand64(&s->rand_state);
-		offset = (r % (f->max_blocks - 1)) * bs;
+		block = r % f->max_blocks;
+		offset = block * (unsigned long long) bs;
 	} else {
 		offset = f->cur_off;
 		f->cur_off += bs;
@@ -542,16 +545,10 @@ static unsigned long long get_offset(struct submitter *s, struct file *f)
 	return offset;
 }
 
-static void init_io(struct submitter *s, unsigned index)
+static struct file *init_new_io(struct submitter *s)
 {
-	struct io_uring_sqe *sqe = &s->sqes[index];
 	struct file *f;
 
-	if (do_nop) {
-		sqe->opcode = IORING_OP_NOP;
-		return;
-	}
-
 	if (s->nr_files == 1) {
 		f = &s->files[0];
 	} else {
@@ -563,7 +560,22 @@ static void init_io(struct submitter *s, unsigned index)
 			f = &s->files[s->cur_file];
 		}
 	}
+
 	f->pending_ios++;
+	return f;
+}
+
+static void init_io(struct submitter *s, unsigned index)
+{
+	struct io_uring_sqe *sqe = &s->sqes[index];
+	struct file *f;
+
+	if (do_nop) {
+		sqe->opcode = IORING_OP_NOP;
+		return;
+	}
+
+	f = init_new_io(s);
 
 	if (register_files) {
 		sqe->flags = IOSQE_FIXED_FILE;
@@ -603,30 +615,10 @@ static void init_io_pt(struct submitter *s, unsigned index)
 	struct nvme_uring_cmd *cmd;
 	unsigned long long slba;
 	unsigned long long nlb;
-	long r;
 
-	if (s->nr_files == 1) {
-		f = &s->files[0];
-	} else {
-		f = &s->files[s->cur_file];
-		if (f->pending_ios >= file_depth(s)) {
-			s->cur_file++;
-			if (s->cur_file == s->nr_files)
-				s->cur_file = 0;
-			f = &s->files[s->cur_file];
-		}
-	}
-	f->pending_ios++;
+	f = init_new_io(s);
 
-	if (random_io) {
-		r = __rand64(&s->rand_state);
-		offset = (r % (f->max_blocks - 1)) * bs;
-	} else {
-		offset = f->cur_off;
-		f->cur_off += bs;
-		if (f->cur_off + bs > f->max_size)
-			f->cur_off = 0;
-	}
+	offset = get_offset(s, f);
 
 	if (register_files) {
 		sqe->fd = f->fixed_fd;
@@ -1121,18 +1113,7 @@ static int prep_more_ios_aio(struct submitter *s, int max_ios, struct iocb *iocb
 	while (index < max_ios) {
 		struct iocb *iocb = &iocbs[index];
 
-		if (s->nr_files == 1) {
-			f = &s->files[0];
-		} else {
-			f = &s->files[s->cur_file];
-			if (f->pending_ios >= file_depth(s)) {
-				s->cur_file++;
-				if (s->cur_file == s->nr_files)
-					s->cur_file = 0;
-				f = &s->files[s->cur_file];
-			}
-		}
-		f->pending_ios++;
+		f = init_new_io(s);
 
 		io_prep_pread(iocb, f->real_fd, s->iovecs[index].iov_base,
 				s->iovecs[index].iov_len, get_offset(s, f));
@@ -1419,18 +1400,7 @@ static void *submitter_sync_fn(void *data)
 		uint64_t offset;
 		struct file *f;
 
-		if (s->nr_files == 1) {
-			f = &s->files[0];
-		} else {
-			f = &s->files[s->cur_file];
-			if (f->pending_ios >= file_depth(s)) {
-				s->cur_file++;
-				if (s->cur_file == s->nr_files)
-					s->cur_file = 0;
-				f = &s->files[s->cur_file];
-			}
-		}
-		f->pending_ios++;
+		f = init_new_io(s);
 
 #ifdef ARCH_HAVE_CPU_CLOCK
 		if (stats)
