Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:59327 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752741AbdBIWSQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2017 17:18:16 -0500
From: Rebecca Cran <rebecca@bluestop.org>
Subject: [PATCH] Windows: re-enable the mmap ioengine and fix static asserts
Date: Thu,  9 Feb 2017 22:17:27 +0000
Message-Id: <20170209221727.5828-1-rebecca@bluestop.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Rebecca Cran <bruce.cran@sandisk.com>

From: Rebecca Cran <bruce.cran@sandisk.com>

Windows supports mmap functionality via the CreateFileMapping and
MapViewOfFile functions. Update posix.c and re-enable the mmap
ioengine in the Makefile.

Also, enable the built-in static asserts, without which the build
breaks when configured with --disable-optimizations.
---
 Makefile           |  1 -
 configure          |  1 +
 os/windows/posix.c | 63 +++++++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/Makefile b/Makefile
index 491278e..a2842a0 100644
--- a/Makefile
+++ b/Makefile
@@ -179,7 +179,6 @@ ifeq ($(CONFIG_TARGET_OS), Darwin)
   LIBS	 += -lpthread -ldl
 endif
 ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
-  SOURCE := $(filter-out engines/mmap.c,$(SOURCE))
   SOURCE += os/windows/posix.c
   LIBS	 += -lpthread -lpsapi -lws2_32
   CFLAGS += -DPSAPI_VERSION=1 -Ios/windows/posix/include -Wno-format -static
diff --git a/configure b/configure
index d0c2173..46d00ee 100755
--- a/configure
+++ b/configure
@@ -314,6 +314,7 @@ CYGWIN*)
   output_sym "CONFIG_SCHED_IDLE"
   output_sym "CONFIG_TCP_NODELAY"
   output_sym "CONFIG_TLS_THREAD"
+  output_sym "CONFIG_STATIC_ASSERT"
   output_sym "CONFIG_IPV6"
   echo "CC=$CC" >> $config_host_mak
   echo "BUILD_CFLAGS=$CFLAGS -I../zlib -include config-host.h -D_GNU_SOURCE" >> $config_host_mak
diff --git a/os/windows/posix.c b/os/windows/posix.c
index bbd93e9..f468cbf 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -304,35 +304,76 @@ void *mmap(void *addr, size_t len, int prot, int flags,
 		int fildes, off_t off)
 {
 	DWORD vaProt = 0;
+	DWORD mapAccess = 0;
+	DWORD lenlow;
+	DWORD lenhigh;
+	HANDLE hMap;
 	void* allocAddr = NULL;
 
 	if (prot & PROT_NONE)
 		vaProt |= PAGE_NOACCESS;
 
-	if ((prot & PROT_READ) && !(prot & PROT_WRITE))
+	if ((prot & PROT_READ) && !(prot & PROT_WRITE)) {
 		vaProt |= PAGE_READONLY;
+		mapAccess = FILE_MAP_READ;
+	}
 
-	if (prot & PROT_WRITE)
+	if (prot & PROT_WRITE) {
 		vaProt |= PAGE_READWRITE;
+		mapAccess |= FILE_MAP_WRITE;
+	}
+
+	lenlow = len & 0xFFFF;
+	lenhigh = len >> 16;
+	/* If the low DWORD is zero and the high DWORD is non-zero, `CreateFileMapping`
+	   will return ERROR_INVALID_PARAMETER. To avoid this, set both to zero. */
+	if (lenlow == 0) {
+		lenhigh = 0;
+	}
 
-	if ((flags & MAP_ANON) | (flags & MAP_ANONYMOUS))
+	if (flags & MAP_ANON || flags & MAP_ANONYMOUS)
 	{
 		allocAddr = VirtualAlloc(addr, len, MEM_COMMIT, vaProt);
 		if (allocAddr == NULL)
 			errno = win_to_posix_error(GetLastError());
 	}
+	else
+	{
+		hMap = CreateFileMapping((HANDLE)_get_osfhandle(fildes), NULL, vaProt, lenhigh, lenlow, NULL);
+
+		if (hMap != NULL)
+		{
+			allocAddr = MapViewOfFile(hMap, mapAccess, off >> 16, off & 0xFFFF, len);
+		}
+
+		if (hMap == NULL || allocAddr == NULL)
+			errno = win_to_posix_error(GetLastError());
+
+	}
 
 	return allocAddr;
 }
 
 int munmap(void *addr, size_t len)
 {
-	if (!VirtualFree(addr, 0, MEM_RELEASE)) {
-		errno = win_to_posix_error(GetLastError());
-		return -1;
+	BOOL success;
+
+	/* We may have allocated the memory with either MapViewOfFile or
+		 VirtualAlloc. Therefore, try calling UnmapViewOfFile first, and if that
+		 fails, call VirtualFree. */
+	success = UnmapViewOfFile(addr);
+
+	if (!success)
+	{
+		success = VirtualFree(addr, 0, MEM_RELEASE);
 	}
 
-	return 0;
+	return !success;
+}
+
+int msync(void *addr, size_t len, int flags)
+{
+	return !FlushViewOfFile(addr, len);
 }
 
 int fork(void)
@@ -702,17 +743,9 @@ int getrusage(int who, struct rusage *r_usage)
 
 int posix_madvise(void *addr, size_t len, int advice)
 {
-	log_err("%s is not implemented\n", __func__);
 	return ENOSYS;
 }
 
-/* Windows doesn't support advice for memory pages. Just ignore it. */
-int msync(void *addr, size_t len, int flags)
-{
-	errno = ENOSYS;
-	return -1;
-}
-
 int fdatasync(int fildes)
 {
 	return fsync(fildes);
-- 
2.9.3.windows.2

