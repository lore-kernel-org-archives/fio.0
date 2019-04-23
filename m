Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52764 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfDWMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 23 Apr 2019 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hIu5j-0005T2-TR
        for fio@vger.kernel.org; Tue, 23 Apr 2019 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190423120001.C79E22C0104@kernel.dk>
Date: Tue, 23 Apr 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7f125e7f3879d23e79bc2ef5eed678ddab3b5c70:

  zbd: Fix zone report handling (2019-04-19 09:11:34 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to afc22c98609ee80a99fbed24231181bdab2bc659:

  Merge branch 'libiscsi' of https://github.com/smartxworks/fio (2019-04-22 08:38:55 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'libiscsi' of https://github.com/smartxworks/fio

Kyle Zhang (2):
      filesetup: don't call create_work_dirs() for ioengine with FIO_DISKLESSIO
      fio: add libiscsi engine

 HOWTO                 |   2 +
 Makefile              |   6 +
 configure             |  28 +++-
 engines/libiscsi.c    | 407 ++++++++++++++++++++++++++++++++++++++++++++++++++
 examples/libiscsi.fio |   3 +
 filesetup.c           |  85 ++++++-----
 fio.1                 |   3 +
 optgroup.h            |   2 +
 8 files changed, 494 insertions(+), 42 deletions(-)
 create mode 100644 engines/libiscsi.c
 create mode 100644 examples/libiscsi.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 468772d7..4fd4da14 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1991,6 +1991,8 @@ I/O engine
 			Asynchronous read and write using DDN's Infinite Memory Engine (IME).
 			This engine will try to stack as much IOs as possible by creating
 			requests for IME. FIO will then decide when to commit these requests.
+		**libiscsi**
+			Read and write iscsi lun with libiscsi.
 
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/Makefile b/Makefile
index fd138dd2..d7e5fca7 100644
--- a/Makefile
+++ b/Makefile
@@ -59,6 +59,12 @@ ifdef CONFIG_LIBHDFS
   SOURCE += engines/libhdfs.c
 endif
 
+ifdef CONFIG_LIBISCSI
+  CFLAGS += $(LIBISCSI_CFLAGS)
+  LIBS += $(LIBISCSI_LIBS)
+  SOURCE += engines/libiscsi.c
+endif
+
 ifdef CONFIG_64BIT
   CFLAGS += -DBITS_PER_LONG=64
 endif
diff --git a/configure b/configure
index 3c882f0f..c7a7c0ae 100755
--- a/configure
+++ b/configure
@@ -148,6 +148,7 @@ disable_lex=""
 disable_pmem="no"
 disable_native="no"
 march_set="no"
+libiscsi="no"
 prefix=/usr/local
 
 # parse options
@@ -204,6 +205,8 @@ for opt do
   ;;
   --with-ime=*) ime_path="$optarg"
   ;;
+  --enable-libiscsi) libiscsi="yes"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -239,6 +242,7 @@ if test "$show_help" = "yes" ; then
   echo "--enable-cuda           Enable GPUDirect RDMA support"
   echo "--disable-native        Don't build for native host"
   echo "--with-ime=             Install path for DDN's Infinite Memory Engine"
+  echo "--enable-libiscsi       Enable iscsi support"
   exit $exit_val
 fi
 
@@ -1970,6 +1974,22 @@ if compile_prog "-I${ime_path}/include" "-L${ime_path}/lib -lim_client" "libime"
 fi
 print_config "DDN's Infinite Memory Engine" "$libime"
 
+##########################################
+# Check if we have required environment variables configured for libiscsi
+if test "$libiscsi" = "yes" ; then
+  if $(pkg-config --atleast-version=1.9.0 libiscsi); then
+    libiscsi="yes"
+    libiscsi_cflags=$(pkg-config --cflags libiscsi)
+    libiscsi_libs=$(pkg-config --libs libiscsi)
+  else
+    if test "$libiscsi" = "yes" ; then
+      echo "libiscsi" "Install libiscsi >= 1.9.0"
+    fi
+    libiscsi="no"
+  fi
+fi
+print_config "iscsi engine" "$libiscsi"
+
 ##########################################
 # Check if we have lex/yacc available
 yacc="no"
