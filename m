Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D3CC433F5
	for <fio@archiver.kernel.org>; Thu, 29 Sep 2022 12:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235453AbiI2MAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 29 Sep 2022 08:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbiI2MAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Sep 2022 08:00:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D84D1D0FD
        for <fio@vger.kernel.org>; Thu, 29 Sep 2022 05:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=C7OQ80VR4pTzEOud/Qm5gWeP0dYeApbWs/lrSswR6KQ=; b=jz86HTc1tDkFbcRXnztNSE3Oud
        hqZ6RW37ivYMuRTdSgQQt7xR9v82stg89yiovBiMU7T3+4N5X+PQjB38skeBT3oCA8PYl6ype1sPE
        o+Yme3MmkXITBXbaIHWk6tLId8Ruq8lwRZYJ9EoYYZrTlHgj3ihgT78Hm14fQU6cq1zUQYlc57YVb
        p3iEVrpCSY6YD2Rc4pHof5vg8Kd2T2R6hawU4q7RSaGqLL5+D8IyQ3FJ7Zsj88PcGssexZaDW2P5g
        V5cuYi/XLni/ul/Ba5D8J3SXZX3Oimkqd57KW6y/EtWbyWv0++0LVMQl5dacZNgGKyHI2nS1k0WfT
        0bmMgxJQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1odsD0-00DFPG-Nc
        for fio@vger.kernel.org; Thu, 29 Sep 2022 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 8CDEB1BC016C; Thu, 29 Sep 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220929120001.8CDEB1BC016C@kernel.dk>
Date:   Thu, 29 Sep 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 6112c0f5a86c6b437e7158ab40a6e9384ce95e85:

  doc: build manpage from fio_doc.rst instead of fio_man.rst (2022-09-27 11:58:25 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c16dc793a3c45780f67ce65244b6e91323dee014:

  Add randtrimwrite data direction (2022-09-28 10:06:40 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      t/io_uring: get rid of useless read barriers
      Add randtrimwrite data direction

 HOWTO.rst    |  3 +++
 fio.1        |  5 +++++
 io_ddir.h    |  4 +++-
 options.c    |  4 ++++
 t/io_uring.c | 10 ++++++----
 5 files changed, 21 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 924f5ed9..e89d05f0 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1134,6 +1134,9 @@ I/O type
 				write 64K bytes on the same trimmed blocks. This behaviour
 				will be consistent with ``number_ios`` or other Fio options
 				limiting the total bytes or number of I/O's.
+		**randtrimwrite**
+				Like trimwrite, but uses random offsets rather
+				than sequential writes.
 
 	Fio defaults to read if the option is not specified.  For the mixed I/O
 	types, the default is to split them 50/50.  For certain types of I/O the
diff --git a/fio.1 b/fio.1
index 39d6b4f4..4324a975 100644
--- a/fio.1
+++ b/fio.1
@@ -904,6 +904,11 @@ then the same blocks will be written to. So if `io_size=64K' is specified,
 Fio will trim a total of 64K bytes and also write 64K bytes on the same
 trimmed blocks. This behaviour will be consistent with `number_ios' or
 other Fio options limiting the total bytes or number of I/O's.
+.TP
+.B randtrimwrite
+Like
+.B trimwrite ,
+but uses random offsets rather than sequential writes.
 .RE
 .P
 Fio defaults to read if the option is not specified. For the mixed I/O
diff --git a/io_ddir.h b/io_ddir.h
index 296a9d04..7227e9ee 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -41,6 +41,7 @@ enum td_ddir {
 	TD_DDIR_RANDRW		= TD_DDIR_RW | TD_DDIR_RAND,
 	TD_DDIR_RANDTRIM	= TD_DDIR_TRIM | TD_DDIR_RAND,
 	TD_DDIR_TRIMWRITE	= TD_DDIR_TRIM | TD_DDIR_WRITE,
+	TD_DDIR_RANDTRIMWRITE	= TD_DDIR_RANDTRIM | TD_DDIR_WRITE,
 };
 
 #define td_read(td)		((td)->o.td_ddir & TD_DDIR_READ)
@@ -67,7 +68,8 @@ static inline const char *ddir_str(enum td_ddir ddir)
 {
 	static const char *__str[] = { NULL, "read", "write", "rw", "rand",
 				"randread", "randwrite", "randrw",
-				"trim", NULL, "trimwrite", NULL, "randtrim" };
+				"trim", NULL, "trimwrite", NULL, "randtrim",
+				NULL, "randtrimwrite" };
 
 	return __str[ddir];
 }
diff --git a/options.c b/options.c
index 5d3daedf..a668b0e4 100644
--- a/options.c
+++ b/options.c
@@ -1947,6 +1947,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = TD_DDIR_TRIMWRITE,
 			    .help = "Trim and write mix, trims preceding writes"
 			  },
+			  { .ival = "randtrimwrite",
+			    .oval = TD_DDIR_RANDTRIMWRITE,
+			    .help = "Randomly trim and write mix, trims preceding writes"
+			  },
 		},
 	},
 	{
diff --git a/t/io_uring.c b/t/io_uring.c
index b9353ac8..edbacee3 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -661,8 +661,12 @@ static void init_io_pt(struct submitter *s, unsigned index)
 static int prep_more_ios_uring(struct submitter *s, int max_ios)
 {
 	struct io_sq_ring *ring = &s->sq_ring;
-	unsigned index, tail, next_tail, prepped = 0;
-	unsigned int head = atomic_load_acquire(ring->head);
+	unsigned head, index, tail, next_tail, prepped = 0;
+
+	if (sq_thread_poll)
+		head = atomic_load_acquire(ring->head);
+	else
+		head = *ring->head;
 
 	next_tail = tail = *ring->tail;
 	do {
@@ -741,7 +745,6 @@ static int reap_events_uring(struct submitter *s)
 	do {
 		struct file *f;
 
-		read_barrier();
 		if (head == atomic_load_acquire(ring->tail))
 			break;
 		cqe = &ring->cqes[head & cq_ring_mask];
@@ -796,7 +799,6 @@ static int reap_events_uring_pt(struct submitter *s)
 	do {
 		struct file *f;
 
-		read_barrier();
 		if (head == atomic_load_acquire(ring->tail))
 			break;
 		index = head & cq_ring_mask;
