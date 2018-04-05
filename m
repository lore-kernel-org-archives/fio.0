Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46448 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbeDEMAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 5 Apr 2018 08:00:14 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1f43Ys-0007Ia-4n
        for fio@vger.kernel.org; Thu, 05 Apr 2018 12:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180405120002.0FE9D2C006C@kernel.dk>
Date: Thu,  5 Apr 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 196ce5d5ff76af30cf93fd24240f12d8c4d24381:

  Merge branch 'fixbug_glfs' of https://github.com/simon-rock/fio (2018-04-03 08:19:38 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2b8b8f0dccb4c7e97aee3b7d7e13d8528467d64e:

  Fix return value checking of fread() in iolog.c (2018-04-04 19:18:50 -0600)

----------------------------------------------------------------
Bart Van Assche (6):
      engines/sg: Make I/O error messages more informative
      Rename TD_F_VER_NONE into TD_F_DO_VERIFY
      Only populate the write buffer if necessary
      parse.h: Remove a superfluous cast
      option parsing: Mark arguments that are not modified as 'const'
      Ensure that .minfp and .maxfp are respected for FIO_OPT_FLOAT_LIST

Jens Axboe (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

Rebecca Cran (1):
      Fix return value checking of fread() in iolog.c

 backend.c    |   4 +++
 engines/sg.c |   4 +--
 fio.h        |   4 +--
 init.c       |   2 +-
 io_u.c       |   9 ++---
 iolog.c      |   6 ++--
 options.c    |  16 ++++-----
 options.h    |   9 +++--
 parse.c      | 112 +++++++++++++++++++++++++++++++----------------------------
 parse.h      |  25 +++++++------
 10 files changed, 103 insertions(+), 88 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index f2d7cc3..b28c3db 100644
--- a/backend.c
+++ b/backend.c
@@ -723,6 +723,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 					break;
 				} else if (io_u->ddir == DDIR_WRITE) {
 					io_u->ddir = DDIR_READ;
+					populate_verify_io_u(td, io_u);
 					break;
 				} else {
 					put_io_u(td, io_u);
@@ -995,6 +996,9 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 			break;
 		}
 
+		if (io_u->ddir == DDIR_WRITE && td->flags & TD_F_DO_VERIFY)
+			populate_verify_io_u(td, io_u);
+
 		ddir = io_u->ddir;
 
 		/*
diff --git a/engines/sg.c b/engines/sg.c
index 72eed8b..c2c0de3 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -287,11 +287,11 @@ static int fio_sgio_doio(struct thread_data *td, struct io_u *io_u, int do_sync)
 
 	if (f->filetype == FIO_TYPE_BLOCK) {
 		ret = fio_sgio_ioctl_doio(td, f, io_u);
-		td->error = io_u->error;
+		td_verror(td, io_u->error, __func__);
 	} else {
 		ret = fio_sgio_rw_doio(f, io_u, do_sync);
 		if (do_sync)
-			td->error = io_u->error;
+			td_verror(td, io_u->error, __func__);
 	}
 
 	return ret;
diff --git a/fio.h b/fio.h
index 488fa9a..2bfcac4 100644
--- a/fio.h
+++ b/fio.h
@@ -79,7 +79,7 @@ enum {
 	__TD_F_READ_IOLOG,
 	__TD_F_REFILL_BUFFERS,
 	__TD_F_SCRAMBLE_BUFFERS,
-	__TD_F_VER_NONE,
+	__TD_F_DO_VERIFY,
 	__TD_F_PROFILE_OPS,
 	__TD_F_COMPRESS,
 	__TD_F_COMPRESS_LOG,
@@ -100,7 +100,7 @@ enum {
 	TD_F_READ_IOLOG		= 1U << __TD_F_READ_IOLOG,
 	TD_F_REFILL_BUFFERS	= 1U << __TD_F_REFILL_BUFFERS,
 	TD_F_SCRAMBLE_BUFFERS	= 1U << __TD_F_SCRAMBLE_BUFFERS,
-	TD_F_VER_NONE		= 1U << __TD_F_VER_NONE,
+	TD_F_DO_VERIFY		= 1U << __TD_F_DO_VERIFY,
 	TD_F_PROFILE_OPS	= 1U << __TD_F_PROFILE_OPS,
 	TD_F_COMPRESS		= 1U << __TD_F_COMPRESS,
 	TD_F_COMPRESS_LOG	= 1U << __TD_F_COMPRESS_LOG,
diff --git a/init.c b/init.c
index ab7e399..0b6fedd 100644
--- a/init.c
+++ b/init.c
@@ -1184,7 +1184,7 @@ static void init_flags(struct thread_data *td)
 	    fio_option_is_set(o, zero_buffers)))
 		td->flags |= TD_F_SCRAMBLE_BUFFERS;
 	if (o->verify != VERIFY_NONE)
-		td->flags |= TD_F_VER_NONE;
+		td->flags |= TD_F_DO_VERIFY;
 
 	if (o->verify_async || o->io_submit_mode == IO_MODE_OFFLOAD)
 		td->flags |= TD_F_NEED_LOCK;
diff --git a/io_u.c b/io_u.c
index 98a7dc5..5fbb238 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1699,7 +1699,7 @@ static void small_content_scramble(struct io_u *io_u)
 
 /*
  * Return an io_u to be processed. Gets a buflen and offset, sets direction,
- * etc. The returned io_u is fully ready to be prepped and submitted.
+ * etc. The returned io_u is fully ready to be prepped, populated and submitted.
  */
 struct io_u *get_io_u(struct thread_data *td)
 {
@@ -1760,12 +1760,9 @@ struct io_u *get_io_u(struct thread_data *td)
 					td->o.min_bs[DDIR_WRITE],
 					io_u->buflen);
 			} else if ((td->flags & TD_F_SCRAMBLE_BUFFERS) &&
-				   !(td->flags & TD_F_COMPRESS))
+				   !(td->flags & TD_F_COMPRESS) &&
+				   !(td->flags & TD_F_DO_VERIFY))
 				do_scramble = 1;
