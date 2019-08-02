Return-Path: <rjones@redhat.com>
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH v4] engines: Add Network Block Device (NBD) support using libnbd.
Date: Fri,  2 Aug 2019 16:32:25 +0100
Message-Id: <20190802153225.11480-2-rjones@redhat.com>
In-Reply-To: <20190802153225.11480-1-rjones@redhat.com>
References: <20190802153225.11480-1-rjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org
Cc: eblake@redhat.com, axboe@kernel.dk
List-ID: <fio@vger.kernel.org>

This commit adds a new engine for testing Network Block Devices
directly.  It requires libnbd (https://github.com/libguestfs/libnbd).

To see how to test nbdkit or qemu-nbd read examples/nbd.fio.

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 HOWTO            |   2 +
 Makefile         |   6 +
 configure        |  27 ++++
 engines/nbd.c    | 368 +++++++++++++++++++++++++++++++++++++++++++++++
 examples/nbd.fio |  35 +++++
 fio.1            |   3 +
 optgroup.c       |   4 +
 optgroup.h       |   2 +
 options.c        |   3 +
 9 files changed, 450 insertions(+)

diff --git a/HOWTO b/HOWTO
index 81244064..955ea43c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1998,6 +1998,8 @@ I/O engine
 			requests for IME. FIO will then decide when to commit these requests.
 		**libiscsi**
 			Read and write iscsi lun with libiscsi.
+		**nbd**
+			Synchronous read and write a Network Block Device (NBD).
 
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/Makefile b/Makefile
index d7e5fca7..fe02bf1d 100644
--- a/Makefile
+++ b/Makefile
@@ -65,6 +65,12 @@ ifdef CONFIG_LIBISCSI
   SOURCE += engines/libiscsi.c
 endif
 
+ifdef CONFIG_LIBNBD
+  CFLAGS += $(LIBNBD_CFLAGS)
+  LIBS += $(LIBNBD_LIBS)
+  SOURCE += engines/nbd.c
+endif
+
 ifdef CONFIG_64BIT
   CFLAGS += -DBITS_PER_LONG=64
 endif
diff --git a/configure b/configure
index a0692d58..b11b2dce 100755
--- a/configure
+++ b/configure
@@ -149,6 +149,7 @@ disable_pmem="no"
 disable_native="no"
 march_set="no"
 libiscsi="no"
+libnbd="no"
 prefix=/usr/local
 
 # parse options
@@ -207,6 +208,8 @@ for opt do
   ;;
   --enable-libiscsi) libiscsi="yes"
   ;;
+  --enable-libnbd) libnbd="yes"
+  ;;
   --disable-tcmalloc) disable_tcmalloc="yes"
   ;;
   --help)
@@ -245,6 +248,7 @@ if test "$show_help" = "yes" ; then
   echo "--disable-native        Don't build for native host"
   echo "--with-ime=             Install path for DDN's Infinite Memory Engine"
   echo "--enable-libiscsi       Enable iscsi support"
+  echo "--enable-libnbd         Enable libnbd (NBD engine) support"
   echo "--disable-tcmalloc	Disable tcmalloc support"
   exit $exit_val
 fi
@@ -2014,6 +2018,23 @@ if test "$libiscsi" = "yes" ; then
 fi
 print_config "iscsi engine" "$libiscsi"
 
+##########################################
+# Check if we have libnbd (for NBD support).
+minimum_libnbd=0.9.6
+if test "$libnbd" = "yes" ; then
+  if $(pkg-config --atleast-version=$minimum_libnbd libnbd); then
+    libnbd="yes"
+    libnbd_cflags=$(pkg-config --cflags libnbd)
+    libnbd_libs=$(pkg-config --libs libnbd)
+  else
+    if test "$libnbd" = "yes" ; then
+      echo "libnbd" "Install libnbd >= $minimum_libnbd"
+    fi
+    libnbd="no"
+  fi
+fi
+print_config "NBD engine" "$libnbd"
+
 ##########################################
 # Check if we have lex/yacc available
 yacc="no"
@@ -2698,6 +2719,12 @@ if test "$libiscsi" = "yes" ; then
   echo "LIBISCSI_CFLAGS=$libiscsi_cflags" >> $config_host_mak
   echo "LIBISCSI_LIBS=$libiscsi_libs" >> $config_host_mak
 fi
