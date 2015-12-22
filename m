Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:42178 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbbLVNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 22 Dec 2015 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aBMXz-0007KF-RP
	for fio@vger.kernel.org; Tue, 22 Dec 2015 13:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151222130002.31A122C2AAE@kernel.dk>
Date: Tue, 22 Dec 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 70c6807675291c2c5ccb38cc9c81b45bcaed0ce1:

  backend: count iterative bytes for progress (2015-12-18 22:33:35 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 72f397487788fc0b542870de5cc29ea8e8134346:

  Make options mask a 64-bit type (2015-12-21 16:03:01 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      backend: only terminate multiple loops if we did no IO
      Make options mask a 64-bit type

 backend.c |  23 +++++++++-----
 options.c |  15 ++++-----
 options.h | 105 ++++++++++++++++++++++++++++++--------------------------------
 3 files changed, 74 insertions(+), 69 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 89ac76b..9920e63 100644
--- a/backend.c
+++ b/backend.c
@@ -808,15 +808,14 @@ static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
  *
  * Returns number of bytes written and trimmed.
  */
-static uint64_t do_io(struct thread_data *td)
+static void do_io(struct thread_data *td, uint64_t *bytes_done)
 {
 	unsigned int i;
 	int ret = 0;
 	uint64_t total_bytes, bytes_issued = 0;
-	uint64_t this_bytes[2];
 
-	this_bytes[0] = td->bytes_done[DDIR_WRITE];
-	this_bytes[1] = td->bytes_done[DDIR_TRIM];
+	for (i = 0; i < DDIR_RWDIR_CNT; i++)
+		bytes_done[i] = td->bytes_done[i];
 
 	if (in_ramp_time(td))
 		td_set_runstate(td, TD_RAMP);
@@ -1050,8 +1049,8 @@ reap:
 	if (!ddir_rw_sum(td->this_io_bytes))
 		td->done = 1;
 
-	return (td->bytes_done[DDIR_WRITE] - this_bytes[0]) +
-		(td->bytes_done[DDIR_TRIM] - this_bytes[1]);
+	for (i = 0; i < DDIR_RWDIR_CNT; i++)
+		bytes_done[i] = td->bytes_done[i] - bytes_done[i];
 }
 
 static void cleanup_io_u(struct thread_data *td)
@@ -1603,9 +1602,17 @@ static void *thread_main(void *data)
 		if (td->o.verify_only && (td_write(td) || td_rw(td)))
 			verify_bytes = do_dry_run(td);
 		else {
-			verify_bytes = do_io(td);
-			if (!verify_bytes)
+			uint64_t bytes_done[DDIR_RWDIR_CNT];
+
+			do_io(td, bytes_done);
+
+			if (!ddir_rw_sum(bytes_done)) {
 				fio_mark_td_terminate(td);
+				verify_bytes = 0;
+			} else {
+				verify_bytes = bytes_done[DDIR_WRITE] +
+						bytes_done[DDIR_TRIM];
+			}
 		}
 
 		clear_state = 1;
diff --git a/options.c b/options.c
index 45726aa..8494713 100644
--- a/options.c
+++ b/options.c
@@ -1075,8 +1075,9 @@ static struct opt_group fio_opt_groups[] = {
 	},
 };
 
-static struct opt_group *__opt_group_from_mask(struct opt_group *ogs, unsigned int *mask,
-					       unsigned int inv_mask)
+static struct opt_group *__opt_group_from_mask(struct opt_group *ogs,
+					       uint64_t *mask,
+					       uint64_t inv_mask)
 {
 	struct opt_group *og;
 	int i;
@@ -1096,7 +1097,7 @@ static struct opt_group *__opt_group_from_mask(struct opt_group *ogs, unsigned i
 	return NULL;
 }
 
-struct opt_group *opt_group_from_mask(unsigned int *mask)
+struct opt_group *opt_group_from_mask(uint64_t *mask)
 {
 	return __opt_group_from_mask(fio_opt_groups, mask, FIO_OPT_C_INVALID);
 }
@@ -1200,7 +1201,7 @@ static struct opt_group fio_opt_cat_groups[] = {
 	}
 };
 
-struct opt_group *opt_group_cat_from_mask(unsigned int *mask)
+struct opt_group *opt_group_cat_from_mask(uint64_t *mask)
 {
 	return __opt_group_from_mask(fio_opt_cat_groups, mask, FIO_OPT_G_INVALID);
 }
@@ -4350,19 +4351,19 @@ static int opt_is_set(struct thread_options *o, struct fio_option *opt)
 	return (o->set_options[index] & ((uint64_t)1 << offset)) != 0;
 }
 
