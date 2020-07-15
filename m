Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgGOMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Jul 2020 08:00:07 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BC1C061755
        for <fio@vger.kernel.org>; Wed, 15 Jul 2020 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvg4z-000535-4W
        for fio@vger.kernel.org; Wed, 15 Jul 2020 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200715120002.0779D1BC019B@kernel.dk>
Date: Wed, 15 Jul 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 255f09d6d266c3e73abb9776ae481bb4d79caf00:

  Merge branch 'io_uring-opt' of https://github.com/antonblanchard/fio (2020-07-13 08:01:52 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 37e8cc62319b30927a3147e25b16c3e00b84692f:

  Merge branch 'fix_devdax' of https://github.com/harish-24/fio (2020-07-14 10:10:23 -0600)

----------------------------------------------------------------
Harish (1):
      Fix: dev-dax engine building with make

Jens Axboe (1):
      Merge branch 'fix_devdax' of https://github.com/harish-24/fio

 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 8f8d9b9a..f374ac84 100644
--- a/Makefile
+++ b/Makefile
@@ -173,8 +173,8 @@ ifdef CONFIG_PMEMBLK
   ENGINES += pmemblk
 endif
 ifdef CONFIG_LINUX_DEVDAX
-  devdax_SRCS = engines/dev-dax.c
-  devdax_LIBS = -lpmem
+  dev-dax_SRCS = engines/dev-dax.c
+  dev-dax_LIBS = -lpmem
   ENGINES += dev-dax
 endif
 ifdef CONFIG_LIBPMEM

