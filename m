Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36936 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfHDMIt (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 4 Aug 2019 08:08:49 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1huFJh-0007l6-N9
        for fio@vger.kernel.org; Sun, 04 Aug 2019 12:08:49 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190804120001.6289E2C0099@kernel.dk>
Date: Sun,  4 Aug 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f2d6de5d997b039cebac9c34912871baa5e12d49:

  nbd: Document the NBD-specific uri parameter (2019-08-02 11:05:28 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to acd44dec8cfa476d91dc1695df64f249e52d06e3:

  nbd: Remove copy and paste error in example (2019-08-03 09:51:44 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      engines/splice: remove buggy ->mem_align set

Richard W.M. Jones (1):
      nbd: Remove copy and paste error in example

 engines/splice.c | 7 -------
 examples/nbd.fio | 2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/engines/splice.c b/engines/splice.c
index feb764fe..6fc36bb6 100644
--- a/engines/splice.c
+++ b/engines/splice.c
@@ -278,13 +278,6 @@ static int fio_spliceio_init(struct thread_data *td)
 	 */
 	sd->vmsplice_to_user_map = 1;
 
-	/*
-	 * And if vmsplice_to_user works, we definitely need aligned
-	 * buffers. Just set ->odirect to force that.
-	 */
-	if (td_read(td))
-		td->o.mem_align = 1;
-
 	td->io_ops_data = sd;
 	return 0;
 }
diff --git a/examples/nbd.fio b/examples/nbd.fio
index 27e15086..6900ebe7 100644
--- a/examples/nbd.fio
+++ b/examples/nbd.fio
@@ -26,7 +26,7 @@ iodepth=64
 offset=0
 
 [job1]
-offset=064m
+offset=64m
 
 [job2]
 offset=128m