-int __fio_option_is_set(struct thread_options *o, unsigned int off1)
+bool __fio_option_is_set(struct thread_options *o, unsigned int off1)
 {
 	struct fio_option *opt, *next;
 
 	next = NULL;
 	while ((opt = find_next_opt(o, next, off1)) != NULL) {
 		if (opt_is_set(o, opt))
-			return 1;
+			return true;
 
 		next = opt;
 	}
 
-	return 0;
+	return false;
 }
 
 void fio_option_mark_set(struct thread_options *o, struct fio_option *opt)
diff --git a/options.h b/options.h
index fd6ad92..d37b162 100644
--- a/options.h
+++ b/options.h
@@ -4,8 +4,10 @@
 #define FIO_MAX_OPTS		512
 
 #include <string.h>
+#include <inttypes.h>
 #include "parse.h"
 #include "flist.h"
+#include "lib/types.h"
 
 #define td_var_offset(var)	((size_t) &((struct thread_options *)0)->var)
 
@@ -24,30 +26,25 @@ extern char client_sockaddr_str[];  /* used with --client option */
 
 extern struct fio_option fio_options[FIO_MAX_OPTS];
 
-extern int __fio_option_is_set(struct thread_options *, unsigned int off);
+extern bool __fio_option_is_set(struct thread_options *, unsigned int off);
 
 #define fio_option_is_set(__td, name)					\
 ({									\
 	const unsigned int off = td_var_offset(name);			\
-	int __r = __fio_option_is_set((__td), off);			\
-	if (__r == -1) {						\
-		dprint(FD_PARSE, "option %s/%u not found in map\n",	\
-				__fio_stringify(name), off);		\
-		__r = 0;						\
-	}								\
+	bool __r = __fio_option_is_set((__td), off);			\
 	__r;								\
 })
 
 extern void fio_option_mark_set(struct thread_options *, struct fio_option *);
 
