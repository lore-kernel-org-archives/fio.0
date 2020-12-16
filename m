Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgLPNAq (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 16 Dec 2020 08:00:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2609C061794
        for <fio@vger.kernel.org>; Wed, 16 Dec 2020 05:00:05 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kpWPU-0004wz-2o
        for fio@vger.kernel.org; Wed, 16 Dec 2020 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201216130001.B88701BC0148@kernel.dk>
Date: Wed, 16 Dec 2020 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 731365d849407426fe32981c97a2f9b42cdc0149:

  flow: fix hang with flow control and zoned block devices (2020-12-07 16:56:37 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dee9b29bef5bc344815d7a53dda6bb21426f2bfa:

  Merge branch 'wip-rbd-engine-tweaks' of https://github.com/dillaman/fio (2020-12-15 09:18:28 -0700)

----------------------------------------------------------------
Jason Dillaman (2):
      engines/rbd: add support for "direct=1" option
      engines/rbd: issue initial flush to enable writeback/around mode

Jens Axboe (1):
      Merge branch 'wip-rbd-engine-tweaks' of https://github.com/dillaman/fio

 engines/rbd.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

---

Diff of recent changes:

diff --git a/engines/rbd.c b/engines/rbd.c
index 268b6ebd..c6203d4c 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -227,12 +227,30 @@ static int _fio_rbd_connect(struct thread_data *td)
 		goto failed_shutdown;
 	}
 
+        if (td->o.odirect) {
+		r = rados_conf_set(rbd->cluster, "rbd_cache", "false");
+		if (r < 0) {
+			log_info("failed to disable RBD in-memory cache\n");
+		}
+	}
+
 	r = rbd_open(rbd->io_ctx, o->rbd_name, &rbd->image, NULL /*snap */ );
 	if (r < 0) {
 		log_err("rbd_open failed.\n");
 		goto failed_open;
 	}
 
+	if (!td->o.odirect) {
+		/*
+		 * ensure cache enables writeback/around mode unless explicitly
+		 * configured for writethrough mode
+		 */
+		r = rbd_flush(rbd->image);
+		if (r < 0) {
+			log_info("rbd: failed to issue initial flush\n");
+		}
+	}
+
 	if (!_fio_rbd_setup_poll(rbd))
 		goto failed_poll;
 

