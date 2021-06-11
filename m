Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbhFKMCh (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 11 Jun 2021 08:02:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58170C061574
        for <fio@vger.kernel.org>; Fri, 11 Jun 2021 05:00:39 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lrfpW-002ilz-Bt
        for fio@vger.kernel.org; Fri, 11 Jun 2021 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210611120002.1987F1BC0165@kernel.dk>
Date: Fri, 11 Jun 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 40d0b84220f7c0ff9c3874656db7f0f8cb6a85e6:

  t/zbd: Fix write target zones counting in test case #31 (2021-06-08 15:15:58 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dd4620b7f9171edaa10955c4826454a05af27c85:

  io_uring: drop redundant IO_MODE_OFFLOAD check (2021-06-10 16:40:49 -0600)

----------------------------------------------------------------
Stefan Hajnoczi (1):
      io_uring: drop redundant IO_MODE_OFFLOAD check

 engines/io_uring.c | 6 ------
 1 file changed, 6 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index b962e804..9c091e37 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -728,12 +728,6 @@ static int fio_ioring_init(struct thread_data *td)
 	struct ioring_data *ld;
 	struct thread_options *to = &td->o;
 
-	if (to->io_submit_mode == IO_MODE_OFFLOAD) {
-		log_err("fio: io_submit_mode=offload is not compatible (or "
-			"useful) with io_uring\n");
-		return 1;
-	}
-
 	/* sqthread submission requires registered files */
 	if (o->sqpoll_thread)
 		o->registerfiles = 1;

