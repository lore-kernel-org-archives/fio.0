Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43952 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752056AbdIBMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 2 Sep 2017 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1do75o-0007ch-5Q
        for fio@vger.kernel.org; Sat, 02 Sep 2017 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170902120002.3A31A2C0167@kernel.dk>
Date: Sat,  2 Sep 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 83070ccd1091a1c44ac838f95bab6811cbc287f5:

  t/axmap: we don't need smalloc/sfree wrappers (2017-08-31 08:34:27 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ba872a0beb498740f076e19299bb7388b82ad4d6:

  revert/rework 81647a9a('fix load_ioengine() not to support no "external:" prefix') (2017-09-01 13:58:35 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (7):
      skeleton: add option example
      fix broken external ioengine option
      cleanup ioengine_load() (for the next commit)
      fix load_ioengine() not to support no "external:" prefix
      add __load_ioengine() to separate ioengine loading from td context
      fix regression by 8c43ba62('filesetup: align layout buffer')
      revert/rework 81647a9a('fix load_ioengine() not to support no "external:" prefix')

 HOWTO                       |  4 +++-
 engines/skeleton_external.c | 32 +++++++++++++++++++++++++++++++-
 filesetup.c                 |  9 +++++----
 fio.1                       |  4 +++-
 init.c                      | 21 ++-------------------
 ioengines.c                 | 41 ++++++++++++++++++++++++++++++-----------
 ioengines.h                 |  2 +-
 options.c                   | 34 ++++++++++++++++++++++++++++++++++
 thread_options.h            |  1 +
 9 files changed, 110 insertions(+), 38 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 3a720c3..2a70b7c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1791,7 +1791,9 @@ I/O engine
 		**external**
 			Prefix to specify loading an external I/O engine object file. Append
 			the engine filename, e.g. ``ioengine=external:/tmp/foo.o`` to load
-			ioengine :file:`foo.o` in :file:`/tmp`.
+			ioengine :file:`foo.o` in :file:`/tmp`. The path can be either
+			absolute or relative. See :file:`engines/skeleton_external.c` for
+			details of writing an external I/O engine.
 
 
 I/O engine specific parameters
diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
index 4bebcc4..56f89f9 100644
--- a/engines/skeleton_external.c
+++ b/engines/skeleton_external.c
@@ -3,7 +3,8 @@
  *
  * Should be compiled with:
  *
- * gcc -Wall -O2 -g -shared -rdynamic -fPIC -o engine.o engine.c
+ * gcc -Wall -O2 -g -shared -rdynamic -fPIC -o skeleton_external.o skeleton_external.c
+ * (also requires -D_GNU_SOURCE -DCONFIG_STRSEP on Linux)
  *
  */
 #include <stdio.h>
@@ -13,6 +14,7 @@
 #include <assert.h>
 
 #include "../fio.h"
+#include "../optgroup.h"
 
 /*
  * The core of the module is identical to the ones included with fio,
@@ -21,6 +23,32 @@
  */
 
 /*
+ * The io engine can define its own options within the io engine source.
+ * The option member must not be at offset 0, due to the way fio parses
+ * the given option. Just add a padding pointer unless the io engine has
+ * something usable.
+ */
+struct fio_skeleton_options {
+	void *pad; /* avoid ->off1 of fio_option becomes 0 */
+	unsigned int dummy;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	= "dummy",
+		.lname	= "ldummy",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct fio_skeleton_options, dummy),
+		.help	= "Set dummy",
+		.category = FIO_OPT_C_ENGINE, /* always use this */
+		.group	= FIO_OPT_G_INVALID, /* this can be different */
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+/*
  * The ->event() hook is called to match an event number with an io_u.
  * After the core has called ->getevents() and it has returned eg 3,
  * the ->event() hook must return the 3 events that have completed for
@@ -140,4 +168,6 @@ struct ioengine_ops ioengine = {
 	.cleanup	= fio_skeleton_cleanup,
 	.open_file	= fio_skeleton_open,
 	.close_file	= fio_skeleton_close,
+	.options	= options,
+	.option_struct_size	= sizeof(struct fio_skeleton_options),
 };
diff --git a/filesetup.c b/filesetup.c
index c4240d2..5e8ea35 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -110,7 +110,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 {
 	int new_layout = 0, unlink_file = 0, flags;
 	unsigned long long left;
-	unsigned int bs;
+	unsigned int bs, alloc_size = 0;
 	char *b = NULL;
 
 	if (read_only) {
@@ -204,7 +204,8 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 	if (bs > left)
 		bs = left;
 
-	b = fio_memalign(page_size, bs);
+	alloc_size = bs;
+	b = fio_memalign(page_size, alloc_size);
 	if (!b) {
 		td_verror(td, errno, "fio_memalign");
 		goto err;
@@ -259,14 +260,14 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 			f->io_size = f->real_file_size;
 	}
 
-	fio_memfree(b, bs);
+	fio_memfree(b, alloc_size);
 done:
 	return 0;
 err:
 	close(f->fd);
 	f->fd = -1;
 	if (b)
-		fio_memfree(b, bs);
+		fio_memfree(b, alloc_size);
 	return 1;
 }
 
diff --git a/fio.1 b/fio.1
index 5b63dfd..97133da 100644
--- a/fio.1
+++ b/fio.1
@@ -1572,7 +1572,9 @@ Read and write using device DAX to a persistent memory device (e.g.,
 .B external
 Prefix to specify loading an external I/O engine object file. Append
 the engine filename, e.g. `ioengine=external:/tmp/foo.o' to load
-ioengine `foo.o' in `/tmp'.
+ioengine `foo.o' in `/tmp'. The path can be either
+absolute or relative. See `engines/skeleton_external.c' in the fio source for
+details of writing an external I/O engine.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
diff --git a/init.c b/init.c
index 625c937..cf5c646 100644
--- a/init.c
+++ b/init.c
@@ -912,20 +912,6 @@ static int fixup_options(struct thread_data *td)
 	return ret;
 }
 
-/* External engines are specified by "external:name.o") */
-static const char *get_engine_name(const char *str)
-{
-	char *p = strstr(str, ":");
-
-	if (!p)
-		return str;
-
-	p++;
-	strip_blank_front(&p);
-	strip_blank_end(p);
-	return p;
-}
-
 static void init_rand_file_service(struct thread_data *td)
 {
 	unsigned long nranges = td->o.nr_files << FIO_FSERVICE_SHIFT;
@@ -1037,8 +1023,6 @@ void td_fill_rand_seeds(struct thread_data *td)
  */
 int ioengine_load(struct thread_data *td)
 {
-	const char *engine;
-
 	if (!td->o.ioengine) {
 		log_err("fio: internal fault, no IO engine specified\n");
 		return 1;
@@ -1057,10 +1041,9 @@ int ioengine_load(struct thread_data *td)
 		free_ioengine(td);
 	}
 
-	engine = get_engine_name(td->o.ioengine);
-	td->io_ops = load_ioengine(td, engine);
+	td->io_ops = load_ioengine(td);
 	if (!td->io_ops) {
-		log_err("fio: failed to load engine %s\n", engine);
+		log_err("fio: failed to load engine\n");
 		return 1;
 	}
 
diff --git a/ioengines.c b/ioengines.c
index 919781c..fa4acab 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -123,13 +123,10 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 	return ops;
 }
 
-struct ioengine_ops *load_ioengine(struct thread_data *td, const char *name)
+static struct ioengine_ops *__load_ioengine(const char *name)
 {
-	struct ioengine_ops *ops;
 	char engine[64];
 
-	dprint(FD_IO, "load ioengine %s\n", name);
-
 	engine[sizeof(engine) - 1] = '\0';
 	strncpy(engine, name, sizeof(engine) - 1);
 
@@ -139,10 +136,37 @@ struct ioengine_ops *load_ioengine(struct thread_data *td, const char *name)
 	if (!strncmp(engine, "linuxaio", 8) || !strncmp(engine, "aio", 3))
 		strcpy(engine, "libaio");
 
-	ops = find_ioengine(engine);
+	dprint(FD_IO, "load ioengine %s\n", engine);
+	return find_ioengine(engine);
+}
+
+struct ioengine_ops *load_ioengine(struct thread_data *td)
+{
+	struct ioengine_ops *ops = NULL;
+	const char *name;
+
+	/*
+	 * Use ->ioengine_so_path if an external ioengine path is specified.
+	 * In this case, ->ioengine is "external" which also means the prefix
+	 * for external ioengines "external:" is properly used.
+	 */
+	name = td->o.ioengine_so_path ?: td->o.ioengine;
+
+	/*
+	 * Try to load ->ioengine first, and if failed try to dlopen(3) either
+	 * ->ioengine or ->ioengine_so_path.  This is redundant for an external
+	 * ioengine with prefix, and also leaves the possibility of unexpected
+	 * behavior (e.g. if the "external" ioengine exists), but we do this
+	 * so as not to break job files not using the prefix.
+	 */
+	ops = __load_ioengine(td->o.ioengine);
 	if (!ops)
 		ops = dlopen_ioengine(td, name);
 
+	/*
+	 * If ops is NULL, we failed to load ->ioengine, and also failed to
+	 * dlopen(3) either ->ioengine or ->ioengine_so_path as a path.
+	 */
 	if (!ops) {
 		log_err("fio: engine %s not loadable\n", name);
 		return NULL;
@@ -552,7 +576,6 @@ int td_io_get_file_size(struct thread_data *td, struct fio_file *f)
 int fio_show_ioengine_help(const char *engine)
 {
 	struct flist_head *entry;
-	struct thread_data td;
 	struct ioengine_ops *io_ops;
 	char *sep;
 	int ret = 1;
@@ -571,9 +594,7 @@ int fio_show_ioengine_help(const char *engine)
 		sep++;
 	}
 
-	memset(&td, 0, sizeof(td));
-
-	io_ops = load_ioengine(&td, engine);
+	io_ops = __load_ioengine(engine);
 	if (!io_ops) {
 		log_info("IO engine %s not found\n", engine);
 		return 1;
@@ -584,7 +605,5 @@ int fio_show_ioengine_help(const char *engine)
 	else
 		log_info("IO engine %s has no options\n", io_ops->name);
 
-	free_ioengine(&td);
-
 	return ret;
 }
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
diff --git a/options.c b/options.c
index 443791a..54fa4ee 100644
--- a/options.c
+++ b/options.c
@@ -1462,6 +1462,39 @@ static int str_write_hist_log_cb(void *data, const char *str)
 	return 0;
 }
 
+/*
+ * str is supposed to be a substring of the strdup'd original string,
+ * and is valid only if it's a regular file path.
+ * This function keeps the pointer to the path as needed later.
+ *
+ * "external:/path/to/so\0" <- original pointer updated with strdup'd
+ * "external\0"             <- above pointer after parsed, i.e. ->ioengine
+ *          "/path/to/so\0" <- str argument, i.e. ->ioengine_so_path
+ */
+static int str_ioengine_external_cb(void *data, const char *str)
+{
+	struct thread_data *td = cb_data_to_td(data);
+	struct stat sb;
+	char *p;
+
+	if (!str) {
+		log_err("fio: null external ioengine path\n");
+		return 1;
+	}
+
+	p = (char *)str; /* str is mutable */
+	strip_blank_front(&p);
+	strip_blank_end(p);
+
+	if (stat(p, &sb) || !S_ISREG(sb.st_mode)) {
+		log_err("fio: invalid external ioengine path \"%s\"\n", p);
+		return 1;
+	}
+
+	td->o.ioengine_so_path = p;
+	return 0;
+}
+
 static int rw_verify(struct fio_option *o, void *data)
 {
 	struct thread_data *td = cb_data_to_td(data);
@@ -1812,6 +1845,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 #endif
 			  { .ival = "external",
 			    .help = "Load external engine (append name)",
+			    .cb = str_ioengine_external_cb,
 			  },
 		},
 	},
diff --git a/thread_options.h b/thread_options.h
index 26a3e0e..fd6576e 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -53,6 +53,7 @@ struct thread_options {
 	char *filename_format;
 	char *opendir;
 	char *ioengine;
+	char *ioengine_so_path;
 	char *mmapfile;
 	enum td_ddir td_ddir;
 	unsigned int rw_seq;
