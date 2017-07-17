Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33618 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbdGQMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Jul 2017 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dX4h4-0000Ss-0S
        for fio@vger.kernel.org; Mon, 17 Jul 2017 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170717120002.194882C009B@kernel.dk>
Date: Mon, 17 Jul 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 74c30eab68f320d73f4c7cf192699cb8bfb14eaf:

  man: fix wrong info on sync_file_range= (2017-07-14 08:25:24 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 785e49c659023df1735bff195ad4ba133ebd23a7:

  build: Sort file list (2017-07-16 14:02:51 -0600)

----------------------------------------------------------------
Bernhard M. Wiedemann (1):
      build: Sort file list

Tomohiro Kusumi (1):
      man: add missing \ for fcntl(2) in write_hint option

 Makefile | 4 ++--
 fio.1    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index bef930f..e8ea6cb 100644
--- a/Makefile
+++ b/Makefile
@@ -36,8 +36,8 @@ ifdef CONFIG_GFIO
   PROGS += gfio
 endif
 
-SOURCE :=	$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
-		$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/lib/*.c)) \
+SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
+		$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/lib/*.c))) \
 		gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		eta.c verify.c memory.c io_u.c parse.c mutex.c options.c \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
diff --git a/fio.1 b/fio.1
index 8a41321..7fe96e0 100644
--- a/fio.1
+++ b/fio.1
@@ -565,7 +565,7 @@ Advise using \fBFADV_RANDOM\fR
 .RE
 .TP
 .BI write_hint \fR=\fPstr
-Use \fBfcntl\fR|(2) to advise the kernel what life time to expect from a write.
+Use \fBfcntl\fR\|(2) to advise the kernel what life time to expect from a write.
 Only supported on Linux, as of version 4.13. The values are all relative to
 each other, and no absolute meaning should be associated with them. Accepted
 values are:
