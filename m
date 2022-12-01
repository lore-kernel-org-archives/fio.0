Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C2AEC4332F
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 22:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiLAWJT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiLAWJR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 17:09:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCFE2B1B3
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 14:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669932496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TeWx9yt+iARtf0yJ7iB32ri3xq3gAehkyxw5IZoQbxk=;
        b=H/dyGKZOU6BiDY3y1m2vjZ+EwGb7cLY1N3JIGiCOKSQoW0umxRlxi45B5Vzu83PJ2XLEAa
        N+gUUXOU5OQdNzyahcwEb9OkhsZUcFex9Hm7vm2dpeCnpa5dm0FITycpYJSo8fO+yJDfwh
        9egWfHVkmNj9JVaKucW0bqGMzafYlD8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-ih028NLxPriVcWUSKNS1aQ-1; Thu, 01 Dec 2022 17:08:13 -0500
X-MC-Unique: ih028NLxPriVcWUSKNS1aQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA75B381079B;
        Thu,  1 Dec 2022 22:08:12 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6173C477F55;
        Thu,  1 Dec 2022 22:08:11 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Vincent Fu <vincentfu@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH v2 03/10] engines/libblkio: Allow setting option mem/iomem
Date:   Thu,  1 Dec 2022 22:07:56 +0000
Message-Id: <20221201220803.52057-4-afaria@redhat.com>
In-Reply-To: <20221201220803.52057-1-afaria@redhat.com>
References: <20221201220803.52057-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
index 08140165..69ca1e79 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2199,7 +2199,10 @@ I/O engine
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
index 7a5d4271..11f45e2a 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -26,7 +26,7 @@ struct fio_blkio_data {
 	struct blkioq *q;
 
 	bool has_mem_region; /* whether mem_region is valid */
-	struct blkio_mem_region mem_region;
+	struct blkio_mem_region mem_region; /* only if allocated by libblkio */
 
 	struct blkio_completion *completions;
 };
@@ -271,6 +271,47 @@ err_free:
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
@@ -403,10 +444,11 @@ FIO_STATIC struct ioengine_ops ioengine = {
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
index 3615f258..18428774 100644
--- a/fio.1
+++ b/fio.1
@@ -1995,7 +1995,9 @@ engine specific options. (See \fIhttps://xnvme.io/\fR).
 .TP
 .B libblkio
 Use the libblkio library (\fIhttps://gitlab.com/libblkio/libblkio\fR). The
-specific driver to use must be set using \fBlibblkio_driver\fR.
+specific driver to use must be set using \fBlibblkio_driver\fR. If
+\fBmem\fR/\fBiomem\fR is not specified, memory allocation is delegated to
+libblkio (and so is guaranteed to work with the selected driver).
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
-- 
2.38.1

