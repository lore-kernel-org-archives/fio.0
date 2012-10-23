Return-Path: <fio-owner@vger.kernel.org>
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:37669 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab2JWB3r (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Oct 2012 21:29:47 -0400
Received: by mail-gg0-f198.google.com with SMTP id o1so6382116ggn.1
        for <fio@vger.kernel.org>; Mon, 22 Oct 2012 18:29:45 -0700 (PDT)
From: Yufei Ren <yufei.ren@stonybrook.edu>
Subject: [PATCH] Replace FIO_HAVE_RUSAGE_THREAD with RUSAGE_THREAD
Date: Mon, 22 Oct 2012 21:29:37 -0400
Message-Id: <1350955778-27682-1-git-send-email-yufei.ren@stonybrook.edu>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Yufei Ren <renyufei83@gmail.com>

From: Yufei Ren <renyufei83@gmail.com>

RUSAGE_THREAD is a more clear macro to enable getrusage() thread support.
---
 os/os-linux.h |    5 -----
 stat.c        |    2 +-
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/os/os-linux.h b/os/os-linux.h
index 2b35f34..9b7ff29 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -14,7 +14,6 @@
 #include <linux/unistd.h>
 #include <linux/raw.h>
 #include <linux/major.h>
-#include <linux/version.h>
 #include <endian.h>
 
 #include "indirect.h"
@@ -63,10 +62,6 @@
 #define FIO_HAVE_FALLOC_ENG
 #endif
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26)
-#define FIO_HAVE_RUSAGE_THREAD
-#endif
-
 #ifdef SYNC_FILE_RANGE_WAIT_BEFORE
 #define FIO_HAVE_SYNC_FILE_RANGE
 #endif
diff --git a/stat.c b/stat.c
index af6e1f2..522901a 100644
--- a/stat.c
+++ b/stat.c
@@ -16,7 +16,7 @@ void update_rusage_stat(struct thread_data *td)
 {
 	struct thread_stat *ts = &td->ts;
 
-#ifdef FIO_HAVE_RUSAGE_THREAD
+#ifdef RUSAGE_THREAD
 	getrusage(RUSAGE_THREAD, &td->ru_end);
 #else
 	getrusage(RUSAGE_SELF, &td->ru_end);
-- 
1.7.2.3

