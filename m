Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbgHSMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Aug 2020 08:00:09 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F9DC061757
        for <fio@vger.kernel.org>; Wed, 19 Aug 2020 05:00:05 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8Ml9-0000Nv-6z
        for fio@vger.kernel.org; Wed, 19 Aug 2020 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200819120001.5AE1F1BC0190@kernel.dk>
Date: Wed, 19 Aug 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 09c1aa8b322765afae56ea1ebc9eaa06f94da6a6:

  engines/windowsaio: only set IOCP thread affinity if specified (2020-08-17 15:42:16 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3c1f3ca75b447a2bd0a93deb0a2a1210529d2ccb:

  Merge branch 'filelock_assert_fix' of https://github.com/bardavid/fio into master (2020-08-18 08:33:49 -0700)

----------------------------------------------------------------
David, Bar (1):
      filelock: fix wrong file trylock assertion.

Jens Axboe (2):
      Merge branch 'asprintf1' of https://github.com/kusumi/fio into master
      Merge branch 'filelock_assert_fix' of https://github.com/bardavid/fio into master

Tomohiro Kusumi (1):
      oslib: fix asprintf build failure

 filelock.c       | 2 +-
 oslib/asprintf.c | 1 -
 oslib/asprintf.h | 2 ++
 3 files changed, 3 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/filelock.c b/filelock.c
index 7e92f63d..fd3a6b29 100644
--- a/filelock.c
+++ b/filelock.c
@@ -179,7 +179,7 @@ static bool __fio_lock_file(const char *fname, int trylock)
 	fio_sem_up(&fld->lock);
 
 	if (!ff) {
-		assert(!trylock);
+		assert(trylock);
 		return true;
 	}
 
diff --git a/oslib/asprintf.c b/oslib/asprintf.c
index ff503c52..2d9f811c 100644
--- a/oslib/asprintf.c
+++ b/oslib/asprintf.c
@@ -1,4 +1,3 @@
-#include <stdarg.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include "oslib/asprintf.h"
diff --git a/oslib/asprintf.h b/oslib/asprintf.h
index 7425300f..43bbb56b 100644
--- a/oslib/asprintf.h
+++ b/oslib/asprintf.h
@@ -1,6 +1,8 @@
 #ifndef FIO_ASPRINTF_H
 #define FIO_ASPRINTF_H
 
+#include <stdarg.h>
+
 #ifndef CONFIG_HAVE_VASPRINTF
 int vasprintf(char **strp, const char *fmt, va_list ap);
 #endif

