Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40070 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfHPMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 16 Aug 2019 08:00:05 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hyato-0007D5-Ha
        for fio@vger.kernel.org; Fri, 16 Aug 2019 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190816120001.BF3462C0678@kernel.dk>
Date: Fri, 16 Aug 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dc54b6ca3209c2da3df30e96d097f6de29d56d24:

  eta: use struct jobs_eta_packed (2019-08-14 15:16:09 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4e8c82b4e9804c52bf2c78327cc5bfca9d8aedfc:

  nbd: Update for libnbd 0.9.8 (2019-08-15 10:42:01 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      stat: ensure that struct jobs_eta packs nicely

Richard W.M. Jones (1):
      nbd: Update for libnbd 0.9.8

 configure     |  2 +-
 engines/nbd.c | 33 ++++++++++++---------------------
 server.h      |  2 +-
 stat.h        | 15 +++++++++------
 4 files changed, 23 insertions(+), 29 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index b11b2dce..b174a6fc 100755
--- a/configure
+++ b/configure
@@ -2020,7 +2020,7 @@ print_config "iscsi engine" "$libiscsi"
 
 ##########################################
 # Check if we have libnbd (for NBD support).
-minimum_libnbd=0.9.6
+minimum_libnbd=0.9.8
 if test "$libnbd" = "yes" ; then
   if $(pkg-config --atleast-version=$minimum_libnbd libnbd); then
     libnbd="yes"
diff --git a/engines/nbd.c b/engines/nbd.c
index f8583812..53237929 100644
--- a/engines/nbd.c
+++ b/engines/nbd.c
@@ -152,15 +152,12 @@ static int nbd_init(struct thread_data *td)
 }
 
 /* A command in flight has been completed. */
-static int cmd_completed (unsigned valid_flag, void *vp, int *error)
+static int cmd_completed (void *vp, int *error)
 {
 	struct io_u *io_u;
 	struct nbd_data *nbd_data;
 	struct io_u **completed;
 
-	if (!(valid_flag & LIBNBD_CALLBACK_VALID))
-		return 0;
-
 	io_u = vp;
 	nbd_data = io_u->engine_data;
 
@@ -195,6 +192,8 @@ static enum fio_q_status nbd_queue(struct thread_data *td,
 				   struct io_u *io_u)
 {
 	struct nbd_data *nbd_data = td->io_ops_data;
+	nbd_completion_callback completion = { .callback = cmd_completed,
+					       .user_data = io_u };
 	int r;
 
 	fio_ro_check(td, io_u);
@@ -206,32 +205,24 @@ static enum fio_q_status nbd_queue(struct thread_data *td,
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
-		r = nbd_aio_pread_callback(nbd_data->nbd,
-					   io_u->xfer_buf, io_u->xfer_buflen,
-					   io_u->offset,
-					   cmd_completed, io_u,
-					   0);
+		r = nbd_aio_pread(nbd_data->nbd,
+				  io_u->xfer_buf, io_u->xfer_buflen,
+				  io_u->offset, completion, 0);
 		break;
 	case DDIR_WRITE:
-		r = nbd_aio_pwrite_callback(nbd_data->nbd,
-					    io_u->xfer_buf, io_u->xfer_buflen,
-					    io_u->offset,
-					    cmd_completed, io_u,
-					    0);
+		r = nbd_aio_pwrite(nbd_data->nbd,
+				   io_u->xfer_buf, io_u->xfer_buflen,
+				   io_u->offset, completion, 0);
 		break;
 	case DDIR_TRIM:
-		r = nbd_aio_trim_callback(nbd_data->nbd, io_u->xfer_buflen,
-					  io_u->offset,
-					  cmd_completed, io_u,
-					  0);
+		r = nbd_aio_trim(nbd_data->nbd, io_u->xfer_buflen,
+				 io_u->offset, completion, 0);
 		break;
 	case DDIR_SYNC:
 		/* XXX We could probably also handle
 		 * DDIR_SYNC_FILE_RANGE with a bit of effort.
 		 */
-		r = nbd_aio_flush_callback(nbd_data->nbd,
-					   cmd_completed, io_u,
-					   0);
+		r = nbd_aio_flush(nbd_data->nbd, completion, 0);
 		break;
 	default:
 		io_u->error = EINVAL;
diff --git a/server.h b/server.h
index abb23bad..ac713252 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 78,
+	FIO_SERVER_VER			= 79,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.h b/stat.h
index c209ab6c..ba7e290d 100644
--- a/stat.h
+++ b/stat.h
@@ -258,13 +258,15 @@ struct thread_stat {
 	uint32_t nr_pending;						\
 	uint32_t nr_setting_up;						\
 									\
-	uint64_t m_rate[DDIR_RWDIR_CNT], t_rate[DDIR_RWDIR_CNT];	\
+	uint64_t m_rate[DDIR_RWDIR_CNT];				\
+	uint64_t t_rate[DDIR_RWDIR_CNT];				\
 	uint64_t rate[DDIR_RWDIR_CNT];					\
-	uint32_t m_iops[DDIR_RWDIR_CNT] __attribute__((packed));	\
-	uint32_t t_iops[DDIR_RWDIR_CNT] __attribute__((packed));	\
-	uint32_t iops[DDIR_RWDIR_CNT] __attribute__((packed));		\
-	uint64_t elapsed_sec __attribute__((packed));			\
-	uint64_t eta_sec __attribute__((packed));			\
+	uint32_t m_iops[DDIR_RWDIR_CNT];				\
+	uint32_t t_iops[DDIR_RWDIR_CNT];				\
+	uint32_t iops[DDIR_RWDIR_CNT];					\
+	uint32_t pad;							\
+	uint64_t elapsed_sec;						\
+	uint64_t eta_sec;						\
 	uint32_t is_pow2;						\
 	uint32_t unit_base;						\
 									\
@@ -276,6 +278,7 @@ struct thread_stat {
 	 * Network 'copy' of run_str[]					\
 	 */								\
 	uint32_t nr_threads;						\
+	uint32_t pad2;							\
 	uint8_t run_str[];						\
 }
 

