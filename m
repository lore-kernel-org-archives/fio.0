Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49000 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbbGQMAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 Jul 2015 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZG4JD-0000OZ-EY
	for fio@vger.kernel.org; Fri, 17 Jul 2015 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150717120001.8258F2C00B7@kernel.dk>
Date: Fri, 17 Jul 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit adaa73f65a8b805dced0b017984d536f215e4353:

  README: no delay on sync to backup git hosts anymore (2015-07-15 08:43:03 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1520f26e713a2fded6728ad372af0d7b8c197adf:

  Re-seed random generator correctly between loops (2015-07-16 14:56:00 -0600)

----------------------------------------------------------------
Dave (1):
      Re-seed random generator correctly between loops

 libfio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/libfio.c b/libfio.c
index 3a28f55..30a3acb 100644
--- a/libfio.c
+++ b/libfio.c
@@ -116,9 +116,10 @@ void clear_io_state(struct thread_data *td)
 	}
 
 	/*
-	 * Set the same seed to get repeatable runs
+	 * Re-Seed random number generator if rand_repeatable is true
 	 */
-	td_fill_rand_seeds(td);
+	if (td->o.rand_repeatable)
+		td_fill_rand_seeds(td);
 }
 
 void reset_all_stats(struct thread_data *td)
