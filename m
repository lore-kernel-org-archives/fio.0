Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46344 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752463AbdBNNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Feb 2017 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cdciE-0001rw-Gg
        for fio@vger.kernel.org; Tue, 14 Feb 2017 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170214130002.030F92C0218@kernel.dk>
Date: Tue, 14 Feb 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 855f03627f2bce6a7f725fe6cc92e7ebe8d39deb:

  fnv: work with non-64-bit aligned chunks of data (2017-02-07 15:11:37 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 06cbb3c71fc75dbeddebb53c8f0a2ea95dc28228:

  Windows: re-enable the mmap ioengine and fix static asserts (2017-02-13 15:38:59 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      gfio: fix git location for fio

Rebecca Cran (3):
      Windows: Update the EULA year and add more examples to the installer
      Fix the return type of log_err and log_info functions
      Windows: re-enable the mmap ioengine and fix static asserts

Sitsofe Wheeler (1):
      configure: try to disable weak linking on OSX

Tomohiro Kusumi (3):
      Add a comment to clarify 941bda94
      steadystate: Use calloc(3)
      Be more verbose on endianness detection failure

 Makefile                |   1 -
 configure               |  18 ++++++--
 diskutil.h              |   1 +
 gfio.c                  |   2 +-
 libfio.c                |  36 +++++++++++++---
 os/windows/eula.rtf     | Bin 1060 -> 1072 bytes
 os/windows/examples.wxs | 112 ++++++++++++++++++++++++++++++++++++++++++------
 os/windows/install.wxs  |   2 +-
 os/windows/posix.c      |  63 ++++++++++++++++++++-------
 steadystate.c           |   9 +---
 t/log.c                 |   4 +-
 11 files changed, 198 insertions(+), 50 deletions(-)

---

Diff of recent changes:

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
index d0c2173..0a258bf 100755
--- a/configure
+++ b/configure
@@ -268,6 +268,17 @@ Darwin)
   if test -z "$cpu" && test "$(sysctl -n hw.optional.x86_64)" = "1"; then
     cpu="x86_64"
   fi
+  # Error at compile time linking of weak/partial symbols if possible...
+cat > $TMPC <<EOF
+int main(void)
+{
+  return 0;
+}
+EOF
+  if compile_prog "" "-Wl,-no_weak_imports" "disable weak symbols"; then
+    echo "Disabling weak symbols"
+    LDFLAGS="$LDFLAGS -Wl,-no_weak_imports"
+  fi
   ;;
 SunOS)
   # `uname -m` returns i86pc even on an x86_64 box, so default based on isainfo
@@ -314,6 +325,7 @@ CYGWIN*)
   output_sym "CONFIG_SCHED_IDLE"
   output_sym "CONFIG_TCP_NODELAY"
   output_sym "CONFIG_TLS_THREAD"
+  output_sym "CONFIG_STATIC_ASSERT"
   output_sym "CONFIG_IPV6"
   echo "CC=$CC" >> $config_host_mak
   echo "BUILD_CFLAGS=$CFLAGS -I../zlib -include config-host.h -D_GNU_SOURCE" >> $config_host_mak
@@ -815,14 +827,12 @@ echo "CLOCK_MONOTONIC_PRECISE       $clock_monotonic_precise"
 # clockid_t probe
 clockid_t="no"
 cat > $TMPC << EOF
-#include <stdio.h>
-#include <string.h>
 #include <time.h>
 int main(int argc, char **argv)
 {
-  clockid_t cid;
+  volatile clockid_t cid;
   memset(&cid, 0, sizeof(cid));
-  return clock_gettime(cid, NULL);
+  return 0;
 }
 EOF
 if compile_prog "" "$LIBS" "clockid_t"; then
diff --git a/diskutil.h b/diskutil.h
index 04fdde2..f773066 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -114,6 +114,7 @@ extern int update_io_ticks(void);
 extern void setup_disk_util(void);
 extern void disk_util_prune_entries(void);
 #else
