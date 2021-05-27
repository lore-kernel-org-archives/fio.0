Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbhE0MBt (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 May 2021 08:01:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD72AC061574
        for <fio@vger.kernel.org>; Thu, 27 May 2021 05:00:16 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lmEgG-005UuI-CB
        for fio@vger.kernel.org; Thu, 27 May 2021 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210527120001.E36E21BC0166@kernel.dk>
Date: Thu, 27 May 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c91fd13d479dc38bbb7ef6995256ad098ebbceb2:

  Merge branch 'master' of https://github.com/DevriesL/fio (2021-05-25 16:54:13 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0313e938c9c8bb37d71dade239f1f5326677b079:

  Fio 3.27 (2021-05-26 10:10:32 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.27

 FIO-VERSION-GEN | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 29486071..47af94e9 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.26
+DEF_VER=fio-3.27
 
 LF='
 '

