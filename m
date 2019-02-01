Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44958 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfBANAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Feb 2019 08:00:09 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gpYQS-0000Jz-Gw
        for fio@vger.kernel.org; Fri, 01 Feb 2019 13:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190201130001.ECACE2C0148@kernel.dk>
Date: Fri,  1 Feb 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 521164fa90df413aa7aa8fb2956095a41eba7d6a:

  io_uring: ensure we use the right argument syscall (2019-01-29 12:20:02 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 154a95828fe08b01774b59602544de394b2d3aa6:

  t/io_uring: verbose error for -95/-EOPNOTSUPP failure (2019-01-31 22:55:52 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: verbose error for -95/-EOPNOTSUPP failure

 t/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 62b48e44..7c75c887 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -262,6 +262,8 @@ static int reap_events(struct submitter *s)
 			f->pending_ios--;
 			if (cqe->res != BS) {
 				printf("io: unexpected ret=%d\n", cqe->res);
+				if (polled && cqe->res == -EOPNOTSUPP)
+					printf("Your filesystem doesn't support poll\n");
 				return -1;
 			}
 		}

