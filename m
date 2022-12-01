Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1DEC4332F
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 22:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiLAWJc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiLAWJ3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 17:09:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A6B2B18F
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 14:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669932501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hCHKzu5TRv4K5ZShkgtE8n9U8bqfRKiPFbrQ8XRW8kg=;
        b=hnZVCd3JGoAx3q2zPFy2jHS61KcjfCgnLu8nfWsOxhYSBH5GP+YNNH62jgJAbCR76f1cYd
        hFkfU+ozVFJTinHv23I7WSJbiAjyTXeFCvJoH9KaNyK2eIC7FkSdtSkIr3okUOICNNwRZ6
        jVOxVdRDwMPGQ74BMueFrU0DCeYoFgY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-9lSUdfuhOFOyuS39CFdA4g-1; Thu, 01 Dec 2022 17:08:19 -0500
X-MC-Unique: 9lSUdfuhOFOyuS39CFdA4g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 706C9811E75;
        Thu,  1 Dec 2022 22:08:19 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16DA1477F55;
        Thu,  1 Dec 2022 22:08:17 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Vincent Fu <vincentfu@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH v2 07/10] engines/libblkio: Add option libblkio_wait_mode
Date:   Thu,  1 Dec 2022 22:08:00 +0000
Message-Id: <20221201220803.52057-8-afaria@redhat.com>
In-Reply-To: <20221201220803.52057-1-afaria@redhat.com>
References: <20221201220803.52057-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

It allows configuring how the engine waits for request completions,
instead of always using a blocking blkioq_do_io() call.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 HOWTO.rst          |  14 +++++-
 engines/libblkio.c | 117 ++++++++++++++++++++++++++++++++++++++++++---
 fio.1              |  16 ++++++-
 3 files changed, 139 insertions(+), 8 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 273b7a68..e9602f59 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2337,7 +2337,8 @@ with the caveat that when used on the command line, they must come after the
 
    [libblkio]
 
-	Use poll queues.
+	Use poll queues. This is incompatible with
+	:option:`libblkio_wait_mode=eventfd <libblkio_wait_mode>`.
 
    [pvsync2]
 
