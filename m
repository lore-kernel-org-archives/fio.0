Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/4] fix/cleanup load_ioengine() [1/2]
Date: Tue, 22 Aug 2017 21:00:28 +0300
Message-Id: <20170822180029.17084-4-tkusumi@tuxera.com>
In-Reply-To: <20170822180029.17084-1-tkusumi@tuxera.com>
References: <20170822180029.17084-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

It's either
1) find the ioengine from the existing (static linked) ioengines or
2) dlopen the path in case of "external" ioengine,

but not to do 2 if 1 failed, as fio doesn't expect an ioengine to be
dynamically loaded unless with "external:" prefix by design.

The current implementation (i.e. do 2 if 1 failed) happened to have
been able to load an external ioengine with below syntax without
"external:" prefix, but this is a bug rather than a feature.

(--)ioengine=./engines/skeleton_external.so

The design of this option since commits in 2007
 7b395ca5('Prefix external io engine loading with 'external'')
 8a7bd877('Document loading external io engines')
is to use "external:/path/to/so" syntax to load an external ioengine.

This commit fixes above bug, which also potentially avoids the case
where "/path/to/so" within the given "external:/path/to/so" happens
to match the existing name, though this is normally unlikely to happen.

This commit also removes char *name arg from load_ioengine(). Only
having ->ioengine/->ioengine_so_path related conditional inside the
function makes the code more readable along with above change.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 init.c      | 12 ++----------
 ioengines.c | 35 +++++++++++++++++++++--------------
 ioengines.h |  2 +-
 3 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/init.c b/init.c
index a2342a6..278b24f 100644
--- a/init.c
+++ b/init.c
@@ -1006,8 +1006,6 @@ void td_fill_rand_seeds(struct thread_data *td)
  */
 int ioengine_load(struct thread_data *td)
 {
-	const char *engine;
-
 	if (!td->o.ioengine) {
 		log_err("fio: internal fault, no IO engine specified\n");
 		return 1;
@@ -1026,15 +1024,9 @@ int ioengine_load(struct thread_data *td)
 		free_ioengine(td);
 	}
 
-	/*
-	 * If an external ioengine is specified, use ->ioengine_so_path which
-	 * points to the so path. Otherwise use ->ioengine which points to the
-	 * name of the ioengine.
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
index 6e6e3de..9a04619 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -123,25 +123,31 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 	return ops;
 }
 
-struct ioengine_ops *load_ioengine(struct thread_data *td, const char *name)
+struct ioengine_ops *load_ioengine(struct thread_data *td)
 {
-	struct ioengine_ops *ops;
-	char engine[64];
+	struct ioengine_ops *ops = NULL;
+	const char *name = NULL;
 
-	dprint(FD_IO, "load ioengine %s\n", name);
+	if (strcmp(td->o.ioengine, "external")) {
+		char engine[64];
 
-	engine[sizeof(engine) - 1] = '\0';
-	strncpy(engine, name, sizeof(engine) - 1);
+		name = td->o.ioengine;
+		engine[sizeof(engine) - 1] = '\0';
+		strncpy(engine, name, sizeof(engine) - 1);
 
-	/*
-	 * linux libaio has alias names, so convert to what we want
-	 */
-	if (!strncmp(engine, "linuxaio", 8) || !strncmp(engine, "aio", 3))
-		strcpy(engine, "libaio");
+		/*
+		 * linux libaio has alias names, so convert to what we want
+		 */
+		if (!strncmp(engine, "linuxaio", 8) || !strncmp(engine, "aio", 3))
+			strcpy(engine, "libaio");
 
-	ops = find_ioengine(engine);
-	if (!ops)
+		dprint(FD_IO, "load ioengine %s\n", engine);
+		ops = find_ioengine(engine);
+	} else if (td->o.ioengine_so_path) {
+		name = td->o.ioengine_so_path;
 		ops = dlopen_ioengine(td, name);
+	} else
+		log_err("fio: missing external ioengine path\n");
 
 	if (!ops) {
 		log_err("fio: engine %s not loadable\n", name);
@@ -591,7 +597,8 @@ int fio_show_ioengine_help(const char *engine)
 
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


