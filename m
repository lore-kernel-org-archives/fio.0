Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F760C4332F
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 22:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiLAWJ3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiLAWJ1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 17:09:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8036D43848
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 14:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669932502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jD3g8Z+YPxWMuPOo5WOcaAHnNENe/k5e9x6xQhkosx0=;
        b=HMea519MyT3Ljz95qE65KVAcNwrqIVCpf+wJE2qa6W6QKFfxusqZBni2OSIdFhQVRrGdN7
        xq4e7Wxjo+Ujm6+j7PoSQNUsZlXPU5iF4h9Iwhu2Kd4UucP7988nSONKwNCfVNHyzPWjD2
        Cag7yLGBcr+aqS+BSJ5Y8hi4EjT8W7U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22--NT2Uv44NF6nFqMOnEv8qg-1; Thu, 01 Dec 2022 17:08:16 -0500
X-MC-Unique: -NT2Uv44NF6nFqMOnEv8qg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F581185A7A3;
        Thu,  1 Dec 2022 22:08:16 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B01CC477F55;
        Thu,  1 Dec 2022 22:08:14 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Vincent Fu <vincentfu@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH v2 05/10] engines/libblkio: Add option libblkio_vectored
Date:   Thu,  1 Dec 2022 22:07:58 +0000
Message-Id: <20221201220803.52057-6-afaria@redhat.com>
In-Reply-To: <20221201220803.52057-1-afaria@redhat.com>
References: <20221201220803.52057-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
index 2b3fe9c2..f77d76cc 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2887,6 +2887,10 @@ with the caveat that when used on the command line, they must come after the
 	and are listed at
 	https://libblkio.gitlab.io/libblkio/blkio.html#properties
 
+.. option:: libblkio_vectored : [libblkio]
+
+	Submit vectored read and write requests.
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/engines/libblkio.c b/engines/libblkio.c
index 6decfd39..219bb0dc 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -28,6 +28,7 @@ struct fio_blkio_data {
 	bool has_mem_region; /* whether mem_region is valid */
 	struct blkio_mem_region mem_region; /* only if allocated by libblkio */
 
+	struct iovec *iovecs; /* for vectored requests */
 	struct blkio_completion *completions;
 };
 
@@ -39,6 +40,7 @@ struct fio_blkio_options {
 	char *pre_start_props;
 
 	unsigned int hipri;
+	unsigned int vectored;
 };
 
 static struct fio_option options[] = {
@@ -78,6 +80,15 @@ static struct fio_option options[] = {
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
 	},
@@ -249,8 +260,9 @@ static int fio_blkio_init(struct thread_data *td)
 		return 1;
 	}
 
+	data->iovecs = calloc(td->o.iodepth, sizeof(data->iovecs[0]));
 	data->completions = calloc(td->o.iodepth, sizeof(data->completions[0]));
-	if (!data->completions) {
+	if (!data->iovecs || !data->completions) {
 		log_err("fio: calloc() failed\n");
 		goto err_free;
 	}
@@ -288,6 +300,7 @@ err_blkio_destroy:
 	blkio_destroy(&data->b);
 err_free:
 	free(data->completions);
+	free(data->iovecs);
 	free(data);
 	return 1;
 }
@@ -340,6 +353,7 @@ static void fio_blkio_cleanup(struct thread_data *td)
 	if (data) {
 		blkio_destroy(&data->b);
 		free(data->completions);
+		free(data->iovecs);
 		free(data);
 	}
 }
@@ -405,18 +419,40 @@ static int fio_blkio_open_file(struct thread_data *td, struct fio_file *f)
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
 			blkioq_discard(data->q, io_u->offset, io_u->xfer_buflen,
diff --git a/fio.1 b/fio.1
index 7f97e940..9b8995b5 100644
--- a/fio.1
+++ b/fio.1
@@ -2634,6 +2634,9 @@ properties depend on the libblkio version in use and are listed at
 .TP
 .BI (libblkio)hipri
 Use poll queues.
+.TP
+.BI (libblkio)libblkio_vectored
+Submit vectored read and write requests.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
-- 
2.38.1

