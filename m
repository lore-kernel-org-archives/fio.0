Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D352C05027
	for <fio@archiver.kernel.org>; Thu, 26 Jan 2023 13:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjAZNAj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 26 Jan 2023 08:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbjAZNAf (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 Jan 2023 08:00:35 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C034FCDD
        for <fio@vger.kernel.org>; Thu, 26 Jan 2023 05:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=GOPJovLpPYA3Pmj/ANjkek56LxiDQN6NxCbQqWGGpFE=; b=m8e5Xk2mZ3vCP4WcQ1o8Z+/xLf
        WTFE+SJTjRYDQiBBVoMgZZuI1Bs8Ch+3nZTt0NXpU78WmM5Zr/8IPmqnoXVJ87L4NFsU4uBkRJzQL
        diGlcZzRl3WQjBAmuY6WQJGpDUpebfUaze6n/aAegX78Z4czzqk39a9MJf7HJDdcGYcRNfX6dJX8m
        F07MdVpNI/BWJ04qlABfzNnuVJxvZtmJJwxow9CICuDcqsUHrVwy1hBnQ/kXDazcMJ2xfJqdLF+/b
        GQewCC/QjfCJIpPUtKVuPXN26eNhAZCfbjRZbZ4LESDYxStWveCp0lwKSwOcv4uWOe9rExpbm1xSr
        YhKvvKTw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pL1rK-006kL2-KG
        for fio@vger.kernel.org; Thu, 26 Jan 2023 13:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 2BC8A1BC016B; Thu, 26 Jan 2023 06:00:03 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230126130003.2BC8A1BC016B@kernel.dk>
Date:   Thu, 26 Jan 2023 06:00:03 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 5ca54c1ba2db849dfaef5fe3aec60329b3df0bd1:

  Makefile: add -Wno-stringop-truncation for y.tab.o (2023-01-24 21:07:37 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1e8ec88fd5f3ab4b7bbd0119708d94fd64a4e7ad:

  Enable crc32c accelleration for arm64 on OSX (2023-01-25 08:01:30 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Enable crc32c accelleration for arm64 on OSX

 configure   |  8 +++++---
 os/os-mac.h | 10 ++++++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index a17d1cda..182cd3c3 100755
--- a/configure
+++ b/configure
@@ -2685,20 +2685,22 @@ print_config "libblkio engine" "$libblkio"
 
 ##########################################
 # check march=armv8-a+crc+crypto
-if test "$march_armv8_a_crc_crypto" != "yes" ; then
-  march_armv8_a_crc_crypto="no"
-fi
+march_armv8_a_crc_crypto="no"
 if test "$cpu" = "arm64" ; then
   cat > $TMPC <<EOF
+#if __linux__
 #include <arm_acle.h>
 #include <arm_neon.h>
 #include <sys/auxv.h>
+#endif
 
 int main(void)
 {
   /* Can we also do a runtime probe? */
 #if __linux__
   return getauxval(AT_HWCAP);
+#elif defined(__APPLE__)
+  return 0;
 #else
 # error "Don't know how to do runtime probe for ARM CRC32c"
 #endif
diff --git a/os/os-mac.h b/os/os-mac.h
index ec2cc1e5..c9103c45 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -14,12 +14,14 @@
 #include <machine/endian.h>
 #include <libkern/OSByteOrder.h>
 
+#include "../arch/arch.h"
 #include "../file.h"
 
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_CHARDEV_SIZE
 #define FIO_HAVE_NATIVE_FALLOCATE
+#define FIO_HAVE_CPU_HAS
 
 #define OS_MAP_ANON		MAP_ANON
 
@@ -106,4 +108,12 @@ static inline bool fio_fallocate(struct fio_file *f, uint64_t offset, uint64_t l
 	return false;
 }
 
+static inline bool os_cpu_has(cpu_features feature)
+{
+	/* just check for arm on OSX for now, we know that has it */
+	if (feature != CPU_ARM64_CRC32C)
+		return false;
+	return FIO_ARCH == arch_aarch64;
+}
+
 #endif
