Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57536 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752578AbeDUMAT (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 21 Apr 2018 08:00:19 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1f9rBi-0006i1-Dp
        for fio@vger.kernel.org; Sat, 21 Apr 2018 12:00:18 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180421120002.3D6C22C006C@kernel.dk>
Date: Sat, 21 Apr 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6897af4622fec753b5b76a4f2f7865dd56550ea4:

  Remove verifysort/verifysort_nr from documentation (2018-04-18 10:52:00 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2e4ef4fbd69eb6d4c07f2f362463e3f3df2e808c:

  engines: fixup fio_q_status style violations (2018-04-20 09:46:19 -0600)

----------------------------------------------------------------
Bart Van Assche (7):
      Declare stat_calc_lat_nu() static
      Introduce enum n2s_unit
      Simplify num2str()
      Change return type of td_io_commit() into void
      gfapi: Make fio_gf_queue() set the I/O unit error status instead of returning -EINVAL
      Remove dead code from fio_io_sync()
      Introduce enum fio_q_status

Jens Axboe (2):
      Merge branch 'master' of https://github.com/bvanassche/fio
      engines: fixup fio_q_status style violations

 backend.c                   | 29 +++++++++++------------------
 engines/cpu.c               |  3 ++-
 engines/dev-dax.c           |  3 ++-
 engines/e4defrag.c          |  3 ++-
 engines/falloc.c            |  6 ++++--
 engines/filecreate.c        |  3 ++-
 engines/ftruncate.c         |  6 ++++--
 engines/fusion-aw.c         |  2 +-
 engines/glusterfs_async.c   |  4 ++--
 engines/glusterfs_sync.c    |  5 +++--
 engines/guasi.c             |  3 ++-
 engines/libaio.c            |  3 ++-
 engines/libhdfs.c           |  3 ++-
 engines/libpmem.c           |  3 ++-
 engines/mmap.c              |  3 ++-
 engines/mtd.c               |  3 ++-
 engines/net.c               |  8 +++++---
 engines/null.c              |  7 ++++---
 engines/pmemblk.c           |  3 ++-
 engines/posixaio.c          |  4 ++--
 engines/rados.c             |  3 ++-
 engines/rbd.c               |  3 ++-
 engines/rdma.c              |  3 ++-
 engines/sg.c                |  8 +++++---
 engines/skeleton_external.c |  3 ++-
 engines/splice.c            |  3 ++-
 engines/sync.c              | 16 ++++++++++------
 engines/windowsaio.c        |  3 ++-
 init.c                      |  6 +++---
 io_u.c                      |  7 ++-----
 ioengines.c                 | 19 ++++++-------------
 ioengines.h                 | 10 +++++-----
 lib/num2str.c               | 27 ++++++++++++++++-----------
 lib/num2str.h               | 18 ++++++++++--------
 options.c                   |  6 +++---
 stat.c                      |  2 +-
 36 files changed, 131 insertions(+), 110 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index a2a0b3d..d5cb6ef 100644
--- a/backend.c
+++ b/backend.c
@@ -268,7 +268,7 @@ static void cleanup_pending_aio(struct thread_data *td)
 static bool fio_io_sync(struct thread_data *td, struct fio_file *f)
 {
 	struct io_u *io_u = __get_io_u(td);
-	int ret;
+	enum fio_q_status ret;
 
 	if (!io_u)
 		return true;
@@ -283,16 +283,13 @@ static bool fio_io_sync(struct thread_data *td, struct fio_file *f)
 
 requeue:
 	ret = td_io_queue(td, io_u);
-	if (ret < 0) {
-		td_verror(td, io_u->error, "td_io_queue");
-		put_io_u(td, io_u);
-		return true;
-	} else if (ret == FIO_Q_QUEUED) {
-		if (td_io_commit(td))
-			return true;
+	switch (ret) {
+	case FIO_Q_QUEUED:
+		td_io_commit(td);
 		if (io_u_queued_complete(td, 1) < 0)
 			return true;
-	} else if (ret == FIO_Q_COMPLETED) {
+		break;
+	case FIO_Q_COMPLETED:
 		if (io_u->error) {
 			td_verror(td, io_u->error, "td_io_queue");
 			return true;
@@ -300,9 +297,9 @@ requeue:
 
 		if (io_u_sync_complete(td, io_u) < 0)
 			return true;
-	} else if (ret == FIO_Q_BUSY) {
-		if (td_io_commit(td))
-			return true;
+		break;
+	case FIO_Q_BUSY:
+		td_io_commit(td);
 		goto requeue;
 	}
 
@@ -453,8 +450,6 @@ int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 		   enum fio_ddir ddir, uint64_t *bytes_issued, int from_verify,
 		   struct timespec *comp_time)
 {
-	int ret2;
-
 	switch (*ret) {
 	case FIO_Q_COMPLETED:
 		if (io_u->error) {
@@ -530,9 +525,7 @@ sync_done:
 		if (!from_verify)
 			unlog_io_piece(td, io_u);
 		requeue_io_u(td, &io_u);
-		ret2 = td_io_commit(td);
-		if (ret2 < 0)
-			*ret = ret2;
+		td_io_commit(td);
 		break;
 	default:
 		assert(*ret < 0);
@@ -605,7 +598,7 @@ static bool in_flight_overlap(struct io_u_queue *q, struct io_u *io_u)
 	return overlap;
 }
 
-static int io_u_submit(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status io_u_submit(struct thread_data *td, struct io_u *io_u)
 {
 	/*
 	 * Check for overlap if the user asked us to, and we have
diff --git a/engines/cpu.c b/engines/cpu.c
index d0b4a89..0987250 100644
--- a/engines/cpu.c
+++ b/engines/cpu.c
@@ -53,7 +53,8 @@ static struct fio_option options[] = {
 };
 
 
-static int fio_cpuio_queue(struct thread_data *td, struct io_u fio_unused *io_u)
+static enum fio_q_status fio_cpuio_queue(struct thread_data *td,
+					 struct io_u fio_unused *io_u)
 {
 	struct cpu_options *co = td->eo;
 
diff --git a/engines/dev-dax.c b/engines/dev-dax.c
index caae1e0..0660bba 100644
--- a/engines/dev-dax.c
+++ b/engines/dev-dax.c
@@ -182,7 +182,8 @@ done:
 	return 0;
 }
 
-static int fio_devdax_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_devdax_queue(struct thread_data *td,
+					  struct io_u *io_u)
 {
 	fio_ro_check(td, io_u);
 	io_u->error = 0;
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index 3619450..8f71d02 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -127,7 +127,8 @@ static void fio_e4defrag_cleanup(struct thread_data *td)
 }
 
 
-static int fio_e4defrag_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_e4defrag_queue(struct thread_data *td,
+					    struct io_u *io_u)
 {
 
 	int ret;
diff --git a/engines/falloc.c b/engines/falloc.c
index bb3ac85..6382569 100644
--- a/engines/falloc.c
+++ b/engines/falloc.c
@@ -65,8 +65,10 @@ open_again:
 #endif
 #ifndef FALLOC_FL_PUNCH_HOLE
 #define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
-#endif 
-static int fio_fallocate_queue(struct thread_data *td, struct io_u *io_u)
+#endif
+
+static enum fio_q_status fio_fallocate_queue(struct thread_data *td,
+					     struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	int ret;
diff --git a/engines/filecreate.c b/engines/filecreate.c
index 6fa041c..39a2950 100644
--- a/engines/filecreate.c
+++ b/engines/filecreate.c
@@ -55,7 +55,8 @@ static int open_file(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-static int queue_io(struct thread_data *td, struct io_u fio_unused *io_u)
+static enum fio_q_status queue_io(struct thread_data *td,
+				  struct io_u fio_unused *io_u)
 {
 	return FIO_Q_COMPLETED;
 }
diff --git a/engines/ftruncate.c b/engines/ftruncate.c
index 14e115f..c7ad038 100644
--- a/engines/ftruncate.c
+++ b/engines/ftruncate.c
@@ -11,18 +11,20 @@
 
 #include "../fio.h"
 
-static int fio_ftruncate_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_ftruncate_queue(struct thread_data *td,
+					     struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	int ret;
+
 	fio_ro_check(td, io_u);
 
 	if (io_u->ddir != DDIR_WRITE) {
 		io_u->error = EINVAL;
 		return FIO_Q_COMPLETED;
 	}
-	ret = ftruncate(f->fd, io_u->offset);
 
+	ret = ftruncate(f->fd, io_u->offset);
 	if (ret)
 		io_u->error = errno;
 
diff --git a/engines/fusion-aw.c b/engines/fusion-aw.c
index 77844ff..eb5fdf5 100644
--- a/engines/fusion-aw.c
+++ b/engines/fusion-aw.c
@@ -34,7 +34,7 @@ struct fas_data {
 	size_t sector_size;
 };
 
-static int queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status queue(struct thread_data *td, struct io_u *io_u)
 {
 	struct fas_data *d = FILE_ENG_DATA(io_u->file);
 	int rc;
diff --git a/engines/glusterfs_async.c b/engines/glusterfs_async.c
index eb8df45..9e1c4bf 100644
--- a/engines/glusterfs_async.c
+++ b/engines/glusterfs_async.c
@@ -93,8 +93,8 @@ static void gf_async_cb(glfs_fd_t * fd, ssize_t ret, void *data)
 	iou->io_complete = 1;
 }
 
-static int fio_gf_async_queue(struct thread_data fio_unused * td,
-			      struct io_u *io_u)
+static enum fio_q_status fio_gf_async_queue(struct thread_data fio_unused * td,
+					    struct io_u *io_u)
 {
 	struct gf_data *g = td->io_ops_data;
 	int r;
diff --git a/engines/glusterfs_sync.c b/engines/glusterfs_sync.c
index 25d05b2..a10e0ed 100644
--- a/engines/glusterfs_sync.c
+++ b/engines/glusterfs_sync.c
@@ -29,7 +29,7 @@ static int fio_gf_prep(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
-static int fio_gf_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_gf_queue(struct thread_data *td, struct io_u *io_u)
 {
 	struct gf_data *g = td->io_ops_data;
 	int ret = 0;
@@ -47,7 +47,8 @@ static int fio_gf_queue(struct thread_data *td, struct io_u *io_u)
 		ret = glfs_fdatasync(g->fd);
 	else {
 		log_err("unsupported operation.\n");
-		return -EINVAL;
+		io_u->error = EINVAL;
+		return FIO_Q_COMPLETED;
 	}
 	dprint(FD_FILE, "fio len %lu ret %d\n", io_u->xfer_buflen, ret);
 	if (io_u->file && ret >= 0 && ddir_rw(io_u->ddir))
diff --git a/engines/guasi.c b/engines/guasi.c
index 9644ee5..cb26802 100644
--- a/engines/guasi.c
+++ b/engines/guasi.c
@@ -113,7 +113,8 @@ static int fio_guasi_getevents(struct thread_data *td, unsigned int min,
 	return n;
 }
 
-static int fio_guasi_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_guasi_queue(struct thread_data *td,
+					 struct io_u *io_u)
 {
 	struct guasi_data *ld = td->io_ops_data;
 
diff --git a/engines/libaio.c b/engines/libaio.c
index 7d59df3..f46b331 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -177,7 +177,8 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 	return r < 0 ? r : events;
 }
 
-static int fio_libaio_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_libaio_queue(struct thread_data *td,
+					  struct io_u *io_u)
 {
 	struct libaio_data *ld = td->io_ops_data;
 
diff --git a/engines/libhdfs.c b/engines/libhdfs.c
index 96a0871..6000160 100644
--- a/engines/libhdfs.c
+++ b/engines/libhdfs.c
@@ -165,7 +165,8 @@ static int fio_hdfsio_prep(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
-static int fio_hdfsio_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_hdfsio_queue(struct thread_data *td,
+					  struct io_u *io_u)
 {
 	struct hdfsio_data *hd = td->io_ops_data;
 	struct hdfsio_options *options = td->eo;
diff --git a/engines/libpmem.c b/engines/libpmem.c
index dbb3f5c..21ff4f6 100644
--- a/engines/libpmem.c
+++ b/engines/libpmem.c
@@ -457,7 +457,8 @@ done:
 	return 0;
 }
 
-static int fio_libpmem_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_libpmem_queue(struct thread_data *td,
+					   struct io_u *io_u)
 {
 	fio_ro_check(td, io_u);
 	io_u->error = 0;
diff --git a/engines/mmap.c b/engines/mmap.c
index 9dbefc8..308b466 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -177,7 +177,8 @@ done:
 	return 0;
 }
 
-static int fio_mmapio_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_mmapio_queue(struct thread_data *td,
+					  struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
diff --git a/engines/mtd.c b/engines/mtd.c
index 5f822fc..b9f4316 100644
--- a/engines/mtd.c
+++ b/engines/mtd.c
@@ -71,7 +71,8 @@ static int fio_mtd_is_bad(struct thread_data *td,
 	return ret;
 }
 
-static int fio_mtd_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_mtd_queue(struct thread_data *td,
+				       struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	struct fio_mtd_data *fmd = FILE_ENG_DATA(f);
diff --git a/engines/net.c b/engines/net.c
index 4540e0e..ca6fb34 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -642,8 +642,9 @@ static int fio_netio_recv(struct thread_data *td, struct io_u *io_u)
 	return ret;
 }
 
-static int __fio_netio_queue(struct thread_data *td, struct io_u *io_u,
-			     enum fio_ddir ddir)
+static enum fio_q_status __fio_netio_queue(struct thread_data *td,
+					   struct io_u *io_u,
+					   enum fio_ddir ddir)
 {
 	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
@@ -687,7 +688,8 @@ static int __fio_netio_queue(struct thread_data *td, struct io_u *io_u,
 	return FIO_Q_COMPLETED;
 }
 
-static int fio_netio_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_netio_queue(struct thread_data *td,
+					 struct io_u *io_u)
 {
 	struct netio_options *o = td->eo;
 	int ret;
diff --git a/engines/null.c b/engines/null.c
index 8c26ad7..4cc0102 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -56,8 +56,8 @@ static int null_commit(struct thread_data *td, struct null_data *nd)
 	return 0;
 }
 
-static int null_queue(struct thread_data *td, struct null_data *nd,
-		      struct io_u *io_u)
+static enum fio_q_status null_queue(struct thread_data *td,
+				    struct null_data *nd, struct io_u *io_u)
 {
 	fio_ro_check(td, io_u);
 
@@ -118,7 +118,8 @@ static int fio_null_commit(struct thread_data *td)
 	return null_commit(td, td->io_ops_data);
 }
 
-static int fio_null_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_null_queue(struct thread_data *td,
+					struct io_u *io_u)
 {
 	return null_queue(td, td->io_ops_data, io_u);
 }
diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index 264eb71..45f6fb6 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -342,7 +342,8 @@ static int fio_pmemblk_get_file_size(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-static int fio_pmemblk_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_pmemblk_queue(struct thread_data *td,
+					   struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	fio_pmemblk_file_t pmb = FILE_ENG_DATA(f);
diff --git a/engines/posixaio.c b/engines/posixaio.c
index bddb1ec..4ac0195 100644
--- a/engines/posixaio.c
+++ b/engines/posixaio.c
@@ -166,8 +166,8 @@ static struct io_u *fio_posixaio_event(struct thread_data *td, int event)
 	return pd->aio_events[event];
 }
 
-static int fio_posixaio_queue(struct thread_data *td,
-			      struct io_u *io_u)
+static enum fio_q_status fio_posixaio_queue(struct thread_data *td,
+					    struct io_u *io_u)
 {
 	struct posixaio_data *pd = td->io_ops_data;
 	os_aiocb_t *aiocb = &io_u->aiocb;
diff --git a/engines/rados.c b/engines/rados.c
index dc0d7b1..c6aec73 100644
--- a/engines/rados.c
+++ b/engines/rados.c
@@ -251,7 +251,8 @@ static void fio_rados_cleanup(struct thread_data *td)
 	}
 }
 
-static int fio_rados_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_rados_queue(struct thread_data *td,
+					 struct io_u *io_u)
 {
 	struct rados_data *rados = td->io_ops_data;
 	struct fio_rados_iou *fri = io_u->engine_data;
diff --git a/engines/rbd.c b/engines/rbd.c
index 6582b06..081b4a0 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -462,7 +462,8 @@ static int fio_rbd_getevents(struct thread_data *td, unsigned int min,
 	return events;
 }
 
-static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_rbd_queue(struct thread_data *td,
+				       struct io_u *io_u)
 {
 	struct rbd_data *rbd = td->io_ops_data;
 	struct fio_rbd_iou *fri = io_u->engine_data;
diff --git a/engines/rdma.c b/engines/rdma.c
index 8def6eb..2569a8e 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -791,7 +791,8 @@ static int fio_rdmaio_recv(struct thread_data *td, struct io_u **io_us,
 	return i;
 }
 
-static int fio_rdmaio_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_rdmaio_queue(struct thread_data *td,
+					  struct io_u *io_u)
 {
 	struct rdmaio_data *rd = td->io_ops_data;
 
diff --git a/engines/sg.c b/engines/sg.c
index c2c0de3..d4848bc 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -236,8 +236,9 @@ re_read:
 	return r;
 }
 
-static int fio_sgio_ioctl_doio(struct thread_data *td,
-			       struct fio_file *f, struct io_u *io_u)
+static enum fio_q_status fio_sgio_ioctl_doio(struct thread_data *td,
+					     struct fio_file *f,
+					     struct io_u *io_u)
 {
 	struct sgio_data *sd = td->io_ops_data;
 	struct sg_io_hdr *hdr = &io_u->hdr;
@@ -377,7 +378,8 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
-static int fio_sgio_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_sgio_queue(struct thread_data *td,
+					struct io_u *io_u)
 {
 	struct sg_io_hdr *hdr = &io_u->hdr;
 	int ret, do_sync = 0;
diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
index 56f89f9..21a3601 100644
--- a/engines/skeleton_external.c
+++ b/engines/skeleton_external.c
@@ -90,7 +90,8 @@ static int fio_skeleton_cancel(struct thread_data *td, struct io_u *io_u)
  * io_u->xfer_buflen. Residual data count may be set in io_u->resid
  * for a short read/write.
  */
-static int fio_skeleton_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_skeleton_queue(struct thread_data *td,
+					    struct io_u *io_u)
 {
 	/*
 	 * Double sanity check to catch errant write on a readonly setup
diff --git a/engines/splice.c b/engines/splice.c
index 08fc857..feb764f 100644
--- a/engines/splice.c
+++ b/engines/splice.c
@@ -199,7 +199,8 @@ static int fio_splice_write(struct thread_data *td, struct io_u *io_u)
 	return io_u->xfer_buflen;
 }
 
-static int fio_spliceio_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_spliceio_queue(struct thread_data *td,
+					    struct io_u *io_u)
 {
 	struct spliceio_data *sd = td->io_ops_data;
 	int ret = 0;
diff --git a/engines/sync.c b/engines/sync.c
index d5b4012..3f36da8 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -110,7 +110,8 @@ static int fio_io_end(struct thread_data *td, struct io_u *io_u, int ret)
 }
 
 #ifdef CONFIG_PWRITEV
-static int fio_pvsyncio_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_pvsyncio_queue(struct thread_data *td,
+					    struct io_u *io_u)
 {
 	struct syncio_data *sd = td->io_ops_data;
 	struct iovec *iov = &sd->iovecs[0];
@@ -137,7 +138,8 @@ static int fio_pvsyncio_queue(struct thread_data *td, struct io_u *io_u)
 #endif
 
 #ifdef FIO_HAVE_PWRITEV2
-static int fio_pvsyncio2_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_pvsyncio2_queue(struct thread_data *td,
+					     struct io_u *io_u)
 {
 	struct syncio_data *sd = td->io_ops_data;
 	struct psyncv2_options *o = td->eo;
@@ -168,8 +170,8 @@ static int fio_pvsyncio2_queue(struct thread_data *td, struct io_u *io_u)
 }
 #endif
 
-
-static int fio_psyncio_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_psyncio_queue(struct thread_data *td,
+					   struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	int ret;
@@ -189,7 +191,8 @@ static int fio_psyncio_queue(struct thread_data *td, struct io_u *io_u)
 	return fio_io_end(td, io_u, ret);
 }
 
-static int fio_syncio_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_syncio_queue(struct thread_data *td,
+					  struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	int ret;
@@ -260,7 +263,8 @@ static void fio_vsyncio_set_iov(struct syncio_data *sd, struct io_u *io_u,
 	sd->queued++;
 }
 
-static int fio_vsyncio_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_vsyncio_queue(struct thread_data *td,
+					   struct io_u *io_u)
 {
 	struct syncio_data *sd = td->io_ops_data;
 
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index 9439393..13d7f19 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -354,7 +354,8 @@ static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
 	return dequeued;
 }
 
-static int fio_windowsaio_queue(struct thread_data *td, struct io_u *io_u)
+static enum fio_q_status fio_windowsaio_queue(struct thread_data *td,
+					      struct io_u *io_u)
 {
 	struct fio_overlapped *o = io_u->engine_data;
 	LPOVERLAPPED lpOvl = &o->o;
diff --git a/init.c b/init.c
index 07d1cdd..9257d47 100644
--- a/init.c
+++ b/init.c
@@ -833,11 +833,11 @@ static int fixup_options(struct thread_data *td)
 		}
 	}
 
-	if (!o->unit_base) {
+	if (o->unit_base == N2S_NONE) {
 		if (td_ioengine_flagged(td, FIO_BIT_BASED))
-			o->unit_base = 1;
+			o->unit_base = N2S_BITPERSEC;
 		else
-			o->unit_base = 8;
+			o->unit_base = N2S_BYTEPERSEC;
 	}
 
 #ifndef FIO_HAVE_ANY_FALLOCATE
diff --git a/io_u.c b/io_u.c
index 633f617..5b4c0df 100644
--- a/io_u.c
+++ b/io_u.c
@@ -610,11 +610,8 @@ int io_u_quiesce(struct thread_data *td)
 	 * io's that have been actually submitted to an async engine,
 	 * and cur_depth is meaningless for sync engines.
 	 */
-	if (td->io_u_queued || td->cur_depth) {
-		int fio_unused ret;
-
-		ret = td_io_commit(td);
-	}
+	if (td->io_u_queued || td->cur_depth)
+		td_io_commit(td);
 
 	while (td->io_u_in_flight) {
 		int ret;
diff --git a/ioengines.c b/ioengines.c
index a8ec79d..6ffd27f 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -276,11 +276,11 @@ out:
 	return r;
 }
 
-int td_io_queue(struct thread_data *td, struct io_u *io_u)
+enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 {
 	const enum fio_ddir ddir = acct_ddir(io_u);
 	unsigned long buflen = io_u->xfer_buflen;
-	int ret;
+	enum fio_q_status ret;
 
 	dprint_io_u(io_u, "queue");
 	fio_ro_check(td, io_u);
@@ -361,18 +361,13 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 			td->ts.total_io_u[io_u->ddir]++;
 		}
 	} else if (ret == FIO_Q_QUEUED) {
-		int r;
-
 		td->io_u_queued++;
 
 		if (ddir_rw(io_u->ddir) || ddir_sync(io_u->ddir))
 			td->ts.total_io_u[io_u->ddir]++;
 
-		if (td->io_u_queued >= td->o.iodepth_batch) {
-			r = td_io_commit(td);
-			if (r < 0)
-				return r;
-		}
+		if (td->io_u_queued >= td->o.iodepth_batch)
+			td_io_commit(td);
 	}
 
 	if (!td_ioengine_flagged(td, FIO_SYNCIO)) {
@@ -410,14 +405,14 @@ int td_io_init(struct thread_data *td)
 	return ret;
 }
 
-int td_io_commit(struct thread_data *td)
+void td_io_commit(struct thread_data *td)
 {
 	int ret;
 
 	dprint(FD_IO, "calling ->commit(), depth %d\n", td->cur_depth);
 
 	if (!td->cur_depth || !td->io_u_queued)
-		return 0;
+		return;
 
 	io_u_mark_depth(td, td->io_u_queued);
 
@@ -432,8 +427,6 @@ int td_io_commit(struct thread_data *td)
 	 */
 	td->io_u_in_flight += td->io_u_queued;
 	td->io_u_queued = 0;
-
-	return 0;
 }
 
 int td_io_open_file(struct thread_data *td, struct fio_file *f)
diff --git a/ioengines.h b/ioengines.h
index a0674ae..feb21db 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -7,12 +7,12 @@
 #include "flist.h"
 #include "io_u.h"
 
-#define FIO_IOOPS_VERSION	23
+#define FIO_IOOPS_VERSION	24
 
 /*
  * io_ops->queue() return values
  */
-enum {
+enum fio_q_status {
 	FIO_Q_COMPLETED	= 0,		/* completed sync */
 	FIO_Q_QUEUED	= 1,		/* queued, will complete async */
 	FIO_Q_BUSY	= 2,		/* no more room, call ->commit() */
@@ -26,7 +26,7 @@ struct ioengine_ops {
 	int (*setup)(struct thread_data *);
 	int (*init)(struct thread_data *);
 	int (*prep)(struct thread_data *, struct io_u *);
-	int (*queue)(struct thread_data *, struct io_u *);
+	enum fio_q_status (*queue)(struct thread_data *, struct io_u *);
 	int (*commit)(struct thread_data *);
 	int (*getevents)(struct thread_data *, unsigned int, unsigned int, const struct timespec *);
 	struct io_u *(*event)(struct thread_data *, int);
@@ -74,9 +74,9 @@ typedef void (*get_ioengine_t)(struct ioengine_ops **);
  */
 extern int __must_check td_io_init(struct thread_data *);
 extern int __must_check td_io_prep(struct thread_data *, struct io_u *);
-extern int __must_check td_io_queue(struct thread_data *, struct io_u *);
+extern enum fio_q_status __must_check td_io_queue(struct thread_data *, struct io_u *);
 extern int __must_check td_io_getevents(struct thread_data *, unsigned int, unsigned int, const struct timespec *);
-extern int __must_check td_io_commit(struct thread_data *);
+extern void td_io_commit(struct thread_data *);
 extern int __must_check td_io_open_file(struct thread_data *, struct fio_file *);
 extern int td_io_close_file(struct thread_data *, struct fio_file *);
 extern int td_io_unlink_file(struct thread_data *, struct fio_file *);
diff --git a/lib/num2str.c b/lib/num2str.c
index 387c5d7..40fb3ae 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -14,22 +14,30 @@
  * @maxlen: max number of digits in the output string (not counting prefix and units, but counting .)
  * @base: multiplier for num (e.g., if num represents Ki, use 1024)
  * @pow2: select unit prefix - 0=power-of-10 decimal SI, nonzero=power-of-2 binary IEC
- * @units: select units - N2S_* macros defined in num2str.h
+ * @units: select units - N2S_* constants defined in num2str.h
  * @returns a malloc'd buffer containing "number[<unit prefix>][<units>]"
  */
-char *num2str(uint64_t num, int maxlen, int base, int pow2, int units)
+char *num2str(uint64_t num, int maxlen, int base, int pow2, enum n2s_unit units)
 {
 	const char *sistr[] = { "", "k", "M", "G", "T", "P" };
 	const char *iecstr[] = { "", "Ki", "Mi", "Gi", "Ti", "Pi" };
 	const char **unitprefix;
-	const char *unitstr[] = { "", "/s", "B", "bit", "B/s", "bit/s" };
+	static const char *const unitstr[] = {
+		[N2S_NONE]	= "",
+		[N2S_PERSEC]	= "/s",
+		[N2S_BYTE]	= "B",
+		[N2S_BIT]	= "bit",
+		[N2S_BYTEPERSEC]= "B/s",
+		[N2S_BITPERSEC]	= "bit/s"
+	};
 	const unsigned int thousand[] = { 1000, 1024 };
 	unsigned int modulo;
-	int unit_index = 0, post_index, carry = 0;
+	int post_index, carry = 0;
 	char tmp[32], fmt[32];
 	char *buf;
 
 	compiletime_assert(sizeof(sistr) == sizeof(iecstr), "unit prefix arrays must be identical sizes");
+	assert(units < ARRAY_SIZE(unitstr));
 
 	buf = malloc(128);
 	if (!buf)
@@ -44,21 +52,18 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, int units)
 		base /= thousand[!!pow2];
 
 	switch (units) {
+	case N2S_NONE:
+		break;
 	case N2S_PERSEC:
-		unit_index = 1;
 		break;
 	case N2S_BYTE:
-		unit_index = 2;
 		break;
 	case N2S_BIT:
-		unit_index = 3;
 		num *= 8;
 		break;
 	case N2S_BYTEPERSEC:
-		unit_index = 4;
 		break;
 	case N2S_BITPERSEC:
-		unit_index = 5;
 		num *= 8;
 		break;
 	}
@@ -87,7 +92,7 @@ done:
 			post_index = 0;
 
 		sprintf(buf, "%llu%s%s", (unsigned long long) num,
-			unitprefix[post_index], unitstr[unit_index]);
+			unitprefix[post_index], unitstr[units]);
 		return buf;
 	}
 
@@ -110,6 +115,6 @@ done:
 	sprintf(tmp, fmt, (double)modulo / (double)thousand[!!pow2]);
 
 	sprintf(buf, "%llu.%s%s%s", (unsigned long long) num, &tmp[2],
-			unitprefix[post_index], unitstr[unit_index]);
+			unitprefix[post_index], unitstr[units]);
 	return buf;
 }
diff --git a/lib/num2str.h b/lib/num2str.h
index 81358a1..797288b 100644
--- a/lib/num2str.h
+++ b/lib/num2str.h
@@ -3,13 +3,15 @@
 
 #include <inttypes.h>
 
-#define N2S_NONE	0
-#define N2S_BITPERSEC	1	/* match unit_base for bit rates */
-#define N2S_PERSEC	2
-#define N2S_BIT		3
-#define N2S_BYTE	4
-#define N2S_BYTEPERSEC	8	/* match unit_base for byte rates */
-
-extern char *num2str(uint64_t, int, int, int, int);
+enum n2s_unit {
+	N2S_NONE	= 0,
+	N2S_PERSEC	= 1,
+	N2S_BYTE	= 2,
+	N2S_BIT		= 3,
+	N2S_BYTEPERSEC	= 4,
+	N2S_BITPERSEC	= 5,
+};
+
+extern char *num2str(uint64_t, int, int, int, enum n2s_unit);
 
 #endif
diff --git a/options.c b/options.c
index 1b3ea04..0b3a895 100644
--- a/options.c
+++ b/options.c
@@ -4425,15 +4425,15 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.prio	= 1,
 		.posval = {
 			  { .ival = "0",
-			    .oval = 0,
+			    .oval = N2S_NONE,
 			    .help = "Auto-detect",
 			  },
 			  { .ival = "8",
-			    .oval = 8,
+			    .oval = N2S_BYTEPERSEC,
 			    .help = "Normal (byte based)",
 			  },
 			  { .ival = "1",
-			    .oval = 1,
+			    .oval = N2S_BITPERSEC,
 			    .help = "Bit based",
 			  },
 		},
diff --git a/stat.c b/stat.c
index 7b9dd3b..c89a7f0 100644
--- a/stat.c
+++ b/stat.c
@@ -362,7 +362,7 @@ static void stat_calc_lat(struct thread_stat *ts, double *dst,
  * To keep the terse format unaltered, add all of the ns latency
  * buckets to the first us latency bucket
  */
-void stat_calc_lat_nu(struct thread_stat *ts, double *io_u_lat_u)
+static void stat_calc_lat_nu(struct thread_stat *ts, double *io_u_lat_u)
 {
 	unsigned long ntotal = 0, total = ddir_rw_sum(ts->total_io_u);
 	int i;
