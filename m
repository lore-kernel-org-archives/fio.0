Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/7] Replace redundant TD_F_NOIO flag with td->io_ops_init
Date: Mon, 20 Mar 2017 23:28:41 +0200
Message-Id: <20170320212847.71404-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

The only reason TD_F_NOIO exists in addition to FIO_NOIO is because
fio_running_or_pending_io_threads() needs to know whether td has
successfully initialized ioengine, whereas FIO_NOIO is statically
set regardless of ioengines's ->init() result.

This commit adds a new td field ->io_ops_init to inidicate ->init()
result, so that td needs no extra bit field for each ioengine like
TD_F_NOIO. It was rather odd that td was unable to tell ->init()
result afterward when ->init() failure (returning non zero) doesn't
mean aborting fio itself. This commit also changes TD_F_NOIO to
TD_F_RESERVED as it's no longer used.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.h       |  3 ++-
 init.c      |  1 +
 ioengines.c | 14 +++++++-------
 libfio.c    |  2 +-
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fio.h b/fio.h
index b573ac5..581512f 100644
--- a/fio.h
+++ b/fio.h
@@ -74,7 +74,7 @@ enum {
 	TD_F_VER_NONE		= 1U << 5,
 	TD_F_PROFILE_OPS	= 1U << 6,
 	TD_F_COMPRESS		= 1U << 7,
-	TD_F_NOIO		= 1U << 8,
+	TD_F_RESERVED		= 1U << 8, /* not used */
 	TD_F_COMPRESS_LOG	= 1U << 9,
 	TD_F_VSTATE_SAVED	= 1U << 10,
 	TD_F_NEED_LOCK		= 1U << 11,
@@ -231,6 +231,7 @@ struct thread_data {
 	 * to any of the available IO engines.
 	 */
 	struct ioengine_ops *io_ops;
+	int io_ops_init;
 
 	/*
 	 * IO engine private data and dlhandle.
diff --git a/init.c b/init.c
index b4b0974..4a72255 100644
--- a/init.c
+++ b/init.c
@@ -459,6 +459,7 @@ static struct thread_data *get_new_job(bool global, struct thread_data *parent,
 		copy_opt_list(td, parent);
 
 	td->io_ops = NULL;
+	td->io_ops_init = 0;
 	if (!preserve_eo)
 		td->eo = NULL;
 
diff --git a/ioengines.c b/ioengines.c
index 95013d1..c773f2e 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -368,17 +368,17 @@ int td_io_init(struct thread_data *td)
 
 	if (td->io_ops->init) {
 		ret = td->io_ops->init(td);
-		if (ret && td->o.iodepth > 1) {
-			log_err("fio: io engine init failed. Perhaps try"
-				" reducing io depth?\n");
-		}
+		if (ret)
+			log_err("fio: io engine %s init failed.%s\n",
+				td->io_ops->name,
+				td->o.iodepth > 1 ?
+				" Perhaps try reducing io depth?" : "");
+		else
+			td->io_ops_init = 1;
 		if (!td->error)
 			td->error = ret;
 	}
 
-	if (!ret && td_ioengine_flagged(td, FIO_NOIO))
-		td->flags |= TD_F_NOIO;
-
 	return ret;
 }
 
diff --git a/libfio.c b/libfio.c
index 4b53c92..8310708 100644
--- a/libfio.c
+++ b/libfio.c
@@ -276,7 +276,7 @@ int fio_running_or_pending_io_threads(void)
 	int nr_io_threads = 0;
 
 	for_each_td(td, i) {
-		if (td->flags & TD_F_NOIO)
+		if (td->io_ops_init && td_ioengine_flagged(td, FIO_NOIO))
 			continue;
 		nr_io_threads++;
 		if (td->runstate < TD_EXITED)
-- 
2.9.3


