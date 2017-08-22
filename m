Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/4] fix/cleanup load_ioengine() [2/2]
Date: Tue, 22 Aug 2017 21:00:29 +0300
Message-Id: <20170822180029.17084-5-tkusumi@tuxera.com>
In-Reply-To: <20170822180029.17084-1-tkusumi@tuxera.com>
References: <20170822180029.17084-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Add a sub function __load_ioengine(), which only takes name argument,
to be called from load_ioengine(). No functional changes.

This lets fio_show_ioengine_help() get rid of a local variable td
which only existed to call load_ioengine(&td, ...) while this td had
no actual thread context thus unneeded.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 ioengines.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/ioengines.c b/ioengines.c
index 9a04619..dcf2e4d 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -123,26 +123,31 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 	return ops;
 }
 
+static struct ioengine_ops *__load_ioengine(const char *name)
+{
+	char engine[64];
+
+	engine[sizeof(engine) - 1] = '\0';
+	strncpy(engine, name, sizeof(engine) - 1);
+
+	/*
+	 * linux libaio has alias names, so convert to what we want
+	 */
+	if (!strncmp(engine, "linuxaio", 8) || !strncmp(engine, "aio", 3))
+		strcpy(engine, "libaio");
+
+	dprint(FD_IO, "load ioengine %s\n", engine);
+	return find_ioengine(engine);
+}
+
 struct ioengine_ops *load_ioengine(struct thread_data *td)
 {
 	struct ioengine_ops *ops = NULL;
 	const char *name = NULL;
 
 	if (strcmp(td->o.ioengine, "external")) {
-		char engine[64];
-
 		name = td->o.ioengine;
-		engine[sizeof(engine) - 1] = '\0';
-		strncpy(engine, name, sizeof(engine) - 1);
-
-		/*
-		 * linux libaio has alias names, so convert to what we want
-		 */
-		if (!strncmp(engine, "linuxaio", 8) || !strncmp(engine, "aio", 3))
-			strcpy(engine, "libaio");
-
-		dprint(FD_IO, "load ioengine %s\n", engine);
-		ops = find_ioengine(engine);
+		ops = __load_ioengine(name);
 	} else if (td->o.ioengine_so_path) {
 		name = td->o.ioengine_so_path;
 		ops = dlopen_ioengine(td, name);
@@ -576,7 +581,6 @@ int td_io_get_file_size(struct thread_data *td, struct fio_file *f)
 int fio_show_ioengine_help(const char *engine)
 {
 	struct flist_head *entry;
-	struct thread_data td;
 	struct ioengine_ops *io_ops;
 	char *sep;
 	int ret = 1;
@@ -595,10 +599,7 @@ int fio_show_ioengine_help(const char *engine)
 		sep++;
 	}
 
-	memset(&td, 0, sizeof(td));
-
-	td.o.ioengine = (char *)engine;
-	io_ops = load_ioengine(&td);
+	io_ops = __load_ioengine(engine);
 	if (!io_ops) {
 		log_info("IO engine %s not found\n", engine);
 		return 1;
@@ -609,7 +610,5 @@ int fio_show_ioengine_help(const char *engine)
 	else
 		log_info("IO engine %s has no options\n", io_ops->name);
 
-	free_ioengine(&td);
-
 	return ret;
 }
-- 
2.9.5


