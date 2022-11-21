Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FEDC4332F
	for <fio@archiver.kernel.org>; Mon, 21 Nov 2022 18:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiKUSaZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Nov 2022 13:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiKUSaW (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Nov 2022 13:30:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B86D14CF
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 10:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669055359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KJtJJhWVCKqzBEUCKdBh/Veg/AWBoEqulYs6jBHkElg=;
        b=i0MRG2ABnGGH3dntKSj7YZXiCilxD7N7xKYwJpkKBeH54PlyXbv+zYSXVOkq+Yqx8wvvki
        SaKKFurhphfTjua+xuyb2Q0FC/aDmeWGFGvWuBrdBl7OzCdcb9pFGh8AipQpZr0f2nmDkT
        bKLS32dUcUZdqkQaMKitVoRQS719lGQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-fTEjvfdRMC-d8tNOQGXbDg-1; Mon, 21 Nov 2022 13:29:18 -0500
X-MC-Unique: fTEjvfdRMC-d8tNOQGXbDg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 471CA3C0218F
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 18:29:18 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 25DB8492B06;
        Mon, 21 Nov 2022 18:29:16 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH 09/10] engines/libblkio: Add options for some driver-specific properties
Date:   Mon, 21 Nov 2022 18:29:01 +0000
Message-Id: <20221121182902.373491-10-afaria@redhat.com>
In-Reply-To: <20221121182902.373491-1-afaria@redhat.com>
References: <20221121182902.373491-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The properties are either common to several drivers or particularly
relevant for benchmarking, so this should help write cleaner workload
files.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 HOWTO.rst                                 | 39 ++++++++++----
 engines/libblkio.c                        | 64 ++++++++++++++++++++++-
 examples/libblkio-io_uring.fio            |  5 +-
 examples/libblkio-virtio-blk-vfio-pci.fio |  5 +-
 fio.1                                     | 32 +++++++++---
 5 files changed, 119 insertions(+), 26 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 7b3a3ffc..763f4f51 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2861,21 +2861,40 @@ with the caveat that when used on the command line, they must come after the
 
 	The driver to be used by libblkio (e.g. **virtio-blk-vfio-pci**).
 
+.. option:: libblkio_path=str : [libblkio]
+
+	Sets the value of the driver-specific "path" property prior to calling
+	``blkio_connect()``, which identifies the target device or file on which
+	to perform I/O. Its exact semantics are driver-dependent and not all
+	drivers may support it.
+
 .. option:: libblkio_pre_connect_props=str : [libblkio]
 
-	A colon-separated list of libblkio properties to be set after creating
-	but before connecting the ``struct blkio``. Each property must have the
-	format ``<name>=<value>``. Colons can be escaped as ``\:``. These are
-	set after the engine sets any other properties, so those can be
-	overriden.
+	A colon-separated list of additional libblkio properties to be set after
+	creating but before connecting the ``struct blkio``. Each property must
+	have the format ``<name>=<value>``. Colons can be escaped as ``\:``.
+	These are set after the engine sets any other properties, so those can
+	be overriden.
+
+.. option:: libblkio_num_entries=int : [libblkio]
+
+	Sets the value of the driver-specific "num-entries" property prior to
+	calling ``blkio_start()``. Its exact semantics are driver-dependent and
+	not all drivers may support it.
+
+.. option:: libblkio_queue_size=int : [libblkio]
+
+	Sets the value of the driver-specific "queue-size" property prior to
+	calling ``blkio_start()``. Its exact semantics are driver-dependent and
+	not all drivers may support it.
 
 .. option:: libblkio_pre_start_props=str : [libblkio]
 
-	A colon-separated list of libblkio properties to be set after connecting
-	but before starting the ``struct blkio``. Each property must have the
-	format ``<name>=<value>``. Colons can be escaped as ``\:``. These are
-	set after the engine sets any other properties, so those can be
-	overriden.
+	A colon-separated list of additional libblkio properties to be set after
+	connecting but before starting the ``struct blkio``. Each property must
+	have the format ``<name>=<value>``. Colons can be escaped as ``\:``.
+	These are set after the engine sets any other properties, so those can
+	be overriden.
 
 .. option:: libblkio_vectored=bool : [libblkio]
 
