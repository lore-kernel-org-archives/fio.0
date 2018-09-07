Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40250 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728172AbeIGQlF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 7 Sep 2018 12:41:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fyFR6-0005OU-6p
        for fio@vger.kernel.org; Fri, 07 Sep 2018 12:00:28 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180907120002.0DE352C00A8@kernel.dk>
Date: Fri,  7 Sep 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f111f76c0e6687c0cc6fc562cb902e4a64e42b37:

  Merge branch 'master' of https://github.com/damien-lemoal/fio (2018-09-05 19:25:39 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bb661c4027e5a0482b9fcc1c1b4e7e918650ee72:

  Fio 3.9 (2018-09-06 09:07:55 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.9

 FIO-VERSION-GEN | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 99261fb..f031594 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.8
+DEF_VER=fio-3.9
 
 LF='
 '

