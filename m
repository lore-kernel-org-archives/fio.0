Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404285AbgFYMAV (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Jun 2020 08:00:21 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EAAC061573
        for <fio@vger.kernel.org>; Thu, 25 Jun 2020 05:00:20 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1joQXz-00065e-QL
        for fio@vger.kernel.org; Thu, 25 Jun 2020 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200625120002.B8C371BC0CCB@kernel.dk>
Date: Thu, 25 Jun 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c7f72c4bdb3586025cc7c5da707e69cc7a1baf07:

  Merge branch 'master' of https://github.com/safl/fio (2020-06-23 12:41:35 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dc6143a58735b781820bb4e3094114078b055810:

  Merge branch 'compiler' of https://github.com/bvanassche/fio (2020-06-24 09:02:06 -0600)

----------------------------------------------------------------
Bart Van Assche (1):
      Merge compiler/gcc4.h into compiler/compiler.h

Jens Axboe (1):
      Merge branch 'compiler' of https://github.com/bvanassche/fio

 compiler/compiler-gcc4.h | 17 -----------------
 compiler/compiler.h      |  8 ++++----
 2 files changed, 4 insertions(+), 21 deletions(-)
 delete mode 100644 compiler/compiler-gcc4.h

---

Diff of recent changes:

diff --git a/compiler/compiler-gcc4.h b/compiler/compiler-gcc4.h
deleted file mode 100644
index e8701cf0..00000000
--- a/compiler/compiler-gcc4.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef FIO_COMPILER_GCC4_H
-#define FIO_COMPILER_GCC4_H
-
-#ifndef __must_check
-#define __must_check		__attribute__((warn_unused_result))
-#endif
-
-#define GCC_VERSION (__GNUC__ * 10000		\
-			+ __GNUC_MINOR__ * 100	\
-			+ __GNUC_PATCHLEVEL__)
-
-#if GCC_VERSION >= 40300
-#define __compiletime_warning(message)	__attribute__((warning(message)))
-#define __compiletime_error(message)	__attribute__((error(message)))
-#endif
-
-#endif
diff --git a/compiler/compiler.h b/compiler/compiler.h
index 8eba2929..8c0eb9d1 100644
--- a/compiler/compiler.h
+++ b/compiler/compiler.h
@@ -3,15 +3,15 @@
 
 /* IWYU pragma: begin_exports */
 #if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 9) || __clang_major__ >= 6
-#include "compiler-gcc4.h"
 #else
 #error Compiler too old, need at least gcc 4.9
 #endif
 /* IWYU pragma: end_exports */
 
-#ifndef __must_check
-#define __must_check
-#endif
+#define __must_check		__attribute__((warn_unused_result))
+
+#define __compiletime_warning(message)	__attribute__((warning(message)))
+#define __compiletime_error(message)	__attribute__((error(message)))
 
 /*
  * Mark unused variables passed to ops functions as unused, to silence gcc

