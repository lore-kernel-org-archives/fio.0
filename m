Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51196 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030859AbeBONAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Feb 2018 08:00:10 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1emJ8y-0000jO-3Z
        for fio@vger.kernel.org; Thu, 15 Feb 2018 13:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180215130001.E10B02C00CF@kernel.dk>
Date: Thu, 15 Feb 2018 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f2cd91604af170e972438c461a40230e266a57d9:

  debug: fix inverted logic in fio_did_warn() (2018-02-12 10:55:07 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 488468793d72297f7dccd42a7b50011e74de0688:

  Merge branch 'wip-ifed-rados' of https://github.com/ifed01/fio (2018-02-14 12:43:04 -0700)

----------------------------------------------------------------
Igor Fedotov (1):
      Add support for Ceph Rados benchmarking.

Jens Axboe (1):
      Merge branch 'wip-ifed-rados' of https://github.com/ifed01/fio

 Makefile           |   3 +
 configure          |  34 ++++
 engines/rados.c    | 479 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 examples/rados.fio |  24 +++
 fio.1              |  17 +-
 5 files changed, 553 insertions(+), 4 deletions(-)
 create mode 100644 engines/rados.c
 create mode 100644 examples/rados.fio

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 3ce6064..c25b422 100644
--- a/Makefile
+++ b/Makefile
@@ -95,6 +95,9 @@ endif
 ifdef CONFIG_WINDOWSAIO
   SOURCE += engines/windowsaio.c
 endif
+ifdef CONFIG_RADOS
+  SOURCE += engines/rados.c
+endif
 ifdef CONFIG_RBD
   SOURCE += engines/rbd.c
 endif
diff --git a/configure b/configure
index d92bb0f..5d283d7 100755
--- a/configure
+++ b/configure
@@ -173,6 +173,8 @@ for opt do
   ;;
   --disable-rdma) disable_rdma="yes"
   ;;
+  --disable-rados) disable_rados="yes"
+  ;;
   --disable-rbd) disable_rbd="yes"
   ;;
   --disable-rbd-blkin) disable_rbd_blkin="yes"
@@ -1527,6 +1529,35 @@ fi
 print_config "IPv6 helpers" "$ipv6"
 
 ##########################################
+# check for rados
+if test "$rados" != "yes" ; then
+  rados="no"
+fi
+cat > $TMPC << EOF
+#include <rados/librados.h>
+
+int main(int argc, char **argv)
+{
+  rados_t cluster;
+  rados_ioctx_t io_ctx;
+  const char cluster_name[] = "ceph";
+  const char user_name[] = "client.admin";
+  const char pool[] = "rados";
+
+  /* The rados_create2 signature required was only introduced in ceph 0.65 */
+  rados_create2(&cluster, cluster_name, user_name, 0);
+  rados_ioctx_create(cluster, pool, &io_ctx);
+
+  return 0;
+}
+EOF
+if test "$disable_rados" != "yes"  && compile_prog "" "-lrados" "rados"; then
+  LIBS="-lrados $LIBS"
+  rados="yes"
+fi
+print_config "Rados engine" "$rados"
+
+##########################################
 # check for rbd
 if test "$rbd" != "yes" ; then
   rbd="no"
@@ -2262,6 +2293,9 @@ fi
 if test "$ipv6" = "yes" ; then
   output_sym "CONFIG_IPV6"
 fi
+if test "$rados" = "yes" ; then
+  output_sym "CONFIG_RADOS"
+fi
 if test "$rbd" = "yes" ; then
   output_sym "CONFIG_RBD"
 fi
