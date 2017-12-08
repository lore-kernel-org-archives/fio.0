Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53455 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752990AbdLHNAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 8 Dec 2017 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eNIG6-0004p8-Cl
        for fio@vger.kernel.org; Fri, 08 Dec 2017 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171208130002.8A22D2C00A1@kernel.dk>
Date: Fri,  8 Dec 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 395feabb53806d5cff2e0b73b6c94048f05b5aae:

  io_u: rate cleanup and spelling error (2017-12-06 12:30:20 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1aa39b0ce447f228460e6d0af601fee88fd5f4b4:

  rate: ensure IO issue restarts right after sleep (2017-12-07 09:06:04 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      rate: ensure IO issue restarts right after sleep

 backend.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 69f03dc..5304ddc 100644
--- a/backend.c
+++ b/backend.c
@@ -894,10 +894,13 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir)
 
 	/*
 	 * If we're ignoring thinktime for the rate, add the number of bytes
-	 * we would have done while sleeping.
+	 * we would have done while sleeping, minus one block to ensure we
+	 * start issuing immediately after the sleep.
 	 */
-	if (total && td->rate_bps[ddir] && td->o.rate_ign_think)
+	if (total && td->rate_bps[ddir] && td->o.rate_ign_think) {
 		td->rate_io_issue_bytes[ddir] += (td->rate_bps[ddir] * 1000000) / total;
+		td->rate_io_issue_bytes[ddir] -= td->o.min_bs[ddir];
+	}
 }
 
 /*