+if test "$libnbd" = "yes" ; then
+  output_sym "CONFIG_LIBNBD"
+  echo "CONFIG_LIBNBD=m" >> $config_host_mak
+  echo "LIBNBD_CFLAGS=$libnbd_cflags" >> $config_host_mak
+  echo "LIBNBD_LIBS=$libnbd_libs" >> $config_host_mak
+fi
 cat > $TMPC << EOF
 int main(int argc, char **argv)
 {
diff --git a/engines/nbd.c b/engines/nbd.c
new file mode 100644
index 00000000..399da5f3
--- /dev/null
+++ b/engines/nbd.c
@@ -0,0 +1,368 @@
+/*
+ * NBD engine
+ *
+ * IO engine that talks to an NBD server.
+ *
+ * Copyright (C) 2019 Red Hat Inc.
+ * Written by Richard W.M. Jones <rjones@redhat.com>
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <errno.h>
+
+#include <libnbd.h>
+
+#include "../fio.h"
+#include "../optgroup.h"
+
+/* Actually this differs across servers, but for nbdkit ... */
+#define NBD_MAX_REQUEST_SIZE (64 * 1024 * 1024)
+
+/* Storage for the NBD handle. */
+struct nbd_data {
+	struct nbd_handle *nbd;
+        int debug;
+
+        /* The list of completed io_u structs. */
+        struct io_u **completed;
+        size_t nr_completed;
+};
+
+/* Options. */
+struct nbd_options {
+	void *padding;
+	char *uri;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	= "uri",
+		.lname	= "NBD URI",
+		.help	= "Name of NBD URI",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_NBD,
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct nbd_options, uri),
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+/* Alocates nbd_data. */
+static int nbd_setup(struct thread_data *td)
+{
+	struct nbd_data *nbd_data;
+	struct nbd_options *o = td->eo;
+	struct fio_file *f;
+	int r;
+	int64_t size;
+
+        nbd_data = calloc(1, sizeof(*nbd_data));
+        if (!nbd_data) {
+                td_verror(td, errno, "calloc");
+                return 1;
+        }
+        td->io_ops_data = nbd_data;
+
+	/* Pretend to deal with files.	See engines/rbd.c */
+	if (!td->files_index) {
+		add_file(td, "nbd", 0, 0);
+		td->o.nr_files = td->o.nr_files ? : 1;
+		td->o.open_files++;
+	}
+	f = td->files[0];
+
+        nbd_data->nbd = nbd_create();
+        if (!nbd_data->nbd) {
+                log_err("fio: nbd_create: %s\n", nbd_get_error());
+                return 1;
+        }
+
+        /* Get the debug flag which can be set through LIBNBD_DEBUG=1. */
+        nbd_data->debug = nbd_get_debug(nbd_data->nbd);
+
+	/* Connect synchronously here so we can check for the size and
+	 * in future other properties of the server.
+	 */
+	if (!o->uri) {
+		log_err("fio: nbd: uri parameter was not specified\n");
+		return 1;
+	}
+	r = nbd_connect_uri(nbd_data->nbd, o->uri);
+	if (r == -1) {
+		log_err("fio: nbd_connect_uri: %s\n", nbd_get_error());
+		return 1;
+	}
+	size = nbd_get_size(nbd_data->nbd);
+	if (size == -1) {
+		log_err("fio: nbd_get_size: %s\n", nbd_get_error());
+		return 1;
+	}
+
+	f->real_file_size = size;
+
+	nbd_close (nbd_data->nbd);
+	nbd_data->nbd = NULL;
+
+	return 0;
+}
+
+/* Closes socket and frees nbd_data -- the opposite of nbd_setup. */
+static void nbd_cleanup(struct thread_data *td)
+{
+	struct nbd_data *nbd_data = td->io_ops_data;
+
+	if (nbd_data) {
+		if (nbd_data->nbd)
+			nbd_close(nbd_data->nbd);
+		free(nbd_data);
+	}
+}
+
+/* Connect to the server from each thread. */
+static int nbd_init(struct thread_data *td)
+{
+	struct nbd_options *o = td->eo;
+	struct nbd_data *nbd_data = td->io_ops_data;
+	int r;
+
+	if (!o->uri) {
+		log_err("fio: nbd: uri parameter was not specified\n");
+		return 1;
+	}
+
+        nbd_data->nbd = nbd_create();
+        if (!nbd_data->nbd) {
+		log_err("fio: nbd_create: %s\n", nbd_get_error());
+                return 1;
+        }
+	/* This is actually a synchronous connect and handshake. */
+	r = nbd_connect_uri(nbd_data->nbd, o->uri);
+	if (r == -1) {
+		log_err("fio: nbd_connect_uri: %s\n", nbd_get_error());
+		return 1;
+	}
+
+	log_info("fio: connected to NBD server\n");
+	return 0;
+}
+
+/* A command in flight has been completed. */
+static int cmd_completed (unsigned valid_flag, void *vp, int *error)
+{
+	struct io_u *io_u;
+        struct nbd_data *nbd_data;
+        struct io_u **completed;
+
+	if (!(valid_flag & LIBNBD_CALLBACK_VALID))
+		return 0;
+
+	io_u = vp;
+        nbd_data = io_u->engine_data;
+
+        if (nbd_data->debug)
+                log_info("fio: nbd: command completed\n");
+
+	if (*error != 0)
+		io_u->error = *error;
+	else
+		io_u->error = 0;
+
+        /* Add this completion to the list so it can be picked up
+         * later by ->event.
+         */
+        completed = realloc(nbd_data->completed,
+                            sizeof(struct io_u *) *
+                            (nbd_data->nr_completed+1));
+        if (completed == NULL) {
+                io_u->error = errno;
+                return 0;
+        }
+
+        nbd_data->completed = completed;
+        nbd_data->completed[nbd_data->nr_completed] = io_u;
+        nbd_data->nr_completed++;
+
+	return 0;
+}
+
+/* Begin read or write request. */
+static enum fio_q_status nbd_queue(struct thread_data *td,
+				   struct io_u *io_u)
+{
+	struct nbd_data *nbd_data = td->io_ops_data;
+	int r;
+
+	fio_ro_check(td, io_u);
+
+        io_u->engine_data = nbd_data;
+
+	if (io_u->ddir == DDIR_WRITE || io_u->ddir == DDIR_READ)
+		assert(io_u->xfer_buflen <= NBD_MAX_REQUEST_SIZE);
+
+	switch (io_u->ddir) {
+	case DDIR_READ:
+		r = nbd_aio_pread_callback(nbd_data->nbd,
+					   io_u->xfer_buf, io_u->xfer_buflen,
+					   io_u->offset,
+					   cmd_completed, io_u,
+					   0);
+		break;
+	case DDIR_WRITE:
+		r = nbd_aio_pwrite_callback(nbd_data->nbd,
+					    io_u->xfer_buf, io_u->xfer_buflen,
+					    io_u->offset,
+					    cmd_completed, io_u,
+					    0);
+		break;
+	case DDIR_TRIM:
+		r = nbd_aio_trim_callback(nbd_data->nbd, io_u->xfer_buflen,
+					  io_u->offset,
+					  cmd_completed, io_u,
+					  0);
+		break;
+	case DDIR_SYNC:
+		/* XXX We could probably also handle
+		 * DDIR_SYNC_FILE_RANGE with a bit of effort.
+		 */
+		r = nbd_aio_flush_callback(nbd_data->nbd,
+					   cmd_completed, io_u,
+					   0);
+		break;
+	default:
+		io_u->error = EINVAL;
+		return FIO_Q_COMPLETED;
+	}
+
+	if (r == -1) {
+		/* errno is optional information on libnbd error path;
+		 * if it's 0, set it to a default value
+		 */
+		io_u->error = nbd_get_errno();
+		if (io_u->error == 0)
+			io_u->error = EIO;
+		return FIO_Q_COMPLETED;
+	}
+
+        if (nbd_data->debug)
+                log_info("fio: nbd: command issued\n");
+	io_u->error = 0;
+	return FIO_Q_QUEUED;
+}
+
+static unsigned retire_commands(struct nbd_handle *nbd)
+{
+	int64_t cookie;
+	unsigned r = 0;
+
+	while ((cookie = nbd_aio_peek_command_completed(nbd)) > 0) {
+		/* Ignore the return value.  cmd_completed has already
+		 * checked for an error and set io_u->error.  We only
+		 * have to call this to retire the command.
+		 */
+		nbd_aio_command_completed(nbd, cookie);
+		r++;
+	}
+
+        if (nbd_get_debug(nbd))
+                log_info("fio: nbd: %u commands retired\n", r);
+	return r;
+}
+
+static int nbd_getevents(struct thread_data *td, unsigned int min,
+			 unsigned int max, const struct timespec *t)
+{
+	struct nbd_data *nbd_data = td->io_ops_data;
+	int r;
+	unsigned events = 0;
+        int timeout;
+
+        /* XXX This handling of timeout is wrong because it will wait
+         * for up to loop iterations * timeout.
+         */
+        timeout = !t ? -1 : t->tv_sec * 1000 + t->tv_nsec / 1000000;
+
+	while (events < min) {
+		r = nbd_poll(nbd_data->nbd, timeout);
+		if (r == -1) {
+			/* error in poll */
+			log_err("fio: nbd_poll: %s\n", nbd_get_error());
+			return -1;
+		}
+		else {
+			/* poll made progress */
+			events += retire_commands(nbd_data->nbd);
+		}
+	}
+
+	return events;
+}
+
+static struct io_u *nbd_event(struct thread_data *td, int event)
+{
+	struct nbd_data *nbd_data = td->io_ops_data;
+
+        if (nbd_data->nr_completed == 0)
+                return NULL;
+
+        /* XXX We ignore the event number and assume fio calls us
+         * exactly once for [0..nr_events-1].
+         */
+        nbd_data->nr_completed--;
+        return nbd_data->completed[nbd_data->nr_completed];
+}
+
+static int nbd_io_u_init(struct thread_data *td, struct io_u *io_u)
+{
+	io_u->engine_data = NULL;
+	return 0;
+}
+
+static void nbd_io_u_free(struct thread_data *td, struct io_u *io_u)
+{
+	/* Nothing needs to be done. */
+}
+
+static int nbd_open_file(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+
+static int nbd_invalidate(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+
+static struct ioengine_ops ioengine = {
+	.name			= "nbd",
+	.version		= FIO_IOOPS_VERSION,
+	.options		= options,
+	.option_struct_size	= sizeof(struct nbd_options),
+	.flags			= FIO_DISKLESSIO | FIO_NOEXTEND,
+
+	.setup			= nbd_setup,
+	.init			= nbd_init,
+	.cleanup		= nbd_cleanup,
+	.queue			= nbd_queue,
+	.getevents		= nbd_getevents,
+	.event			= nbd_event,
+	.io_u_init		= nbd_io_u_init,
+	.io_u_free		= nbd_io_u_free,
+
+	.open_file		= nbd_open_file,
+	.invalidate		= nbd_invalidate,
+};
+
+static void fio_init fio_nbd_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_nbd_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/nbd.fio b/examples/nbd.fio
new file mode 100644
index 00000000..27e15086
--- /dev/null
+++ b/examples/nbd.fio
@@ -0,0 +1,35 @@
+# To use fio to test nbdkit:
+#
+# nbdkit -U - memory size=256M --run 'export unixsocket; fio examples/nbd.fio'
+#
+# To use fio to test qemu-nbd:
+#
+# rm -f /tmp/disk.img /tmp/socket
+# truncate -s 256M /tmp/disk.img
+# export unixsocket=/tmp/socket
+# qemu-nbd -t -k $unixsocket -f raw /tmp/disk.img &
+# fio examples/nbd.fio
+# killall qemu-nbd
+
+[global]
+ioengine=nbd
+uri=nbd+unix:///?socket=${unixsocket}
+# Starting from nbdkit 1.14 the following will work:
+#uri=${uri}
+rw=randrw
+time_based
+runtime=60
+group_reporting
+iodepth=64
+
+[job0]
+offset=0
+
+[job1]
+offset=064m
+
+[job2]
+offset=128m
+
+[job3]
+offset=192m
diff --git a/fio.1 b/fio.1
index 2966d9d5..30b17f02 100644
--- a/fio.1
+++ b/fio.1
@@ -1756,6 +1756,9 @@ FIO will then decide when to commit these requests.
 .TP
 .B libiscsi
 Read and write iscsi lun with libiscsi.
+.TP
+.B nbd
+Synchronous read and write a Network Block Device (NBD).
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
diff --git a/optgroup.c b/optgroup.c
index 04ceec7e..c228ff29 100644
--- a/optgroup.c
+++ b/optgroup.c
@@ -169,6 +169,10 @@ static const struct opt_group fio_opt_cat_groups[] = {
 		.name	= "libhdfs I/O engine", /* libhdfs */
 		.mask	= FIO_OPT_G_HDFS,
 	},
+	{
+		.name	= "NBD I/O engine", /* NBD */
+		.mask	= FIO_OPT_G_NBD,
+	},
 	{
 		.name	= NULL,
 	},
diff --git a/optgroup.h b/optgroup.h
index 148c8da1..8009bf25 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -63,6 +63,7 @@ enum opt_category_group {
 	__FIO_OPT_G_SG,
 	__FIO_OPT_G_MMAP,
 	__FIO_OPT_G_ISCSI,
+	__FIO_OPT_G_NBD,
 	__FIO_OPT_G_NR,
 
 	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
@@ -102,6 +103,7 @@ enum opt_category_group {
 	FIO_OPT_G_MMAP		= (1ULL << __FIO_OPT_G_MMAP),
 	FIO_OPT_G_INVALID	= (1ULL << __FIO_OPT_G_NR),
 	FIO_OPT_G_ISCSI         = (1ULL << __FIO_OPT_G_ISCSI),
+	FIO_OPT_G_NBD		= (1ULL << __FIO_OPT_G_NBD),
 };
 
 extern const struct opt_group *opt_group_from_mask(uint64_t *mask);
diff --git a/options.c b/options.c
index 95086074..f4c9bedf 100644
--- a/options.c
+++ b/options.c
@@ -1899,6 +1899,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "HTTP (WebDAV/S3) IO engine",
 			  },
 #endif
+			  { .ival = "nbd",
+			    .help = "Network Block Device (NBD) IO engine"
+			  },
 		},
 	},
 	{
-- 
2.22.0