@@ -2543,7 +2563,7 @@ if test "$libhdfs" = "yes" ; then
   echo "JAVA_HOME=$JAVA_HOME" >> $config_host_mak
   echo "FIO_LIBHDFS_INCLUDE=$FIO_LIBHDFS_INCLUDE" >> $config_host_mak
   echo "FIO_LIBHDFS_LIB=$FIO_LIBHDFS_LIB" >> $config_host_mak
- fi
+fi
 if test "$mtd" = "yes" ; then
   output_sym "CONFIG_MTD"
 fi
@@ -2627,6 +2647,12 @@ fi
 if test "$thp" = "yes" ; then
   output_sym "CONFIG_HAVE_THP"
 fi
+if test "$libiscsi" = "yes" ; then
+  output_sym "CONFIG_LIBISCSI"
+  echo "CONFIG_LIBISCSI=m" >> $config_host_mak
+  echo "LIBISCSI_CFLAGS=$libiscsi_cflags" >> $config_host_mak
+  echo "LIBISCSI_LIBS=$libiscsi_libs" >> $config_host_mak
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "GFIO_LIBS+=$GFIO_LIBS" >> $config_host_mak
diff --git a/engines/libiscsi.c b/engines/libiscsi.c
new file mode 100644
index 00000000..e4eb0bab
--- /dev/null
+++ b/engines/libiscsi.c
@@ -0,0 +1,407 @@
+/*
+ * libiscsi engine
+ *
+ * this engine read/write iscsi lun with libiscsi.
+ */
+
+
+#include "../fio.h"
+#include "../optgroup.h"
+
+#include <stdlib.h>
+#include <iscsi/iscsi.h>
+#include <iscsi/scsi-lowlevel.h>
+#include <poll.h>
+
+struct iscsi_lun;
+struct iscsi_info;
+
+struct iscsi_task {
+	struct scsi_task	*scsi_task;
+	struct iscsi_lun	*iscsi_lun;
+	struct io_u		*io_u;
+};
+
+struct iscsi_lun {
+	struct iscsi_info	*iscsi_info;
+	struct iscsi_context	*iscsi;
+	struct iscsi_url        *url;
+	int			 block_size;
+	uint64_t		 num_blocks;
+};
+
+struct iscsi_info {
+	struct iscsi_lun	**luns;
+	int			  nr_luns;
+	struct pollfd		 *pfds;
+	struct iscsi_task	**complete_events;
+	int			  nr_events;
+};
+
+struct iscsi_options {
+	void	*pad;
+	char	*initiator;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	  = "initiator",
+		.lname	  = "initiator",
+		.type	  = FIO_OPT_STR_STORE,
+		.off1	  = offsetof(struct iscsi_options, initiator),
+		.def	  = "iqn.2019-04.org.fio:fio",
+		.help	  = "initiator name",
+		.category = FIO_OPT_C_ENGINE,
+		.group	  = FIO_OPT_G_ISCSI,
+	},
+
+	{
+		.name = NULL,
+	},
+};
+
+static int fio_iscsi_setup_lun(struct iscsi_info *iscsi_info,
+			       char *initiator, struct fio_file *f, int i)
+{
+	struct iscsi_lun		*iscsi_lun  = NULL;
+	struct scsi_task		*task	    = NULL;
+	struct scsi_readcapacity16	*rc16	    = NULL;
+	int				 ret	    = 0;
+
+	iscsi_lun = malloc(sizeof(struct iscsi_lun));
+	memset(iscsi_lun, 0, sizeof(struct iscsi_lun));
+
+	iscsi_lun->iscsi_info = iscsi_info;
+
+	iscsi_lun->url = iscsi_parse_full_url(NULL, f->file_name);
+	if (iscsi_lun->url == NULL) {
+		log_err("iscsi: failed to parse url: %s\n", f->file_name);
+		ret = EINVAL;
+		goto out;
+	}
+
+	iscsi_lun->iscsi = iscsi_create_context(initiator);
+	if (iscsi_lun->iscsi == NULL) {
+		log_err("iscsi: failed to create iscsi context.\n");
+		ret = 1;
+		goto out;
+	}
+
+	if (iscsi_set_targetname(iscsi_lun->iscsi, iscsi_lun->url->target)) {
+		log_err("iscsi: failed to set target name.\n");
+		ret = EINVAL;
+		goto out;
+	}
+
+	if (iscsi_set_session_type(iscsi_lun->iscsi, ISCSI_SESSION_NORMAL) != 0) {
+		log_err("iscsi: failed to set session type.\n");
+		ret = EINVAL;
+		goto out;
+	}
+
+	if (iscsi_set_header_digest(iscsi_lun->iscsi,
+				    ISCSI_HEADER_DIGEST_NONE_CRC32C) != 0) {
+		log_err("iscsi: failed to set header digest.\n");
+		ret = EINVAL;
+		goto out;
+	}
+
+	if (iscsi_full_connect_sync(iscsi_lun->iscsi,
+				    iscsi_lun->url->portal,
+				    iscsi_lun->url->lun)) {
+		log_err("sicsi: failed to connect to LUN : %s\n",
+			iscsi_get_error(iscsi_lun->iscsi));
+		ret = EINVAL;
+		goto out;
+	}
+
+	task = iscsi_readcapacity16_sync(iscsi_lun->iscsi, iscsi_lun->url->lun);
+	if (task == NULL || task->status != SCSI_STATUS_GOOD) {
+		log_err("iscsi: failed to send readcapacity command\n");
+		ret = EINVAL;
+		goto out;
+	}
+
+	rc16 = scsi_datain_unmarshall(task);
+	if (rc16 == NULL) {
+		log_err("iscsi: failed to unmarshal readcapacity16 data.\n");
+		ret = EINVAL;
+		goto out;
+	}
+
+	iscsi_lun->block_size = rc16->block_length;
+	iscsi_lun->num_blocks = rc16->returned_lba + 1;
+
+	scsi_free_scsi_task(task);
+	task = NULL;
+
+	f->real_file_size = iscsi_lun->num_blocks * iscsi_lun->block_size;
+	f->engine_data	  = iscsi_lun;
+
+	iscsi_info->luns[i]    = iscsi_lun;
+	iscsi_info->pfds[i].fd = iscsi_get_fd(iscsi_lun->iscsi);
+
+out:
+	if (task) {
+		scsi_free_scsi_task(task);
+	}
+
+	if (ret && iscsi_lun) {
+		if (iscsi_lun->iscsi != NULL) {
+			if (iscsi_is_logged_in(iscsi_lun->iscsi)) {
+				iscsi_logout_sync(iscsi_lun->iscsi);
+			}
+			iscsi_destroy_context(iscsi_lun->iscsi);
+		}
+		free(iscsi_lun);
+	}
+
+	return ret;
+}
+
+static int fio_iscsi_setup(struct thread_data *td)
+{
+	struct iscsi_options	*options    = td->eo;
+	struct iscsi_info	*iscsi_info = NULL;
+	int			 ret	    = 0;
+	struct fio_file		*f;
+	int			 i;
+
+	iscsi_info	    = malloc(sizeof(struct iscsi_info));
+	iscsi_info->nr_luns = td->o.nr_files;
+	iscsi_info->luns    = calloc(iscsi_info->nr_luns, sizeof(struct iscsi_lun*));
+	iscsi_info->pfds    = calloc(iscsi_info->nr_luns, sizeof(struct pollfd));
+
+	iscsi_info->nr_events	    = 0;
+	iscsi_info->complete_events = calloc(td->o.iodepth, sizeof(struct iscsi_task*));
+
+	td->io_ops_data = iscsi_info;
+
+	for_each_file(td, f, i) {
+		ret = fio_iscsi_setup_lun(iscsi_info, options->initiator, f, i);
+		if (ret < 0) break;
+	}
+
+	return ret;
+}
+
+static int fio_iscsi_init(struct thread_data *td) {
+	return 0;
+}
+
+static void fio_iscsi_cleanup_lun(struct iscsi_lun *iscsi_lun) {
+	if (iscsi_lun->iscsi != NULL) {
+		if (iscsi_is_logged_in(iscsi_lun->iscsi)) {
+			iscsi_logout_sync(iscsi_lun->iscsi);
+		}
+		iscsi_destroy_context(iscsi_lun->iscsi);
+	}
+	free(iscsi_lun);
+}
+
+static void fio_iscsi_cleanup(struct thread_data *td)
+{
+	struct iscsi_info *iscsi_info = td->io_ops_data;
+
+	for (int i = 0; i < iscsi_info->nr_luns; i++) {
+		if (iscsi_info->luns[i]) {
+			fio_iscsi_cleanup_lun(iscsi_info->luns[i]);
+			iscsi_info->luns[i] = NULL;
+		}
+	}
+
+	free(iscsi_info->luns);
+	free(iscsi_info->pfds);
+	free(iscsi_info->complete_events);
+	free(iscsi_info);
+}
+
+static int fio_iscsi_prep(struct thread_data *td, struct io_u *io_u)
+{
+	return 0;
+}
+
+static int fio_iscsi_open_file(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+
+static int fio_iscsi_close_file(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+
+static void iscsi_cb(struct iscsi_context *iscsi, int status,
+		     void *command_data, void *private_data)
+{
+	struct iscsi_task	*iscsi_task = (struct iscsi_task*)private_data;
+	struct iscsi_lun	*iscsi_lun  = iscsi_task->iscsi_lun;
+	struct iscsi_info       *iscsi_info = iscsi_lun->iscsi_info;
+	struct io_u             *io_u	    = iscsi_task->io_u;
+
+	if (status == SCSI_STATUS_GOOD) {
+		io_u->error = 0;
+	} else {
+		log_err("iscsi: request failed with error %s.\n",
+			iscsi_get_error(iscsi_lun->iscsi));
+
+		io_u->error = 1;
+		io_u->resid = io_u->xfer_buflen;
+	}
+
+	iscsi_info->complete_events[iscsi_info->nr_events] = iscsi_task;
+	iscsi_info->nr_events++;
+}
+
+static enum fio_q_status fio_iscsi_queue(struct thread_data *td,
+					 struct io_u *io_u)
+{
+	struct iscsi_lun	*iscsi_lun  = io_u->file->engine_data;
+	struct scsi_task	*scsi_task  = NULL;
+	struct iscsi_task	*iscsi_task = malloc(sizeof(struct iscsi_task));
+	int			 ret	    = -1;
+
+	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
+		if (io_u->offset % iscsi_lun->block_size != 0) {
+			log_err("iscsi: offset is not align to block size.\n");
+			ret = -1;
+			goto out;
+		}
+
+		if (io_u->xfer_buflen % iscsi_lun->block_size != 0) {
+			log_err("iscsi: buflen is not align to block size.\n");
+			ret = -1;
+			goto out;
+		}
+	}
+
+	if (io_u->ddir == DDIR_READ) {
+		scsi_task = scsi_cdb_read16(io_u->offset / iscsi_lun->block_size,
+					    io_u->xfer_buflen,
+					    iscsi_lun->block_size,
+					    0, 0, 0, 0, 0);
+		ret = scsi_task_add_data_in_buffer(scsi_task, io_u->xfer_buflen,
+						   io_u->xfer_buf);
+		if (ret < 0) {
+			log_err("iscsi: failed to add data in buffer.\n");
+			goto out;
+		}
+	} else if (io_u->ddir == DDIR_WRITE) {
+		scsi_task = scsi_cdb_write16(io_u->offset / iscsi_lun->block_size,
+					     io_u->xfer_buflen,
+					     iscsi_lun->block_size,
+					     0, 0, 0, 0, 0);
+		ret = scsi_task_add_data_out_buffer(scsi_task, io_u->xfer_buflen,
+						    io_u->xfer_buf);
+		if (ret < 0) {
+			log_err("iscsi: failed to add data out buffer.\n");
+			goto out;
+		}
+	} else if (ddir_sync(io_u->ddir)) {
+		scsi_task = scsi_cdb_synchronizecache16(
+			0, iscsi_lun->num_blocks * iscsi_lun->block_size, 0, 0);
+	} else {
+		log_err("iscsi: invalid I/O operation: %d\n", io_u->ddir);
+		ret = EINVAL;
+		goto out;
+	}
+
+	iscsi_task->scsi_task = scsi_task;
+	iscsi_task->iscsi_lun = iscsi_lun;
+	iscsi_task->io_u      = io_u;
+
+	ret = iscsi_scsi_command_async(iscsi_lun->iscsi, iscsi_lun->url->lun,
+				       scsi_task, iscsi_cb, NULL, iscsi_task);
+	if (ret < 0) {
+		log_err("iscsi: failed to send scsi command.\n");
+		goto out;
+	}
+
+	return FIO_Q_QUEUED;
+
+out:
+	if (iscsi_task) {
+		free(iscsi_task);
+	}
+
+	if (scsi_task) {
+		scsi_free_scsi_task(scsi_task);
+	}
+
+	if (ret) {
+		io_u->error = ret;
+	}
+	return FIO_Q_COMPLETED;
+}
+
+static int fio_iscsi_getevents(struct thread_data *td, unsigned int min,
+			       unsigned int max, const struct timespec *t)
+{
+	struct iscsi_info	*iscsi_info = td->io_ops_data;
+	int			 ret	    = 0;
+
+	iscsi_info->nr_events = 0;
+
+	while (iscsi_info->nr_events < min) {
+		for (int i = 0; i < iscsi_info->nr_luns; i++) {
+			int events = iscsi_which_events(iscsi_info->luns[i]->iscsi);
+			iscsi_info->pfds[i].events = events;
+		}
+
+		ret = poll(iscsi_info->pfds, iscsi_info->nr_luns, -1);
+		if (ret < 0) {
+			log_err("iscsi: failed to poll events: %s.\n",
+				strerror(errno));
+			break;
+		}
+
+		for (int i = 0; i < iscsi_info->nr_luns; i++) {
+			ret = iscsi_service(iscsi_info->luns[i]->iscsi,
+					    iscsi_info->pfds[i].revents);
+			assert(ret >= 0);
+		}
+	}
+
+	return ret < 0 ? ret : iscsi_info->nr_events;
+}
+
+static struct io_u *fio_iscsi_event(struct thread_data *td, int event)
+{
+	struct iscsi_info	*iscsi_info = (struct iscsi_info*)td->io_ops_data;
+	struct iscsi_task	*iscsi_task = iscsi_info->complete_events[event];
+	struct io_u		*io_u	    = iscsi_task->io_u;
+
+	iscsi_info->complete_events[event] = NULL;
+
+	scsi_free_scsi_task(iscsi_task->scsi_task);
+	free(iscsi_task);
+
+	return io_u;
+}
+
+static struct ioengine_ops ioengine_iscsi = {
+	.name               = "libiscsi",
+	.version            = FIO_IOOPS_VERSION,
+	.flags              = FIO_SYNCIO | FIO_DISKLESSIO | FIO_NODISKUTIL,
+	.setup              = fio_iscsi_setup,
+	.init               = fio_iscsi_init,
+	.prep               = fio_iscsi_prep,
+	.queue              = fio_iscsi_queue,
+	.getevents          = fio_iscsi_getevents,
+	.event              = fio_iscsi_event,
+	.cleanup            = fio_iscsi_cleanup,
+	.open_file          = fio_iscsi_open_file,
+	.close_file         = fio_iscsi_close_file,
+	.option_struct_size = sizeof(struct iscsi_options),
+	.options	    = options,
+};
+
+static void fio_init fio_iscsi_register(void)
+{
+	register_ioengine(&ioengine_iscsi);
+}
+
+static void fio_exit fio_iscsi_unregister(void)
+{
+	unregister_ioengine(&ioengine_iscsi);
+}
diff --git a/examples/libiscsi.fio b/examples/libiscsi.fio
new file mode 100644
index 00000000..565604dd
--- /dev/null
+++ b/examples/libiscsi.fio
@@ -0,0 +1,3 @@
+[iscsi]
+ioengine=libiscsi
+filename=iscsi\://127.0.0.1/iqn.2016-02.com.fio\:system\:fio/1
diff --git a/filesetup.c b/filesetup.c
index 47c889a0..24e6fb07 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -890,6 +890,42 @@ uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
 	return offset;
 }
 
