Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48710 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751432AbeCaMAU (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 31 Mar 2018 08:00:20 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1f2FBD-0002tF-EJ
        for fio@vger.kernel.org; Sat, 31 Mar 2018 12:00:19 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180331120002.9D0822C00D1@kernel.dk>
Date: Sat, 31 Mar 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d6d74886759e3f268a6a3b12a47872865b867023:

  Merge branch 'master' of https://github.com/bvanassche/fio (2018-03-29 10:02:25 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cefd2a94b408b9c3be0300edb1270a546e7f09fe:

  Merge branch 'aarch64-crc32c' of https://github.com/sitsofe/fio (2018-03-30 10:16:27 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'aarch64-crc32c' of https://github.com/sitsofe/fio

Sitsofe Wheeler (2):
      aarch64: refactor HW ARM CRC32c detection
      Minor style changes

 arch/arch-aarch64.h |  4 ----
 configure           | 18 +++++++++++++-----
 crc/crc32c-arm64.c  | 21 +++++++--------------
 crc/crc32c-intel.c  |  2 +-
 crc/crc32c.h        |  6 +++---
 os/os-linux.h       | 27 +++++++++++++++++++++++++++
 os/os.h             | 11 +++++++++++
 7 files changed, 62 insertions(+), 27 deletions(-)

---

Diff of recent changes:

diff --git a/arch/arch-aarch64.h b/arch/arch-aarch64.h
index 0912a86..2a86cc5 100644
--- a/arch/arch-aarch64.h
+++ b/arch/arch-aarch64.h
@@ -27,8 +27,4 @@ static inline int arch_ffz(unsigned long bitmask)
 
 #define ARCH_HAVE_FFZ
 
-#ifdef ARCH_HAVE_CRC_CRYPTO
-#define ARCH_HAVE_ARM64_CRC_CRYPTO
-#endif
-
 #endif
diff --git a/configure b/configure
index f635863..38706a9 100755
--- a/configure
+++ b/configure
@@ -600,7 +600,7 @@ int main(void)
 EOF
 if compile_prog "" "" "posixaio" ; then
   posix_aio="yes"
-elif compile_prog "" "-lrt" "posixaio"; then
+elif compile_prog "" "-lrt" "posixaio -lrt"; then
   posix_aio="yes"
   posix_aio_lrt="yes"
   LIBS="-lrt $LIBS"
@@ -2108,18 +2108,23 @@ if test "$march_armv8_a_crc_crypto" != "yes" ; then
 fi
 if test "$cpu" = "arm64" ; then
   cat > $TMPC <<EOF
-#include <sys/auxv.h>
 #include <arm_acle.h>
 #include <arm_neon.h>
+#include <sys/auxv.h>
 
 int main(void)
 {
-  return 0;
+  /* Can we also do a runtime probe? */
+#if __linux__
+  return getauxval(AT_HWCAP);
+#else
+# error "Don't know how to do runtime probe for ARM CRC32c"
+#endif
 }
 EOF
-  if compile_prog "-march=armv8-a+crc+crypto" "" ""; then
+  if compile_prog "-march=armv8-a+crc+crypto" "" "ARM CRC32c"; then
     march_armv8_a_crc_crypto="yes"
-    CFLAGS="$CFLAGS -march=armv8-a+crc+crypto -DARCH_HAVE_CRC_CRYPTO"
+    CFLAGS="$CFLAGS -march=armv8-a+crc+crypto"
     march_set="yes"
   fi
 fi
@@ -2421,6 +2426,9 @@ if test "$zlib" = "no" ; then
     echo "Note that some distros have separate packages for static libraries."
   fi
 fi
+if test "$march_armv8_a_crc_crypto" = "yes" ; then
+  output_sym "ARCH_HAVE_CRC_CRYPTO"
+fi
 if test "$cuda" = "yes" ; then
   output_sym "CONFIG_CUDA"
 fi
diff --git a/crc/crc32c-arm64.c b/crc/crc32c-arm64.c
index 08177ba..11bfe5d 100644
--- a/crc/crc32c-arm64.c
+++ b/crc/crc32c-arm64.c
@@ -1,4 +1,9 @@
 #include "crc32c.h"
+#include "../os/os.h"
+
+bool crc32c_arm64_available = false;
+
+#ifdef ARCH_HAVE_CRC_CRYPTO
 
 #define CRC32C3X8(ITR) \
 	crc1 = __crc32cd(crc1, *((const uint64_t *)data + 42*1 + (ITR)));\
@@ -15,15 +20,6 @@
 	CRC32C3X8((ITR)*7+6) \
 	} while(0)
 
-#ifndef HWCAP_CRC32
-#define HWCAP_CRC32             (1 << 7)
-#endif /* HWCAP_CRC32 */
-
-bool crc32c_arm64_available = false;
-
-#ifdef ARCH_HAVE_ARM64_CRC_CRYPTO
-
-#include <sys/auxv.h>
 #include <arm_acle.h>
 #include <arm_neon.h>
 
