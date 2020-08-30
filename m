Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgH3MAh (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 30 Aug 2020 08:00:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0932DC061573
        for <fio@vger.kernel.org>; Sun, 30 Aug 2020 05:00:37 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCM0g-00036L-3l
        for fio@vger.kernel.org; Sun, 30 Aug 2020 12:00:34 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200830120002.5FB181BC0042@kernel.dk>
Date: Sun, 30 Aug 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit db83b0abd16bbd6b8f589a993e6f70d9812be6e3:

  Use fallthrough attribute (2020-08-28 09:14:38 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e68470637ae7c03d5f85a9243e148d7c46ad4487:

  Update the year to 2020 in os/windows/eula.rtf (2020-08-29 18:54:17 -0600)

----------------------------------------------------------------
Rebecca Cran (2):
      Update os/windows/dobuild.cmd to support signing binaries/installer
      Update the year to 2020 in os/windows/eula.rtf

 os/windows/dobuild.cmd |  12 ++++++++++++
 os/windows/eula.rtf    | Bin 1077 -> 1075 bytes
 2 files changed, 12 insertions(+)

---

Diff of recent changes:

diff --git a/os/windows/dobuild.cmd b/os/windows/dobuild.cmd
index ef12d82d..d06a2afa 100644
--- a/os/windows/dobuild.cmd
+++ b/os/windows/dobuild.cmd
@@ -26,9 +26,21 @@ if not defined FIO_ARCH (
   goto end
 )
 
+if defined SIGN_FIO (
+  signtool sign /n "%SIGNING_CN%" /t http://timestamp.digicert.com ..\..\fio.exe
+  signtool sign /as /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /td sha256 /fd sha256 ..\..\fio.exe
+
+  signtool sign /n "%SIGNING_CN%" /t http://timestamp.digicert.com ..\..\t\*.exe
+  signtool sign /as /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /td sha256 /fd sha256 ..\..\t\*.exe
+)
+
 "%WIX%bin\candle" -nologo -arch %FIO_ARCH% -dFioVersionNumbers="%FIO_VERSION_NUMBERS%" install.wxs
 @if ERRORLEVEL 1 goto end
 "%WIX%bin\candle" -nologo -arch %FIO_ARCH% examples.wxs
 @if ERRORLEVEL 1 goto end
 "%WIX%bin\light" -nologo -sice:ICE61 install.wixobj examples.wixobj -ext WixUIExtension -out %FIO_VERSION%-%FIO_ARCH%.msi
 :end
+
+if defined SIGN_FIO (
+  signtool sign /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /td sha256 /fd sha256 %FIO_VERSION%-%FIO_ARCH%.msi
+)
\ No newline at end of file
diff --git a/os/windows/eula.rtf b/os/windows/eula.rtf
index 01472be9..a931017c 100755
Binary files a/os/windows/eula.rtf and b/os/windows/eula.rtf differ

