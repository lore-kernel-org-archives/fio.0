Return-Path: <rjones@redhat.com>
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH fio] nbd: Update for libnbd 0.9.8.
Date: Thu, 15 Aug 2019 16:30:40 +0100
Message-Id: <20190815153040.4511-1-rjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org
Cc: eblake@redhat.com, axboe@kernel.dk
List-ID: <fio@vger.kernel.org>

As the libnbd API isn't permanently stable until we reach the 1.0
release (expected soon), some code changes are needed to cope with API
changes between 0.9.6 and 0.9.8.  In this case we made changes to
completion handlers after feedback from reviewers.  This fix for fio
incorporates all the changes needed and bumps the minimum version to
libnbd >= 0.9.8.

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 configure     |  2 +-
 engines/nbd.c | 33 ++++++++++++---------------------
 2 files changed, 13 insertions(+), 22 deletions(-)

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
-- 
2.22.0


