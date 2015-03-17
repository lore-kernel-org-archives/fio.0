Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbbCQMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 17 Mar 2015 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YXqAH-0006mE-2O
	for fio@vger.kernel.org; Tue, 17 Mar 2015 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150317120003.8580740188@lyth.info>
Date: Tue, 17 Mar 2015 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 85492cb89e2421ae71d92b1c88e75efda3ee1f1b:

  smalloc: bump initial size to 8 pools (2015-03-03 15:13:17 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 95e564523d502e5a682ae7f6ee793ca4c9ca76ca:

  rate: remove redundant code in rate_ddir() (2015-03-12 10:05:25 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      rate: remove redundant code in rate_ddir()

 io_u.c |    3 ---
 1 file changed, 3 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index f61fee8..6567e10 100644
--- a/io_u.c
+++ b/io_u.c
@@ -590,9 +590,6 @@ static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
 	if (td_rw(td) && __should_check_rate(td, odir))
 		td->rate_pending_usleep[odir] -= usec;
 
-	if (ddir == DDIR_TRIM)
-		return DDIR_TRIM;
-
 	return ddir;
 }
 
