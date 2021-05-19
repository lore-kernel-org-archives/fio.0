Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237480AbhESMB0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 May 2021 08:01:26 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC145C06175F
        for <fio@vger.kernel.org>; Wed, 19 May 2021 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljKrs-003rwn-Ku
        for fio@vger.kernel.org; Wed, 19 May 2021 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210519120002.5D8AA1BC0106@kernel.dk>
Date: Wed, 19 May 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dfecde6a4b49bd299b2a7192c10533b9beb4820d:

  Merge branch '2021-05-13/stat-fix-integer-overflow' of https://github.com/flx42/fio (2021-05-14 09:36:59 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b54e0d80c52e626021aacd0ae4d9875940cff9aa:

  Merge branch 'taras/nfs-upstream' of https://github.com/tarasglek/fio-1 (2021-05-18 17:34:38 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'taras/nfs-upstream' of https://github.com/tarasglek/fio-1

Taras Glek (6):
      NFS engine
      NFS configure fixes
      C-style comments
      single line bodies
      skip skeleton comments
      clean up nfs example

 HOWTO            |  13 ++-
 Makefile         |   6 ++
 configure        |  29 +++++
 engines/nfs.c    | 314 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 examples/nfs.fio |  22 ++++
 fio.1            |  10 ++
 optgroup.c       |   4 +
 optgroup.h       |   2 +
 options.c        |   5 +
 9 files changed, 404 insertions(+), 1 deletion(-)
 create mode 100644 engines/nfs.c
 create mode 100644 examples/nfs.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index f5681c0d..86fb2964 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1171,7 +1171,7 @@ I/O type
 
 		**1**
 			Backward-compatible alias for **mixed**.
-		
+
 		**2**
 			Alias for **both**.
 
@@ -2103,6 +2103,12 @@ I/O engine
 			I/O engine supporting asynchronous read and write operations to the
 			DAOS File System (DFS) via libdfs.
 
+		**nfs**
+			I/O engine supporting asynchronous read and write operations to
+			NFS filesystems from userspace via libnfs. This is useful for
+			achieving higher concurrency and thus throughput than is possible
+			via kernel NFS.
+
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -2525,6 +2531,11 @@ with the caveat that when used on the command line, they must come after the
 	Specificy a different object class for the dfs file.
 	Use DAOS container's object class by default.
 
+.. option:: nfs_url=str : [nfs]
+
+	URL in libnfs format, eg nfs://<server|ipv4|ipv6>/path[?arg=val[&arg=val]*]
+	Refer to the libnfs README for more details.
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/Makefile b/Makefile
index ba027b2e..ef317373 100644
--- a/Makefile
+++ b/Makefile
@@ -79,6 +79,12 @@ ifdef CONFIG_LIBNBD
   ENGINES += nbd
 endif
 
+ifdef CONFIG_LIBNFS
+  CFLAGS += $(LIBNFS_CFLAGS)
+  LIBS += $(LIBNFS_LIBS)
+  SOURCE += engines/nfs.c
+endif
+
 ifdef CONFIG_64BIT
   CPPFLAGS += -DBITS_PER_LONG=64
 else ifdef CONFIG_32BIT
diff --git a/configure b/configure
index e886bdc8..8b763700 100755
--- a/configure
+++ b/configure
@@ -170,6 +170,7 @@ disable_native="no"
 march_set="no"
 libiscsi="no"
 libnbd="no"
+libnfs="no"
 libzbc=""
 dfs=""
 dynamic_engines="no"
@@ -241,6 +242,8 @@ for opt do
   ;;
   --disable-tcmalloc) disable_tcmalloc="yes"
   ;;
+  --disable-nfs) disable_nfs="yes"
+  ;;
   --dynamic-libengines) dynamic_engines="yes"
   ;;
   --disable-dfs) dfs="no"
@@ -271,8 +274,10 @@ if test "$show_help" = "yes" ; then
   echo "--disable-rados         Disable Rados support even if found"
   echo "--disable-rbd           Disable Rados Block Device even if found"
   echo "--disable-http          Disable HTTP support even if found"
+  echo "--disable-nfs           Disable userspace NFS support even if found"
   echo "--disable-gfapi         Disable gfapi"
   echo "--enable-libhdfs        Enable hdfs support"
+  echo "--enable-libnfs         Enable nfs support"
   echo "--disable-lex           Disable use of lex/yacc for math"
   echo "--disable-pmem          Disable pmem based engines even if found"
   echo "--enable-lex            Enable use of lex/yacc for math"
