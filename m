Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40325 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbaBMNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 13 Feb 2014 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WDvtc-00066K-SU
	for fio@vger.kernel.org; Thu, 13 Feb 2014 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140213130003.DED92436BC@strynoevaenget.dk>
Date: Thu, 13 Feb 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f0fdbcafc3a62b84250e5ccdcaec47e3ffa93a00:

  parse: cleanup difference between profile and normal options (2014-02-11 15:44:50 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8d6ecac27d36b3001c8fed00eab7f32cd573636a:

  null: style fixup (2014-02-12 21:25:20 -0700)

----------------------------------------------------------------
Daniel Gollub (5):
      Make file.h C++ safe by casting fio_file_flags
      Make parse.h C++ safe by avoiding "or" keyword
      Fix g++ warning about void* used in arithmetic
      Introduce get_ioengine for external engines
      engines/null: allow build as external C++ ioengine

Jens Axboe (3):
      Make err.h a bit more Windows friendly
      clang: fix warnings with clang build
      null: style fixup

 engines/null.c      |   48 +++++++++++++++++++++++++++++++++++++++++-------
 err.h               |   16 ++++++++--------
 file.h              |    4 ++--
 fio.h               |    4 ++--
 goptions.c          |    2 +-
 ioengine.h          |    5 +++++
 ioengines.c         |   14 ++++++++++++++
 options.c           |    6 +++---
 parse.c             |    2 +-
 parse.h             |    4 ++--
 profiles/tiobench.c |    1 -
 11 files changed, 79 insertions(+), 27 deletions(-)

---

Diff of recent changes:

diff --git a/engines/null.c b/engines/null.c
index bf7885e..eb17b11 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -4,6 +4,10 @@
  * IO engine that doesn't do any real IO transfers, it just pretends to.
  * The main purpose is to test fio itself.
  *
+ * It also can act as external C++ engine - compiled with:
+ *
+ * g++ -O2 -g -shared -rdynamic -fPIC -o null.so null.c -DFIO_EXTERNAL_ENGINE
+ *
  */
 #include <stdio.h>
 #include <stdlib.h>
@@ -21,7 +25,7 @@ struct null_data {
 
 static struct io_u *fio_null_event(struct thread_data *td, int event)
 {
-	struct null_data *nd = td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops->data;
 
 	return nd->io_us[event];
 }
@@ -30,7 +34,7 @@ static int fio_null_getevents(struct thread_data *td, unsigned int min_events,
 			      unsigned int fio_unused max,
 			      struct timespec fio_unused *t)
 {
-	struct null_data *nd = td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops->data;
 	int ret = 0;
 	
 	if (min_events) {
@@ -43,10 +47,12 @@ static int fio_null_getevents(struct thread_data *td, unsigned int min_events,
 
 static int fio_null_commit(struct thread_data *td)
 {
-	struct null_data *nd = td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops->data;
 
 	if (!nd->events) {
+#ifndef FIO_EXTERNAL_ENGINE
 		io_u_mark_submit(td, nd->queued);
+#endif
 		nd->events = nd->queued;
 		nd->queued = 0;
 	}
@@ -56,7 +62,7 @@ static int fio_null_commit(struct thread_data *td)
 
 static int fio_null_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct null_data *nd = td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops->data;
 
 	fio_ro_check(td, io_u);
 
@@ -77,7 +83,7 @@ static int fio_null_open(struct thread_data fio_unused *td,
 
 static void fio_null_cleanup(struct thread_data *td)
 {
-	struct null_data *nd = td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops->data;
 
 	if (nd) {
 		if (nd->io_us)
@@ -88,12 +94,12 @@ static void fio_null_cleanup(struct thread_data *td)
 
 static int fio_null_init(struct thread_data *td)
 {
-	struct null_data *nd = malloc(sizeof(*nd));
+	struct null_data *nd = (struct null_data *) malloc(sizeof(*nd));
 
 	memset(nd, 0, sizeof(*nd));
 
 	if (td->o.iodepth != 1) {
-		nd->io_us = malloc(td->o.iodepth * sizeof(struct io_u *));
+		nd->io_us = (struct io_u **) malloc(td->o.iodepth * sizeof(struct io_u *));
 		memset(nd->io_us, 0, td->o.iodepth * sizeof(struct io_u *));
 	} else
 		td->io_ops->flags |= FIO_SYNCIO;
@@ -102,6 +108,7 @@ static int fio_null_init(struct thread_data *td)
 	return 0;
 }
 
+#ifndef __cplusplus
 static struct ioengine_ops ioengine = {
 	.name		= "null",
 	.version	= FIO_IOOPS_VERSION,
@@ -124,3 +131,30 @@ static void fio_exit fio_null_unregister(void)
 {
 	unregister_ioengine(&ioengine);
 }
+
+#else
+
+#ifdef FIO_EXTERNAL_ENGINE
+extern "C" {
+void get_ioengine(struct ioengine_ops **ioengine_ptr)
+{
+	struct ioengine_ops *ioengine;
+
+	*ioengine_ptr = (struct ioengine_ops *) malloc(sizeof(struct ioengine_ops));
+	ioengine = *ioengine_ptr;
+
+	strcpy(ioengine->name, "cpp_null");
+	ioengine->version        = FIO_IOOPS_VERSION;
+	ioengine->queue          = fio_null_queue;
+	ioengine->commit         = fio_null_commit;
+	ioengine->getevents      = fio_null_getevents;
+	ioengine->event          = fio_null_event;
+	ioengine->init           = fio_null_init;
+	ioengine->cleanup        = fio_null_cleanup;
+	ioengine->open_file      = fio_null_open;
+	ioengine->flags	         = FIO_DISKLESSIO;
+}
+}
+#endif /* FIO_EXTERNAL_ENGINE */
+
+#endif /* __cplusplus */
diff --git a/err.h b/err.h
index 5c024ee..0765f1b 100644
--- a/err.h
+++ b/err.h
@@ -11,26 +11,26 @@
  */
 #define MAX_ERRNO	4095
 
-#define IS_ERR_VALUE(x) ((x) >= (unsigned long)-MAX_ERRNO)
+#define IS_ERR_VALUE(x) ((x) >= (uintptr_t)-MAX_ERRNO)
 
-static inline void *ERR_PTR(long error)
+static inline void *ERR_PTR(uintptr_t error)
 {
 	return (void *) error;
 }
 
-static inline long PTR_ERR(const void *ptr)
+static inline uintptr_t PTR_ERR(const void *ptr)
 {
-	return (long) ptr;
+	return (uintptr_t) ptr;
 }
 
-static inline long IS_ERR(const void *ptr)
+static inline uintptr_t IS_ERR(const void *ptr)
 {
-	return IS_ERR_VALUE((unsigned long)ptr);
+	return IS_ERR_VALUE((uintptr_t)ptr);
 }
 
-static inline long IS_ERR_OR_NULL(const void *ptr)
+static inline uintptr_t IS_ERR_OR_NULL(const void *ptr)
 {
-	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
+	return !ptr || IS_ERR_VALUE((uintptr_t)ptr);
 }
 
 static inline int PTR_ERR_OR_ZERO(const void *ptr)
diff --git a/file.h b/file.h
index 19413fc..c1d02a5 100644
--- a/file.h
+++ b/file.h
@@ -128,11 +128,11 @@ struct fio_file {
 #define FILE_FLAG_FNS(name)						\
 static inline void fio_file_set_##name(struct fio_file *f)		\
 {									\
-	(f)->flags |= FIO_FILE_##name;					\
+	(f)->flags = (enum fio_file_flags) ((f)->flags | FIO_FILE_##name);	\
 }									\
 static inline void fio_file_clear_##name(struct fio_file *f)		\
 {									\
-	(f)->flags &= ~FIO_FILE_##name;					\
+	(f)->flags = (enum fio_file_flags) ((f)->flags & ~FIO_FILE_##name);	\
 }									\
 static inline int fio_file_##name(struct fio_file *f)			\
 {									\
diff --git a/fio.h b/fio.h
index 719b2f3..cda4668 100644
--- a/fio.h
+++ b/fio.h
@@ -343,10 +343,10 @@ enum {
 
 #define __td_verror(td, err, msg, func)					\
 	do {								\
-		int __e = (err);						\
+		int ____e = (err);						\
 		if ((td)->error)					\
 			break;						\
-		(td)->error = __e;					\
+		(td)->error = ____e;					\
 		if (!(td)->first_error)					\
 			snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=%s, error=%s", __FILE__, __LINE__, (func), (msg));		\
 	} while (0)
diff --git a/goptions.c b/goptions.c
index 21d6427..5b5c89e 100644
--- a/goptions.c
+++ b/goptions.c
@@ -1216,7 +1216,7 @@ static void gopt_handle_str_multi_changed(struct gopt_job_view *gjv,
 			break;
 		set = gtk_toggle_button_get_active(GTK_TOGGLE_BUTTON(m->checks[i]));
 		if (set) {
-			if (vp->or)
+			if (vp->orval)
 				val |= vp->oval;
 			else
 				val = vp->oval;
diff --git a/ioengine.h b/ioengine.h
index 19ed10b..abf2b46 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -168,6 +168,11 @@ enum fio_ioengine_flags {
 };
 
 /*
+ * External engine defined symbol to fill in the engine ops structure
+ */
+typedef void (*get_ioengine_t)(struct ioengine_ops **);
+
+/*
  * io engine entry points
  */
 extern int __must_check td_io_init(struct thread_data *);
diff --git a/ioengines.c b/ioengines.c
index d71e372..3c75fa6 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -107,6 +107,20 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 	ops = dlsym(dlhandle, engine_lib);
 	if (!ops)
 		ops = dlsym(dlhandle, "ioengine");
+
+	/*
+	 * For some external engines (like C++ ones) it is not that trivial
+	 * to provide a non-static ionengine structure that we can reference.
+	 * Instead we call a method which allocates the required ioengine
+	 * structure.
+	 */
+	if (!ops) {
+		get_ioengine_t get_ioengine = dlsym(dlhandle, "get_ioengine");
+
+		if (get_ioengine)
+			get_ioengine(&ops);
+	}
+
 	if (!ops) {
 		td_vmsg(td, -1, dlerror(), "dlsym");
 		dlclose(dlhandle);
diff --git a/options.c b/options.c
index 9f6bc8d..4dcefba 100644
--- a/options.c
+++ b/options.c
@@ -1914,18 +1914,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  { .ival = "wait_before",
 			    .oval = SYNC_FILE_RANGE_WAIT_BEFORE,
 			    .help = "SYNC_FILE_RANGE_WAIT_BEFORE",
-			    .or	  = 1,
+			    .orval  = 1,
 			  },
 			  { .ival = "write",
 			    .oval = SYNC_FILE_RANGE_WRITE,
 			    .help = "SYNC_FILE_RANGE_WRITE",
-			    .or	  = 1,
+			    .orval  = 1,
 			  },
 			  {
 			    .ival = "wait_after",
 			    .oval = SYNC_FILE_RANGE_WAIT_AFTER,
 			    .help = "SYNC_FILE_RANGE_WAIT_AFTER",
-			    .or	  = 1,
+			    .orval  = 1,
 			  },
 		},
 		.type	= FIO_OPT_STR_MULTI,
diff --git a/parse.c b/parse.c
index 6121dfc..e46fc14 100644
--- a/parse.c
+++ b/parse.c
@@ -415,7 +415,7 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 			if (!strncmp(vp->ival, ptr, str_match_len(vp, ptr))) {
 				ret = 0;
 				if (o->off1)
-					val_store(ilp, vp->oval, o->off1, vp->or, data, o);
+					val_store(ilp, vp->oval, o->off1, vp->orval, data, o);
 				continue;
 			}
 		}
diff --git a/parse.h b/parse.h
index 8eefff9..1009252 100644
--- a/parse.h
+++ b/parse.h
@@ -28,7 +28,7 @@ struct value_pair {
 	const char *ival;		/* string option */
 	unsigned int oval;		/* output value */
 	const char *help;		/* help text for sub option */
-	int or;				/* OR value */
+	int orval;			/* OR value */
 	void *cb;			/* sub-option callback */
 };
 
@@ -100,7 +100,7 @@ typedef int (fio_opt_str_val_fn)(void *, long long *);
 typedef int (fio_opt_int_fn)(void *, int *);
 typedef int (fio_opt_str_set_fn)(void *);
 
-#define __td_var(start, offset)	((void *) start + (offset))
+#define __td_var(start, offset)	((char *) start + (offset))
 
 struct thread_options;
 static inline void *td_var(struct thread_options *to, struct fio_option *o,
diff --git a/profiles/tiobench.c b/profiles/tiobench.c
index 99c88c4..7a7030a 100644
--- a/profiles/tiobench.c
+++ b/profiles/tiobench.c
@@ -113,7 +113,6 @@ static int tb_prep_cmdline(void)
 static struct profile_ops tiobench_profile = {
 	.name		= "tiobench",
 	.desc		= "tiotest/tiobench benchmark",
-	.options	= options,
 	.prep_cmd	= tb_prep_cmdline,
 	.cmdline	= tb_opts,
 	.options	= options,
