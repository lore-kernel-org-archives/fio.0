Return-Path: <fio-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:60734 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab1HFSjI (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 6 Aug 2011 14:39:08 -0400
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/3] RDMA engine spelling fix: change FIO_RDMA_MAX_IO_DPETH into FIO_RDMA_MAX_IO_DEPTH
Date: Sat, 6 Aug 2011 20:17:19 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108062017.19964.bvanassche@acm.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>, Ren Yufei <renyufei83@yahoo.com.cn>

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Ren Yufei <renyufei83@yahoo.com.cn>
Cc: Jens Axboe <jaxboe@fusionio.com>

---
 engines/rdma.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/engines/rdma.c b/engines/rdma.c
index 060927a..61a90b8 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -40,7 +40,7 @@
 #include <rdma/rdma_cma.h>
 #include <infiniband/arch.h>
 
-#define FIO_RDMA_MAX_IO_DPETH    128
+#define FIO_RDMA_MAX_IO_DEPTH    128
 
 enum rdma_io_mode {
 	FIO_RDMA_UNKNOWN = 0,
@@ -61,7 +61,7 @@ struct rdma_info_blk {
 	uint32_t nr;		/* client: io depth
 				   server: number of records for memory semantic
 				 */
-	struct remote_u rmt_us[FIO_RDMA_MAX_IO_DPETH];
+	struct remote_u rmt_us[FIO_RDMA_MAX_IO_DEPTH];
 };
 
 struct rdma_io_u_data {
@@ -145,7 +145,7 @@ static int server_recv(struct thread_data *td, struct ibv_wc *wc)
 {
 	struct rdmaio_data *rd = td->io_ops->data;
 
-	if (wc->wr_id == FIO_RDMA_MAX_IO_DPETH) {
+	if (wc->wr_id == FIO_RDMA_MAX_IO_DEPTH) {
 		rd->rdma_protocol = ntohl(rd->recv_buf.mode);
 
 		/* CHANNEL semantic, do nothing */
@@ -183,7 +183,7 @@ static int cq_event_handler(struct thread_data *td, enum ibv_wc_opcode opcode)
 			else
 				server_recv(td, &wc);
 
-			if (wc.wr_id == FIO_RDMA_MAX_IO_DPETH)
+			if (wc.wr_id == FIO_RDMA_MAX_IO_DEPTH)
 				break;
 
 			for (i = 0; i < rd->io_u_flight_nr; i++) {
@@ -218,7 +218,7 @@ static int cq_event_handler(struct thread_data *td, enum ibv_wc_opcode opcode)
 		case IBV_WC_SEND:
 		case IBV_WC_RDMA_WRITE:
 		case IBV_WC_RDMA_READ:
-			if (wc.wr_id == FIO_RDMA_MAX_IO_DPETH)
+			if (wc.wr_id == FIO_RDMA_MAX_IO_DEPTH)
 				break;
 
 			for (i = 0; i < rd->io_u_flight_nr; i++) {
@@ -405,7 +405,7 @@ static int fio_rdmaio_setup_control_msg_buffers(struct thread_data *td)
 	rd->recv_sgl.lkey = rd->recv_mr->lkey;
 	rd->rq_wr.sg_list = &rd->recv_sgl;
 	rd->rq_wr.num_sge = 1;
-	rd->rq_wr.wr_id = FIO_RDMA_MAX_IO_DPETH;
+	rd->rq_wr.wr_id = FIO_RDMA_MAX_IO_DEPTH;
 
 	/* send wq */
 	rd->send_sgl.addr = (uint64_t) (unsigned long)&rd->send_buf;
@@ -416,7 +416,7 @@ static int fio_rdmaio_setup_control_msg_buffers(struct thread_data *td)
 	rd->sq_wr.send_flags = IBV_SEND_SIGNALED;
 	rd->sq_wr.sg_list = &rd->send_sgl;
 	rd->sq_wr.num_sge = 1;
-	rd->sq_wr.wr_id = FIO_RDMA_MAX_IO_DPETH;
+	rd->sq_wr.wr_id = FIO_RDMA_MAX_IO_DEPTH;
 
 	return 0;
 }
@@ -1087,9 +1087,9 @@ static int fio_rdmaio_init(struct thread_data *td)
 	if ((rd->rdma_protocol == FIO_RDMA_MEM_WRITE) ||
 	    (rd->rdma_protocol == FIO_RDMA_MEM_READ)) {
 		rd->rmt_us =
-			malloc(FIO_RDMA_MAX_IO_DPETH * sizeof(struct remote_u));
+			malloc(FIO_RDMA_MAX_IO_DEPTH * sizeof(struct remote_u));
 		memset(rd->rmt_us, 0,
-			FIO_RDMA_MAX_IO_DPETH * sizeof(struct remote_u));
+			FIO_RDMA_MAX_IO_DEPTH * sizeof(struct remote_u));
 		rd->rmt_nr = 0;
 	}
 
-- 
1.7.3.4

