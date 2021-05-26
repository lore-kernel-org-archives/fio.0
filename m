Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhEZMBs (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 May 2021 08:01:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC972C061574
        for <fio@vger.kernel.org>; Wed, 26 May 2021 05:00:16 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1llsCj-004UHy-NY
        for fio@vger.kernel.org; Wed, 26 May 2021 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210526120001.AC37B1BC015F@kernel.dk>
Date: Wed, 26 May 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b54e0d80c52e626021aacd0ae4d9875940cff9aa:

  Merge branch 'taras/nfs-upstream' of https://github.com/tarasglek/fio-1 (2021-05-18 17:34:38 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c91fd13d479dc38bbb7ef6995256ad098ebbceb2:

  Merge branch 'master' of https://github.com/DevriesL/fio (2021-05-25 16:54:13 -0600)

----------------------------------------------------------------
DevriesL (1):
      android: add support for NDK sharedmem

Jens Axboe (1):
      Merge branch 'master' of https://github.com/DevriesL/fio

 os/os-android.h | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/os/os-android.h b/os/os-android.h
index 3f1aa9d3..a81cd815 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -71,11 +71,15 @@
 #include <stdio.h>
 #include <linux/ashmem.h>
 #include <linux/shm.h>
+#include <android/api-level.h>
+#if __ANDROID_API__ >= __ANDROID_API_O__
+#include <android/sharedmem.h>
+#else
+#define ASHMEM_DEVICE	"/dev/ashmem"
+#endif
 #define shmid_ds shmid64_ds
 #define SHM_HUGETLB    04000
 
-#define ASHMEM_DEVICE	"/dev/ashmem"
-
 static inline int shmctl(int __shmid, int __cmd, struct shmid_ds *__buf)
 {
 	int ret=0;
@@ -89,6 +93,16 @@ static inline int shmctl(int __shmid, int __cmd, struct shmid_ds *__buf)
 	return ret;
 }
 
+#if __ANDROID_API__ >= __ANDROID_API_O__
+static inline int shmget(key_t __key, size_t __size, int __shmflg)
+{
+	char keybuf[11];
+
+	sprintf(keybuf, "%d", __key);
+
+	return ASharedMemory_create(keybuf, __size + sizeof(uint64_t));
+}
+#else
 static inline int shmget(key_t __key, size_t __size, int __shmflg)
 {
 	int fd,ret;
@@ -114,6 +128,7 @@ error:
 	close(fd);
 	return ret;
 }
+#endif
 
 static inline void *shmat(int __shmid, const void *__shmaddr, int __shmflg)
 {

