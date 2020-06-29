Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731638AbgF2TOD (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 29 Jun 2020 15:14:03 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA78C0D9419
        for <fio@vger.kernel.org>; Mon, 29 Jun 2020 05:00:27 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jpsSI-00015a-Q0
        for fio@vger.kernel.org; Mon, 29 Jun 2020 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200629120002.B95371BC019A@kernel.dk>
Date: Mon, 29 Jun 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dc6143a58735b781820bb4e3094114078b055810:

  Merge branch 'compiler' of https://github.com/bvanassche/fio (2020-06-24 09:02:06 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 797ef7b209d7423f34dfe513beeede21d2efddc4:

  Merge branch 'pmemblk' of https://github.com/bvanassche/fio (2020-06-28 07:08:36 -0600)

----------------------------------------------------------------
Bart Van Assche (1):
      Unbreak the pmemblk engine

Jens Axboe (1):
      Merge branch 'pmemblk' of https://github.com/bvanassche/fio

 engines/pmemblk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index 730f4d77..e2eaa15e 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -220,14 +220,14 @@ static fio_pmemblk_file_t pmb_open(const char *pathspec, int flags)
 		pmb->pmb_nblocks = pmemblk_nblock(pmb->pmb_pool);
 
 		fio_pmemblk_cache_insert(pmb);
+	} else {
+		free(path);
 	}
 
 	pmb->pmb_refcnt += 1;
 
 	pthread_mutex_unlock(&CacheLock);
 
-	free(path);
-
 	return pmb;
 
 error:

