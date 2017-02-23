Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45722 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbdBWNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 Feb 2017 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cgt07-0003ev-6S
        for fio@vger.kernel.org; Thu, 23 Feb 2017 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170223130001.EDE732C0086@kernel.dk>
Date: Thu, 23 Feb 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8983ce71bc3aa4076cb0c9f2b5c3b73ab7c7de93:

  init: use 'bool' for get_new_job() (2017-02-21 20:53:48 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 484817a95764dc7ba83b9f16c417bd727813043a:

  configure: disable compile time asserts for !opt and !static_assert (2017-02-22 09:00:06 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      configure: disable compile time asserts for !opt and !static_assert

 compiler/compiler.h | 8 +++++++-
 configure           | 3 +++
 2 files changed, 10 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/compiler/compiler.h b/compiler/compiler.h
index a6a7432..20df21d 100644
--- a/compiler/compiler.h
+++ b/compiler/compiler.h
@@ -38,10 +38,12 @@
 #if defined(CONFIG_STATIC_ASSERT)
 #define compiletime_assert(condition, msg) _Static_assert(condition, msg)
 
-#else
+#elif !defined(CONFIG_DISABLE_OPTIMIZATIONS)
+
 #ifndef __compiletime_error
 #define __compiletime_error(message)
 #endif
+
 #ifndef __compiletime_error_fallback
 #define __compiletime_error_fallback(condition)	do { } while (0)
 #endif
@@ -61,6 +63,10 @@
 #define compiletime_assert(condition, msg) \
 	_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
 
+#else
+
+#define compiletime_assert(condition, msg)	do { } while (0)
+
 #endif
 
 #endif
diff --git a/configure b/configure
index 44d215f..15b87fa 100755
--- a/configure
+++ b/configure
@@ -2041,6 +2041,9 @@ fi
 if test "$have_bool" = "yes" ; then
   output_sym "CONFIG_HAVE_BOOL"
 fi
+if test "$disable_opt" = "yes" ; then
+  output_sym "CONFIG_DISABLE_OPTIMIZATIONS"
+fi
 
 if test "$zlib" = "no" ; then
   echo "Consider installing zlib-dev (zlib-devel), some fio features depend on it."