diff --git a/engines/rados.c b/engines/rados.c
new file mode 100644
index 0000000..dc0d7b1
--- /dev/null
+++ b/engines/rados.c
@@ -0,0 +1,479 @@
+/*
+ *  Ceph Rados engine
+ *
+ * IO engine using Ceph's RADOS interface to test low-level performance of
+ * Ceph OSDs.
+ *
+ */
+
+#include <rados/librados.h>
+#include <pthread.h>
+#include "fio.h"
+#include "../optgroup.h"
+
+struct fio_rados_iou {
+	struct thread_data *td;
+	struct io_u *io_u;
+	rados_completion_t completion;
+	rados_write_op_t write_op;
+};
+
+struct rados_data {
+	rados_t cluster;
+	rados_ioctx_t io_ctx;
+	char **objects;
+	size_t object_count;
+	struct io_u **aio_events;
+	bool connected;
+};
+
+/* fio configuration options read from the job file */
+struct rados_options {
+	void *pad;
+	char *cluster_name;
+	char *pool_name;
+	char *client_name;
+	int busy_poll;
+};
+
+static struct fio_option options[] = {
+	{
+		.name     = "clustername",
+		.lname    = "ceph cluster name",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "Cluster name for ceph",
+		.off1     = offsetof(struct rados_options, cluster_name),
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_RBD,
+	},
+	{
+		.name     = "pool",
+		.lname    = "pool name to use",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "Ceph pool name to benchmark against",
+		.off1     = offsetof(struct rados_options, pool_name),
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_RBD,
+	},
+	{
+		.name     = "clientname",
+		.lname    = "rados engine clientname",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "Name of the ceph client to access RADOS engine",
+		.off1     = offsetof(struct rados_options, client_name),
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_RBD,
+	},
+	{
+		.name     = "busy_poll",
+		.lname    = "busy poll mode",
+		.type     = FIO_OPT_BOOL,
+		.help     = "Busy poll for completions instead of sleeping",
+		.off1     = offsetof(struct rados_options, busy_poll),
+		.def	  = "0",
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_RBD,
+	},
+	{
+		.name     = NULL,
+	},
+};
+
+static int _fio_setup_rados_data(struct thread_data *td,
+				struct rados_data **rados_data_ptr)
+{
+	struct rados_data *rados;
+
+	if (td->io_ops_data)
+		return 0;
+
+	rados = calloc(1, sizeof(struct rados_data));
+	if (!rados)
+		goto failed;
+
+	rados->connected = false;
+
+	rados->aio_events = calloc(td->o.iodepth, sizeof(struct io_u *));
+	if (!rados->aio_events)
+		goto failed;
+
+	rados->object_count = td->o.nr_files;
+	rados->objects = calloc(rados->object_count, sizeof(char*));
+	if (!rados->objects)
+		goto failed;
+
+	*rados_data_ptr = rados;
+	return 0;
+
+failed:
+	if (rados) {
+		rados->object_count = 0;
+		if (rados->aio_events)
+			free(rados->aio_events);
+		free(rados);
+	}
+	return 1;
+}
+
+static void _fio_rados_rm_objects(struct rados_data *rados)
+{
+	size_t i;
+	for (i = 0; i < rados->object_count; ++i) {
+		if (rados->objects[i]) {
+			rados_remove(rados->io_ctx, rados->objects[i]);
+			free(rados->objects[i]);
+			rados->objects[i] = NULL;
+		}
+	}
+}
+
+static int _fio_rados_connect(struct thread_data *td)
+{
+	struct rados_data *rados = td->io_ops_data;
+	struct rados_options *o = td->eo;
+	int r;
+	const uint64_t file_size =
+		td->o.size / (td->o.nr_files ? td->o.nr_files : 1u);
+	struct fio_file *f;
+	uint32_t i;
+	size_t oname_len = 0;
+
+	if (o->cluster_name) {
+		char *client_name = NULL;
+
+		/*
+		* If we specify cluser name, the rados_create2
+		* will not assume 'client.'. name is considered
+		* as a full type.id namestr
+		*/
+		if (o->client_name) {
+			if (!index(o->client_name, '.')) {
+				client_name = calloc(1, strlen("client.") +
+					strlen(o->client_name) + 1);
+				strcat(client_name, "client.");
+				strcat(client_name, o->client_name);
+			} else {
+				client_name = o->client_name;
+			}
+		}
+
+		r = rados_create2(&rados->cluster, o->cluster_name,
+			client_name, 0);
+
+		if (client_name && !index(o->client_name, '.'))
+			free(client_name);
+	} else
+		r = rados_create(&rados->cluster, o->client_name);
+
+	if (r < 0) {
+		log_err("rados_create failed.\n");
+		goto failed_early;
+	}
+
+	r = rados_conf_read_file(rados->cluster, NULL);
+	if (r < 0) {
+		log_err("rados_conf_read_file failed.\n");
+		goto failed_early;
+	}
+
+	r = rados_connect(rados->cluster);
+	if (r < 0) {
+		log_err("rados_connect failed.\n");
+		goto failed_early;
+	}
+
+	r = rados_ioctx_create(rados->cluster, o->pool_name, &rados->io_ctx);
+	if (r < 0) {
+		log_err("rados_ioctx_create failed.\n");
+		goto failed_shutdown;
+	}
+
+	for (i = 0; i < rados->object_count; i++) {
+		f = td->files[i];
+		f->real_file_size = file_size;
+		f->engine_pos = i;
+
+		oname_len = strlen(f->file_name) + 32;
+		rados->objects[i] = malloc(oname_len);
+		/* vary objects for different jobs */
+		snprintf(rados->objects[i], oname_len - 1,
+			"fio_rados_bench.%s.%x",
+			f->file_name, td->thread_number);
+		r = rados_write(rados->io_ctx, rados->objects[i], "", 0, 0);
+		if (r < 0) {
+			free(rados->objects[i]);
+			rados->objects[i] = NULL;
+			log_err("error creating object.\n");
+			goto failed_obj_create;
+		}
+	}
+
+  return 0;
+
+failed_obj_create:
+	_fio_rados_rm_objects(rados);
+	rados_ioctx_destroy(rados->io_ctx);
+	rados->io_ctx = NULL;
+failed_shutdown:
+	rados_shutdown(rados->cluster);
+	rados->cluster = NULL;
+failed_early:
+	return 1;
+}
+
+static void _fio_rados_disconnect(struct rados_data *rados)
+{
+	if (!rados)
+		return;
+
+	_fio_rados_rm_objects(rados);
+
+	if (rados->io_ctx) {
+		rados_ioctx_destroy(rados->io_ctx);
+		rados->io_ctx = NULL;
+	}
+
+	if (rados->cluster) {
+		rados_shutdown(rados->cluster);
+		rados->cluster = NULL;
+	}
+}
+
+static void fio_rados_cleanup(struct thread_data *td)
+{
+	struct rados_data *rados = td->io_ops_data;
+
+	if (rados) {
+		_fio_rados_disconnect(rados);
+		free(rados->objects);
+		free(rados->aio_events);
+		free(rados);
+	}
+}
+
+static int fio_rados_queue(struct thread_data *td, struct io_u *io_u)
+{
+	struct rados_data *rados = td->io_ops_data;
+	struct fio_rados_iou *fri = io_u->engine_data;
+	char *object = rados->objects[io_u->file->engine_pos];
+	int r = -1;
+
+	fio_ro_check(td, io_u);
+
+	if (io_u->ddir == DDIR_WRITE) {
+		 r = rados_aio_create_completion(fri, NULL,
+			NULL, &fri->completion);
+		if (r < 0) {
+			log_err("rados_aio_create_completion failed.\n");
+			goto failed;
+		}
+
+		r = rados_aio_write(rados->io_ctx, object, fri->completion,
+			io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		if (r < 0) {
+			log_err("rados_write failed.\n");
+			goto failed_comp;
+		}
+		return FIO_Q_QUEUED;
+	} else if (io_u->ddir == DDIR_READ) {
+		r = rados_aio_create_completion(fri, NULL,
+			NULL, &fri->completion);
+		if (r < 0) {
+			log_err("rados_aio_create_completion failed.\n");
+			goto failed;
+		}
+		r = rados_aio_read(rados->io_ctx, object, fri->completion,
+			io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		if (r < 0) {
+			log_err("rados_aio_read failed.\n");
+			goto failed_comp;
+		}
+		return FIO_Q_QUEUED;
+	} else if (io_u->ddir == DDIR_TRIM) {
+		r = rados_aio_create_completion(fri, NULL,
+			NULL , &fri->completion);
+		if (r < 0) {
+			log_err("rados_aio_create_completion failed.\n");
+			goto failed;
+		}
+		fri->write_op = rados_create_write_op();
+		if (fri->write_op == NULL) {
+			log_err("rados_create_write_op failed.\n");
+			goto failed_comp;
+		}
+		rados_write_op_zero(fri->write_op, io_u->offset,
+			io_u->xfer_buflen);
+		r = rados_aio_write_op_operate(fri->write_op, rados->io_ctx,
+			fri->completion, object, NULL, 0);
+		if (r < 0) {
+			log_err("rados_aio_write_op_operate failed.\n");
+			goto failed_write_op;
+		}
+		return FIO_Q_QUEUED;
+	 }
+
+	log_err("WARNING: Only DDIR_READ, DDIR_WRITE and DDIR_TRIM are supported!");
+
+failed_write_op:
+	rados_release_write_op(fri->write_op);
+failed_comp:
+	rados_aio_release(fri->completion);
+failed:
+	io_u->error = -r;
+	td_verror(td, io_u->error, "xfer");
+	return FIO_Q_COMPLETED;
+}
+
+static struct io_u *fio_rados_event(struct thread_data *td, int event)
+{
+	struct rados_data *rados = td->io_ops_data;
+	return rados->aio_events[event];
+}
+
+int fio_rados_getevents(struct thread_data *td, unsigned int min,
+	unsigned int max, const struct timespec *t)
+{
+	struct rados_data *rados = td->io_ops_data;
+	struct rados_options *o = td->eo;
+	int busy_poll = o->busy_poll;
+	unsigned int events = 0;
+	struct io_u *u;
+	struct fio_rados_iou *fri;
+	unsigned int i;
+	rados_completion_t first_unfinished;
+	int observed_new = 0;
+
+	/* loop through inflight ios until we find 'min' completions */
+	do {
+		first_unfinished = NULL;
+		io_u_qiter(&td->io_u_all, u, i) {
+			if (!(u->flags & IO_U_F_FLIGHT))
+				continue;
+
+			fri = u->engine_data;
+			if (fri->completion) {
+				if (rados_aio_is_complete(fri->completion)) {
+					if (fri->write_op != NULL) {
+						rados_release_write_op(fri->write_op);
+						fri->write_op = NULL;
+					}
+					rados_aio_release(fri->completion);
+					fri->completion = NULL;
+					rados->aio_events[events] = u;
+					events++;
+					observed_new = 1;
+				} else if (first_unfinished == NULL) {
+					first_unfinished = fri->completion;
+				}
+			}
+			if (events >= max)
+				break;
+		}
+		if (events >= min)
+			return events;
+		if (first_unfinished == NULL || busy_poll)
+			continue;
+
+		if (!observed_new)
+			rados_aio_wait_for_complete(first_unfinished);
+	} while (1);
+  return events;
+}
+
+static int fio_rados_setup(struct thread_data *td)
+{
+	struct rados_data *rados = NULL;
+	int r;
+	/* allocate engine specific structure to deal with librados. */
+	r = _fio_setup_rados_data(td, &rados);
+	if (r) {
+		log_err("fio_setup_rados_data failed.\n");
+		goto cleanup;
+	}
+	td->io_ops_data = rados;
+
+	/* Force single process mode.
+	*/
+	td->o.use_thread = 1;
+
+	/* connect in the main thread to determine to determine
+	* the size of the given RADOS block device. And disconnect
+	* later on.
+	*/
+	r = _fio_rados_connect(td);
+	if (r) {
+		log_err("fio_rados_connect failed.\n");
+		goto cleanup;
+	}
+	rados->connected = true;
+
+	return 0;
+cleanup:
+	fio_rados_cleanup(td);
+	return r;
+}
+
+/* open/invalidate are noops. we set the FIO_DISKLESSIO flag in ioengine_ops to
+   prevent fio from creating the files
+*/
+static int fio_rados_open(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+static int fio_rados_invalidate(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+
+static void fio_rados_io_u_free(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_rados_iou *fri = io_u->engine_data;
+
+	if (fri) {
+		io_u->engine_data = NULL;
+		fri->td = NULL;
+		if (fri->completion)
+			rados_aio_release(fri->completion);
+		if (fri->write_op)
+			rados_release_write_op(fri->write_op);
+		free(fri);
+	}
+}
+
+static int fio_rados_io_u_init(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_rados_iou *fri;
+	fri = calloc(1, sizeof(*fri));
+	fri->io_u = io_u;
+	fri->td = td;
+	io_u->engine_data = fri;
+	return 0;
+}
+
+/* ioengine_ops for get_ioengine() */
+static struct ioengine_ops ioengine = {
+	.name = "rados",
+	.version		= FIO_IOOPS_VERSION,
+	.flags			= FIO_DISKLESSIO,
+	.setup			= fio_rados_setup,
+	.queue			= fio_rados_queue,
+	.getevents		= fio_rados_getevents,
+	.event			= fio_rados_event,
+	.cleanup		= fio_rados_cleanup,
+	.open_file		= fio_rados_open,
+	.invalidate		= fio_rados_invalidate,
+	.options		= options,
+	.io_u_init		= fio_rados_io_u_init,
+	.io_u_free		= fio_rados_io_u_free,
+	.option_struct_size	= sizeof(struct rados_options),
+};
+
+static void fio_init fio_rados_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_rados_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/rados.fio b/examples/rados.fio
new file mode 100644
index 0000000..035cbff
--- /dev/null
+++ b/examples/rados.fio
@@ -0,0 +1,24 @@
+######################################################################
+# Example test for the RADOS engine.
+#
+# Runs a 4k random write test against a RADOS via librados
+#
+# NOTE: Make sure you have either Ceph pool named 'rados' or change
+#       the pool parameter.
+######################################################################
+[global]
+#logging
+#write_iops_log=write_iops_log
+#write_bw_log=write_bw_log
+#write_lat_log=write_lat_log
+ioengine=rados
+clientname=admin
+pool=rados
+busy_poll=0
+rw=randwrite
+bs=4k
+
+[rbd_iodepth32]
+iodepth=32
+size=128m
+nr_files=32
diff --git a/fio.1 b/fio.1
index 91ae4a2..e488b01 100644
--- a/fio.1
+++ b/fio.1
@@ -1585,6 +1585,11 @@ size to the current block offset. \fBblocksize\fR is ignored.
 I/O engine that does regular EXT4_IOC_MOVE_EXT ioctls to simulate
 defragment activity in request to DDIR_WRITE event.
 .TP
+.B rados
+I/O engine supporting direct access to Ceph Reliable Autonomic Distributed
+Object Store (RADOS) via librados. This ioengine defines engine specific
+options.
+.TP
 .B rbd
 I/O engine supporting direct access to Ceph Rados Block Devices
 (RBD) via librbd without the need to use the kernel rbd driver. This
@@ -1773,21 +1778,25 @@ after event.
 .RE
 .RE
 .TP
-.BI (rbd)clustername \fR=\fPstr
+.BI (rbd,rados)clustername \fR=\fPstr
 Specifies the name of the Ceph cluster.
 .TP
 .BI (rbd)rbdname \fR=\fPstr
 Specifies the name of the RBD.
 .TP
-.BI (rbd)pool \fR=\fPstr
-Specifies the name of the Ceph pool containing RBD.
+.BI (rbd,rados)pool \fR=\fPstr
+Specifies the name of the Ceph pool containing RBD or RADOS data.
 .TP
-.BI (rbd)clientname \fR=\fPstr
+.BI (rbd,rados)clientname \fR=\fPstr
 Specifies the username (without the 'client.' prefix) used to access the
 Ceph cluster. If the \fBclustername\fR is specified, the \fBclientname\fR shall be
 the full *type.id* string. If no type. prefix is given, fio will add 'client.'
 by default.
 .TP
+.BI (rbd,rados)busy_poll \fR=\fPbool
+Poll store instead of waiting for completion. Usually this provides better
+throughput at cost of higher(up to 100%) CPU utilization.
+.TP
 .BI (mtd)skip_bad \fR=\fPbool
 Skip operations against known bad blocks.
 .TP
