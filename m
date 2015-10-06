Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34643 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbbJFAUU (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 5 Oct 2015 20:20:20 -0400
Received: by padhy16 with SMTP id hy16so50975893pad.1
        for <fio@vger.kernel.org>; Mon, 05 Oct 2015 17:20:19 -0700 (PDT)
From: Bruce Cran <bruce.cran@gmail.com>
Subject: [PATCH] Fix Windows build by using lib/strcasestr.{c,h}
Date: Mon,  5 Oct 2015 18:18:50 -0600
Message-Id: <1444090730-4656-1-git-send-email-bruce.cran@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: bruce.cran@gmail.com

---
 Makefile        | 1 +
 os/os-windows.h | 1 +
 2 files changed, 2 insertions(+)

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
 
-- 
2.5.2.windows.2

