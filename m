Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41276 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfEJMGC (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 May 2019 08:06:02 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hP4Hq-0006SV-4p
        for fio@vger.kernel.org; Fri, 10 May 2019 12:06:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190510120001.B694C2C00F5@kernel.dk>
Date: Fri, 10 May 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2857c34bd39fcd67c489a8e2b19d9455032bad0f:

  t/io_uring: clarify polled support is fs + device (2019-05-08 11:56:05 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8066f6b6177acba17f61fecb9f04d04767fb1a96:

  t/io_uring: improve EOPNOTSUPP message (2019-05-09 09:56:29 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: improve EOPNOTSUPP message

 t/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 208b58a5..62dee805 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -264,8 +264,7 @@ static int reap_events(struct submitter *s)
 			if (cqe->res != BS) {
 				printf("io: unexpected ret=%d\n", cqe->res);
 				if (polled && cqe->res == -EOPNOTSUPP)
-					printf("Your filesystem/device doesn't "
-						"support polled IO\n");
+					printf("Your filesystem/driver/kernel doesn't support polled IO\n");
 				return -1;
 			}
 		}

