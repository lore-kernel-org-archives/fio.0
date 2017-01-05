Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33660 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032109AbdAENAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 5 Jan 2017 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cP7eE-0002FZ-NZ
        for fio@vger.kernel.org; Thu, 05 Jan 2017 13:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170105130001.DC9B02C1D80@kernel.dk>
Date: Thu,  5 Jan 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1684f7fd9047c7405264f462f76e1135c563ec33:

  Add missing .help string for io_size option (2017-01-03 10:10:58 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 847d544cce05157ec36f50b8214b26aff83aef01:

  Style cleanups for arm crc32c hw support (2017-01-04 19:44:35 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Style cleanups for arm crc32c hw support

wei xiao (1):
      Add arm64 hardware assisted crc32c support

 HOWTO               |   5 +++
 Makefile            |   4 +-
 arch/arch-aarch64.h |   4 ++
 configure           |  23 +++++++++++
 crc/crc32c-arm64.c  | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 crc/crc32c.h        |  14 +++++++
 crc/test.c          |   1 +
 lib/bloom.c         |   1 +
 options.c           |   4 ++
 verify.c            |   2 +
 verify.h            |   1 +
 11 files changed, 172 insertions(+), 2 deletions(-)
 create mode 100644 crc/crc32c-arm64.c

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 4354e46..4cc733f 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1514,6 +1514,11 @@ verify=str	If writing to a file, fio can verify the file contents
 				back to regular software crc32c, if not
 				supported by the system.
 
+			crc32c-arm64 Use hardware assisted crc32c calculation
+				provided on CRC enabled ARM 64-bits processors.
+				Falls back to regular software crc32c, if not
+				supported by the system.
+
 			crc32	Use a crc32 sum of the data area and store
 				it in the header of each block.
 
diff --git a/Makefile b/Makefile
index 4c64168..ad02d93 100644
--- a/Makefile
+++ b/Makefile
@@ -234,10 +234,10 @@ endif
 T_DEDUPE_OBJS = t/dedupe.o
 T_DEDUPE_OBJS += lib/rbtree.o t/log.o mutex.o smalloc.o gettime.o crc/md5.o \
 		lib/memalign.o lib/bloom.o t/debug.o crc/xxhash.o t/arch.o \
-		crc/murmur3.o crc/crc32c.o crc/crc32c-intel.o crc/fnv.o
+		crc/murmur3.o crc/crc32c.o crc/crc32c-intel.o crc/crc32c-arm64.o crc/fnv.o
 T_DEDUPE_PROGS = t/fio-dedupe
 
-T_VS_OBJS = t/verify-state.o t/log.o crc/crc32c.o crc/crc32c-intel.o t/debug.o
+T_VS_OBJS = t/verify-state.o t/log.o crc/crc32c.o crc/crc32c-intel.o crc/crc32c-arm64.o t/debug.o
 T_VS_PROGS = t/fio-verify-state
 
 T_PIPE_ASYNC_OBJS = t/read-to-pipe-async.o
diff --git a/arch/arch-aarch64.h b/arch/arch-aarch64.h
index 2a86cc5..0912a86 100644
--- a/arch/arch-aarch64.h
+++ b/arch/arch-aarch64.h
@@ -27,4 +27,8 @@ static inline int arch_ffz(unsigned long bitmask)
 
 #define ARCH_HAVE_FFZ
 
+#ifdef ARCH_HAVE_CRC_CRYPTO
+#define ARCH_HAVE_ARM64_CRC_CRYPTO
+#endif
+
 #endif
diff --git a/configure b/configure
index fc15782..7de88f8 100755
--- a/configure
+++ b/configure
@@ -342,6 +342,8 @@ elif check_define __s390__ ; then
   fi
 elif check_define __arm__ ; then
   cpu="arm"
+elif check_define __aarch64__ ; then
+  cpu="aarch64"
 elif check_define __hppa__ ; then
   cpu="hppa"
 else
@@ -362,6 +364,9 @@ case "$cpu" in
   armv*b|armv*l|arm)
     cpu="arm"
   ;;
+  aarch64)
+    cpu="arm64"
+  ;;
   hppa|parisc|parisc64)
     cpu="hppa"
   ;;
@@ -1780,6 +1785,24 @@ if compile_prog "" "" "bool"; then
 fi
 echo "bool                          $have_bool"
 
