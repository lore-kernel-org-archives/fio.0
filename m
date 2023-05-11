Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2527C77B7C
	for <fio@archiver.kernel.org>; Thu, 11 May 2023 12:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238016AbjEKMBb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 11 May 2023 08:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237947AbjEKMAp (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 May 2023 08:00:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870FF9EF6
        for <fio@vger.kernel.org>; Thu, 11 May 2023 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=pOl4WxVIDpQ1BMpxlWMok5y8khXRtyaqDwZygm28N3Y=; b=asAf1YF4TpSlwO/2RwQkTNQb5y
        U/z8kAP0mAAnh7LRsMH7VFXzFCej2QabsBhMHuIBfYaP5hqjAjQ2baivx5c4W7Kbj76IetcIrLQ3j
        HsM+lPCJnHyRRvwDgJ3+j0qG+79IhYGOEnzMPd5Av6jkI0iYoFpVOEnmzzJgX0D+YW8zi1weIfhXw
        z+l6sQNYKobJqJmR4E7o11QmHG1kgdWx+0bDwKx5i/iGSIb7l6beM6bVwfqXzhe+saqB6N0kXWjJJ
        sw5SyxILlHhgsyDWlBr/hP3r1Cc9XjcjW/GMDP1RsoDXzKbaAN0pSvnLqJaBMoLr9Uxgj8MXQwr5q
        VLlJplhw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1px4xo-00HBYr-Qj
        for fio@vger.kernel.org; Thu, 11 May 2023 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 83EE11BC0136; Thu, 11 May 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230511120001.83EE11BC0136@kernel.dk>
Date:   Thu, 11 May 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 0771592f81fcb032e261b18212477ceffc6cdac5:

  Merge branch 'master' of https://github.com/bvanassche/fio (2023-04-27 17:08:41 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 37946bed31b688fe55e2003b6d59ff0c964165bb:

  engines/rdma: remove dead code (2023-05-10 09:16:55 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      README: remove reference to the bsdio installer
      t/read-to-pipe-async: remove dead code
      engines/rdma: remove dead code

 README.rst             | 11 +++++------
 engines/rdma.c         |  2 --
 t/read-to-pipe-async.c |  4 +---
 3 files changed, 6 insertions(+), 11 deletions(-)

---

Diff of recent changes:

diff --git a/README.rst b/README.rst
index bcd08ec9..8f6208e3 100644
--- a/README.rst
+++ b/README.rst
@@ -123,12 +123,11 @@ Solaris:
 	``pkgutil -i fio``.
 
 Windows:
-        Beginning with fio 3.31 Windows installers are available on GitHub at
-        https://github.com/axboe/fio/releases.  Rebecca Cran
-        <rebecca@bsdio.com> has fio packages for Windows at
-        https://bsdio.com/fio/ . The latest builds for Windows can also be
-        grabbed from https://ci.appveyor.com/project/axboe/fio by clicking the
-        latest x86 or x64 build and then selecting the Artifacts tab.
+	Beginning with fio 3.31 Windows installers are available on GitHub at
+        https://github.com/axboe/fio/releases. The latest builds for Windows
+	can also be grabbed from https://ci.appveyor.com/project/axboe/fio by
+	clicking the latest x86 or x64 build and then selecting the Artifacts
+	tab.
 
 BSDs:
 	Packages for BSDs may be available from their binary package repositories.
diff --git a/engines/rdma.c b/engines/rdma.c
index ee2844d3..ebdbcb1c 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -856,8 +856,6 @@ static int fio_rdmaio_commit(struct thread_data *td)
 			ret = fio_rdmaio_send(td, io_us, rd->io_u_queued_nr);
 		else if (!rd->is_client)
 			ret = fio_rdmaio_recv(td, io_us, rd->io_u_queued_nr);
-		else
-			ret = 0;	/* must be a SYNC */
 
 		if (ret > 0) {
 			fio_rdmaio_queued(td, io_us, ret);
diff --git a/t/read-to-pipe-async.c b/t/read-to-pipe-async.c
index 586e3c95..569fc62a 100644
--- a/t/read-to-pipe-async.c
+++ b/t/read-to-pipe-async.c
@@ -247,10 +247,8 @@ static void *writer_fn(void *data)
 	while (!wt->thread.exit || !flist_empty(&wt->list)) {
 		pthread_mutex_lock(&wt->thread.lock);
 
-		if (work) {
+		if (work)
 			flist_add_tail(&work->list, &wt->done_list);
-			work = NULL;
-		}
 	
 		work = find_seq(wt, seq);
 		if (work)
