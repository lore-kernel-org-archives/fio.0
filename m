Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/4] move skip_bad= option to engines/mtd.c
Date: Mon,  7 Aug 2017 20:37:54 +0300
Message-Id: <20170807173754.80126-5-tkusumi@tuxera.com>
In-Reply-To: <20170807173754.80126-1-tkusumi@tuxera.com>
References: <20170807173754.80126-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This is ioengine specific, thus should be defined in engines/mtd.c.

This option is useless unless engines/mtd.c is enabled.
It could be conditionally compiled using CONFIG_MTD, but all
other ioengines define their own option structure in their code.

The only functional difference is that now .category is changed
to FIO_OPT_C_ENGINE. This is also something done by all other
ioengine specific options, though ->category isn't really used
for anything meaningfull.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 cconv.c          |  2 --
 engines/mtd.c    | 28 +++++++++++++++++++++++++++-
 options.c        | 11 -----------
 thread_options.h |  2 --
 4 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/cconv.c b/cconv.c
index b8d9ddc..f9f2b30 100644
--- a/cconv.c
+++ b/cconv.c
@@ -283,7 +283,6 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->compress_percentage = le32_to_cpu(top->compress_percentage);
 	o->compress_chunk = le32_to_cpu(top->compress_chunk);
 	o->dedupe_percentage = le32_to_cpu(top->dedupe_percentage);
-	o->skip_bad = le32_to_cpu(top->skip_bad);
 	o->block_error_hist = le32_to_cpu(top->block_error_hist);
 	o->replay_align = le32_to_cpu(top->replay_align);
 	o->replay_scale = le32_to_cpu(top->replay_scale);
@@ -471,7 +470,6 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->compress_chunk = cpu_to_le32(o->compress_chunk);
 	top->dedupe_percentage = cpu_to_le32(o->dedupe_percentage);
 	top->block_error_hist = cpu_to_le32(o->block_error_hist);
-	top->skip_bad = cpu_to_le32(o->skip_bad);
 	top->replay_align = cpu_to_le32(o->replay_align);
 	top->replay_scale = cpu_to_le32(o->replay_scale);
 	top->per_job_logs = cpu_to_le32(o->per_job_logs);
diff --git a/engines/mtd.c b/engines/mtd.c
index 3c22a1b..b4a6600 100644
--- a/engines/mtd.c
+++ b/engines/mtd.c
@@ -13,6 +13,7 @@
 #include <mtd/mtd-user.h>
 
 #include "../fio.h"
+#include "../optgroup.h"
 #include "../verify.h"
 #include "../oslib/libmtd.h"
 
@@ -22,6 +23,28 @@ struct fio_mtd_data {
 	struct mtd_dev_info info;
 };
 
+struct fio_mtd_options {
+	void *pad; /* avoid off1 == 0 */
+	unsigned int skip_bad;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	= "skip_bad",
+		.lname	= "Skip operations against bad blocks",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct fio_mtd_options, skip_bad),
+		.help	= "Skip operations against known bad blocks.",
+		.hide	= 1,
+		.def	= "0",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_MTD,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
 static int fio_mtd_maybe_mark_bad(struct thread_data *td,
 				  struct fio_mtd_data *fmd,
 				  struct io_u *io_u, int eb)
@@ -55,6 +78,7 @@ static int fio_mtd_queue(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	struct fio_mtd_data *fmd = FILE_ENG_DATA(f);
+	struct fio_mtd_options *o = td->eo;
 	int local_offs = 0;
 	int ret;
 
@@ -77,7 +101,7 @@ static int fio_mtd_queue(struct thread_data *td, struct io_u *io_u)
 			      (int)fmd->info.eb_size - eb_offs);
 		char *buf = ((char *)io_u->buf) + local_offs;
 
-		if (td->o.skip_bad) {
+		if (o->skip_bad) {
 			ret = fio_mtd_is_bad(td, fmd, io_u, eb);
 			if (ret == -1)
 				break;
@@ -190,6 +214,8 @@ static struct ioengine_ops ioengine = {
 	.close_file	= fio_mtd_close_file,
 	.get_file_size	= fio_mtd_get_file_size,
 	.flags		= FIO_SYNCIO | FIO_NOEXTEND,
+	.options	= options,
+	.option_struct_size	= sizeof(struct fio_mtd_options),
 };
 
 static void fio_init fio_mtd_register(void)
diff --git a/options.c b/options.c
index 5a2ab57..f2b2bb9 100644
--- a/options.c
+++ b/options.c
@@ -4379,17 +4379,6 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_IO_FLOW,
 	},
 	{
-		.name	= "skip_bad",
-		.lname	= "Skip operations against bad blocks",
-		.type	= FIO_OPT_BOOL,
-		.off1	= offsetof(struct thread_options, skip_bad),
-		.help	= "Skip operations against known bad blocks.",
-		.hide	= 1,
-		.def	= "0",
-		.category = FIO_OPT_C_IO,
-		.group	= FIO_OPT_G_MTD,
-	},
-	{
 		.name   = "steadystate",
 		.lname  = "Steady state threshold",
 		.alias  = "ss",
diff --git a/thread_options.h b/thread_options.h
index 72d86cf..f3dfd42 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -306,7 +306,6 @@ struct thread_options {
 	fio_fp64_t latency_percentile;
 
 	unsigned block_error_hist;
-	unsigned int skip_bad;
 
 	unsigned int replay_align;
 	unsigned int replay_scale;
@@ -579,7 +578,6 @@ struct thread_options_pack {
 	fio_fp64_t latency_percentile;
 
 	uint32_t block_error_hist;
-	uint32_t skip_bad;
 
 	uint32_t replay_align;
 	uint32_t replay_scale;
-- 
2.9.4


