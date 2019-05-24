Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49278 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391195AbfEXMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 May 2019 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hU8rj-0008R4-J2
        for fio@vger.kernel.org; Fri, 24 May 2019 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190524120001.9ABE72C00A7@kernel.dk>
Date: Fri, 24 May 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit de5ed0e4d398bc9d4576f9b2b82d7686989c27e1:

  configure: add gettid() test (2019-05-22 17:12:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ce4d13ca162df4127ec3b5911553802c53396705:

  glusterfs: update for new API (2019-05-23 14:57:52 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      glusterfs: update for new API

 configure                 | 21 +++++++++++++++++++++
 engines/glusterfs.c       |  8 ++++++++
 engines/glusterfs_async.c |  5 +++++
 engines/glusterfs_sync.c  |  8 ++++++++
 4 files changed, 42 insertions(+)

---

Diff of recent changes:

diff --git a/configure b/configure
index ee421663..b0052dc1 100755
--- a/configure
+++ b/configure
@@ -1789,6 +1789,24 @@ fi
 print_config "Gluster API use fadvise" "$gf_fadvise"
 fi
 
+##########################################
+# check for newer gfapi
+if test "$gfapi" = "yes" ; then
+gf_new="no"
+cat > $TMPC << EOF
+#include <glusterfs/api/glfs.h>
+
+int main(int argc, char **argv)
+{
+  return glfs_fsync(NULL, NULL, NULL) && glfs_ftruncate(NULL, 0, NULL, NULL);
+}
+EOF
+if compile_prog "" "-lgfapi -lglusterfs" "gf new api"; then
+  gf_new="yes"
+fi
+print_config "Gluster new API" "$gf_new"
+fi
+
 ##########################################
 # check for gfapi trim support
 if test "$gf_trim" != "yes" ; then
@@ -2576,6 +2594,9 @@ fi
 if test "$gf_trim" = "yes" ; then
   output_sym "CONFIG_GF_TRIM"
 fi
+if test "$gf_new" = "yes" ; then
+  output_sym "CONFIG_GF_NEW_API"
+fi
 if test "$libhdfs" = "yes" ; then
   output_sym "CONFIG_LIBHDFS"
   echo "FIO_HDFS_CPU=$FIO_HDFS_CPU" >> $config_host_mak
diff --git a/engines/glusterfs.c b/engines/glusterfs.c
index d0250b70..f2b84a2a 100644
--- a/engines/glusterfs.c
+++ b/engines/glusterfs.c
@@ -288,7 +288,11 @@ int fio_gf_open_file(struct thread_data *td, struct fio_file *f)
 		    || sb.st_size < f->real_file_size) {
 			dprint(FD_FILE, "fio extend file %s from %jd to %" PRIu64 "\n",
 			       f->file_name, (intmax_t) sb.st_size, f->real_file_size);
+#if defined(CONFIG_GF_NEW_API)
+			ret = glfs_ftruncate(g->fd, f->real_file_size, NULL, NULL);
+#else
 			ret = glfs_ftruncate(g->fd, f->real_file_size);
+#endif
 			if (ret) {
 				log_err("failed fio extend file %s to %" PRIu64 "\n",
 					f->file_name, f->real_file_size);
@@ -350,7 +354,11 @@ int fio_gf_open_file(struct thread_data *td, struct fio_file *f)
 					       f->file_name);
 					glfs_unlink(g->fs, f->file_name);
 				} else if (td->o.create_fsync) {
+#if defined(CONFIG_GF_NEW_API)
+					if (glfs_fsync(g->fd, NULL, NULL) < 0) {
+#else
 					if (glfs_fsync(g->fd) < 0) {
+#endif
 						dprint(FD_FILE,
 						       "failed to sync, close %s\n",
 						       f->file_name);
diff --git a/engines/glusterfs_async.c b/engines/glusterfs_async.c
index 9e1c4bf0..0392ad6e 100644
--- a/engines/glusterfs_async.c
+++ b/engines/glusterfs_async.c
@@ -84,7 +84,12 @@ static int fio_gf_io_u_init(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
+#if defined(CONFIG_GF_NEW_API)
+static void gf_async_cb(glfs_fd_t * fd, ssize_t ret, struct glfs_stat *prestat,
+			struct glfs_stat *poststat, void *data)
+#else
 static void gf_async_cb(glfs_fd_t * fd, ssize_t ret, void *data)
+#endif
 {
 	struct io_u *io_u = data;
 	struct fio_gf_iou *iou = io_u->engine_data;
diff --git a/engines/glusterfs_sync.c b/engines/glusterfs_sync.c
index 099a5af1..de73261f 100644
--- a/engines/glusterfs_sync.c
+++ b/engines/glusterfs_sync.c
@@ -42,9 +42,17 @@ static enum fio_q_status fio_gf_queue(struct thread_data *td, struct io_u *io_u)
 	else if (io_u->ddir == DDIR_WRITE)
 		ret = glfs_write(g->fd, io_u->xfer_buf, io_u->xfer_buflen, 0);
 	else if (io_u->ddir == DDIR_SYNC)
+#if defined(CONFIG_GF_NEW_API)
+		ret = glfs_fsync(g->fd, NULL, NULL);
+#else
 		ret = glfs_fsync(g->fd);
+#endif
 	else if (io_u->ddir == DDIR_DATASYNC)
+#if defined(CONFIG_GF_NEW_API)
+		ret = glfs_fdatasync(g->fd, NULL, NULL);
+#else
 		ret = glfs_fdatasync(g->fd);
+#endif
 	else {
 		log_err("unsupported operation.\n");
 		io_u->error = EINVAL;

