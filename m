Return-Path: <dehrenberg@google.com>
Return-Path: <dehrenberg@google.com>
Sender: Daniel Ehrenberg <dehrenberg@google.com>
From: Dan Ehrenberg <dehrenberg@chromium.org>
Subject: [PATCH v2 6/7] mtd: ioengine
Date: Wed, 15 Apr 2015 10:41:34 -0700
Message-Id: <1429119695-22425-7-git-send-email-dehrenberg@chromium.org>
In-Reply-To: <1429119695-22425-1-git-send-email-dehrenberg@chromium.org>
References: <1429119695-22425-1-git-send-email-dehrenberg@chromium.org>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: gwendal@chromium.org, Dan Ehrenberg <dehrenberg@chromium.org>
List-ID: <fio@vger.kernel.org>

This patch adds an MTD ioengine. Trims are interpreted as MTD erases.
A skip_bad option calls out to the kernel to ask if the block being
operated on is bad first; if it is bad, the operation is skipped
and -EIO is returned.

Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>
---
 HOWTO            |  10 +++
 Makefile         |   5 ++
 engines/mtd.c    | 209 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fio.1            |  10 +++
 options.c        |  15 ++++
 options.h        |   2 +
 thread_options.h |   2 +
 7 files changed, 253 insertions(+)
 create mode 100644 engines/mtd.c

diff --git a/HOWTO b/HOWTO
index e49a257..4b7b2d1 100644
--- a/HOWTO
+++ b/HOWTO
@@ -776,6 +776,15 @@ ioengine=str	Defines how the job issues io to the file. The following
 				necessary environment variables to work with
 				hdfs/libhdfs properly.
 
+			mtd	Read, write and erase an MTD character device
+				(e.g., /dev/mtd0). Discards are treated as
+				erases. Depending on the underlying device
+				type, the I/O may have to go in a certain
+				pattern, e.g., on NAND, writing sequentially
+				to erase blocks and discarding before
+				overwriting. The trimwrite mode works well
+				for this constraint.
+
 			external Prefix to specify loading an external
 				IO engine object file. Append the engine
 				filename, eg ioengine=external:/tmp/foo.o
@@ -1727,6 +1736,7 @@ be the starting port number since fio will use a range of ports.
 		1 	  : allocate space immidietly inside defragment event,
 			    and free right after event
 
+[mtd] skip_bad=bool	Skip operations against known bad blocks.
 
 
 6.0 Interpreting the output
diff --git a/Makefile b/Makefile
index 52e515b..d7456d2 100644
--- a/Makefile
+++ b/Makefile
@@ -107,6 +107,11 @@ ifdef CONFIG_GFAPI
     CFLAGS += "-DGFAPI_USE_FADVISE"
   endif
 endif
