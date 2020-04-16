Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2634642AbgDPMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Apr 2020 08:00:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAA0C061A0C
        for <fio@vger.kernel.org>; Thu, 16 Apr 2020 05:00:03 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jP3Bb-00029a-MJ
        for fio@vger.kernel.org; Thu, 16 Apr 2020 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200416120002.1786B1BC0181@kernel.dk>
Date: Thu, 16 Apr 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 25dc6606fbbaca35aec3009c4ff9512ed02d41ba:

  zbd: fix sequential write pattern with verify= and max_open_zones= (2020-04-13 17:18:31 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f5501dd2e466e53cd606e304f1cb6b0a49b481dc:

  Merge branch 'appveyor-artifacts' of https://github.com/vincentkfu/fio (2020-04-15 08:29:01 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'appveyor-artifacts' of https://github.com/vincentkfu/fio

Vincent Fu (1):
      appveyor: make test artifacts available for inspection

 .appveyor.yml | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
index 2f962c4b..e2351be7 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -25,8 +25,11 @@ after_build:
 
 test_script:
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && file.exe fio.exe && make.exe test'
-  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && python.exe t/run-fio-tests.py --debug'
+  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && [ -f fio.exe ] && python.exe t/run-fio-tests.py --artifact-root test-artifacts --debug'
+  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && [ -d test-artifacts ] && 7z a -t7z test-artifacts.7z test-artifacts -xr!foo.0.0 -xr!latency.?.0 -xr!fio_jsonplus_clat2csv.test'
 
 artifacts:
   - path: os\windows\*.msi
     name: msi
+  - path: test-artifacts.7z
+    name: test-artifacts

