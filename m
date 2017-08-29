Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38912 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752315AbdH2MAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 29 Aug 2017 08:00:10 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dmfBh-0005Rl-Jn
        for fio@vger.kernel.org; Tue, 29 Aug 2017 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170829120002.116782C0098@kernel.dk>
Date: Tue, 29 Aug 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0c76294c12bdc3df90a41754b05fa30b612ea6eb:

  engines/windowsaio: kill useless forward declarations (2017-08-27 15:21:26 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a4befdc605bc253f258a99e9f0d037147775035e:

  Merge branch 'direct_layout_fix' of https://github.com/sitsofe/fio (2017-08-28 09:57:30 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'direct_layout_fix' of https://github.com/sitsofe/fio

Sitsofe Wheeler (2):
      filesetup: align layout buffer
      filesetup: add direct=1 failure warning to layout

 filesetup.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 0e5599a..a6a94ee 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -15,6 +15,7 @@
 #include "os/os.h"
 #include "hash.h"
 #include "lib/axmap.h"
+#include "lib/memalign.h"
 
 #ifdef CONFIG_LINUX_FALLOCATE
 #include <linux/falloc.h>
@@ -161,8 +162,14 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		if (err == ENOENT && !td->o.allow_create)
 			log_err("fio: file creation disallowed by "
 					"allow_file_create=0\n");
-		else
+		else {
+			if (err == EINVAL && (flags & OS_O_DIRECT))
+				log_err("fio: looks like your filesystem "
+					"does not support "
+					"direct=1/buffered=0\n");
+
 			td_verror(td, err, "open");
+		}
 		return 1;
 	}
 
@@ -194,9 +201,9 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 	if (bs > left)
 		bs = left;
 
-	b = malloc(bs);
+	b = fio_memalign(page_size, bs);
 	if (!b) {
-		td_verror(td, errno, "malloc");
+		td_verror(td, errno, "fio_memalign");
 		goto err;
 	}
 
@@ -249,14 +256,14 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 			f->io_size = f->real_file_size;
 	}
 
-	free(b);
+	fio_memfree(b, bs);
 done:
 	return 0;
 err:
 	close(f->fd);
 	f->fd = -1;
 	if (b)
-		free(b);
+		fio_memfree(b, bs);
 	return 1;
 }
 