+##########################################
+# check march=armv8-a+crc+crypto
+march_armv8_a_crc_crypto="no"
+if test "$cpu" = "arm64" ; then
+  cat > $TMPC <<EOF
+int main(void)
+{
+  return 0;
+}
+EOF
+  if compile_prog "-march=armv8-a+crc+crypto" "" ""; then
+    march_armv8_a_crc_crypto="yes"
+    CFLAGS="$CFLAGS -march=armv8-a+crc+crypto -DARCH_HAVE_CRC_CRYPTO"
+  fi
+fi
+echo "march_armv8_a_crc_crypto      $march_armv8_a_crc_crypto"
+
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
diff --git a/crc/crc32c-arm64.c b/crc/crc32c-arm64.c
new file mode 100644
index 0000000..c3f42c7
--- /dev/null
+++ b/crc/crc32c-arm64.c
@@ -0,0 +1,115 @@
+#include "crc32c.h"
+
+#define CRC32C3X8(ITR) \
+	crc1 = __crc32cd(crc1, *((const uint64_t *)data + 42*1 + (ITR)));\
+	crc2 = __crc32cd(crc2, *((const uint64_t *)data + 42*2 + (ITR)));\
+	crc0 = __crc32cd(crc0, *((const uint64_t *)data + 42*0 + (ITR)));
+
+#define CRC32C7X3X8(ITR) do {\
+	CRC32C3X8((ITR)*7+0) \
+	CRC32C3X8((ITR)*7+1) \
+	CRC32C3X8((ITR)*7+2) \
+	CRC32C3X8((ITR)*7+3) \
+	CRC32C3X8((ITR)*7+4) \
+	CRC32C3X8((ITR)*7+5) \
+	CRC32C3X8((ITR)*7+6) \
+	} while(0)
+
+#ifndef HWCAP_CRC32
+#define HWCAP_CRC32             (1 << 7)
+#endif /* HWCAP_CRC32 */
+
+int crc32c_arm64_available = 0;
+
+#ifdef ARCH_HAVE_ARM64_CRC_CRYPTO
+
+#include <sys/auxv.h>
+#include <arm_acle.h>
+#include <arm_neon.h>
+
+static int crc32c_probed;
+
+/*
+ * Function to calculate reflected crc with PMULL Instruction
+ * crc done "by 3" for fixed input block size of 1024 bytes
+ */
+uint32_t crc32c_arm64(unsigned char const *data, unsigned long length)
+{
+	signed long len = length;
+	uint32_t crc = ~0;
+	uint32_t crc0, crc1, crc2;
+
+	/* Load two consts: K1 and K2 */
+	const poly64_t k1 = 0xe417f38a, k2 = 0x8f158014;
+	uint64_t t0, t1;
+
+	while ((len -= 1024) >= 0) {
+		/* Do first 8 bytes here for better pipelining */
+		crc0 = __crc32cd(crc, *(const uint64_t *)data);
+		crc1 = 0;
+		crc2 = 0;
+		data += sizeof(uint64_t);
+
+		/* Process block inline
+		   Process crc0 last to avoid dependency with above */
+		CRC32C7X3X8(0);
+		CRC32C7X3X8(1);
+		CRC32C7X3X8(2);
+		CRC32C7X3X8(3);
+		CRC32C7X3X8(4);
+		CRC32C7X3X8(5);
+
+		data += 42*3*sizeof(uint64_t);
+
+		/* Merge crc0 and crc1 into crc2
+		   crc1 multiply by K2
+		   crc0 multiply by K1 */
+
+		t1 = (uint64_t)vmull_p64(crc1, k2);
+		t0 = (uint64_t)vmull_p64(crc0, k1);
+		crc = __crc32cd(crc2, *(const uint64_t *)data);
+		crc1 = __crc32cd(0, t1);
+		crc ^= crc1;
+		crc0 = __crc32cd(0, t0);
+		crc ^= crc0;
+
+		data += sizeof(uint64_t);
+	}
+
+	if (!(len += 1024))
+		return crc;
+
+	while ((len -= sizeof(uint64_t)) >= 0) {
+                crc = __crc32cd(crc, *(const uint64_t *)data);
+                data += sizeof(uint64_t);
+        }
+
+        /* The following is more efficient than the straight loop */
+        if (len & sizeof(uint32_t)) {
+                crc = __crc32cw(crc, *(const uint32_t *)data);
+                data += sizeof(uint32_t);
+        }
+        if (len & sizeof(uint16_t)) {
+                crc = __crc32ch(crc, *(const uint16_t *)data);
+                data += sizeof(uint16_t);
+        }
+        if (len & sizeof(uint8_t)) {
+                crc = __crc32cb(crc, *(const uint8_t *)data);
+        }
+
+	return crc;
+}
+
+void crc32c_arm64_probe(void)
+{
+	unsigned long hwcap;
+
+	if (!crc32c_probed) {
+		hwcap = getauxval(AT_HWCAP);
+		if (hwcap & HWCAP_CRC32)
+			crc32c_arm64_available = 1;
+		crc32c_probed = 1;
+	}
+}
+
+#endif /* ARCH_HAVE_ARM64_CRC_CRYPTO */
diff --git a/crc/crc32c.h b/crc/crc32c.h
index 11bcf9c..5d66407 100644
--- a/crc/crc32c.h
+++ b/crc/crc32c.h
@@ -21,8 +21,19 @@
 #include "../arch/arch.h"
 
 extern uint32_t crc32c_sw(unsigned char const *, unsigned long);