+ifdef CONFIG_MTD
+  SOURCE += engines/mtd.c
+  SOURCE += lib/libmtd.c
+  SOURCE += lib/libmtd_legacy.c
+endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
diff --git a/engines/mtd.c b/engines/mtd.c
new file mode 100644
index 0000000..c24913a
--- /dev/null
+++ b/engines/mtd.c
@@ -0,0 +1,209 @@
+/*
+ * MTD engine
+ *
+ * IO engine that reads/writes from MTD character devices.
+ *
+ */
+#include <assert.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+#include <mtd/mtd-user.h>
+
+#include "../fio.h"
+#include "../verify.h"
+#include "../lib/libmtd.h"
+
+libmtd_t desc;
+
+struct fio_mtd_data {
+	struct mtd_dev_info info;
+};
+
+static int fio_mtd_maybe_mark_bad(struct thread_data *td,
+				  struct fio_mtd_data *fmd,
+				  struct io_u *io_u, int eb)
+{
+	int ret;
+	if (errno == EIO) {
+		ret = mtd_mark_bad(&fmd->info, io_u->file->fd, eb);
+		if (ret != 0) {
+			io_u->error = errno;
+			td_verror(td, errno, "mtd_mark_bad");
+			return -1;
+		}
+	}
+	return 0;
+}
+
+static int fio_mtd_is_bad(struct thread_data *td,
+			  struct fio_mtd_data *fmd,
+			  struct io_u *io_u, int eb)
+{
+	int ret = mtd_is_bad(&fmd->info, io_u->file->fd, eb);
+	if (ret == -1) {
+		io_u->error = errno;
+		td_verror(td, errno, "mtd_is_bad");
+	} else if (ret == 1)
+		io_u->error = EIO;	/* Silent failure--don't flood stderr */
+	return ret;
+}
+
+static int fio_mtd_queue(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+	struct fio_mtd_data *fmd = FILE_ENG_DATA(f);
+	int local_offs = 0;
+	int ret;
+
+	fio_ro_check(td, io_u);
+
+	/*
+	 * Errors tend to pertain to particular erase blocks, so divide up
+	 * I/O to erase block size.
+	 * If an error is encountered, log it and keep going onto the next
+	 * block because the error probably just pertains to that block.
+	 * TODO(dehrenberg): Divide up reads and writes into page-sized
+	 * operations to get more fine-grained information about errors.
+	 * TODO(dehrenberg): Somehow skip ops against known bad blocks
+	 * rather than erroring out.
+	 */
+	while (local_offs < io_u->buflen) {
+		int eb = (io_u->offset + local_offs) / fmd->info.eb_size;
+		int eb_offs = (io_u->offset + local_offs) % fmd->info.eb_size;
+		/* The length is the smaller of the length remaining in the
+		 * buffer and the distance to the end of the erase block */
+		int len = min((int)io_u->buflen - local_offs,
+			      (int)fmd->info.eb_size - eb_offs);
+		char *buf = ((char *)io_u->buf) + local_offs;
+
+		if (td->o.skip_bad) {
+			ret = fio_mtd_is_bad(td, fmd, io_u, eb);
+			if (ret == -1)
+				break;
+			else if (ret == 1)
+				goto next;
+		}
+		if (io_u->ddir == DDIR_READ) {
+			ret = mtd_read(&fmd->info, f->fd, eb, eb_offs, buf, len);
+			if (ret != 0) {
+				io_u->error = errno;
+				td_verror(td, errno, "mtd_read");
+				if (fio_mtd_maybe_mark_bad(td, fmd, io_u, eb))
+					break;
+			}
+		} else if (io_u->ddir == DDIR_WRITE) {
+			ret = mtd_write(desc, &fmd->info, f->fd, eb,
+					    eb_offs, buf, len, NULL, 0, 0);
+			if (ret != 0) {
+				io_u->error = errno;
+				td_verror(td, errno, "mtd_write");
+				if (fio_mtd_maybe_mark_bad(td, fmd, io_u, eb))
+					break;
+			}
+		} else if (io_u->ddir == DDIR_TRIM) {
+			if (eb_offs != 0 || len != fmd->info.eb_size) {
+				io_u->error = EINVAL;
+				td_verror(td, EINVAL,
+					  "trim on MTD must be erase block-aligned");
+			}
+			ret = mtd_erase(desc, &fmd->info, f->fd, eb);
+			if (ret != 0) {
+				io_u->error = errno;
+				td_verror(td, errno, "mtd_erase");
+				if (fio_mtd_maybe_mark_bad(td, fmd, io_u, eb))
+					break;
+			}
+		} else {
+			io_u->error = ENOTSUP;
+			td_verror(td, io_u->error, "operation not supported on mtd");
+		}
+
+next:
+		local_offs += len;
+	}
+
+	return FIO_Q_COMPLETED;
+}
+
+static int fio_mtd_open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct fio_mtd_data *fmd;
+	int ret;
+
+	ret = generic_open_file(td, f);
+	if (ret)
+		return ret;
+
+	fmd = calloc(1, sizeof(*fmd));
+	if (!fmd)
+		goto err_close;
+
+	ret = mtd_get_dev_info(desc, f->file_name, &fmd->info);
+	if (ret != 0) {
+		td_verror(td, errno, "mtd_get_dev_info");
+		goto err_free;
+	}
+
+	FILE_SET_ENG_DATA(f, fmd);
+	return 0;
+
+err_free:
+	free(fmd);
+err_close:
+	{
+		int fio_unused ret;
+		ret = generic_close_file(td, f);
+		return 1;
+	}
+}
+
+static int fio_mtd_close_file(struct thread_data *td, struct fio_file *f)
+{
+	struct fio_mtd_data *fmd = FILE_ENG_DATA(f);
+
+	FILE_SET_ENG_DATA(f, NULL);
+	free(fmd);
+
+	return generic_close_file(td, f);
+}
+
+int fio_mtd_get_file_size(struct thread_data *td, struct fio_file *f)
+{
+	struct mtd_dev_info info;
+
+	int ret = mtd_get_dev_info(desc, f->file_name, &info);
+	if (ret != 0) {
+		td_verror(td, errno, "mtd_get_dev_info");
+		return errno;
+	}
+	f->real_file_size = info.size;
+
+	return 0;
+}
+
+static struct ioengine_ops ioengine = {
+	.name		= "mtd",
+	.version	= FIO_IOOPS_VERSION,
+	.queue		= fio_mtd_queue,
+	.open_file	= fio_mtd_open_file,
+	.close_file	= fio_mtd_close_file,
+	.get_file_size	= fio_mtd_get_file_size,
+	.flags		= FIO_SYNCIO | FIO_NOEXTEND,
+};
+
+static void fio_init fio_mtd_register(void)
+{
+	desc = libmtd_open();
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_mtd_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+	libmtd_close(desc);
+	desc = NULL;
+}
+
diff --git a/fio.1 b/fio.1
index 26531bd..51d5294 100644
--- a/fio.1
+++ b/fio.1
@@ -659,6 +659,13 @@ file out of those files based on the offset generated by fio backend. (see the
 example job file to create such files, use rw=write option). Please note, you
 might want to set necessary environment variables to work with hdfs/libhdfs
 properly.
