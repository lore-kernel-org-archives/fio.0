Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40044 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730317AbfJHMAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Oct 2019 08:00:13 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHoA0-00007P-2I
        for fio@vger.kernel.org; Tue, 08 Oct 2019 12:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191008120001.6BEFE2C086D@kernel.dk>
Date: Tue,  8 Oct 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 58d68a0dad21fb8aed34bb987e00b9b7dee65296:

  Merge branch 'error-on-implicit-decl' of https://github.com/sitsofe/fio (2019-10-06 09:15:51 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 998baa29f571df9d2e4b626bedd317a2fd28c68a:

  Merge branch 'replay-blktrace-fixes' of https://github.com/shimrot/fio (2019-10-07 21:23:26 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'replay-blktrace-fixes' of https://github.com/shimrot/fio

krisd (1):
      Fix assert error on blktrace replay containing trims

 blktrace.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/blktrace.c b/blktrace.c
index efe9ce24..8a246613 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -544,16 +544,19 @@ bool load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 	    !ios[DDIR_SYNC]) {
 		log_err("fio: found no ios in blktrace data\n");
 		return false;
-	} else if (ios[DDIR_READ] && !ios[DDIR_WRITE]) {
-		td->o.td_ddir = TD_DDIR_READ;
-		td->o.max_bs[DDIR_READ] = rw_bs[DDIR_READ];
-	} else if (!ios[DDIR_READ] && ios[DDIR_WRITE]) {
-		td->o.td_ddir = TD_DDIR_WRITE;
-		td->o.max_bs[DDIR_WRITE] = rw_bs[DDIR_WRITE];
-	} else {
-		td->o.td_ddir = TD_DDIR_RW;
+	}
+
+	td->o.td_ddir = 0;
+	if (ios[DDIR_READ]) {
+		td->o.td_ddir |= TD_DDIR_READ;
 		td->o.max_bs[DDIR_READ] = rw_bs[DDIR_READ];
+	}
+	if (ios[DDIR_WRITE]) {
+		td->o.td_ddir |= TD_DDIR_WRITE;
 		td->o.max_bs[DDIR_WRITE] = rw_bs[DDIR_WRITE];
+	}
+	if (ios[DDIR_TRIM]) {
+		td->o.td_ddir |= TD_DDIR_TRIM;
 		td->o.max_bs[DDIR_TRIM] = rw_bs[DDIR_TRIM];
 	}
 

