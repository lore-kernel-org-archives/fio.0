Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB18C3DA6F
	for <fio@archiver.kernel.org>; Thu, 24 Aug 2023 12:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjHXMAo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 24 Aug 2023 08:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241186AbjHXMAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 24 Aug 2023 08:00:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BA41995
        for <fio@vger.kernel.org>; Thu, 24 Aug 2023 05:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=c6IzTaJg58J+RBFOopEGrYPWy4e1G6S07ZGoOl3uZSE=; b=FGpgTQ7qpDSdCMPu4lVR54ZV4+
        PK+XkmsScc9v1shaVK8o1N5Qqv1VaYbkGeBICAvj8OcRFVd1GQU21tF/8O8dI3h0x7L22NJjhwAyi
        xA2A3NA92vgrRQ0PkrVQYhgtUuor++DMX9IyzwC979AxTMK5iC9CJzlCIThns6/E03h9UPdLwo1ch
        RDztaxolhROfR1vzPpVVZJVzJdz9yoX3AMVJSYvqb86BVPsQ9Vb0XI/49CLRTxevAURyXzzFtllUf
        reZDK3PMK26+XNNkdnrR3APs3r0Zz/YUjHvMMdo4T6oo/X8lmSIkD41ccgUS/+nj/daulNLPDg1dk
        e1I8brng==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qZ90U-00Al5S-Ms
        for fio@vger.kernel.org; Thu, 24 Aug 2023 12:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 2B9F71BC0139; Thu, 24 Aug 2023 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230824120002.2B9F71BC0139@kernel.dk>
Date:   Thu, 24 Aug 2023 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit b311162c37a2867873e1222ce6b5f38c88be4d80:

  examples: add example and fiograph for protection information options (2023-08-16 09:34:46 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4a0c766c69ddfe5231d65f2676e97333ba89ab2b:

  Merge branch 'master' of https://github.com/michalbiesek/fio (2023-08-23 08:21:39 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/michalbiesek/fio

Michal Biesek (1):
      Add RISC-V 64 support

 arch/arch-riscv64.h   | 32 ++++++++++++++++++++++++++++++++
 arch/arch.h           |  3 +++
 configure             | 24 +++++++++++++++++++++++-
 libfio.c              |  1 +
 os/os-linux-syscall.h |  7 +++++++
 5 files changed, 66 insertions(+), 1 deletion(-)
 create mode 100644 arch/arch-riscv64.h

---

Diff of recent changes:

diff --git a/arch/arch-riscv64.h b/arch/arch-riscv64.h
new file mode 100644
index 00000000..a74b7d47
--- /dev/null
+++ b/arch/arch-riscv64.h
@@ -0,0 +1,32 @@
+#ifndef ARCH_RISCV64_H
+#define ARCH_RISCV64_H
+
+#include <unistd.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#define FIO_ARCH	(arch_riscv64)
+
+#define nop		__asm__ __volatile__ ("nop")
+#define read_barrier()		__asm__ __volatile__("fence r, r": : :"memory")
+#define write_barrier()		__asm__ __volatile__("fence w, w": : :"memory")
+
+static inline unsigned long long get_cpu_clock(void)
+{
+	unsigned long val;
+
+	asm volatile("rdcycle %0" : "=r"(val));
+	return val;
+}
+#define ARCH_HAVE_CPU_CLOCK
+
+#define ARCH_HAVE_INIT
+extern bool tsc_reliable;
+static inline int arch_init(char *envp[])
+{
+	tsc_reliable = true;
+	return 0;
+}
+
+#endif
diff --git a/arch/arch.h b/arch/arch.h
index 6e476701..3ee9b053 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -24,6 +24,7 @@ enum {
 	arch_mips,
 	arch_aarch64,
 	arch_loongarch64,
+	arch_riscv64,
 
 	arch_generic,
 
@@ -100,6 +101,8 @@ extern unsigned long arch_flags;
 #include "arch-aarch64.h"
 #elif defined(__loongarch64)
 #include "arch-loongarch64.h"
+#elif defined(__riscv) && __riscv_xlen == 64
+#include "arch-riscv64.h"
 #else
 #warning "Unknown architecture, attempting to use generic model."
 #include "arch-generic.h"
diff --git a/configure b/configure
index 6c938251..36184a58 100755
--- a/configure
+++ b/configure
@@ -133,6 +133,20 @@ EOF
   compile_object
 }
 
+check_val() {
+    cat > $TMPC <<EOF
+#if $1 == $2
+int main(void)
+{
+  return 0;
+}
+#else
+#error $1 is not equal $2
+#endif
+EOF
+  compile_object
+}
+
 output_sym() {
   echo "$1=y" >> $config_host_mak
   echo "#define $1" >> $config_host_h
@@ -501,13 +515,21 @@ elif check_define __hppa__ ; then
   cpu="hppa"
 elif check_define __loongarch64 ; then
   cpu="loongarch64"
+elif check_define __riscv ; then
+  if check_val __riscv_xlen 32 ; then
+    cpu="riscv32"
+  elif check_val __riscv_xlen 64 ; then
+    cpu="riscv64"
+  elif check_val __riscv_xlen 128 ; then
+    cpu="riscv128"
+  fi
 else
   cpu=`uname -m`
 fi
 
 # Normalise host CPU name and set ARCH.
 case "$cpu" in
-  ia64|ppc|ppc64|s390|s390x|sparc64|loongarch64)
+  ia64|ppc|ppc64|s390|s390x|sparc64|loongarch64|riscv64)
     cpu="$cpu"
   ;;
   i386|i486|i586|i686|i86pc|BePC)
diff --git a/libfio.c b/libfio.c
index 5e3fd30b..237ce34c 100644
--- a/libfio.c
+++ b/libfio.c
@@ -75,6 +75,7 @@ static const char *fio_arch_strings[arch_nr] = {
 	"mips",
 	"aarch64",
 	"loongarch64",
+	"riscv64",
 	"generic"
 };
 
diff --git a/os/os-linux-syscall.h b/os/os-linux-syscall.h
index 67ee4d91..626330ad 100644
--- a/os/os-linux-syscall.h
+++ b/os/os-linux-syscall.h
@@ -286,6 +286,13 @@
 #define __NR_sys_tee          	77
 #define __NR_sys_vmsplice       75
 #endif
+
+/* Linux syscalls for riscv64 */
+#elif defined(ARCH_RISCV64_H)
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		30
+#define __NR_ioprio_get		31
+#endif
 #else
 #warning "Unknown architecture"
 #endif
