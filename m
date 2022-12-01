Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F535C4332F
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 22:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiLAWJk (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiLAWJh (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 17:09:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A284A9C2
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 14:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669932506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uOWFnEDpsJV/EJ+5JiRoyNExkg1oV2YiRboUF+Jr0ec=;
        b=OkpwKV3o/qe2BwE4H9zpOS9TkrB7Dc+fhERZpmMx/2b+JgbtFaahntifKhZqxbwO8jlCp+
        yvS+geK0h0dD17G8vJ4HgdVpv46pZo6dh8jf2zhoxyljy/IQlUxtmVqM/1dRseQyxfrgM4
        VxTO1x59F2EXAOKEsEfFuMuixY0pZRs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-BPiH-mYLMaC54QS5uai9sA-1; Thu, 01 Dec 2022 17:08:23 -0500
X-MC-Unique: BPiH-mYLMaC54QS5uai9sA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF82A1C06EE9;
        Thu,  1 Dec 2022 22:08:22 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64A8A477F55;
        Thu,  1 Dec 2022 22:08:21 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Vincent Fu <vincentfu@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH v2 09/10] engines/libblkio: Add options for some driver-specific properties
Date:   Thu,  1 Dec 2022 22:08:02 +0000
Message-Id: <20221201220803.52057-10-afaria@redhat.com>
In-Reply-To: <20221201220803.52057-1-afaria@redhat.com>
References: <20221201220803.52057-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The properties are either common to several drivers or particularly
relevant for benchmarking, so this should help write cleaner workload
files.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 HOWTO.rst                                 | 42 +++++++++++----
 engines/libblkio.c                        | 62 ++++++++++++++++++++++-
 examples/libblkio-io_uring.fio            |  4 +-
 examples/libblkio-virtio-blk-vfio-pci.fio |  9 ++--
 fio.1                                     | 36 +++++++++----
 5 files changed, 124 insertions(+), 29 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 1cea16c4..10e6bc79 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2869,23 +2869,45 @@ with the caveat that when used on the command line, they must come after the
 	libblkio version in use and are listed at
 	https://libblkio.gitlab.io/libblkio/blkio.html#drivers
 
+.. option:: libblkio_path=str : [libblkio]
+
+	Sets the value of the driver-specific "path" property before connecting
+	the libblkio instance, which identifies the target device or file on
+	which to perform I/O. Its exact semantics are driver-dependent and not
+	all drivers may support it; see
+	https://libblkio.gitlab.io/libblkio/blkio.html#drivers
+
 .. option:: libblkio_pre_connect_props=str : [libblkio]
 
-	A colon-separated list of libblkio properties to be set after creating
-	but before connecting the libblkio instance. Each property must have the
-	format ``<name>=<value>``. Colons can be escaped as ``\:``. These are
-	set after the engine sets any other properties, so those can be
-	overriden. Available properties depend on the libblkio version in use
+	A colon-separated list of additional libblkio properties to be set after
+	creating but before connecting the libblkio instance. Each property must
+	have the format ``<name>=<value>``. Colons can be escaped as ``\:``.
+	These are set after the engine sets any other properties, so those can
+	be overriden. Available properties depend on the libblkio version in use
 	and are listed at
 	https://libblkio.gitlab.io/libblkio/blkio.html#properties
 
+.. option:: libblkio_num_entries=int : [libblkio]
+
+	Sets the value of the driver-specific "num-entries" property before
+	starting the libblkio instance. Its exact semantics are driver-dependent
+	and not all drivers may support it; see
+	https://libblkio.gitlab.io/libblkio/blkio.html#drivers
+
+.. option:: libblkio_queue_size=int : [libblkio]
+
+	Sets the value of the driver-specific "queue-size" property before
+	starting the libblkio instance. Its exact semantics are driver-dependent
+	and not all drivers may support it; see
+	https://libblkio.gitlab.io/libblkio/blkio.html#drivers
+
 .. option:: libblkio_pre_start_props=str : [libblkio]
 
-	A colon-separated list of libblkio properties to be set after connecting
-	but before starting the libblkio instance. Each property must have the
-	format ``<name>=<value>``. Colons can be escaped as ``\:``. These are
-	set after the engine sets any other properties, so those can be
-	overriden. Available properties depend on the libblkio version in use
+	A colon-separated list of additional libblkio properties to be set after
+	connecting but before starting the libblkio instance. Each property must
+	have the format ``<name>=<value>``. Colons can be escaped as ``\:``.
+	These are set after the engine sets any other properties, so those can
+	be overriden. Available properties depend on the libblkio version in use
 	and are listed at
 	https://libblkio.gitlab.io/libblkio/blkio.html#properties
 
diff --git a/engines/libblkio.c b/engines/libblkio.c
index 7f5dcf36..fc4e3f8a 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -43,7 +43,12 @@ struct fio_blkio_options {
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
@@ -63,18 +68,49 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBBLKIO,
 	},
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
@@ -245,6 +281,13 @@ static int fio_blkio_create_and_connect(struct thread_data *td,
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
@@ -254,6 +297,21 @@ static int fio_blkio_create_and_connect(struct thread_data *td,
 		goto err_blkio_destroy;
 	}
 
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
index 655a0b50..3485b97e 100644
--- a/examples/libblkio-io_uring.fio
+++ b/examples/libblkio-io_uring.fio
@@ -1,14 +1,14 @@
 ; Benchmark accessing a regular file or block device using libblkio.
 ;
 ; Replace "/dev/nvme0n1" below with the path to your file or device, or override
-; it by passing the '--libblkio_pre_connect_props=path=...' flag to fio.
+; it by passing the '--libblkio_path=...' flag to fio.
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
index 425df4a6..6bed664b 100644
--- a/examples/libblkio-virtio-blk-vfio-pci.fio
+++ b/examples/libblkio-virtio-blk-vfio-pci.fio
@@ -1,16 +1,15 @@
 ; Benchmark accessing a PCI virtio-blk device using libblkio.
 ;
-; Replace "/sys/bus/pci/devices/0000\:00\:01.0" below with the path to your
-; device's sysfs directory, or override it by passing the
-; '--libblkio_pre_connect_props=path=...' flag to fio. Note that colons in the
-; path must be escaped with a backslash.
+; Replace "/sys/bus/pci/devices/0000:00:01.0" below with the path to your
+; device's sysfs directory, or override it by passing the '--libblkio_path=...'
+; flag to fio.
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
index da548303..6f7a608d 100644
--- a/fio.1
+++ b/fio.1
@@ -2616,20 +2616,36 @@ The libblkio driver to use. Different drivers access devices through different
 underlying interfaces. Available drivers depend on the libblkio version in use
 and are listed at \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#drivers\fR
 .TP
+.BI (libblkio)libblkio_path \fR=\fPstr
+Sets the value of the driver-specific "path" property before connecting the
+libblkio instance, which identifies the target device or file on which to
+perform I/O. Its exact semantics are driver-dependent and not all drivers may
+support it; see \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#drivers\fR
+.TP
 .BI (libblkio)libblkio_pre_connect_props \fR=\fPstr
-A colon-separated list of libblkio properties to be set after creating but
-before connecting the libblkio instance. Each property must have the format
-\fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are set after
-the engine sets any other properties, so those can be overriden. Available
-properties depend on the libblkio version in use and are listed at
+A colon-separated list of additional libblkio properties to be set after
+creating but before connecting the libblkio instance. Each property must have
+the format \fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are
+set after the engine sets any other properties, so those can be overriden.
+Available properties depend on the libblkio version in use and are listed at
 \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#properties\fR
 .TP
+.BI (libblkio)libblkio_num_entries \fR=\fPint
+Sets the value of the driver-specific "num-entries" property before starting the
+libblkio instance. Its exact semantics are driver-dependent and not all drivers
+may support it; see \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#drivers\fR
+.TP
+.BI (libblkio)libblkio_queue_size \fR=\fPint
+Sets the value of the driver-specific "queue-size" property before starting the
+libblkio instance. Its exact semantics are driver-dependent and not all drivers
+may support it; see \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#drivers\fR
+.TP
 .BI (libblkio)libblkio_pre_start_props \fR=\fPstr
-A colon-separated list of libblkio properties to be set after connecting but
-before starting the libblkio instance. Each property must have the format
-\fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are set after
-the engine sets any other properties, so those can be overriden. Available
-properties depend on the libblkio version in use and are listed at
+A colon-separated list of additional libblkio properties to be set after
+connecting but before starting the libblkio instance. Each property must have
+the format \fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are
+set after the engine sets any other properties, so those can be overriden.
+Available properties depend on the libblkio version in use and are listed at
 \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#properties\fR
 .TP
 .BI (libblkio)hipri
-- 
2.38.1

