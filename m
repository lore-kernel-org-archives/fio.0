Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33241 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333AbcDEMAb (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 5 Apr 2016 08:00:31 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1anPeO-0000sv-1A
	for fio@vger.kernel.org; Tue, 05 Apr 2016 12:00:20 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160405120001.7BB262C00C4@kernel.dk>
Date: Tue,  5 Apr 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 526c403dc9b892ae1dda6ebb2a0f2d5883795d17:

  fio: register pvsync2 engine correctly (2016-04-01 20:56:52 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2a442a30385a3b3a338148be46661f4ea3d9eed1:

  Modify RDMA engine to print strerror messages. (2016-04-04 10:06:03 -0600)

----------------------------------------------------------------
Logan Gunthorpe (1):
      Modify RDMA engine to print strerror messages.

 engines/rdma.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

---

Diff of recent changes:

diff --git a/engines/rdma.c b/engines/rdma.c
index 87ba465..7fbfad9 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -415,7 +415,7 @@ static int fio_rdmaio_setup_qp(struct thread_data *td)
 		rd->pd = ibv_alloc_pd(rd->cm_id->verbs);
 
 	if (rd->pd == NULL) {
-		log_err("fio: ibv_alloc_pd fail\n");
+		log_err("fio: ibv_alloc_pd fail: %m\n");
 		return 1;
 	}
 
@@ -424,7 +424,7 @@ static int fio_rdmaio_setup_qp(struct thread_data *td)
 	else
 		rd->channel = ibv_create_comp_channel(rd->cm_id->verbs);
 	if (rd->channel == NULL) {
-		log_err("fio: ibv_create_comp_channel fail\n");
+		log_err("fio: ibv_create_comp_channel fail: %m\n");
 		goto err1;
 	}
 
@@ -438,12 +438,12 @@ static int fio_rdmaio_setup_qp(struct thread_data *td)
 		rd->cq = ibv_create_cq(rd->cm_id->verbs,
 				       qp_depth, rd, rd->channel, 0);
 	if (rd->cq == NULL) {
-		log_err("fio: ibv_create_cq failed\n");
+		log_err("fio: ibv_create_cq failed: %m\n");
 		goto err2;
 	}
 
 	if (ibv_req_notify_cq(rd->cq, 0) != 0) {
-		log_err("fio: ibv_create_cq failed\n");
+		log_err("fio: ibv_req_notify_cq failed: %m\n");
 		goto err3;
 	}
 
@@ -459,13 +459,13 @@ static int fio_rdmaio_setup_qp(struct thread_data *td)
 
 	if (rd->is_client == 0) {
 		if (rdma_create_qp(rd->child_cm_id, rd->pd, &init_attr) != 0) {
-			log_err("fio: rdma_create_qp failed\n");
+			log_err("fio: rdma_create_qp failed: %m\n");
 			goto err3;
 		}
 		rd->qp = rd->child_cm_id->qp;
 	} else {
 		if (rdma_create_qp(rd->cm_id, rd->pd, &init_attr) != 0) {
-			log_err("fio: rdma_create_qp failed\n");
+			log_err("fio: rdma_create_qp failed: %m\n");
 			goto err3;
 		}
 		rd->qp = rd->cm_id->qp;
@@ -490,14 +490,14 @@ static int fio_rdmaio_setup_control_msg_buffers(struct thread_data *td)
 	rd->recv_mr = ibv_reg_mr(rd->pd, &rd->recv_buf, sizeof(rd->recv_buf),
 				 IBV_ACCESS_LOCAL_WRITE);
 	if (rd->recv_mr == NULL) {
-		log_err("fio: recv_buf reg_mr failed\n");
+		log_err("fio: recv_buf reg_mr failed: %m\n");
 		return 1;
 	}
 
 	rd->send_mr = ibv_reg_mr(rd->pd, &rd->send_buf, sizeof(rd->send_buf),
 				 0);
 	if (rd->send_mr == NULL) {
-		log_err("fio: send_buf reg_mr failed\n");
+		log_err("fio: send_buf reg_mr failed: %m\n");
 		ibv_dereg_mr(rd->recv_mr);
 		return 1;
 	}
@@ -731,7 +731,7 @@ static int fio_rdmaio_send(struct thread_data *td, struct io_u **io_us,
 		}
 
 		if (ibv_post_send(rd->qp, &r_io_u_d->sq_wr, &bad_wr) != 0) {
-			log_err("fio: ibv_post_send fail\n");
+			log_err("fio: ibv_post_send fail: %m\n");
 			return -1;
 		}
 
@@ -759,7 +759,7 @@ static int fio_rdmaio_recv(struct thread_data *td, struct io_u **io_us,
 			r_io_u_d = io_us[i]->engine_data;
 			if (ibv_post_recv(rd->qp, &r_io_u_d->rq_wr, &bad_wr) !=
 			    0) {
-				log_err("fio: ibv_post_recv fail\n");
+				log_err("fio: ibv_post_recv fail: %m\n");
 				return 1;
 			}
 		}
@@ -767,7 +767,7 @@ static int fio_rdmaio_recv(struct thread_data *td, struct io_u **io_us,
 		   || (rd->rdma_protocol == FIO_RDMA_MEM_WRITE)) {
 		/* re-post the rq_wr */
 		if (ibv_post_recv(rd->qp, &rd->rq_wr, &bad_wr) != 0) {
-			log_err("fio: ibv_post_recv fail\n");
+			log_err("fio: ibv_post_recv fail: %m\n");
 			return 1;
 		}
 
@@ -866,7 +866,7 @@ static int fio_rdmaio_connect(struct thread_data *td, struct fio_file *f)
 	conn_param.retry_count = 10;
 
 	if (rdma_connect(rd->cm_id, &conn_param) != 0) {
-		log_err("fio: rdma_connect fail\n");
+		log_err("fio: rdma_connect fail: %m\n");
 		return 1;
 	}
 
@@ -881,7 +881,7 @@ static int fio_rdmaio_connect(struct thread_data *td, struct fio_file *f)
 	rd->send_buf.nr = htonl(td->o.iodepth);
 
 	if (ibv_post_send(rd->qp, &rd->sq_wr, &bad_wr) != 0) {
-		log_err("fio: ibv_post_send fail");
+		log_err("fio: ibv_post_send fail: %m");
 		return 1;
 	}
 
@@ -918,7 +918,7 @@ static int fio_rdmaio_accept(struct thread_data *td, struct fio_file *f)
 	conn_param.initiator_depth = 1;
 
 	if (rdma_accept(rd->child_cm_id, &conn_param) != 0) {
-		log_err("fio: rdma_accept\n");
+		log_err("fio: rdma_accept: %m\n");
 		return 1;
 	}
 
@@ -932,7 +932,7 @@ static int fio_rdmaio_accept(struct thread_data *td, struct fio_file *f)
 	ret = rdma_poll_wait(td, IBV_WC_RECV) < 0;
 
 	if (ibv_post_send(rd->qp, &rd->sq_wr, &bad_wr) != 0) {
-		log_err("fio: ibv_post_send fail");
+		log_err("fio: ibv_post_send fail: %m");
 		return 1;
 	}
 
@@ -965,7 +965,7 @@ static int fio_rdmaio_close_file(struct thread_data *td, struct fio_file *f)
 				     || (rd->rdma_protocol ==
 					 FIO_RDMA_MEM_READ))) {
 		if (ibv_post_send(rd->qp, &rd->sq_wr, &bad_wr) != 0) {
-			log_err("fio: ibv_post_send fail");
+			log_err("fio: ibv_post_send fail: %m");
 			return 1;
 		}
 
@@ -1084,12 +1084,12 @@ static int fio_rdmaio_setup_listen(struct thread_data *td, short port)
 
 	/* rdma_listen */
 	if (rdma_bind_addr(rd->cm_id, (struct sockaddr *)&rd->addr) != 0) {
-		log_err("fio: rdma_bind_addr fail\n");
+		log_err("fio: rdma_bind_addr fail: %m\n");
 		return 1;
 	}
 
 	if (rdma_listen(rd->cm_id, 3) != 0) {
-		log_err("fio: rdma_listen fail\n");
+		log_err("fio: rdma_listen fail: %m\n");
 		return 1;
 	}
 
@@ -1110,7 +1110,7 @@ static int fio_rdmaio_setup_listen(struct thread_data *td, short port)
 
 	/* post recv buf */
 	if (ibv_post_recv(rd->qp, &rd->rq_wr, &bad_wr) != 0) {
-		log_err("fio: ibv_post_recv fail\n");
+		log_err("fio: ibv_post_recv fail: %m\n");
 		return 1;
 	}
 
@@ -1238,13 +1238,13 @@ static int fio_rdmaio_init(struct thread_data *td)
 
 	rd->cm_channel = rdma_create_event_channel();
 	if (!rd->cm_channel) {
-		log_err("fio: rdma_create_event_channel fail\n");
+		log_err("fio: rdma_create_event_channel fail: %m\n");
 		return 1;
 	}
 
 	ret = rdma_create_id(rd->cm_channel, &rd->cm_id, rd, RDMA_PS_TCP);
 	if (ret) {
-		log_err("fio: rdma_create_id fail\n");
+		log_err("fio: rdma_create_id fail: %m\n");
 		return 1;
 	}
 
@@ -1295,7 +1295,7 @@ static int fio_rdmaio_init(struct thread_data *td)
 				      IBV_ACCESS_REMOTE_READ |
 				      IBV_ACCESS_REMOTE_WRITE);
 		if (io_u->mr == NULL) {
-			log_err("fio: ibv_reg_mr io_u failed\n");
+			log_err("fio: ibv_reg_mr io_u failed: %m\n");
 			return 1;
 		}
 
