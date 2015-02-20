Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:65375 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbbBTTAj (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Feb 2015 14:00:39 -0500
Received: by mail-ig0-f179.google.com with SMTP id l13so5402748iga.0
        for <fio@vger.kernel.org>; Fri, 20 Feb 2015 11:00:39 -0800 (PST)
MIME-Version: 1.0
From: enh <enh@google.com>
Date: Fri, 20 Feb 2015 11:00:18 -0800
Message-ID: <CAJgzZoqb=+nFdbFjAv6Tbx6x-Gdqz-+nvHJpEuZXK4iBrqUsSA@mail.gmail.com>
Subject: [PATCH] fix implicit function declaration on Android
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

there's no fio_set_sched_idle in os/os-android.h. copy the one from
os/os-linux.h.

current Android also has posix_madvise.

diff --git a/os/os-android.h b/os/os-android.h
index c30f62e..6b074cd 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -4,6 +4,7 @@
 #define FIO_OS os_android

 #include <sys/ioctl.h>
+#include <sys/mman.h>
 #include <sys/uio.h>
 #include <sys/syscall.h>
 #include <sys/vfs.h>
@@ -37,10 +38,6 @@

 #define OS_MAP_ANON MAP_ANONYMOUS

-#define posix_madvise   madvise
-#define POSIX_MADV_DONTNEED MADV_DONTNEED
-#define POSIX_MADV_SEQUENTIAL MADV_SEQUENTIAL
-#define POSIX_MADV_RANDOM MADV_RANDOM
 #ifdef MADV_REMOVE
 #define FIO_MADV_FREE MADV_REMOVE
 #endif
@@ -261,4 +258,12 @@ static inline int os_trim(int fd, unsigned long long start,
  return errno;
 }

+#ifdef CONFIG_SCHED_IDLE
+static inline int fio_set_sched_idle(void)
+{
+        struct sched_param p = { .sched_priority = 0, };
+        return sched_setscheduler(gettid(), SCHED_IDLE, &p);
+}
+#endif
+
 #endif
