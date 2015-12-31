Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34093 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbbLaNAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 31 Dec 2015 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aEcpn-0001ft-B9
	for fio@vger.kernel.org; Thu, 31 Dec 2015 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151231130001.DFF2C2C00B6@kernel.dk>
Date: Thu, 31 Dec 2015 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit de26b8245b06c99ec64d9f88cfde1ed9627f871a:

  configure: add --enable-lex (2015-12-29 20:58:13 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5f3bd0fd67254e3750681f0700a0cc162faee500:

  options: move pattern_fmt_desc where we need it (2015-12-30 09:27:05 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      options: make the groups/categories constant
      options: split out option grouping code
      options: we don't need the crc32c verify include
      options: move pattern_fmt_desc where we need it

 Makefile            |   2 +-
 engines/cpu.c       |   1 +
 engines/e4defrag.c  |   1 +
 engines/glusterfs.c |   1 +
 engines/libaio.c    |   1 +
 engines/libhdfs.c   |   2 +-
 engines/net.c       |   1 +
 engines/rbd.c       |   1 +
 engines/rdma.c      |   1 +
 goptions.c          |  10 +--
 optgroup.c          | 166 ++++++++++++++++++++++++++++++++++++++++++++++
 optgroup.h          | 102 ++++++++++++++++++++++++++++
 options.c           | 186 +++-------------------------------------------------
 options.h           |  97 ---------------------------
 parse.c             |   1 +
 profiles/act.c      |   1 +
 profiles/tiobench.c |   1 +
 17 files changed, 296 insertions(+), 279 deletions(-)
 create mode 100644 optgroup.c
 create mode 100644 optgroup.h

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 1b5c9a6..bd5f1bb 100644
--- a/Makefile
+++ b/Makefile
@@ -45,7 +45,7 @@ SOURCE :=	$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
-		workqueue.c rate-submit.c
+		workqueue.c rate-submit.c optgroup.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
diff --git a/engines/cpu.c b/engines/cpu.c
index 7e4d737..7643a8c 100644
--- a/engines/cpu.c
+++ b/engines/cpu.c
@@ -6,6 +6,7 @@
  *
  */
 #include "../fio.h"
+#include "../optgroup.h"
 
 struct cpu_options {
 	void *pad;
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index d6113a9..c0667fe 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -17,6 +17,7 @@
 #include <fcntl.h>
 
 #include "../fio.h"
+#include "../optgroup.h"
 
 #ifndef EXT4_IOC_MOVE_EXT
 #define EXT4_IOC_MOVE_EXT               _IOWR('f', 15, struct move_extent)
diff --git a/engines/glusterfs.c b/engines/glusterfs.c
index 507cd25..dec9fb5 100644
--- a/engines/glusterfs.c
+++ b/engines/glusterfs.c
@@ -6,6 +6,7 @@
  */
 
 #include "gfapi.h"
+#include "../optgroup.h"
 
 struct fio_option gfapi_options[] = {
 	{
diff --git a/engines/libaio.c b/engines/libaio.c
index 60dc49d..9d562bb 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -13,6 +13,7 @@
 
 #include "../fio.h"
 #include "../lib/pow2.h"
+#include "../optgroup.h"
 
 static int fio_libaio_commit(struct thread_data *td);
 
diff --git a/engines/libhdfs.c b/engines/libhdfs.c
index f690b00..faad3f8 100644
--- a/engines/libhdfs.c
+++ b/engines/libhdfs.c
@@ -15,7 +15,7 @@
 #include <hdfs.h>
 
 #include "../fio.h"
-
+#include "../optgroup.h"
 
 #define CHUNCK_NAME_LENGTH_MAX 80
 #define CHUNCK_CREATION_BUFFER_SIZE 65536
diff --git a/engines/net.c b/engines/net.c
index cd19535..9301ccf 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -22,6 +22,7 @@
 
 #include "../fio.h"
 #include "../verify.h"
+#include "../optgroup.h"
 
 struct netio_data {
 	int listenfd;
diff --git a/engines/rbd.c b/engines/rbd.c
index 2be9b55..8252d27 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -8,6 +8,7 @@
 #include <rbd/librbd.h>
 
 #include "../fio.h"
+#include "../optgroup.h"
 
 struct fio_rbd_iou {
 	struct io_u *io_u;
diff --git a/engines/rdma.c b/engines/rdma.c
index 1006b7e..87ba465 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -41,6 +41,7 @@
 
 #include "../fio.h"
 #include "../hash.h"
+#include "../optgroup.h"
 
 #include <rdma/rdma_cma.h>
 #include <infiniband/arch.h>
diff --git a/goptions.c b/goptions.c
index 9279b22..b3d3684 100644
--- a/goptions.c
+++ b/goptions.c
@@ -11,6 +11,7 @@
 #include "ghelpers.h"
 #include "gerror.h"
 #include "parse.h"
+#include "optgroup.h"
 
 struct gopt {
 	GtkWidget *box;
@@ -95,7 +96,7 @@ static GtkWidget *gopt_get_group_frame(struct gopt_job_view *gjv,
 				       GtkWidget *box, uint64_t groupmask)
 {
 	uint64_t mask, group;
-	struct opt_group *og;
+	const struct opt_group *og;
 	GtkWidget *frame, *hbox;
 	struct gopt_frame_widget *gfw;
 
@@ -1136,7 +1137,7 @@ static void gopt_add_options(struct gopt_job_view *gjv,
 	for (i = 0; fio_options[i].name; i++) {
 		struct fio_option *o = &fio_options[i];
 		uint64_t mask = o->category;
-		struct opt_group *og;
+		const struct opt_group *og;
 
 		while ((og = opt_group_from_mask(&mask)) != NULL) {
 			GtkWidget *vbox = gjv->vboxes[ffz64(~og->mask)];
@@ -1177,14 +1178,15 @@ static GtkWidget *gopt_add_tab(GtkWidget *notebook, const char *name)
 	return vbox;
 }
 
-static GtkWidget *gopt_add_group_tab(GtkWidget *notebook, struct opt_group *og)
+static GtkWidget *gopt_add_group_tab(GtkWidget *notebook,
+				     const struct opt_group *og)
 {
 	return gopt_add_tab(notebook, og->name);
 }
 
 static void gopt_add_group_tabs(GtkWidget *notebook, struct gopt_job_view *gjv)
 {
-	struct opt_group *og;
+	const struct opt_group *og;
 	unsigned int i;
 
 	i = 0;
diff --git a/optgroup.c b/optgroup.c
new file mode 100644
index 0000000..5f9ca96
--- /dev/null
+++ b/optgroup.c
@@ -0,0 +1,166 @@
+#include <stdio.h>
+#include <inttypes.h>
+#include "optgroup.h"
+
+/*
+ * Option grouping
+ */
+static const struct opt_group fio_opt_groups[] = {
+	{
+		.name	= "General",
+		.mask	= FIO_OPT_C_GENERAL,
+	},
+	{
+		.name	= "I/O",
+		.mask	= FIO_OPT_C_IO,
+	},
+	{
+		.name	= "File",
+		.mask	= FIO_OPT_C_FILE,
+	},
+	{
+		.name	= "Statistics",
+		.mask	= FIO_OPT_C_STAT,
+	},
+	{
+		.name	= "Logging",
+		.mask	= FIO_OPT_C_LOG,
+	},
+	{
+		.name	= "Profiles",
+		.mask	= FIO_OPT_C_PROFILE,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+static const struct opt_group fio_opt_cat_groups[] = {
+	{
+		.name	= "Latency profiling",
+		.mask	= FIO_OPT_G_LATPROF,
+	},
+	{
+		.name	= "Rate",
+		.mask	= FIO_OPT_G_RATE,
+	},
+	{
+		.name	= "Zone",
+		.mask	= FIO_OPT_G_ZONE,
+	},
+	{
+		.name	= "Read/write mix",
+		.mask	= FIO_OPT_G_RWMIX,
+	},
+	{
+		.name	= "Verify",
+		.mask	= FIO_OPT_G_VERIFY,
+	},
+	{
+		.name	= "Trim",
+		.mask	= FIO_OPT_G_TRIM,
+	},
+	{
+		.name	= "I/O Logging",
+		.mask	= FIO_OPT_G_IOLOG,
+	},
+	{
+		.name	= "I/O Depth",
+		.mask	= FIO_OPT_G_IO_DEPTH,
+	},
+	{
+		.name	= "I/O Flow",
+		.mask	= FIO_OPT_G_IO_FLOW,
+	},
+	{
+		.name	= "Description",
+		.mask	= FIO_OPT_G_DESC,
+	},
+	{
+		.name	= "Filename",
+		.mask	= FIO_OPT_G_FILENAME,
+	},
+	{
+		.name	= "General I/O",
+		.mask	= FIO_OPT_G_IO_BASIC,
+	},
+	{
+		.name	= "Cgroups",
+		.mask	= FIO_OPT_G_CGROUP,
+	},
+	{
+		.name	= "Runtime",
+		.mask	= FIO_OPT_G_RUNTIME,
+	},
+	{
+		.name	= "Process",
+		.mask	= FIO_OPT_G_PROCESS,
+	},
+	{
+		.name	= "Job credentials / priority",
+		.mask	= FIO_OPT_G_CRED,
+	},
+	{
+		.name	= "Clock settings",
+		.mask	= FIO_OPT_G_CLOCK,
+	},
+	{
+		.name	= "I/O Type",
+		.mask	= FIO_OPT_G_IO_TYPE,
+	},
+	{
+		.name	= "I/O Thinktime",
+		.mask	= FIO_OPT_G_THINKTIME,
+	},
+	{
+		.name	= "Randomizations",
+		.mask	= FIO_OPT_G_RANDOM,
+	},
+	{
+		.name	= "I/O buffers",
+		.mask	= FIO_OPT_G_IO_BUF,
+	},
+	{
+		.name	= "Tiobench profile",
+		.mask	= FIO_OPT_G_TIOBENCH,
+	},
+	{
+		.name	= "MTD",
+		.mask	= FIO_OPT_G_MTD,
+	},
+
+	{
+		.name	= NULL,
+	}
+};
+
+static const struct opt_group *group_from_mask(const struct opt_group *ogs,
+					       uint64_t *mask,
+					       uint64_t inv_mask)
+{
+	int i;
+
+	if (*mask == inv_mask || !*mask)
+		return NULL;
+
+	for (i = 0; ogs[i].name; i++) {
+		const struct opt_group *og = &ogs[i];
+
+		if (*mask & og->mask) {
+			*mask &= ~(og->mask);
+			return og;
+		}
+	}
+
+	return NULL;
+}
+
+const struct opt_group *opt_group_from_mask(uint64_t *mask)
+{
+	return group_from_mask(fio_opt_groups, mask, FIO_OPT_C_INVALID);
+}
+
+const struct opt_group *opt_group_cat_from_mask(uint64_t *mask)
+{
+	return group_from_mask(fio_opt_cat_groups, mask, FIO_OPT_G_INVALID);
+}
diff --git a/optgroup.h b/optgroup.h
new file mode 100644
index 0000000..815ac16
--- /dev/null
+++ b/optgroup.h
@@ -0,0 +1,102 @@
+#ifndef FIO_OPT_GROUP_H
+#define FIO_OPT_GROUP_H
+
+struct opt_group {
+	const char *name;
+	uint64_t mask;
+};
+
+enum opt_category {
+	__FIO_OPT_C_GENERAL	= 0,
+	__FIO_OPT_C_IO,
+	__FIO_OPT_C_FILE,
+	__FIO_OPT_C_STAT,
+	__FIO_OPT_C_LOG,
+	__FIO_OPT_C_PROFILE,
+	__FIO_OPT_C_ENGINE,
+	__FIO_OPT_C_NR,
+
+	FIO_OPT_C_GENERAL	= (1ULL << __FIO_OPT_C_GENERAL),
+	FIO_OPT_C_IO		= (1ULL << __FIO_OPT_C_IO),
+	FIO_OPT_C_FILE		= (1ULL << __FIO_OPT_C_FILE),
+	FIO_OPT_C_STAT		= (1ULL << __FIO_OPT_C_STAT),
+	FIO_OPT_C_LOG		= (1ULL << __FIO_OPT_C_LOG),
+	FIO_OPT_C_PROFILE	= (1ULL << __FIO_OPT_C_PROFILE),
+	FIO_OPT_C_ENGINE	= (1ULL << __FIO_OPT_C_ENGINE),
+	FIO_OPT_C_INVALID	= (1ULL << __FIO_OPT_C_NR),
+};
+
+enum opt_category_group {
+	__FIO_OPT_G_RATE	= 0,
+	__FIO_OPT_G_ZONE,
+	__FIO_OPT_G_RWMIX,
+	__FIO_OPT_G_VERIFY,
+	__FIO_OPT_G_TRIM,
+	__FIO_OPT_G_IOLOG,
+	__FIO_OPT_G_IO_DEPTH,
+	__FIO_OPT_G_IO_FLOW,
+	__FIO_OPT_G_DESC,
+	__FIO_OPT_G_FILENAME,
+	__FIO_OPT_G_IO_BASIC,
+	__FIO_OPT_G_CGROUP,
+	__FIO_OPT_G_RUNTIME,
+	__FIO_OPT_G_PROCESS,
+	__FIO_OPT_G_CRED,
+	__FIO_OPT_G_CLOCK,
+	__FIO_OPT_G_IO_TYPE,
+	__FIO_OPT_G_THINKTIME,
+	__FIO_OPT_G_RANDOM,
+	__FIO_OPT_G_IO_BUF,
+	__FIO_OPT_G_TIOBENCH,
+	__FIO_OPT_G_ERR,
+	__FIO_OPT_G_E4DEFRAG,
+	__FIO_OPT_G_NETIO,
+	__FIO_OPT_G_RDMA,
+	__FIO_OPT_G_LIBAIO,
+	__FIO_OPT_G_ACT,
+	__FIO_OPT_G_LATPROF,
+        __FIO_OPT_G_RBD,
+        __FIO_OPT_G_GFAPI,
+        __FIO_OPT_G_MTD,
+	__FIO_OPT_G_HDFS,
+	__FIO_OPT_G_NR,
+
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
+	FIO_OPT_G_HDFS		= (1ULL << __FIO_OPT_G_HDFS),
+	FIO_OPT_G_INVALID	= (1ULL << __FIO_OPT_G_NR),
+};
+
+extern const struct opt_group *opt_group_from_mask(uint64_t *mask);
+extern const struct opt_group *opt_group_cat_from_mask(uint64_t *mask);
+
+#endif
diff --git a/options.c b/options.c
index 49d6600..871552b 100644
--- a/options.c
+++ b/options.c
@@ -16,19 +16,10 @@
 #include "lib/fls.h"
 #include "lib/pattern.h"
 #include "options.h"
-
-#include "crc/crc32c.h"
+#include "optgroup.h"
 
 char client_sockaddr_str[INET6_ADDRSTRLEN] = { 0 };
 
-struct pattern_fmt_desc fmt_desc[] = {
-	{
-		.fmt   = "%o",
-		.len   = FIELD_SIZE(struct io_u *, offset),
-		.paste = paste_blockoff
-	}
-};
-
 /*
  * Check if mmap/mmaphuge has a :/foo/bar/file at the end. If so, return that.
  */
@@ -963,13 +954,20 @@ static int str_dedupe_cb(void *data, unsigned long long *il)
 
 static int str_verify_pattern_cb(void *data, const char *input)
 {
+	struct pattern_fmt_desc fmt_desc[] = {
+		{
+			.fmt   = "%o",
+			.len   = FIELD_SIZE(struct io_u *, offset),
+			.paste = paste_blockoff
+		}
+	};
 	struct thread_data *td = data;
 	int ret;
 
 	td->o.verify_fmt_sz = ARRAY_SIZE(td->o.verify_fmt);
 	ret = parse_and_fill_pattern(input, strlen(input), td->o.verify_pattern,
-				     MAX_PATTERN_SIZE, fmt_desc, sizeof(fmt_desc),
-				     td->o.verify_fmt, &td->o.verify_fmt_sz);
+			MAX_PATTERN_SIZE, fmt_desc, sizeof(fmt_desc),
+			td->o.verify_fmt, &td->o.verify_fmt_sz);
 	if (ret < 0)
 		return 1;
 
@@ -1043,170 +1041,6 @@ static int gtod_cpu_verify(struct fio_option *o, void *data)
 }
 
 /*
- * Option grouping
- */
-static struct opt_group fio_opt_groups[] = {
-	{
-		.name	= "General",
-		.mask	= FIO_OPT_C_GENERAL,
-	},
-	{
-		.name	= "I/O",
-		.mask	= FIO_OPT_C_IO,
-	},
-	{
-		.name	= "File",
-		.mask	= FIO_OPT_C_FILE,
-	},
-	{
-		.name	= "Statistics",
-		.mask	= FIO_OPT_C_STAT,
-	},
-	{
-		.name	= "Logging",
-		.mask	= FIO_OPT_C_LOG,
-	},
-	{
-		.name	= "Profiles",
-		.mask	= FIO_OPT_C_PROFILE,
-	},
-	{
-		.name	= NULL,
-	},
-};
-
-static struct opt_group *__opt_group_from_mask(struct opt_group *ogs,
-					       uint64_t *mask,
-					       uint64_t inv_mask)
-{
-	struct opt_group *og;
-	int i;
-
-	if (*mask == inv_mask || !*mask)
-		return NULL;
-
-	for (i = 0; ogs[i].name; i++) {
-		og = &ogs[i];
-
-		if (*mask & og->mask) {
-			*mask &= ~(og->mask);
-			return og;
-		}
-	}
-
-	return NULL;
-}
-
-struct opt_group *opt_group_from_mask(uint64_t *mask)
-{
-	return __opt_group_from_mask(fio_opt_groups, mask, FIO_OPT_C_INVALID);
-}
-
-static struct opt_group fio_opt_cat_groups[] = {
-	{
-		.name	= "Latency profiling",
-		.mask	= FIO_OPT_G_LATPROF,
-	},
-	{
-		.name	= "Rate",
-		.mask	= FIO_OPT_G_RATE,
-	},
-	{
-		.name	= "Zone",
-		.mask	= FIO_OPT_G_ZONE,
-	},
-	{
-		.name	= "Read/write mix",
-		.mask	= FIO_OPT_G_RWMIX,
-	},
-	{
-		.name	= "Verify",
-		.mask	= FIO_OPT_G_VERIFY,
-	},
-	{
-		.name	= "Trim",
-		.mask	= FIO_OPT_G_TRIM,
-	},
-	{
-		.name	= "I/O Logging",
-		.mask	= FIO_OPT_G_IOLOG,
-	},
-	{
-		.name	= "I/O Depth",
-		.mask	= FIO_OPT_G_IO_DEPTH,
-	},
-	{
-		.name	= "I/O Flow",
-		.mask	= FIO_OPT_G_IO_FLOW,
-	},
-	{
-		.name	= "Description",
-		.mask	= FIO_OPT_G_DESC,
-	},
-	{
-		.name	= "Filename",
-		.mask	= FIO_OPT_G_FILENAME,
-	},
-	{
-		.name	= "General I/O",
-		.mask	= FIO_OPT_G_IO_BASIC,
-	},
-	{
-		.name	= "Cgroups",
-		.mask	= FIO_OPT_G_CGROUP,
-	},
-	{
-		.name	= "Runtime",
-		.mask	= FIO_OPT_G_RUNTIME,
-	},
-	{
-		.name	= "Process",
-		.mask	= FIO_OPT_G_PROCESS,
-	},
-	{
-		.name	= "Job credentials / priority",
-		.mask	= FIO_OPT_G_CRED,
-	},
-	{
-		.name	= "Clock settings",
-		.mask	= FIO_OPT_G_CLOCK,
-	},
-	{
-		.name	= "I/O Type",
-		.mask	= FIO_OPT_G_IO_TYPE,
-	},
-	{
-		.name	= "I/O Thinktime",
-		.mask	= FIO_OPT_G_THINKTIME,
-	},
-	{
-		.name	= "Randomizations",
-		.mask	= FIO_OPT_G_RANDOM,
-	},
-	{
-		.name	= "I/O buffers",
-		.mask	= FIO_OPT_G_IO_BUF,
-	},
-	{
-		.name	= "Tiobench profile",
-		.mask	= FIO_OPT_G_TIOBENCH,
-	},
-	{
-		.name	= "MTD",
-		.mask	= FIO_OPT_G_MTD,
-	},
-
-	{
-		.name	= NULL,
-	}
-};
-
-struct opt_group *opt_group_cat_from_mask(uint64_t *mask)
-{
-	return __opt_group_from_mask(fio_opt_cat_groups, mask, FIO_OPT_G_INVALID);
-}
-
-/*
  * Map of job/command line options
  */
 struct fio_option fio_options[FIO_MAX_OPTS] = {
diff --git a/options.h b/options.h
index 13b534a..6a5db07 100644
--- a/options.h
+++ b/options.h
@@ -59,103 +59,6 @@ static inline struct fio_option *find_option(struct fio_option *options,
 	return NULL;
 }
 
-struct opt_group {
-	const char *name;
-	uint64_t mask;
-};
-
-enum opt_category {
-	__FIO_OPT_C_GENERAL	= 0,
-	__FIO_OPT_C_IO,
-	__FIO_OPT_C_FILE,
-	__FIO_OPT_C_STAT,
-	__FIO_OPT_C_LOG,
-	__FIO_OPT_C_PROFILE,
-	__FIO_OPT_C_ENGINE,
-	__FIO_OPT_C_NR,
-
-	FIO_OPT_C_GENERAL	= (1ULL << __FIO_OPT_C_GENERAL),
-	FIO_OPT_C_IO		= (1ULL << __FIO_OPT_C_IO),
-	FIO_OPT_C_FILE		= (1ULL << __FIO_OPT_C_FILE),
-	FIO_OPT_C_STAT		= (1ULL << __FIO_OPT_C_STAT),
-	FIO_OPT_C_LOG		= (1ULL << __FIO_OPT_C_LOG),
-	FIO_OPT_C_PROFILE	= (1ULL << __FIO_OPT_C_PROFILE),
-	FIO_OPT_C_ENGINE	= (1ULL << __FIO_OPT_C_ENGINE),
-	FIO_OPT_C_INVALID	= (1ULL << __FIO_OPT_C_NR),
-};
-
-enum opt_category_group {
-	__FIO_OPT_G_RATE	= 0,
-	__FIO_OPT_G_ZONE,
-	__FIO_OPT_G_RWMIX,
-	__FIO_OPT_G_VERIFY,
-	__FIO_OPT_G_TRIM,
-	__FIO_OPT_G_IOLOG,
-	__FIO_OPT_G_IO_DEPTH,
-	__FIO_OPT_G_IO_FLOW,
-	__FIO_OPT_G_DESC,
-	__FIO_OPT_G_FILENAME,
-	__FIO_OPT_G_IO_BASIC,
-	__FIO_OPT_G_CGROUP,
-	__FIO_OPT_G_RUNTIME,
-	__FIO_OPT_G_PROCESS,
-	__FIO_OPT_G_CRED,
-	__FIO_OPT_G_CLOCK,
-	__FIO_OPT_G_IO_TYPE,
-	__FIO_OPT_G_THINKTIME,
-	__FIO_OPT_G_RANDOM,
-	__FIO_OPT_G_IO_BUF,
-	__FIO_OPT_G_TIOBENCH,
-	__FIO_OPT_G_ERR,
-	__FIO_OPT_G_E4DEFRAG,
-	__FIO_OPT_G_NETIO,
-	__FIO_OPT_G_RDMA,
-	__FIO_OPT_G_LIBAIO,
-	__FIO_OPT_G_ACT,
-	__FIO_OPT_G_LATPROF,
-        __FIO_OPT_G_RBD,
-        __FIO_OPT_G_GFAPI,
-        __FIO_OPT_G_MTD,
-	__FIO_OPT_G_HDFS,
-	__FIO_OPT_G_NR,
-
-	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
-	FIO_OPT_G_ZONE		= (1ULL << __FIO_OPT_G_ZONE),
-	FIO_OPT_G_RWMIX		= (1ULL << __FIO_OPT_G_RWMIX),
-	FIO_OPT_G_VERIFY	= (1ULL << __FIO_OPT_G_VERIFY),
-	FIO_OPT_G_TRIM		= (1ULL << __FIO_OPT_G_TRIM),
-	FIO_OPT_G_IOLOG		= (1ULL << __FIO_OPT_G_IOLOG),
-	FIO_OPT_G_IO_DEPTH	= (1ULL << __FIO_OPT_G_IO_DEPTH),
-	FIO_OPT_G_IO_FLOW	= (1ULL << __FIO_OPT_G_IO_FLOW),
-	FIO_OPT_G_DESC		= (1ULL << __FIO_OPT_G_DESC),
-	FIO_OPT_G_FILENAME	= (1ULL << __FIO_OPT_G_FILENAME),
-	FIO_OPT_G_IO_BASIC	= (1ULL << __FIO_OPT_G_IO_BASIC),
-	FIO_OPT_G_CGROUP	= (1ULL << __FIO_OPT_G_CGROUP),
-	FIO_OPT_G_RUNTIME	= (1ULL << __FIO_OPT_G_RUNTIME),
-	FIO_OPT_G_PROCESS	= (1ULL << __FIO_OPT_G_PROCESS),
-	FIO_OPT_G_CRED		= (1ULL << __FIO_OPT_G_CRED),
-	FIO_OPT_G_CLOCK		= (1ULL << __FIO_OPT_G_CLOCK),
-	FIO_OPT_G_IO_TYPE	= (1ULL << __FIO_OPT_G_IO_TYPE),
-	FIO_OPT_G_THINKTIME	= (1ULL << __FIO_OPT_G_THINKTIME),
-	FIO_OPT_G_RANDOM	= (1ULL << __FIO_OPT_G_RANDOM),
-	FIO_OPT_G_IO_BUF	= (1ULL << __FIO_OPT_G_IO_BUF),
-	FIO_OPT_G_TIOBENCH	= (1ULL << __FIO_OPT_G_TIOBENCH),
-	FIO_OPT_G_ERR		= (1ULL << __FIO_OPT_G_ERR),
-	FIO_OPT_G_E4DEFRAG	= (1ULL << __FIO_OPT_G_E4DEFRAG),
-	FIO_OPT_G_NETIO		= (1ULL << __FIO_OPT_G_NETIO),
-	FIO_OPT_G_RDMA		= (1ULL << __FIO_OPT_G_RDMA),
-	FIO_OPT_G_LIBAIO	= (1ULL << __FIO_OPT_G_LIBAIO),
-	FIO_OPT_G_ACT		= (1ULL << __FIO_OPT_G_ACT),
-	FIO_OPT_G_LATPROF	= (1ULL << __FIO_OPT_G_LATPROF),
-	FIO_OPT_G_RBD		= (1ULL << __FIO_OPT_G_RBD),
-	FIO_OPT_G_GFAPI		= (1ULL << __FIO_OPT_G_GFAPI),
-	FIO_OPT_G_MTD		= (1ULL << __FIO_OPT_G_MTD),
-	FIO_OPT_G_HDFS		= (1ULL << __FIO_OPT_G_HDFS),
-	FIO_OPT_G_INVALID	= (1ULL << __FIO_OPT_G_NR),
-};
-
-extern struct opt_group *opt_group_from_mask(uint64_t *mask);
-extern struct opt_group *opt_group_cat_from_mask(uint64_t *mask);
 extern struct fio_option *fio_option_find(const char *name);
 extern unsigned int fio_get_kb_base(void *);
 
diff --git a/parse.c b/parse.c
index ac1bee9..ec0f870 100644
--- a/parse.c
+++ b/parse.c
@@ -15,6 +15,7 @@
 #include "parse.h"
 #include "debug.h"
 #include "options.h"
+#include "optgroup.h"
 #include "minmax.h"
 #include "lib/ieee754.h"
 #include "lib/pow2.h"
diff --git a/profiles/act.c b/profiles/act.c
index 4d2ec5c..3e9238b 100644
--- a/profiles/act.c
+++ b/profiles/act.c
@@ -1,6 +1,7 @@
 #include "../fio.h"
 #include "../profile.h"
 #include "../parse.h"
+#include "../optgroup.h"
 
 /*
  * 1x loads
diff --git a/profiles/tiobench.c b/profiles/tiobench.c
index b4331d7..8af6f4e 100644
--- a/profiles/tiobench.c
+++ b/profiles/tiobench.c
@@ -1,6 +1,7 @@
 #include "../fio.h"
 #include "../profile.h"
 #include "../parse.h"
+#include "../optgroup.h"
 
 static unsigned long long size;
 static unsigned int loops = 1;
