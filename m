Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:54487 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934146AbcLTXxe (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Dec 2016 18:53:34 -0500
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id 3507561CF8
        for <fio@vger.kernel.org>; Tue, 20 Dec 2016 23:53:33 +0000 (UTC)
Received: from g2t2360.austin.hpecorp.net (g2t2360.austin.hpecorp.net [16.196.225.135])
        by g2t2352.austin.hpe.com (Postfix) with ESMTP id 27E9652
        for <fio@vger.kernel.org>; Tue, 20 Dec 2016 23:53:32 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 1/2] pmemblk: clean up error logs
Date: Tue, 20 Dec 2016 17:56:37 -0600
Message-Id: <20161220235638.35477-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

From: Robert Elliott <elliott@hpe.com>

Print the errno string rather than the number, and prefix
all log_err prints with pmemblk rather than fio.
---
 engines/pmemblk.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index ca72697..977a02b 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -119,7 +119,7 @@ int load_libpmemblk(const char *path)
 	return 0;
 
 errorout:
-	log_err("fio: unable to load libpmemblk: %s\n", dlerror());
+	log_err("pmemblk: unable to load libpmemblk: %s\n", dlerror());
 	if (dl)
 		dlclose(dl);
 
@@ -267,9 +267,8 @@ static fio_pmemblk_file_t pmb_open(const char *pathspec, int flags)
 			    pmemblk_create(path, bsize, fsize, 0644);
 		}
 		if (!pmb->pmb_pool) {
-			log_err
-			    ("fio: enable to open pmemblk pool file (errno %d)\n",
-			     errno);
+			log_err("pmemblk: unable to open pmemblk pool file %s (%s)\n",
+			     path, strerror(errno));
 			goto error;
 		}
 
@@ -331,14 +330,14 @@ static int pmb_get_flags(struct thread_data *td, uint64_t *pflags)
 	if (!td->o.use_thread) {
 		if (!thread_warned) {
 			thread_warned = 1;
-			log_err("fio: must set thread=1 for pmemblk engine\n");
+			log_err("pmemblk: must set thread=1 for pmemblk engine\n");
 		}
 		return 1;
 	}
 
 	if (!td->o.odirect && !odirect_warned) {
 		odirect_warned = 1;
-		log_info("fio: direct == 0, but pmemblk is always direct\n");
+		log_info("pmemblk: direct == 0, but pmemblk is always direct\n");
 	}
 
 	if (td->o.allow_create)
-- 
2.9.3

