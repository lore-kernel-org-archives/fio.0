Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36604 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbcFNMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Jun 2016 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1bCn0k-0000wI-Kq
	for fio@vger.kernel.org; Tue, 14 Jun 2016 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160614120001.DC2812C00A7@kernel.dk>
Date: Tue, 14 Jun 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2b7625e25e32783272b8e6ffbc1546fa50b9386c:

  iolog: fix 'cur_log' leaks (2016-06-11 21:41:13 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bccdc0d0c9d41749515131226aab71baa59e03cd:

  Fio 2.12 (2016-06-13 15:42:44 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      stat: treat !per_unit_logs() like IO offload mode
      Fio 2.12

 FIO-VERSION-GEN        |  2 +-
 os/windows/install.wxs |  2 +-
 stat.c                 | 11 +++++++----
 3 files changed, 9 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index ea65ea8..04802dd 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.11
+DEF_VER=fio-2.12
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 45084e6..1e8022d 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.11">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.12">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/stat.c b/stat.c
index 26d8d53..e0e97cd 100644
--- a/stat.c
+++ b/stat.c
@@ -1983,11 +1983,14 @@ static struct io_logs *get_cur_log(struct io_log *iolog)
 		return cur_log;
 
 	/*
-	 * Out of space. If we're in IO offload mode, add a new log chunk
-	 * inline. If we're doing inline submissions, flag 'td' as needing
-	 * a log regrow and we'll take care of it on the submission side.
+	 * Out of space. If we're in IO offload mode, or we're not doing
+	 * per unit logging (hence logging happens outside of the IO thread
+	 * as well), add a new log chunk inline. If we're doing inline
+	 * submissions, flag 'td' as needing a log regrow and we'll take
+	 * care of it on the submission side.
 	 */
-	if (iolog->td->o.io_submit_mode == IO_MODE_OFFLOAD)
+	if (iolog->td->o.io_submit_mode == IO_MODE_OFFLOAD ||
+	    !per_unit_log(iolog))
 		return regrow_log(iolog);
 
 	iolog->td->flags |= TD_F_REGROW_LOGS;
