Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:32902 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751487AbeDYMAU (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 25 Apr 2018 08:00:20 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fBJ5w-0002n2-1d
        for fio@vger.kernel.org; Wed, 25 Apr 2018 12:00:20 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180425120001.D53532C00CF@kernel.dk>
Date: Wed, 25 Apr 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2e4ef4fbd69eb6d4c07f2f362463e3f3df2e808c:

  engines: fixup fio_q_status style violations (2018-04-20 09:46:19 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ca0a0b521e8650ed736246c00092094a4d5c9829:

  t/*: missing statics (2018-04-24 14:03:34 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      configure: use proper CONFIG_ prefix for asprintf/vasprintf
      engines/libaio: don't sleep for 0 reap return for 0 event check
      t/*: missing statics

 configure        | 4 ++--
 engines/libaio.c | 3 ++-
 oslib/asprintf.c | 4 ++--
 oslib/asprintf.h | 4 ++--
 t/lfsr-test.c    | 2 +-
 t/stest.c        | 2 +-
 6 files changed, 10 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 70cb006..9bdc7a1 100755
--- a/configure
+++ b/configure
@@ -2218,10 +2218,10 @@ if test "$posix_pshared" = "yes" ; then
   output_sym "CONFIG_PSHARED"
 fi
 if test "$have_asprintf" = "yes" ; then
-    output_sym "HAVE_ASPRINTF"
+    output_sym "CONFIG_HAVE_ASPRINTF"
 fi
 if test "$have_vasprintf" = "yes" ; then
-    output_sym "HAVE_VASPRINTF"
+    output_sym "CONFIG_HAVE_VASPRINTF"
 fi
 if test "$linux_fallocate" = "yes" ; then
   output_sym "CONFIG_LINUX_FALLOCATE"
diff --git a/engines/libaio.c b/engines/libaio.c
index f46b331..dae2a70 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -169,7 +169,8 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 			events += r;
 		else if ((min && r == 0) || r == -EAGAIN) {
 			fio_libaio_commit(td);
-			usleep(100);
+			if (actual_min)
+				usleep(10);
 		} else if (r != -EINTR)
 			break;
 	} while (events < min);
diff --git a/oslib/asprintf.c b/oslib/asprintf.c
index f1e7fd2..969479f 100644
--- a/oslib/asprintf.c
+++ b/oslib/asprintf.c
@@ -3,7 +3,7 @@
 #include <stdlib.h>
 #include "oslib/asprintf.h"
 
-#ifndef HAVE_VASPRINTF
+#ifndef CONFIG_HAVE_VASPRINTF
 int vasprintf(char **strp, const char *fmt, va_list ap)
 {
     va_list ap_copy;
@@ -28,7 +28,7 @@ int vasprintf(char **strp, const char *fmt, va_list ap)
 }
 #endif
 
-#ifndef HAVE_ASPRINTF
+#ifndef CONFIG_HAVE_ASPRINTF
 int asprintf(char **strp, const char *fmt, ...)
 {
     va_list arg;
diff --git a/oslib/asprintf.h b/oslib/asprintf.h
index 1aa076b..7425300 100644
--- a/oslib/asprintf.h
+++ b/oslib/asprintf.h
@@ -1,10 +1,10 @@
 #ifndef FIO_ASPRINTF_H
 #define FIO_ASPRINTF_H
 
-#ifndef HAVE_VASPRINTF
+#ifndef CONFIG_HAVE_VASPRINTF
 int vasprintf(char **strp, const char *fmt, va_list ap);
 #endif
-#ifndef HAVE_ASPRINTF
+#ifndef CONFIG_HAVE_ASPRINTF
 int asprintf(char **strp, const char *fmt, ...);
 #endif
 
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
index abdbafb..a01f2cf 100644
--- a/t/lfsr-test.c
+++ b/t/lfsr-test.c
@@ -7,7 +7,7 @@
 #include "../gettime.h"
 #include "../fio_time.h"
 
-void usage()
+static void usage(void)
 {
 	printf("Usage: lfsr-test 0x<numbers> [seed] [spin] [verify]\n");
 	printf("-------------------------------------------------------------\n");
diff --git a/t/stest.c b/t/stest.c
index 04df60d..b95968f 100644
--- a/t/stest.c
+++ b/t/stest.c
@@ -18,7 +18,7 @@ struct elem {
 	unsigned int magic2;
 };
 
-FLIST_HEAD(list);
+static FLIST_HEAD(list);
 
 static int do_rand_allocs(void)
 {
