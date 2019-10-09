Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47928 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbfJIMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Oct 2019 08:00:06 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIAdQ-000244-Pb
        for fio@vger.kernel.org; Wed, 09 Oct 2019 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191009120001.63D2F2C086D@kernel.dk>
Date: Wed,  9 Oct 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 998baa29f571df9d2e4b626bedd317a2fd28c68a:

  Merge branch 'replay-blktrace-fixes' of https://github.com/shimrot/fio (2019-10-07 21:23:26 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 983a656c11bf35043759de48aa5a85bdb4ffb106:

  Merge branch 'bumpflocks' of https://github.com/earlephilhower/fio (2019-10-08 20:58:57 -0600)

----------------------------------------------------------------
Earle F. Philhower, III (1):
      Increase MAX_FILELOCKS for highly parallel IO test

Jens Axboe (1):
      Merge branch 'bumpflocks' of https://github.com/earlephilhower/fio

 filelock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/filelock.c b/filelock.c
index cc98aafc..7e92f63d 100644
--- a/filelock.c
+++ b/filelock.c
@@ -22,7 +22,7 @@ struct fio_filelock {
 	unsigned int references;
 };
 
-#define MAX_FILELOCKS	128
+#define MAX_FILELOCKS	1024
 	
 static struct filelock_data {
 	struct flist_head list;

