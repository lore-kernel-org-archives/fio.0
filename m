Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbhBQNAq (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 17 Feb 2021 08:00:46 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12D7C061756
        for <fio@vger.kernel.org>; Wed, 17 Feb 2021 05:00:05 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lCMR1-0003X1-L1
        for fio@vger.kernel.org; Wed, 17 Feb 2021 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210217130001.A6C621BC0116@kernel.dk>
Date: Wed, 17 Feb 2021 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d16e84e256ffdcd3143c9439cf1e408d8db61c1a:

  Merge branch 'per-engine-pre-write-function' of https://github.com/lukaszstolarczuk/fio (2021-02-14 13:21:05 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c4f5c92fac8a39ffff29d57e99c3c0163358dd7a:

  engines/io_uring: add verbose error for ENOSYS (2021-02-16 12:07:14 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      engines/io_uring: add verbose error for ENOSYS

 engines/io_uring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 9ce2ae80..c9036ba0 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -696,7 +696,11 @@ static int fio_ioring_post_init(struct thread_data *td)
 
 	err = fio_ioring_queue_init(td);
 	if (err) {
-		td_verror(td, errno, "io_queue_init");
+		int __errno = errno;
+
+		if (__errno == ENOSYS)
+			log_err("fio: your kernel doesn't support io_uring\n");
+		td_verror(td, __errno, "io_queue_init");
 		return 1;
 	}
 

