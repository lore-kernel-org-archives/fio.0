Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbhCJNAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 Mar 2021 08:00:11 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413F7C061760
        for <fio@vger.kernel.org>; Wed, 10 Mar 2021 05:00:11 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lJyRZ-003TZR-GG
        for fio@vger.kernel.org; Wed, 10 Mar 2021 13:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210310130002.513561BC014F@kernel.dk>
Date: Wed, 10 Mar 2021 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 267b164c372d57145880f365bab8d8a52bf8baa7:

  Fio 3.26 (2021-03-08 17:44:38 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6b8cadb66c62394420a39b46af1a2967b916c829:

  Merge branch 'master' of https://github.com/DevriesL/fio (2021-03-09 07:58:39 -0700)

----------------------------------------------------------------
DevriesL (1):
      engines/io_uring: fix compilation conflict with Android NDK

Jens Axboe (1):
      Merge branch 'master' of https://github.com/DevriesL/fio

 engines/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index c9036ba0..b962e804 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -696,11 +696,11 @@ static int fio_ioring_post_init(struct thread_data *td)
 
 	err = fio_ioring_queue_init(td);
 	if (err) {
-		int __errno = errno;
+		int init_err = errno;
 
-		if (__errno == ENOSYS)
+		if (init_err == ENOSYS)
 			log_err("fio: your kernel doesn't support io_uring\n");
-		td_verror(td, __errno, "io_queue_init");
+		td_verror(td, init_err, "io_queue_init");
 		return 1;
 	}
 

