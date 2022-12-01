Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169A8C4321E
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 22:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiLAWJl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiLAWJi (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 17:09:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379E24B749
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 14:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669932506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j5veDCPk/jRYTrPhG0qpXCHleieDKTcLwXZM24l7UC4=;
        b=TrEhuHGMOF2anPwBA/NEW4Yj+fuDmeSGnUwhSYslVutgzi4HZsq9Mu+/ICJqtjR2GmlVHs
        f0CLDC69HX7hxMBVqvPRZ02yxz4EOEDn8ZGHuuX1kxNFJryE2DJyGJUDrZfF6tgUogp+JE
        7fKNWdGnTcTfuZdkLPXfJnjdNRoiVwE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-v8YU6tfUP8eRsMQTJC2oJw-1; Thu, 01 Dec 2022 17:08:23 -0500
X-MC-Unique: v8YU6tfUP8eRsMQTJC2oJw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DC6D38107A0;
        Thu,  1 Dec 2022 22:08:21 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7447477F55;
        Thu,  1 Dec 2022 22:08:19 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Vincent Fu <vincentfu@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH v2 08/10] engines/libblkio: Add option libblkio_force_enable_completion_eventfd
Date:   Thu,  1 Dec 2022 22:08:01 +0000
Message-Id: <20221201220803.52057-9-afaria@redhat.com>
In-Reply-To: <20221201220803.52057-1-afaria@redhat.com>
References: <20221201220803.52057-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When set, the queue's completion fd is enabled even when it isn't used,
i.e., even if option libblkio_wait_mode is _not_ set to "eventfd".

Depending on the libblkio driver, this can have an impact on
performance. This option allows evaluating that overhead.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 HOWTO.rst          |  9 ++++++++-
 engines/libblkio.c | 21 +++++++++++++++++++--
 fio.1              | 10 +++++++++-
 3 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index e9602f59..1cea16c4 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2338,7 +2338,8 @@ with the caveat that when used on the command line, they must come after the
    [libblkio]
 
 	Use poll queues. This is incompatible with
-	:option:`libblkio_wait_mode=eventfd <libblkio_wait_mode>`.
+	:option:`libblkio_wait_mode=eventfd <libblkio_wait_mode>` and
+	:option:`libblkio_force_enable_completion_eventfd`.
 
    [pvsync2]
 
@@ -2907,6 +2908,12 @@ with the caveat that when used on the command line, they must come after the
 	**loop**
 		Use a busy loop with a non-blocking call to ``blkioq_do_io()``.
 
+.. option:: libblkio_force_enable_completion_eventfd : [libblkio]
+
+	Enable the queue's completion eventfd even when unused. This may impact
+	performance. The default is to enable it only if
+	:option:`libblkio_wait_mode=eventfd <libblkio_wait_mode>`.
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/engines/libblkio.c b/engines/libblkio.c
index 8a4828c3..7f5dcf36 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -24,7 +24,7 @@
 struct fio_blkio_data {
 	struct blkio *b;
 	struct blkioq *q;
-	int completion_fd; /* -1 if not FIO_BLKIO_WAIT_MODE_EVENTFD */
+	int completion_fd; /* may be -1 if not FIO_BLKIO_WAIT_MODE_EVENTFD */
 
 	bool has_mem_region; /* whether mem_region is valid */
 	struct blkio_mem_region mem_region; /* only if allocated by libblkio */
@@ -50,6 +50,7 @@ struct fio_blkio_options {
 	unsigned int vectored;
 	unsigned int write_zeroes_on_trim;
 	enum fio_blkio_wait_mode wait_mode;
+	unsigned int force_enable_completion_eventfd;
 };
 
 static struct fio_option options[] = {
@@ -132,6 +133,16 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBBLKIO,
 	},
+	{
+		.name	= "libblkio_force_enable_completion_eventfd",
+		.lname	= "Force enable the completion eventfd, even if unused",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct fio_blkio_options,
+				   force_enable_completion_eventfd),
+		.help	= "This can impact performance",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
 	{
 		.name = NULL,
 	},
@@ -276,6 +287,11 @@ static int fio_blkio_setup(struct thread_data *td)
 		return 1;
 	}
 
+	if (options->hipri && options->force_enable_completion_eventfd) {
+		log_err("fio: option hipri is incompatible with option libblkio_force_enable_completion_eventfd\n");
+		return 1;
+	}
+
 	if (fio_blkio_create_and_connect(td, &b) != 0)
 		return 1;
 
@@ -342,7 +358,8 @@ static int fio_blkio_init(struct thread_data *td)
 	else
 		data->q = blkio_get_queue(data->b, 0);
 
-	if (options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD) {
+	if (options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD ||
+		options->force_enable_completion_eventfd) {
 		/* enable completion fd and make it blocking */
 		blkioq_set_completion_fd_enabled(data->q, true);
 		data->completion_fd = blkioq_get_completion_fd(data->q);
diff --git a/fio.1 b/fio.1
index 1a810214..da548303 100644
--- a/fio.1
+++ b/fio.1
@@ -2633,7 +2633,8 @@ properties depend on the libblkio version in use and are listed at
 \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#properties\fR
 .TP
 .BI (libblkio)hipri
-Use poll queues. This is incompatible with \fBlibblkio_wait_mode=eventfd\fR.
+Use poll queues. This is incompatible with \fBlibblkio_wait_mode=eventfd\fR and
+\fBlibblkio_force_enable_completion_eventfd\fR.
 .TP
 .BI (libblkio)libblkio_vectored
 Submit vectored read and write requests.
@@ -2654,6 +2655,13 @@ Use a blocking call to \fBread()\fR on the completion eventfd.
 .TP
 .B loop
 Use a busy loop with a non-blocking call to \fBblkioq_do_io()\fR.
+.RE
+.RE
+.TP
+.BI (libblkio)libblkio_force_enable_completion_eventfd
+Enable the queue's completion eventfd even when unused. This may impact
+performance. The default is to enable it only if
+\fBlibblkio_wait_mode=eventfd\fR.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
-- 
2.38.1