@@ -102,13 +98,10 @@ uint32_t crc32c_arm64(unsigned char const *data, unsigned long length)
 
 void crc32c_arm64_probe(void)
 {
-	unsigned long hwcap;
-
 	if (!crc32c_probed) {
-		hwcap = getauxval(AT_HWCAP);
-		crc32c_arm64_available = (hwcap & HWCAP_CRC32) != 0;
+		crc32c_arm64_available = os_cpu_has(CPU_ARM64_CRC32C);
 		crc32c_probed = true;
 	}
 }
 
-#endif /* ARCH_HAVE_ARM64_CRC_CRYPTO */
+#endif /* ARCH_HAVE_CRC_CRYPTO */
diff --git a/crc/crc32c-intel.c b/crc/crc32c-intel.c
index 9a2cefd..6e810a2 100644
--- a/crc/crc32c-intel.c
+++ b/crc/crc32c-intel.c
@@ -84,4 +84,4 @@ void crc32c_intel_probe(void)
 	}
 }
 
-#endif /* ARCH_HAVE_SSE */
+#endif /* ARCH_HAVE_SSE4_2 */
diff --git a/crc/crc32c.h b/crc/crc32c.h
index 60f6014..18f1161 100644
--- a/crc/crc32c.h
+++ b/crc/crc32c.h
@@ -27,7 +27,7 @@ extern uint32_t crc32c_sw(unsigned char const *, unsigned long);
 extern bool crc32c_arm64_available;
 extern bool crc32c_intel_available;
 
-#ifdef ARCH_HAVE_ARM64_CRC_CRYPTO
+#ifdef ARCH_HAVE_CRC_CRYPTO
 extern uint32_t crc32c_arm64(unsigned char const *, unsigned long);
 extern void crc32c_arm64_probe(void);
 #else
@@ -35,7 +35,7 @@ extern void crc32c_arm64_probe(void);
 static inline void crc32c_arm64_probe(void)
 {
 }
-#endif
+#endif /* ARCH_HAVE_CRC_CRYPTO */
 
 #ifdef ARCH_HAVE_SSE4_2
 extern uint32_t crc32c_intel(unsigned char const *, unsigned long);
@@ -45,7 +45,7 @@ extern void crc32c_intel_probe(void);
 static inline void crc32c_intel_probe(void)
 {
 }
-#endif
+#endif /* ARCH_HAVE_SSE4_2 */
 
 static inline uint32_t fio_crc32c(unsigned char const *buf, unsigned long len)
 {
diff --git a/os/os-linux.h b/os/os-linux.h
index 894dc85..1d400a0 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -19,6 +19,13 @@
 #include <linux/fs.h>
 #include <scsi/sg.h>
 
+#ifdef ARCH_HAVE_CRC_CRYPTO
+#include <sys/auxv.h>
+#ifndef HWCAP_CRC32
+#define HWCAP_CRC32             (1 << 7)
+#endif /* HWCAP_CRC32 */
+#endif /* ARCH_HAVE_CRC_CRYPTO */
+
 #include "./os-linux-syscall.h"
 #include "binject.h"
 #include "../file.h"
@@ -410,4 +417,24 @@ static inline bool fio_fallocate(struct fio_file *f, uint64_t offset,
 }
 #endif
 
+#define FIO_HAVE_CPU_HAS
+static inline bool os_cpu_has(cpu_features feature)
+{
+	bool have_feature;
+	unsigned long fio_unused hwcap;
+
+	switch (feature) {
+#ifdef ARCH_HAVE_CRC_CRYPTO
+	case CPU_ARM64_CRC32C:
+		hwcap = getauxval(AT_HWCAP);
+		have_feature = (hwcap & HWCAP_CRC32) != 0;
+		break;
+#endif
+	default:
+		have_feature = false;
+	}
+
+	return have_feature;
+}
+
 #endif
diff --git a/os/os.h b/os/os.h
index 95ed7cf..becc410 100644
--- a/os/os.h
+++ b/os/os.h
@@ -27,6 +27,10 @@ enum {
 	os_nr,
 };
 
+typedef enum {
+        CPU_ARM64_CRC32C,
+} cpu_features;
+
 /* IWYU pragma: begin_exports */
 #if defined(__ANDROID__)
 #include "os-android.h"
@@ -387,4 +391,11 @@ static inline bool fio_fallocate(struct fio_file *f, uint64_t offset, uint64_t l
 # define FIO_HAVE_ANY_FALLOCATE
 #endif
 
+#ifndef FIO_HAVE_CPU_HAS
+static inline bool os_cpu_has(cpu_features feature)
+{
+	return false;
+}
+#endif
+
 #endif
