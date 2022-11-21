Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48861C4332F
	for <fio@archiver.kernel.org>; Mon, 21 Nov 2022 18:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiKUSaT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Nov 2022 13:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiKUSaS (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Nov 2022 13:30:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1087FD06EB
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 10:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669055357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hXwmVQaQ/JertBU5vE90nXOh2pva+w2z9YzfS8zY9TM=;
        b=Y/FM5XyPWZKC9dhvLq0TgYP2nQGAWpASoPsiGrTQJz+PX+cSxFyriolxLohfBRd+uhKXB7
        pgO8MUEdMTCY3yrloL+e0D+1nHQwXvYE1Ak1qBd3OevoXeNMgvpzLvbvfDn7Kn6y6RtYKv
        gU55WY+5yKc1J45UN6Yg8JXqfC78jX0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-DRuIQvVcNy-7CrzC-hARMw-1; Mon, 21 Nov 2022 13:29:15 -0500
X-MC-Unique: DRuIQvVcNy-7CrzC-hARMw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DE18811E7A
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 18:29:15 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3BD58492B06;
        Mon, 21 Nov 2022 18:29:14 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH 07/10] engines/libblkio: Add option libblkio_wait_mode
Date:   Mon, 21 Nov 2022 18:28:59 +0000
Message-Id: <20221121182902.373491-8-afaria@redhat.com>
In-Reply-To: <20221121182902.373491-1-afaria@redhat.com>
References: <20221121182902.373491-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

It allows configuring how the engine waits for request completions,
instead of always using a blocking blkioq_do_io() call.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 HOWTO.rst          |  14 ++++-
 engines/libblkio.c | 132 ++++++++++++++++++++++++++++++++++++++++++---
 fio.1              |  16 +++++-
 3 files changed, 154 insertions(+), 8 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 7155add6..4b059cb2 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2332,7 +2332,8 @@ with the caveat that when used on the command line, they must come after the
 
    [libblkio]
 
-	Use poll queues.
+	Use poll queues. This is incompatible with
+	:option:`libblkio_wait_mode=eventfd <libblkio_wait_mode>`.
 
    [pvsync2]
 
@@ -2884,6 +2885,17 @@ with the caveat that when used on the command line, they must come after the
 	Submit trims as "write zeroes" requests instead of discard requests.
 	Default is 0.
 
+.. option:: libblkio_wait_mode=str : [libblkio]
+
+	How to wait for completions:
+
+	**block** (default)
+		Use a blocking call to ``blkioq_do_io()``.
+	**eventfd**
+		Use a blocking call to ``read()`` on the completion eventfd.
+	**loop**
+		Use a busy loop with a non-blocking call to ``blkioq_do_io()``.
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/engines/libblkio.c b/engines/libblkio.c
index 79af3aa7..d7666f69 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -20,6 +20,12 @@
 #include "../options.h"
 #include "../parse.h"
 
