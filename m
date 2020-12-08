Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgLHNAq (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Dec 2020 08:00:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0BEC061749
        for <fio@vger.kernel.org>; Tue,  8 Dec 2020 05:00:06 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmcb6-0005CD-Cp
        for fio@vger.kernel.org; Tue, 08 Dec 2020 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201208130001.5C06A1BC011C@kernel.dk>
Date: Tue,  8 Dec 2020 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a210654b03dbd04f17984d1cf791b1fd56862f1b:

  Merge branch 'cufile' of https://github.com/SystemFabricWorks/fio (2020-12-05 14:45:16 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 731365d849407426fe32981c97a2f9b42cdc0149:

  flow: fix hang with flow control and zoned block devices (2020-12-07 16:56:37 -0700)

----------------------------------------------------------------
Aravind Ramesh (1):
      flow: fix hang with flow control and zoned block devices

Jens Axboe (1):
      Merge branch 'reword-toolarge' of https://github.com/sitsofe/fio

Sitsofe Wheeler (1):
      filesetup: reword block size too large message

 filesetup.c | 2 +-
 flow.c      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 42c5f630..d3c370ca 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1199,7 +1199,7 @@ int setup_files(struct thread_data *td)
 		o->size = total_size;
 
 	if (o->size < td_min_bs(td)) {
-		log_err("fio: blocksize too large for data set\n");
+		log_err("fio: blocksize is larger than data set range\n");
 		goto err_out;
 	}
 
diff --git a/flow.c b/flow.c
index ea6b0ec9..c64bb3b2 100644
--- a/flow.c
+++ b/flow.c
@@ -37,6 +37,8 @@ int flow_threshold_exceeded(struct thread_data *td)
 		if (td->o.flow_sleep) {
 			io_u_quiesce(td);
 			usleep(td->o.flow_sleep);
+		} else if (td->o.zone_mode == ZONE_MODE_ZBD) {
+			io_u_quiesce(td);
 		}
 
 		return 1;

