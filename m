Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42754 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751920AbdI2MAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Sep 2017 08:00:12 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dxtxk-0001oC-95
        for fio@vger.kernel.org; Fri, 29 Sep 2017 12:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170929120002.52F2E2C0111@kernel.dk>
Date: Fri, 29 Sep 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b6b662b64c70bf043bbafd654f9bf98513ea5dc9:

  Fio 3.1 (2017-09-28 04:23:20 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c16035aadd600a3a4c4b241339e3d3099f56c4b2:

  backend: fix a case where we complain about no IO being done (2017-09-28 06:58:23 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      backend: fix a case where we complain about no IO being done

 backend.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 6198c3d..e4eff37 100644
--- a/backend.c
+++ b/backend.c
@@ -1505,7 +1505,7 @@ static void *thread_main(void *data)
 	struct sk_out *sk_out = fd->sk_out;
 	uint64_t bytes_done[DDIR_RWDIR_CNT];
 	int deadlock_loop_cnt;
-	int clear_state;
+	bool clear_state, did_some_io;
 	int ret;
 
 	sk_out_assign(sk_out);
@@ -1726,7 +1726,8 @@ static void *thread_main(void *data)
 	}
 
 	memset(bytes_done, 0, sizeof(bytes_done));
-	clear_state = 0;
+	clear_state = false;
+	did_some_io = false;
 
 	while (keep_running(td)) {
 		uint64_t verify_bytes;
@@ -1765,7 +1766,7 @@ static void *thread_main(void *data)
 		if (td->runstate >= TD_EXITED)
 			break;
 
-		clear_state = 1;
+		clear_state = true;
 
 		/*
 		 * Make sure we've successfully updated the rusage stats
@@ -1804,6 +1805,9 @@ static void *thread_main(void *data)
 		    td_ioengine_flagged(td, FIO_UNIDIR))
 			continue;
 
+		if (ddir_rw_sum(bytes_done))
+			did_some_io = true;
+
 		clear_io_state(td, 0);
 
 		fio_gettime(&td->start, NULL);
@@ -1830,6 +1834,7 @@ static void *thread_main(void *data)
 	 * (Are we not missing other flags that can be ignored ?)
 	 */
 	if ((td->o.size || td->o.io_size) && !ddir_rw_sum(bytes_done) &&
+	    !did_some_io &&
 	    !(td_ioengine_flagged(td, FIO_NOIO) ||
 	      td_ioengine_flagged(td, FIO_DISKLESSIO)))
 		log_err("%s: No I/O performed by %s, "