+.TP
+.B mtd
+Read, write and erase an MTD character device (e.g., /dev/mtd0). Discards are
+treated as erases. Depending on the underlying device type, the I/O may have
+to go in a certain pattern, e.g., on NAND, writing sequentially to erase blocks
+and discarding before overwriting. The trimwrite mode works well for this
+constraint.
 .RE
 .P
 .RE
@@ -1576,6 +1583,9 @@ Specifies the name of the Ceph pool containing the RBD.
 .TP
 .BI (rbd)clientname \fR=\fPstr
 Specifies the username (without the 'client.' prefix) used to access the Ceph cluster.
+.TP
+.BI (mtd)skipbad \fR=\fPbool
+Skip operations against known bad blocks.
 .SH OUTPUT
 While running, \fBfio\fR will display the status of the created jobs.  For
 example:
diff --git a/options.c b/options.c
index cda4790..16e4506 100644
--- a/options.c
+++ b/options.c
@@ -1257,6 +1257,10 @@ static struct opt_group fio_opt_cat_groups[] = {
 		.name	= "Tiobench profile",
 		.mask	= FIO_OPT_G_TIOBENCH,
 	},
+	{
+		.name	= "MTD",
+		.mask	= FIO_OPT_G_MTD,
+	},
 
 	{
 		.name	= NULL,
@@ -3650,6 +3654,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_IO_FLOW,
 	},
 	{
+		.name	= "skip_bad",
+		.lname	= "Skip operations against bad blocks",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(skip_bad),
+		.help	= "Skip operations against known bad blocks.",
+		.hide	= 1,
+		.def	= "0",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_MTD,
+	},
+	{
 		.name = NULL,
 	},
 };
diff --git a/options.h b/options.h
index 36fd35d..2cf435a 100644
--- a/options.h
+++ b/options.h
@@ -115,6 +115,7 @@ enum opt_category_group {
 	__FIO_OPT_G_LATPROF,
         __FIO_OPT_G_RBD,
         __FIO_OPT_G_GFAPI,
+        __FIO_OPT_G_MTD,
 	__FIO_OPT_G_NR,
 
 	FIO_OPT_G_RATE		= (1U << __FIO_OPT_G_RATE),
@@ -146,6 +147,7 @@ enum opt_category_group {
 	FIO_OPT_G_LATPROF	= (1U << __FIO_OPT_G_LATPROF),
 	FIO_OPT_G_RBD		= (1U << __FIO_OPT_G_RBD),
 	FIO_OPT_G_GFAPI		= (1U << __FIO_OPT_G_GFAPI),
+	FIO_OPT_G_MTD		= (1U << __FIO_OPT_G_MTD),
 	FIO_OPT_G_INVALID	= (1U << __FIO_OPT_G_NR),
 };
 
diff --git a/thread_options.h b/thread_options.h
index 59e32ac..9ebc816 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -262,6 +262,7 @@ struct thread_options {
 	fio_fp64_t latency_percentile;
 
 	unsigned block_error_hist;
+	unsigned int skip_bad;
 };
 
 #define FIO_TOP_STR_MAX		256
@@ -489,6 +490,7 @@ struct thread_options_pack {
 	fio_fp64_t latency_percentile;
 
 	uint32_t block_error_hist;
+	uint32_t skip_bad;
 } __attribute__((packed));
 
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
-- 
2.2.0.rc0.207.ga3a616c


