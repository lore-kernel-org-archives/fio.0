Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33800 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgANNAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Jan 2020 08:00:17 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irLnt-0003nv-DS
        for fio@vger.kernel.org; Tue, 14 Jan 2020 13:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200114130001.D538C1BC0CAC@kernel.dk>
Date: Tue, 14 Jan 2020 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b7ed2a862ddafa7dbaa6299ee8633b6f8221e283:

  io_uring: set sqe iopriority, if prio/prioclass is set (2020-01-09 14:58:51 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7eff05d723d1330a5407b2bdd9145f1bfb6dd0e1:

  time: limit usec_sleep() to maximum intervals of 1 second (2020-01-13 14:51:35 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      time: limit usec_sleep() to maximum intervals of 1 second

 time.c | 7 +++++++
 1 file changed, 7 insertions(+)

---

Diff of recent changes:

diff --git a/time.c b/time.c
index 19999699..cd0e2a89 100644
--- a/time.c
+++ b/time.c
@@ -57,6 +57,13 @@ uint64_t usec_sleep(struct thread_data *td, unsigned long usec)
 		if (ts >= 1000000) {
 			req.tv_sec = ts / 1000000;
 			ts -= 1000000 * req.tv_sec;
+			/*
+			 * Limit sleep to ~1 second at most, otherwise we
+			 * don't notice then someone signaled the job to
+			 * exit manually.
+			 */
+			if (req.tv_sec > 1)
+				req.tv_sec = 1;
 		} else
 			req.tv_sec = 0;
 

