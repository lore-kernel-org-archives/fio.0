Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59660 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaETMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 20 May 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WmiiD-0005Uh-53
	for fio@vger.kernel.org; Tue, 20 May 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140520120003.B406F40157@lyth.info>
Date: Tue, 20 May 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2c3fcd7bd67209e141e259b1fdd4585e8d91167c:

  Fio 2.1.9 (2014-05-12 17:18:13 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d9b100fc117a963334fb71b8b662be90cd456068:

  Add ->invalidate() IO engine ops (2014-05-19 19:57:05 -0600)

----------------------------------------------------------------
Christophe Vu-Brugier (1):
      Fix some typos in the manpage

Jens Axboe (5):
      Merge branch 'master' of git://github.com/rootfs/fio
      Merge branch 'master' of git://github.com/cvubrugier/fio
      Run the gluster engines through indent
      gfapi: indentify
      Add ->invalidate() IO engine ops

Xan Peng (1):
      Fix issue with dangling pointer in the rbd engine

chenh (10):
      Glusterfs libgfapi engine - initial deposit
      make glfs call per thread based
      respond to get file size
      respond to get file size
      fix get file size problem
      fix man page; fix read work
      extend file for real
      first async IO code drop
      second async IO code drop
      glusterfs api fadvise support

 Makefile                  |    8 ++
 configure                 |   45 +++++++
 engines/gfapi.h           |   22 ++++
 engines/glusterfs.c       |  285 +++++++++++++++++++++++++++++++++++++++++++++
 engines/glusterfs_async.c |  207 ++++++++++++++++++++++++++++++++
 engines/glusterfs_sync.c  |   93 +++++++++++++++
 engines/rbd.c             |   34 +++---
 filesetup.c               |    4 +-
 fio.1                     |   38 +++---
 ioengine.h                |    3 +-
 options.c                 |    9 ++
 options.h                 |    2 +
 12 files changed, 721 insertions(+), 29 deletions(-)
 create mode 100644 engines/gfapi.h
 create mode 100644 engines/glusterfs.c
 create mode 100644 engines/glusterfs_async.c
 create mode 100644 engines/glusterfs_sync.c

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index a0f0f71..59fae9c 100644
--- a/Makefile
+++ b/Makefile
@@ -91,6 +91,14 @@ endif
 ifndef CONFIG_INET_ATON
   SOURCE += lib/inet_aton.c
 endif
+ifdef CONFIG_GFAPI
+  SOURCE += engines/glusterfs.c
+  SOURCE += engines/glusterfs_sync.c
+  SOURCE += engines/glusterfs_async.c
+  ifdef CONFIG_GF_FADVISE
+    CFLAGS += "-DGFAPI_USE_FADVISE"
+  endif
+endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
diff --git a/configure b/configure
index 2ba1daf..d37e8b4 100755
--- a/configure
+++ b/configure
@@ -1165,6 +1165,45 @@ if compile_prog "" "" "setvbuf"; then
 fi
 echo "setvbuf                       $setvbuf"
 
+# check for gfapi
+gfapi="no"
+cat > $TMPC << EOF
+#include <glusterfs/api/glfs.h>
+
+int main(int argc, char **argv)
+{
+
+  glfs_t *g = glfs_new("foo");
+
+  return 0;
+}
+EOF
+if compile_prog "" "-lgfapi -lglusterfs" "gfapi"; then
+  LIBS="-lgfapi -lglusterfs $LIBS"
+  gfapi="yes"
+fi
+ echo "Gluster API engine            $gfapi"
+
+##########################################
+# check for gfapi fadvise support
+gf_fadvise="no"
+cat > $TMPC << EOF
+#include <glusterfs/api/glfs.h>
+
+int main(int argc, char **argv)
+{
+  struct glfs_fd *fd;
+  int ret = glfs_fadvise(fd, 0, 0, 1);
+
+  return 0;
+}
+EOF
+
+if compile_prog "" "-lgfapi -lglusterfs" "gfapi"; then
+  gf_fadvise="yes"
+fi
+echo "Gluster API use fadvise       $gf_fadvise"
+
 ##########################################
 # Check if we support stckf on s390
 s390_z196_facilities="no"
@@ -1326,6 +1365,12 @@ if test "$s390_z196_facilities" = "yes" ; then
   output_sym "CONFIG_S390_Z196_FACILITIES"
   CFLAGS="$CFLAGS -march=z9-109"
 fi
+if test "$gfapi" = "yes" ; then
+  output_sym "CONFIG_GFAPI"
+fi
+if test "$gf_fadvise" = "yes" ; then
+  output_sym "CONFIG_GF_FADVISE"
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "CFLAGS+=$CFLAGS" >> $config_host_mak
diff --git a/engines/gfapi.h b/engines/gfapi.h
new file mode 100644
index 0000000..f8acb98
--- /dev/null
+++ b/engines/gfapi.h
@@ -0,0 +1,22 @@
+#include <glusterfs/api/glfs.h>
+#include <glusterfs/api/glfs-handles.h>
+#include "../fio.h"
+
+struct gf_options {
+	struct thread_data *td;
+	char *gf_vol;
+	char *gf_brick;
+};
+
+struct gf_data {
+	glfs_t *fs;
+	glfs_fd_t *fd;
+	struct io_u **aio_events;
+};
+
+extern struct fio_option gfapi_options[];
+extern int fio_gf_setup(struct thread_data *td);
+extern void fio_gf_cleanup(struct thread_data *td);
+extern int fio_gf_get_file_size(struct thread_data *td, struct fio_file *f);
+extern int fio_gf_open_file(struct thread_data *td, struct fio_file *f);
+extern int fio_gf_close_file(struct thread_data *td, struct fio_file *f);
diff --git a/engines/glusterfs.c b/engines/glusterfs.c
new file mode 100644
index 0000000..b233b20
--- /dev/null
+++ b/engines/glusterfs.c
@@ -0,0 +1,285 @@
+/*
+ * glusterfs engine
+ *
+ * common Glusterfs's gfapi interface
+ *
+ */
+
+#include "gfapi.h"
+
+struct fio_option gfapi_options[] = {
+	{
+	 .name = "volume",
+	 .lname = "Glusterfs volume",
+	 .type = FIO_OPT_STR_STORE,
+	 .help = "Name of the Glusterfs volume",
+	 .off1 = offsetof(struct gf_options, gf_vol),
+	 .category = FIO_OPT_C_ENGINE,
+	 .group = FIO_OPT_G_GFAPI,
+	 },
+	{
+	 .name = "brick",
+	 .lname = "Glusterfs brick name",
+	 .type = FIO_OPT_STR_STORE,
+	 .help = "Name of the Glusterfs brick to connect",
+	 .off1 = offsetof(struct gf_options, gf_brick),
+	 .category = FIO_OPT_C_ENGINE,
+	 .group = FIO_OPT_G_GFAPI,
+	 },
+	{
+	 .name = NULL,
+	 },
+};
+
+int fio_gf_setup(struct thread_data *td)
+{
+	int r = 0;
+	struct gf_data *g = NULL;
+	struct gf_options *opt = td->eo;
+	struct stat sb = { 0, };
+
+	dprint(FD_IO, "fio setup\n");
+
+	if (td->io_ops->data)
+		return 0;
+
+	g = malloc(sizeof(struct gf_data));
+	if (!g) {
+		log_err("malloc failed.\n");
+		return -ENOMEM;
+	}
+	g->fs = NULL;
+	g->fd = NULL;
+	g->aio_events = NULL;
+
+	g->fs = glfs_new(opt->gf_vol);
+	if (!g->fs) {
+		log_err("glfs_new failed.\n");
+		goto cleanup;
+	}
+	glfs_set_logging(g->fs, "/tmp/fio_gfapi.log", 7);
+	/* default to tcp */
+	r = glfs_set_volfile_server(g->fs, "tcp", opt->gf_brick, 0);
+	if (r) {
+		log_err("glfs_set_volfile_server failed.\n");
+		goto cleanup;
+	}
+	r = glfs_init(g->fs);
+	if (r) {
+		log_err("glfs_init failed. Is glusterd running on brick?\n");
+		goto cleanup;
+	}
+	sleep(2);
+	r = glfs_lstat(g->fs, ".", &sb);
+	if (r) {
+		log_err("glfs_lstat failed.\n");
+		goto cleanup;
+	}
+	dprint(FD_FILE, "fio setup %p\n", g->fs);
+	td->io_ops->data = g;
+cleanup:
+	if (r) {
+		if (g) {
+			if (g->fs) {
+				glfs_fini(g->fs);
+			}
+			free(g);
+			td->io_ops->data = NULL;
+		}
+	}
+	return r;
+}
+
+void fio_gf_cleanup(struct thread_data *td)
+{
+	struct gf_data *g = td->io_ops->data;
+
+	if (g) {
+		if (g->aio_events)
+			free(g->aio_events);
+		if (g->fd)
+			glfs_close(g->fd);
+		if (g->fs)
+			glfs_fini(g->fs);
+		free(g);
+		td->io_ops->data = NULL;
+	}
+}
+
+int fio_gf_get_file_size(struct thread_data *td, struct fio_file *f)
+{
+	struct stat buf;
+	int ret;
+	struct gf_data *g = td->io_ops->data;
+
+	dprint(FD_FILE, "get file size %s\n", f->file_name);
+
+	if (!g || !g->fs) {
+		return 0;
+	}
+	if (fio_file_size_known(f))
+		return 0;
+
+	ret = glfs_lstat(g->fs, f->file_name, &buf);
+	if (ret < 0) {
+		log_err("glfs_lstat failed.\n");
+		return ret;
+	}
+
+	f->real_file_size = buf.st_size;
+	fio_file_set_size_known(f);
+
+	return 0;
+
+}
+
+int fio_gf_open_file(struct thread_data *td, struct fio_file *f)
+{
+
+	int flags = 0;
+	int ret = 0;
+	struct gf_data *g = td->io_ops->data;
+	struct stat sb = { 0, };
+
+	if (td_write(td)) {
+		if (!read_only)
+			flags = O_RDWR;
+	} else if (td_read(td)) {
+		if (!read_only)
+			flags = O_RDWR;
+		else
+			flags = O_RDONLY;
+	}
+	dprint(FD_FILE, "fio file %s open mode %s td rw %s\n", f->file_name,
+	       flags == O_RDONLY ? "ro" : "rw", td_read(td) ? "read" : "write");
+	g->fd = glfs_creat(g->fs, f->file_name, flags, 0644);
+	if (!g->fd) {
+		log_err("glfs_creat failed.\n");
+		ret = errno;
+	}
+	/* file for read doesn't exist or shorter than required, create/extend it */
+	if (td_read(td)) {
+		if (glfs_lstat(g->fs, f->file_name, &sb)
+		    || sb.st_size < f->real_file_size) {
+			dprint(FD_FILE, "fio extend file %s from %ld to %ld\n",
+			       f->file_name, sb.st_size, f->real_file_size);
+			ret = glfs_ftruncate(g->fd, f->real_file_size);
+			if (ret) {
+				log_err("failed fio extend file %s to %ld\n",
+					f->file_name, f->real_file_size);
+			} else {
+				unsigned long long left;
+				unsigned int bs;
+				char *b;
+				int r;
+
+				/* fill the file, copied from extend_file */
+				b = malloc(td->o.max_bs[DDIR_WRITE]);
+
+				left = f->real_file_size;
+				while (left && !td->terminate) {
+					bs = td->o.max_bs[DDIR_WRITE];
+					if (bs > left)
+						bs = left;
+
+					fill_io_buffer(td, b, bs, bs);
+
+					r = glfs_write(g->fd, b, bs, 0);
+					dprint(FD_IO,
+					       "fio write %d of %ld file %s\n",
+					       r, f->real_file_size,
+					       f->file_name);
+
+					if (r > 0) {
+						left -= r;
+						continue;
+					} else {
+						if (r < 0) {
+							int __e = errno;
+
+							if (__e == ENOSPC) {
+								if (td->o.
+								    fill_device)
+									break;
+								log_info
+								    ("fio: ENOSPC on laying out "
+								     "file, stopping\n");
+								break;
+							}
+							td_verror(td, errno,
+								  "write");
+						} else
+							td_verror(td, EIO,
+								  "write");
+
+						break;
+					}
+				}
+
+				if (b)
+					free(b);
+				glfs_lseek(g->fd, 0, SEEK_SET);
+
+				if (td->terminate) {
+					dprint(FD_FILE, "terminate unlink %s\n",
+					       f->file_name);
+					unlink(f->file_name);
+				} else if (td->o.create_fsync) {
+					if (glfs_fsync(g->fd) < 0) {
+						dprint(FD_FILE,
+						       "failed to sync, close %s\n",
+						       f->file_name);
+						td_verror(td, errno, "fsync");
+						glfs_close(g->fd);
+						g->fd = NULL;
+						return 1;
+					}
+				}
+			}
+		}
+	}
+#if defined(GFAPI_USE_FADVISE)
+	{
+		int r = 0;
+		if (td_random(td)) {
+			r = glfs_fadvise(g->fd, 0, f->real_file_size,
+					 POSIX_FADV_RANDOM);
+		} else {
+			r = glfs_fadvise(g->fd, 0, f->real_file_size,
+					 POSIX_FADV_SEQUENTIAL);
+		}
+		if (r) {
+			dprint(FD_FILE, "fio %p fadvise %s status %d\n", g->fs,
+			       f->file_name, r);
+		}
+	}
+#endif
+	dprint(FD_FILE, "fio %p created %s\n", g->fs, f->file_name);
+	f->fd = -1;
+	f->shadow_fd = -1;
+
+	return ret;
+}
+
+int fio_gf_close_file(struct thread_data *td, struct fio_file *f)
+{
+	int ret = 0;
+	struct gf_data *g = td->io_ops->data;
+
+	dprint(FD_FILE, "fd close %s\n", f->file_name);
+
+	if (g) {
+		if (g->fd && glfs_close(g->fd) < 0)
+			ret = errno;
+
+		if (g->fs)
+			glfs_fini(g->fs);
+
+		g->fd = NULL;
+		free(g);
+	}
+	td->io_ops->data = NULL;
+	f->engine_data = 0;
+
+	return ret;
+}
diff --git a/engines/glusterfs_async.c b/engines/glusterfs_async.c
new file mode 100644
index 0000000..30f1719
--- /dev/null
+++ b/engines/glusterfs_async.c
@@ -0,0 +1,207 @@
+/*
+ * glusterfs engine
+ *
+ * IO engine using Glusterfs's gfapi async interface
+ *
+ */
+#include "gfapi.h"
+#define NOT_YET 1
+struct fio_gf_iou {
+	struct io_u *io_u;
+	int io_complete;
+};
+static ulong cb_count = 0, issued = 0;
+
+static struct io_u *fio_gf_event(struct thread_data *td, int event)
+{
+	struct gf_data *gf_data = td->io_ops->data;
+	dprint(FD_IO, "%s\n", __FUNCTION__);
+	return gf_data->aio_events[event];
+}
+
+static int fio_gf_getevents(struct thread_data *td, unsigned int min,
+			    unsigned int max, struct timespec *t)
+{
+	struct gf_data *g = td->io_ops->data;
+	unsigned int events = 0;
+	struct io_u *io_u;
+	int i = 0;
+	struct fio_gf_iou *io = NULL;
+
+	dprint(FD_IO, "%s\n", __FUNCTION__);
+	do {
+		io_u_qiter(&td->io_u_all, io_u, i) {
+			if (!(io_u->flags & IO_U_F_FLIGHT))
+				continue;
+
+			io = (struct fio_gf_iou *)io_u->engine_data;
+
+			if (io && io->io_complete) {
+				io->io_complete = 0;
+				g->aio_events[events] = io_u;
+				events++;
+
+				if (events >= max)
+					break;
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
+static void fio_gf_io_u_free(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_gf_iou *io = io_u->engine_data;
+
+	if (io) {
+		if (io->io_complete) {
+			log_err("incomplete IO found.\n");
+		}
+		io_u->engine_data = NULL;
+		free(io);
+	}
+	fprintf(stderr, "issued %lu finished %lu\n", issued, cb_count);
+}
+
+static int fio_gf_io_u_init(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_gf_iou *io = NULL;
+
+	dprint(FD_FILE, "%s\n", __FUNCTION__);
+
+	if (!io_u->engine_data) {
+		io = malloc(sizeof(struct fio_gf_iou));
+		if (!io) {
+			td_verror(td, errno, "malloc");
+			return 1;
+		}
+		io->io_complete = 0;
+		io->io_u = io_u;
+		io_u->engine_data = io;
+	}
+	return 0;
+}
+
+static void gf_async_cb(glfs_fd_t * fd, ssize_t ret, void *data)
+{
+	struct io_u *io_u = (struct io_u *)data;
+	struct fio_gf_iou *iou = (struct fio_gf_iou *)io_u->engine_data;
+
+	dprint(FD_IO, "%s ret %lu\n", __FUNCTION__, ret);
+	iou->io_complete = 1;
+	cb_count++;
+}
+
+static int fio_gf_async_queue(struct thread_data fio_unused * td,
+			      struct io_u *io_u)
+{
+	struct gf_data *g = td->io_ops->data;
+	int r = 0;
+
+	dprint(FD_IO, "%s op %s\n", __FUNCTION__,
+	       io_u->ddir == DDIR_READ ? "read" : io_u->ddir ==
+	       DDIR_WRITE ? "write" : io_u->ddir ==
+	       DDIR_SYNC ? "sync" : "unknown");
+
+	fio_ro_check(td, io_u);
+
+	if (io_u->ddir == DDIR_READ)
+		r = glfs_pread_async(g->fd, io_u->xfer_buf, io_u->xfer_buflen,
+				     io_u->offset, 0, gf_async_cb,
+				     (void *)io_u);
+	else if (io_u->ddir == DDIR_WRITE)
+		r = glfs_pwrite_async(g->fd, io_u->xfer_buf, io_u->xfer_buflen,
+				      io_u->offset, 0, gf_async_cb,
+				      (void *)io_u);
+	else if (io_u->ddir == DDIR_SYNC) {
+		r = glfs_fsync_async(g->fd, gf_async_cb, (void *)io_u);
+	} else {
+		log_err("unsupported operation.\n");
+		io_u->error = -EINVAL;
+		goto failed;
+	}
+	if (r) {
+		log_err("glfs failed.\n");
+		io_u->error = r;
+		goto failed;
+	}
+	issued++;
+	return FIO_Q_QUEUED;
+
+failed:
+	io_u->error = r;
+	td_verror(td, io_u->error, "xfer");
+	return FIO_Q_COMPLETED;
+}
+
+int fio_gf_async_setup(struct thread_data *td)
+{
+	int r = 0;
+	struct gf_data *g = NULL;
+#if defined(NOT_YET)
+	fprintf(stderr, "the async interface is still very experimental...\n");
+#endif
+	r = fio_gf_setup(td);
+	if (r) {
+		return r;
+	}
+	td->o.use_thread = 1;
+	g = td->io_ops->data;
+	g->aio_events = malloc(td->o.iodepth * sizeof(struct io_u *));
+	if (!g->aio_events) {
+		r = -ENOMEM;
+		fio_gf_cleanup(td);
+		return r;
+	}
+
+	memset(g->aio_events, 0, td->o.iodepth * sizeof(struct io_u *));
+
+	return r;
+
+}
+
+static int fio_gf_async_prep(struct thread_data *td, struct io_u *io_u)
+{
+	dprint(FD_FILE, "%s\n", __FUNCTION__);
+
+	if (!ddir_rw(io_u->ddir))
+		return 0;
+
+	return 0;
+}
+
+static struct ioengine_ops ioengine = {
+	.name = "gfapi_async",
+	.version = FIO_IOOPS_VERSION,
+	.init = fio_gf_async_setup,
+	.cleanup = fio_gf_cleanup,
+	.prep = fio_gf_async_prep,
+	.queue = fio_gf_async_queue,
+	.open_file = fio_gf_open_file,
+	.close_file = fio_gf_close_file,
+	.get_file_size = fio_gf_get_file_size,
+	.getevents = fio_gf_getevents,
+	.event = fio_gf_event,
+	.io_u_init = fio_gf_io_u_init,
+	.io_u_free = fio_gf_io_u_free,
+	.options = gfapi_options,
+	.option_struct_size = sizeof(struct gf_options),
+	.flags = FIO_DISKLESSIO,
+};
+
+static void fio_init fio_gf_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_gf_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/engines/glusterfs_sync.c b/engines/glusterfs_sync.c
new file mode 100644
index 0000000..938baf4
--- /dev/null
+++ b/engines/glusterfs_sync.c
@@ -0,0 +1,93 @@
+/*
+ * glusterfs engine
+ *
+ * IO engine using Glusterfs's gfapi sync interface
+ *
+ */
+
+#include "gfapi.h"
+
+#define LAST_POS(f)	((f)->engine_data)
+static int fio_gf_prep(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+	struct gf_data *g = td->io_ops->data;
+
+	dprint(FD_FILE, "fio prep\n");
+
+	if (!ddir_rw(io_u->ddir))
+		return 0;
+
+	if (LAST_POS(f) != -1ULL && LAST_POS(f) == io_u->offset)
+		return 0;
+
+	if (glfs_lseek(g->fd, io_u->offset, SEEK_SET) < 0) {
+		td_verror(td, errno, "lseek");
+		return 1;
+	}
+
+	return 0;
+}
+
+static int fio_gf_queue(struct thread_data *td, struct io_u *io_u)
+{
+	struct gf_data *g = td->io_ops->data;
+	int ret = 0;
+
+	dprint(FD_FILE, "fio queue len %lu\n", io_u->xfer_buflen);
+	fio_ro_check(td, io_u);
+
+	if (io_u->ddir == DDIR_READ)
+		ret = glfs_read(g->fd, io_u->xfer_buf, io_u->xfer_buflen, 0);
+	else if (io_u->ddir == DDIR_WRITE)
+		ret = glfs_write(g->fd, io_u->xfer_buf, io_u->xfer_buflen, 0);
+	else {
+		log_err("unsupported operation.\n");
+		return -EINVAL;
+	}
+	dprint(FD_FILE, "fio len %lu ret %d\n", io_u->xfer_buflen, ret);
+	if (io_u->file && ret >= 0 && ddir_rw(io_u->ddir))
+		LAST_POS(io_u->file) = io_u->offset + ret;
+
+	if (ret != (int)io_u->xfer_buflen) {
+		if (ret >= 0) {
+			io_u->resid = io_u->xfer_buflen - ret;
+			io_u->error = 0;
+			return FIO_Q_COMPLETED;
+		} else
+			io_u->error = errno;
+	}
+
+	if (io_u->error) {
+		log_err("IO failed.\n");
+		td_verror(td, io_u->error, "xfer");
+	}
+
+	return FIO_Q_COMPLETED;
+
+}
+
+static struct ioengine_ops ioengine = {
+	.name = "gfapi",
+	.version = FIO_IOOPS_VERSION,
+	.init = fio_gf_setup,
+	.cleanup = fio_gf_cleanup,
+	.prep = fio_gf_prep,
+	.queue = fio_gf_queue,
+	.open_file = fio_gf_open_file,
+	.close_file = fio_gf_close_file,
+	.get_file_size = fio_gf_get_file_size,
+	.options = gfapi_options,
+	.option_struct_size = sizeof(struct gf_options),
+	.flags = FIO_SYNCIO | FIO_DISKLESSIO,
+};
+
+static void fio_init fio_gf_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_gf_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/engines/rbd.c b/engines/rbd.c
index ff35373..d006123 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -131,8 +131,10 @@ static int _fio_rbd_connect(struct thread_data *td)
 
 failed_open:
 	rados_ioctx_destroy(rbd_data->io_ctx);
+	rbd_data->io_ctx = NULL;
 failed_shutdown:
 	rados_shutdown(rbd_data->cluster);
+	rbd_data->cluster = NULL;
 failed_early:
 	return 1;
 }
@@ -402,6 +404,11 @@ static int fio_rbd_open(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
+static int fio_rbd_invalidate(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+
 static void fio_rbd_io_u_free(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_rbd_iou *o = io_u->engine_data;
@@ -424,19 +431,20 @@ static int fio_rbd_io_u_init(struct thread_data *td, struct io_u *io_u)
 }
 
 static struct ioengine_ops ioengine = {
-	.name               = "rbd",
-	.version            = FIO_IOOPS_VERSION,
-	.setup              = fio_rbd_setup,
-	.init               = fio_rbd_init,
-	.queue              = fio_rbd_queue,
-	.getevents          = fio_rbd_getevents,
-	.event              = fio_rbd_event,
-	.cleanup            = fio_rbd_cleanup,
-	.open_file          = fio_rbd_open,
-	.options            = options,
-	.io_u_init          = fio_rbd_io_u_init,
-	.io_u_free          = fio_rbd_io_u_free,
-	.option_struct_size = sizeof(struct rbd_options),
+	.name			= "rbd",
+	.version		= FIO_IOOPS_VERSION,
+	.setup			= fio_rbd_setup,
+	.init			= fio_rbd_init,
+	.queue			= fio_rbd_queue,
+	.getevents		= fio_rbd_getevents,
+	.event			= fio_rbd_event,
+	.cleanup		= fio_rbd_cleanup,
+	.open_file		= fio_rbd_open,
+	.invalidate		= fio_rbd_invalidate,
+	.options		= options,
+	.io_u_init		= fio_rbd_io_u_init,
+	.io_u_free		= fio_rbd_io_u_free,
+	.option_struct_size	= sizeof(struct rbd_options),
 };
 
 static void fio_init fio_rbd_register(void)
diff --git a/filesetup.c b/filesetup.c
index ad7fb85..84eaed6 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -401,7 +401,9 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 	dprint(FD_IO, "invalidate cache %s: %llu/%llu\n", f->file_name, off,
 								len);
 
-	if (f->mmap_ptr) {
+	if (td->io_ops->invalidate)
+		ret = td->io_ops->invalidate(td, f);
+	else if (f->mmap_ptr) {
 		ret = posix_madvise(f->mmap_ptr, f->mmap_sz, POSIX_MADV_DONTNEED);
 #ifdef FIO_MADV_FREE
 		if (f->filetype == FIO_TYPE_BD)
diff --git a/fio.1 b/fio.1
index eeb036e..62f40ea 100644
--- a/fio.1
+++ b/fio.1
@@ -75,7 +75,7 @@ Report full output status every `time` period passed.
 Turn on safety read-only checks, preventing any attempted write.
 .TP
 .BI \-\-section \fR=\fPsec
-Only run section \fIsec\fR from job file. Multiple of these options can be given, adding more sections to run.
+Only run section \fIsec\fR from job file. This option can be used multiple times to add more sections to run.
 .TP
 .BI \-\-alloc\-size \fR=\fPkb
 Set the internal smalloc pool size to \fIkb\fP kilobytes.
@@ -225,7 +225,7 @@ The lock modes are:
 No locking. This is the default.
 .TP
 .B exclusive
-Only one thread or process may do IO at the time, excluding all others.
+Only one thread or process may do IO at a time, excluding all others.
 .TP
 .B readwrite
 Read-write locking on the file. Many readers may access the file at the same
@@ -310,7 +310,7 @@ reasons. Allowed values are 1024 or 1000, with 1024 being the default.
 .BI unified_rw_reporting \fR=\fPbool
 Fio normally reports statistics on a per data direction basis, meaning that
 read, write, and trim are accounted and reported separately. If this option is
-set, the fio will sum the results and report them as "mixed" instead.
+set fio sums the results and reports them as "mixed" instead.
 .TP
 .BI randrepeat \fR=\fPbool
 Seed the random number generator used for random I/O patterns in a predictable
@@ -326,8 +326,8 @@ control what sequence of output is being generated. If not set, the random
 sequence depends on the \fBrandrepeat\fR setting.
 .TP
 .BI use_os_rand \fR=\fPbool
-Fio can either use the random generator supplied by the OS to generator random
-offsets, or it can use it's own internal generator (based on Tausworthe).
+Fio can either use the random generator supplied by the OS to generate random
+offsets, or it can use its own internal generator (based on Tausworthe).
 Default is to use the internal generator, which is often of better quality and
 faster. Default: false.
 .TP
@@ -359,7 +359,7 @@ because ZFS doesn't support it. Default: 'posix'.
 .RE
 .TP
 .BI fadvise_hint \fR=\fPbool
-Use of \fBposix_fadvise\fR\|(2) to advise the kernel what I/O patterns
+Use \fBposix_fadvise\fR\|(2) to advise the kernel what I/O patterns
 are likely to be issued. Default: true.
 .TP
 .BI size \fR=\fPint
@@ -443,7 +443,7 @@ blocksize settings, and any sequential read or write will use the READ
 blocksize setting.
 .TP
 .B zero_buffers
-Initialise buffers with all zeros. Default: fill buffers with random data.
+Initialize buffers with all zeros. Default: fill buffers with random data.
 The resulting IO buffers will not be completely zeroed, unless
 \fPscramble_buffers\fR is also turned off.
 .TP
@@ -475,8 +475,8 @@ the remaining zeroed. With this set to some chunk size smaller than the block
 size, fio can alternate random and zeroed data throughout the IO buffer.
 .TP
 .BI buffer_pattern \fR=\fPstr
-If set, fio will fill the io buffers with this pattern. If not set, the contents
-of io buffers is defined by the other options related to buffer contents. The
+If set, fio will fill the IO buffers with this pattern. If not set, the contents
+of IO buffers is defined by the other options related to buffer contents. The
 setting can be any pattern of bytes, and can be prefixed with 0x for hex
 values.
 .TP
@@ -495,13 +495,13 @@ Defines how files to service are selected.  The following types are defined:
 Choose a file at random.
 .TP
 .B roundrobin
-Round robin over open files (default).
+Round robin over opened files (default).
 .TP
 .B sequential
 Do each file in the set sequentially.
 .RE
 .P
-The number of I/Os to issue before switching a new file can be specified by
+The number of I/Os to issue before switching to a new file can be specified by
 appending `:\fIint\fR' to the service type.
 .RE
 .TP
@@ -602,6 +602,16 @@ request to DDIR_WRITE event
 IO engine supporting direct access to Ceph Rados Block Devices (RBD) via librbd 
 without the need to use the kernel rbd driver. This ioengine defines engine specific 
 options.
+.TP
+.B gfapi
+Using Glusterfs libgfapi sync interface to direct access to Glusterfs volumes without
+having to go through FUSE. This ioengine defines engine specific
+options.
+.TP
+.B gfapi_async
+Using Glusterfs libgfapi async interface to direct access to Glusterfs volumes without
+having to go through FUSE. This ioengine defines engine specific
+options.
 .RE
 .P
 .RE
@@ -609,7 +619,7 @@ options.
 .BI iodepth \fR=\fPint
 Number of I/O units to keep in flight against the file. Note that increasing
 iodepth beyond 1 will not affect synchronous ioengines (except for small
-degress when verify_async is in use). Even async engines my impose OS
+degress when verify_async is in use). Even async engines may impose OS
 restrictions causing the desired depth not to be achieved.  This may happen on
 Linux when using libaio and not setting \fBdirect\fR=1, since buffered IO is
 not async on that OS. Keep an eye on the IO depth distribution in the
@@ -1367,7 +1377,7 @@ the observed latencies fell, respectively.
 .SS "Ioengine Parameters List"
 Some parameters are only valid when a specific ioengine is in use. These are
 used identically to normal parameters, with the caveat that when used on the
-command line, the must come after the ioengine that defines them is selected.
+command line, they must come after the ioengine.
 .TP
 .BI (cpu)cpuload \fR=\fPint
 Attempt to use the specified percentage of CPU cycles.
@@ -1438,7 +1448,7 @@ hostname must be omitted if this option is used.
 .TP
 .BI (net, pingpong) \fR=\fPbool
 Normally a network writer will just continue writing data, and a network reader
-will just consume packages. If pingpong=1 is set, a writer will send its normal
+will just consume packets. If pingpong=1 is set, a writer will send its normal
 payload to the reader, then wait for the reader to send the same payload back.
 This allows fio to measure network latencies. The submission and completion
 latencies then measure local time spent sending or receiving, and the
diff --git a/ioengine.h b/ioengine.h
index 6e3c717..37bf5fc 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -15,7 +15,7 @@
 #include <guasi.h>
 #endif
 
-#define FIO_IOOPS_VERSION	18
+#define FIO_IOOPS_VERSION	19
 
 enum {
 	IO_U_F_FREE		= 1 << 0,
@@ -143,6 +143,7 @@ struct ioengine_ops {
 	void (*cleanup)(struct thread_data *);
 	int (*open_file)(struct thread_data *, struct fio_file *);
 	int (*close_file)(struct thread_data *, struct fio_file *);
+	int (*invalidate)(struct thread_data *, struct fio_file *);
 	int (*get_file_size)(struct thread_data *, struct fio_file *);
 	void (*terminate)(struct thread_data *);
 	int (*io_u_init)(struct thread_data *, struct io_u *);
diff --git a/options.c b/options.c
index 9dcb255..d5bf00c 100644
--- a/options.c
+++ b/options.c
@@ -1533,6 +1533,15 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "fallocate() file based engine",
 			  },
 #endif
+#ifdef CONFIG_GFAPI
+			  { .ival = "gfapi",
+			    .help = "Glusterfs libgfapi(sync) based engine"
+			  },
+			  { .ival = "gfapi_async",
+			    .help = "Glusterfs libgfapi(async) based engine"
+			  },
+#endif
+
 			  { .ival = "external",
 			    .help = "Load external engine (append name)",
 			  },
diff --git a/options.h b/options.h
index de9f610..b2e2c0c 100644
--- a/options.h
+++ b/options.h
@@ -98,6 +98,7 @@ enum opt_category_group {
 	__FIO_OPT_G_ACT,
 	__FIO_OPT_G_LATPROF,
         __FIO_OPT_G_RBD,
+        __FIO_OPT_G_GFAPI,
 	__FIO_OPT_G_NR,
 
 	FIO_OPT_G_RATE		= (1U << __FIO_OPT_G_RATE),
@@ -128,6 +129,7 @@ enum opt_category_group {
 	FIO_OPT_G_ACT		= (1U << __FIO_OPT_G_ACT),
 	FIO_OPT_G_LATPROF	= (1U << __FIO_OPT_G_LATPROF),
 	FIO_OPT_G_RBD		= (1U << __FIO_OPT_G_RBD),
+	FIO_OPT_G_GFAPI		= (1U << __FIO_OPT_G_GFAPI),
 	FIO_OPT_G_INVALID	= (1U << __FIO_OPT_G_NR),
 };
 
