Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57748 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfJBMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Oct 2019 08:00:12 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iFdIi-00084o-Kf
        for fio@vger.kernel.org; Wed, 02 Oct 2019 12:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191002120001.5F8A02C0145@kernel.dk>
Date: Wed,  2 Oct 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e2defc22798dcd884356fbbaf8856689839b52e5:

  configure: add --enable-libaio-uring parameter (2019-09-27 13:51:12 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f95183e40c5d48cd119d3fbcd752b70c39c97683:

  Update the email and web address for Windows binaries. (2019-10-01 21:34:18 -0600)

----------------------------------------------------------------
Rebecca Cran (1):
      Update the email and web address for Windows binaries.

 README | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/README b/README
index 38022bbb..7c65906d 100644
--- a/README
+++ b/README
@@ -119,8 +119,8 @@ Solaris:
 	``pkgutil -i fio``.
 
 Windows:
-	Rebecca Cran <rebecca+fio@bluestop.org> has fio packages for Windows at
-	https://www.bluestop.org/fio/ . The latest builds for Windows can also
+	Rebecca Cran <rebecca@bsdio.com> has fio packages for Windows at
+	https://bsdio.com/fio/ . The latest builds for Windows can also
 	be grabbed from https://ci.appveyor.com/project/axboe/fio by clicking
 	the latest x86 or x64 build, then selecting the ARTIFACTS tab.
 

