Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57740 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfEIMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 May 2019 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hOhiW-0002l6-Mf
        for fio@vger.kernel.org; Thu, 09 May 2019 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190509120003.26BCA2C098E@kernel.dk>
Date: Thu,  9 May 2019 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f22dd97a5a1342c7dcb84f777a77bd30859cc35b:

  Update CFLAGS and LDFLAGS for FreeBSD builds (2019-05-06 22:18:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2857c34bd39fcd67c489a8e2b19d9455032bad0f:

  t/io_uring: clarify polled support is fs + device (2019-05-08 11:56:05 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: clarify polled support is fs + device

 t/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 79a92311..208b58a5 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -264,7 +264,8 @@ static int reap_events(struct submitter *s)
 			if (cqe->res != BS) {
 				printf("io: unexpected ret=%d\n", cqe->res);
 				if (polled && cqe->res == -EOPNOTSUPP)
-					printf("Your filesystem doesn't support poll\n");
+					printf("Your filesystem/device doesn't "
+						"support polled IO\n");
 				return -1;
 			}
 		}

