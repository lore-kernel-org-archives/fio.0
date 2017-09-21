Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60578 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdIUMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 21 Sep 2017 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dv09D-0007Ws-FL
        for fio@vger.kernel.org; Thu, 21 Sep 2017 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170921120001.E7DCC2C0084@kernel.dk>
Date: Thu, 21 Sep 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 51102e0d64a2ae08472ecb90a72737f08de942fb:

  add fio_set_directio() error message for platforms without direct I/O (2017-09-18 12:43:27 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2ae7a90df2d2340c4503be8a91526f80b3b96789:

  init: typo in help output (2017-09-20 22:21:35 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      init: typo in help output

 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 6ac5212..e80aec3 100644
--- a/init.c
+++ b/init.c
@@ -2115,7 +2115,7 @@ static void usage(const char *name)
 	printf("  --inflate-log=log\tInflate and output compressed log\n");
 #endif
 	printf("  --trigger-file=file\tExecute trigger cmd when file exists\n");
-	printf("  --trigger-timeout=t\tExecute trigger af this time\n");
+	printf("  --trigger-timeout=t\tExecute trigger at this time\n");
 	printf("  --trigger=cmd\t\tSet this command as local trigger\n");
 	printf("  --trigger-remote=cmd\tSet this command as remote trigger\n");
 	printf("  --aux-path=path\tUse this path for fio state generated files\n");
