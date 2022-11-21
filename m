Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91E8C433FE
	for <fio@archiver.kernel.org>; Mon, 21 Nov 2022 18:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiKUSaM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Nov 2022 13:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKUSaL (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Nov 2022 13:30:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E918D0DD8
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 10:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669055351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyIM8JTOl13WjjSckqw0c+z8fG0NcnxHr7kI/fqt+v0=;
        b=KjrjJAlCVubKzIQ9yDLskV5CpqulG6eODqEQmNRvEL5BQU+9oltbcTRiheADh+dBDL7uGY
        KfKirLyJIbptBy1qFyeDYyHcLFAsVN6nA3FXkfyftejlIVk/X9RRepqJfMzF8bq0sbt05A
        8C9h+YbHeAoixV/eFTrhl5k1lrVF8e8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-qkbNLnT7PEOyybjIw4tadw-1; Mon, 21 Nov 2022 13:29:09 -0500
X-MC-Unique: qkbNLnT7PEOyybjIw4tadw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E07F3C0218D
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 18:29:09 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66942492B06;
        Mon, 21 Nov 2022 18:29:08 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH 03/10] engines/libblkio: Allow setting option mem/iomem
Date:   Mon, 21 Nov 2022 18:28:55 +0000
Message-Id: <20221121182902.373491-4-afaria@redhat.com>
In-Reply-To: <20221121182902.373491-1-afaria@redhat.com>
References: <20221121182902.373491-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This allows users to customize data buffer memory using fio's existing
options. Users become responsible for ensuring that the allocated memory
satisfies all constraints imposed by the libblkio driver under use.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 HOWTO.rst          |  5 ++++-
 engines/libblkio.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 fio.1              |  4 +++-
 3 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index d5a2749c..fb27d3d3 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2196,7 +2196,10 @@ I/O engine
 			Use the libblkio library
 			(https://gitlab.com/libblkio/libblkio). The specific
 			*driver* to use must be set using
-			:option:`libblkio_driver`.
+			:option:`libblkio_driver`. If
+			:option:`mem`/:option:`iomem` is not specified, memory
+			allocation is delegated to libblkio (and so is
+			guaranteed to work with the selected *driver*).
 
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/engines/libblkio.c b/engines/libblkio.c
index bd9a5c84..54fd9ff6 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -237,7 +237,7 @@ struct fio_blkio_data {
 	struct blkioq *q;
 
 	bool has_mem_region; /* whether mem_region is valid */
-	struct blkio_mem_region mem_region;
+	struct blkio_mem_region mem_region; /* only if allocated by libblkio */
 
 	struct blkio_completion *completions;
 };
@@ -292,6 +292,47 @@ err_free:
 	return 1;
 }
 
+static int fio_blkio_post_init(struct thread_data *td)
+{
+	struct fio_blkio_data *data = td->io_ops_data;
+
+	if (!data->has_mem_region) {
+		/*
+		 * Memory was allocated by the fio core and not iomem_alloc(),
+		 * so we need to register it as a memory region here.
+		 *
+		 * `td->orig_buffer_size` is computed like `len` below, but then
+		 * fio can add some padding to it to make sure it is
+		 * sufficiently aligned to the page size and the mem_align
+		 * option. However, this can make it become unaligned to the
+		 * "mem-region-alignment" property in ways that the user can't
+		 * control, so we essentially recompute `td->orig_buffer_size`
+		 * here but without adding that padding.
+		 */
+
+		unsigned long long max_block_size;
+		struct blkio_mem_region region;
+
+		max_block_size = max(td->o.max_bs[DDIR_READ],
+				     max(td->o.max_bs[DDIR_WRITE],
+					 td->o.max_bs[DDIR_TRIM]));
+
+		region = (struct blkio_mem_region) {
+			.addr	= td->orig_buffer,
+			.len	= (size_t)max_block_size *
+					(size_t)td->o.iodepth,
+			.fd	= -1,
+		};
+
+		if (blkio_map_mem_region(data->b, &region) != 0) {
+			fio_blkio_log_err(blkio_map_mem_region);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 static void fio_blkio_cleanup(struct thread_data *td)
 {
 	struct fio_blkio_data *data = td->io_ops_data;
@@ -433,10 +474,11 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.name			= "libblkio",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_DISKLESSIO | FIO_NOEXTEND |
-				  FIO_NO_OFFLOAD,
+				  FIO_NO_OFFLOAD | FIO_SKIPPABLE_IOMEM_ALLOC,
 
 	.setup			= fio_blkio_setup,
 	.init			= fio_blkio_init,
+	.post_init		= fio_blkio_post_init,
 	.cleanup		= fio_blkio_cleanup,
 
 	.iomem_alloc		= fio_blkio_iomem_alloc,
diff --git a/fio.1 b/fio.1
index 64a774f5..12eeb013 100644
--- a/fio.1
+++ b/fio.1
@@ -1992,7 +1992,9 @@ engine specific options. (See \fIhttps://xnvme.io/\fR).
 .TP
 .B libblkio
 Use the libblkio library (\fIhttps://gitlab.com/libblkio/libblkio\fR). The
-specific \fBdriver\fR to use must be set using \fBlibblkio_driver\fR.
+specific \fBdriver\fR to use must be set using \fBlibblkio_driver\fR. If
+\fBmem\fR/\fBiomem\fR is not specified, memory allocation is delegated to
+libblkio (and so is guaranteed to work with the selected \fBdriver\fR).
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
-- 
2.38.1

