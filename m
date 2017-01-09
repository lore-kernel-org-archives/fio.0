Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/6] Staticize pmemblk ioengine_ops
Date: Mon,  9 Jan 2017 23:41:59 +0900
Message-Id: <1483972923-13662-2-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1483972923-13662-1-git-send-email-tkusumi@tuxera.com>
References: <1483972923-13662-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Inbox engines can have static ops.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/pmemblk.c           | 2 +-
 engines/skeleton_external.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index ca72697..5439da0 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -482,7 +482,7 @@ static int fio_pmemblk_unlink_file(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-struct ioengine_ops ioengine = {
+static struct ioengine_ops ioengine = {
 	.name = "pmemblk",
 	.version = FIO_IOOPS_VERSION,
 	.queue = fio_pmemblk_queue,
diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
index 63a6f8d..5d6a9ed 100644
--- a/engines/skeleton_external.c
+++ b/engines/skeleton_external.c
@@ -126,7 +126,7 @@ static int fio_skeleton_close(struct thread_data *td, struct fio_file *f)
 
 /*
  * Note that the structure is exported, so that fio can get it via
- * dlsym(..., "ioengine");
+ * dlsym(..., "ioengine"); for (and only for) external engines.
  */
 struct ioengine_ops ioengine = {
 	.name		= "engine_name",
-- 
2.5.5