+enum fio_blkio_wait_mode {
+	FIO_BLKIO_WAIT_MODE_BLOCK,
+	FIO_BLKIO_WAIT_MODE_EVENTFD,
+	FIO_BLKIO_WAIT_MODE_LOOP,
+};
+
 struct fio_blkio_options {
 	void *pad; /* option fields must not have offset 0 */
 
@@ -30,6 +36,7 @@ struct fio_blkio_options {
 	unsigned int hipri;
 	unsigned int vectored;
 	unsigned int write_zeroes_on_trim;
+	enum fio_blkio_wait_mode wait_mode;
 };
 
 static struct fio_option options[] = {
@@ -89,6 +96,30 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBBLKIO,
 	},
+	{
+		.name	= "libblkio_wait_mode",
+		.lname	= "How to wait for completions",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct fio_blkio_options, wait_mode),
+		.help	= "How to wait for completions",
+		.def	= "block",
+		.posval = {
+			  { .ival = "block",
+			    .oval = FIO_BLKIO_WAIT_MODE_BLOCK,
+			    .help = "Blocking blkioq_do_io()",
+			  },
+			  { .ival = "eventfd",
+			    .oval = FIO_BLKIO_WAIT_MODE_EVENTFD,
+			    .help = "Blocking read() on the completion eventfd",
+			  },
+			  { .ival = "loop",
+			    .oval = FIO_BLKIO_WAIT_MODE_LOOP,
+			    .help = "Busy loop with non-blocking blkioq_do_io()",
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
 
 	{
 		.name = NULL,
@@ -237,12 +268,21 @@ static int fio_blkio_setup(struct thread_data *td)
 	 * again in the init() callback.
 	 */
 
+	const struct fio_blkio_options *options = td->eo;
 	struct blkio *b;
 	int ret = 0;
 	uint64_t capacity;
 
 	assert(td->files_index == 1);
 
+	/* validate options */
+
+	if (options->hipri &&
+		options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD) {
+		log_err("fio: option hipri is incompatible with option libblkio_wait_mode=eventfd\n");
+		return 1;
+	}
+
 	/* get target size */
 
 	if (fio_blkio_create_and_connect(td, &b) != 0)
@@ -268,6 +308,7 @@ out_blkio_destroy:
 struct fio_blkio_data {
 	struct blkio *b;
 	struct blkioq *q;
+	int completion_fd; /* -1 if not FIO_BLKIO_WAIT_MODE_EVENTFD */
 
 	bool has_mem_region; /* whether mem_region is valid */
 	struct blkio_mem_region mem_region; /* only if allocated by libblkio */
@@ -280,6 +321,7 @@ static int fio_blkio_init(struct thread_data *td)
 {
 	const struct fio_blkio_options *options = td->eo;
 	struct fio_blkio_data *data;
+	int flags;
 
 	/* allocate per-thread data struct */
 
@@ -324,6 +366,31 @@ static int fio_blkio_init(struct thread_data *td)
 	else
 		data->q = blkio_get_queue(data->b, 0);
 
+	/* enable completion fd and make it blocking */
+
+	if (options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD) {
+		blkioq_set_completion_fd_enabled(data->q, true);
+
+		data->completion_fd = blkioq_get_completion_fd(data->q);
+
+		flags = fcntl(data->completion_fd, F_GETFL);
+		if (flags < 0) {
+			log_err("fio: fcntl(F_GETFL) failed: %s\n",
+				strerror(errno));
+			goto err_blkio_destroy;
+		}
+
+		flags &= ~O_NONBLOCK;
+
+		if (fcntl(data->completion_fd, F_SETFL, flags) != 0) {
+			log_err("fio: fcntl(F_SETFL) failed: %s\n",
+				strerror(errno));
+			goto err_blkio_destroy;
+		}
+	} else {
+		data->completion_fd = -1;
+	}
+
 	/* Set data only here so cleanup() does nothing if init() fails. */
 	td->io_ops_data = data;
 
@@ -521,16 +588,69 @@ static enum fio_q_status fio_blkio_queue(struct thread_data *td,
 static int fio_blkio_getevents(struct thread_data *td, unsigned int min,
 			       unsigned int max, const struct timespec *t)
 {
+	const struct fio_blkio_options *options = td->eo;
 	struct fio_blkio_data *data = td->io_ops_data;
-	int n;
+	int ret, n;
+	uint64_t event;
 
-	n = blkioq_do_io(data->q, data->completions, (int)min, (int)max, NULL);
-	if (n < 0) {
-		fio_blkio_log_err(blkioq_do_io);
+	switch (options->wait_mode) {
+	case FIO_BLKIO_WAIT_MODE_BLOCK:
+
+		n = blkioq_do_io(data->q, data->completions, (int)min, (int)max,
+				 NULL);
+		if (n < 0) {
+			fio_blkio_log_err(blkioq_do_io);
+			return -1;
+		}
+
+		return n;
+
+	case FIO_BLKIO_WAIT_MODE_EVENTFD:
+
+		n = blkioq_do_io(data->q, data->completions, 0, (int)max, NULL);
+		if (n < 0) {
+			fio_blkio_log_err(blkioq_do_io);
+			return -1;
+		}
+
+		while (n < (int)min) {
+			ret = read(data->completion_fd, &event, sizeof(event));
+			if (ret != sizeof(event)) {
+				log_err("fio: read() on the completion fd returned %d\n",
+					ret);
+				return -1;
+			}
+
+			ret = blkioq_do_io(data->q, data->completions + n, 0,
+					   (int)max - n, NULL);
+			if (ret < 0) {
+				fio_blkio_log_err(blkioq_do_io);
+				return -1;
+			}
+
+			n += ret;
+		}
+
+		return n;
+
+	case FIO_BLKIO_WAIT_MODE_LOOP:
+
+		for (n = 0; n < (int)min; ) {
+			ret = blkioq_do_io(data->q, data->completions + n, 0,
+					   (int)max - n, NULL);
+			if (ret < 0) {
+				fio_blkio_log_err(blkioq_do_io);
+				return -1;
+			}
+
+			n += ret;
+		}
+
+		return n;
+
+	default:
 		return -1;
 	}
-
-	return n;
 }
 
 static struct io_u *fio_blkio_event(struct thread_data *td, int event)
diff --git a/fio.1 b/fio.1
index 053c2eda..88bb232f 100644
--- a/fio.1
+++ b/fio.1
@@ -2622,7 +2622,7 @@ before starting the \fBstruct blkio\fR. Each property must have the format
 the engine sets any other properties, so those can be overriden.
 .TP
 .BI (libblkio)hipri \fR=\fPbool
-Use poll queues.
+Use poll queues. This is incompatible with \fBlibblkio_wait_mode=eventfd\fR.
 .TP
 .BI (libblkio)libblkio_vectored \fR=\fPbool
 Submit vectored read and write requests. Default is 0.
@@ -2630,6 +2630,20 @@ Submit vectored read and write requests. Default is 0.
 .BI (libblkio)libblkio_write_zeroes_on_trim \fR=\fPbool
 Submit trims as "write zeroes" requests instead of discard requests. Default is
 0.
+.TP
+.BI (libblkio)libblkio_wait_mode \fR=\fPstr
+How to wait for completions:
+.RS
+.RS
+.TP
+.B block \fR(default)
+Use a blocking call to \fBblkioq_do_io()\fR.
+.TP
+.B eventfd
+Use a blocking call to \fBread()\fR on the completion eventfd.
+.TP
+.B loop
+Use a busy loop with a non-blocking call to \fBblkioq_do_io()\fR.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
-- 
2.38.1

