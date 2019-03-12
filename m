Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54682 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfCLMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 12 Mar 2019 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h3g4m-00048y-66
        for fio@vger.kernel.org; Tue, 12 Mar 2019 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190312120002.6087E2C0049@kernel.dk>
Date: Tue, 12 Mar 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e39863e3cb61bb750f5e7d87fcf11c2bf4651996:

  t/io_uring: add depth options (2019-03-08 21:30:25 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d9c50de7c1d95e5c173ac6d7f5b3f0d63131f8b4:

  t/io_uring: memset() allocated memory (2019-03-11 10:46:47 -0600)

----------------------------------------------------------------
Keith Busch (1):
      t/io_uring: memset() allocated memory

 t/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 36aede9b..363cba3e 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -526,7 +526,8 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	submitter = malloc(sizeof(*submitter) * depth * sizeof(struct iovec));
+	submitter = malloc(sizeof(*submitter) + depth * sizeof(struct iovec));
+	memset(submitter, 0, sizeof(*submitter) + depth * sizeof(struct iovec));
 	s = submitter;
 
 	flags = O_RDONLY | O_NOATIME;

