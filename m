Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/5] cleanup ioengine_load() (for the next commit)
Date: Thu, 31 Aug 2017 23:13:06 +0300
Message-Id: <20170831201308.47933-4-tkusumi@tuxera.com>
In-Reply-To: <20170831201308.47933-1-tkusumi@tuxera.com>
References: <20170831201308.47933-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This commit removes name argument from ioengine_load(), as both
ioengine name and path are self contained in td.
No functional changes.

This makes the next commit's diff more clear by separating non
functional noise.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 init.c      | 10 ++--------
 ioengines.c |  8 ++++++--
 ioengines.h |  2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/init.c b/init.c
index 2da64ba..cf5c646 100644
--- a/init.c
+++ b/init.c
@@ -1023,8 +1023,6 @@ void td_fill_rand_seeds(struct thread_data *td)
  */
 int ioengine_load(struct thread_data *td)
 {
-	const char *engine;
-
 	if (!td->o.ioengine) {
 		log_err("fio: internal fault, no IO engine specified\n");
 		return 1;
@@ -1043,13 +1041,9 @@ int ioengine_load(struct thread_data *td)
 		free_ioengine(td);
 	}
 
-	/*
-	 * Use ->ioengine_so_path if an external ioengine is specified.
-	 */
-	engine = td->o.ioengine_so_path ?: td->o.ioengine;
-	td->io_ops = load_ioengine(td, engine);
+	td->io_ops = load_ioengine(td);
 	if (!td->io_ops) {
-		log_err("fio: failed to load engine %s\n", engine);
+		log_err("fio: failed to load engine\n");
 		return 1;
 	}
 
diff --git a/ioengines.c b/ioengines.c
index 919781c..54aa5a6 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -123,10 +123,13 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 	return ops;
 }
 
-struct ioengine_ops *load_ioengine(struct thread_data *td, const char *name)
+struct ioengine_ops *load_ioengine(struct thread_data *td)
 {
 	struct ioengine_ops *ops;
 	char engine[64];
+	char *name;
+
+	name = td->o.ioengine_so_path ?: td->o.ioengine;
 
 	dprint(FD_IO, "load ioengine %s\n", name);
 
@@ -573,7 +576,8 @@ int fio_show_ioengine_help(const char *engine)
 
 	memset(&td, 0, sizeof(td));
 
-	io_ops = load_ioengine(&td, engine);
+	td.o.ioengine = (char *)engine;
+	io_ops = load_ioengine(&td);
 	if (!io_ops) {
 		log_info("IO engine %s not found\n", engine);
 		return 1;
diff --git a/ioengines.h b/ioengines.h
index f24f4df..177cbc0 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -79,7 +79,7 @@ extern int td_io_close_file(struct thread_data *, struct fio_file *);
 extern int td_io_unlink_file(struct thread_data *, struct fio_file *);
 extern int __must_check td_io_get_file_size(struct thread_data *, struct fio_file *);
 
-extern struct ioengine_ops *load_ioengine(struct thread_data *, const char *);
+extern struct ioengine_ops *load_ioengine(struct thread_data *);
 extern void register_ioengine(struct ioengine_ops *);
 extern void unregister_ioengine(struct ioengine_ops *);
 extern void free_ioengine(struct thread_data *);
-- 
2.9.5


