Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/4] fix broken external ioengine option
Date: Tue, 22 Aug 2017 21:00:27 +0300
Message-Id: <20170822180029.17084-3-tkusumi@tuxera.com>
In-Reply-To: <20170822180029.17084-1-tkusumi@tuxera.com>
References: <20170822180029.17084-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

get_engine_name() function added for "external:" ioengine option by
below commits in 2007 has been broken by __handle_option() stripping
':' and after while parsing the option.
 7b395ca5('Prefix external io engine loading with 'external'')
 8a7bd877('Document loading external io engines')

It seems below commit in 2011 broke it.
 c44b1ff5('Add sub-option support (sort-of) and convert libaio_userspace_reap')

Above change made fio dlopen "external" instead of the path located
after "external:", since the path had already been stripped by
__handle_option() by the time get_engine_name() was called. This commit
fixes it by adding ->ioengine_so_path pointer to keep the path while
parsing using sub-option callback.

Note that removing get_engine_name() doesn't affect non "external:"
ioengine options. The option strings have been stripped by the parser.

-- before this commit
 # ./fio --name=xxx --ioengine=external:./engines/skeleton_external.so
 fio: engine external not loadable
 fio: failed to load engine external
 fio: file:ioengines.c:91, func=dlopen, error=external: cannot open shared object file: No such file or directory

-- with this commit
 # ./fio --name=xxx --ioengine=external:./engines/skeleton_external.so
 xxx: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=engine_name, iodepth=1
 fio-3.0-7-g75f05
 Starting 1 process
 xxx: you need to specify size=
 fio: pid=0, err=22/file:filesetup.c:963, func=total_file_size, error=Invalid argument

 Run status group 0 (all jobs):

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 init.c           | 21 ++++++---------------
 options.c        | 34 ++++++++++++++++++++++++++++++++++
 thread_options.h |  1 +
 3 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/init.c b/init.c
index 164e411..a2342a6 100644
--- a/init.c
+++ b/init.c
@@ -895,20 +895,6 @@ static int fixup_options(struct thread_data *td)
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
@@ -1040,7 +1026,12 @@ int ioengine_load(struct thread_data *td)
 		free_ioengine(td);
 	}
 
-	engine = get_engine_name(td->o.ioengine);
+	/*
+	 * If an external ioengine is specified, use ->ioengine_so_path which
+	 * points to the so path. Otherwise use ->ioengine which points to the
+	 * name of the ioengine.
+	 */
+	engine = td->o.ioengine_so_path ?: td->o.ioengine;
 	td->io_ops = load_ioengine(td, engine);
 	if (!td->io_ops) {
 		log_err("fio: failed to load engine %s\n", engine);
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
-- 
2.9.5


