Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1302BC4708E
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 22:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiLAWJV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiLAWJR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 17:09:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8422935D
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 14:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669932495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+qdozbdQ3DOJlBeRCDwrmauOFWr6/hlfXs6OEWpZSnk=;
        b=byCx0AHzN5sAJhekqu449eNdz4o6QCG/8LWdA8K7NI0KHkHY50OdLxJOGlQR2Fs/41R7gF
        rd7F+IJTaqlGUR+VtcmsA6Edxk5wJ20tJJerpYdANjRQHhASeCH6QTYtdlCRIx3Jr4pq+w
        zuoHO8ITvkKy6ZoDEYzc3j9X7yuYPLs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-1WLqJm1QOR68vMfcJSyNcA-1; Thu, 01 Dec 2022 17:08:14 -0500
X-MC-Unique: 1WLqJm1QOR68vMfcJSyNcA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69438811E67;
        Thu,  1 Dec 2022 22:08:14 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DB99477F55;
        Thu,  1 Dec 2022 22:08:12 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Vincent Fu <vincentfu@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH v2 04/10] engines/libblkio: Add support for poll queues
Date:   Thu,  1 Dec 2022 22:07:57 +0000
Message-Id: <20221201220803.52057-5-afaria@redhat.com>
In-Reply-To: <20221201220803.52057-1-afaria@redhat.com>
References: <20221201220803.52057-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Configure a poll queue instead of a "regular" queue when option hipri is
set.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 HOWTO.rst          |  4 ++++
 engines/libblkio.c | 25 +++++++++++++++++++++++--
 fio.1              |  3 +++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 69ca1e79..2b3fe9c2 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2335,6 +2335,10 @@ with the caveat that when used on the command line, they must come after the
         by the application. The benefits are more efficient IO for high IOPS
         scenarios, and lower latencies for low queue depth IO.
 
+   [libblkio]
+
+	Use poll queues.
+
    [pvsync2]
 
 	Set RWF_HIPRI on I/O, indicating to the kernel that it's of higher priority
diff --git a/engines/libblkio.c b/engines/libblkio.c
index 11f45e2a..6decfd39 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -37,6 +37,8 @@ struct fio_blkio_options {
 	char *driver;
 	char *pre_connect_props;
 	char *pre_start_props;
+
+	unsigned int hipri;
 };
 
 static struct fio_option options[] = {
@@ -67,6 +69,15 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
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
 	{
 		.name = NULL,
 	},
@@ -223,6 +234,7 @@ out_blkio_destroy:
 
 static int fio_blkio_init(struct thread_data *td)
 {
+	const struct fio_blkio_options *options = td->eo;
 	struct fio_blkio_data *data;
 
 	/*
@@ -246,7 +258,13 @@ static int fio_blkio_init(struct thread_data *td)
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
@@ -256,7 +274,10 @@ static int fio_blkio_init(struct thread_data *td)
 		goto err_blkio_destroy;
 	}
 
-	data->q = blkio_get_queue(data->b, 0);
+	if (options->hipri)
+		data->q = blkio_get_poll_queue(data->b, 0);
+	else
+		data->q = blkio_get_queue(data->b, 0);
 
 	/* Set data last so cleanup() does nothing if init() fails. */
 	td->io_ops_data = data;
diff --git a/fio.1 b/fio.1
index 18428774..7f97e940 100644
--- a/fio.1
+++ b/fio.1
@@ -2631,6 +2631,9 @@ before starting the libblkio instance. Each property must have the format
 the engine sets any other properties, so those can be overriden. Available
 properties depend on the libblkio version in use and are listed at
 \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#properties\fR
+.TP
+.BI (libblkio)hipri
+Use poll queues.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
-- 
2.38.1

