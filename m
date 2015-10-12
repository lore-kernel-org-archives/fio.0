Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51812 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbbJLMAh (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 12 Oct 2015 08:00:37 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZlbmO-0001ec-Oh
	for fio@vger.kernel.org; Mon, 12 Oct 2015 12:00:36 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151012120002.7AB7E2C0A2E@kernel.dk>
Date: Mon, 12 Oct 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2099539d0f49098148b101d2e3d3f533777c700e:

  server: bump protocol version (2015-10-01 08:55:18 +0200)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 36a6ac702ab9f8321bd0d6e298348f4c65eb01ae:

  Fix Windows build by using lib/strcasestr.{c,h} (2015-10-08 12:58:06 -0600)

----------------------------------------------------------------
Bruce Cran (1):
      Fix Windows build by using lib/strcasestr.{c,h}

 Makefile        | 1 +
 os/os-windows.h | 1 +
 2 files changed, 2 insertions(+)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index d287126..1507464 100644
--- a/Makefile
+++ b/Makefile
@@ -237,6 +237,7 @@ ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
     T_DEDUPE_OBJS += os/windows/posix.o lib/hweight.o
     T_SMALLOC_OBJS += os/windows/posix.o lib/hweight.o
     T_LFSR_TEST_OBJS += os/windows/posix.o lib/hweight.o
+    T_ZIPF_OBJS += lib/strcasestr.o
 endif
 
 T_TEST_PROGS = $(T_SMALLOC_PROGS)
diff --git a/os/os-windows.h b/os/os-windows.h
index 9e931c9..ad1c3df 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -16,6 +16,7 @@
 #include "../file.h"
 #include "../log.h"
 #include "../lib/hweight.h"
+#include "../lib/strcasestr.h"
 
 #include "windows/posix.h"
 
