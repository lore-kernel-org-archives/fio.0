Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgGUMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Jul 2020 08:00:07 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B28C061794
        for <fio@vger.kernel.org>; Tue, 21 Jul 2020 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxqwG-0006HT-Or
        for fio@vger.kernel.org; Tue, 21 Jul 2020 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200721120001.BBF3B1BC01AA@kernel.dk>
Date: Tue, 21 Jul 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fa443634fbfa38fd5d6418a96a45022c78b90df4:

  Merge branch 'patch-1' of https://github.com/avlasov-mos-de/fio (2020-07-18 08:39:04 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d13596b225baf61425a9ca92b0583fc3fa97765d:

  Fio 3.21 (2020-07-20 16:37:50 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.21

 FIO-VERSION-GEN | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 7050f84e..48e575fc 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.20
+DEF_VER=fio-3.21
 
 LF='
 '

