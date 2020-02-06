Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54580 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgBFNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Feb 2020 08:00:05 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1izglJ-0000aX-0L
        for fio@vger.kernel.org; Thu, 06 Feb 2020 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200206130001.C49091BC016D@kernel.dk>
Date: Thu,  6 Feb 2020 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f4cd67d8dc96ca947b294f6a5c9fdced2b64215d:

  Merge branch 'latency-rebase-again' of https://github.com/vincentkfu/fio (2020-02-04 10:05:09 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ac694f66968fe7b18c820468abd8333f3df333fb:

  Fio 3.18 (2020-02-05 07:59:58 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.18

 FIO-VERSION-GEN | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 13ce8c16..6c2bcc8a 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.17
+DEF_VER=fio-3.18
 
 LF='
 '

