Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40416 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbcBFNAJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 6 Feb 2016 08:00:09 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aS2T5-00005J-Er
	for fio@vger.kernel.org; Sat, 06 Feb 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160206130002.40CFC2C2157@kernel.dk>
Date: Sat,  6 Feb 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e6989e10964f5ae30e0ba8f0cd27a663baf5617b:

  log: add support for logging max instead of averages (2016-02-04 12:09:48 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 820ba1f9c31bbe92e9b8f71d587907819919c0f8:

  io_ddir: io_ddir_name array should be static (2016-02-05 08:42:26 -0700)

----------------------------------------------------------------
Andrey Kuzmin (1):
      fio: fix copy/paste error in io_ddir.h

Jens Axboe (1):
      io_ddir: io_ddir_name array should be static

 io_ddir.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/io_ddir.h b/io_ddir.h
index e5eff68..763e826 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -16,8 +16,9 @@ enum fio_ddir {
 
 static inline const char *io_ddir_name(enum fio_ddir ddir)
 {
-	const char *name[] = { "read", "write", "trim", "sync", "datasync",
-				"sync_file_range", "write", };
+	static const char *name[] = { "read", "write", "trim", "sync",
+					"datasync", "sync_file_range",
+					"wait", };
 
 	if (ddir < DDIR_LAST)
 		return name[ddir];
