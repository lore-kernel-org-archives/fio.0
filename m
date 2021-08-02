Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbhHBMAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 2 Aug 2021 08:00:17 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC05C06175F
        for <fio@vger.kernel.org>; Mon,  2 Aug 2021 05:00:08 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mAWc2-0059KQ-CI
        for fio@vger.kernel.org; Mon, 02 Aug 2021 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210802120002.4D91B1BC013C@kernel.dk>
Date: Mon,  2 Aug 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7c8e6725155cae72a0a730d3c3a36776bc5621a3:

  Makefile: update libzbc git repository (2021-07-28 07:27:29 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 572782274da6f7223627f734c6e1818a03c71a6d:

  Merge branch 'master' of https://github.com/anson-lo/fio (2021-08-01 08:36:01 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/anson-lo/fio

anson-lo (1):
      Fix an error triggered by double releasing the lock

 verify.c | 1 -
 1 file changed, 1 deletion(-)

---

Diff of recent changes:

diff --git a/verify.c b/verify.c
index a418c054..0e1e4639 100644
--- a/verify.c
+++ b/verify.c
@@ -1411,7 +1411,6 @@ static void *verify_async_thread(void *data)
 			ret = pthread_cond_wait(&td->verify_cond,
 							&td->io_u_lock);
 			if (ret) {
-				pthread_mutex_unlock(&td->io_u_lock);
 				break;
 			}
 		}

