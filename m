Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 11/15] Don't malloc/memcpy ioengine_ops on td initialization
Date: Wed, 27 Jul 2016 22:37:16 +0900
Message-Id: <1469626640-13335-11-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

The only reason load_ioengine() needs to malloc extra space for
struct ioengine_ops and memcpy from the original ops is because td
has per-thread/process ioengine private data which is a part of
this structure.

If data (and dlhandle) are separated from struct ioengine_ops,
load_ioengine() no longer needs to malloc, as the rest of structure
fields such as function pointers and string literal are static.
Td only needs a pointer to the original ops. Also avoid memcpying
a list_head from the original ops.

This commit moves/renames data and dlhandle to struct thread_data
as thread_data::io_ops_data and thread_data::io_ops_dlhandle.
engines/*.c which access ioengine private data by dereferencing
td->io_ops->... are modified accordingly, but nothing more than that.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 engines/binject.c         | 10 +++++-----
 engines/e4defrag.c        |  6 +++---
 engines/glusterfs.c       | 20 ++++++++++----------
 engines/glusterfs_async.c |  8 ++++----
 engines/glusterfs_sync.c  |  4 ++--
 engines/guasi.c           | 12 ++++++------
 engines/libaio.c          | 14 +++++++-------
 engines/libhdfs.c         | 16 ++++++++--------
 engines/net.c             | 42 ++++++++++++++++++++---------------------
 engines/null.c            | 12 ++++++------
 engines/posixaio.c        | 10 +++++-----
 engines/rbd.c             | 16 ++++++++--------
 engines/rdma.c            | 48 +++++++++++++++++++++++------------------------
 engines/sg.c              | 16 ++++++++--------
 engines/solarisaio.c      | 12 ++++++------
 engines/splice.c          | 12 ++++++------
 engines/sync.c            | 20 ++++++++++----------
 engines/windowsaio.c      | 16 ++++++++--------
 fio.h                     |  6 ++++++
 ioengine.h                |  2 --
 ioengines.c               | 17 ++++++-----------
 21 files changed, 159 insertions(+), 160 deletions(-)

diff --git a/engines/binject.c b/engines/binject.c
index f8e83cd..7d20a3f 100644
--- a/engines/binject.c
+++ b/engines/binject.c
@@ -94,7 +94,7 @@ static int fio_binject_getevents(struct thread_data *td, unsigned int min,
 				 unsigned int max,
 				 const struct timespec fio_unused *t)
 {
-	struct binject_data *bd = td->io_ops->data;
+	struct binject_data *bd = td->io_ops_data;
 	int left = max, ret, r = 0, ev_index = 0;
 	void *buf = bd->cmds;
 	unsigned int i, events;
@@ -185,7 +185,7 @@ static int fio_binject_doio(struct thread_data *td, struct io_u *io_u)
 
 static int fio_binject_prep(struct thread_data *td, struct io_u *io_u)
 {
-	struct binject_data *bd = td->io_ops->data;
+	struct binject_data *bd = td->io_ops_data;
 	struct b_user_cmd *buc = &io_u->buc;
 	struct binject_file *bf = FILE_ENG_DATA(io_u->file);
 
@@ -234,7 +234,7 @@ static int fio_binject_queue(struct thread_data *td, struct io_u *io_u)
 
 static struct io_u *fio_binject_event(struct thread_data *td, int event)
 {
-	struct binject_data *bd = td->io_ops->data;
+	struct binject_data *bd = td->io_ops_data;
 
 	return bd->events[event];
 }
@@ -376,7 +376,7 @@ err_close:
 
 static void fio_binject_cleanup(struct thread_data *td)
 {
-	struct binject_data *bd = td->io_ops->data;
+	struct binject_data *bd = td->io_ops_data;
 
 	if (bd) {
 		free(bd->events);
@@ -406,7 +406,7 @@ static int fio_binject_init(struct thread_data *td)
 	bd->fd_flags = malloc(sizeof(int) * td->o.nr_files);
 	memset(bd->fd_flags, 0, sizeof(int) * td->o.nr_files);
 
-	td->io_ops->data = bd;
+	td->io_ops_data = bd;
 	return 0;
 }
 
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index c0667fe..c599c98 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -109,7 +109,7 @@ static int fio_e4defrag_init(struct thread_data *td)
 		goto err;
 
 	ed->bsz = stub.st_blksize;
-	td->io_ops->data = ed;
+	td->io_ops_data = ed;
 	return 0;
 err:
 	td_verror(td, errno, "io_queue_init");
@@ -120,7 +120,7 @@ err:
 
 static void fio_e4defrag_cleanup(struct thread_data *td)
 {
-	struct e4defrag_data *ed = td->io_ops->data;
+	struct e4defrag_data *ed = td->io_ops_data;
 	if (ed) {
 		if (ed->donor_fd >= 0)
 			close(ed->donor_fd);
@@ -136,7 +136,7 @@ static int fio_e4defrag_queue(struct thread_data *td, struct io_u *io_u)
 	unsigned long long len;
 	struct move_extent me;
 	struct fio_file *f = io_u->file;
-	struct e4defrag_data *ed = td->io_ops->data;
+	struct e4defrag_data *ed = td->io_ops_data;
 	struct e4defrag_options *o = td->eo;
 
 	fio_ro_check(td, io_u);
diff --git a/engines/glusterfs.c b/engines/glusterfs.c
index dec9fb5..2abc283 100644
--- a/engines/glusterfs.c
+++ b/engines/glusterfs.c
@@ -41,7 +41,7 @@ int fio_gf_setup(struct thread_data *td)
 
 	dprint(FD_IO, "fio setup\n");
 
-	if (td->io_ops->data)
+	if (td->io_ops_data)
 		return 0;
 
 	g = malloc(sizeof(struct gf_data));
@@ -77,19 +77,19 @@ int fio_gf_setup(struct thread_data *td)
 		goto cleanup;
 	}
 	dprint(FD_FILE, "fio setup %p\n", g->fs);
-	td->io_ops->data = g;
+	td->io_ops_data = g;
 	return 0;
 cleanup:
 	if (g->fs)
 		glfs_fini(g->fs);
 	free(g);
-	td->io_ops->data = NULL;
+	td->io_ops_data = NULL;
 	return r;
 }
 
 void fio_gf_cleanup(struct thread_data *td)
 {
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 
 	if (g) {
 		if (g->aio_events)
@@ -99,7 +99,7 @@ void fio_gf_cleanup(struct thread_data *td)
 		if (g->fs)
 			glfs_fini(g->fs);
 		free(g);
-		td->io_ops->data = NULL;
+		td->io_ops_data = NULL;
 	}
 }
 
@@ -107,7 +107,7 @@ int fio_gf_get_file_size(struct thread_data *td, struct fio_file *f)
 {
 	struct stat buf;
 	int ret;
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 
 	dprint(FD_FILE, "get file size %s\n", f->file_name);
 
@@ -135,7 +135,7 @@ int fio_gf_open_file(struct thread_data *td, struct fio_file *f)
 
 	int flags = 0;
 	int ret = 0;
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 	struct stat sb = { 0, };
 
 	if (td_write(td)) {
@@ -268,7 +268,7 @@ int fio_gf_open_file(struct thread_data *td, struct fio_file *f)
 int fio_gf_close_file(struct thread_data *td, struct fio_file *f)
 {
 	int ret = 0;
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 
 	dprint(FD_FILE, "fd close %s\n", f->file_name);
 
@@ -284,7 +284,7 @@ int fio_gf_close_file(struct thread_data *td, struct fio_file *f)
 int fio_gf_unlink_file(struct thread_data *td, struct fio_file *f)
 {
 	int ret = 0;
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 
 	dprint(FD_FILE, "fd unlink %s\n", f->file_name);
 
@@ -300,7 +300,7 @@ int fio_gf_unlink_file(struct thread_data *td, struct fio_file *f)
 		g->fd = NULL;
 		free(g);
 	}
-	td->io_ops->data = NULL;
+	td->io_ops_data = NULL;
 
 	return ret;
 }
diff --git a/engines/glusterfs_async.c b/engines/glusterfs_async.c
index 7c2c139..8e42a84 100644
--- a/engines/glusterfs_async.c
+++ b/engines/glusterfs_async.c
@@ -13,7 +13,7 @@ struct fio_gf_iou {
 
 static struct io_u *fio_gf_event(struct thread_data *td, int event)
 {
-	struct gf_data *gf_data = td->io_ops->data;
+	struct gf_data *gf_data = td->io_ops_data;
 
 	dprint(FD_IO, "%s\n", __FUNCTION__);
 	return gf_data->aio_events[event];
@@ -22,7 +22,7 @@ static struct io_u *fio_gf_event(struct thread_data *td, int event)
 static int fio_gf_getevents(struct thread_data *td, unsigned int min,
 			    unsigned int max, const struct timespec *t)
 {
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 	unsigned int events = 0;
 	struct io_u *io_u;
 	int i;
@@ -99,7 +99,7 @@ static void gf_async_cb(glfs_fd_t * fd, ssize_t ret, void *data)
 static int fio_gf_async_queue(struct thread_data fio_unused * td,
 			      struct io_u *io_u)
 {
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 	int r;
 
 	dprint(FD_IO, "%s op %s\n", __FUNCTION__, io_ddir_name(io_u->ddir));
@@ -150,7 +150,7 @@ int fio_gf_async_setup(struct thread_data *td)
 		return r;
 
 	td->o.use_thread = 1;
-	g = td->io_ops->data;
+	g = td->io_ops_data;
 	g->aio_events = calloc(td->o.iodepth, sizeof(struct io_u *));
 	if (!g->aio_events) {
 		r = -ENOMEM;
diff --git a/engines/glusterfs_sync.c b/engines/glusterfs_sync.c
index 6de4ee2..05e184c 100644
--- a/engines/glusterfs_sync.c
+++ b/engines/glusterfs_sync.c
@@ -11,7 +11,7 @@
 static int fio_gf_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 
 	dprint(FD_FILE, "fio prep\n");
 
@@ -31,7 +31,7 @@ static int fio_gf_prep(struct thread_data *td, struct io_u *io_u)
 
 static int fio_gf_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct gf_data *g = td->io_ops->data;
+	struct gf_data *g = td->io_ops_data;
 	int ret = 0;
 
 	dprint(FD_FILE, "fio queue len %lu\n", io_u->xfer_buflen);
diff --git a/engines/guasi.c b/engines/guasi.c
index c586f09..eb12c89 100644
--- a/engines/guasi.c
+++ b/engines/guasi.c
@@ -50,7 +50,7 @@ static int fio_guasi_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 
 static struct io_u *fio_guasi_event(struct thread_data *td, int event)
 {
-	struct guasi_data *ld = td->io_ops->data;
+	struct guasi_data *ld = td->io_ops_data;
 	struct io_u *io_u;
 	struct guasi_reqinfo rinf;
 
@@ -82,7 +82,7 @@ static struct io_u *fio_guasi_event(struct thread_data *td, int event)
 static int fio_guasi_getevents(struct thread_data *td, unsigned int min,
 			       unsigned int max, const struct timespec *t)
 {
-	struct guasi_data *ld = td->io_ops->data;
+	struct guasi_data *ld = td->io_ops_data;
 	int n, r;
 	long timeo = -1;
 
@@ -115,7 +115,7 @@ static int fio_guasi_getevents(struct thread_data *td, unsigned int min,
 
 static int fio_guasi_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct guasi_data *ld = td->io_ops->data;
+	struct guasi_data *ld = td->io_ops_data;
 
 	fio_ro_check(td, io_u);
 
@@ -148,7 +148,7 @@ static void fio_guasi_queued(struct thread_data *td, struct io_u **io_us, int nr
 
 static int fio_guasi_commit(struct thread_data *td)
 {
-	struct guasi_data *ld = td->io_ops->data;
+	struct guasi_data *ld = td->io_ops_data;
 	int i;
 	struct io_u *io_u;
 	struct fio_file *f;
@@ -198,7 +198,7 @@ static int fio_guasi_cancel(struct thread_data fio_unused *td,
 
 static void fio_guasi_cleanup(struct thread_data *td)
 {
-	struct guasi_data *ld = td->io_ops->data;
+	struct guasi_data *ld = td->io_ops_data;
 	int n;
 
 	GDBG_PRINT(("fio_guasi_cleanup(%p)\n", ld));
@@ -235,7 +235,7 @@ static int fio_guasi_init(struct thread_data *td)
 	ld->queued_nr = 0;
 	ld->reqs_nr = 0;
 
-	td->io_ops->data = ld;
+	td->io_ops_data = ld;
 	GDBG_PRINT(("fio_guasi_init(): depth=%d -> %p\n", td->o.iodepth, ld));
 
 	return 0;
diff --git a/engines/libaio.c b/engines/libaio.c
index 9d562bb..e15c519 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -83,7 +83,7 @@ static int fio_libaio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 
 static struct io_u *fio_libaio_event(struct thread_data *td, int event)
 {
-	struct libaio_data *ld = td->io_ops->data;
+	struct libaio_data *ld = td->io_ops_data;
 	struct io_event *ev;
 	struct io_u *io_u;
 
@@ -145,7 +145,7 @@ static int user_io_getevents(io_context_t aio_ctx, unsigned int max,
 static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 				unsigned int max, const struct timespec *t)
 {
-	struct libaio_data *ld = td->io_ops->data;
+	struct libaio_data *ld = td->io_ops_data;
 	struct libaio_options *o = td->eo;
 	unsigned actual_min = td->o.iodepth_batch_complete_min == 0 ? 0 : min;
 	struct timespec __lt, *lt = NULL;
@@ -181,7 +181,7 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 
 static int fio_libaio_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct libaio_data *ld = td->io_ops->data;
+	struct libaio_data *ld = td->io_ops_data;
 
 	fio_ro_check(td, io_u);
 
@@ -238,7 +238,7 @@ static void fio_libaio_queued(struct thread_data *td, struct io_u **io_us,
 
 static int fio_libaio_commit(struct thread_data *td)
 {
-	struct libaio_data *ld = td->io_ops->data;
+	struct libaio_data *ld = td->io_ops_data;
 	struct iocb **iocbs;
 	struct io_u **io_us;
 	struct timeval tv;
@@ -308,14 +308,14 @@ static int fio_libaio_commit(struct thread_data *td)
 
 static int fio_libaio_cancel(struct thread_data *td, struct io_u *io_u)
 {
-	struct libaio_data *ld = td->io_ops->data;
+	struct libaio_data *ld = td->io_ops_data;
 
 	return io_cancel(ld->aio_ctx, &io_u->iocb, ld->aio_events);
 }
 
 static void fio_libaio_cleanup(struct thread_data *td)
 {
-	struct libaio_data *ld = td->io_ops->data;
+	struct libaio_data *ld = td->io_ops_data;
 
 	if (ld) {
 		/*
@@ -363,7 +363,7 @@ static int fio_libaio_init(struct thread_data *td)
 	ld->iocbs = calloc(ld->entries, sizeof(struct iocb *));
 	ld->io_us = calloc(ld->entries, sizeof(struct io_u *));
 
-	td->io_ops->data = ld;
+	td->io_ops_data = ld;
 	return 0;
 }
 
diff --git a/engines/libhdfs.c b/engines/libhdfs.c
index faad3f8..fba17c4 100644
--- a/engines/libhdfs.c
+++ b/engines/libhdfs.c
@@ -119,7 +119,7 @@ static int get_chunck_name(char *dest, char *file_name, uint64_t chunk_id) {
 static int fio_hdfsio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct hdfsio_options *options = td->eo;
-	struct hdfsio_data *hd = td->io_ops->data;
+	struct hdfsio_data *hd = td->io_ops_data;
 	unsigned long f_id;
 	char fname[CHUNCK_NAME_LENGTH_MAX];
 	int open_flags;
@@ -163,7 +163,7 @@ static int fio_hdfsio_prep(struct thread_data *td, struct io_u *io_u)
 
 static int fio_hdfsio_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct hdfsio_data *hd = td->io_ops->data;
+	struct hdfsio_data *hd = td->io_ops_data;
 	struct hdfsio_options *options = td->eo;
 	int ret;
 	unsigned long offset;
@@ -223,7 +223,7 @@ int fio_hdfsio_open_file(struct thread_data *td, struct fio_file *f)
 
 int fio_hdfsio_close_file(struct thread_data *td, struct fio_file *f)
 {
-	struct hdfsio_data *hd = td->io_ops->data;
+	struct hdfsio_data *hd = td->io_ops_data;
 
 	if (hd->curr_file_id != -1) {
 		if ( hdfsCloseFile(hd->fs, hd->fp) == -1) {
@@ -238,7 +238,7 @@ int fio_hdfsio_close_file(struct thread_data *td, struct fio_file *f)
 static int fio_hdfsio_init(struct thread_data *td)
 {
 	struct hdfsio_options *options = td->eo;
-	struct hdfsio_data *hd = td->io_ops->data;
+	struct hdfsio_data *hd = td->io_ops_data;
 	struct fio_file *f;
 	uint64_t j,k;
 	int i, failure = 0;
@@ -309,13 +309,13 @@ static int fio_hdfsio_setup(struct thread_data *td)
 	int i;
 	uint64_t file_size, total_file_size;
 
-	if (!td->io_ops->data) {
+	if (!td->io_ops_data) {
 		hd = malloc(sizeof(*hd));
 		memset(hd, 0, sizeof(*hd));
 		
 		hd->curr_file_id = -1;
 
-		td->io_ops->data = hd;
+		td->io_ops_data = hd;
 	}
 	
 	total_file_size = 0;
@@ -346,7 +346,7 @@ static int fio_hdfsio_setup(struct thread_data *td)
 
 static int fio_hdfsio_io_u_init(struct thread_data *td, struct io_u *io_u)
 {
-	struct hdfsio_data *hd = td->io_ops->data;
+	struct hdfsio_data *hd = td->io_ops_data;
 	struct hdfsio_options *options = td->eo;
 	int failure;
 	struct hdfsBuilder *bld;
@@ -381,7 +381,7 @@ static int fio_hdfsio_io_u_init(struct thread_data *td, struct io_u *io_u)
 
 static void fio_hdfsio_io_u_free(struct thread_data *td, struct io_u *io_u)
 {
-	struct hdfsio_data *hd = td->io_ops->data;
+	struct hdfsio_data *hd = td->io_ops_data;
 
 	if (hd->fs && hdfsDisconnect(hd->fs) < 0) {
 		log_err("hdfs: disconnect failed: %d\n", errno);
diff --git a/engines/net.c b/engines/net.c
index 9301ccf..f24efc1 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -374,7 +374,7 @@ static int splice_io_u(int fdin, int fdout, unsigned int len)
  */
 static int splice_in(struct thread_data *td, struct io_u *io_u)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 
 	return splice_io_u(io_u->file->fd, nd->pipes[1], io_u->xfer_buflen);
 }
@@ -385,7 +385,7 @@ static int splice_in(struct thread_data *td, struct io_u *io_u)
 static int splice_out(struct thread_data *td, struct io_u *io_u,
 		      unsigned int len)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 
 	return splice_io_u(nd->pipes[0], io_u->file->fd, len);
 }
@@ -423,7 +423,7 @@ static int vmsplice_io_u(struct io_u *io_u, int fd, unsigned int len)
 static int vmsplice_io_u_out(struct thread_data *td, struct io_u *io_u,
 			     unsigned int len)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 
 	return vmsplice_io_u(io_u, nd->pipes[0], len);
 }
@@ -433,7 +433,7 @@ static int vmsplice_io_u_out(struct thread_data *td, struct io_u *io_u,
  */
 static int vmsplice_io_u_in(struct thread_data *td, struct io_u *io_u)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 
 	return vmsplice_io_u(io_u, nd->pipes[1], io_u->xfer_buflen);
 }
@@ -524,7 +524,7 @@ static void verify_udp_seq(struct thread_data *td, struct netio_data *nd,
 
 static int fio_netio_send(struct thread_data *td, struct io_u *io_u)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	int ret, flags = 0;
 
@@ -587,7 +587,7 @@ static int is_close_msg(struct io_u *io_u, int len)
 
 static int fio_netio_recv(struct thread_data *td, struct io_u *io_u)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	int ret, flags = 0;
 
@@ -645,7 +645,7 @@ static int fio_netio_recv(struct thread_data *td, struct io_u *io_u)
 static int __fio_netio_queue(struct thread_data *td, struct io_u *io_u,
 			     enum fio_ddir ddir)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	int ret;
 
@@ -711,7 +711,7 @@ static int fio_netio_queue(struct thread_data *td, struct io_u *io_u)
 
 static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	int type, domain;
 
@@ -826,7 +826,7 @@ static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
 
 static int fio_netio_accept(struct thread_data *td, struct fio_file *f)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	socklen_t socklen;
 	int state;
@@ -878,7 +878,7 @@ err:
 
 static void fio_netio_send_close(struct thread_data *td, struct fio_file *f)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	struct udp_close_msg msg;
 	struct sockaddr *to;
@@ -913,7 +913,7 @@ static int fio_netio_close_file(struct thread_data *td, struct fio_file *f)
 
 static int fio_netio_udp_recv_open(struct thread_data *td, struct fio_file *f)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	struct udp_close_msg msg;
 	struct sockaddr *to;
@@ -947,7 +947,7 @@ static int fio_netio_udp_recv_open(struct thread_data *td, struct fio_file *f)
 
 static int fio_netio_send_open(struct thread_data *td, struct fio_file *f)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	struct udp_close_msg msg;
 	struct sockaddr *to;
@@ -1049,7 +1049,7 @@ static int fio_fill_addr(struct thread_data *td, const char *host, int af,
 static int fio_netio_setup_connect_inet(struct thread_data *td,
 					const char *host, unsigned short port)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	struct addrinfo *res = NULL;
 	void *dst, *src;
@@ -1099,7 +1099,7 @@ static int fio_netio_setup_connect_inet(struct thread_data *td,
 static int fio_netio_setup_connect_unix(struct thread_data *td,
 					const char *path)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct sockaddr_un *soun = &nd->addr_un;
 
 	soun->sun_family = AF_UNIX;
@@ -1120,7 +1120,7 @@ static int fio_netio_setup_connect(struct thread_data *td)
 
 static int fio_netio_setup_listen_unix(struct thread_data *td, const char *path)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct sockaddr_un *addr = &nd->addr_un;
 	mode_t mode;
 	int len, fd;
@@ -1153,7 +1153,7 @@ static int fio_netio_setup_listen_unix(struct thread_data *td, const char *path)
 
 static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	struct ip_mreq mr;
 	struct sockaddr_in sin;
@@ -1269,7 +1269,7 @@ static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 
 static int fio_netio_setup_listen(struct thread_data *td)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 	struct netio_options *o = td->eo;
 	int ret;
 
@@ -1344,7 +1344,7 @@ static int fio_netio_init(struct thread_data *td)
 
 static void fio_netio_cleanup(struct thread_data *td)
 {
-	struct netio_data *nd = td->io_ops->data;
+	struct netio_data *nd = td->io_ops_data;
 
 	if (nd) {
 		if (nd->listenfd != -1)
@@ -1368,13 +1368,13 @@ static int fio_netio_setup(struct thread_data *td)
 		td->o.open_files++;
 	}
 
-	if (!td->io_ops->data) {
+	if (!td->io_ops_data) {
 		nd = malloc(sizeof(*nd));;
 
 		memset(nd, 0, sizeof(*nd));
 		nd->listenfd = -1;
 		nd->pipes[0] = nd->pipes[1] = -1;
-		td->io_ops->data = nd;
+		td->io_ops_data = nd;
 	}
 
 	return 0;
@@ -1392,7 +1392,7 @@ static int fio_netio_setup_splice(struct thread_data *td)
 
 	fio_netio_setup(td);
 
-	nd = td->io_ops->data;
+	nd = td->io_ops_data;
 	if (nd) {
 		if (pipe(nd->pipes) < 0)
 			return 1;
diff --git a/engines/null.c b/engines/null.c
index 41d42e0..f7ba370 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -25,7 +25,7 @@ struct null_data {
 
 static struct io_u *fio_null_event(struct thread_data *td, int event)
 {
-	struct null_data *nd = (struct null_data *) td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops_data;
 
 	return nd->io_us[event];
 }
@@ -34,7 +34,7 @@ static int fio_null_getevents(struct thread_data *td, unsigned int min_events,
 			      unsigned int fio_unused max,
 			      const struct timespec fio_unused *t)
 {
-	struct null_data *nd = (struct null_data *) td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops_data;
 	int ret = 0;
 	
 	if (min_events) {
@@ -47,7 +47,7 @@ static int fio_null_getevents(struct thread_data *td, unsigned int min_events,
 
 static int fio_null_commit(struct thread_data *td)
 {
-	struct null_data *nd = (struct null_data *) td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops_data;
 
 	if (!nd->events) {
 #ifndef FIO_EXTERNAL_ENGINE
@@ -62,7 +62,7 @@ static int fio_null_commit(struct thread_data *td)
 
 static int fio_null_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct null_data *nd = (struct null_data *) td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops_data;
 
 	fio_ro_check(td, io_u);
 
@@ -83,7 +83,7 @@ static int fio_null_open(struct thread_data fio_unused *td,
 
 static void fio_null_cleanup(struct thread_data *td)
 {
-	struct null_data *nd = (struct null_data *) td->io_ops->data;
+	struct null_data *nd = (struct null_data *) td->io_ops_data;
 
 	if (nd) {
 		free(nd->io_us);
@@ -103,7 +103,7 @@ static int fio_null_init(struct thread_data *td)
 	} else
 		td->io_ops->flags |= FIO_SYNCIO;
 
-	td->io_ops->data = nd;
+	td->io_ops_data = nd;
 	return 0;
 }
 
diff --git a/engines/posixaio.c b/engines/posixaio.c
index 29bcc5a..e5411b7 100644
--- a/engines/posixaio.c
+++ b/engines/posixaio.c
@@ -93,7 +93,7 @@ static int fio_posixaio_prep(struct thread_data fio_unused *td,
 static int fio_posixaio_getevents(struct thread_data *td, unsigned int min,
 				  unsigned int max, const struct timespec *t)
 {
-	struct posixaio_data *pd = td->io_ops->data;
+	struct posixaio_data *pd = td->io_ops_data;
 	os_aiocb_t *suspend_list[SUSPEND_ENTRIES];
 	struct timespec start;
 	int have_timeout = 0;
@@ -161,7 +161,7 @@ restart:
 
 static struct io_u *fio_posixaio_event(struct thread_data *td, int event)
 {
-	struct posixaio_data *pd = td->io_ops->data;
+	struct posixaio_data *pd = td->io_ops_data;
 
 	return pd->aio_events[event];
 }
@@ -169,7 +169,7 @@ static struct io_u *fio_posixaio_event(struct thread_data *td, int event)
 static int fio_posixaio_queue(struct thread_data *td,
 			      struct io_u *io_u)
 {
-	struct posixaio_data *pd = td->io_ops->data;
+	struct posixaio_data *pd = td->io_ops_data;
 	os_aiocb_t *aiocb = &io_u->aiocb;
 	int ret;
 
@@ -220,7 +220,7 @@ static int fio_posixaio_queue(struct thread_data *td,
 
 static void fio_posixaio_cleanup(struct thread_data *td)
 {
-	struct posixaio_data *pd = td->io_ops->data;
+	struct posixaio_data *pd = td->io_ops_data;
 
 	if (pd) {
 		free(pd->aio_events);
@@ -236,7 +236,7 @@ static int fio_posixaio_init(struct thread_data *td)
 	pd->aio_events = malloc(td->o.iodepth * sizeof(struct io_u *));
 	memset(pd->aio_events, 0, td->o.iodepth * sizeof(struct io_u *));
 
-	td->io_ops->data = pd;
+	td->io_ops_data = pd;
 	return 0;
 }
 
diff --git a/engines/rbd.c b/engines/rbd.c
index 87ed360..2967a9f 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -91,7 +91,7 @@ static int _fio_setup_rbd_data(struct thread_data *td,
 {
 	struct rbd_data *rbd;
 
-	if (td->io_ops->data)
+	if (td->io_ops_data)
 		return 0;
 
 	rbd = calloc(1, sizeof(struct rbd_data));
@@ -118,7 +118,7 @@ failed:
 
 static int _fio_rbd_connect(struct thread_data *td)
 {
-	struct rbd_data *rbd = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops_data;
 	struct rbd_options *o = td->eo;
 	int r;
 
@@ -226,7 +226,7 @@ static void _fio_rbd_finish_aiocb(rbd_completion_t comp, void *data)
 
 static struct io_u *fio_rbd_event(struct thread_data *td, int event)
 {
-	struct rbd_data *rbd = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops_data;
 
 	return rbd->aio_events[event];
 }
@@ -282,7 +282,7 @@ static int rbd_io_u_cmp(const void *p1, const void *p2)
 static int rbd_iter_events(struct thread_data *td, unsigned int *events,
 			   unsigned int min_evts, int wait)
 {
-	struct rbd_data *rbd = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops_data;
 	unsigned int this_events = 0;
 	struct io_u *io_u;
 	int i, sidx;
@@ -361,7 +361,7 @@ static int fio_rbd_getevents(struct thread_data *td, unsigned int min,
 
 static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct rbd_data *rbd = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops_data;
 	struct fio_rbd_iou *fri = io_u->engine_data;
 	int r = -1;
 
@@ -439,7 +439,7 @@ failed:
 
 static void fio_rbd_cleanup(struct thread_data *td)
 {
-	struct rbd_data *rbd = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops_data;
 
 	if (rbd) {
 		_fio_rbd_disconnect(rbd);
@@ -467,7 +467,7 @@ static int fio_rbd_setup(struct thread_data *td)
 		log_err("fio_setup_rbd_data failed.\n");
 		goto cleanup;
 	}
-	td->io_ops->data = rbd;
+	td->io_ops_data = rbd;
 
 	/* librbd does not allow us to run first in the main thread and later
 	 * in a fork child. It needs to be the same process context all the
@@ -526,7 +526,7 @@ static int fio_rbd_open(struct thread_data *td, struct fio_file *f)
 static int fio_rbd_invalidate(struct thread_data *td, struct fio_file *f)
 {
 #if defined(CONFIG_RBD_INVAL)
-	struct rbd_data *rbd = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops_data;
 
 	return rbd_invalidate_cache(rbd->image);
 #else
diff --git a/engines/rdma.c b/engines/rdma.c
index 7fbfad9..fbe8434 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -191,7 +191,7 @@ struct rdmaio_data {
 
 static int client_recv(struct thread_data *td, struct ibv_wc *wc)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	unsigned int max_bs;
 
 	if (wc->byte_len != sizeof(rd->recv_buf)) {
@@ -232,7 +232,7 @@ static int client_recv(struct thread_data *td, struct ibv_wc *wc)
 
 static int server_recv(struct thread_data *td, struct ibv_wc *wc)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	unsigned int max_bs;
 
 	if (wc->wr_id == FIO_RDMA_MAX_IO_DEPTH) {
@@ -257,7 +257,7 @@ static int server_recv(struct thread_data *td, struct ibv_wc *wc)
 
 static int cq_event_handler(struct thread_data *td, enum ibv_wc_opcode opcode)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_wc wc;
 	struct rdma_io_u_data *r_io_u_d;
 	int ret;
@@ -368,7 +368,7 @@ static int cq_event_handler(struct thread_data *td, enum ibv_wc_opcode opcode)
  */
 static int rdma_poll_wait(struct thread_data *td, enum ibv_wc_opcode opcode)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_cq *ev_cq;
 	void *ev_ctx;
 	int ret;
@@ -405,7 +405,7 @@ again:
 
 static int fio_rdmaio_setup_qp(struct thread_data *td)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_qp_init_attr init_attr;
 	int qp_depth = td->o.iodepth * 2;	/* 2 times of io depth */
 
@@ -485,7 +485,7 @@ err1:
 
 static int fio_rdmaio_setup_control_msg_buffers(struct thread_data *td)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 
 	rd->recv_mr = ibv_reg_mr(rd->pd, &rd->recv_buf, sizeof(rd->recv_buf),
 				 IBV_ACCESS_LOCAL_WRITE);
@@ -529,7 +529,7 @@ static int get_next_channel_event(struct thread_data *td,
 				  struct rdma_event_channel *channel,
 				  enum rdma_cm_event_type wait_event)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct rdma_cm_event *event;
 	int ret;
 
@@ -561,7 +561,7 @@ static int get_next_channel_event(struct thread_data *td,
 
 static int fio_rdmaio_prep(struct thread_data *td, struct io_u *io_u)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct rdma_io_u_data *r_io_u_d;
 
 	r_io_u_d = io_u->engine_data;
@@ -604,7 +604,7 @@ static int fio_rdmaio_prep(struct thread_data *td, struct io_u *io_u)
 
 static struct io_u *fio_rdmaio_event(struct thread_data *td, int event)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct io_u *io_u;
 	int i;
 
@@ -622,7 +622,7 @@ static struct io_u *fio_rdmaio_event(struct thread_data *td, int event)
 static int fio_rdmaio_getevents(struct thread_data *td, unsigned int min,
 				unsigned int max, const struct timespec *t)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	enum ibv_wc_opcode comp_opcode;
 	struct ibv_cq *ev_cq;
 	void *ev_ctx;
@@ -684,7 +684,7 @@ again:
 static int fio_rdmaio_send(struct thread_data *td, struct io_u **io_us,
 			   unsigned int nr)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_send_wr *bad_wr;
 #if 0
 	enum ibv_wc_opcode comp_opcode;
@@ -747,7 +747,7 @@ static int fio_rdmaio_send(struct thread_data *td, struct io_u **io_us,
 static int fio_rdmaio_recv(struct thread_data *td, struct io_u **io_us,
 			   unsigned int nr)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_recv_wr *bad_wr;
 	struct rdma_io_u_data *r_io_u_d;
 	int i;
@@ -783,7 +783,7 @@ static int fio_rdmaio_recv(struct thread_data *td, struct io_u **io_us,
 
 static int fio_rdmaio_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 
 	fio_ro_check(td, io_u);
 
@@ -801,7 +801,7 @@ static int fio_rdmaio_queue(struct thread_data *td, struct io_u *io_u)
 static void fio_rdmaio_queued(struct thread_data *td, struct io_u **io_us,
 			      unsigned int nr)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct timeval now;
 	unsigned int i;
 
@@ -824,7 +824,7 @@ static void fio_rdmaio_queued(struct thread_data *td, struct io_u **io_us,
 
 static int fio_rdmaio_commit(struct thread_data *td)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct io_u **io_us;
 	int ret;
 
@@ -856,7 +856,7 @@ static int fio_rdmaio_commit(struct thread_data *td)
 
 static int fio_rdmaio_connect(struct thread_data *td, struct fio_file *f)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct rdma_conn_param conn_param;
 	struct ibv_send_wr *bad_wr;
 
@@ -907,7 +907,7 @@ static int fio_rdmaio_connect(struct thread_data *td, struct fio_file *f)
 
 static int fio_rdmaio_accept(struct thread_data *td, struct fio_file *f)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct rdma_conn_param conn_param;
 	struct ibv_send_wr *bad_wr;
 	int ret = 0;
@@ -952,7 +952,7 @@ static int fio_rdmaio_open_file(struct thread_data *td, struct fio_file *f)
 
 static int fio_rdmaio_close_file(struct thread_data *td, struct fio_file *f)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_send_wr *bad_wr;
 
 	/* unregister rdma buffer */
@@ -1008,7 +1008,7 @@ static int fio_rdmaio_close_file(struct thread_data *td, struct fio_file *f)
 static int fio_rdmaio_setup_connect(struct thread_data *td, const char *host,
 				    unsigned short port)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_recv_wr *bad_wr;
 	int err;
 
@@ -1072,7 +1072,7 @@ static int fio_rdmaio_setup_connect(struct thread_data *td, const char *host,
 
 static int fio_rdmaio_setup_listen(struct thread_data *td, short port)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct ibv_recv_wr *bad_wr;
 	int state = td->runstate;
 
@@ -1207,7 +1207,7 @@ bad_host:
 
 static int fio_rdmaio_init(struct thread_data *td)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 	struct rdmaio_options *o = td->eo;
 	unsigned int max_bs;
 	int ret, i;
@@ -1316,7 +1316,7 @@ static int fio_rdmaio_init(struct thread_data *td)
 
 static void fio_rdmaio_cleanup(struct thread_data *td)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_data *rd = td->io_ops_data;
 
 	if (rd)
 		free(rd);
@@ -1332,12 +1332,12 @@ static int fio_rdmaio_setup(struct thread_data *td)
 		td->o.open_files++;
 	}
 
-	if (!td->io_ops->data) {
+	if (!td->io_ops_data) {
 		rd = malloc(sizeof(*rd));
 
 		memset(rd, 0, sizeof(*rd));
 		init_rand_seed(&rd->rand_state, (unsigned int) GOLDEN_RATIO_PRIME, 0);
-		td->io_ops->data = rd;
+		td->io_ops_data = rd;
 	}
 
 	return 0;
diff --git a/engines/sg.c b/engines/sg.c
index 360775f..c1fe602 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -102,7 +102,7 @@ static int fio_sgio_getevents(struct thread_data *td, unsigned int min,
 			      unsigned int max,
 			      const struct timespec fio_unused *t)
 {
-	struct sgio_data *sd = td->io_ops->data;
+	struct sgio_data *sd = td->io_ops_data;
 	int left = max, eventNum, ret, r = 0;
 	void *buf = sd->sgbuf;
 	unsigned int i, events;
@@ -207,7 +207,7 @@ re_read:
 static int fio_sgio_ioctl_doio(struct thread_data *td,
 			       struct fio_file *f, struct io_u *io_u)
 {
-	struct sgio_data *sd = td->io_ops->data;
+	struct sgio_data *sd = td->io_ops_data;
 	struct sg_io_hdr *hdr = &io_u->hdr;
 	int ret;
 
@@ -268,7 +268,7 @@ static int fio_sgio_doio(struct thread_data *td, struct io_u *io_u, int do_sync)
 static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct sg_io_hdr *hdr = &io_u->hdr;
-	struct sgio_data *sd = td->io_ops->data;
+	struct sgio_data *sd = td->io_ops_data;
 	long long nr_blocks, lba;
 
 	if (io_u->xfer_buflen & (sd->bs - 1)) {
@@ -366,7 +366,7 @@ static int fio_sgio_queue(struct thread_data *td, struct io_u *io_u)
 
 static struct io_u *fio_sgio_event(struct thread_data *td, int event)
 {
-	struct sgio_data *sd = td->io_ops->data;
+	struct sgio_data *sd = td->io_ops_data;
 
 	return sd->events[event];
 }
@@ -463,7 +463,7 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 
 static void fio_sgio_cleanup(struct thread_data *td)
 {
-	struct sgio_data *sd = td->io_ops->data;
+	struct sgio_data *sd = td->io_ops_data;
 
 	if (sd) {
 		free(sd->events);
@@ -492,7 +492,7 @@ static int fio_sgio_init(struct thread_data *td)
 	sd->sgbuf = malloc(sizeof(struct sg_io_hdr) * td->o.iodepth);
 	memset(sd->sgbuf, 0, sizeof(struct sg_io_hdr) * td->o.iodepth);
 	sd->type_checked = 0;
-	td->io_ops->data = sd;
+	td->io_ops_data = sd;
 
 	/*
 	 * we want to do it, regardless of whether odirect is set or not
@@ -503,7 +503,7 @@ static int fio_sgio_init(struct thread_data *td)
 
 static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 {
-	struct sgio_data *sd = td->io_ops->data;
+	struct sgio_data *sd = td->io_ops_data;
 	unsigned int bs = 0;
 	unsigned long long max_lba = 0;
 
@@ -552,7 +552,7 @@ static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 
 static int fio_sgio_open(struct thread_data *td, struct fio_file *f)
 {
-	struct sgio_data *sd = td->io_ops->data;
+	struct sgio_data *sd = td->io_ops_data;
 	int ret;
 
 	ret = generic_open_file(td, f);
diff --git a/engines/solarisaio.c b/engines/solarisaio.c
index 55a0cb9..151f31d 100644
--- a/engines/solarisaio.c
+++ b/engines/solarisaio.c
@@ -28,7 +28,7 @@ static int fio_solarisaio_cancel(struct thread_data fio_unused *td,
 static int fio_solarisaio_prep(struct thread_data fio_unused *td,
 			    struct io_u *io_u)
 {
-	struct solarisaio_data *sd = td->io_ops->data;
+	struct solarisaio_data *sd = td->io_ops_data;
 
 	io_u->resultp.aio_return = AIO_INPROGRESS;
 	io_u->engine_data = sd;
@@ -75,7 +75,7 @@ static void wait_for_event(struct timeval *tv)
 static int fio_solarisaio_getevents(struct thread_data *td, unsigned int min,
 				    unsigned int max, const struct timespec *t)
 {
-	struct solarisaio_data *sd = td->io_ops->data;
+	struct solarisaio_data *sd = td->io_ops_data;
 	struct timeval tv;
 	int ret;
 
@@ -100,7 +100,7 @@ static int fio_solarisaio_getevents(struct thread_data *td, unsigned int min,
 
 static struct io_u *fio_solarisaio_event(struct thread_data *td, int event)
 {
-	struct solarisaio_data *sd = td->io_ops->data;
+	struct solarisaio_data *sd = td->io_ops_data;
 
 	return sd->aio_events[event];
 }
@@ -108,7 +108,7 @@ static struct io_u *fio_solarisaio_event(struct thread_data *td, int event)
 static int fio_solarisaio_queue(struct thread_data fio_unused *td,
 			      struct io_u *io_u)
 {
-	struct solarisaio_data *sd = td->io_ops->data;
+	struct solarisaio_data *sd = td->io_ops_data;
 	struct fio_file *f = io_u->file;
 	off_t off;
 	int ret;
@@ -155,7 +155,7 @@ static int fio_solarisaio_queue(struct thread_data fio_unused *td,
 
 static void fio_solarisaio_cleanup(struct thread_data *td)
 {
-	struct solarisaio_data *sd = td->io_ops->data;
+	struct solarisaio_data *sd = td->io_ops_data;
 
 	if (sd) {
 		free(sd->aio_events);
@@ -204,7 +204,7 @@ static int fio_solarisaio_init(struct thread_data *td)
 	fio_solarisaio_init_sigio();
 #endif
 
-	td->io_ops->data = sd;
+	td->io_ops_data = sd;
 	return 0;
 }
 
diff --git a/engines/splice.c b/engines/splice.c
index f35ae17..eba093e 100644
--- a/engines/splice.c
+++ b/engines/splice.c
@@ -28,7 +28,7 @@ struct spliceio_data {
  */
 static int fio_splice_read_old(struct thread_data *td, struct io_u *io_u)
 {
-	struct spliceio_data *sd = td->io_ops->data;
+	struct spliceio_data *sd = td->io_ops_data;
 	struct fio_file *f = io_u->file;
 	int ret, ret2, buflen;
 	off_t offset;
@@ -72,7 +72,7 @@ static int fio_splice_read_old(struct thread_data *td, struct io_u *io_u)
  */
 static int fio_splice_read(struct thread_data *td, struct io_u *io_u)
 {
-	struct spliceio_data *sd = td->io_ops->data;
+	struct spliceio_data *sd = td->io_ops_data;
 	struct fio_file *f = io_u->file;
 	struct iovec iov;
 	int ret , buflen, mmap_len;
@@ -166,7 +166,7 @@ static int fio_splice_read(struct thread_data *td, struct io_u *io_u)
  */
 static int fio_splice_write(struct thread_data *td, struct io_u *io_u)
 {
-	struct spliceio_data *sd = td->io_ops->data;
+	struct spliceio_data *sd = td->io_ops_data;
 	struct iovec iov = {
 		.iov_base = io_u->xfer_buf,
 		.iov_len = io_u->xfer_buflen,
@@ -201,7 +201,7 @@ static int fio_splice_write(struct thread_data *td, struct io_u *io_u)
 
 static int fio_spliceio_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct spliceio_data *sd = td->io_ops->data;
+	struct spliceio_data *sd = td->io_ops_data;
 	int ret = 0;
 
 	fio_ro_check(td, io_u);
@@ -247,7 +247,7 @@ static int fio_spliceio_queue(struct thread_data *td, struct io_u *io_u)
 
 static void fio_spliceio_cleanup(struct thread_data *td)
 {
-	struct spliceio_data *sd = td->io_ops->data;
+	struct spliceio_data *sd = td->io_ops_data;
 
 	if (sd) {
 		close(sd->pipe[0]);
@@ -284,7 +284,7 @@ static int fio_spliceio_init(struct thread_data *td)
 	if (td_read(td))
 		td->o.mem_align = 1;
 
-	td->io_ops->data = sd;
+	td->io_ops_data = sd;
 	return 0;
 }
 
diff --git a/engines/sync.c b/engines/sync.c
index 433e4fa..1726b8e 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -97,7 +97,7 @@ static int fio_io_end(struct thread_data *td, struct io_u *io_u, int ret)
 #ifdef CONFIG_PWRITEV
 static int fio_pvsyncio_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 	struct iovec *iov = &sd->iovecs[0];
 	struct fio_file *f = io_u->file;
 	int ret;
@@ -124,7 +124,7 @@ static int fio_pvsyncio_queue(struct thread_data *td, struct io_u *io_u)
 #ifdef FIO_HAVE_PWRITEV2
 static int fio_pvsyncio2_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 	struct psyncv2_options *o = td->eo;
 	struct iovec *iov = &sd->iovecs[0];
 	struct fio_file *f = io_u->file;
@@ -197,7 +197,7 @@ static int fio_vsyncio_getevents(struct thread_data *td, unsigned int min,
 				 unsigned int max,
 				 const struct timespec fio_unused *t)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 	int ret;
 
 	if (min) {
@@ -212,14 +212,14 @@ static int fio_vsyncio_getevents(struct thread_data *td, unsigned int min,
 
 static struct io_u *fio_vsyncio_event(struct thread_data *td, int event)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 
 	return sd->io_us[event];
 }
 
 static int fio_vsyncio_append(struct thread_data *td, struct io_u *io_u)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 
 	if (ddir_sync(io_u->ddir))
 		return 0;
@@ -246,7 +246,7 @@ static void fio_vsyncio_set_iov(struct syncio_data *sd, struct io_u *io_u,
 
 static int fio_vsyncio_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 
 	fio_ro_check(td, io_u);
 
@@ -286,7 +286,7 @@ static int fio_vsyncio_queue(struct thread_data *td, struct io_u *io_u)
  */
 static int fio_vsyncio_end(struct thread_data *td, ssize_t bytes)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 	struct io_u *io_u;
 	unsigned int i;
 	int err;
@@ -326,7 +326,7 @@ static int fio_vsyncio_end(struct thread_data *td, ssize_t bytes)
 
 static int fio_vsyncio_commit(struct thread_data *td)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 	struct fio_file *f;
 	ssize_t ret;
 
@@ -364,13 +364,13 @@ static int fio_vsyncio_init(struct thread_data *td)
 	sd->iovecs = malloc(td->o.iodepth * sizeof(struct iovec));
 	sd->io_us = malloc(td->o.iodepth * sizeof(struct io_u *));
 
-	td->io_ops->data = sd;
+	td->io_ops_data = sd;
 	return 0;
 }
 
 static void fio_vsyncio_cleanup(struct thread_data *td)
 {
-	struct syncio_data *sd = td->io_ops->data;
+	struct syncio_data *sd = td->io_ops_data;
 
 	if (sd) {
 		free(sd->iovecs);
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index cbbed6a..0e164b6 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -84,7 +84,7 @@ static int fio_windowsaio_init(struct thread_data *td)
 		}
 	}
 
-	td->io_ops->data = wd;
+	td->io_ops_data = wd;
 
 	if (!rc) {
 		struct thread_ctx *ctx;
@@ -97,7 +97,7 @@ static int fio_windowsaio_init(struct thread_data *td)
 			rc = 1;
 		}
 
-		wd = td->io_ops->data;
+		wd = td->io_ops_data;
 		wd->iothread_running = TRUE;
 		wd->iocp = hFile;
 
@@ -131,7 +131,7 @@ static void fio_windowsaio_cleanup(struct thread_data *td)
 {
 	struct windowsaio_data *wd;
 
-	wd = td->io_ops->data;
+	wd = td->io_ops_data;
 
 	if (wd != NULL) {
 		wd->iothread_running = FALSE;
@@ -143,7 +143,7 @@ static void fio_windowsaio_cleanup(struct thread_data *td)
 		free(wd->aio_events);
 		free(wd);
 
-		td->io_ops->data = NULL;
+		td->io_ops_data = NULL;
 	}
 }
 
@@ -203,10 +203,10 @@ static int fio_windowsaio_open_file(struct thread_data *td, struct fio_file *f)
 
 	/* Only set up the completion port and thread if we're not just
 	 * querying the device size */
-	if (!rc && td->io_ops->data != NULL) {
+	if (!rc && td->io_ops_data != NULL) {
 		struct windowsaio_data *wd;
 
-		wd = td->io_ops->data;
+		wd = td->io_ops_data;
 
 		if (CreateIoCompletionPort(f->hFile, wd->iocp, 0, 0) == NULL) {
 			log_err("windowsaio: failed to create io completion port\n");
@@ -251,7 +251,7 @@ static BOOL timeout_expired(DWORD start_count, DWORD end_count)
 
 static struct io_u* fio_windowsaio_event(struct thread_data *td, int event)
 {
-	struct windowsaio_data *wd = td->io_ops->data;
+	struct windowsaio_data *wd = td->io_ops_data;
 	return wd->aio_events[event];
 }
 
@@ -259,7 +259,7 @@ static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
 				    unsigned int max,
 				    const struct timespec *t)
 {
-	struct windowsaio_data *wd = td->io_ops->data;
+	struct windowsaio_data *wd = td->io_ops_data;
 	unsigned int dequeued = 0;
 	struct io_u *io_u;
 	int i;
diff --git a/fio.h b/fio.h
index 8a0ebe3..87a94f6 100644
--- a/fio.h
+++ b/fio.h
@@ -227,6 +227,12 @@ struct thread_data {
 	struct ioengine_ops *io_ops;
 
 	/*
+	 * IO engine private data and dlhandle.
+	 */
+	void *io_ops_data;
+	void *io_ops_dlhandle;
+
+	/*
 	 * Queue depth of io_u's that fio MIGHT do
 	 */
 	unsigned int cur_depth;
diff --git a/ioengine.h b/ioengine.h
index 161acf5..0effade 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -163,8 +163,6 @@ struct ioengine_ops {
 	void (*io_u_free)(struct thread_data *, struct io_u *);
 	int option_struct_size;
 	struct fio_option *options;
-	void *data;
-	void *dlhandle;
 };
 
 enum fio_ioengine_flags {
diff --git a/ioengines.c b/ioengines.c
index e2e7280..918b50a 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -119,13 +119,13 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 		return NULL;
 	}
 
-	ops->dlhandle = dlhandle;
+	td->io_ops_dlhandle = dlhandle;
 	return ops;
 }
 
 struct ioengine_ops *load_ioengine(struct thread_data *td, const char *name)
 {
-	struct ioengine_ops *ops, *ret;
+	struct ioengine_ops *ops;
 	char engine[16];
 
 	dprint(FD_IO, "load ioengine %s\n", name);
@@ -153,11 +153,7 @@ struct ioengine_ops *load_ioengine(struct thread_data *td, const char *name)
 	if (check_engine_ops(ops))
 		return NULL;
 
-	ret = malloc(sizeof(*ret));
-	memcpy(ret, ops, sizeof(*ret));
-	ret->data = NULL;
-
-	return ret;
+	return ops;
 }
 
 /*
@@ -173,10 +169,9 @@ void free_ioengine(struct thread_data *td)
 		td->eo = NULL;
 	}
 
-	if (td->io_ops->dlhandle)
-		dlclose(td->io_ops->dlhandle);
+	if (td->io_ops_dlhandle)
+		dlclose(td->io_ops_dlhandle);
 
-	free(td->io_ops);
 	td->io_ops = NULL;
 }
 
@@ -186,7 +181,7 @@ void close_ioengine(struct thread_data *td)
 
 	if (td->io_ops->cleanup) {
 		td->io_ops->cleanup(td);
-		td->io_ops->data = NULL;
+		td->io_ops_data = NULL;
 	}
 
 	free_ioengine(td);
-- 
2.5.5