@@ -2895,6 +2896,17 @@ with the caveat that when used on the command line, they must come after the
 
 	Submit trims as "write zeroes" requests instead of discard requests.
 
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
index 66a9bd31..8a4828c3 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -24,6 +24,7 @@
 struct fio_blkio_data {
 	struct blkio *b;
 	struct blkioq *q;
+	int completion_fd; /* -1 if not FIO_BLKIO_WAIT_MODE_EVENTFD */
 
 	bool has_mem_region; /* whether mem_region is valid */
 	struct blkio_mem_region mem_region; /* only if allocated by libblkio */
@@ -32,6 +33,12 @@ struct fio_blkio_data {
 	struct blkio_completion *completions;
 };
 
+enum fio_blkio_wait_mode {
+	FIO_BLKIO_WAIT_MODE_BLOCK,
+	FIO_BLKIO_WAIT_MODE_EVENTFD,
+	FIO_BLKIO_WAIT_MODE_LOOP,
+};
+
 struct fio_blkio_options {
 	void *pad; /* option fields must not have offset 0 */
 
@@ -42,6 +49,7 @@ struct fio_blkio_options {
 	unsigned int hipri;
 	unsigned int vectored;
 	unsigned int write_zeroes_on_trim;
+	enum fio_blkio_wait_mode wait_mode;
 };
 
 static struct fio_option options[] = {
@@ -100,6 +108,30 @@ static struct fio_option options[] = {
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
 	},
@@ -231,12 +263,19 @@ err_blkio_destroy:
  */
 static int fio_blkio_setup(struct thread_data *td)
 {
+	const struct fio_blkio_options *options = td->eo;
 	struct blkio *b;
 	int ret = 0;
 	uint64_t capacity;
 
 	assert(td->files_index == 1);
 
+	if (options->hipri &&
+		options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD) {
+		log_err("fio: option hipri is incompatible with option libblkio_wait_mode=eventfd\n");
+		return 1;
+	}
+
 	if (fio_blkio_create_and_connect(td, &b) != 0)
 		return 1;
 
@@ -258,6 +297,7 @@ static int fio_blkio_init(struct thread_data *td)
 {
 	const struct fio_blkio_options *options = td->eo;
 	struct fio_blkio_data *data;
+	int flags;
 
 	/*
 	 * Request enqueueing is fast, and it's not possible to know exactly
@@ -302,6 +342,28 @@ static int fio_blkio_init(struct thread_data *td)
 	else
 		data->q = blkio_get_queue(data->b, 0);
 
+	if (options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD) {
+		/* enable completion fd and make it blocking */
+		blkioq_set_completion_fd_enabled(data->q, true);
+		data->completion_fd = blkioq_get_completion_fd(data->q);
+
+		flags = fcntl(data->completion_fd, F_GETFL);
+		if (flags < 0) {
+			log_err("fio: fcntl(F_GETFL) failed: %s\n",
+				strerror(errno));
+			goto err_blkio_destroy;
+		}
+
+		if (fcntl(data->completion_fd, F_SETFL,
+			  flags & ~O_NONBLOCK) != 0) {
+			log_err("fio: fcntl(F_SETFL) failed: %s\n",
+				strerror(errno));
+			goto err_blkio_destroy;
+		}
+	} else {
+		data->completion_fd = -1;
+	}
+
 	/* Set data last so cleanup() does nothing if init() fails. */
 	td->io_ops_data = data;
 
@@ -490,16 +552,59 @@ static enum fio_q_status fio_blkio_queue(struct thread_data *td,
 static int fio_blkio_getevents(struct thread_data *td, unsigned int min,
 			       unsigned int max, const struct timespec *t)
 {
+	const struct fio_blkio_options *options = td->eo;
 	struct fio_blkio_data *data = td->io_ops_data;
-	int n;
+	int ret, n;
+	uint64_t event;
+
+	switch (options->wait_mode) {
+	case FIO_BLKIO_WAIT_MODE_BLOCK:
+		n = blkioq_do_io(data->q, data->completions, (int)min, (int)max,
+				 NULL);
+		if (n < 0) {
+			fio_blkio_log_err(blkioq_do_io);
+			return -1;
+		}
+		return n;
+	case FIO_BLKIO_WAIT_MODE_EVENTFD:
+		n = blkioq_do_io(data->q, data->completions, 0, (int)max, NULL);
+		if (n < 0) {
+			fio_blkio_log_err(blkioq_do_io);
+			return -1;
+		}
+		while (n < (int)min) {
+			ret = read(data->completion_fd, &event, sizeof(event));
+			if (ret != sizeof(event)) {
+				log_err("fio: read() on the completion fd returned %d\n",
+					ret);
+				return -1;
+			}
 
-	n = blkioq_do_io(data->q, data->completions, (int)min, (int)max, NULL);
-	if (n < 0) {
-		fio_blkio_log_err(blkioq_do_io);
+			ret = blkioq_do_io(data->q, data->completions + n, 0,
+					   (int)max - n, NULL);
+			if (ret < 0) {
+				fio_blkio_log_err(blkioq_do_io);
+				return -1;
+			}
+
+			n += ret;
+		}
+		return n;
+	case FIO_BLKIO_WAIT_MODE_LOOP:
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
+		return n;
+	default:
 		return -1;
 	}
-
-	return n;
 }
 
 static struct io_u *fio_blkio_event(struct thread_data *td, int event)
diff --git a/fio.1 b/fio.1
index ad061caa..1a810214 100644
--- a/fio.1
+++ b/fio.1
@@ -2633,13 +2633,27 @@ properties depend on the libblkio version in use and are listed at
 \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#properties\fR
 .TP
 .BI (libblkio)hipri
-Use poll queues.
+Use poll queues. This is incompatible with \fBlibblkio_wait_mode=eventfd\fR.
 .TP
 .BI (libblkio)libblkio_vectored
 Submit vectored read and write requests.
 .TP
 .BI (libblkio)libblkio_write_zeroes_on_trim
 Submit trims as "write zeroes" requests instead of discard requests.
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

