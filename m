Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59744 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933161AbcKMNAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Nov 2016 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c5uOB-0000lw-P9
        for fio@vger.kernel.org; Sun, 13 Nov 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161113130001.89A332C008C@kernel.dk>
Date: Sun, 13 Nov 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4e7a881493790a3a2b970988aef4bd3603877fab:

  Fix duplicated typos from 42d97b5c in fio(1) (2016-11-02 08:05:49 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 206c546d6015fe3809b8e52ea95f56114b8e9f25:

  rbd: fix crash with zero sized image (2016-11-12 08:36:23 -0700)

----------------------------------------------------------------
Pan Liu (1):
      rbd: fix crash with zero sized image

 engines/rbd.c | 5 +++++
 1 file changed, 5 insertions(+)

---

Diff of recent changes:

diff --git a/engines/rbd.c b/engines/rbd.c
index aa50c80..ee2ce81 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -595,7 +595,12 @@ static int fio_rbd_setup(struct thread_data *td)
 	if (r < 0) {
 		log_err("rbd_status failed.\n");
 		goto disconnect;
+	} else if (info.size == 0) {
+		log_err("image size should be larger than zero.\n");
+		r = -EINVAL;
+		goto disconnect;
 	}
+
 	dprint(FD_IO, "rbd-engine: image size: %lu\n", info.size);
 
 	/* taken from "net" engine. Pretend we deal with files,
