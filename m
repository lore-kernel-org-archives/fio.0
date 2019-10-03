Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50870 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfJCMAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Oct 2019 08:00:15 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iFzmI-0006W4-D7
        for fio@vger.kernel.org; Thu, 03 Oct 2019 12:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191003120002.48CDA2C28B2@kernel.dk>
Date: Thu,  3 Oct 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f95183e40c5d48cd119d3fbcd752b70c39c97683:

  Update the email and web address for Windows binaries. (2019-10-01 21:34:18 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 13e9c0b09c0c8d892b790aeaf736263dd76f2d2e:

  Windows: Update URLs to https, and remove mention of WiX version (2019-10-02 08:23:19 -0600)

----------------------------------------------------------------
Rebecca Cran (1):
      Windows: Update URLs to https, and remove mention of WiX version

 README | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/README b/README
index 7c65906d..0f943bcc 100644
--- a/README
+++ b/README
@@ -164,9 +164,9 @@ configure.
 Windows
 ~~~~~~~
 
-On Windows, Cygwin (http://www.cygwin.com/) is required in order to build
-fio. To create an MSI installer package install WiX 3.8 from
-http://wixtoolset.org and run :file:`dobuild.cmd` from the :file:`os/windows`
+On Windows, Cygwin (https://www.cygwin.com/) is required in order to build
+fio. To create an MSI installer package install WiX from
+https://wixtoolset.org and run :file:`dobuild.cmd` from the :file:`os/windows`
 directory.
 
 How to compile fio on 64-bit Windows:

