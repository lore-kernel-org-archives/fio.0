Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ia0-f181.google.com ([209.85.210.181]:44007 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3CLHHD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 12 Mar 2013 03:07:03 -0400
Received: by mail-ia0-f181.google.com with SMTP id w33so4435929iag.40
        for <fio@vger.kernel.org>; Tue, 12 Mar 2013 00:07:02 -0700 (PDT)
From: olegmatcovsky@gmail.com
Subject: [PATCH 2/2] Conditionally include <sys/shm.h> based on OS support. Define missing MAP_HUGETLB for Android.
Date: Tue, 12 Mar 2013 00:06:53 -0700
Message-Id: <1363072013-7562-1-git-send-email-olegmatcovsky@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Oleg Matcovschi <olegmatcovsky@gmail.com>

From: Oleg <olegm@olegm-vmware.(none)>

Signed-off-by: Oleg Matcovschi <olegmatcovsky@gmail.com>
---
 backend.c       |    6 +++---
 init.c          |    7 ++++---
 memory.c        |    6 +++---
 os/os-android.h |    4 ++++
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/backend.c b/backend.c
index d1fe964..e482fb8 100644
--- a/backend.c
+++ b/backend.c
@@ -34,12 +34,12 @@
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <sys/ipc.h>
-#ifndef FIO_NO_HAVE_SHM_H
-#include <sys/shm.h>
-#endif
 #include <sys/mman.h>
 
 #include "fio.h"
+#ifndef FIO_NO_HAVE_SHM_H
+#include <sys/shm.h>
+#endif
 #include "hash.h"
 #include "smalloc.h"
 #include "verify.h"
diff --git a/init.c b/init.c
index c722688..9d15318 100644
--- a/init.c
+++ b/init.c
@@ -9,13 +9,14 @@
 #include <string.h>
 #include <errno.h>
 #include <sys/ipc.h>
-#ifndef FIO_NO_HAVE_SHM_H
-#include <sys/shm.h>
-#endif
 #include <sys/types.h>
 #include <sys/stat.h>
 
 #include "fio.h"
+#ifndef FIO_NO_HAVE_SHM_H
+#include <sys/shm.h>
+#endif
+
 #include "parse.h"
 #include "smalloc.h"
 #include "filehash.h"
diff --git a/memory.c b/memory.c
index ee5f895..443d71d 100644
--- a/memory.c
+++ b/memory.c
@@ -5,12 +5,12 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
-#ifndef FIO_NO_HAVE_SHM_H
-#include <sys/shm.h>
-#endif
 #include <sys/mman.h>
 
 #include "fio.h"
+#ifndef FIO_NO_HAVE_SHM_H
+#include <sys/shm.h>
+#endif
 
 static void *pinned_mem;
 
diff --git a/os/os-android.h b/os/os-android.h
index cedfdaf..3bb44b9 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -31,6 +31,7 @@
 #define FIO_HAVE_E4_ENG
 #define FIO_HAVE_BYTEORDER_FUNCS
 #define FIO_HAVE_MMAP_HUGE
+#define FIO_NO_HAVE_SHM_H
 
 #define OS_MAP_ANON		MAP_ANONYMOUS
 
@@ -41,6 +42,9 @@
 #ifdef MADV_REMOVE
 #define FIO_MADV_FREE	MADV_REMOVE
 #endif
+#ifndef MAP_HUGETLB
+#define MAP_HUGETLB 0x40000 /* arch specific */
+#endif
 
 
 /*
-- 
1.7.5.4