-static inline int o_match(struct fio_option *o, const char *opt)
+static inline bool o_match(struct fio_option *o, const char *opt)
 {
 	if (!strcmp(o->name, opt))
-		return 1;
+		return true;
 	else if (o->alias && !strcmp(o->alias, opt))
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 
 static inline struct fio_option *find_option(struct fio_option *options,
@@ -64,7 +61,7 @@ static inline struct fio_option *find_option(struct fio_option *options,
 
 struct opt_group {
 	const char *name;
-	unsigned int mask;
+	uint64_t mask;
 };
 
 enum opt_category {
@@ -77,14 +74,14 @@ enum opt_category {
 	__FIO_OPT_C_ENGINE,
 	__FIO_OPT_C_NR,
 
-	FIO_OPT_C_GENERAL	= (1U << __FIO_OPT_C_GENERAL),
-	FIO_OPT_C_IO		= (1U << __FIO_OPT_C_IO),
-	FIO_OPT_C_FILE		= (1U << __FIO_OPT_C_FILE),
-	FIO_OPT_C_STAT		= (1U << __FIO_OPT_C_STAT),
-	FIO_OPT_C_LOG		= (1U << __FIO_OPT_C_LOG),
-	FIO_OPT_C_PROFILE	= (1U << __FIO_OPT_C_PROFILE),
-	FIO_OPT_C_ENGINE	= (1U << __FIO_OPT_C_ENGINE),
-	FIO_OPT_C_INVALID	= (1U << __FIO_OPT_C_NR),
+	FIO_OPT_C_GENERAL	= (1ULL << __FIO_OPT_C_GENERAL),
+	FIO_OPT_C_IO		= (1ULL << __FIO_OPT_C_IO),
+	FIO_OPT_C_FILE		= (1ULL << __FIO_OPT_C_FILE),
+	FIO_OPT_C_STAT		= (1ULL << __FIO_OPT_C_STAT),
+	FIO_OPT_C_LOG		= (1ULL << __FIO_OPT_C_LOG),
+	FIO_OPT_C_PROFILE	= (1ULL << __FIO_OPT_C_PROFILE),
+	FIO_OPT_C_ENGINE	= (1ULL << __FIO_OPT_C_ENGINE),
+	FIO_OPT_C_INVALID	= (1ULL << __FIO_OPT_C_NR),
 };
 
 enum opt_category_group {
@@ -121,42 +118,42 @@ enum opt_category_group {
         __FIO_OPT_G_MTD,
 	__FIO_OPT_G_NR,
 
-	FIO_OPT_G_RATE		= (1U << __FIO_OPT_G_RATE),
-	FIO_OPT_G_ZONE		= (1U << __FIO_OPT_G_ZONE),
-	FIO_OPT_G_RWMIX		= (1U << __FIO_OPT_G_RWMIX),
-	FIO_OPT_G_VERIFY	= (1U << __FIO_OPT_G_VERIFY),
-	FIO_OPT_G_TRIM		= (1U << __FIO_OPT_G_TRIM),
-	FIO_OPT_G_IOLOG		= (1U << __FIO_OPT_G_IOLOG),
-	FIO_OPT_G_IO_DEPTH	= (1U << __FIO_OPT_G_IO_DEPTH),
-	FIO_OPT_G_IO_FLOW	= (1U << __FIO_OPT_G_IO_FLOW),
-	FIO_OPT_G_DESC		= (1U << __FIO_OPT_G_DESC),
-	FIO_OPT_G_FILENAME	= (1U << __FIO_OPT_G_FILENAME),
-	FIO_OPT_G_IO_BASIC	= (1U << __FIO_OPT_G_IO_BASIC),
-	FIO_OPT_G_CGROUP	= (1U << __FIO_OPT_G_CGROUP),
-	FIO_OPT_G_RUNTIME	= (1U << __FIO_OPT_G_RUNTIME),
-	FIO_OPT_G_PROCESS	= (1U << __FIO_OPT_G_PROCESS),
-	FIO_OPT_G_CRED		= (1U << __FIO_OPT_G_CRED),
-	FIO_OPT_G_CLOCK		= (1U << __FIO_OPT_G_CLOCK),
-	FIO_OPT_G_IO_TYPE	= (1U << __FIO_OPT_G_IO_TYPE),
-	FIO_OPT_G_THINKTIME	= (1U << __FIO_OPT_G_THINKTIME),
-	FIO_OPT_G_RANDOM	= (1U << __FIO_OPT_G_RANDOM),
-	FIO_OPT_G_IO_BUF	= (1U << __FIO_OPT_G_IO_BUF),
-	FIO_OPT_G_TIOBENCH	= (1U << __FIO_OPT_G_TIOBENCH),
-	FIO_OPT_G_ERR		= (1U << __FIO_OPT_G_ERR),
-	FIO_OPT_G_E4DEFRAG	= (1U << __FIO_OPT_G_E4DEFRAG),
-	FIO_OPT_G_NETIO		= (1U << __FIO_OPT_G_NETIO),
-	FIO_OPT_G_RDMA		= (1U << __FIO_OPT_G_RDMA),
-	FIO_OPT_G_LIBAIO	= (1U << __FIO_OPT_G_LIBAIO),
-	FIO_OPT_G_ACT		= (1U << __FIO_OPT_G_ACT),
-	FIO_OPT_G_LATPROF	= (1U << __FIO_OPT_G_LATPROF),
-	FIO_OPT_G_RBD		= (1U << __FIO_OPT_G_RBD),
-	FIO_OPT_G_GFAPI		= (1U << __FIO_OPT_G_GFAPI),
-	FIO_OPT_G_MTD		= (1U << __FIO_OPT_G_MTD),
-	FIO_OPT_G_INVALID	= (1U << __FIO_OPT_G_NR),
+	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
+	FIO_OPT_G_ZONE		= (1ULL << __FIO_OPT_G_ZONE),
+	FIO_OPT_G_RWMIX		= (1ULL << __FIO_OPT_G_RWMIX),
+	FIO_OPT_G_VERIFY	= (1ULL << __FIO_OPT_G_VERIFY),
+	FIO_OPT_G_TRIM		= (1ULL << __FIO_OPT_G_TRIM),
+	FIO_OPT_G_IOLOG		= (1ULL << __FIO_OPT_G_IOLOG),
+	FIO_OPT_G_IO_DEPTH	= (1ULL << __FIO_OPT_G_IO_DEPTH),
+	FIO_OPT_G_IO_FLOW	= (1ULL << __FIO_OPT_G_IO_FLOW),
+	FIO_OPT_G_DESC		= (1ULL << __FIO_OPT_G_DESC),
+	FIO_OPT_G_FILENAME	= (1ULL << __FIO_OPT_G_FILENAME),
+	FIO_OPT_G_IO_BASIC	= (1ULL << __FIO_OPT_G_IO_BASIC),
+	FIO_OPT_G_CGROUP	= (1ULL << __FIO_OPT_G_CGROUP),
+	FIO_OPT_G_RUNTIME	= (1ULL << __FIO_OPT_G_RUNTIME),
+	FIO_OPT_G_PROCESS	= (1ULL << __FIO_OPT_G_PROCESS),
+	FIO_OPT_G_CRED		= (1ULL << __FIO_OPT_G_CRED),
+	FIO_OPT_G_CLOCK		= (1ULL << __FIO_OPT_G_CLOCK),
+	FIO_OPT_G_IO_TYPE	= (1ULL << __FIO_OPT_G_IO_TYPE),
+	FIO_OPT_G_THINKTIME	= (1ULL << __FIO_OPT_G_THINKTIME),
+	FIO_OPT_G_RANDOM	= (1ULL << __FIO_OPT_G_RANDOM),
+	FIO_OPT_G_IO_BUF	= (1ULL << __FIO_OPT_G_IO_BUF),
+	FIO_OPT_G_TIOBENCH	= (1ULL << __FIO_OPT_G_TIOBENCH),
+	FIO_OPT_G_ERR		= (1ULL << __FIO_OPT_G_ERR),
+	FIO_OPT_G_E4DEFRAG	= (1ULL << __FIO_OPT_G_E4DEFRAG),
+	FIO_OPT_G_NETIO		= (1ULL << __FIO_OPT_G_NETIO),
+	FIO_OPT_G_RDMA		= (1ULL << __FIO_OPT_G_RDMA),
+	FIO_OPT_G_LIBAIO	= (1ULL << __FIO_OPT_G_LIBAIO),
+	FIO_OPT_G_ACT		= (1ULL << __FIO_OPT_G_ACT),
+	FIO_OPT_G_LATPROF	= (1ULL << __FIO_OPT_G_LATPROF),
+	FIO_OPT_G_RBD		= (1ULL << __FIO_OPT_G_RBD),
+	FIO_OPT_G_GFAPI		= (1ULL << __FIO_OPT_G_GFAPI),
+	FIO_OPT_G_MTD		= (1ULL << __FIO_OPT_G_MTD),
+	FIO_OPT_G_INVALID	= (1ULL << __FIO_OPT_G_NR),
 };
 
-extern struct opt_group *opt_group_from_mask(unsigned int *mask);
-extern struct opt_group *opt_group_cat_from_mask(unsigned int *mask);
+extern struct opt_group *opt_group_from_mask(uint64_t *mask);
+extern struct opt_group *opt_group_cat_from_mask(uint64_t *mask);
 extern struct fio_option *fio_option_find(const char *name);
 extern unsigned int fio_get_kb_base(void *);
 
