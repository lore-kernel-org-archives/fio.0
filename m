Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56126 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbaBSNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Feb 2014 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WG6kv-0007lt-70
	for fio@vger.kernel.org; Wed, 19 Feb 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140219130004.14349429CF@strynoevaenget.dk>
Date: Wed, 19 Feb 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 81fa6e06408879509e005cbb192205b9125f7614:

  Fix early termination of cpu id string (2014-02-14 08:48:22 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dc632d12d74bab6a439aaf8c317d250d3a8def5c:

  add example job file for the RBD engine (2014-02-18 11:22:16 -0800)

----------------------------------------------------------------
Daniel Gollub (1):
      librbd ioengine support

Danny Al-Gaaf (2):
      fio.1: add rbd options to man page
      add example job file for the RBD engine

 Makefile         |    3 +
 configure        |   30 ++++
 engines/rbd.c    |  449 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 examples/rbd.fio |   23 +++
 fio.1            |   14 ++
 options.c        |    5 +
 options.h        |    2 +
 7 files changed, 526 insertions(+)
 create mode 100644 engines/rbd.c
 create mode 100644 examples/rbd.fio

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 3f654f0..1113c2f 100644
--- a/Makefile
+++ b/Makefile
@@ -76,6 +76,9 @@ endif
 ifdef CONFIG_WINDOWSAIO
   SOURCE += engines/windowsaio.c
 endif
+ifdef CONFIG_RBD
+  SOURCE += engines/rbd.c
+endif
 ifndef CONFIG_STRSEP
   SOURCE += lib/strsep.c
 endif
diff --git a/configure b/configure
index 89405cd..4b00679 100755
--- a/configure
+++ b/configure
@@ -1119,6 +1119,33 @@ if compile_prog "" "" "ipv6"; then
 fi
 echo "IPv6 helpers                  $ipv6"
 
+##########################################
+# check for rbd
+rbd="no"
+cat > $TMPC << EOF
+#include <rbd/librbd.h>
+
+int main(int argc, char **argv)
+{
+
+  rados_t cluster;
+  rados_ioctx_t io_ctx;
+  const char pool[] = "rbd";
+
+  int major, minor, extra;
+  rbd_version(&major, &minor, &extra);
+
+  rados_ioctx_create(cluster, pool, &io_ctx);
+  return 0;
+}
+EOF
+if compile_prog "" "-lrbd -lrados" "rbd"; then
+  LIBS="-lrbd -lrados $LIBS"
+  rbd="yes"
+fi
+echo "Rados Block Device engine     $rbd"
+
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -1240,6 +1267,9 @@ fi
 if test "$ipv6" = "yes" ; then
   output_sym "CONFIG_IPV6"
 fi
+if test "$rbd" = "yes" ; then
+  output_sym "CONFIG_RBD"
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "CFLAGS+=$CFLAGS" >> $config_host_mak
diff --git a/engines/rbd.c b/engines/rbd.c
new file mode 100644
index 0000000..d089a41
--- /dev/null
+++ b/engines/rbd.c
@@ -0,0 +1,449 @@
+/*
+ * rbd engine
+ *
+ * IO engine using Ceph's librbd to test RADOS Block Devices.
+ *
+ */
+
+#include <rbd/librbd.h>
+
+#include "../fio.h"
+
+struct fio_rbd_iou {
+	struct io_u *io_u;
+	int io_complete;
+};
+
+struct rbd_data {
+	rados_t cluster;
+	rados_ioctx_t io_ctx;
+	rbd_image_t image;
+	struct io_u **aio_events;
+};
+
+struct rbd_options {
+	struct thread_data *td;
+	char *rbd_name;
+	char *pool_name;
+	char *client_name;
+};
+
+static struct fio_option options[] = {
+	{
+	 .name     = "rbdname",
+	 .lname    = "rbd engine rbdname",
+	 .type     = FIO_OPT_STR_STORE,
+	 .help     = "RBD name for RBD engine",
+	 .off1     = offsetof(struct rbd_options, rbd_name),
+	 .category = FIO_OPT_C_ENGINE,
+	 .group    = FIO_OPT_G_RBD,
+	 },
+	{
+	 .name     = "pool",
+	 .lname    = "rbd engine pool",
+	 .type     = FIO_OPT_STR_STORE,
+	 .help     = "Name of the pool hosting the RBD for the RBD engine",
+	 .off1     = offsetof(struct rbd_options, pool_name),
+	 .category = FIO_OPT_C_ENGINE,
+	 .group    = FIO_OPT_G_RBD,
+	 },
+	{
+	 .name     = "clientname",
+	 .lname    = "rbd engine clientname",
+	 .type     = FIO_OPT_STR_STORE,
+	 .help     = "Name of the ceph client to access the RBD for the RBD engine",
+	 .off1     = offsetof(struct rbd_options, client_name),
+	 .category = FIO_OPT_C_ENGINE,
+	 .group    = FIO_OPT_G_RBD,
+	 },
+	{
+	 .name = NULL,
+	 },
+};
+
+static int _fio_setup_rbd_data(struct thread_data *td,
+			       struct rbd_data **rbd_data_ptr)
+{
+	struct rbd_data *rbd_data;
+
+	if (td->io_ops->data)
+		return 0;
+
+	rbd_data = malloc(sizeof(struct rbd_data));
+	if (!rbd_data)
+		goto failed;
+
+	memset(rbd_data, 0, sizeof(struct rbd_data));
+
+	rbd_data->aio_events = malloc(td->o.iodepth * sizeof(struct io_u *));
+	if (!rbd_data->aio_events)
+		goto failed;
+
+	memset(rbd_data->aio_events, 0, td->o.iodepth * sizeof(struct io_u *));
+
+	*rbd_data_ptr = rbd_data;
+
+	return 0;
+
+failed:
+	return 1;
+
+}
+
+static int _fio_rbd_connect(struct thread_data *td)
+{
+	struct rbd_data *rbd_data = td->io_ops->data;
+	struct rbd_options *o = td->eo;
+	int r;
+
+	r = rados_create(&(rbd_data->cluster), o->client_name);
+	if (r < 0) {
+		log_err("rados_create failed.\n");
+		goto failed_early;
+	}
+
+	r = rados_conf_read_file(rbd_data->cluster, NULL);
+	if (r < 0) {
+		log_err("rados_conf_read_file failed.\n");
+		goto failed_early;
+	}
+
+	r = rados_connect(rbd_data->cluster);
+	if (r < 0) {
+		log_err("rados_connect failed.\n");
+		goto failed_shutdown;
+	}
+
+	r = rados_ioctx_create(rbd_data->cluster, o->pool_name,
+			       &(rbd_data->io_ctx));
+	if (r < 0) {
+		log_err("rados_ioctx_create failed.\n");
+		goto failed_shutdown;
+	}
+
+	r = rbd_open(rbd_data->io_ctx, o->rbd_name, &(rbd_data->image),
+		     NULL /*snap */ );
+	if (r < 0) {
+		log_err("rbd_open failed.\n");
+		goto failed_open;
+	}
+	return 0;
+
+failed_open:
+	rados_ioctx_destroy(rbd_data->io_ctx);
+failed_shutdown:
+	rados_shutdown(rbd_data->cluster);
+failed_early:
+	return 1;
+}
+
+static void _fio_rbd_disconnect(struct rbd_data *rbd_data)
+{
+	if (!rbd_data)
+		return;
+
+	/* shutdown everything */
+	if (rbd_data->image) {
+		rbd_close(rbd_data->image);
+		rbd_data->image = NULL;
+	}
+
+	if (rbd_data->io_ctx) {
+		rados_ioctx_destroy(rbd_data->io_ctx);
+		rbd_data->io_ctx = NULL;
+	}
+
+	if (rbd_data->cluster) {
+		rados_shutdown(rbd_data->cluster);
+		rbd_data->cluster = NULL;
+	}
+}
+
+static void _fio_rbd_finish_write_aiocb(rbd_completion_t comp, void *data)
+{
+	struct io_u *io_u = (struct io_u *)data;
+	struct fio_rbd_iou *fio_rbd_iou =
+	    (struct fio_rbd_iou *)io_u->engine_data;
+
+	fio_rbd_iou->io_complete = 1;
+
+	/* if write needs to be verified - we should not release comp here
+	   without fetching the result */
+
+	rbd_aio_release(comp);
+	/* TODO handle error */
+
+	return;
+}
+
+static void _fio_rbd_finish_read_aiocb(rbd_completion_t comp, void *data)
+{
+	struct io_u *io_u = (struct io_u *)data;
+	struct fio_rbd_iou *fio_rbd_iou =
+	    (struct fio_rbd_iou *)io_u->engine_data;
+
+	fio_rbd_iou->io_complete = 1;
+
+	/* if read needs to be verified - we should not release comp here
+	   without fetching the result */
+	rbd_aio_release(comp);
+
+	/* TODO handle error */
+
+	return;
+}
+
+static struct io_u *fio_rbd_event(struct thread_data *td, int event)
+{
+	struct rbd_data *rbd_data = td->io_ops->data;
+
+	return rbd_data->aio_events[event];
+}
+
+static int fio_rbd_getevents(struct thread_data *td, unsigned int min,
+			     unsigned int max, struct timespec *t)
+{
+	struct rbd_data *rbd_data = td->io_ops->data;
+	unsigned int events = 0;
+	struct io_u *io_u;
+	int i;
+	struct fio_rbd_iou *fov;
+
+	do {
+		io_u_qiter(&td->io_u_all, io_u, i) {
+			if (!(io_u->flags & IO_U_F_FLIGHT))
+				continue;
+
+			fov = (struct fio_rbd_iou *)io_u->engine_data;
+
+			if (fov->io_complete) {
+				fov->io_complete = 0;
+				rbd_data->aio_events[events] = io_u;
+				events++;
+			}
+
+		}
+		if (events < min)
+			usleep(100);
+		else
+			break;
+
+	} while (1);
+
+	return events;
+}
+
+static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
+{
+	int r = -1;
+	struct rbd_data *rbd_data = td->io_ops->data;
+	rbd_completion_t comp;
+
+	fio_ro_check(td, io_u);
+
+	if (io_u->ddir == DDIR_WRITE) {
+		r = rbd_aio_create_completion(io_u,
+					      (rbd_callback_t)
+					      _fio_rbd_finish_write_aiocb,
+					      &comp);
+		if (r < 0) {
+			log_err
+			    ("rbd_aio_create_completion for DDIR_WRITE failed.\n");
+			goto failed;
+		}
+
+		r = rbd_aio_write(rbd_data->image, io_u->offset,
+				  io_u->xfer_buflen, io_u->xfer_buf, comp);
+		if (r < 0) {
+			log_err("rbd_aio_write failed.\n");
+			goto failed;
+		}
+
+	} else if (io_u->ddir == DDIR_READ) {
+		r = rbd_aio_create_completion(io_u,
+					      (rbd_callback_t)
+					      _fio_rbd_finish_read_aiocb,
+					      &comp);
+		if (r < 0) {
+			log_err
+			    ("rbd_aio_create_completion for DDIR_READ failed.\n");
+			goto failed;
+		}
+
+		r = rbd_aio_read(rbd_data->image, io_u->offset,
+				 io_u->xfer_buflen, io_u->xfer_buf, comp);
+
+		if (r < 0) {
+			log_err("rbd_aio_read failed.\n");
+			goto failed;
+		}
+
+	} else if (io_u->ddir == DDIR_SYNC) {
+		r = rbd_flush(rbd_data->image);
+		if (r < 0) {
+			log_err("rbd_flush failed.\n");
+			goto failed;
+		}
+
+		return FIO_Q_COMPLETED;
+	} else {
+		dprint(FD_IO, "%s: Warning: unhandled ddir: %d\n", __func__,
+		       io_u->ddir);
+		return FIO_Q_COMPLETED;
+	}
+
+	return FIO_Q_QUEUED;
+
+failed:
+	io_u->error = r;
+	td_verror(td, io_u->error, "xfer");
+	return FIO_Q_COMPLETED;
+}
+
+static int fio_rbd_init(struct thread_data *td)
+{
+	int r;
+
+	r = _fio_rbd_connect(td);
+	if (r) {
+		log_err("fio_rbd_connect failed, return code: %d .\n", r);
+		goto failed;
+	}
+
+	return 0;
+
+failed:
+	return 1;
+
+}
+
+static void fio_rbd_cleanup(struct thread_data *td)
+{
+	struct rbd_data *rbd_data = td->io_ops->data;
+
+	if (rbd_data) {
+		_fio_rbd_disconnect(rbd_data);
+		free(rbd_data->aio_events);
+		free(rbd_data);
+	}
+
+}
+
+static int fio_rbd_setup(struct thread_data *td)
+{
+	int r = 0;
+	rbd_image_info_t info;
+	struct fio_file *f;
+	struct rbd_data *rbd_data = NULL;
+	int major, minor, extra;
+
+	/* log version of librbd. No cluster connection required. */
+	rbd_version(&major, &minor, &extra);
+	log_info("rbd engine: RBD version: %d.%d.%d\n", major, minor, extra);
+
+	/* allocate engine specific structure to deal with librbd. */
+	r = _fio_setup_rbd_data(td, &rbd_data);
+	if (r) {
+		log_err("fio_setup_rbd_data failed.\n");
+		goto cleanup;
+	}
+	td->io_ops->data = rbd_data;
+
+	/* librbd does not allow us to run first in the main thread and later in a
+	 * fork child. It needs to be the same process context all the time. 
+	 */
+	td->o.use_thread = 1;
+
+	/* connect in the main thread to determine to determine
+	 * the size of the given RADOS block device. And disconnect
+	 * later on.
+	 */
+	r = _fio_rbd_connect(td);
+	if (r) {
+		log_err("fio_rbd_connect failed.\n");
+		goto cleanup;
+	}
+
+	/* get size of the RADOS block device */
+	r = rbd_stat(rbd_data->image, &info, sizeof(info));
+	if (r < 0) {
+		log_err("rbd_status failed.\n");
+		goto disconnect;
+	}
+	dprint(FD_IO, "rbd-engine: image size: %lu\n", info.size);
+
+	/* taken from "net" engine. Pretend we deal with files,
+	 * even if we do not have any ideas about files.
+	 * The size of the RBD is set instead of a artificial file.
+	 */
+	if (!td->files_index) {
+		add_file(td, td->o.filename ? : "rbd");
+		td->o.nr_files = td->o.nr_files ? : 1;
+	}
+	f = td->files[0];
+	f->real_file_size = info.size;
+
+	/* disconnect, then we were only connected to determine
+	 * the size of the RBD.
+	 */
+	_fio_rbd_disconnect(rbd_data);
+	return 0;
+
+disconnect:
+	_fio_rbd_disconnect(rbd_data);
+cleanup:
+	fio_rbd_cleanup(td);
+	return r;
+}
+
+static int fio_rbd_open(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+
+static void fio_rbd_io_u_free(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_rbd_iou *o = io_u->engine_data;
+
+	if (o) {
+		io_u->engine_data = NULL;
+		free(o);
+	}
+}
+
+static int fio_rbd_io_u_init(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_rbd_iou *o;
+
+	o = malloc(sizeof(*o));
+	o->io_complete = 0;
+	o->io_u = io_u;
+	io_u->engine_data = o;
+	return 0;
+}
+
+struct ioengine_ops ioengine = {
+	.name               = "rbd",
+	.version            = FIO_IOOPS_VERSION,
+	.setup              = fio_rbd_setup,
+	.init               = fio_rbd_init,
+	.queue              = fio_rbd_queue,
+	.getevents          = fio_rbd_getevents,
+	.event              = fio_rbd_event,
+	.cleanup            = fio_rbd_cleanup,
+	.open_file          = fio_rbd_open,
+	.options            = options,
+	.io_u_init          = fio_rbd_io_u_init,
+	.io_u_free          = fio_rbd_io_u_free,
+	.option_struct_size = sizeof(struct rbd_options),
+};
+
+static void fio_init fio_rbd_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_rbd_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/rbd.fio b/examples/rbd.fio
new file mode 100644
index 0000000..fcb494a
--- /dev/null
+++ b/examples/rbd.fio
@@ -0,0 +1,23 @@
+######################################################################
+# Example test for the RBD engine.
+# 
+# Runs a 4k random write test agains a RBD via librbd  
+#
+# NOTE: Make sure you have either a RBD named 'fio_test' or change 
+#       the rbdname parameter.
+######################################################################
+[global]
+#logging
+#write_iops_log=write_iops_log
+#write_bw_log=write_bw_log
+#write_lat_log=write_lat_log
+ioengine=rbd
+clientname=admin
+pool=rbd
+rbdname=fio_test
+invalidate=0	# mandatory
+rw=randwrite
+bs=4k
+
+[rbd_iodepth32]
+iodepth=32
diff --git a/fio.1 b/fio.1
index ec10377..1df1cd1 100644
--- a/fio.1
+++ b/fio.1
@@ -557,6 +557,11 @@ transfer as fio ioengine
 .B e4defrag
 IO engine that does regular EXT4_IOC_MOVE_EXT ioctls to simulate defragment activity
 request to DDIR_WRITE event
+.TP
+.B rbd
+IO engine supporting direct access to Ceph Rados Block Devices (RBD) via librbd 
+without the need to use the kernel rbd driver. This ioengine defines engine specific 
+options.
 .RE
 .P
 .RE
@@ -1394,6 +1399,15 @@ Preallocate donor's file on init
 .BI 1:
 allocate space immediately inside defragment event, and free right after event
 .RE
+.TP
+.BI (rbd)rbdname \fR=\fPstr
+Specifies the name of the RBD.
+.TP
+.BI (rbd)pool \fR=\fPstr
+Specifies the name of the Ceph pool containing the RBD.
+.TP
+.BI (rbd)clientname \fR=\fPstr
+Specifies the username (without the 'client.' prefix) used to access the Ceph cluster.
 .SH OUTPUT
 While running, \fBfio\fR will display the status of the created jobs.  For
 example:
diff --git a/options.c b/options.c
index 4dcefba..ea51664 100644
--- a/options.c
+++ b/options.c
@@ -1388,6 +1388,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "Windows native asynchronous IO"
 			  },
 #endif
+#ifdef CONFIG_RBD
+			  { .ival = "rbd",
+			    .help = "Rados Block Device asynchronous IO"
+			  },
+#endif
 			  { .ival = "mmap",
 			    .help = "Memory mapped IO"
 			  },
diff --git a/options.h b/options.h
index fc36368..3dc48a9 100644
--- a/options.h
+++ b/options.h
@@ -95,6 +95,7 @@ enum opt_category_group {
 	__FIO_OPT_G_LIBAIO,
 	__FIO_OPT_G_ACT,
 	__FIO_OPT_G_LATPROF,
+        __FIO_OPT_G_RBD,
 	__FIO_OPT_G_NR,
 
 	FIO_OPT_G_RATE		= (1U << __FIO_OPT_G_RATE),
@@ -124,6 +125,7 @@ enum opt_category_group {
 	FIO_OPT_G_LIBAIO	= (1U << __FIO_OPT_G_LIBAIO),
 	FIO_OPT_G_ACT		= (1U << __FIO_OPT_G_ACT),
 	FIO_OPT_G_LATPROF	= (1U << __FIO_OPT_G_LATPROF),
+	FIO_OPT_G_RBD		= (1U << __FIO_OPT_G_RBD),
 	FIO_OPT_G_INVALID	= (1U << __FIO_OPT_G_NR),
 };
 