+/* keep this as a function to avoid a warning in handle_du() */
 static inline void print_disk_util(struct disk_util_stat *du,
 				   struct disk_util_agg *agg, int terse,
 				   struct buf_output *out)
diff --git a/gfio.c b/gfio.c
index 9c917cb..7c92a50 100644
--- a/gfio.c
+++ b/gfio.c
@@ -1240,7 +1240,7 @@ static void about_dialog(GtkWidget *w, gpointer data)
 		"program-name", "gfio",
 		"comments", "Gtk2 UI for fio",
 		"license", license_trans,
-		"website", "http://git.kernel.dk/?p=fio.git;a=summary",
+		"website", "http://git.kernel.dk/cgit/fio/",
 		"authors", authors,
 		"version", fio_version_string,
 		"copyright", "�� 2012 Jens Axboe <axboe@kernel.dk>",
diff --git a/libfio.c b/libfio.c
index 960daf6..7e0d32c 100644
--- a/libfio.c
+++ b/libfio.c
@@ -311,6 +311,13 @@ int fio_set_fd_nonblocking(int fd, const char *who)
 	return flags;
 }
 
+enum {
+	ENDIAN_INVALID_BE = 1,
+	ENDIAN_INVALID_LE,
+	ENDIAN_INVALID_CONFIG,
+	ENDIAN_BROKEN,
+};
+
 static int endian_check(void)
 {
 	union {
@@ -327,16 +334,16 @@ static int endian_check(void)
 
 #if defined(CONFIG_LITTLE_ENDIAN)
 	if (be)
-		return 1;
+		return ENDIAN_INVALID_BE;
 #elif defined(CONFIG_BIG_ENDIAN)
 	if (le)
-		return 1;
+		return ENDIAN_INVALID_LE;
 #else
-	return 1;
+	return ENDIAN_INVALID_CONFIG;
 #endif
 
 	if (!le && !be)
-		return 1;
+		return ENDIAN_BROKEN;
 
 	return 0;
 }
@@ -344,6 +351,7 @@ static int endian_check(void)
 int initialize_fio(char *envp[])
 {
 	long ps;
+	int err;
 
 	/*
 	 * We need these to be properly 64-bit aligned, otherwise we
@@ -359,8 +367,26 @@ int initialize_fio(char *envp[])
 	compiletime_assert((offsetof(struct thread_options_pack, percentile_list) % 8) == 0, "percentile_list");
 	compiletime_assert((offsetof(struct thread_options_pack, latency_percentile) % 8) == 0, "latency_percentile");
 
-	if (endian_check()) {
+	err = endian_check();
+	if (err) {
 		log_err("fio: endianness settings appear wrong.\n");
+		switch (err) {
+		case ENDIAN_INVALID_BE:
+			log_err("fio: got big-endian when configured for little\n");
+			break;
+		case ENDIAN_INVALID_LE:
+			log_err("fio: got little-endian when configured for big\n");
+			break;
+		case ENDIAN_INVALID_CONFIG:
+			log_err("fio: not configured to any endianness\n");
+			break;
+		case ENDIAN_BROKEN:
+			log_err("fio: failed to detect endianness\n");
+			break;
+		default:
+			assert(0);
+			break;
+		}
 		log_err("fio: please report this to fio@vger.kernel.org\n");
 		return 1;
 	}
diff --git a/os/windows/eula.rtf b/os/windows/eula.rtf
index cc7be7f..1c92932 100755
Binary files a/os/windows/eula.rtf and b/os/windows/eula.rtf differ
diff --git a/os/windows/examples.wxs b/os/windows/examples.wxs
index a21182a..cc2ff5c 100755
--- a/os/windows/examples.wxs
+++ b/os/windows/examples.wxs
@@ -9,48 +9,111 @@
                     <File Source="..\..\examples\aio-read.fio" />
                 </Component>
                 <Component>
+                    <File Source="..\..\examples\backwards-read.fio" />
+                </Component>
+                <Component>
+                    <File Source="..\..\examples\basic-verify.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\cpuio.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\dev-dax.fio" />
+                </Component>
+                <Component>
                     <File Source="..\..\examples\disk-zone-profile.fio" />
                 </Component>
                 <Component>
+                  <File Source="..\..\examples\e4defrag.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\e4defrag2.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\enospc-pressure.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\falloc.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\fixed-rate-submission.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\flow.fio" />
+                </Component>
+                <Component>
                     <File Source="..\..\examples\fsx.fio" />
                 </Component>
                 <Component>
+                  <File Source="..\..\examples\fusion-aw-sync.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\gfapi.fio" />
+                </Component>
+                <Component>
                     <File Source="..\..\examples\iometer-file-access-server.fio" />
                 </Component>
                 <Component>
+                  <File Source="..\..\examples\jesd219.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\latency-profile.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\libhdfs.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\mtd.fio" />
+                </Component>
+                <Component>
                     <File Source="..\..\examples\netio.fio" />
                 </Component>
                 <Component>
                     <File Source="..\..\examples\netio_multicast.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\ssd-test.fio" />
+                  <File Source="..\..\examples\null.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\surface-scan.fio" />
+                  <File Source="..\..\examples\numa.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\tiobench-example.fio" />
+                  <File Source="..\..\examples\pmemblk.fio" />
                 </Component>
                 <Component>
-                  <File Source="..\..\examples\null.fio" />
+                  <File Source="..\..\examples\poisson-rate-submission.fio" />
                 </Component>
                 <Component>
-                  <File Source="..\..\examples\flow.fio" />
+                  <File Source="..\..\examples\rand-zones.fio" />
                 </Component>
                 <Component>
-                  <File Source="..\..\examples\cpuio.fio" />
+                  <File Source="..\..\examples\rbd.fio" />
                 </Component>
                 <Component>
-                  <File Source="..\..\examples\falloc.fio" />
+                  <File Source="..\..\examples\rdmaio-client.fio" />
                 </Component>
                 <Component>
-                  <File Source="..\..\examples\fusion-aw-sync.fio" />
+                  <File Source="..\..\examples\rdmaio-server.fio" />
                 </Component>
                 <Component>
                   <File Source="..\..\examples\ssd-steadystate.fio" />
                 </Component>
                 <Component>
+                    <File Source="..\..\examples\ssd-test.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\steadystate.fio" />
+                </Component>
+                <Component>
+                    <File Source="..\..\examples\surface-scan.fio" />
+                </Component>
+                <Component>
+                    <File Source="..\..\examples\tiobench-example.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\waitfor.fio" />
+                </Component>
+                <Component>
                   <File Source="..\..\examples\zipf.fio" />
                 </Component>
         </DirectoryRef>
@@ -59,20 +122,41 @@
         <ComponentGroup Id="examples">
             <ComponentRef Id="_1mbs_clients.fio" />
             <ComponentRef Id="aio_read.fio" />
+            <ComponentRef Id="backwards_read.fio" />
+            <ComponentRef Id="basic_verify.fio" />
+            <ComponentRef Id="cpuio.fio" />
+            <ComponentRef Id="dev_dax.fio" />
             <ComponentRef Id="disk_zone_profile.fio" />
+            <ComponentRef Id="e4defrag.fio" />
+            <ComponentRef Id="e4defrag2.fio" />
+            <ComponentRef Id="enospc_pressure.fio" />
+            <ComponentRef Id="falloc.fio" />
+            <ComponentRef Id="fixed_rate_submission.fio" />
+            <ComponentRef Id="flow.fio" />
             <ComponentRef Id="fsx.fio" />
+            <ComponentRef Id="fusion_aw_sync.fio" />
+            <ComponentRef Id="gfapi.fio" />
             <ComponentRef Id="iometer_file_access_server.fio" />
+            <ComponentRef Id="jesd219.fio" />
+            <ComponentRef Id="latency_profile.fio" />
+            <ComponentRef Id="libhdfs.fio" />
+            <ComponentRef Id="mtd.fio" />
             <ComponentRef Id="netio.fio" />
             <ComponentRef Id="netio_multicast.fio" />
+            <ComponentRef Id="null.fio" />
+            <ComponentRef Id="numa.fio" />
+            <ComponentRef Id="pmemblk.fio" />
+            <ComponentRef Id="poisson_rate_submission.fio" />
+            <ComponentRef Id="rand_zones.fio" />
+            <ComponentRef Id="rbd.fio" />
+            <ComponentRef Id="rdmaio_client.fio" />
+            <ComponentRef Id="rdmaio_server.fio" />
+            <ComponentRef Id="ssd_steadystate.fio" />
             <ComponentRef Id="ssd_test.fio" />
+            <ComponentRef Id="steadystate.fio" />
             <ComponentRef Id="surface_scan.fio" />
             <ComponentRef Id="tiobench_example.fio" />
-            <ComponentRef Id="null.fio" />
-            <ComponentRef Id="flow.fio" />
-            <ComponentRef Id="cpuio.fio" />
-            <ComponentRef Id="falloc.fio" />
-            <ComponentRef Id="fusion_aw_sync.fio" />
-            <ComponentRef Id="ssd_steadystate.fio" />
+            <ComponentRef Id="waitfor.fio" />
             <ComponentRef Id="zipf.fio" />
         </ComponentGroup>
     </Fragment>
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 22b7f7e..9e776de 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -58,7 +58,7 @@
 		<ComponentGroupRef Id="examples"/>
 	</Feature>
 
-	<Property Id="ARPURLINFOABOUT" Value="http://git.kernel.dk/?p=fio.git" />
+	<Property Id="ARPURLINFOABOUT" Value="http://git.kernel.dk/cgit/fio/" />
 	<Property Id='ARPCONTACT'>fio@vger.kernel.org</Property>
 	<Property Id='ARPHELPLINK'>http://www.spinics.net/lists/fio/</Property>
 	<Property Id='ARPURLUPDATEINFO'>http://bluestop.org/fio/</Property>
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
diff --git a/steadystate.c b/steadystate.c
index 951376f..43c715c 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -8,13 +8,8 @@ bool steadystate_enabled = false;
 
 static void steadystate_alloc(struct thread_data *td)
 {
-	int i;
-
-	td->ss.bw_data = malloc(td->ss.dur * sizeof(uint64_t));
-	td->ss.iops_data = malloc(td->ss.dur * sizeof(uint64_t));
-	/* initialize so that it is obvious if the cache is not full in the output */
-	for (i = 0; i < td->ss.dur; i++)
-		td->ss.iops_data[i] = td->ss.bw_data[i] = 0;
+	td->ss.bw_data = calloc(td->ss.dur, sizeof(uint64_t));
+	td->ss.iops_data = calloc(td->ss.dur, sizeof(uint64_t));
 
 	td->ss.state |= __FIO_SS_DATA;
 }
diff --git a/t/log.c b/t/log.c
index 1ed3851..929aac6 100644
--- a/t/log.c
+++ b/t/log.c
@@ -2,7 +2,7 @@
 #include <stdarg.h>
 #include "../minmax.h"
 
-int log_err(const char *format, ...)
+size_t log_err(const char *format, ...)
 {
 	char buffer[1024];
 	va_list args;
@@ -16,7 +16,7 @@ int log_err(const char *format, ...)
 	return fwrite(buffer, len, 1, stderr);
 }
 
-int log_info(const char *format, ...)
+size_t log_info(const char *format, ...)
 {
 	char buffer[1024];
 	va_list args;
