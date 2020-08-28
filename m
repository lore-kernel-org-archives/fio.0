Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729171AbgH1MAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Aug 2020 08:00:06 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F85C061264
        for <fio@vger.kernel.org>; Fri, 28 Aug 2020 05:00:05 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBd35-0000Ol-HL
        for fio@vger.kernel.org; Fri, 28 Aug 2020 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200828120002.2BD281BC0047@kernel.dk>
Date: Fri, 28 Aug 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 84106576cefbbd9f5dfa5ee33b245f77938d0269:

  t/io_uring: cleanup vectored vs non-vectored (2020-08-22 11:26:39 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0ed7d55e6610020c4642ddb246f6ce1ab697052d:

  zbd: don't read past the WP on a read only workload with verify (2020-08-27 12:27:36 -0600)

----------------------------------------------------------------
Aravind Ramesh (1):
      zbd: don't read past the WP on a read only workload with verify

 zbd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/zbd.c b/zbd.c
index 5af8af4a..584d3640 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1467,9 +1467,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
-		if (td->runstate == TD_VERIFYING) {
-			if (td_write(td))
-				zb = zbd_replay_write_order(td, io_u, zb);
+		if (td->runstate == TD_VERIFYING && td_write(td)) {
+			zb = zbd_replay_write_order(td, io_u, zb);
 			goto accept;
 		}
 		/*

