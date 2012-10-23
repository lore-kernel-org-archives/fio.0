Return-Path: <fio-owner@vger.kernel.org>
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:46299 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444Ab2JWB3v (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Oct 2012 21:29:51 -0400
Received: by mail-gh0-f198.google.com with SMTP id g21so8383076ghb.1
        for <fio@vger.kernel.org>; Mon, 22 Oct 2012 18:29:49 -0700 (PDT)
From: Yufei Ren <yufei.ren@stonybrook.edu>
Subject: [PATCH] rdma ioengine improvement
Date: Mon, 22 Oct 2012 21:29:38 -0400
Message-Id: <1350955778-27682-2-git-send-email-yufei.ren@stonybrook.edu>
In-Reply-To: <1350955778-27682-1-git-send-email-yufei.ren@stonybrook.edu>
References: <1350955778-27682-1-git-send-email-yufei.ren@stonybrook.edu>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Yufei Ren <renyufei83@gmail.com>

From: Yufei Ren <renyufei83@gmail.com>

1) Use fio shipped reentrant and thread-safe rand to replace buggy rand().
2) Add a pause time period before client start committing IOs.
	In SEND/RECV test, it's a good practice to setup the iodepth of
	of the RECV side deeper than that of the SEND side to
	avoid RNR (receiver not ready) error. The
	SEND side may send so many unsolicited message before
	RECV side commits sufficient recv buffers into recv queue.
	This may lead to RNR error. Here, SEND side pauses for a while
	during which RECV side commits sufficient recv buffers.
3) Fix server thread hanging bug.
	For RDMA WRITE/READ test, No IO bytes are accumulated in server side
	during test. Server thread indicates its task completion by changing
	its state into `done' as an alternitive. Add `td->done' checking in
	do_io().
4) Some comments revision.
	export EXTFLAGS and EXTLIBS with '+=".
	explanation on exchanging steps of RDMA ioengine control messages.

All these changes are tested in 40Gbps RoCE and 56Gbps InfiniBand testbeds.
---
 backend.c      |    2 +-
 engines/rdma.c |   46 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/backend.c b/backend.c
index 3b42c4d..157fd52 100644
--- a/backend.c
+++ b/backend.c
@@ -591,7 +591,7 @@ static void do_io(struct thread_data *td)
 		int ret2, full;
 		enum fio_ddir ddir;
 
-		if (td->terminate)
+		if (td->terminate || td->done)
 			break;
 
 		update_tv_cache(td);
diff --git a/engines/rdma.c b/engines/rdma.c
index 79d72d2..2633432 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -7,14 +7,25 @@
  *
  * This I/O engine is disabled by default. To enable it, execute:
  *
- * $ export EXTFLAGS="-DFIO_HAVE_RDMA"
- * $ export EXTLIBS="-libverbs -lrdmacm"
+ * $ export EXTFLAGS+=" -DFIO_HAVE_RDMA "
+ * $ export EXTLIBS+=" -libverbs -lrdmacm "
  *
  * before running make. You will need the Linux RDMA software as well, either
  * from your Linux distributor or directly from openfabrics.org:
  *
  * http://www.openfabrics.org/downloads/OFED/
  *
+ * Exchanging steps of RDMA ioengine control messages:
+ *	1. client side sends test mode (RDMA_WRITE/RDMA_READ/SEND)
+ *	   to server side.
+ * 	2. server side parses test mode, and sends back confirmation
+ *	   to client side. In RDMA WRITE/READ test, this confirmation
+ * 	   includes memory information, such as rkey, address.
+ *	3. client side initiates test loop.
+ * 	4. In RDMA WRITE/READ test, client side sends a completion
+ *	   notification to server side. Server side updates its
+ * 	   td->done as true.
+ *
  */
 #include <stdio.h>
 #include <stdlib.h>
@@ -41,7 +52,7 @@
 #include <rdma/rdma_cma.h>
 #include <infiniband/arch.h>
 
