Return-Path: <fio-owner@vger.kernel.org>
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:36144 "EHLO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab2JTDSj (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 19 Oct 2012 23:18:39 -0400
Received: by mail-yh0-f70.google.com with SMTP id o21so1894171yho.1
        for <fio@vger.kernel.org>; Fri, 19 Oct 2012 20:18:37 -0700 (PDT)
From: Yufei Ren <yufei.ren@stonybrook.edu>
Subject: [PATCH 2/4] thread cpu resource statistics bug fix
Date: Fri, 19 Oct 2012 23:11:50 -0400
Message-Id: <1350702712-5168-3-git-send-email-yufei.ren@stonybrook.edu>
In-Reply-To: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu>
References: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Yufei Ren <renyufei83@gmail.com>

From: Yufei Ren <renyufei83@gmail.com>

If `thread' option is enabled, resource usage should be thread
based instead of process based. For the following job,

fio --ioengine=cpuio --cpuload=50 --time_based --runtime=10 --name=j0 --numjobs=4 --thread

before patch, each thread CPU statistics:
...
  cpu          : usr=199.67%, sys=0.14%, ctx=1475, majf=0, minf=24
...

after patch:
...
  cpu          : usr=49.80%, sys=0.00%, ctx=79, majf=0, minf=18446744073709538943
...
---
 os/os-linux.h |    5 +++++
 stat.c        |    4 ++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/os/os-linux.h b/os/os-linux.h
index 9b7ff29..2b35f34 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -14,6 +14,7 @@
 #include <linux/unistd.h>
 #include <linux/raw.h>
 #include <linux/major.h>
+#include <linux/version.h>
 #include <endian.h>
 
 #include "indirect.h"
@@ -62,6 +63,10 @@
 #define FIO_HAVE_FALLOC_ENG
 #endif
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26)
+#define FIO_HAVE_RUSAGE_THREAD
+#endif
+
 #ifdef SYNC_FILE_RANGE_WAIT_BEFORE
 #define FIO_HAVE_SYNC_FILE_RANGE
 #endif
diff --git a/stat.c b/stat.c
index d041ef3..af6e1f2 100644
--- a/stat.c
+++ b/stat.c
@@ -16,7 +16,11 @@ void update_rusage_stat(struct thread_data *td)
 {
 	struct thread_stat *ts = &td->ts;
 
+#ifdef FIO_HAVE_RUSAGE_THREAD
+	getrusage(RUSAGE_THREAD, &td->ru_end);
+#else
 	getrusage(RUSAGE_SELF, &td->ru_end);
+#endif
 
 	ts->usr_time += mtime_since(&td->ru_start.ru_utime,
 					&td->ru_end.ru_utime);
-- 
1.7.2.3

