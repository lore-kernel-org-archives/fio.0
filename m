Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35936 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405262AbfITMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 20 Sep 2019 08:00:11 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iBHa7-0007CN-1C
        for fio@vger.kernel.org; Fri, 20 Sep 2019 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190920120002.382EB2C02C4@kernel.dk>
Date: Fri, 20 Sep 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ae3ae8367271e6df7be5eae37c15c00e6c2dc76e:

  Merge branch 'fio_reset_sqe' of https://github.com/anarazel/fio (2019-09-13 14:56:16 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 92f75708b530989fdb13b50be6604f44b80d038d:

  Fio 3.16 (2019-09-19 19:01:52 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      engines/io_uring: remove debug printf
      Fio 3.16

 FIO-VERSION-GEN    | 2 +-
 engines/io_uring.c | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 350da551..d5cec22e 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.15
+DEF_VER=fio-3.16
 
 LF='
 '
diff --git a/engines/io_uring.c b/engines/io_uring.c
index e5edfcd2..ef56345b 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -562,7 +562,6 @@ static int fio_ioring_post_init(struct thread_data *td)
 		return 1;
 	}
 
-	printf("files=%d\n", o->registerfiles);
 	if (o->registerfiles) {
 		err = fio_ioring_register_files(td);
 		if (err) {