-			if (td->flags & TD_F_VER_NONE) {
-				populate_verify_io_u(td, io_u);
-				do_scramble = 0;
-			}
 		} else if (io_u->ddir == DDIR_READ) {
 			/*
 			 * Reset the buf_filled parameters so next time if the
diff --git a/iolog.c b/iolog.c
index 2b5eaf0..bfafc03 100644
--- a/iolog.c
+++ b/iolog.c
@@ -978,7 +978,7 @@ int iolog_file_inflate(const char *file)
 	struct iolog_compress ic;
 	z_stream stream;
 	struct stat sb;
-	ssize_t ret;
+	size_t ret;
 	size_t total;
 	void *buf;
 	FILE *f;
@@ -1000,12 +1000,12 @@ int iolog_file_inflate(const char *file)
 	ic.seq = 1;
 
 	ret = fread(ic.buf, ic.len, 1, f);
-	if (ret < 0) {
+	if (ret == 0 && ferror(f)) {
 		perror("fread");
 		fclose(f);
 		free(buf);
 		return 1;
-	} else if (ret != 1) {
+	} else if (ferror(f) || (!feof(f) && ret != 1)) {
 		log_err("fio: short read on reading log\n");
 		fclose(f);
 		free(buf);
diff --git a/options.c b/options.c
index 45a5b82..17d7245 100644
--- a/options.c
+++ b/options.c
@@ -1517,7 +1517,7 @@ static int str_ioengine_external_cb(void *data, const char *str)
 	return 0;
 }
 
-static int rw_verify(struct fio_option *o, void *data)
+static int rw_verify(const struct fio_option *o, void *data)
 {
 	struct thread_data *td = cb_data_to_td(data);
 
@@ -1530,7 +1530,7 @@ static int rw_verify(struct fio_option *o, void *data)
 	return 0;
 }
 
-static int gtod_cpu_verify(struct fio_option *o, void *data)
+static int gtod_cpu_verify(const struct fio_option *o, void *data)
 {
 #ifndef FIO_HAVE_CPU_AFFINITY
 	struct thread_data *td = cb_data_to_td(data);
@@ -4904,7 +4904,7 @@ int fio_options_parse(struct thread_data *td, char **opts, int num_opts)
 	opts_copy = dup_and_sub_options(opts, num_opts);
 
 	for (ret = 0, i = 0, unknown = 0; i < num_opts; i++) {
-		struct fio_option *o;
+		const struct fio_option *o;
 		int newret = parse_option(opts_copy[i], opts[i], fio_options,
 						&o, &td->o, &td->opt_list);
 
@@ -4930,7 +4930,7 @@ int fio_options_parse(struct thread_data *td, char **opts, int num_opts)
 			opts = opts_copy;
 		}
 		for (i = 0; i < num_opts; i++) {
-			struct fio_option *o = NULL;
+			const struct fio_option *o = NULL;
 			int newret = 1;
 
 			if (!opts_copy[i])
@@ -4961,9 +4961,9 @@ int fio_cmd_option_parse(struct thread_data *td, const char *opt, char *val)
 
 	ret = parse_cmd_option(opt, val, fio_options, &td->o, &td->opt_list);
 	if (!ret) {
-		struct fio_option *o;
+		const struct fio_option *o;
 
-		o = find_option(fio_options, opt);
+		o = find_option_c(fio_options, opt);
 		if (o)
 			fio_option_mark_set(&td->o, o);
 	}
@@ -5028,7 +5028,7 @@ unsigned int fio_get_kb_base(void *data)
 	return kb_base;
 }
 
-int add_option(struct fio_option *o)
+int add_option(const struct fio_option *o)
 {
 	struct fio_option *__o;
 	int opt_index = 0;
@@ -5165,7 +5165,7 @@ bool __fio_option_is_set(struct thread_options *o, unsigned int off1)
 	return false;
 }
 
-void fio_option_mark_set(struct thread_options *o, struct fio_option *opt)
+void fio_option_mark_set(struct thread_options *o, const struct fio_option *opt)
 {
 	unsigned int opt_off, index, offset;
 
diff --git a/options.h b/options.h
index 59024ef..e53eb1b 100644
--- a/options.h
+++ b/options.h
@@ -8,7 +8,7 @@
 #include "parse.h"
 #include "lib/types.h"
 
-int add_option(struct fio_option *);
+int add_option(const struct fio_option *);
 void invalidate_profile_options(const char *);
 extern char *exec_profile;
 
@@ -31,9 +31,10 @@ extern bool __fio_option_is_set(struct thread_options *, unsigned int off);
 	__r;								\
 })
 
-extern void fio_option_mark_set(struct thread_options *, struct fio_option *);
+extern void fio_option_mark_set(struct thread_options *,
+				const struct fio_option *);
 
-static inline bool o_match(struct fio_option *o, const char *opt)
+static inline bool o_match(const struct fio_option *o, const char *opt)
 {
 	if (!strcmp(o->name, opt))
 		return true;
@@ -44,6 +45,8 @@ static inline bool o_match(struct fio_option *o, const char *opt)
 }
 
 extern struct fio_option *find_option(struct fio_option *, const char *);
+extern const struct fio_option *
+find_option_c(const struct fio_option *, const char *);
 extern struct fio_option *fio_option_find(const char *);
 extern unsigned int fio_get_kb_base(void *);
 
diff --git a/parse.c b/parse.c
index 33fcf46..deb4120 100644
--- a/parse.c
+++ b/parse.c
@@ -39,7 +39,7 @@ static const char *opt_type_names[] = {
 	"OPT_UNSUPPORTED",
 };
 
-static struct fio_option *__fio_options;
+static const struct fio_option *__fio_options;
 
 static int vp_cmp(const void *p1, const void *p2)
 {
@@ -49,7 +49,7 @@ static int vp_cmp(const void *p1, const void *p2)
 	return strlen(vp2->ival) - strlen(vp1->ival);
 }
 
-static void posval_sort(struct fio_option *o, struct value_pair *vpmap)
+static void posval_sort(const struct fio_option *o, struct value_pair *vpmap)
 {
 	const struct value_pair *vp;
 	int entries;
@@ -67,14 +67,15 @@ static void posval_sort(struct fio_option *o, struct value_pair *vpmap)
 	qsort(vpmap, entries, sizeof(struct value_pair), vp_cmp);
 }
 
-static void show_option_range(struct fio_option *o,
+static void show_option_range(const struct fio_option *o,
 			      size_t (*logger)(const char *format, ...))
 {
 	if (o->type == FIO_OPT_FLOAT_LIST) {
-		if (o->minfp == DBL_MIN && o->maxfp == DBL_MAX)
+		if (!o->minfp && !o->maxfp)
 			return;
 
-		logger("%20s: min=%f", "range", o->minfp);
+		if (o->minfp != DBL_MIN)
+			logger("%20s: min=%f", "range", o->minfp);
 		if (o->maxfp != DBL_MAX)
 			logger(", max=%f", o->maxfp);
 		logger("\n");
@@ -89,7 +90,7 @@ static void show_option_range(struct fio_option *o,
 	}
 }
 
-static void show_option_values(struct fio_option *o)
+static void show_option_values(const struct fio_option *o)
 {
 	int i;
 
@@ -109,7 +110,7 @@ static void show_option_values(struct fio_option *o)
 		log_info("\n");
 }
 
-static void show_option_help(struct fio_option *o, int is_err)
+static void show_option_help(const struct fio_option *o, int is_err)
 {
 	const char *typehelp[] = {
 		"invalid",
@@ -484,7 +485,7 @@ static int str_match_len(const struct value_pair *vp, const char *str)
 			*ptr = (val);			\
 	} while (0)
 
-static const char *opt_type_name(struct fio_option *o)
+static const char *opt_type_name(const struct fio_option *o)
 {
 	compiletime_assert(ARRAY_SIZE(opt_type_names) - 1 == FIO_OPT_UNSUPPORTED,
 				"opt_type_names[] index");
@@ -495,8 +496,8 @@ static const char *opt_type_name(struct fio_option *o)
 	return "OPT_UNKNOWN?";
 }
 
-static int __handle_option(struct fio_option *o, const char *ptr, void *data,
-			   int first, int more, int curr)
+static int __handle_option(const struct fio_option *o, const char *ptr,
+			   void *data, int first, int more, int curr)
 {
 	int il=0, *ilp;
 	fio_fp64_t *flp;
@@ -668,15 +669,17 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 			log_err("not a floating point value: %s\n", ptr);
 			return 1;
 		}
-		if (uf > o->maxfp) {
-			log_err("value out of range: %f"
-				" (range max: %f)\n", uf, o->maxfp);
-			return 1;
-		}
-		if (uf < o->minfp) {
-			log_err("value out of range: %f"
-				" (range min: %f)\n", uf, o->minfp);
-			return 1;
+		if (o->minfp || o->maxfp) {
+			if (uf > o->maxfp) {
+				log_err("value out of range: %f"
+					" (range max: %f)\n", uf, o->maxfp);
+				return 1;
+			}
+			if (uf < o->minfp) {
+				log_err("value out of range: %f"
+					" (range min: %f)\n", uf, o->minfp);
+				return 1;
+			}
 		}
 
 		flp = td_var(data, o, o->off1);
@@ -892,7 +895,8 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 	return ret;
 }
 
-static int handle_option(struct fio_option *o, const char *__ptr, void *data)
+static int handle_option(const struct fio_option *o, const char *__ptr,
+			 void *data)
 {
 	char *o_ptr, *ptr, *ptr2;
 	int ret, done;
@@ -970,11 +974,16 @@ struct fio_option *find_option(struct fio_option *options, const char *opt)
 	return NULL;
 }
 
+const struct fio_option *
+find_option_c(const struct fio_option *options, const char *opt)
+{
+	return find_option((struct fio_option *)options, opt);
+}
 
-static struct fio_option *get_option(char *opt,
-				     struct fio_option *options, char **post)
+static const struct fio_option *
+get_option(char *opt, const struct fio_option *options, char **post)
 {
-	struct fio_option *o;
+	const struct fio_option *o;
 	char *ret;
 
 	ret = strchr(opt, '=');
@@ -984,9 +993,9 @@ static struct fio_option *get_option(char *opt,
 		ret = opt;
 		(*post)++;
 		strip_blank_end(ret);
-		o = find_option(options, ret);
+		o = find_option_c(options, ret);
 	} else {
-		o = find_option(options, opt);
+		o = find_option_c(options, opt);
 		*post = NULL;
 	}
 
@@ -995,7 +1004,7 @@ static struct fio_option *get_option(char *opt,
 
 static int opt_cmp(const void *p1, const void *p2)
 {
-	struct fio_option *o;
+	const struct fio_option *o;
 	char *s, *foo;
 	int prio1, prio2;
 
@@ -1019,15 +1028,15 @@ static int opt_cmp(const void *p1, const void *p2)
 	return prio2 - prio1;
 }
 
-void sort_options(char **opts, struct fio_option *options, int num_opts)
+void sort_options(char **opts, const struct fio_option *options, int num_opts)
 {
 	__fio_options = options;
 	qsort(opts, num_opts, sizeof(char *), opt_cmp);
 	__fio_options = NULL;
 }
 
-static void add_to_dump_list(struct fio_option *o, struct flist_head *dump_list,
-			     const char *post)
+static void add_to_dump_list(const struct fio_option *o,
+			     struct flist_head *dump_list, const char *post)
 {
 	struct print_option *p;
 
@@ -1045,12 +1054,12 @@ static void add_to_dump_list(struct fio_option *o, struct flist_head *dump_list,
 }
 
 int parse_cmd_option(const char *opt, const char *val,
-		     struct fio_option *options, void *data,
+		     const struct fio_option *options, void *data,
 		     struct flist_head *dump_list)
 {
-	struct fio_option *o;
+	const struct fio_option *o;
 
-	o = find_option(options, opt);
+	o = find_option_c(options, opt);
 	if (!o) {
 		log_err("Bad option <%s>\n", opt);
 		return 1;
@@ -1065,8 +1074,8 @@ int parse_cmd_option(const char *opt, const char *val,
 	return 0;
 }
 
-int parse_option(char *opt, const char *input,
-		 struct fio_option *options, struct fio_option **o, void *data,
+int parse_option(char *opt, const char *input, const struct fio_option *options,
+		 const struct fio_option **o, void *data,
 		 struct flist_head *dump_list)
 {
 	char *post;
@@ -1151,10 +1160,10 @@ int string_distance_ok(const char *opt, int distance)
 	return distance <= len;
 }
 
-static struct fio_option *find_child(struct fio_option *options,
-				     struct fio_option *o)
+static const struct fio_option *find_child(const struct fio_option *options,
+					   const struct fio_option *o)
 {
-	struct fio_option *__o;
+	const struct fio_option *__o;
 
 	for (__o = options + 1; __o->name; __o++)
 		if (__o->parent && !strcmp(__o->parent, o->name))
@@ -1163,7 +1172,8 @@ static struct fio_option *find_child(struct fio_option *options,
 	return NULL;
 }
 
-static void __print_option(struct fio_option *o, struct fio_option *org,
+static void __print_option(const struct fio_option *o,
+			   const struct fio_option *org,
 			   int level)
 {
 	char name[256], *p;
@@ -1184,10 +1194,10 @@ static void __print_option(struct fio_option *o, struct fio_option *org,
 	log_info("%-24s: %s\n", name, o->help);
 }
 
-static void print_option(struct fio_option *o)
+static void print_option(const struct fio_option *o)
 {
-	struct fio_option *parent;
-	struct fio_option *__o;
+	const struct fio_option *parent;
+	const struct fio_option *__o;
 	unsigned int printed;
 	unsigned int level;
 
@@ -1208,9 +1218,9 @@ static void print_option(struct fio_option *o)
 	} while (printed);
 }
 
-int show_cmd_help(struct fio_option *options, const char *name)
+int show_cmd_help(const struct fio_option *options, const char *name)
 {
-	struct fio_option *o, *closest;
+	const struct fio_option *o, *closest;
 	unsigned int best_dist = -1U;
 	int found = 0;
 	int show_all = 0;
@@ -1284,9 +1294,9 @@ int show_cmd_help(struct fio_option *options, const char *name)
 /*
  * Handle parsing of default parameters.
  */
-void fill_default_options(void *data, struct fio_option *options)
+void fill_default_options(void *data, const struct fio_option *options)
 {
-	struct fio_option *o;
+	const struct fio_option *o;
 
 	dprint(FD_PARSE, "filling default options\n");
 
@@ -1309,10 +1319,6 @@ static void option_init(struct fio_option *o)
 		if (!o->maxval)
 			o->maxval = UINT_MAX;
 	}
-	if (o->type == FIO_OPT_FLOAT_LIST) {
-		o->minfp = DBL_MIN;
-		o->maxfp = DBL_MAX;
-	}
 	if (o->type == FIO_OPT_STR_SET && o->def && !o->no_warn_def) {
 		log_err("Option %s: string set option with"
 				" default will always be true\n", o->name);
@@ -1346,9 +1352,9 @@ void options_init(struct fio_option *options)
 	}
 }
 