+static bool create_work_dirs(struct thread_data *td, const char *fname)
+{
+	char path[PATH_MAX];
+	char *start, *end;
+
+	if (td->o.directory) {
+		snprintf(path, PATH_MAX, "%s%c%s", td->o.directory,
+			 FIO_OS_PATH_SEPARATOR, fname);
+		start = strstr(path, fname);
+	} else {
+		snprintf(path, PATH_MAX, "%s", fname);
+		start = path;
+	}
+
+	end = start;
+	while ((end = strchr(end, FIO_OS_PATH_SEPARATOR)) != NULL) {
+		if (end == start)
+			break;
+		*end = '\0';
+		errno = 0;
+#ifdef CONFIG_HAVE_MKDIR_TWO
+		if (mkdir(path, 0600) && errno != EEXIST) {
+#else
+		if (mkdir(path) && errno != EEXIST) {
+#endif
+			log_err("fio: failed to create dir (%s): %d\n",
+				start, errno);
+			return false;
+		}
+		*end = FIO_OS_PATH_SEPARATOR;
+		end++;
+	}
+	td->flags |= TD_F_DIRS_CREATED;
+	return true;
+}
+
 /*
  * Open the files and setup files sizes, creating files if necessary.
  */
@@ -908,6 +944,14 @@ int setup_files(struct thread_data *td)
 
 	old_state = td_bump_runstate(td, TD_SETTING_UP);
 
+	for_each_file(td, f, i) {
+		if (!td_ioengine_flagged(td, FIO_DISKLESSIO) &&
+		    strchr(f->file_name, FIO_OS_PATH_SEPARATOR) &&
+		    !(td->flags & TD_F_DIRS_CREATED) &&
+		    !create_work_dirs(td, f->file_name))
+			goto err_out;
+	}
+
 	/*
 	 * Find out physical size of files or devices for this thread,
 	 * before we determine I/O size and range of our targets.
@@ -1517,42 +1561,6 @@ bool exists_and_not_regfile(const char *filename)
 	return true;
 }
 
-static bool create_work_dirs(struct thread_data *td, const char *fname)
-{
-	char path[PATH_MAX];
-	char *start, *end;
-
-	if (td->o.directory) {
-		snprintf(path, PATH_MAX, "%s%c%s", td->o.directory,
-			 FIO_OS_PATH_SEPARATOR, fname);
-		start = strstr(path, fname);
-	} else {
-		snprintf(path, PATH_MAX, "%s", fname);
-		start = path;
-	}
-
-	end = start;
-	while ((end = strchr(end, FIO_OS_PATH_SEPARATOR)) != NULL) {
-		if (end == start)
-			break;
-		*end = '\0';
-		errno = 0;
-#ifdef CONFIG_HAVE_MKDIR_TWO
-		if (mkdir(path, 0600) && errno != EEXIST) {
-#else
-		if (mkdir(path) && errno != EEXIST) {
-#endif
-			log_err("fio: failed to create dir (%s): %d\n",
-				start, errno);
-			return false;
-		}
-		*end = FIO_OS_PATH_SEPARATOR;
-		end++;
-	}
-	td->flags |= TD_F_DIRS_CREATED;
-	return true;
-}
-
 int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 {
 	int cur_files = td->files_index;
@@ -1568,11 +1576,6 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 
 	sprintf(file_name + len, "%s", fname);
 
-	if (strchr(fname, FIO_OS_PATH_SEPARATOR) &&
-	    !(td->flags & TD_F_DIRS_CREATED) &&
-	    !create_work_dirs(td, fname))
-		return 1;
-
 	/* clean cloned siblings using existing files */
 	if (numjob && is_already_allocated(file_name) &&
 	    !exists_and_not_regfile(fname))
diff --git a/fio.1 b/fio.1
index ed492682..2708b503 100644
--- a/fio.1
+++ b/fio.1
@@ -1751,6 +1751,9 @@ are "contiguous" and the IO depth is not exceeded) before issuing a call to IME.
 Asynchronous read and write using DDN's Infinite Memory Engine (IME). This
 engine will try to stack as much IOs as possible by creating requests for IME.
 FIO will then decide when to commit these requests.
+.TP
+.B libiscsi
+Read and write iscsi lun with libiscsi.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
diff --git a/optgroup.h b/optgroup.h
index bf1bb036..483adddd 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -63,6 +63,7 @@ enum opt_category_group {
 	__FIO_OPT_G_SG,
 	__FIO_OPT_G_MMAP,
 	__FIO_OPT_G_NR,
+	__FIO_OPT_G_ISCSI,
 
 	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
 	FIO_OPT_G_ZONE		= (1ULL << __FIO_OPT_G_ZONE),
@@ -100,6 +101,7 @@ enum opt_category_group {
 	FIO_OPT_G_SG		= (1ULL << __FIO_OPT_G_SG),
 	FIO_OPT_G_MMAP		= (1ULL << __FIO_OPT_G_MMAP),
 	FIO_OPT_G_INVALID	= (1ULL << __FIO_OPT_G_NR),
+	FIO_OPT_G_ISCSI         = (1ULL << __FIO_OPT_G_ISCSI),
 };
 
 extern const struct opt_group *opt_group_from_mask(uint64_t *mask);

