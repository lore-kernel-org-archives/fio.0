Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49474 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751687AbeFBMAS (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 2 Jun 2018 08:00:18 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fP5Cj-00031z-Lg
        for fio@vger.kernel.org; Sat, 02 Jun 2018 12:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180602120001.912AB2C0311@kernel.dk>
Date: Sat,  2 Jun 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 80f021501fda6a6244672bb89dd8221a61cee54b:

  io_u: ensure to invalidate cache on time_based random reads (2018-05-31 09:05:59 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c397ab3aac3d4ed1660d9cd4d820f31a4375306e:

  Fio 3.7 (2018-06-01 13:21:56 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.7

 FIO-VERSION-GEN | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index d2d095b..b28a1f3 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.6
+DEF_VER=fio-3.7
 
 LF='
 '
