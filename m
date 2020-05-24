Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50976 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgEXMCX (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 24 May 2020 08:02:23 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcpIa-0002Gc-9J
        for fio@vger.kernel.org; Sun, 24 May 2020 12:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200524120003.13ADB1BC018D@kernel.dk>
Date: Sun, 24 May 2020 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1bb1bcade4acbd3cf69ba1c825ad01eebf0b3cdf:

  zbd: make zbd_info->mutex non-recursive (2020-05-21 17:23:13 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d51e4ffa596b617cdb41680b31a4a3895a5307fc:

  Fio 3.20 (2020-05-23 11:14:14 -0600)

----------------------------------------------------------------
Fabrice Fontaine (1):
      Makefile: fix build of io_uring on sh4

Jens Axboe (2):
      Merge branch 'master' of https://github.com/ffontaine/fio
      Fio 3.20

 FIO-VERSION-GEN | 2 +-
 Makefile        | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 3220aaa1..7050f84e 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.19
+DEF_VER=fio-3.20
 
 LF='
 '
diff --git a/Makefile b/Makefile
index f1e984f5..e3962195 100644
--- a/Makefile
+++ b/Makefile
@@ -283,6 +283,7 @@ T_PIPE_ASYNC_OBJS = t/read-to-pipe-async.o
 T_PIPE_ASYNC_PROGS = t/read-to-pipe-async
 
 T_IOU_RING_OBJS = t/io_uring.o
+T_IOU_RING_OBJS += t/arch.o
 T_IOU_RING_PROGS = t/io_uring
 
 T_MEMLOCK_OBJS = t/memlock.o

