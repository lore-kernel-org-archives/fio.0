Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 6/9] New ioctl based synchronous IO engine. Only supports
 copy command
Date: Tue,  1 Dec 2020 17:10:31 +0530
Message-Id: <20201201114034.8307-7-krish.reddy@samsung.com>
In-Reply-To: <20201201114034.8307-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <20201201114034.8307-1-krish.reddy@samsung.com>
	<CGME20201201114105epcas5p4b99d6a66a543152a377461875aedf342@epcas5p4.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

From: Ankit Kumar <ankit.kumar@samsung.com>

Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
---
 HOWTO          |   4 +
 Makefile       |   2 +-
 engines/sctl.c | 215 +++++++++++++++++++++++++++++++++++++++++++++++++
 fio.1          |   4 +
 io_u.h         |   3 +
 options.c      |   5 ++
 os/os-linux.h  |   1 +
 7 files changed, 233 insertions(+), 1 deletion(-)
 create mode 100644 engines/sctl.c

diff --git a/HOWTO b/HOWTO
index 5cbd46a2..76b04918 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1913,6 +1913,10 @@ I/O engine
 			character devices. This engine supports trim operations.
 			The sg engine includes engine specific options.
 
+		**sctl**
+			Synchronous ioengine. This engine only supports option ``rw=copy`` and
+			``rw=randcopy`` operations. The target should be a block device file.
+
 		**null**
 			Doesn't transfer any data, just pretends to.  This is mainly used to
 			exercise fio itself and for debugging/testing purposes.
diff --git a/Makefile b/Makefile
index ecfaa3e0..3dad92ab 100644
--- a/Makefile
+++ b/Makefile
@@ -189,7 +189,7 @@ endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
-		oslib/linux-dev-lookup.c engines/io_uring.c
+		oslib/linux-dev-lookup.c engines/io_uring.c engines/sctl.c
 ifdef CONFIG_HAS_BLKZONED
   SOURCE += oslib/linux-blkzoned.c
 endif
