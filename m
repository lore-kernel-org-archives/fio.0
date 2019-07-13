Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55934 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbfGMMAT (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 13 Jul 2019 08:00:19 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hmGhO-0007Lb-3g
        for fio@vger.kernel.org; Sat, 13 Jul 2019 12:00:19 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190713120001.E90262C0147@kernel.dk>
Date: Sat, 13 Jul 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f32a30d4c4eb2490b5c1bdac9ae3c2fc7a7ab20e:

  engines/http: set FIO_SYNCIO flag (2019-07-09 08:55:31 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fc220349e45144360917db48010b503a9874930d:

  Merge branch 'dev' of https://github.com/smartxworks/fio (2019-07-12 10:44:45 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Fio 3.15
      Merge branch 'dev' of https://github.com/smartxworks/fio

Kyle Zhang (1):
      libiscsi: log reason of error when readcapacity failed

 FIO-VERSION-GEN    | 2 +-
 engines/libiscsi.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 69222008..350da551 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.14
+DEF_VER=fio-3.15
 
 LF='
 '
diff --git a/engines/libiscsi.c b/engines/libiscsi.c
index e4eb0bab..bea94c5a 100644
--- a/engines/libiscsi.c
+++ b/engines/libiscsi.c
@@ -117,7 +117,8 @@ static int fio_iscsi_setup_lun(struct iscsi_info *iscsi_info,
 
 	task = iscsi_readcapacity16_sync(iscsi_lun->iscsi, iscsi_lun->url->lun);
 	if (task == NULL || task->status != SCSI_STATUS_GOOD) {
-		log_err("iscsi: failed to send readcapacity command\n");
+		log_err("iscsi: failed to send readcapacity command: %s\n",
+			iscsi_get_error(iscsi_lun->iscsi));
 		ret = EINVAL;
 		goto out;
 	}

