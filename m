Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46206 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752385AbeDSMAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 19 Apr 2018 08:00:14 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1f98EX-0004e0-UB
        for fio@vger.kernel.org; Thu, 19 Apr 2018 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180419120001.E2C5A2C00EE@kernel.dk>
Date: Thu, 19 Apr 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f31feaa21642929b6d9d5396b73669372fda9a0a:

  Deprecate verifysort and verifysort_nr (2018-04-17 21:50:55 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6897af4622fec753b5b76a4f2f7865dd56550ea4:

  Remove verifysort/verifysort_nr from documentation (2018-04-18 10:52:00 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      iolog: update stale comment
      Remove verifysort/verifysort_nr from documentation

 HOWTO   | 12 ------------
 fio.1   | 10 ----------
 iolog.c |  6 +-----
 3 files changed, 1 insertion(+), 27 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index c34fdf3..8ee00fd 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2635,18 +2635,6 @@ Verification
 	previously written file. If the data direction includes any form of write,
 	the verify will be of the newly written data.
 
-.. option:: verifysort=bool
-
-	If true, fio will sort written verify blocks when it deems it faster to read
-	them back in a sorted manner. This is often the case when overwriting an
-	existing file, since the blocks are already laid out in the file system. You
-	can ignore this option unless doing huge amounts of really fast I/O where
-	the red-black tree sorting CPU time becomes significant. Default: true.
-
-.. option:: verifysort_nr=int
-
-	Pre-load and sort verify blocks for a read workload.
-
 .. option:: verify_offset=int
 
 	Swap the verification header with data somewhere else in the block before
diff --git a/fio.1 b/fio.1
index 9264855..24bdcdb 100644
--- a/fio.1
+++ b/fio.1
@@ -2340,16 +2340,6 @@ previously written file. If the data direction includes any form of write,
 the verify will be of the newly written data.
 .RE
 .TP
-.BI verifysort \fR=\fPbool
-If true, fio will sort written verify blocks when it deems it faster to read
-them back in a sorted manner. This is often the case when overwriting an
-existing file, since the blocks are already laid out in the file system. You
-can ignore this option unless doing huge amounts of really fast I/O where
-the red\-black tree sorting CPU time becomes significant. Default: true.
-.TP
-.BI verifysort_nr \fR=\fPint
-Pre\-load and sort verify blocks for a read workload.
-.TP
 .BI verify_offset \fR=\fPint
 Swap the verification header with data somewhere else in the block before
 writing. It is swapped back before verifying.
diff --git a/iolog.c b/iolog.c
index 598548d..74c89f0 100644
--- a/iolog.c
+++ b/iolog.c
@@ -227,11 +227,7 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 	}
 
 	/*
-	 * We don't need to sort the entries if we only performed sequential
-	 * writes. In this case, just reading back data in the order we wrote
-	 * it out is the faster but still safe.
-	 *
-	 * One exception is if we don't have a random map in which case we need
+	 * Only sort writes if we don't have a random map in which case we need
 	 * to check for duplicate blocks and drop the old one, which we rely on
 	 * the rb insert/lookup for handling.
 	 */
