Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC7AC433EF
	for <fio@archiver.kernel.org>; Sat, 19 Feb 2022 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242051AbiBSNA1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:00:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbiBSNA0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 19 Feb 2022 08:00:26 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83421FFF7F
        for <fio@vger.kernel.org>; Sat, 19 Feb 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=ouU45qrgW7uAEPTE6tt3xxLzZsTs6dn8Z0iNf+ccG+g=; b=h/X8wlfIMCvlmTwB+wWW5pFvIa
        Sr58EDYdXJhvpXZaY3G+1fAzB8usRTy4RuH3GzdVfr2d6WntA3R0Vh7jXoxjpInbdgFaBvmVvyyEL
        e3B4SSyqX8lqFAQRfj0FsW8KubzMxKyWomGRMfkYWWYx+REVCrQr3WjqtIwwHefLwz2evHtJe/OEz
        8Sa3+GFcRZoY7CHyjdVsQ9EHjYaOX8xKVmrECaQ+2atsr0w7/eUGUP5c5Dg3WDMyuCJEysjmBMp4f
        Nh/RVRa22p/+zikjDqy4lCPi32imi3lPfFNoQtJLWAbTFYkLvMcQinRDf8UIEDgjJSexb3bIGdNDH
        5pMmXZEQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nLPLI-00B5q8-Po
        for fio@vger.kernel.org; Sat, 19 Feb 2022 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id C6F521BC0141; Sat, 19 Feb 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220219130001.C6F521BC0141@kernel.dk>
