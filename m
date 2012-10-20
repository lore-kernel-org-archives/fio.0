Return-Path: <fio-owner@vger.kernel.org>
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:43645 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab2JTDSG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 19 Oct 2012 23:18:06 -0400
Received: by mail-qa0-f70.google.com with SMTP id t11so1718528qaa.1
        for <fio@vger.kernel.org>; Fri, 19 Oct 2012 20:18:05 -0700 (PDT)
From: Yufei Ren <yufei.ren@stonybrook.edu>
Subject: [PATCH 3/4] rdma ioengine improvement
Date: Fri, 19 Oct 2012 23:11:51 -0400
Message-Id: <1350702712-5168-4-git-send-email-yufei.ren@stonybrook.edu>
In-Reply-To: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu>
References: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Yufei Ren <renyufei83@gmail.com>

From: Yufei Ren <renyufei83@gmail.com>

---
 backend.c      |    2 +-
 engines/rdma.c |   28 ++++++++++++++++++++--------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/backend.c b/backend.c
index 4e3a3ed..85ec196 100644
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
index 79d72d2..9a51e4f 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -7,8 +7,8 @@
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
@@ -41,7 +41,7 @@
 #include <rdma/rdma_cma.h>
 #include <infiniband/arch.h>
 
-#define FIO_RDMA_MAX_IO_DEPTH    128
+#define FIO_RDMA_MAX_IO_DEPTH    512
 
 enum rdma_io_mode {
 	FIO_RDMA_UNKNOWN = 0,
@@ -110,6 +110,8 @@ struct rdmaio_data {
 	int io_u_completed_nr;
 };
 
+static unsigned int Junk;
+
 static int client_recv(struct thread_data *td, struct ibv_wc *wc)
 {
 	struct rdmaio_data *rd = td->io_ops->data;
@@ -602,7 +604,7 @@ static int fio_rdmaio_send(struct thread_data *td, struct io_u **io_us,
 		case FIO_RDMA_MEM_WRITE:
 			/* compose work request */
 			r_io_u_d = io_us[i]->engine_data;
-			index = rand() % rd->rmt_nr;
+			index = rand_r(&Junk) % rd->rmt_nr;
 			r_io_u_d->sq_wr.opcode = IBV_WR_RDMA_WRITE;
 			r_io_u_d->sq_wr.wr.rdma.rkey = rd->rmt_us[index].rkey;
 			r_io_u_d->sq_wr.wr.rdma.remote_addr = \
@@ -612,7 +614,7 @@ static int fio_rdmaio_send(struct thread_data *td, struct io_u **io_us,
 		case FIO_RDMA_MEM_READ:
 			/* compose work request */
 			r_io_u_d = io_us[i]->engine_data;
-			index = rand() % rd->rmt_nr;
+			index = rand_r(&Junk) % rd->rmt_nr;
 			r_io_u_d->sq_wr.opcode = IBV_WR_RDMA_READ;
 			r_io_u_d->sq_wr.wr.rdma.rkey = rd->rmt_us[index].rkey;
 			r_io_u_d->sq_wr.wr.rdma.remote_addr = \
@@ -790,6 +792,13 @@ static int fio_rdmaio_connect(struct thread_data *td, struct fio_file *f)
 	/* wait for remote MR info from server side */
 	rdma_poll_wait(td, IBV_WC_RECV);
 
+	/* In SEND/RECV test, iodepth in RECV side is deeper
+	 * in SEND side. RECV needs more time to construct the
+	 * buffer blocks, so the server side may need to stop
+	 * some time before transfer data.
+	 */
+	usleep(500000);
+
 	return 0;
 }
 
@@ -872,8 +881,8 @@ static int fio_rdmaio_close_file(struct thread_data *td, struct fio_file *f)
         return 1;
     }*/
 
-	ibv_destroy_qp(rd->qp);
 	ibv_destroy_cq(rd->cq);
+	ibv_destroy_qp(rd->qp);
 
 	if (rd->is_client == 1)
 		rdma_destroy_id(rd->cm_id);
@@ -1150,6 +1159,9 @@ static int fio_rdmaio_init(struct thread_data *td)
 		i++;
 	}
 
+	Junk = getpid();
+	rand_r(&Junk);
+
 	rd->send_buf.nr = htonl(i);
 
 	return ret;
@@ -1229,8 +1241,8 @@ static int fio_rdmaio_init(struct thread_data fio_unused * td)
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

