Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42248 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752377AbeDJMAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 10 Apr 2018 08:00:16 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1f5rwe-0000JF-1h
        for fio@vger.kernel.org; Tue, 10 Apr 2018 12:00:16 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180410120002.67FC52C007A@kernel.dk>
Date: Tue, 10 Apr 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9fac0db7a09bac08bbff9b213d3b1daceee07679:

  steadystate: check for division by zero in mean calculation (2018-04-08 15:54:26 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cb73748b9af3d678eb6ad0af7b9cea5a2ea1999e:

  stat: remove dead 'nr_uninit' assignment (2018-04-09 08:10:40 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      init: fix memory leak in error handling
      stat: remove dead 'nr_uninit' assignment

 init.c | 3 ++-
 stat.c | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 0b6fedd..f5ff73d 100644
--- a/init.c
+++ b/init.c
@@ -1970,7 +1970,8 @@ static int __parse_jobs_ini(struct thread_data *td,
 			if (p[0] == '[') {
 				if (nested) {
 					log_err("No new sections in included files\n");
-					return 1;
+					ret = 1;
+					goto out;
 				}
 
 				skip_fgets = 1;
diff --git a/stat.c b/stat.c
index a837ed9..7b9dd3b 100644
--- a/stat.c
+++ b/stat.c
@@ -670,7 +670,6 @@ static int calc_block_percentiles(int nr_block_infos, uint32_t *block_infos,
 	if (len > 1)
 		qsort((void *)plist, len, sizeof(plist[0]), double_cmp);
 
-	nr_uninit = 0;
 	/* Start only after the uninit entries end */
 	for (nr_uninit = 0;
 	     nr_uninit < nr_block_infos
