Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36626 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388156AbfJVMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 22 Oct 2019 08:00:04 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iMspX-0000yK-Sw
        for fio@vger.kernel.org; Tue, 22 Oct 2019 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191022120002.392302C070F@kernel.dk>
Date: Tue, 22 Oct 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2e97fa1b0d76edc6517fa4a8a4f6e0792b458e8c:

  Merge branch 'fix-fsync-on-close' of https://github.com/sitsofe/fio (2019-10-15 09:27:06 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f6830780c2022a607b252191d4a5a1c6804e7513:

  Merge branch 'android-log-fix' of https://github.com/kdrag0n/fio (2019-10-21 08:46:43 -0600)

----------------------------------------------------------------
Danny Lin (1):
      Makefile: Link to the system logging library on Android

Jens Axboe (1):
      Merge branch 'android-log-fix' of https://github.com/kdrag0n/fio

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 7c21ef83..7aab6abd 100644
--- a/Makefile
+++ b/Makefile
@@ -170,7 +170,7 @@ endif
 ifeq ($(CONFIG_TARGET_OS), Android)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c profiles/tiobench.c \
 		oslib/linux-dev-lookup.c
-  LIBS += -ldl
+  LIBS += -ldl -llog
   LDFLAGS += -rdynamic
 endif
 ifeq ($(CONFIG_TARGET_OS), SunOS)

