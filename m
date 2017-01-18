Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/5] Refactor fio_show_ioengine_help()
Date: Thu, 19 Jan 2017 02:38:25 +0900
Message-Id: <1484761107-21387-3-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1484761107-21387-1-git-send-email-tkusumi@tuxera.com>
References: <1484761107-21387-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Since td is there only to call load_ioengine(),
ioengine ops doesn't need to be refered to as td.io_ops.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 ioengines.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/ioengines.c b/ioengines.c
index 315432d..95013d1 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -618,15 +618,15 @@ int fio_show_ioengine_help(const char *engine)
 {
 	struct flist_head *entry;
 	struct thread_data td;
+	struct ioengine_ops *io_ops;
 	char *sep;
 	int ret = 1;
 
 	if (!engine || !*engine) {
 		log_info("Available IO engines:\n");
 		flist_for_each(entry, &engine_list) {
-			td.io_ops = flist_entry(entry, struct ioengine_ops,
-						list);
-			log_info("\t%s\n", td.io_ops->name);
+			io_ops = flist_entry(entry, struct ioengine_ops, list);
+			log_info("\t%s\n", io_ops->name);
 		}
 		return 0;
 	}
@@ -638,16 +638,16 @@ int fio_show_ioengine_help(const char *engine)
 
 	memset(&td, 0, sizeof(td));
 
-	td.io_ops = load_ioengine(&td, engine);
-	if (!td.io_ops) {
+	io_ops = load_ioengine(&td, engine);
+	if (!io_ops) {
 		log_info("IO engine %s not found\n", engine);
 		return 1;
 	}
 
-	if (td.io_ops->options)
-		ret = show_cmd_help(td.io_ops->options, sep);
+	if (io_ops->options)
+		ret = show_cmd_help(io_ops->options, sep);
 	else
-		log_info("IO engine %s has no options\n", td.io_ops->name);
+		log_info("IO engine %s has no options\n", io_ops->name);
 
 	free_ioengine(&td);
 
-- 
2.5.5


