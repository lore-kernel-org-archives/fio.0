Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381DAC4332F
	for <fio@archiver.kernel.org>; Mon, 21 Nov 2022 18:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiKUSaN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Nov 2022 13:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiKUSaM (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Nov 2022 13:30:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D31D02F7
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 10:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669055354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gnd4ECqJQFSaDzsejNUysIrD48IxTJTLa/FrZHO1cVY=;
        b=JiRo4Ajfg6JszQ2HttmNeQf+PjoXp5mqPPcBEodr3cbDiBRIXVNUCJB33VW8B33mScyWOP
        850pDrER6eFk4t9i1esylL9EZvcbj3qwMPhTRMurKlpYv34eL7e6J0cD/97psNHwuZf2Yq
        yg4B42/7xmLqotLb51TpnnVbZc479dU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-EZd2IMf4MJaQgYC6bY3SZQ-1; Mon, 21 Nov 2022 13:29:12 -0500
X-MC-Unique: EZd2IMf4MJaQgYC6bY3SZQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73FDB101A56D
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 18:29:12 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51395492B06;
        Mon, 21 Nov 2022 18:29:11 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH 05/10] engines/libblkio: Add option libblkio_vectored
Date:   Mon, 21 Nov 2022 18:28:57 +0000
Message-Id: <20221121182902.373491-6-afaria@redhat.com>
In-Reply-To: <20221121182902.373491-1-afaria@redhat.com>
References: <20221121182902.373491-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When enabled, read and write requests are submitted as vectored requests
using blkioq_{readv,writev}(), instead of using blkioq_{read,write}().

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 HOWTO.rst          |  4 ++++
 engines/libblkio.c | 46 +++++++++++++++++++++++++++++++++++++++++-----
 fio.1              |  3 +++
 3 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index cdea3258..b9c7c8df 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2875,6 +2875,10 @@ with the caveat that when used on the command line, they must come after the
 	set after the engine sets any other properties, so those can be
 	overriden.
 
+.. option:: libblkio_vectored=bool : [libblkio]
+
+	Submit vectored read and write requests. Default is 0.
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/engines/libblkio.c b/engines/libblkio.c
index d2ade3f1..dcf701ad 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -28,6 +28,7 @@ struct fio_blkio_options {
 	char *pre_start_props;
 
 	unsigned int hipri;
+	unsigned int vectored;
 };
 
 static struct fio_option options[] = {
@@ -68,6 +69,15 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBBLKIO,
 	},
+	{
+		.name	= "libblkio_vectored",
+		.lname	= "Use blkioq_{readv,writev}()",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct fio_blkio_options, vectored),
+		.help	= "Use blkioq_{readv,writev}() instead of blkioq_{read,write}()",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
 
 	{
 		.name = NULL,
@@ -251,6 +261,7 @@ struct fio_blkio_data {
 	bool has_mem_region; /* whether mem_region is valid */
 	struct blkio_mem_region mem_region; /* only if allocated by libblkio */
 
+	struct iovec *iovecs; /* for vectored requests */
 	struct blkio_completion *completions;
 };
 
@@ -267,8 +278,9 @@ static int fio_blkio_init(struct thread_data *td)
 		goto err_free;
 	}
 
+	data->iovecs = calloc(td->o.iodepth, sizeof(data->iovecs[0]));
 	data->completions = calloc(td->o.iodepth, sizeof(data->completions[0]));
-	if (!data->completions) {
+	if (!data->iovecs || !data->completions) {
 		log_err("fio: calloc() failed\n");
 		goto err_free;
 	}
@@ -310,6 +322,7 @@ err_blkio_destroy:
 	blkio_destroy(&data->b);
 err_free:
 	free(data->completions);
+	free(data->iovecs);
 	free(data);
 	return 1;
 }
@@ -362,6 +375,7 @@ static void fio_blkio_cleanup(struct thread_data *td)
 	if (data) {
 		blkio_destroy(&data->b);
 		free(data->completions);
+		free(data->iovecs);
 		free(data);
 	}
 }
@@ -432,19 +446,41 @@ static int fio_blkio_open_file(struct thread_data *td, struct fio_file *f)
 static enum fio_q_status fio_blkio_queue(struct thread_data *td,
 					 struct io_u *io_u)
 {
+	const struct fio_blkio_options *options = td->eo;
 	struct fio_blkio_data *data = td->io_ops_data;
 
 	fio_ro_check(td, io_u);
 
 	switch (io_u->ddir) {
 		case DDIR_READ:
-			blkioq_read(data->q, io_u->offset, io_u->xfer_buf,
-				    (size_t)io_u->xfer_buflen, io_u, 0);
+			if (options->vectored) {
+				struct iovec *iov = &data->iovecs[io_u->index];
+				iov->iov_base = io_u->xfer_buf;
+				iov->iov_len = (size_t)io_u->xfer_buflen;
+
+				blkioq_readv(data->q, io_u->offset, iov, 1,
+					     io_u, 0);
+			} else {
+				blkioq_read(data->q, io_u->offset,
+					    io_u->xfer_buf,
+					    (size_t)io_u->xfer_buflen, io_u, 0);
+			}
 			break;
 
 		case DDIR_WRITE:
-			blkioq_write(data->q, io_u->offset, io_u->xfer_buf,
-				     (size_t)io_u->xfer_buflen, io_u, 0);
+			if (options->vectored) {
+				struct iovec *iov = &data->iovecs[io_u->index];
+				iov->iov_base = io_u->xfer_buf;
+				iov->iov_len = (size_t)io_u->xfer_buflen;
+
+				blkioq_writev(data->q, io_u->offset, iov, 1,
+					      io_u, 0);
+			} else {
+				blkioq_write(data->q, io_u->offset,
+					     io_u->xfer_buf,
+					     (size_t)io_u->xfer_buflen, io_u,
+					     0);
+			}
 			break;
 
 		case DDIR_TRIM:
diff --git a/fio.1 b/fio.1
index 7c1b315a..a403b415 100644
--- a/fio.1
+++ b/fio.1
@@ -2623,6 +2623,9 @@ the engine sets any other properties, so those can be overriden.
 .TP
 .BI (libblkio)hipri \fR=\fPbool
 Use poll queues.
+.TP
+.BI (libblkio)libblkio_vectored \fR=\fPbool
+Submit vectored read and write requests. Default is 0.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
-- 
2.38.1

