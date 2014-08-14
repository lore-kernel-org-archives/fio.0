Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39591 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbaHNMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 Aug 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XHthN-0002dm-5S
	for fio@vger.kernel.org; Thu, 14 Aug 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140814120003.D24B040249@lyth.info>
Date: Thu, 14 Aug 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b7f5c00db0d450aff09b35301bedf16e26e25d3a:

  verify: turn off numberio verification for meta and time_based (2014-08-07 15:27:31 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1b10477b21157800f030c3ec91511a810e75e4c7:

  Add support for HDFS IO engine (2014-08-13 13:36:52 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Add missing IO engines to the HOWTO

Manish Mandlik (1):
      Add support for HDFS IO engine

 HOWTO             |   30 +++++--
 Makefile          |    9 +-
 configure         |   30 +++++++
 engines/libhdfs.c |  240 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fio.1             |    3 +
 options.c         |    6 +-
 6 files changed, 309 insertions(+), 9 deletions(-)
 create mode 100644 engines/libhdfs.c

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 1c4b308..d728353 100644
--- a/HOWTO
+++ b/HOWTO
@@ -670,15 +670,31 @@ ioengine=str	Defines how the job issues io to the file. The following
 				channel semantics (Send/Recv) for the
 				InfiniBand, RoCE and iWARP protocols.
 
-			falloc   IO engine that does regular fallocate to
-				 simulate data transfer as fio ioengine.
-				 DDIR_READ  does fallocate(,mode = keep_size,)
-				 DDIR_WRITE does fallocate(,mode = 0)
-				 DDIR_TRIM  does fallocate(,mode = punch_hole)
+			falloc	IO engine that does regular fallocate to
+				simulate data transfer as fio ioengine.
+				DDIR_READ  does fallocate(,mode = keep_size,)
+				DDIR_WRITE does fallocate(,mode = 0)
+				DDIR_TRIM  does fallocate(,mode = punch_hole)
 
 			e4defrag IO engine that does regular EXT4_IOC_MOVE_EXT
-				 ioctls to simulate defragment activity in
-				 request to DDIR_WRITE event
+				ioctls to simulate defragment activity in
+				request to DDIR_WRITE event
+
+			rbd	IO engine supporting direct access to Ceph
+				Rados Block Devices (RBD) via librbd without
+				the need to use the kernel rbd driver. This
+				ioengine defines engine specific options.
+
+			gfapi	Using Glusterfs libgfapi sync interface to
+				direct access to Glusterfs volumes without
+				options.
+
+			gfapi_async Using Glusterfs libgfapi async interface
+				to direct access to Glusterfs volumes without
+				having to go through FUSE. This ioengine
+				defines engine specific options.
+
+			hdfs	Read and write through Hadoop (HDFS).
 
 			external Prefix to specify loading an external
 				IO engine object file. Append the engine
diff --git a/Makefile b/Makefile
index 65e95be..8d86269 100644
--- a/Makefile
+++ b/Makefile
@@ -38,6 +38,13 @@ SOURCE := gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
 		lib/tp.c
 
+ifdef CONFIG_LIBHDFS
+  HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
+  HDFSLIB= $(JAVA_HOME)/jre/lib/amd64/server/libjvm.so $(FIO_LIBHDFS_LIB)/liblibhdfs.a
+  CFLAGS += $(HDFSFLAGS)
+  SOURCE += engines/libhdfs.c
+endif
+
 ifdef CONFIG_64BIT_LLP64
   CFLAGS += -DBITS_PER_LONG=32
 endif
@@ -268,7 +275,7 @@ t/ieee754: $(T_IEEE_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_IEEE_OBJS) $(LIBS)
 
 fio: $(FIO_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(FIO_OBJS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(FIO_OBJS) $(LIBS) $(HDFSLIB)
 
 gfio: $(GFIO_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) -o gfio $(GFIO_OBJS) $(LIBS) $(GTK_LDFLAGS)
diff --git a/configure b/configure
index 1494dd7..33d1327 100755
--- a/configure
+++ b/configure
@@ -134,6 +134,7 @@ cpu=""
 show_help="no"
 exit_val=0
 gfio="no"
+libhdfs="no"
 
 # parse options
 for opt do
@@ -160,6 +161,8 @@ for opt do
   ;;
   --disable-gfapi) disable_gfapi="yes"
   ;;
+  --enable-libhdfs) libhdfs="yes"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -178,6 +181,7 @@ if test "$show_help" = "yes" ; then
   echo "--esx                  Configure build options for esx"
   echo "--enable-gfio          Enable building of gtk gfio"
   echo "--disable-numa         Disable libnuma even if found"
+  echo "--enable-libhdfs       Enable hdfs support"
   exit $exit_val
 fi
 
@@ -1243,6 +1247,29 @@ if compile_prog "" "" "s390_z196_facilities"; then
   fi
 fi
 echo "s390_z196_facilities          $s390_z196_facilities"
+
+##########################################
+# Check if we have required environment variables configured for libhdfs
+if test "$libhdfs" = "yes" ; then
+  hdfs_conf_error=0
+  if test "$JAVA_HOME" = "" ; then
+    echo "configure: JAVA_HOME should be defined to jdk/jvm path"
+    hdfs_conf_error=1
+  fi
+  if test "$FIO_LIBHDFS_INCLUDE" = "" ; then
+    echo "configure: FIO_LIBHDFS_INCLUDE should be defined to libhdfs inlude path"
+    hdfs_conf_error=1
+  fi
+  if test "$FIO_LIBHDFS_LIB" = "" ; then
+    echo "configure: FIO_LIBHDFS_LIB should be defined to libhdfs library path"
+    hdfs_conf_error=1
+  fi
+  if test "$hdfs_conf_error" = "1" ; then
+    exit 1
+  fi
+fi
+echo "HDFS engine                   $libhdfs"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -1384,6 +1411,9 @@ fi
 if test "$gf_fadvise" = "yes" ; then
   output_sym "CONFIG_GF_FADVISE"
 fi
+if test "$libhdfs" = "yes" ; then
+  output_sym "CONFIG_LIBHDFS"
+fi
 
 if test "$zlib" = "no" ; then
   echo "Consider installing zlib-dev (zlib-devel), some fio features depend on it."
diff --git a/engines/libhdfs.c b/engines/libhdfs.c
new file mode 100644
index 0000000..773d46b
--- /dev/null
+++ b/engines/libhdfs.c
@@ -0,0 +1,240 @@
+/*
+ * libhdfs engine
+ *
+ * this engine helps perform read/write operations on hdfs cluster using
+ * libhdfs. hdfs doesnot support modification of data once file is created.
+ *
+ * so to mimic that create many files of small size (e.g 256k), and this
+ * engine select a file based on the offset generated by fio.
+ *
+ * thus, random reads and writes can also be achieved with this logic.
+ *
+ * NOTE: please set environment variables FIO_HDFS_BS and FIO_HDFS_FCOUNT
+ * to appropriate value to work this engine properly
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/uio.h>
+#include <errno.h>
+#include <assert.h>
+
+#include "../fio.h"
+
+#include "hdfs.h"
+
+struct hdfsio_data {
+	char host[256];
+	int port;
+	hdfsFS fs;
+	hdfsFile fp;
+	unsigned long fsbs;
+	unsigned long fscount;
+	unsigned long curr_file_id;
+	unsigned int numjobs;
+	unsigned int fid_correction;
+};
+
+static int fio_hdfsio_setup_fs_params(struct hdfsio_data *hd)
+{
+	/* make sure that hdfsConnect is invoked before executing this function */
+	hdfsSetWorkingDirectory(hd->fs, "/.perftest");
+	hd->fp = hdfsOpenFile(hd->fs, ".fcount", O_RDONLY, 0, 0, 0);
+	if (hd->fp) {
+		hdfsRead(hd->fs, hd->fp, &(hd->fscount), sizeof(hd->fscount));
+		hdfsCloseFile(hd->fs, hd->fp);
+	}
+	hd->fp = hdfsOpenFile(hd->fs, ".fbs", O_RDONLY, 0, 0, 0);
+	if (hd->fp) {
+		hdfsRead(hd->fs, hd->fp, &(hd->fsbs), sizeof(hd->fsbs));
+		hdfsCloseFile(hd->fs, hd->fp);
+	}
+
+	return 0;
+}
+
+static int fio_hdfsio_prep(struct thread_data *td, struct io_u *io_u)
+{
+	struct hdfsio_data *hd;
+	hdfsFileInfo *fi;
+	unsigned long f_id;
+	char fname[80];
+	int open_flags = 0;
+
+	hd = td->io_ops->data;
+
+	if (hd->curr_file_id == -1) {
+		/* see comment in fio_hdfsio_setup() function */
+		fio_hdfsio_setup_fs_params(hd);
+	}
+
+	/* find out file id based on the offset generated by fio */
+	f_id = (io_u->offset / hd->fsbs) + hd->fid_correction;
+
+	if (f_id == hd->curr_file_id) {
+		/* file is already open */
+		return 0;
+	}
+
+	if (hd->curr_file_id != -1) {
+		hdfsCloseFile(hd->fs, hd->fp);
+	}
+
+	if (io_u->ddir == DDIR_READ) {
+		open_flags = O_RDONLY;
+	} else if (io_u->ddir == DDIR_WRITE) {
+		open_flags = O_WRONLY;
+	} else {
+		printf("Invalid I/O Operation\n");
+	}
+
+	hd->curr_file_id = f_id;
+	do {
+		sprintf(fname, ".f%lu", f_id);
+		fi = hdfsGetPathInfo(hd->fs, fname);
+		if (fi->mSize >= hd->fsbs || io_u->ddir == DDIR_WRITE) {
+			/* file has enough data to read OR file is opened in write mode */
+			hd->fp =
+			    hdfsOpenFile(hd->fs, fname, open_flags, 0, 0,
+					 hd->fsbs);
+			if (hd->fp) {
+				break;
+			}
+		}
+		/* file is empty, so try next file for reading */
+		f_id = (f_id + 1) % hd->fscount;
+	} while (1);
+
+	return 0;
+}
+
+static int fio_io_end(struct thread_data *td, struct io_u *io_u, int ret)
+{
+	if (ret != (int)io_u->xfer_buflen) {
+		if (ret >= 0) {
+			io_u->resid = io_u->xfer_buflen - ret;
+			io_u->error = 0;
+			return FIO_Q_COMPLETED;
+		} else
+			io_u->error = errno;
+	}
+
+	if (io_u->error)
+		td_verror(td, io_u->error, "xfer");
+
+	return FIO_Q_COMPLETED;
+}
+
+static int fio_hdfsio_queue(struct thread_data *td, struct io_u *io_u)
+{
+	struct hdfsio_data *hd;
+	int ret = 0;
+
+	hd = td->io_ops->data;
+
+	if (io_u->ddir == DDIR_READ) {
+		ret =
+		    hdfsRead(hd->fs, hd->fp, io_u->xfer_buf, io_u->xfer_buflen);
+	} else if (io_u->ddir == DDIR_WRITE) {
+		ret =
+		    hdfsWrite(hd->fs, hd->fp, io_u->xfer_buf,
+			      io_u->xfer_buflen);
+	} else {
+		printf("Invalid I/O Operation\n");
+	}
+
+	return fio_io_end(td, io_u, ret);
+}
+
+int fio_hdfsio_open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct hdfsio_data *hd;
+
+	hd = td->io_ops->data;
+	hd->fs = hdfsConnect(hd->host, hd->port);
+	hdfsSetWorkingDirectory(hd->fs, "/.perftest");
+	hd->fid_correction = (getpid() % hd->numjobs);
+
+	return 0;
+}
+
+int fio_hdfsio_close_file(struct thread_data *td, struct fio_file *f)
+{
+	struct hdfsio_data *hd;
+
+	hd = td->io_ops->data;
+	hdfsDisconnect(hd->fs);
+
+	return 0;
+}
+
+static int fio_hdfsio_setup(struct thread_data *td)
+{
+	struct hdfsio_data *hd;
+	struct fio_file *f;
+	static unsigned int numjobs = 1;	/* atleast one job has to be there! */
+	numjobs = (td->o.numjobs > numjobs) ? td->o.numjobs : numjobs;
+
+	if (!td->io_ops->data) {
+		hd = malloc(sizeof(*hd));;
+
+		memset(hd, 0, sizeof(*hd));
+		td->io_ops->data = hd;
+
+		/* separate host and port from filename */
+		*(strchr(td->o.filename, ',')) = ' ';
+		sscanf(td->o.filename, "%s%d", hd->host, &(hd->port));
+
+		/* read fbs and fcount and based on that set f->real_file_size */
+		f = td->files[0];
+#if 0
+		/* IMHO, this should be done here instead of fio_hdfsio_prep()
+		 * but somehow calling it here doesn't seem to work,
+		 * some problem with libhdfs that needs to be debugged */
+		hd->fs = hdfsConnect(hd->host, hd->port);
+		fio_hdfsio_setup_fs_params(hd);
+		hdfsDisconnect(hd->fs);
+#else
+		/* so, as an alternate, using environment variables */
+		if (getenv("FIO_HDFS_FCOUNT") && getenv("FIO_HDFS_BS")) {
+			hd->fscount = atol(getenv("FIO_HDFS_FCOUNT"));
+			hd->fsbs = atol(getenv("FIO_HDFS_BS"));
+		} else {
+			fprintf(stderr,
+				"FIO_HDFS_FCOUNT and/or FIO_HDFS_BS not set.\n");
+			return 1;
+		}
+#endif
+		f->real_file_size = hd->fscount * hd->fsbs;
+
+		td->o.nr_files = 1;
+		hd->curr_file_id = -1;
+		hd->numjobs = numjobs;
+		fio_file_set_size_known(f);
+	}
+
+	return 0;
+}
+
+static struct ioengine_ops ioengine_hdfs = {
+	.name = "libhdfs",
+	.version = FIO_IOOPS_VERSION,
+	.setup = fio_hdfsio_setup,
+	.prep = fio_hdfsio_prep,
+	.queue = fio_hdfsio_queue,
+	.open_file = fio_hdfsio_open_file,
+	.close_file = fio_hdfsio_close_file,
+	.flags = FIO_SYNCIO,
+};
+
+static void fio_init fio_hdfsio_register(void)
+{
+	register_ioengine(&ioengine_hdfs);
+}
+
+static void fio_exit fio_hdfsio_unregister(void)
+{
+	unregister_ioengine(&ioengine_hdfs);
+}
diff --git a/fio.1 b/fio.1
index 5291126..b5ff3cc 100644
--- a/fio.1
+++ b/fio.1
@@ -612,6 +612,9 @@ options.
 Using Glusterfs libgfapi async interface to direct access to Glusterfs volumes without
 having to go through FUSE. This ioengine defines engine specific
 options.
+.TP
+.B hdfs
+Read and write through Hadoop (HDFS)
 .RE
 .P
 .RE
diff --git a/options.c b/options.c
index 3a3321f..484efc1 100644
--- a/options.c
+++ b/options.c
@@ -1541,7 +1541,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "Glusterfs libgfapi(async) based engine"
 			  },
 #endif
-
+#ifdef CONFIG_LIBHDFS
+			  { .ival = "hdfs",
+			    .help = "Hadoop Distributed Filesystem (HDFS) engine"
+			  },
+#endif
 			  { .ival = "external",
 			    .help = "Load external engine (append name)",
 			  },
