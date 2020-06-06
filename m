Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgFFMAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 6 Jun 2020 08:00:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0E3C03E96A
        for <fio@vger.kernel.org>; Sat,  6 Jun 2020 05:00:14 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jhXUf-0004Jd-75
        for fio@vger.kernel.org; Sat, 06 Jun 2020 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200606120001.C5BC61BC017A@kernel.dk>
Date: Sat,  6 Jun 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 00ca8df5468e90bbf1256ec90fc9ae14b1706ccc:

  zbd: Fix max_open_zones checks (2020-06-03 20:15:35 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 08541925ec1b5887fc91e59a4bc253d54757c4c6:

  Makefile: include linux-blkzoned.c for Android, if set (2020-06-05 07:06:46 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Makefile: include linux-blkzoned.c for Android, if set

 Makefile | 3 +++
 1 file changed, 3 insertions(+)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index e3962195..7eb5e899 100644
--- a/Makefile
+++ b/Makefile
@@ -176,6 +176,9 @@ endif
 ifeq ($(CONFIG_TARGET_OS), Android)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c profiles/tiobench.c \
 		oslib/linux-dev-lookup.c
+ifdef CONFIG_HAS_BLKZONED
+  SOURCE += oslib/linux-blkzoned.c
+endif
   LIBS += -ldl -llog
   LDFLAGS += -rdynamic
 endif

