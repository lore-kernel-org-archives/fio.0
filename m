Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC5A2C433FE
	for <fio@archiver.kernel.org>; Mon, 21 Nov 2022 18:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiKUSaU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Nov 2022 13:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiKUSaS (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Nov 2022 13:30:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EED4D06F9
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 10:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669055355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yYnpcvKeTPNG4ri9Jng/+A7aY3mW6UOEcPWMHJiJVMc=;
        b=Vs+RMehgYxR6k2EDCDBSAO/Dh3gJVL6VQzs9QTq8w6E3VuOP3LgfbwUCKPsmAkTJdK5BzG
        FDE99z0EPbOwumcke78Bc6VdSDPoUrkXI6pnAJayDF/jGV1kGTrZUABbyqXJ4VXizxO5el
        HpAKEEER711PvsgUpK3ohQnk7zgEBaI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-IVtaTJtQPoyb0NDu3Zl-qw-1; Mon, 21 Nov 2022 13:29:14 -0500
X-MC-Unique: IVtaTJtQPoyb0NDu3Zl-qw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E30A8833A06
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 18:29:13 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0B7A492B06;
        Mon, 21 Nov 2022 18:29:12 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH 06/10] engines/libblkio: Add option libblkio_write_zeroes_on_trim
Date:   Mon, 21 Nov 2022 18:28:58 +0000
Message-Id: <20221121182902.373491-7-afaria@redhat.com>
In-Reply-To: <20221121182902.373491-1-afaria@redhat.com>
References: <20221121182902.373491-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When set, trim IOs will be submitted as blkioq_write_zeroes() requests
instead of blkioq_discard() requests.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 HOWTO.rst          |  5 +++++
 engines/libblkio.c | 20 ++++++++++++++++++--
 fio.1              |  4 ++++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index b9c7c8df..7155add6 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2879,6 +2879,11 @@ with the caveat that when used on the command line, they must come after the
 
 	Submit vectored read and write requests. Default is 0.
 
+.. option:: libblkio_write_zeroes_on_trim=bool : [libblkio]
+
+	Submit trims as "write zeroes" requests instead of discard requests.
+	Default is 0.
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/engines/libblkio.c b/engines/libblkio.c
index dcf701ad..79af3aa7 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -29,6 +29,7 @@ struct fio_blkio_options {
 
 	unsigned int hipri;
 	unsigned int vectored;
+	unsigned int write_zeroes_on_trim;
 };
 
 static struct fio_option options[] = {
@@ -78,6 +79,16 @@ static struct fio_option options[] = {
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
@@ -484,8 +495,13 @@ static enum fio_q_status fio_blkio_queue(struct thread_data *td,
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
diff --git a/fio.1 b/fio.1
index a403b415..053c2eda 100644
--- a/fio.1
+++ b/fio.1
@@ -2626,6 +2626,10 @@ Use poll queues.
 .TP
 .BI (libblkio)libblkio_vectored \fR=\fPbool
 Submit vectored read and write requests. Default is 0.
+.TP
+.BI (libblkio)libblkio_write_zeroes_on_trim \fR=\fPbool
+Submit trims as "write zeroes" requests instead of discard requests. Default is
+0.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
-- 
2.38.1

