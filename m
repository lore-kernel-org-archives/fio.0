Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53918 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751755AbdIAMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Sep 2017 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dnkcK-0003oa-3L
        for fio@vger.kernel.org; Fri, 01 Sep 2017 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170901120002.6E8B62C00B0@kernel.dk>
Date: Fri,  1 Sep 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2b2fa7f5ecfd5cd5b54a209934b05b770e9c9301:

  lib/axmap: a few fixes/cleanups (2017-08-30 13:03:26 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 83070ccd1091a1c44ac838f95bab6811cbc287f5:

  t/axmap: we don't need smalloc/sfree wrappers (2017-08-31 08:34:27 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'verify_warn' of https://github.com/sitsofe/fio
      t/axmap: we don't need smalloc/sfree wrappers

Sitsofe Wheeler (2):
      verify: make overwriting verified blocks warning more specific
      verify: warn when verify pass won't be run

 init.c    | 23 ++++++++++++++++++++---
 t/axmap.c | 10 ----------
 2 files changed, 20 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 164e411..625c937 100644
--- a/init.c
+++ b/init.c
@@ -748,13 +748,30 @@ static int fixup_options(struct thread_data *td)
 		o->size = -1ULL;
 
 	if (o->verify != VERIFY_NONE) {
-		if (td_write(td) && o->do_verify && o->numjobs > 1) {
-			log_info("Multiple writers may overwrite blocks that "
-				"belong to other jobs. This can cause "
+		if (td_write(td) && o->do_verify && o->numjobs > 1 &&
+		    (o->filename ||
+		     !(o->unique_filename &&
+		       strstr(o->filename_format, "$jobname") &&
+		       strstr(o->filename_format, "$jobnum") &&
+		       strstr(o->filename_format, "$filenum")))) {
+			log_info("fio: multiple writers may overwrite blocks "
+				"that belong to other jobs. This can cause "
 				"verification failures.\n");
 			ret = warnings_fatal;
 		}
 
+		/*
+		 * Warn if verification is requested but no verification of any
+		 * kind can be started due to time constraints
+		 */
+		if (td_write(td) && o->do_verify && o->timeout &&
+		    o->time_based && !td_read(td) && !o->verify_backlog) {
+			log_info("fio: verification read phase will never "
+				 "start because write phase uses all of "
+				 "runtime\n");
+			ret = warnings_fatal;
+		}
+
 		if (!fio_option_is_set(o, refill_buffers))
 			o->refill_buffers = 1;
 
diff --git a/t/axmap.c b/t/axmap.c
index e32ff98..a803ce4 100644
--- a/t/axmap.c
+++ b/t/axmap.c
@@ -8,16 +8,6 @@
 #include "../lib/lfsr.h"
 #include "../lib/axmap.h"
 
-void *smalloc(size_t size)
-{
-	return malloc(size);
-}
-
-void sfree(void *ptr)
-{
-	free(ptr);
-}
-
 static int test_regular(size_t size, int seed)
 {
 	struct fio_lfsr lfsr;
