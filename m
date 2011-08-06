Return-Path: <fio-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:60723 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab1HFSjI (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 6 Aug 2011 14:39:08 -0400
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/3] RDMA I/O engine: Fix compiler warnings
Date: Sat, 6 Aug 2011 20:22:11 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108062022.11121.bvanassche@acm.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>, Ren Yufei <renyufei83@yahoo.com.cn>

Fix 32-bit mode compiler warnings and a warning about an unused variable.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Ren Yufei <renyufei83@yahoo.com.cn>

---
 engines/rdma.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/engines/rdma.c b/engines/rdma.c
index fa94865..54fd194 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -205,7 +205,7 @@ static int cq_event_handler(struct thread_data *td, enum ibv_wc_opcode opcode)
 				}
 			}
 			if (i == rd->io_u_flight_nr)
-				log_err("fio: recv wr %ld not found\n",
+				log_err("fio: recv wr %" PRId64 " not found\n",
 					wc.wr_id);
 			else {
 				/* put the last one into middle of the list */
@@ -234,7 +234,7 @@ static int cq_event_handler(struct thread_data *td, enum ibv_wc_opcode opcode)
 				}
 			}
 			if (i == rd->io_u_flight_nr)
-				log_err("fio: send wr %ld not found\n",
+				log_err("fio: send wr %" PRId64 " not found\n",
 					wc.wr_id);
 			else {
 				/* put the last one into middle of the list */
@@ -587,8 +587,10 @@ static int fio_rdmaio_send(struct thread_data *td, struct io_u **io_us,
 {
 	struct rdmaio_data *rd = td->io_ops->data;
 	struct ibv_send_wr *bad_wr;
+#if 0
 	enum ibv_wc_opcode comp_opcode;
 	comp_opcode = IBV_WC_RDMA_WRITE;
+#endif
 	int i, index;
 	struct rdma_io_u_data *r_io_u_d;
 
@@ -1018,8 +1020,9 @@ static int fio_rdmaio_init(struct thread_data *td)
 	/* soft limit */
 	if ((rl.rlim_cur != RLIM_INFINITY)
 	    && (rl.rlim_cur < td->orig_buffer_size)) {
-		log_err("fio: soft RLIMIT_MEMLOCK is: %ld\n", rl.rlim_cur);
-		log_err("fio: total block size is:    %ld\n",
+		log_err("fio: soft RLIMIT_MEMLOCK is: %" PRId64 "\n",
+			rl.rlim_cur);
+		log_err("fio: total block size is:    %zd\n",
 			td->orig_buffer_size);
 		/* try to set larger RLIMIT_MEMLOCK */
 		rl.rlim_cur = rl.rlim_max;
-- 
1.7.3.4

