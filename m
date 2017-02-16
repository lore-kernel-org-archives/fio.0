Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42280 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754441AbdBPNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Feb 2017 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1ceLfK-0005G4-VV
        for fio@vger.kernel.org; Thu, 16 Feb 2017 13:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170216130002.6CEB62C0218@kernel.dk>
Date: Thu, 16 Feb 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c1f50f765a0a51931605c1fb223d166e3b3a93c6:

  Use 0 instead of DDIR_READ to iterate from 0 to DDIR_RWDIR_CNT (2017-02-14 08:24:24 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5c8e84cab3bca39de54a69092473f000f8a57f40:

  Explicitly check td_trim(td) for the direction of next io_u (2017-02-15 13:52:24 -0700)

----------------------------------------------------------------
Tomohiro Kusumi (2):
      Drop obsolete comment on a race condition
      Explicitly check td_trim(td) for the direction of next io_u

 filesetup.c | 3 ---
 io_u.c      | 4 +++-
 2 files changed, 3 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 3fa8b32..e9976eb 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -500,9 +500,6 @@ int file_lookup_open(struct fio_file *f, int flags)
 	__f = lookup_file_hash(f->file_name);
 	if (__f) {
 		dprint(FD_FILE, "found file in hash %s\n", f->file_name);
-		/*
-		 * racy, need the __f->lock locked
-		 */
 		f->lock = __f->lock;
 		from_hash = 1;
 	} else {
diff --git a/io_u.c b/io_u.c
index f1a3916..69bec4b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -758,8 +758,10 @@ static enum fio_ddir get_rw_ddir(struct thread_data *td)
 		ddir = DDIR_READ;
 	else if (td_write(td))
 		ddir = DDIR_WRITE;
-	else
+	else if (td_trim(td))
 		ddir = DDIR_TRIM;
+	else
+		ddir = DDIR_INVAL;
 
 	td->rwmix_ddir = rate_ddir(td, ddir);
 	return td->rwmix_ddir;