@@ -2277,6 +2282,21 @@ EOF
 fi
 print_config "DAOS File System (dfs) Engine" "$dfs"
 
+##########################################
+# Check if we have libnfs (for userspace nfs support).
+if test "$disable_nfs" != "yes"; then
+  if $(pkg-config libnfs); then
+    libnfs="yes"
+    libnfs_cflags=$(pkg-config --cflags libnfs)
+    libnfs_libs=$(pkg-config --libs libnfs)
+  else
+    if test "$libnfs" = "yes" ; then
+      echo "libnfs" "Install libnfs"
+    fi
+  fi
+fi
+print_config "NFS engine" "$libnfs"
+
 ##########################################
 # Check if we have lex/yacc available
 yacc="no"
@@ -3101,6 +3121,9 @@ fi
 if test "$dfs" = "yes" ; then
   output_sym "CONFIG_DFS"
 fi
+if test "$libnfs" = "yes" ; then
+  output_sym "CONFIG_NFS"
+fi
 if test "$march_set" = "no" && test "$build_native" = "yes" ; then
   output_sym "CONFIG_BUILD_NATIVE"
 fi
@@ -3140,6 +3163,12 @@ if test "$libnbd" = "yes" ; then
   echo "LIBNBD_CFLAGS=$libnbd_cflags" >> $config_host_mak
   echo "LIBNBD_LIBS=$libnbd_libs" >> $config_host_mak
 fi
+if test "$libnfs" = "yes" ; then
+  output_sym "CONFIG_LIBNFS"
+  echo "CONFIG_LIBNFS=m" >> $config_host_mak
+  echo "LIBNFS_CFLAGS=$libnfs_cflags" >> $config_host_mak
+  echo "LIBNFS_LIBS=$libnfs_libs" >> $config_host_mak
+fi
 if test "$dynamic_engines" = "yes" ; then
   output_sym "CONFIG_DYNAMIC_ENGINES"
 fi
