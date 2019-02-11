Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36312 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfBKNAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Feb 2019 08:00:10 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gtBBx-0006cA-SA
        for fio@vger.kernel.org; Mon, 11 Feb 2019 13:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190211130001.B33982C00B5@kernel.dk>
Date: Mon, 11 Feb 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2f75f022393e432210d01b15088f425ee5260340:

  client/server: inflate error handling (2019-02-08 16:33:34 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6616949337d8409ec0999f2b3ad240ea2d037a82:

  io_uring: sync header with the kernel (2019-02-10 09:36:48 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: sync header with the kernel

 os/linux/io_uring.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index b1504502..24906e99 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -11,8 +11,6 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 
-#define IORING_MAX_ENTRIES	4096
-
 /*
  * IO submission data structure (Submission Queue Entry)
  */
@@ -94,7 +92,8 @@ struct io_sqring_offsets {
 	__u32 flags;
 	__u32 dropped;
 	__u32 array;
-	__u32 resv[3];
+	__u32 resv1;
+	__u64 resv2;
 };
 
 /*
@@ -109,7 +108,7 @@ struct io_cqring_offsets {
 	__u32 ring_entries;
 	__u32 overflow;
 	__u32 cqes;
-	__u32 resv[4];
+	__u64 resv[2];
 };
 
 /*

