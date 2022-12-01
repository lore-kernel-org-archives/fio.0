Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F0EDC4332F
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 22:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiLAWJh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiLAWJe (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 17:09:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE133D90B
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 14:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669932501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=32+JB6FTTPm7lZ4nidZ29ICUqkVp6MREL/WEprJlT8c=;
        b=Z5vEGQxUNqXatp0b3Dc2UHSFxAV0nuJAEpJ36+eHDvYU/2ihmGlWK3W/rPhsoZKhvWM/Ih
        /6Dy07RTwdiSHrZFGofXZAi48JH3gAsUQ1VhwdhUzp8D0VIPzajzLvUgLzuIS+CqhdtBjR
        YPSWB8zZPZZw9DpW7x96VCBoUC/mt70=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-ALD3Y_fAO9WzcR2_pE8fBA-1; Thu, 01 Dec 2022 17:08:18 -0500
X-MC-Unique: ALD3Y_fAO9WzcR2_pE8fBA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C216C85A5A6;
        Thu,  1 Dec 2022 22:08:17 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67EE8477F5E;
        Thu,  1 Dec 2022 22:08:16 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Vincent Fu <vincentfu@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH v2 06/10] engines/libblkio: Add option libblkio_write_zeroes_on_trim
Date:   Thu,  1 Dec 2022 22:07:59 +0000
Message-Id: <20221201220803.52057-7-afaria@redhat.com>
In-Reply-To: <20221201220803.52057-1-afaria@redhat.com>
References: <20221201220803.52057-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When set, trim IOs will be submitted as blkioq_write_zeroes() requests
instead of blkioq_discard() requests.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 HOWTO.rst          |  4 ++++
 engines/libblkio.c | 20 ++++++++++++++++++--
 fio.1              |  3 +++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index f77d76cc..273b7a68 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2891,6 +2891,10 @@ with the caveat that when used on the command line, they must come after the
 
 	Submit vectored read and write requests.
 
+.. option:: libblkio_write_zeroes_on_trim : [libblkio]
+
+	Submit trims as "write zeroes" requests instead of discard requests.
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/engines/libblkio.c b/engines/libblkio.c
index 219bb0dc..66a9bd31 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -41,6 +41,7 @@ struct fio_blkio_options {
 
 	unsigned int hipri;
 	unsigned int vectored;
+	unsigned int write_zeroes_on_trim;
 };
 
 static struct fio_option options[] = {
@@ -89,6 +90,16 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBBLKIO,
 	},
+	{
+		.name	= "libblkio_write_zeroes_on_trim",
+		.lname	= "Use blkioq_write_zeroes() for TRIM",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct fio_blkio_options,
+				   write_zeroes_on_trim),
+		.help	= "Use blkioq_write_zeroes() for TRIM instead of blkioq_discard()",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
 	{
 		.name = NULL,
 	},
@@ -455,8 +466,13 @@ static enum fio_q_status fio_blkio_queue(struct thread_data *td,
 			}
 			break;
 		case DDIR_TRIM:
-			blkioq_discard(data->q, io_u->offset, io_u->xfer_buflen,
-				       io_u, 0);
+			if (options->write_zeroes_on_trim) {
+				blkioq_write_zeroes(data->q, io_u->offset,
+						    io_u->xfer_buflen, io_u, 0);
+			} else {
+				blkioq_discard(data->q, io_u->offset,
+					       io_u->xfer_buflen, io_u, 0);
+			}
 		        break;
 		case DDIR_SYNC:
 		case DDIR_DATASYNC:
diff --git a/fio.1 b/fio.1
index 9b8995b5..ad061caa 100644
--- a/fio.1
+++ b/fio.1
@@ -2637,6 +2637,9 @@ Use poll queues.
 .TP
 .BI (libblkio)libblkio_vectored
 Submit vectored read and write requests.
+.TP
+.BI (libblkio)libblkio_write_zeroes_on_trim
+Submit trims as "write zeroes" requests instead of discard requests.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
-- 
2.38.1

