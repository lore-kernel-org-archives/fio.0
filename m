Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBFAC433F5
	for <fio@archiver.kernel.org>; Wed,  6 Oct 2021 12:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E87560FE3
	for <fio@archiver.kernel.org>; Wed,  6 Oct 2021 12:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238201AbhJFMC3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 6 Oct 2021 08:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238167AbhJFMC3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Oct 2021 08:02:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51419C061749
        for <fio@vger.kernel.org>; Wed,  6 Oct 2021 05:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=dWTS9C6PCdWIrCNGvF0GWO6jO1z94YPyp/5h8/dv07Q=; b=gMzIOxaGKxSHojew0UgDSniPiR
        P5pIvnGRHv5ftE4lXCYIQHrpEC8tGOPT5LnboAwP5KrEu/XwWZJU04APz9HsyCxUdzqieXfxjwcUJ
        VeVgIhOjV0pI3bVO4NXsfODJdt3KzzbP6VtHEbHmHTAJaEjeXotC8QK5abLZwc357NL1hX3lJ7zm6
        XHviGcyxKqU4DxXUXsEZM5ld1Wh0HopUR4oIAw2bAJLyF2oM5aR9grPKc+mtM0OuywgZAr0vhtUWS
        2gD873cpP84uz4s3RrkB/DNijKi9FdrMM9agVfTo5DNUH6fleKgo5x8DDgq9VqYEXebl83AemVeIR
        Q2ohnrkg==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mY5ae-000qfY-BR
        for fio@vger.kernel.org; Wed, 06 Oct 2021 12:00:15 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 713A71BC014C; Wed,  6 Oct 2021 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211006120001.713A71BC014C@kernel.dk>
Date:   Wed,  6 Oct 2021 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 24a24c12a04c45174c2d68ffb7fcb3f367e40dee:

  t/io_uring: clean up aio wait loop (2021-10-04 17:04:04 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 09ee86fa431939cb8f634e9ee8e1fc8d9302ea59:

  t/io_uring: get rid of old debug printfs (2021-10-05 06:58:07 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      t/io_uring: print submitter id with tid on startup
      t/io_uring: get rid of old debug printfs

 t/io_uring.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index f27a12c7..7ef2f6ce 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -552,7 +552,7 @@ static int submitter_init(struct submitter *s)
 	int i, nr_batch;
 
 	s->tid = gettid();
-	printf("submitter=%d\n", s->tid);
+	printf("submitter=%d, tid=%d\n", s->index, s->tid);
 
 	srand48(pthread_self());
 
@@ -951,7 +951,6 @@ static int setup_ring(struct submitter *s)
 	ptr = mmap(0, p.sq_off.array + p.sq_entries * sizeof(__u32),
 			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
 			IORING_OFF_SQ_RING);
-	printf("sq_ring ptr = 0x%p\n", ptr);
 	sring->head = ptr + p.sq_off.head;
 	sring->tail = ptr + p.sq_off.tail;
 	sring->ring_mask = ptr + p.sq_off.ring_mask;
@@ -963,12 +962,10 @@ static int setup_ring(struct submitter *s)
 	s->sqes = mmap(0, p.sq_entries * sizeof(struct io_uring_sqe),
 			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
 			IORING_OFF_SQES);
-	printf("sqes ptr    = 0x%p\n", s->sqes);
 
 	ptr = mmap(0, p.cq_off.cqes + p.cq_entries * sizeof(struct io_uring_cqe),
 			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
 			IORING_OFF_CQ_RING);
-	printf("cq_ring ptr = 0x%p\n", ptr);
 	cring->head = ptr + p.cq_off.head;
 	cring->tail = ptr + p.cq_off.tail;
 	cring->ring_mask = ptr + p.cq_off.ring_mask;
@@ -1253,10 +1250,8 @@ int main(int argc, char *argv[])
 	printf("polled=%d, fixedbufs=%d, register_files=%d, buffered=%d, QD=%d\n", polled, fixedbufs, register_files, buffered, depth);
 	if (!aio)
 		printf("Engine=io_uring, sq_ring=%d, cq_ring=%d\n", *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
-#ifdef CONFIG_LIBAIO
 	else
-		printf("Engine=aio, ctx=%p\n", &s->aio_ctx);
-#endif
+		printf("Engine=aio\n");
 
 	for (j = 0; j < nthreads; j++) {
 		s = get_submitter(j);
