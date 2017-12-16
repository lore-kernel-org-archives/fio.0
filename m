Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54054 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753278AbdLPNAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 16 Dec 2017 08:00:12 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eQC4Z-0006Xx-8V
        for fio@vger.kernel.org; Sat, 16 Dec 2017 13:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171216130001.A9A962C009F@kernel.dk>
Date: Sat, 16 Dec 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit db37d89074ed204c9c2bd010e72f63dcf4725715:

  Allow configurable ETA intervals (2017-12-14 11:51:41 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9b50942ecec9c79fa82050c503fe313cfd87ac96:

  ioengines: clear out ->td_ops_dlhandle if we close it (2017-12-15 13:35:56 -0700)

----------------------------------------------------------------
Jens Axboe (5):
      parse: dump option type when using --debug=parse
      ioengines: improve "is this the same IO engine" check
      parse: don't check for < 0 on an unsigned type
      init: fix missing dlhandle reference put
      ioengines: clear out ->td_ops_dlhandle if we close it

 compiler/compiler.h |  5 +++++
 fio.h               |  5 -----
 init.c              | 20 ++++++++++++++++++++
 ioengines.c         |  4 +++-
 parse.c             | 32 ++++++++++++++++++++++++++++++--
 parse.h             |  2 +-
 6 files changed, 59 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/compiler/compiler.h b/compiler/compiler.h
index 20df21d..91a9883 100644
--- a/compiler/compiler.h
+++ b/compiler/compiler.h
@@ -69,4 +69,9 @@
 
 #endif
 
+#ifdef FIO_INTERNAL
+#define ARRAY_SIZE(x)    (sizeof((x)) / (sizeof((x)[0])))
+#define FIELD_SIZE(s, f) (sizeof(((typeof(s))0)->f))
+#endif
+
 #endif
diff --git a/fio.h b/fio.h
index b3b95ef..334f203 100644
--- a/fio.h
+++ b/fio.h
@@ -800,11 +800,6 @@ static inline void td_flags_set(struct thread_data *td, unsigned int *flags,
 extern const char *fio_get_arch_string(int);
 extern const char *fio_get_os_string(int);
 
-#ifdef FIO_INTERNAL
-#define ARRAY_SIZE(x)    (sizeof((x)) / (sizeof((x)[0])))
-#define FIELD_SIZE(s, f) (sizeof(((typeof(s))0)->f))
-#endif
-
 enum {
 	__FIO_OUTPUT_TERSE	= 0,
 	__FIO_OUTPUT_JSON	= 1,
diff --git a/init.c b/init.c
index b9da713..f7d79c1 100644
--- a/init.c
+++ b/init.c
@@ -11,6 +11,7 @@
 #include <sys/ipc.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <dlfcn.h>
 
 #include "fio.h"
 #ifndef FIO_NO_HAVE_SHM_H
@@ -1064,6 +1065,9 @@ int ioengine_load(struct thread_data *td)
 	}
 
 	if (td->io_ops) {
+		struct ioengine_ops *ops;
+		void *dlhandle;
+
 		/* An engine is loaded, but the requested ioengine
 		 * may have changed.
 		 */
@@ -1072,6 +1076,22 @@ int ioengine_load(struct thread_data *td)
 			return 0;
 		}
 
+		/*
+		 * Name of file and engine may be different, load ops
+		 * for this name and see if they match. If they do, then
+		 * the engine is unchanged.
+		 */
+		dlhandle = td->io_ops_dlhandle;
+		ops = load_ioengine(td);
+		if (ops == td->io_ops && dlhandle == td->io_ops_dlhandle) {
+			if (dlhandle)
+				dlclose(dlhandle);
+			return 0;
+		}
+
+		if (dlhandle && dlhandle != td->io_ops_dlhandle)
+			dlclose(dlhandle);
+
 		/* Unload the old engine. */
 		free_ioengine(td);
 	}
diff --git a/ioengines.c b/ioengines.c
index 7951ff3..cec0c76 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -194,8 +194,10 @@ void free_ioengine(struct thread_data *td)
 		td->eo = NULL;
 	}
 
-	if (td->io_ops_dlhandle)
+	if (td->io_ops_dlhandle) {
 		dlclose(td->io_ops_dlhandle);
+		td->io_ops_dlhandle = NULL;
+	}
 
 	td->io_ops = NULL;
 }
diff --git a/parse.c b/parse.c
index 68229d0..a9ee1ce 100644
--- a/parse.c
+++ b/parse.c
@@ -12,6 +12,7 @@
 #include <math.h>
 #include <float.h>
 
+#include "compiler/compiler.h"
 #include "parse.h"
 #include "debug.h"
 #include "options.h"
@@ -24,6 +25,22 @@
 #include "y.tab.h"
 #endif
 
+static const char *opt_type_names[] = {
+	"OPT_INVALID",
+	"OPT_STR",
+	"OPT_STR_MULTI",
+	"OPT_STR_VAL",
+	"OPT_STR_VAL_TIME",
+	"OPT_STR_STORE",
+	"OPT_RANGE",
+	"OPT_INT",
+	"OPT_BOOL",
+	"OPT_FLOAT_LIST",
+	"OPT_STR_SET",
+	"OPT_DEPRECATED",
+	"OPT_UNSUPPORTED",
+};
+
 static struct fio_option *__fio_options;
 
 static int vp_cmp(const void *p1, const void *p2)
@@ -469,6 +486,17 @@ static int str_match_len(const struct value_pair *vp, const char *str)
 			*ptr = (val);			\
 	} while (0)
 
+static const char *opt_type_name(struct fio_option *o)
+{
+	compiletime_assert(ARRAY_SIZE(opt_type_names) - 1 == FIO_OPT_UNSUPPORTED,
+				"opt_type_names[] index");
+
+	if (o->type <= FIO_OPT_UNSUPPORTED)
+		return opt_type_names[o->type];
+
+	return "OPT_UNKNOWN?";
+}
+
 static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 			   int first, int more, int curr)
 {
@@ -483,8 +511,8 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 	struct value_pair posval[PARSE_MAX_VP];
 	int i, all_skipped = 1;
 
-	dprint(FD_PARSE, "__handle_option=%s, type=%d, ptr=%s\n", o->name,
-							o->type, ptr);
+	dprint(FD_PARSE, "__handle_option=%s, type=%s, ptr=%s\n", o->name,
+							opt_type_name(o), ptr);
 
 	if (!ptr && o->type != FIO_OPT_STR_SET && o->type != FIO_OPT_STR) {
 		log_err("Option %s requires an argument\n", o->name);
diff --git a/parse.h b/parse.h
index dfe7f16..d05236b 100644
--- a/parse.h
+++ b/parse.h
@@ -20,7 +20,7 @@ enum fio_opt_type {
 	FIO_OPT_FLOAT_LIST,
 	FIO_OPT_STR_SET,
 	FIO_OPT_DEPRECATED,
-	FIO_OPT_UNSUPPORTED,
+	FIO_OPT_UNSUPPORTED,	/* keep this last */
 };
 
 /*