-#define FIO_RDMA_MAX_IO_DEPTH    128
+#define FIO_RDMA_MAX_IO_DEPTH    512
 
 enum rdma_io_mode {
 	FIO_RDMA_UNKNOWN = 0,
@@ -591,7 +602,8 @@ static int fio_rdmaio_send(struct thread_data *td, struct io_u **io_us,
 	enum ibv_wc_opcode comp_opcode;
 	comp_opcode = IBV_WC_RDMA_WRITE;
 #endif
-	int i, index;
+	int i;
+	long index;
 	struct rdma_io_u_data *r_io_u_d;
 
 	r_io_u_d = NULL;
@@ -602,7 +614,10 @@ static int fio_rdmaio_send(struct thread_data *td, struct io_u **io_us,
 		case FIO_RDMA_MEM_WRITE:
 			/* compose work request */
 			r_io_u_d = io_us[i]->engine_data;
-			index = rand() % rd->rmt_nr;
+			if (td->o.use_os_rand)
+				index = os_random_long(&td->random_state) % rd->rmt_nr;
+			else
+				index = __rand(&td->__random_state) % rd->rmt_nr;
 			r_io_u_d->sq_wr.opcode = IBV_WR_RDMA_WRITE;
 			r_io_u_d->sq_wr.wr.rdma.rkey = rd->rmt_us[index].rkey;
 			r_io_u_d->sq_wr.wr.rdma.remote_addr = \
@@ -612,7 +627,10 @@ static int fio_rdmaio_send(struct thread_data *td, struct io_u **io_us,
 		case FIO_RDMA_MEM_READ:
 			/* compose work request */
 			r_io_u_d = io_us[i]->engine_data;
-			index = rand() % rd->rmt_nr;
+			if (td->o.use_os_rand)
+				index = os_random_long(&td->random_state) % rd->rmt_nr;
+			else
+				index = __rand(&td->__random_state) % rd->rmt_nr;
 			r_io_u_d->sq_wr.opcode = IBV_WR_RDMA_READ;
 			r_io_u_d->sq_wr.wr.rdma.rkey = rd->rmt_us[index].rkey;
 			r_io_u_d->sq_wr.wr.rdma.remote_addr = \
@@ -790,6 +808,16 @@ static int fio_rdmaio_connect(struct thread_data *td, struct fio_file *f)
 	/* wait for remote MR info from server side */
 	rdma_poll_wait(td, IBV_WC_RECV);
 
+	/* In SEND/RECV test, it's a good practice to setup the iodepth of
+	 * of the RECV side deeper than that of the SEND side to
+	 * avoid RNR (receiver not ready) error. The
+	 * SEND side may send so many unsolicited message before 
+	 * RECV side commits sufficient recv buffers into recv queue.
+	 * This may lead to RNR error. Here, SEND side pauses for a while
+	 * during which RECV side commits sufficient recv buffers.
+	 */
+	usleep(500000);
+
 	return 0;
 }
 
@@ -872,8 +900,8 @@ static int fio_rdmaio_close_file(struct thread_data *td, struct fio_file *f)
         return 1;
     }*/
 
-	ibv_destroy_qp(rd->qp);
 	ibv_destroy_cq(rd->cq);
+	ibv_destroy_qp(rd->qp);
 
 	if (rd->is_client == 1)
 		rdma_destroy_id(rd->cm_id);
@@ -1229,8 +1257,8 @@ static int fio_rdmaio_init(struct thread_data fio_unused * td)
 	log_err("     make sure OFED is installed,\n");
 	log_err("     $ ofed_info\n");
 	log_err("     then try to make fio as follows:\n");
-	log_err("     $ export EXTFLAGS=\"-DFIO_HAVE_RDMA\"\n");
-	log_err("     $ export EXTLIBS=\"-libverbs -lrdmacm\"\n");
+	log_err("     $ export EXTFLAGS+=\" -DFIO_HAVE_RDMA \"\n");
+	log_err("     $ export EXTLIBS+=\" -libverbs -lrdmacm \"\n");
 	log_err("     $ make clean && make\n");
 	return 1;
 }
-- 
1.7.2.3

