Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbgGNMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Jul 2020 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A8EC061755
        for <fio@vger.kernel.org>; Tue, 14 Jul 2020 05:00:09 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvJbR-0000H5-QV
        for fio@vger.kernel.org; Tue, 14 Jul 2020 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200714120002.4D7631BC0C9C@kernel.dk>
Date: Tue, 14 Jul 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5bd526f2a614e75a929906c91a5fa3bab293d319:

  t/io_uring: make bs and polled IO configurable at runtime (2020-07-08 15:48:11 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 255f09d6d266c3e73abb9776ae481bb4d79caf00:

  Merge branch 'io_uring-opt' of https://github.com/antonblanchard/fio (2020-07-13 08:01:52 -0600)

----------------------------------------------------------------
Anton Blanchard (1):
      io_uring: Avoid needless update of completion queue head pointer

Jens Axboe (1):
      Merge branch 'io_uring-opt' of https://github.com/antonblanchard/fio

 engines/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index cd0810f4..ecff0657 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -307,7 +307,9 @@ static int fio_ioring_cqring_reap(struct thread_data *td, unsigned int events,
 		head++;
 	} while (reaped + events < max);
 
-	atomic_store_release(ring->head, head);
+	if (reaped)
+		atomic_store_release(ring->head, head);
+
 	return reaped;
 }
 

