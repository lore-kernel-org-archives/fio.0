Return-Path: <josef@toxicpanda.com>
Return-Path: <josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH] add a filecreate engine
Date: Fri,  6 Oct 2017 15:43:14 -0400
Message-Id: <1507318994-8341-1-git-send-email-jbacik@fb.com>
To: axboe@kernel.dk, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is for doing empty file creation jobs much like what we do with
fs_mark.  You still need to specify a filesize so that fio will pretend
to do something, but the IO won't actually be done on the file.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 HOWTO                |  4 +++
 Makefile             |  2 +-
 engines/filecreate.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fio.1                |  4 +++
 4 files changed, 98 insertions(+), 1 deletion(-)
 create mode 100644 engines/filecreate.c

diff --git a/HOWTO b/HOWTO
index 8fad2ce6f4d8..df79e2dffb30 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1797,6 +1797,10 @@ I/O engine
 			absolute or relative. See :file:`engines/skeleton_external.c` for
 			details of writing an external I/O engine.
 
+		**filecreate**
+			Simply create the files and do no IO to them.  You still need to
+			set  `filesize` so that all the accounting still occurs, but no
+			actual IO will be done other than creating the file.
 
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/Makefile b/Makefile
index 3764da550851..76243ffb056e 100644
--- a/Makefile
+++ b/Makefile
@@ -42,7 +42,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		eta.c verify.c memory.c io_u.c parse.c mutex.c options.c \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
-		engines/ftruncate.c \
+		engines/ftruncate.c engines/filecreate.c \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
diff --git a/engines/filecreate.c b/engines/filecreate.c
new file mode 100644
index 000000000000..284aaf398328
--- /dev/null
+++ b/engines/filecreate.c
@@ -0,0 +1,89 @@
+/*
+ * filecreate engine
+ *
+ * IO engine that doesn't do any IO, just creates files and tracks the latency
+ * of the file creation.
+ */
+#include <stdio.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+
+#include "../fio.h"
+#include "../filehash.h"
+
+static int open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct timespec start, end;
+	int from_hash = 0;
+	int do_lat = !td->o.disable_lat;
+
+	dprint(FD_FILE, "fd open %s\n", f->file_name);
+
+	if (f->filetype != FIO_TYPE_FILE) {
+		log_err("fio: only files are supported fallocate \n");
+		return 1;
+	}
+	if (!strcmp(f->file_name, "-")) {
+		log_err("fio: can't read/write to stdin/out\n");
+		return 1;
+	}
+
+open_again:
+	if (do_lat)
+		fio_gettime(&start, NULL);
+	from_hash = file_lookup_open(f, O_CREAT|O_RDWR);
+	if (do_lat) {
+		unsigned long long nsec;
+
+		fio_gettime(&end, NULL);
+		nsec = ntime_since(&start, &end);
+		add_lat_sample(td, DDIR_WRITE, nsec, 0, 0);
+	}
+
+	if (f->fd == -1) {
+		char buf[FIO_VERROR_SIZE];
+		int e = errno;
+
+		snprintf(buf, sizeof(buf), "open(%s)", f->file_name);
+		td_verror(td, e, buf);
+	}
+
+	if (!from_hash && f->fd != -1) {
+		if (add_file_hash(f)) {
+			int fio_unused ret;
+
+			/*
+			 * OK to ignore, we haven't done anything with it
+			 */
+			ret = generic_close_file(td, f);
+			goto open_again;
+		}
+	}
+
+	return 0;
+}
+
+static int queue_io(struct thread_data *td, struct io_u fio_unused *io_u)
+{
+	return FIO_Q_COMPLETED;
+}
+
+static struct ioengine_ops ioengine = {
+	.name		= "filecreate",
+	.version	= FIO_IOOPS_VERSION,
+	.open_file	= open_file,
+	.queue		= queue_io,
+	.close_file	= generic_close_file,
+	.flags		= FIO_DISKLESSIO | FIO_SYNCIO | FIO_FAKEIO,
+};
+
+static void fio_init fio_filecreate_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_filecreate_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/fio.1 b/fio.1
index b943db2289d6..68ed3ba457b9 100644
--- a/fio.1
+++ b/fio.1
@@ -1577,6 +1577,10 @@ the engine filename, e.g. `ioengine=external:/tmp/foo.o' to load
 ioengine `foo.o' in `/tmp'. The path can be either
 absolute or relative. See `engines/skeleton_external.c' in the fio source for
 details of writing an external I/O engine.
+.TP
+.B filecreate
+Create empty files only.  \fBfilesize\fR still needs to be specified so that fio
+will run and grab latency results, but no IO will actually be done on the files.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
-- 
2.7.4