diff --git a/engines/nfs.c b/engines/nfs.c
new file mode 100644
index 00000000..21be8833
--- /dev/null
+++ b/engines/nfs.c
@@ -0,0 +1,314 @@
+#include <stdlib.h>
+#include <poll.h>
+#include <nfsc/libnfs.h>
+#include <nfsc/libnfs-raw.h>
+#include <nfsc/libnfs-raw-mount.h>
+
+#include "../fio.h"
+#include "../optgroup.h"
+
+enum nfs_op_type {
+	NFS_READ_WRITE = 0,
+	NFS_STAT_MKDIR_RMDIR,
+	NFS_STAT_TOUCH_RM,
+};
+
+struct fio_libnfs_options {
+	struct nfs_context *context;
+	char *nfs_url;
+	unsigned int queue_depth; /* nfs_callback needs this info, but doesn't have fio td structure to pull it from */
+	/* the following implement a circular queue of outstanding IOs */
+	int outstanding_events; /* IOs issued to libnfs, that have not returned yet */
+	int prev_requested_event_index; /* event last returned via fio_libnfs_event */
+	int next_buffered_event; /* round robin-pointer within events[] */
+	int buffered_event_count; /* IOs completed by libnfs, waiting for FIO */
+	int free_event_buffer_index; /* next free buffer */
+	struct io_u**events;
+};
+
+struct nfs_data {
+	struct nfsfh *nfsfh;
+	struct fio_libnfs_options *options;
+};
+
+static struct fio_option options[] = {
+	{
+		.name     = "nfs_url",
+		.lname    = "nfs_url",
+		.type     = FIO_OPT_STR_STORE,
+		.help	= "URL in libnfs format, eg nfs://<server|ipv4|ipv6>/path[?arg=val[&arg=val]*]",
+		.off1     = offsetof(struct fio_libnfs_options, nfs_url),
+		.category = FIO_OPT_C_ENGINE,
+		.group	= __FIO_OPT_G_NFS,
+	},
+	{
+		.name     = NULL,
+	},
+};
+
+static struct io_u *fio_libnfs_event(struct thread_data *td, int event)
+{
+	struct fio_libnfs_options *o = td->eo;
+	struct io_u *io_u = o->events[o->next_buffered_event];
+	assert(o->events[o->next_buffered_event]);
+	o->events[o->next_buffered_event] = NULL;
+	o->next_buffered_event = (o->next_buffered_event + 1) % td->o.iodepth;
+	/* validate our state machine */
+	assert(o->buffered_event_count);
+	o->buffered_event_count--;
+	assert(io_u);
+	/* assert that fio_libnfs_event is being called in sequential fashion */
+	assert(event == 0 || o->prev_requested_event_index + 1 == event);
+	if (o->buffered_event_count == 0) {
+		o->prev_requested_event_index = -1;
+	} else {
+		o->prev_requested_event_index = event;
+	}
+	return io_u;
+}
+
+static int nfs_event_loop(struct thread_data *td, bool flush) {
+	struct fio_libnfs_options *o = td->eo;
+	struct pollfd pfds[1]; /* nfs:0 */
+	/* we already have stuff queued for fio, no need to waste cpu on poll() */
+	if (o->buffered_event_count)
+		return o->buffered_event_count;
+	/* fio core logic seems to stop calling this event-loop if we ever return with 0 events */
+	#define SHOULD_WAIT() (o->outstanding_events == td->o.iodepth || (flush && o->outstanding_events))
+
+	do {
+		int timeout = SHOULD_WAIT() ? -1 : 0;
+		int ret = 0;
+		pfds[0].fd = nfs_get_fd(o->context);
+		pfds[0].events = nfs_which_events(o->context);
+		ret = poll(&pfds[0], 1, timeout);
+		if (ret < 0) {
+			if (errno == EINTR || errno == EAGAIN) {
+				continue;
+			}
+			log_err("nfs: failed to poll events: %s.\n",
+				strerror(errno));
+			break;
+		}
+
+		ret = nfs_service(o->context, pfds[0].revents);
+		if (ret < 0) {
+			log_err("nfs: socket is in an unrecoverable error state.\n");
+			break;
+		}
+	} while (SHOULD_WAIT());
+	return o->buffered_event_count;
+#undef SHOULD_WAIT
+}
+
+static int fio_libnfs_getevents(struct thread_data *td, unsigned int min,
+				  unsigned int max, const struct timespec *t)
+{
+	return nfs_event_loop(td, false);
+}
+
+static void nfs_callback(int res, struct nfs_context *nfs, void *data,
+                       void *private_data)
+{
+	struct io_u *io_u = private_data;
+	struct nfs_data *nfs_data = io_u->file->engine_data;
+	struct fio_libnfs_options *o = nfs_data->options;
+	if (res < 0) {
+		log_err("Failed NFS operation(code:%d): %s\n", res, nfs_get_error(o->context));
+		io_u->error = -res;
+		/* res is used for read math below, don't wanna pass negative there */
+		res = 0;
+	} else if (io_u->ddir == DDIR_READ) {
+		memcpy(io_u->buf, data, res);
+		if (res == 0)
+			log_err("Got NFS EOF, this is probably not expected\n");
+	}
+	/* fio uses resid to track remaining data */
+	io_u->resid = io_u->xfer_buflen - res;
+
+	assert(!o->events[o->free_event_buffer_index]);
+	o->events[o->free_event_buffer_index] = io_u;
+	o->free_event_buffer_index = (o->free_event_buffer_index + 1) % o->queue_depth;
+	o->outstanding_events--;
+	o->buffered_event_count++;
+}
+
+static int queue_write(struct fio_libnfs_options *o, struct io_u *io_u) {
+	struct nfs_data *nfs_data = io_u->engine_data;
+	return nfs_pwrite_async(o->context, nfs_data->nfsfh,
+                           io_u->offset, io_u->buflen, io_u->buf, nfs_callback,
+                           io_u);
+}
+
+static int queue_read(struct fio_libnfs_options *o, struct io_u *io_u) {
+	struct nfs_data *nfs_data = io_u->engine_data;
+	return nfs_pread_async(o->context,  nfs_data->nfsfh, io_u->offset, io_u->buflen, nfs_callback,  io_u);
+}
+
+static enum fio_q_status fio_libnfs_queue(struct thread_data *td,
+					    struct io_u *io_u)
+{
+	struct nfs_data *nfs_data = io_u->file->engine_data;
+	struct fio_libnfs_options *o = nfs_data->options;
+	struct nfs_context *nfs = o->context;
+	int err;
+	enum fio_q_status ret = FIO_Q_QUEUED;
+
+	io_u->engine_data = nfs_data;
+	switch(io_u->ddir) {
+		case DDIR_WRITE:
+			err = queue_write(o, io_u);
+			break;
+		case DDIR_READ:
+			err = queue_read(o, io_u);
+			break;
+		case DDIR_TRIM:
+			log_err("nfs: trim is not supported");
+			err = -1;
+			break;
+		default:
+			log_err("nfs: unhandled io %d\n", io_u->ddir);
+			err = -1;
+	}
+	if (err) {
+		log_err("nfs: Failed to queue nfs op: %s\n", nfs_get_error(nfs));
+		td->error = 1;
+		return FIO_Q_COMPLETED;
+	}
+	o->outstanding_events++;
+	return ret;
+}
+
+/*
+ * Do a mount if one has not been done before 
+ */
+static int do_mount(struct thread_data *td, const char *url)
+{
+	size_t event_size = sizeof(struct io_u **) * td->o.iodepth;
+	struct fio_libnfs_options *options = td->eo;
+	struct nfs_url *nfs_url = NULL;
+	int ret = 0;
+	int path_len = 0;
+	char *mnt_dir = NULL;
+
+	if (options->context)
+		return 0;
+
+	options->context = nfs_init_context();
+	if (options->context == NULL) {
+		log_err("nfs: failed to init nfs context\n");
+		return -1;
+	}
+
+	options->events = malloc(event_size);
+	memset(options->events, 0, event_size);
+
+	options->prev_requested_event_index = -1;
+	options->queue_depth = td->o.iodepth;
+
+	nfs_url = nfs_parse_url_full(options->context, url);
+	path_len = strlen(nfs_url->path);
+	mnt_dir = malloc(path_len + strlen(nfs_url->file) + 1);
+	strcpy(mnt_dir, nfs_url->path);
+	strcpy(mnt_dir + strlen(nfs_url->path), nfs_url->file);
+	ret = nfs_mount(options->context, nfs_url->server, mnt_dir);
+	free(mnt_dir);
+	nfs_destroy_url(nfs_url);
+	return ret;
+}
+
+static int fio_libnfs_setup(struct thread_data *td)
+{
+	/* Using threads with libnfs causes fio to hang on exit, lower performance */
+	td->o.use_thread = 0;
+	return 0;
+}
+
+static void fio_libnfs_cleanup(struct thread_data *td)
+{
+	struct fio_libnfs_options *o = td->eo;
+	nfs_umount(o->context);
+	nfs_destroy_context(o->context);
+	free(o->events);
+}
+
+static int fio_libnfs_open(struct thread_data *td, struct fio_file *f)
+{
+	int ret;
+	struct fio_libnfs_options *options = td->eo;
+	struct nfs_data *nfs_data = NULL;
+	int flags = 0;
+
+	if (!options->nfs_url) {
+		log_err("nfs: nfs_url is a required parameter\n");
+		return -1;
+	}
+
+	ret = do_mount(td, options->nfs_url);
+
+	if (ret != 0) {
+		log_err("nfs: Failed to mount %s with code %d: %s\n", options->nfs_url, ret, nfs_get_error(options->context));
+		return ret;
+	}
+	nfs_data = malloc(sizeof(struct nfs_data));
+	memset(nfs_data, 0, sizeof(struct nfs_data));
+	nfs_data->options = options;
+
+	if (td->o.td_ddir == TD_DDIR_WRITE) {
+		flags |= O_CREAT | O_RDWR;
+	} else {
+		flags |= O_RDWR;
+	}
+	ret = nfs_open(options->context, f->file_name, flags, &nfs_data->nfsfh);
+
+	if (ret != 0)
+		log_err("Failed to open %s: %s\n", f->file_name, nfs_get_error(options->context));
+	f->engine_data = nfs_data;
+	return ret;
+}
+
+static int fio_libnfs_close(struct thread_data *td, struct fio_file *f)
+{
+	struct nfs_data *nfs_data = f->engine_data;
+	struct fio_libnfs_options *o = nfs_data->options;
+	int ret = 0;
+	if (nfs_data->nfsfh)
+		ret = nfs_close(o->context, nfs_data->nfsfh);
+	free(nfs_data);
+	f->engine_data = NULL;
+	return ret;
+}
+
+/*
+ * Hook for writing out outstanding data.
+ */
+static int fio_libnfs_commit(struct thread_data *td) {
+	nfs_event_loop(td, true);
+	return 0;
+}
+
+struct ioengine_ops ioengine = {
+	.name		= "nfs",
+	.version	= FIO_IOOPS_VERSION,
+	.setup		= fio_libnfs_setup,
+	.queue		= fio_libnfs_queue,
+	.getevents	= fio_libnfs_getevents,
+	.event		= fio_libnfs_event,
+	.cleanup	= fio_libnfs_cleanup,
+	.open_file	= fio_libnfs_open,
+	.close_file	= fio_libnfs_close,
+	.commit     = fio_libnfs_commit,
+	.flags      = FIO_DISKLESSIO | FIO_NOEXTEND | FIO_NODISKUTIL,
+	.options	= options,
+	.option_struct_size	= sizeof(struct fio_libnfs_options),
+};
+
+static void fio_init fio_nfs_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_nfs_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/nfs.fio b/examples/nfs.fio
new file mode 100644
index 00000000..f856cebf
--- /dev/null
+++ b/examples/nfs.fio
@@ -0,0 +1,22 @@
+[global]
+nfs_url=nfs://127.0.0.1/nfs
+blocksize=524288
+iodepth=10
+ioengine=nfs
+size=104857600
+lat_percentiles=1
+group_reporting
+numjobs=10
+ramp_time=5s
+filename_format=myfiles.$clientuid.$jobnum.$filenum
+time_based=1
+
+[write]
+rw=write
+runtime=10s
+stonewall
+
+[read]
+wait_for=write
+rw=randread
+runtime=10s
diff --git a/fio.1 b/fio.1
index 533bcf6a..ab08cb01 100644
--- a/fio.1
+++ b/fio.1
@@ -1901,6 +1901,12 @@ not be \fBcudamalloc\fR. This ioengine defines engine specific options.
 .B dfs
 I/O engine supporting asynchronous read and write operations to the DAOS File
 System (DFS) via libdfs.
