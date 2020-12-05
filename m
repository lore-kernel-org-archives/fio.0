Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgLENBR (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 5 Dec 2020 08:01:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC32C0613D1
        for <fio@vger.kernel.org>; Sat,  5 Dec 2020 05:00:06 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klXAS-0005mU-NH
        for fio@vger.kernel.org; Sat, 05 Dec 2020 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201205130001.7847B1BC0124@kernel.dk>
Date: Sat,  5 Dec 2020 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f9eb98cba4cfc5351bace61c21eda67fb625266b:

  Merge branch 'stat-int-creep3' of https://github.com/jeffreyalien/fio (2020-12-03 16:09:43 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fd80924b22fef6ce0d5580724d91490347445f90:

  Fio 3.25 (2020-12-04 11:47:42 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.25

 FIO-VERSION-GEN | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 86ea0c5d..81a6355b 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.24
+DEF_VER=fio-3.25
 
 LF='
 '