Date:   Sat, 19 Feb 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c99c81adb3510a8dc34d47fd40b19ef657e32192:

  Correct F_FULLSYNC -> F_FULLFSYNC (2022-02-17 12:53:59 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 933651ec130ce4d27a5c249d649d20afeb2bdf38:

  Merge branch 'rpma-update-RPMA-engines-with-new-librpma-completions-API' of https://github.com/ldorau/fio (2022-02-18 09:02:03 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'rpma-update-RPMA-engines-with-new-librpma-completions-API' of https://github.com/ldorau/fio

Lukasz Dorau (1):
      rpma: RPMA engines require librpma>=v0.11.0 with rpma_cq_get_wc()

Oksana Salyk (1):
      rpma: update RPMA engines with new librpma completions API

 configure               |  4 ++--
 engines/librpma_apm.c   |  8 +++-----
 engines/librpma_fio.c   | 46 +++++++++++++++++++++++++++++-----------------
 engines/librpma_fio.h   | 16 +++++++++-------
 engines/librpma_gpspm.c | 39 ++++++++++++++++++---------------------
 5 files changed, 61 insertions(+), 52 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 6160d84d..be4605f9 100755
--- a/configure
+++ b/configure
@@ -974,7 +974,7 @@ print_config "rdmacm" "$rdmacm"
 
 ##########################################
 # librpma probe
-# The librpma engine requires librpma>=v0.10.0 with rpma_mr_advise().
+# The librpma engines require librpma>=v0.11.0 with rpma_cq_get_wc().
 if test "$librpma" != "yes" ; then
   librpma="no"
 fi
@@ -982,7 +982,7 @@ cat > $TMPC << EOF
 #include <librpma.h>
 int main(void)
 {
-  void *ptr = rpma_mr_advise;
+  void *ptr = rpma_cq_get_wc;
   (void) ptr; /* unused */
   return 0;
 }
diff --git a/engines/librpma_apm.c b/engines/librpma_apm.c
index ffa3769d..d1166ad8 100644
--- a/engines/librpma_apm.c
+++ b/engines/librpma_apm.c
@@ -22,8 +22,7 @@ static inline int client_io_flush(struct thread_data *td,
 		struct io_u *first_io_u, struct io_u *last_io_u,
 		unsigned long long int len);
 
-static int client_get_io_u_index(struct rpma_completion *cmpl,
-		unsigned int *io_u_index);
+static int client_get_io_u_index(struct ibv_wc *wc, unsigned int *io_u_index);
 
 static int client_init(struct thread_data *td)
 {
@@ -188,10 +187,9 @@ static inline int client_io_flush(struct thread_data *td,
 	return 0;
 }
 
-static int client_get_io_u_index(struct rpma_completion *cmpl,
-		unsigned int *io_u_index)
+static int client_get_io_u_index(struct ibv_wc *wc, unsigned int *io_u_index)
 {
-	memcpy(io_u_index, &cmpl->op_context, sizeof(*io_u_index));
+	memcpy(io_u_index, &wc->wr_id, sizeof(*io_u_index));
 
 	return 1;
 }
diff --git a/engines/librpma_fio.c b/engines/librpma_fio.c
index 9d6ebf38..dfd82180 100644
--- a/engines/librpma_fio.c
+++ b/engines/librpma_fio.c
@@ -302,6 +302,12 @@ int librpma_fio_client_init(struct thread_data *td,
 	if (ccd->conn == NULL)
 		goto err_peer_delete;
 
+	/* get the connection's main CQ */
+	if ((ret = rpma_conn_get_cq(ccd->conn, &ccd->cq))) {
+		librpma_td_verror(td, ret, "rpma_conn_get_cq");
+		goto err_conn_delete;
+	}
+
 	/* get the connection's private data sent from the server */
 	if ((ret = rpma_conn_get_private_data(ccd->conn, &pdata))) {
 		librpma_td_verror(td, ret, "rpma_conn_get_private_data");
@@ -455,7 +461,7 @@ static enum fio_q_status client_queue_sync(struct thread_data *td,
 		struct io_u *io_u)
 {
 	struct librpma_fio_client_data *ccd = td->io_ops_data;
-	struct rpma_completion cmpl;
+	struct ibv_wc wc;
 	unsigned io_u_index;
 	int ret;
 
@@ -478,31 +484,31 @@ static enum fio_q_status client_queue_sync(struct thread_data *td,
 
 	do {
 		/* get a completion */
-		ret = rpma_conn_completion_get(ccd->conn, &cmpl);
+		ret = rpma_cq_get_wc(ccd->cq, 1, &wc, NULL);
 		if (ret == RPMA_E_NO_COMPLETION) {
 			/* lack of completion is not an error */
 			continue;
 		} else if (ret != 0) {
 			/* an error occurred */
-			librpma_td_verror(td, ret, "rpma_conn_completion_get");
+			librpma_td_verror(td, ret, "rpma_cq_get_wc");
 			goto err;
 		}
 
 		/* if io_us has completed with an error */
-		if (cmpl.op_status != IBV_WC_SUCCESS)
+		if (wc.status != IBV_WC_SUCCESS)
 			goto err;
 
-		if (cmpl.op == RPMA_OP_SEND)
+		if (wc.opcode == IBV_WC_SEND)
 			++ccd->op_send_completed;
 		else {
-			if (cmpl.op == RPMA_OP_RECV)
+			if (wc.opcode == IBV_WC_RECV)
 				++ccd->op_recv_completed;
 
 			break;
 		}
 	} while (1);
 
-	if (ccd->get_io_u_index(&cmpl, &io_u_index) != 1)
+	if (ccd->get_io_u_index(&wc, &io_u_index) != 1)
 		goto err;
 
 	if (io_u->index != io_u_index) {
@@ -654,8 +660,8 @@ int librpma_fio_client_commit(struct thread_data *td)
 static int client_getevent_process(struct thread_data *td)
 {
 	struct librpma_fio_client_data *ccd = td->io_ops_data;
-	struct rpma_completion cmpl;
-	/* io_u->index of completed io_u (cmpl.op_context) */
+	struct ibv_wc wc;
+	/* io_u->index of completed io_u (wc.wr_id) */
 	unsigned int io_u_index;
 	/* # of completed io_us */
 	int cmpl_num = 0;
@@ -665,7 +671,7 @@ static int client_getevent_process(struct thread_data *td)
 	int ret;
 
 	/* get a completion */
-	if ((ret = rpma_conn_completion_get(ccd->conn, &cmpl))) {
+	if ((ret = rpma_cq_get_wc(ccd->cq, 1, &wc, NULL))) {
 		/* lack of completion is not an error */
 		if (ret == RPMA_E_NO_COMPLETION) {
 			/* lack of completion is not an error */
@@ -673,22 +679,22 @@ static int client_getevent_process(struct thread_data *td)
 		}
 
 		/* an error occurred */
-		librpma_td_verror(td, ret, "rpma_conn_completion_get");
+		librpma_td_verror(td, ret, "rpma_cq_get_wc");
 		return -1;
 	}
 
 	/* if io_us has completed with an error */
-	if (cmpl.op_status != IBV_WC_SUCCESS) {
-		td->error = cmpl.op_status;
+	if (wc.status != IBV_WC_SUCCESS) {
+		td->error = wc.status;
 		return -1;
 	}
 
-	if (cmpl.op == RPMA_OP_SEND)
+	if (wc.opcode == IBV_WC_SEND)
 		++ccd->op_send_completed;
-	else if (cmpl.op == RPMA_OP_RECV)
+	else if (wc.opcode == IBV_WC_RECV)
 		++ccd->op_recv_completed;
 
-	if ((ret = ccd->get_io_u_index(&cmpl, &io_u_index)) != 1)
+	if ((ret = ccd->get_io_u_index(&wc, &io_u_index)) != 1)
 		return ret;
 
 	/* look for an io_u being completed */
@@ -750,7 +756,7 @@ int librpma_fio_client_getevents(struct thread_data *td, unsigned int min,
 
 			/*
 			 * To reduce CPU consumption one can use
-			 * the rpma_conn_completion_wait() function.
+			 * the rpma_cq_wait() function.
 			 * Note this greatly increase the latency
 			 * and make the results less stable.
 			 * The bandwidth stays more or less the same.
@@ -1029,6 +1035,12 @@ int librpma_fio_server_open_file(struct thread_data *td, struct fio_file *f,
 	csd->ws_ptr = ws_ptr;
 	csd->conn = conn;
 
+	/* get the connection's main CQ */
+	if ((ret = rpma_conn_get_cq(csd->conn, &csd->cq))) {
+		librpma_td_verror(td, ret, "rpma_conn_get_cq");
+		goto err_conn_delete;
+	}
+
 	return 0;
 
 err_conn_delete:
diff --git a/engines/librpma_fio.h b/engines/librpma_fio.h
index 2c507e9c..91290235 100644
--- a/engines/librpma_fio.h
+++ b/engines/librpma_fio.h
@@ -94,12 +94,13 @@ typedef int (*librpma_fio_flush_t)(struct thread_data *td,
  * - ( 0) - skip
  * - (-1) - on error
  */
-typedef int (*librpma_fio_get_io_u_index_t)(struct rpma_completion *cmpl,
+typedef int (*librpma_fio_get_io_u_index_t)(struct ibv_wc *wc,
 		unsigned int *io_u_index);
 
 struct librpma_fio_client_data {
 	struct rpma_peer *peer;
 	struct rpma_conn *conn;
+	struct rpma_cq *cq;
 
 	/* aligned td->orig_buffer */
 	char *orig_buffer_aligned;
@@ -199,29 +200,29 @@ static inline int librpma_fio_client_io_complete_all_sends(
 		struct thread_data *td)
 {
 	struct librpma_fio_client_data *ccd = td->io_ops_data;
-	struct rpma_completion cmpl;
+	struct ibv_wc wc;
 	int ret;
 
 	while (ccd->op_send_posted != ccd->op_send_completed) {
 		/* get a completion */
-		ret = rpma_conn_completion_get(ccd->conn, &cmpl);
+		ret = rpma_cq_get_wc(ccd->cq, 1, &wc, NULL);
 		if (ret == RPMA_E_NO_COMPLETION) {
 			/* lack of completion is not an error */
 			continue;
 		} else if (ret != 0) {
 			/* an error occurred */
-			librpma_td_verror(td, ret, "rpma_conn_completion_get");
+			librpma_td_verror(td, ret, "rpma_cq_get_wc");
 			break;
 		}
 
-		if (cmpl.op_status != IBV_WC_SUCCESS)
+		if (wc.status != IBV_WC_SUCCESS)
 			return -1;
 
-		if (cmpl.op == RPMA_OP_SEND)
+		if (wc.opcode == IBV_WC_SEND)
 			++ccd->op_send_completed;
 		else {
 			log_err(
-				"A completion other than RPMA_OP_SEND got during cleaning up the CQ from SENDs\n");
+				"A completion other than IBV_WC_SEND got during cleaning up the CQ from SENDs\n");
 			return -1;
 		}
 	}
@@ -251,6 +252,7 @@ struct librpma_fio_server_data {
 
 	/* resources of an incoming connection */
 	struct rpma_conn *conn;
+	struct rpma_cq *cq;
 
 	char *ws_ptr;
 	struct rpma_mr_local *ws_mr;
diff --git a/engines/librpma_gpspm.c b/engines/librpma_gpspm.c
index 74147709..14626e7f 100644
--- a/engines/librpma_gpspm.c
+++ b/engines/librpma_gpspm.c
@@ -60,8 +60,7 @@ static inline int client_io_flush(struct thread_data *td,
 		struct io_u *first_io_u, struct io_u *last_io_u,
 		unsigned long long int len);
 
-static int client_get_io_u_index(struct rpma_completion *cmpl,
-		unsigned int *io_u_index);
+static int client_get_io_u_index(struct ibv_wc *wc, unsigned int *io_u_index);
 
 static int client_init(struct thread_data *td)
 {
@@ -317,17 +316,16 @@ static inline int client_io_flush(struct thread_data *td,
 	return 0;
 }
 
-static int client_get_io_u_index(struct rpma_completion *cmpl,
-		unsigned int *io_u_index)
+static int client_get_io_u_index(struct ibv_wc *wc, unsigned int *io_u_index)
 {
 	GPSPMFlushResponse *flush_resp;
 
-	if (cmpl->op != RPMA_OP_RECV)
+	if (wc->opcode != IBV_WC_RECV)
 		return 0;
 
 	/* unpack a response from the received buffer */
 	flush_resp = gpspm_flush_response__unpack(NULL,
-			cmpl->byte_len, cmpl->op_context);
+			wc->byte_len, (void *)wc->wr_id);
 	if (flush_resp == NULL) {
 		log_err("Cannot unpack the flush response buffer\n");
 		return -1;
@@ -373,7 +371,7 @@ struct server_data {
 	uint32_t msg_sqe_available; /* # of free SQ slots */
 
 	/* in-memory queues */
-	struct rpma_completion *msgs_queued;
+	struct ibv_wc *msgs_queued;
 	uint32_t msg_queued_nr;
 };
 
@@ -562,8 +560,7 @@ err_cfg_delete:
 	return ret;
 }
 
-static int server_qe_process(struct thread_data *td,
-		struct rpma_completion *cmpl)
+static int server_qe_process(struct thread_data *td, struct ibv_wc *wc)
 {
 	struct librpma_fio_server_data *csd = td->io_ops_data;
 	struct server_data *sd = csd->server_data;
@@ -580,7 +577,7 @@ static int server_qe_process(struct thread_data *td,
 	int ret;
 
 	/* calculate SEND/RECV pair parameters */
-	msg_index = (int)(uintptr_t)cmpl->op_context;
+	msg_index = (int)(uintptr_t)wc->wr_id;
 	io_u_buff_offset = IO_U_BUFF_OFF_SERVER(msg_index);
 	send_buff_offset = io_u_buff_offset + SEND_OFFSET;
 	recv_buff_offset = io_u_buff_offset + RECV_OFFSET;
@@ -588,7 +585,7 @@ static int server_qe_process(struct thread_data *td,
 	recv_buff_ptr = sd->orig_buffer_aligned + recv_buff_offset;
 
 	/* unpack a flush request from the received buffer */
-	flush_req = gpspm_flush_request__unpack(NULL, cmpl->byte_len,
+	flush_req = gpspm_flush_request__unpack(NULL, wc->byte_len,
 			recv_buff_ptr);
 	if (flush_req == NULL) {
 		log_err("cannot unpack the flush request buffer\n");
@@ -682,28 +679,28 @@ static int server_cmpl_process(struct thread_data *td)
 {
 	struct librpma_fio_server_data *csd = td->io_ops_data;
 	struct server_data *sd = csd->server_data;
-	struct rpma_completion *cmpl = &sd->msgs_queued[sd->msg_queued_nr];
+	struct ibv_wc *wc = &sd->msgs_queued[sd->msg_queued_nr];
 	struct librpma_fio_options_values *o = td->eo;
 	int ret;
 
-	ret = rpma_conn_completion_get(csd->conn, cmpl);
+	ret = rpma_cq_get_wc(csd->cq, 1, wc, NULL);
 	if (ret == RPMA_E_NO_COMPLETION) {
 		if (o->busy_wait_polling == 0) {
-			ret = rpma_conn_completion_wait(csd->conn);
+			ret = rpma_cq_wait(csd->cq);
 			if (ret == RPMA_E_NO_COMPLETION) {
 				/* lack of completion is not an error */
 				return 0;
 			} else if (ret != 0) {
-				librpma_td_verror(td, ret, "rpma_conn_completion_wait");
+				librpma_td_verror(td, ret, "rpma_cq_wait");
 				goto err_terminate;
 			}
 
-			ret = rpma_conn_completion_get(csd->conn, cmpl);
+			ret = rpma_cq_get_wc(csd->cq, 1, wc, NULL);
 			if (ret == RPMA_E_NO_COMPLETION) {
 				/* lack of completion is not an error */
 				return 0;
 			} else if (ret != 0) {
-				librpma_td_verror(td, ret, "rpma_conn_completion_get");
+				librpma_td_verror(td, ret, "rpma_cq_get_wc");
 				goto err_terminate;
 			}
 		} else {
@@ -711,17 +708,17 @@ static int server_cmpl_process(struct thread_data *td)
 			return 0;
 		}
 	} else if (ret != 0) {
-		librpma_td_verror(td, ret, "rpma_conn_completion_get");
+		librpma_td_verror(td, ret, "rpma_cq_get_wc");
 		goto err_terminate;
 	}
 
 	/* validate the completion */
-	if (cmpl->op_status != IBV_WC_SUCCESS)
+	if (wc->status != IBV_WC_SUCCESS)
 		goto err_terminate;
 
-	if (cmpl->op == RPMA_OP_RECV)
+	if (wc->opcode == IBV_WC_RECV)
 		++sd->msg_queued_nr;
-	else if (cmpl->op == RPMA_OP_SEND)
+	else if (wc->opcode == IBV_WC_SEND)
 		++sd->msg_sqe_available;
 
 	return 0;