-void options_mem_dupe(struct fio_option *options, void *data)
+void options_mem_dupe(const struct fio_option *options, void *data)
 {
-	struct fio_option *o;
+	const struct fio_option *o;
 	char **ptr;
 
 	dprint(FD_PARSE, "dup options\n");
@@ -1363,9 +1369,9 @@ void options_mem_dupe(struct fio_option *options, void *data)
 	}
 }
 
-void options_free(struct fio_option *options, void *data)
+void options_free(const struct fio_option *options, void *data)
 {
-	struct fio_option *o;
+	const struct fio_option *o;
 	char **ptr;
 
 	dprint(FD_PARSE, "free options\n");
diff --git a/parse.h b/parse.h
index d05236b..4ad92d9 100644
--- a/parse.h
+++ b/parse.h
@@ -68,7 +68,7 @@ struct fio_option {
 	int hide_on_set;		/* hide on set, not on unset */
 	const char *inverse;		/* if set, apply opposite action to this option */
 	struct fio_option *inv_opt;	/* cached lookup */
-	int (*verify)(struct fio_option *, void *);
+	int (*verify)(const struct fio_option *, void *);
 	const char *prof_name;		/* only valid for specific profile */
 	void *prof_opts;
 	uint64_t category;		/* what type of option */
@@ -81,14 +81,18 @@ struct fio_option {
 	int no_free;
 };
 
-extern int parse_option(char *, const char *, struct fio_option *, struct fio_option **, void *, struct flist_head *);
-extern void sort_options(char **, struct fio_option *, int);
-extern int parse_cmd_option(const char *t, const char *l, struct fio_option *, void *, struct flist_head *);
-extern int show_cmd_help(struct fio_option *, const char *);
-extern void fill_default_options(void *, struct fio_option *);
+extern int parse_option(char *, const char *, const struct fio_option *,
+			const struct fio_option **, void *,
+			struct flist_head *);
+extern void sort_options(char **, const struct fio_option *, int);
+extern int parse_cmd_option(const char *t, const char *l,
+			    const struct fio_option *, void *,
+			    struct flist_head *);
+extern int show_cmd_help(const struct fio_option *, const char *);
+extern void fill_default_options(void *, const struct fio_option *);
 extern void options_init(struct fio_option *);
-extern void options_mem_dupe(struct fio_option *, void *);
-extern void options_free(struct fio_option *, void *);
+extern void options_mem_dupe(const struct fio_option *, void *);
+extern void options_free(const struct fio_option *, void *);
 
 extern void strip_blank_front(char **);
 extern void strip_blank_end(char *);
@@ -108,7 +112,8 @@ typedef int (fio_opt_str_val_fn)(void *, long long *);
 typedef int (fio_opt_int_fn)(void *, int *);
 
 struct thread_options;
-static inline void *td_var(void *to, struct fio_option *o, unsigned int offset)
+static inline void *td_var(void *to, const struct fio_option *o,
+			   unsigned int offset)
 {
 	void *ret;
 
@@ -117,7 +122,7 @@ static inline void *td_var(void *to, struct fio_option *o, unsigned int offset)
 	else
 		ret = to;
 
-	return (char *) ret + offset;
+	return ret + offset;
 }
 
 static inline int parse_is_percent(unsigned long long val)
