Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA6AC77B7F
	for <fio@archiver.kernel.org>; Sat, 20 May 2023 12:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjETMAV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 20 May 2023 08:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjETMAV (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 20 May 2023 08:00:21 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF45693
        for <fio@vger.kernel.org>; Sat, 20 May 2023 05:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=XkSWZblaI/KmT8qp17/g6m7GPPNqGJZ+z1NdhGXfmOU=; b=KeVaxTjaIW87LTkbeoSEMFQEO6
        mbMRrNzoo5AeQht/6mGH687oJIE+MV29WGSR67CO966gnFsUE0DOyc8yGuaOlA6Ap36hufwsHanm5
        rHpqge8TVlvXSfb9rkCAP/cKQrj4F4edKiVD4plCOHcn3ieap+LwPSSRTzJVwILKn2UT/+sW17hND
        pj7CFr8P4/yn4FHj6HfKK5SCPGAo2wag5ZrJh+jDh6LlycqAk5dPRdDAJBR0fTWhegs+6737AYvwl
        ntI1Q75v1tuUMtoFtRpTxgEe5ulzncWV7DuTeAHiHYRZzlep2IMuSHP7P8PIatXtSDLHv2Q2rzsDY
        0BC3UOKg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q0LFo-00Gebs-2K
        for fio@vger.kernel.org;
        Sat, 20 May 2023 12:00:13 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 6F6DD1BC0155; Sat, 20 May 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230520120001.6F6DD1BC0155@kernel.dk>
Date:   Sat, 20 May 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 5cedafafeeb9dde862455342cd24c860d84f4f07:

  ci: fix ups for 32-bit GitHub Actions Linux builds (2023-05-18 14:29:10 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 870ea00243b1290541334bec2a56428c9f68dba6:

  io_ur: make sure that sync errors are noticed upfront (2023-05-19 19:30:38 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'master' of https://github.com/huajingyun01/fio
      io_ur: make sure that sync errors are noticed upfront

Jingyun Hua (1):
      Add LoongArch64 support

 arch/arch-loongarch64.h | 10 ++++++++++
 arch/arch.h             |  3 +++
 configure               |  4 +++-
 io_u.c                  |  3 +++
 libfio.c                |  1 +
 os/os-linux-syscall.h   | 16 ++++++++++++++++
 6 files changed, 36 insertions(+), 1 deletion(-)
 create mode 100644 arch/arch-loongarch64.h

---

Diff of recent changes:

diff --git a/arch/arch-loongarch64.h b/arch/arch-loongarch64.h
new file mode 100644
index 00000000..43ea83b4
--- /dev/null
+++ b/arch/arch-loongarch64.h
@@ -0,0 +1,10 @@
+#ifndef ARCH_LOONGARCH64_H
+#define ARCH_LOONGARCH64_H
+
+#define FIO_ARCH	(arch_loongarch64)
+
+#define read_barrier()		__asm__ __volatile__("dbar 0": : :"memory")
+#define write_barrier()		__asm__ __volatile__("dbar 0": : :"memory")
+#define nop			__asm__ __volatile__("dbar 0": : :"memory")
+
+#endif
diff --git a/arch/arch.h b/arch/arch.h
index fca003be..6e476701 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -23,6 +23,7 @@ enum {
 	arch_hppa,
 	arch_mips,
 	arch_aarch64,
+	arch_loongarch64,
 
 	arch_generic,
 
@@ -97,6 +98,8 @@ extern unsigned long arch_flags;
 #include "arch-hppa.h"
 #elif defined(__aarch64__)
 #include "arch-aarch64.h"
+#elif defined(__loongarch64)
+#include "arch-loongarch64.h"
 #else
 #warning "Unknown architecture, attempting to use generic model."
 #include "arch-generic.h"
diff --git a/configure b/configure
index ca03350b..74416fd4 100755
--- a/configure
+++ b/configure
@@ -499,13 +499,15 @@ elif check_define __aarch64__ ; then
   cpu="aarch64"
 elif check_define __hppa__ ; then
   cpu="hppa"
+elif check_define __loongarch64 ; then
+  cpu="loongarch64"
 else
   cpu=`uname -m`
 fi
 
 # Normalise host CPU name and set ARCH.
 case "$cpu" in
-  ia64|ppc|ppc64|s390|s390x|sparc64)
+  ia64|ppc|ppc64|s390|s390x|sparc64|loongarch64)
     cpu="$cpu"
   ;;
   i386|i486|i586|i686|i86pc|BePC)
diff --git a/io_u.c b/io_u.c
index 30265cfb..6f5fc94d 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2027,6 +2027,8 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 	}
 
 	if (ddir_sync(ddir)) {
+		if (io_u->error)
+			goto error;
 		td->last_was_sync = true;
 		if (f) {
 			f->first_write = -1ULL;
@@ -2082,6 +2084,7 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 				icd->error = ret;
 		}
 	} else if (io_u->error) {
+error:
 		icd->error = io_u->error;
 		io_u_log_error(td, io_u);
 	}
diff --git a/libfio.c b/libfio.c
index ddd49cd7..5e3fd30b 100644
--- a/libfio.c
+++ b/libfio.c
@@ -74,6 +74,7 @@ static const char *fio_arch_strings[arch_nr] = {
 	"hppa",
 	"mips",
 	"aarch64",
+	"loongarch64",
 	"generic"
 };
 
diff --git a/os/os-linux-syscall.h b/os/os-linux-syscall.h
index c399b2fa..67ee4d91 100644
--- a/os/os-linux-syscall.h
+++ b/os/os-linux-syscall.h
@@ -270,6 +270,22 @@
 #define __NR_ioprio_get		31
 #endif
 
+/* Linux syscalls for loongarch64 */
+#elif defined(ARCH_LOONGARCH64_H)
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set         30
+#define __NR_ioprio_get         31
+#endif
+
+#ifndef __NR_fadvise64
+#define __NR_fadvise64          223
+#endif
+
+#ifndef __NR_sys_splice
+#define __NR_sys_splice         76
+#define __NR_sys_tee          	77
+#define __NR_sys_vmsplice       75
+#endif
 #else
 #warning "Unknown architecture"
 #endif
