Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57064 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbbFBMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 2 Jun 2015 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YzkrV-00025F-Lv
	for fio@vger.kernel.org; Tue, 02 Jun 2015 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150602120001.725712C00ED@kernel.dk>
Date: Tue,  2 Jun 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ec4dde5948a52c5bf8dcfe3b1c43912ddef2538e:

  rdma: adapt to new init_rand_seed() (2015-05-30 13:04:33 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a53d4f7847273faeef9795ad7a3f5865b0c22840:

  Merge branch 'req6' of git://github.com/kusumi/fio (2015-06-01 08:32:45 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'req6' of git://github.com/kusumi/fio

Tomohiro Kusumi (2):
      Fix build error on non-GNU environment
      Minor cleanups on cleanup()

 engines/null.c   | 3 +--
 engines/sync.c   | 8 +++++---
 lib/mountcheck.c | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/engines/null.c b/engines/null.c
index 6000930..41d42e0 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -86,8 +86,7 @@ static void fio_null_cleanup(struct thread_data *td)
 	struct null_data *nd = (struct null_data *) td->io_ops->data;
 
 	if (nd) {
-		if (nd->io_us)
-			free(nd->io_us);
+		free(nd->io_us);
 		free(nd);
 	}
 }
diff --git a/engines/sync.c b/engines/sync.c
index 48aafff..f5801fe 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -317,9 +317,11 @@ static void fio_vsyncio_cleanup(struct thread_data *td)
 {
 	struct syncio_data *sd = td->io_ops->data;
 
-	free(sd->iovecs);
-	free(sd->io_us);
-	free(sd);
+	if (sd) {
+		free(sd->iovecs);
+		free(sd->io_us);
+		free(sd);
+	}
 }
 
 static struct ioengine_ops ioengine_rw = {
diff --git a/lib/mountcheck.c b/lib/mountcheck.c
index dea2746..bb01f69 100644
--- a/lib/mountcheck.c
+++ b/lib/mountcheck.c
@@ -1,8 +1,8 @@
 #include <stdio.h>
 #include <string.h>
-#include <mntent.h>
 
 #ifdef CONFIG_GETMNTENT
+#include <mntent.h>
 
 #define MTAB	"/etc/mtab"
 
