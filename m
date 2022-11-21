Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6682DC433FE
	for <fio@archiver.kernel.org>; Mon, 21 Nov 2022 18:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiKUSaZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Nov 2022 13:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiKUSaW (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Nov 2022 13:30:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6D3D14E2
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 10:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669055360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OYEqttUywRI54y50LJYIPeGfk/2Plc730Z++x6OdG8I=;
        b=aY4QWwQuNwGSEs9Uckf/epUj6gEzuDAbLFfSqkD+kVqvwjRWziRWrD8qJ5WaFvXX5ZGatq
        4PP5CB1PS8MH4XwYMeEny7MISiBp3+xnl49VJhhgTbJC4Gk/e4aveP7c0Va9IAIh0WjNxU
        4fRlNCymOm2ekC0XIzl8E4X92AOB+Y0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-JAZrVGMwOL-_cfWmO26iQg-1; Mon, 21 Nov 2022 13:29:17 -0500
X-MC-Unique: JAZrVGMwOL-_cfWmO26iQg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCAD0801755
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 18:29:16 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA840492B06;
        Mon, 21 Nov 2022 18:29:15 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH 08/10] engines/libblkio: Add option libblkio_force_enable_completion_eventfd
Date:   Mon, 21 Nov 2022 18:29:00 +0000
Message-Id: <20221121182902.373491-9-afaria@redhat.com>
In-Reply-To: <20221121182902.373491-1-afaria@redhat.com>
References: <20221121182902.373491-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
index 4b059cb2..7b3a3ffc 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2333,7 +2333,8 @@ with the caveat that when used on the command line, they must come after the
    [libblkio]
 
 	Use poll queues. This is incompatible with
-	:option:`libblkio_wait_mode=eventfd <libblkio_wait_mode>`.
+	:option:`libblkio_wait_mode=eventfd <libblkio_wait_mode>` and
+	:option:`libblkio_force_enable_completion_eventfd`.
 
    [pvsync2]
 
@@ -2896,6 +2897,12 @@ with the caveat that when used on the command line, they must come after the
 	**loop**
 		Use a busy loop with a non-blocking call to ``blkioq_do_io()``.
 
+.. option:: libblkio_force_enable_completion_eventfd=bool : [libblkio]
+
+	Enable the ``struct blkioq``'s completion eventfd even when unused. This
+	may impact performance. The default is to enable it only if
+	:option:`libblkio_wait_mode` is **eventfd**.
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/engines/libblkio.c b/engines/libblkio.c
index d7666f69..3ff87e6d 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -37,6 +37,7 @@ struct fio_blkio_options {
 	unsigned int vectored;
 	unsigned int write_zeroes_on_trim;
 	enum fio_blkio_wait_mode wait_mode;
+	unsigned int force_enable_completion_eventfd;
 };
 
 static struct fio_option options[] = {
@@ -120,6 +121,16 @@ static struct fio_option options[] = {
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
@@ -283,6 +294,11 @@ static int fio_blkio_setup(struct thread_data *td)
 		return 1;
 	}
 
+	if (options->hipri && options->force_enable_completion_eventfd) {
+		log_err("fio: option hipri is incompatible with option libblkio_force_enable_completion_eventfd\n");
+		return 1;
+	}
+
 	/* get target size */
 
 	if (fio_blkio_create_and_connect(td, &b) != 0)
@@ -308,7 +324,7 @@ out_blkio_destroy:
 struct fio_blkio_data {
 	struct blkio *b;
 	struct blkioq *q;
-	int completion_fd; /* -1 if not FIO_BLKIO_WAIT_MODE_EVENTFD */
+	int completion_fd; /* may be -1 if not FIO_BLKIO_WAIT_MODE_EVENTFD */
 
 	bool has_mem_region; /* whether mem_region is valid */
 	struct blkio_mem_region mem_region; /* only if allocated by libblkio */
@@ -368,7 +384,8 @@ static int fio_blkio_init(struct thread_data *td)
 
 	/* enable completion fd and make it blocking */
 
-	if (options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD) {
+	if (options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD ||
+		options->force_enable_completion_eventfd) {
 		blkioq_set_completion_fd_enabled(data->q, true);
 
 		data->completion_fd = blkioq_get_completion_fd(data->q);
diff --git a/fio.1 b/fio.1
index 88bb232f..e2f92bd1 100644
--- a/fio.1
+++ b/fio.1
@@ -2622,7 +2622,8 @@ before starting the \fBstruct blkio\fR. Each property must have the format
 the engine sets any other properties, so those can be overriden.
 .TP
 .BI (libblkio)hipri \fR=\fPbool
-Use poll queues. This is incompatible with \fBlibblkio_wait_mode=eventfd\fR.
+Use poll queues. This is incompatible with \fBlibblkio_wait_mode=eventfd\fR and
+\fBlibblkio_force_enable_completion_eventfd\fR.
 .TP
 .BI (libblkio)libblkio_vectored \fR=\fPbool
 Submit vectored read and write requests. Default is 0.
@@ -2644,6 +2645,13 @@ Use a blocking call to \fBread()\fR on the completion eventfd.
 .TP
 .B loop
 Use a busy loop with a non-blocking call to \fBblkioq_do_io()\fR.
+.RE
+.RE
+.TP
+.BI (libblkio)libblkio_force_enable_completion_eventfd \fR=\fPbool
+Enable the \fBstruct blkioq\fR's completion eventfd even when unused. This may
+impact performance. The default is to enable it only if \fBlibblkio_wait_mode\fR
+is \fBeventfd\fR.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
-- 
2.38.1

