Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59479 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbbGNMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Jul 2015 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZEysY-0006B7-B5
	for fio@vger.kernel.org; Tue, 14 Jul 2015 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150714120002.689012C00B7@kernel.dk>
Date: Tue, 14 Jul 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7627557b4795971e0a7565f51415697c71d27c6b:

  buffer: only set refill_buffers, it it wasn't set manually (2015-07-10 09:27:02 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4fbe186054f09654f31c9a77b743d2aa40c85e54:

  HOWTO: spelling error (2015-07-13 14:35:30 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Update README for DragonFly
      HOWTO: fix long line
      HOWTO: spelling error

Logan Gunthorpe (2):
      Error when the block size on the RDMA server is less than the client
      RDMA engine server mode flow fix ups.

 HOWTO          |  6 +++---
 README         |  7 ++++---
 engines/rdma.c | 53 +++++++++++++++++++++++++++++++++++++++++++++--------
 eta.c          | 13 +++++++++++--
 fio.h          |  1 +
 5 files changed, 64 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index b823eae..b61a638 100644
--- a/HOWTO
+++ b/HOWTO
@@ -198,7 +198,7 @@ sections.
 -------------------------
 
 fio also supports environment variable expansion in job files. Any
-substring of the form "${VARNAME}" as part of an option value (in other
+sub-string of the form "${VARNAME}" as part of an option value (in other
 words, on the right of the `='), will be expanded to the value of the
 environment variable called VARNAME.  If no such environment variable
 is defined, or VARNAME is the empty string, the empty string will be
@@ -875,8 +875,8 @@ fsync=int	If writing to a file, issue a sync of the dirty data
 
 fdatasync=int	Like fsync= but uses fdatasync() to only sync data and not
 		metadata blocks.
-		In FreeBSD and Windows there is no fdatasync(), this falls back to
-		using fsync()
+		In FreeBSD and Windows there is no fdatasync(), this falls back
+		to using fsync()
 
 sync_file_range=str:val	Use sync_file_range() for every 'val' number of
 		write operations. Fio will track range of writes that
diff --git a/README b/README
index 25189f8..ab42f1b 100644
--- a/README
+++ b/README
@@ -345,9 +345,10 @@ Platforms
 ---------
 
 Fio works on (at least) Linux, Solaris, AIX, HP-UX, OSX, NetBSD, OpenBSD,
-Windows and FreeBSD.  Some features and/or options may only be available on
-some of the platforms, typically because those features only apply to that
-platform (like the solarisaio engine, or the splice engine on Linux).
+Windows, FreeBSD, and DragonFly. Some features and/or options may only be
+available on some of the platforms, typically because those features only
+apply to that platform (like the solarisaio engine, or the splice engine on
+Linux).
 
 Some features are not available on FreeBSD/Solaris even if they could be
 implemented, I'd be happy to take patches for that. An example of that is
diff --git a/engines/rdma.c b/engines/rdma.c
index 2ba34e4..7eb0051 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -137,6 +137,7 @@ struct rdma_info_blk {
 	uint32_t nr;		/* client: io depth
 				   server: number of records for memory semantic
 				 */
+	uint32_t max_bs;        /* maximum block size */
 	struct remote_u rmt_us[FIO_RDMA_MAX_IO_DEPTH];
 };
 
@@ -190,12 +191,21 @@ struct rdmaio_data {
 static int client_recv(struct thread_data *td, struct ibv_wc *wc)
 {
 	struct rdmaio_data *rd = td->io_ops->data;
+	unsigned int max_bs;
 
 	if (wc->byte_len != sizeof(rd->recv_buf)) {
 		log_err("Received bogus data, size %d\n", wc->byte_len);
 		return 1;
 	}
 
+	max_bs = max(td->o.max_bs[DDIR_READ], td->o.max_bs[DDIR_WRITE]);
+	if (max_bs > ntohl(rd->recv_buf.max_bs)) {
+		log_err("fio: Server's block size (%d) must be greater than or "
+			"equal to the client's block size (%d)!\n",
+			ntohl(rd->recv_buf.max_bs), max_bs);
+		return 1;
+	}
+
 	/* store mr info for MEMORY semantic */
 	if ((rd->rdma_protocol == FIO_RDMA_MEM_WRITE) ||
 	    (rd->rdma_protocol == FIO_RDMA_MEM_READ)) {
@@ -222,6 +232,7 @@ static int client_recv(struct thread_data *td, struct ibv_wc *wc)
 static int server_recv(struct thread_data *td, struct ibv_wc *wc)
 {
 	struct rdmaio_data *rd = td->io_ops->data;
+	unsigned int max_bs;
 
 	if (wc->wr_id == FIO_RDMA_MAX_IO_DEPTH) {
 		rd->rdma_protocol = ntohl(rd->recv_buf.mode);
@@ -229,6 +240,15 @@ static int server_recv(struct thread_data *td, struct ibv_wc *wc)
 		/* CHANNEL semantic, do nothing */
 		if (rd->rdma_protocol == FIO_RDMA_CHA_SEND)
 			rd->rdma_protocol = FIO_RDMA_CHA_RECV;
+
+		max_bs = max(td->o.max_bs[DDIR_READ], td->o.max_bs[DDIR_WRITE]);
+		if (max_bs < ntohl(rd->recv_buf.max_bs)) {
+			log_err("fio: Server's block size (%d) must be greater than or "
+				"equal to the client's block size (%d)!\n",
+				ntohl(rd->recv_buf.max_bs), max_bs);
+			return 1;
+		}
+
 	}
 
 	return 0;
@@ -257,9 +277,12 @@ static int cq_event_handler(struct thread_data *td, enum ibv_wc_opcode opcode)
 
 		case IBV_WC_RECV:
 			if (rd->is_client == 1)
-				client_recv(td, &wc);
+				ret = client_recv(td, &wc);
 			else
-				server_recv(td, &wc);
+				ret = server_recv(td, &wc);
+
+			if (ret)
+				return -1;
 
 			if (wc.wr_id == FIO_RDMA_MAX_IO_DEPTH)
 				break;
@@ -329,6 +352,7 @@ static int cq_event_handler(struct thread_data *td, enum ibv_wc_opcode opcode)
 		}
 		rd->cq_event_num++;
 	}
+
 	if (ret) {
 		log_err("fio: poll error %d\n", ret);
 		return 1;
@@ -368,7 +392,7 @@ again:
 	}
 
 	ret = cq_event_handler(td, opcode);
-	if (ret < 1)
+	if (ret == 0)
 		goto again;
 
 	ibv_ack_cq_events(rd->cq, ret);
@@ -860,10 +884,12 @@ static int fio_rdmaio_connect(struct thread_data *td, struct fio_file *f)
 		return 1;
 	}
 
-	rdma_poll_wait(td, IBV_WC_SEND);
+	if (rdma_poll_wait(td, IBV_WC_SEND) < 0)
+		return 1;
 
 	/* wait for remote MR info from server side */
-	rdma_poll_wait(td, IBV_WC_RECV);
+	if (rdma_poll_wait(td, IBV_WC_RECV) < 0)
+		return 1;
 
 	/* In SEND/RECV test, it's a good practice to setup the iodepth of
 	 * of the RECV side deeper than that of the SEND side to
@@ -883,6 +909,7 @@ static int fio_rdmaio_accept(struct thread_data *td, struct fio_file *f)
 	struct rdmaio_data *rd = td->io_ops->data;
 	struct rdma_conn_param conn_param;
 	struct ibv_send_wr *bad_wr;
+	int ret = 0;
 
 	/* rdma_accept() - then wait for accept success */
 	memset(&conn_param, 0, sizeof(conn_param));
@@ -901,16 +928,17 @@ static int fio_rdmaio_accept(struct thread_data *td, struct fio_file *f)
 	}
 
 	/* wait for request */
-	rdma_poll_wait(td, IBV_WC_RECV);
+	ret = rdma_poll_wait(td, IBV_WC_RECV) < 0;
 
 	if (ibv_post_send(rd->qp, &rd->sq_wr, &bad_wr) != 0) {
 		log_err("fio: ibv_post_send fail");
 		return 1;
 	}
 
-	rdma_poll_wait(td, IBV_WC_SEND);
+	if (rdma_poll_wait(td, IBV_WC_SEND) < 0)
+		return 1;
 
-	return 0;
+	return ret;
 }
 
 static int fio_rdmaio_open_file(struct thread_data *td, struct fio_file *f)
@@ -1045,6 +1073,9 @@ static int fio_rdmaio_setup_listen(struct thread_data *td, short port)
 {
 	struct rdmaio_data *rd = td->io_ops->data;
 	struct ibv_recv_wr *bad_wr;
+	int state = td->runstate;
+
+	td_set_runstate(td, TD_SETTING_UP);
 
 	rd->addr.sin_family = AF_INET;
 	rd->addr.sin_addr.s_addr = htonl(INADDR_ANY);
@@ -1061,6 +1092,8 @@ static int fio_rdmaio_setup_listen(struct thread_data *td, short port)
 		return 1;
 	}
 
+	log_info("fio: waiting for connection\n");
+
 	/* wait for CONNECT_REQUEST */
 	if (get_next_channel_event
 	    (td, rd->cm_channel, RDMA_CM_EVENT_CONNECT_REQUEST) != 0) {
@@ -1080,6 +1113,7 @@ static int fio_rdmaio_setup_listen(struct thread_data *td, short port)
 		return 1;
 	}
 
+	td_set_runstate(td, state);
 	return 0;
 }
 
@@ -1236,6 +1270,7 @@ static int fio_rdmaio_init(struct thread_data *td)
 
 	if (td_read(td)) {	/* READ as the server */
 		rd->is_client = 0;
+		td->flags |= TD_F_NO_PROGRESS;
 		/* server rd->rdma_buf_len will be setup after got request */
 		ret = fio_rdmaio_setup_listen(td, o->port);
 	} else {		/* WRITE as the client */
@@ -1244,6 +1279,8 @@ static int fio_rdmaio_init(struct thread_data *td)
 	}
 
 	max_bs = max(td->o.max_bs[DDIR_READ], td->o.max_bs[DDIR_WRITE]);
+	rd->send_buf.max_bs = htonl(max_bs);
+
 	/* register each io_u in the free list */
 	for (i = 0; i < td->io_u_freelist.nr; i++) {
 		struct io_u *io_u = td->io_u_freelist.io_us[i];
diff --git a/eta.c b/eta.c
index e458457..aed61ec 100644
--- a/eta.c
+++ b/eta.c
@@ -123,6 +123,11 @@ void eta_to_str(char *str, unsigned long eta_sec)
 	unsigned int d, h, m, s;
 	int disp_hour = 0;
 
+	if (eta_sec == -1) {
+		sprintf(str, "--");
+		return;
+	}
+
 	s = eta_sec % 60;
 	eta_sec /= 60;
 	m = eta_sec % 60;
@@ -146,7 +151,7 @@ void eta_to_str(char *str, unsigned long eta_sec)
 /*
  * Best effort calculation of the estimated pending runtime of a job.
  */
-static int thread_eta(struct thread_data *td)
+static unsigned long thread_eta(struct thread_data *td)
 {
 	unsigned long long bytes_total, bytes_done;
 	unsigned long eta_sec = 0;
@@ -158,6 +163,9 @@ static int thread_eta(struct thread_data *td)
 
 	bytes_total = td->total_io_size;
 
+	if (td->flags & TD_F_NO_PROGRESS)
+		return -1;
+
 	if (td->o.fill_device && td->o.size  == -1ULL) {
 		if (!td->fill_device_size || td->fill_device_size == -1ULL)
 			return 0;
@@ -513,7 +521,8 @@ void display_thread_status(struct jobs_eta *je)
 		int l;
 		int ddir;
 
-		if ((!je->eta_sec && !eta_good) || je->nr_ramp == je->nr_running)
+		if ((!je->eta_sec && !eta_good) || je->nr_ramp == je->nr_running ||
+		    je->eta_sec == -1)
 			strcpy(perc_str, "-.-% done");
 		else {
 			double mult = 100.0;
diff --git a/fio.h b/fio.h
index 819d4fc..744d994 100644
--- a/fio.h
+++ b/fio.h
@@ -78,6 +78,7 @@ enum {
 	TD_F_VSTATE_SAVED	= 1U << 10,
 	TD_F_NEED_LOCK		= 1U << 11,
 	TD_F_CHILD		= 1U << 12,
+	TD_F_NO_PROGRESS        = 1U << 13,
 };
 
 enum {
