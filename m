Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbgG1MAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 28 Jul 2020 08:00:08 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4331FC061794
        for <fio@vger.kernel.org>; Tue, 28 Jul 2020 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0OH6-00008F-AH
        for fio@vger.kernel.org; Tue, 28 Jul 2020 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200728120001.EBAF61BC01B9@kernel.dk>
Date: Tue, 28 Jul 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 11b280c158db01744effde3863bfe9c65f7af090:

  t/jobs/t001[1-2].fio: run for 10 seconds instead of 3 (2020-07-26 22:19:47 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b5aba537d844f73187eb931179ac59e7da570e7c:

  iolog: ensure that dynamic log entries are at least queue depth sized (2020-07-27 16:00:20 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Add roundup_pow2() as a generic helper
      iolog: ensure that dynamic log entries are at least queue depth sized

 engines/io_uring.c |  6 +-----
 iolog.c            |  6 +++++-
 lib/roundup.h      | 11 +++++++++++
 3 files changed, 17 insertions(+), 6 deletions(-)
 create mode 100644 lib/roundup.h

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index ecff0657..0ccd2318 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -17,6 +17,7 @@
 #include "../optgroup.h"
 #include "../lib/memalign.h"
 #include "../lib/fls.h"
+#include "../lib/roundup.h"
 
 #ifdef ARCH_HAVE_IOURING
 
@@ -654,11 +655,6 @@ static int fio_ioring_post_init(struct thread_data *td)
 	return 0;
 }
 
-static unsigned roundup_pow2(unsigned depth)
-{
-	return 1UL << __fls(depth - 1);
-}
-
 static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o = td->eo;
diff --git a/iolog.c b/iolog.c
index 4a79fc46..4af10da3 100644
--- a/iolog.c
+++ b/iolog.c
@@ -19,6 +19,7 @@
 #include "smalloc.h"
 #include "blktrace.h"
 #include "pshared.h"
+#include "lib/roundup.h"
 
 #include <netinet/in.h>
 #include <netinet/tcp.h>
@@ -748,10 +749,13 @@ void setup_log(struct io_log **log, struct log_params *p,
 	}
 
 	if (l->td && l->td->o.io_submit_mode != IO_MODE_OFFLOAD) {
+		unsigned int def_samples = DEF_LOG_ENTRIES;
 		struct io_logs *__p;
 
 		__p = calloc(1, sizeof(*l->pending));
-		__p->max_samples = DEF_LOG_ENTRIES;
+		if (l->td->o.iodepth > DEF_LOG_ENTRIES)
+			def_samples = roundup_pow2(l->td->o.iodepth);
+		__p->max_samples = def_samples;
 		__p->log = calloc(__p->max_samples, log_entry_sz(l));
 		l->pending = __p;
 	}
diff --git a/lib/roundup.h b/lib/roundup.h
new file mode 100644
index 00000000..5a99c8ac
--- /dev/null
+++ b/lib/roundup.h
@@ -0,0 +1,11 @@
+#ifndef FIO_ROUNDUP_H
+#define FIO_ROUNDUP_H
+
+#include "lib/fls.h"
+
+static inline unsigned roundup_pow2(unsigned depth)
+{
+	return 1UL << __fls(depth - 1);
+}
+
+#endif