diff --git a/engines/libblkio.c b/engines/libblkio.c
index 3ff87e6d..a80be66f 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -30,7 +30,12 @@ struct fio_blkio_options {
 	void *pad; /* option fields must not have offset 0 */
 
 	char *driver;
+
+	char *path;
 	char *pre_connect_props;
+
+	int num_entries;
+	int queue_size;
 	char *pre_start_props;
 
 	unsigned int hipri;
@@ -50,18 +55,51 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBBLKIO,
 	},
+
+	{
+		.name	= "libblkio_path",
+		.lname	= "libblkio \"path\" property",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct fio_blkio_options, path),
+		.help	= "Value to set the \"path\" property to",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
 	{
 		.name	= "libblkio_pre_connect_props",
-		.lname	= "Properties to be set before blkio_connect()",
+		.lname	= "Additional properties to be set before blkio_connect()",
 		.type	= FIO_OPT_STR_STORE,
 		.off1	= offsetof(struct fio_blkio_options, pre_connect_props),
 		.help	= "",
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBBLKIO,
 	},
+
+	{
+		.name	= "libblkio_num_entries",
+		.lname	= "libblkio \"num-entries\" property",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct fio_blkio_options, num_entries),
+		.help	= "Value to set the \"num-entries\" property to",
+		.minval	= 1,
+		.interval = 1,
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
+	{
+		.name	= "libblkio_queue_size",
+		.lname	= "libblkio \"queue-size\" property",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct fio_blkio_options, queue_size),
+		.help	= "Value to set the \"queue-size\" property to",
+		.minval	= 1,
+		.interval = 1,
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
 	{
 		.name	= "libblkio_pre_start_props",
-		.lname	= "Properties to be set before blkio_start()",
+		.lname	= "Additional properties to be set before blkio_start()",
 		.type	= FIO_OPT_STR_STORE,
 		.off1	= offsetof(struct fio_blkio_options, pre_start_props),
 		.help	= "",
@@ -244,6 +282,13 @@ static int fio_blkio_create_and_connect(struct thread_data *td,
 		goto err_blkio_destroy;
 	}
 
+	if (options->path) {
+		if (blkio_set_str(b, "path", options->path) != 0) {
+			fio_blkio_log_err(blkio_set_str);
+			goto err_blkio_destroy;
+		}
+	}
+
 	if (fio_blkio_set_props_from_str(b, "libblkio_pre_connect_props",
 					 options->pre_connect_props) != 0)
 		goto err_blkio_destroy;
@@ -257,6 +302,21 @@ static int fio_blkio_create_and_connect(struct thread_data *td,
 
 	/* set pre-start properties */
 
+	if (options->num_entries != 0) {
+		if (blkio_set_int(b, "num-entries",
+				  options->num_entries) != 0) {
+			fio_blkio_log_err(blkio_set_int);
+			goto err_blkio_destroy;
+		}
+	}
+
+	if (options->queue_size != 0) {
+		if (blkio_set_int(b, "queue-size", options->queue_size) != 0) {
+			fio_blkio_log_err(blkio_set_int);
+			goto err_blkio_destroy;
+		}
+	}
+
 	if (fio_blkio_set_props_from_str(b, "libblkio_pre_start_props",
 					 options->pre_start_props) != 0)
 		goto err_blkio_destroy;
diff --git a/examples/libblkio-io_uring.fio b/examples/libblkio-io_uring.fio
index d2700e51..e5885094 100644
--- a/examples/libblkio-io_uring.fio
+++ b/examples/libblkio-io_uring.fio
@@ -1,15 +1,14 @@
 ; Benchmark accessing a regular file or block device using libblkio.
 ;
 ; Replace "libblkio_path" below with the path to your file or device, or
-; override it by passing the '--libblkio_pre_connect_props=path=...' flag to
-; fio.
+; override it by passing the '--libblkio_path=...' flag to fio.
 ;
 ; For information on libblkio, see: https://gitlab.com/libblkio/libblkio
 
 [global]
 ioengine=libblkio
 libblkio_driver=io_uring
-libblkio_pre_connect_props=path=/dev/nvme0n1  ; REPLACE THIS WITH THE RIGHT PATH
+libblkio_path=/dev/nvme0n1  ; REPLACE THIS WITH THE RIGHT PATH
 rw=randread
 blocksize=4k
 direct=1
diff --git a/examples/libblkio-virtio-blk-vfio-pci.fio b/examples/libblkio-virtio-blk-vfio-pci.fio
index 79d6228d..ba89f7ef 100644
--- a/examples/libblkio-virtio-blk-vfio-pci.fio
+++ b/examples/libblkio-virtio-blk-vfio-pci.fio
@@ -1,15 +1,14 @@
 ; Benchmark accessing a PCI virtio-blk device using libblkio.
 ;
 ; Replace "libblkio_path" below with the path to your device's sysfs directory,
-; or override it by passing the '--libblkio_pre_connect_props=path=...' flag to
-; fio. Note that colons in the path must be escaped with a backslash.
+; or override it by passing the '--libblkio_path=...' flag to fio.
 ;
 ; For information on libblkio, see: https://gitlab.com/libblkio/libblkio
 
 [global]
 ioengine=libblkio
 libblkio_driver=virtio-blk-vfio-pci
-libblkio_pre_connect_props=path=/sys/bus/pci/devices/0000\:00\:01.0  ; REPLACE THIS WITH THE RIGHT PATH
+libblkio_path=/sys/bus/pci/devices/0000:00:01.0  ; REPLACE THIS WITH THE RIGHT PATH
 rw=randread
 blocksize=4k
 time_based=1
diff --git a/fio.1 b/fio.1
index e2f92bd1..f20a4164 100644
--- a/fio.1
+++ b/fio.1
@@ -2609,17 +2609,33 @@ If this option is set, xnvme will use vectored read/write commands.
 .BI (libblkio)libblkio_driver \fR=\fPstr
 The driver to be used by libblkio (e.g. \fBvirtio-blk-vfio-pci\fR).
 .TP
+.BI (libblkio)libblkio_path \fR=\fPstr
+Sets the value of the driver-specific "path" property prior to calling
+\fBblkio_connect()\fR, which identifies the target device or file on which to
+perform I/O. Its exact semantics are driver-dependent and not all drivers may
+support it.
+.TP
 .BI (libblkio)libblkio_pre_connect_props \fR=\fPstr
-A colon-separated list of libblkio properties to be set after creating but
-before connecting the \fBstruct blkio\fR. Each property must have the format
-\fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are set after
-the engine sets any other properties, so those can be overriden.
+A colon-separated list of additional libblkio properties to be set after
+creating but before connecting the \fBstruct blkio\fR. Each property must have
+the format \fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are
+set after the engine sets any other properties, so those can be overriden.
+.TP
+.BI (libblkio)libblkio_num_entries \fR=\fPint
+Sets the value of the driver-specific "num-entries" property prior to calling
+\fBblkio_start()\fR. Its exact semantics are driver-dependent and not all
+drivers may support it.
+.TP
+.BI (libblkio)libblkio_queue_size \fR=\fPint
+Sets the value of the driver-specific "queue-size" property prior to calling
+\fBblkio_start()\fR. Its exact semantics are driver-dependent and not all
+drivers may support it.
 .TP
 .BI (libblkio)libblkio_pre_start_props \fR=\fPstr
-A colon-separated list of libblkio properties to be set after connecting but
-before starting the \fBstruct blkio\fR. Each property must have the format
-\fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are set after
-the engine sets any other properties, so those can be overriden.
+A colon-separated list of additional libblkio properties to be set after
+connecting but before starting the \fBstruct blkio\fR. Each property must have
+the format \fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are
+set after the engine sets any other properties, so those can be overriden.
 .TP
 .BI (libblkio)hipri \fR=\fPbool
 Use poll queues. This is incompatible with \fBlibblkio_wait_mode=eventfd\fR and
-- 
2.38.1