+extern int crc32c_arm64_available;
 extern int crc32c_intel_available;
 
+#ifdef ARCH_HAVE_ARM64_CRC_CRYPTO
+extern uint32_t crc32c_arm64(unsigned char const *, unsigned long);
+extern void crc32c_arm64_probe(void);
+#else
+#define crc32c_arm64 crc32c_sw
+static inline void crc32c_arm64_probe(void)
+{
+}
+#endif
+
 #ifdef ARCH_HAVE_SSE4_2
 extern uint32_t crc32c_intel(unsigned char const *, unsigned long);
 extern void crc32c_intel_probe(void);
@@ -35,6 +46,9 @@ static inline void crc32c_intel_probe(void)
 
 static inline uint32_t fio_crc32c(unsigned char const *buf, unsigned long len)
 {
+	if (crc32c_arm64_available)
+		return crc32c_arm64(buf, len);
+
 	if (crc32c_intel_available)
 		return crc32c_intel(buf, len);
 
diff --git a/crc/test.c b/crc/test.c
index 300000d..78f19ac 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -291,6 +291,7 @@ int fio_crctest(const char *type)
 	int i, first = 1;
 	void *buf;
 
+	crc32c_arm64_probe();
 	crc32c_intel_probe();
 
 	if (!type)
diff --git a/lib/bloom.c b/lib/bloom.c
index fa38db9..7a9ebaa 100644
--- a/lib/bloom.c
+++ b/lib/bloom.c
@@ -65,6 +65,7 @@ struct bloom *bloom_new(uint64_t entries)
 	struct bloom *b;
 	size_t no_uints;
 
+	crc32c_arm64_probe();
 	crc32c_intel_probe();
 
 	b = malloc(sizeof(*b));
diff --git a/options.c b/options.c
index 1ca16e8..5886c50 100644
--- a/options.c
+++ b/options.c
@@ -2647,6 +2647,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = VERIFY_CRC32C,
 			    .help = "Use crc32c checksums for verification (hw assisted, if available)",
 			  },
+			  { .ival = "crc32c-arm64",
+			    .oval = VERIFY_CRC32C,
+			    .help = "Use crc32c checksums for verification (hw assisted, if available)",
+			  },
 			  { .ival = "crc32c",
 			    .oval = VERIFY_CRC32C,
 			    .help = "Use crc32c checksums for verification (hw assisted, if available)",
diff --git a/verify.c b/verify.c
index 790ab31..8733feb 100644
--- a/verify.c
+++ b/verify.c
@@ -1210,7 +1210,9 @@ nothing:
 void fio_verify_init(struct thread_data *td)
 {
 	if (td->o.verify == VERIFY_CRC32C_INTEL ||
+	    td->o.verify == VERIFY_CRC32C_ARM64 ||
 	    td->o.verify == VERIFY_CRC32C) {
+		crc32c_arm64_probe();
 		crc32c_intel_probe();
 	}
 }
diff --git a/verify.h b/verify.h
index deb161e..8d40ff6 100644
--- a/verify.h
+++ b/verify.h
@@ -15,6 +15,7 @@ enum {
 	VERIFY_CRC64,			/* crc64 sum data blocks */
 	VERIFY_CRC32,			/* crc32 sum data blocks */
 	VERIFY_CRC32C,			/* crc32c sum data blocks */
+	VERIFY_CRC32C_ARM64,		/* crc32c sum data blocks with hw */
 	VERIFY_CRC32C_INTEL,		/* crc32c sum data blocks with hw */
 	VERIFY_CRC16,			/* crc16 sum data blocks */
 	VERIFY_CRC7,			/* crc7 sum data blocks */
