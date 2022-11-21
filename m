Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 880E3C433FE
	for <fio@archiver.kernel.org>; Mon, 21 Nov 2022 18:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiKUSaR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Nov 2022 13:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiKUSaQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Nov 2022 13:30:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BF2D08B9
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 10:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669055353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QQgEjl5ubmH/fuffnrB+/EspbchYnTS03bVKbeg28gY=;
        b=AbzVRryaOEsP8vYL7tYnmuaxJD+8RsSDTdlnxvimH+GuYNqzGHHANajUMkFeDKiMCBWzR0
        M7A2T8jOx9SyYxpztgX+w0SrzUgOKS41tsevKDNXJ+tQ3XA62i3zOcSBMurCGCvz1lq7NH
        0L93onRNnY2U1xyqjKsrSRWlbwsuF2Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-nQmGPtI4NDuxfx6-QPViAg-1; Mon, 21 Nov 2022 13:29:11 -0500
X-MC-Unique: nQmGPtI4NDuxfx6-QPViAg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 062FE811E7A
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 18:29:11 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8F21492B06;
        Mon, 21 Nov 2022 18:29:09 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH 04/10] engines/libblkio: Add support for poll queues
Date:   Mon, 21 Nov 2022 18:28:56 +0000
Message-Id: <20221121182902.373491-5-afaria@redhat.com>
In-Reply-To: <20221121182902.373491-1-afaria@redhat.com>
References: <20221121182902.373491-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Configure a poll queue instead of a "regular" queue when option hipri is
set.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 HOWTO.rst          |  4 ++++
 engines/libblkio.c | 26 ++++++++++++++++++++++++--
 fio.1              |  3 +++
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index fb27d3d3..cdea3258 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2330,6 +2330,10 @@ with the caveat that when used on the command line, they must come after the
         by the application. The benefits are more efficient IO for high IOPS
         scenarios, and lower latencies for low queue depth IO.
 
+   [libblkio]
+
+	Use poll queues.
+
    [pvsync2]
 
 	Set RWF_HIPRI on I/O, indicating to the kernel that it's of higher priority
diff --git a/engines/libblkio.c b/engines/libblkio.c
index 54fd9ff6..d2ade3f1 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -26,6 +26,8 @@ struct fio_blkio_options {
 	char *driver;
 	char *pre_connect_props;
 	char *pre_start_props;
+
+	unsigned int hipri;
 };
 
 static struct fio_option options[] = {
@@ -57,6 +59,16 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_LIBBLKIO,
 	},
 
+	{
+		.name	= "hipri",
+		.lname	= "Use poll queues",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct fio_blkio_options, hipri),
+		.help	= "Use poll queues",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
+
 	{
 		.name = NULL,
 	},
@@ -244,6 +256,7 @@ struct fio_blkio_data {
 
 static int fio_blkio_init(struct thread_data *td)
 {
+	const struct fio_blkio_options *options = td->eo;
 	struct fio_blkio_data *data;
 
 	/* allocate per-thread data struct */
@@ -265,7 +278,13 @@ static int fio_blkio_init(struct thread_data *td)
 	if (fio_blkio_create_and_connect(td, &data->b) != 0)
 		goto err_free;
 
-	if (blkio_set_int(data->b, "num-queues", 1) != 0) {
+	if (blkio_set_int(data->b, "num-queues", options->hipri ? 0 : 1) != 0) {
+		fio_blkio_log_err(blkio_set_int);
+		goto err_blkio_destroy;
+	}
+
+	if (blkio_set_int(data->b, "num-poll-queues",
+			  options->hipri ? 1 : 0) != 0) {
 		fio_blkio_log_err(blkio_set_int);
 		goto err_blkio_destroy;
 	}
@@ -277,7 +296,10 @@ static int fio_blkio_init(struct thread_data *td)
 
 	/* get queue */
 
-	data->q = blkio_get_queue(data->b, 0);
+	if (options->hipri)
+		data->q = blkio_get_poll_queue(data->b, 0);
+	else
+		data->q = blkio_get_queue(data->b, 0);
 
 	/* Set data only here so cleanup() does nothing if init() fails. */
 	td->io_ops_data = data;
diff --git a/fio.1 b/fio.1
index 12eeb013..7c1b315a 100644
--- a/fio.1
+++ b/fio.1
@@ -2620,6 +2620,9 @@ A colon-separated list of libblkio properties to be set after connecting but
 before starting the \fBstruct blkio\fR. Each property must have the format
 \fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are set after
 the engine sets any other properties, so those can be overriden.
+.TP
+.BI (libblkio)hipri \fR=\fPbool
+Use poll queues.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
-- 
2.38.1