+.TP
+.B nfs
+I/O engine supporting asynchronous read and write operations to
+NFS filesystems from userspace via libnfs. This is useful for
+achieving higher concurrency and thus throughput than is possible
+via kernel NFS.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
@@ -2283,6 +2289,10 @@ Use DAOS container's chunk size by default.
 .BI (dfs)object_class
 Specificy a different object class for the dfs file.
 Use DAOS container's object class by default.
+.TP
+.BI (nfs)nfs_url
+URL in libnfs format, eg nfs://<server|ipv4|ipv6>/path[?arg=val[&arg=val]*]
+Refer to the libnfs README for more details.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
diff --git a/optgroup.c b/optgroup.c
index 15a16229..bebb4a51 100644
--- a/optgroup.c
+++ b/optgroup.c
@@ -185,6 +185,10 @@ static const struct opt_group fio_opt_cat_groups[] = {
 		.name	= "DAOS File System (dfs) I/O engine", /* dfs */
 		.mask	= FIO_OPT_G_DFS,
 	},
+	{
+		.name	= "NFS I/O engine", /* nfs */
+		.mask	= FIO_OPT_G_NFS,
+	},
 	{
 		.name	= NULL,
 	},
diff --git a/optgroup.h b/optgroup.h
index ff748629..1fb84a29 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -70,6 +70,7 @@ enum opt_category_group {
 	__FIO_OPT_G_NR,
 	__FIO_OPT_G_LIBCUFILE,
 	__FIO_OPT_G_DFS,
+	__FIO_OPT_G_NFS,
 
 	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
 	FIO_OPT_G_ZONE		= (1ULL << __FIO_OPT_G_ZONE),
@@ -110,6 +111,7 @@ enum opt_category_group {
 	FIO_OPT_G_INVALID	= (1ULL << __FIO_OPT_G_NR),
 	FIO_OPT_G_ISCSI         = (1ULL << __FIO_OPT_G_ISCSI),
 	FIO_OPT_G_NBD		= (1ULL << __FIO_OPT_G_NBD),
+	FIO_OPT_G_NFS		= (1ULL << __FIO_OPT_G_NFS),
 	FIO_OPT_G_IOURING	= (1ULL << __FIO_OPT_G_IOURING),
 	FIO_OPT_G_FILESTAT	= (1ULL << __FIO_OPT_G_FILESTAT),
 	FIO_OPT_G_LIBCUFILE	= (1ULL << __FIO_OPT_G_LIBCUFILE),
diff --git a/options.c b/options.c
index ddabaa82..b82a10aa 100644
--- a/options.c
+++ b/options.c
@@ -2025,6 +2025,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  { .ival = "dfs",
 			    .help = "DAOS File System (dfs) IO engine",
 			  },
+#endif
+#ifdef CONFIG_NFS
+			  { .ival = "nfs",
+			    .help = "NFS IO engine",
+			  },
 #endif
 		},
 	},