diff --git a/engines/sctl.c b/engines/sctl.c
new file mode 100644
index 00000000..7c51e9b0
--- /dev/null
+++ b/engines/sctl.c
@@ -0,0 +1,215 @@
+/*
+ * sctl engine
+ *
+ * IO engine using the Linux ioctl based interface for NVMe device
+ * This ioengine operates in sync mode with block devices (/dev/nvmeX)
+ *
+ */
+#include <sys/stat.h>
+#include "../fio.h"
+
+struct sctl_data {
+	struct copy_range *cr;
+};
+
+static enum fio_q_status fio_sctl_queue(struct thread_data *td,
+					struct io_u *io_u)
+{
+	struct copy_range *cr = &io_u->cr;
+	struct fio_file *f = io_u->file;
+	int ret;
+
+	ret = ioctl(f->fd, BLKCOPY, cr);
+
+	if (ret < 0)
+		io_u->error = errno;
+	else {
+		io_u_mark_submit(td, 1);
+		io_u_queued(td, io_u);
+	}
+
+	if (io_u->error) {
+		td_verror(td, io_u->error, "xfer");
+		return FIO_Q_COMPLETED;
+	}
+
+	return ret;
+}
+
+static int fio_sctl_prep(struct thread_data *td, struct io_u *io_u)
+{
+	struct copy_range *cr = &io_u->cr;
+
+	memset(cr, 0, sizeof(*cr));
+
+	cr->dest = io_u->offset;
+	cr->nr_range = io_u->xfer_buflen / sizeof(struct source_range);
+	cr->range_list = (__u64)io_u->xfer_buf;
+
+	return 0;
+}
+
+static void fio_sctl_cleanup(struct thread_data *td)
+{
+	struct sctl_data *sd = td->io_ops_data;
+
+	if (sd) {
+		free(sd->cr);
+		free(sd);
+	}
+}
+
+static int fio_sctl_init(struct thread_data *td)
+{
+	struct sctl_data *sd;
+
+	sd = calloc(1, sizeof(*sd));
+	sd->cr = calloc(td->o.iodepth, sizeof(struct copy_range));
+
+	td->io_ops_data = sd;
+
+	return 0;
+}
+
+static int fio_sctl_type_check(struct thread_data *td, struct fio_file *f) {
+	char cpath[PATH_MAX];
+	FILE *sfile;
+	uint32_t copy_sectors, num_ranges, copy_range_sectors;
+	struct stat st;
+	int rc;
+
+	if (f->filetype != FIO_TYPE_BLOCK)
+		return -EINVAL;
+
+	rc = stat(f->file_name, &st);
+	if (rc < 0) {
+		log_err("%s: failed to stat file %s (%s)\n",
+			td->o.name, f->file_name, strerror(errno));
+		return -errno;
+	}
+
+	snprintf(cpath, PATH_MAX, "/sys/dev/block/%d:%d/queue/max_copy_sectors",
+		 major(st.st_rdev), minor(st.st_rdev));
+
+	sfile = fopen(cpath, "r");
+	if (!sfile) {
+		log_err("%s: fopen on %s failed (%s)\n",
+			td->o.name, cpath, strerror(errno));
+		return 1;
+	}
+
+	rc = fscanf(sfile, "%u", &copy_sectors);
+	if (rc < 0) {
+		log_err("%s: fscanf on %s failed (%s)\n",
+			td->o.name, cpath, strerror(errno));
+		fclose(sfile);
+		return 1;
+	}
+
+	if (!copy_sectors) {
+		log_err("%s: Device doesn't support copy operation\n",
+			td->o.name);
+		fclose(sfile);
+		return 1;
+	}
+
+	fclose(sfile);
+
+	snprintf(cpath, PATH_MAX, "/sys/dev/block/%d:%d/queue/max_copy_nr_ranges",
+		 major(st.st_rdev), minor(st.st_rdev));
+
+	sfile = fopen(cpath, "r");
+	if (!sfile) {
+		log_err("%s: fopen on %s failed (%s)\n",
+			td->o.name, cpath, strerror(errno));
+		return 1;
+	}
+
+	rc = fscanf(sfile, "%u", &num_ranges);
+	if (rc < 0) {
+		log_err("%s: fscanf on %s failed (%s)\n",
+			td->o.name, cpath, strerror(errno));
+		fclose(sfile);
+		return 1;
+	}
+
+	if (td->o.num_range > num_ranges) {
+		log_err("%s: number of copy ranges is more than device supported"
+			" (%u > %u)\n", td->o.name,
+			td->o.num_range,
+			num_ranges);
+		fclose(sfile);
+		return 1;
+	}
+
+	fclose(sfile);
+
+	snprintf(cpath, PATH_MAX, "/sys/dev/block/%d:%d/queue/max_copy_range_sectors",
+		 major(st.st_rdev), minor(st.st_rdev));
+
+	sfile = fopen(cpath, "r");
+	if (!sfile) {
+		log_err("%s: fopen on %s failed (%s)\n",
+			td->o.name, cpath, strerror(errno));
+		return 1;
+	}
+
+	rc = fscanf(sfile, "%u", &copy_range_sectors);
+	if (rc < 0) {
+		log_err("%s: fscanf on %s failed (%s)\n",
+			td->o.name, cpath, strerror(errno));
+		fclose(sfile);
+		return 1;
+	}
+
+	if (td->o.bs[DDIR_COPY] > (((unsigned long long) copy_range_sectors) << 9)) {
+		log_err("%s: size of copy range is more than device supported"
+			" (%llu > %llu)\n", td->o.name,
+			td->o.bs[DDIR_COPY],
+			((unsigned long long) copy_range_sectors) << 9);
+		fclose(sfile);
+		return 1;
+	}
+
+	fclose(sfile);
+
+	return 0;
+}
+
+static int fio_sctl_open(struct thread_data *td, struct fio_file *f) {
+	int ret;
+
+	ret = generic_open_file(td, f);
+	if (ret)
+		return ret;
+
+	if (fio_sctl_type_check(td, f)) {
+		ret = generic_close_file(td, f);
+		return 1;
+	}
+
+	return 0;
+}
+
+static struct ioengine_ops ioengine = {
+	.name			= "sctl",
+	.version		= FIO_IOOPS_VERSION,
+	.init			= fio_sctl_init,
+	.prep			= fio_sctl_prep,
+	.queue			= fio_sctl_queue,
+	.cleanup		= fio_sctl_cleanup,
+	.open_file		= fio_sctl_open,
+	.close_file		= generic_close_file,
+	.get_file_size		= generic_get_file_size,
+	.flags			= FIO_SYNCIO
+};
+
+static void fio_init fio_sctl_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_sctl_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/fio.1 b/fio.1
index d4da1b0c..c09d0288 100644
--- a/fio.1
+++ b/fio.1
@@ -1684,6 +1684,10 @@ I/O. Requires \fBfilename\fR option to specify either block or
 character devices. This engine supports trim operations. The
 sg engine includes engine specific options.
 .TP
+.B sctl
+Synchronous ioengine. This engine only supports `rw=copy' and
+`rw=randcopy' operations. The target should be a block device file.
+.TP
 .B libzbc
 Synchronous I/O engine for SMR hard-disks using the \fBlibzbc\fR
 library. The target can be either an sg character device or
diff --git a/io_u.h b/io_u.h
index d4c5be43..e0b10595 100644
--- a/io_u.h
+++ b/io_u.h
@@ -127,6 +127,9 @@ struct io_u {
 #endif
 #ifdef CONFIG_RDMA
 		struct ibv_mr *mr;
+#endif
+#ifdef FIO_HAVE_SCTL
+		struct copy_range cr;
 #endif
 		void *mmap_data;
 	};
diff --git a/options.c b/options.c
index e085ab25..1b3bed3b 100644
--- a/options.c
+++ b/options.c
@@ -1886,6 +1886,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  { .ival = "sg",
 			    .help = "SCSI generic v3 IO",
 			  },
+#endif
+#ifdef FIO_HAVE_SCTL
+			  { .ival = "sctl",
+			    .help = "Simple copy IO engine",
+			  },
 #endif
 			  { .ival = "null",
 			    .help = "Testing engine (no data transfer)",
diff --git a/os/os-linux.h b/os/os-linux.h
index 5562b0da..d0a620cc 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -36,6 +36,7 @@
 #define FIO_HAVE_CPU_AFFINITY
 #define FIO_HAVE_DISK_UTIL
 #define FIO_HAVE_SGIO
+#define FIO_HAVE_SCTL
 #define FIO_HAVE_IOPRIO
 #define FIO_HAVE_IOPRIO_CLASS
 #define FIO_HAVE_IOSCHED_SWITCH
-- 
2.17.1


