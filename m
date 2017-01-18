Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/5] Move options_mem_dupe() to parse.c
Date: Thu, 19 Jan 2017 02:38:26 +0900
Message-Id: <1484761107-21387-4-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1484761107-21387-1-git-send-email-tkusumi@tuxera.com>
References: <1484761107-21387-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This function should be in parse.c with fio_option* argument first.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.h     |  1 -
 init.c    |  2 +-
 options.c | 19 ++-----------------
 parse.c   | 17 +++++++++++++++++
 parse.h   |  1 +
 5 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/fio.h b/fio.h
index 62ff7ab..b2dade9 100644
--- a/fio.h
+++ b/fio.h
@@ -518,7 +518,6 @@ extern int fio_show_option_help(const char *);
 extern void fio_options_set_ioengine_opts(struct option *long_options, struct thread_data *td);
 extern void fio_options_dup_and_init(struct option *);
 extern void fio_options_mem_dupe(struct thread_data *);
-extern void options_mem_dupe(void *data, struct fio_option *options);
 extern void td_fill_rand_seeds(struct thread_data *);
 extern void td_fill_verify_state_seed(struct thread_data *);
 extern void add_job_opts(const char **, int);
diff --git a/init.c b/init.c
index 2d26c52..c3cc3e5 100644
--- a/init.c
+++ b/init.c
@@ -1020,7 +1020,7 @@ int ioengine_load(struct thread_data *td)
 		 */
 		if (origeo) {
 			memcpy(td->eo, origeo, td->io_ops->option_struct_size);
-			options_mem_dupe(td->eo, td->io_ops->options);
+			options_mem_dupe(td->io_ops->options, td->eo);
 		} else {
 			memset(td->eo, 0, td->io_ops->option_struct_size);
 			fill_default_options(td->eo, td->io_ops->options);
diff --git a/options.c b/options.c
index 1ca16e8..713112f 100644
--- a/options.c
+++ b/options.c
@@ -4772,34 +4772,19 @@ int fio_show_option_help(const char *opt)
 	return show_cmd_help(fio_options, opt);
 }
 
-void options_mem_dupe(void *data, struct fio_option *options)
-{
-	struct fio_option *o;
-	char **ptr;
-
-	for (o = &options[0]; o->name; o++) {
-		if (o->type != FIO_OPT_STR_STORE)
-			continue;
-
-		ptr = td_var(data, o, o->off1);
-		if (*ptr)
-			*ptr = strdup(*ptr);
-	}
-}
-
 /*
  * dupe FIO_OPT_STR_STORE options
  */
 void fio_options_mem_dupe(struct thread_data *td)
 {
-	options_mem_dupe(&td->o, fio_options);
+	options_mem_dupe(fio_options, &td->o);
 
 	if (td->eo && td->io_ops) {
 		void *oldeo = td->eo;
 
 		td->eo = malloc(td->io_ops->option_struct_size);
 		memcpy(td->eo, oldeo, td->io_ops->option_struct_size);
-		options_mem_dupe(td->eo, td->io_ops->options);
+		options_mem_dupe(td->io_ops->options, td->eo);
 	}
 }
 
diff --git a/parse.c b/parse.c
index 518c2df..fc508b6 100644
--- a/parse.c
+++ b/parse.c
@@ -1319,6 +1319,23 @@ void options_init(struct fio_option *options)
 	}
 }
 
+void options_mem_dupe(struct fio_option *options, void *data)
+{
+	struct fio_option *o;
+	char **ptr;
+
+	dprint(FD_PARSE, "dup options\n");
+
+	for (o = &options[0]; o->name; o++) {
+		if (o->type != FIO_OPT_STR_STORE)
+			continue;
+
+		ptr = td_var(data, o, o->off1);
+		if (*ptr)
+			*ptr = strdup(*ptr);
+	}
+}
+
 void options_free(struct fio_option *options, void *data)
 {
 	struct fio_option *o;
diff --git a/parse.h b/parse.h
index 7ba4e37..54e3948 100644
--- a/parse.h
+++ b/parse.h
@@ -86,6 +86,7 @@ extern int parse_cmd_option(const char *t, const char *l, struct fio_option *, v
 extern int show_cmd_help(struct fio_option *, const char *);
 extern void fill_default_options(void *, struct fio_option *);
 extern void options_init(struct fio_option *);
+extern void options_mem_dupe(struct fio_option *, void *);
 extern void options_free(struct fio_option *, void *);
 
 extern void strip_blank_front(char **);
-- 
2.5.5


