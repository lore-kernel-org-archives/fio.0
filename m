Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8CBC25B48
	for <fio@archiver.kernel.org>; Thu, 26 Oct 2023 12:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjJZMAP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 26 Oct 2023 08:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjJZMAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 Oct 2023 08:00:14 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E36B91
        for <fio@vger.kernel.org>; Thu, 26 Oct 2023 05:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=EBO54cbYOqmYXlHQuDdvDe8fxf2DMbaJ65Vd117mlDI=; b=NeJCrVlKV1IajhLC3Z4xQBg8nn
        cmzkIJ7ntShyMYIIaJeJVMBN3rcugwGzcovlcO9vJ6B2CXbJlSIjzbLmllRIjLum7JdqqHFWlA3E+
        vvB50keifOa0WxAIyLQao/qkfPJH4jyxo0fCe97wGpaXXIN9y+kmNS/HqJSseW69BTR/+y47OETEI
        778C5OMYuh3pphM5j8sv4Ab+9DtH8YBBUDbfLxJl6bSBHYXQyiXeIi2tI8xQ6MtomLPKAn2/qpk3x
        2e9gCOTfN4i7dmlEaNWpm8U5DrUgxvWaXTk9v+9QLqFFwtjejOxbkwwQ6Awzp7pR/CNuXn+4KJP7f
        RqtG9Apw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qvz22-00HHEI-2T
        for fio@vger.kernel.org;
        Thu, 26 Oct 2023 12:00:11 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 2DD101BC016F; Thu, 26 Oct 2023 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231026120002.2DD101BC016F@kernel.dk>
Date:   Thu, 26 Oct 2023 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c11e22e92f3796f21eb15eb6ddc1614d9fa4f99d:

  Merge branch 'spellingfixes-2023-10-23' of https://github.com/proact-de/fio (2023-10-23 08:32:46 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7a725c78547f7337dddb6fd391f80914f671e583:

  Merge branch 'englist' of https://github.com/vt-alt/fio (2023-10-25 17:53:40 -0400)

----------------------------------------------------------------
Vincent Fu (2):
      engines/io_uring_cmd: allocate enough ranges for async trims
      Merge branch 'englist' of https://github.com/vt-alt/fio

Vitaly Chikunov (1):
      nfs: Fix incorrect engine registering for '--enghelp' list

 engines/io_uring.c | 2 +-
 engines/nfs.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 05703df8..38c36fdc 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1196,7 +1196,7 @@ static int fio_ioring_init(struct thread_data *td)
 	    td->o.zone_mode == ZONE_MODE_ZBD)
 		td->io_ops->flags |= FIO_ASYNCIO_SYNC_TRIM;
 	else
-		ld->dsm = calloc(ld->iodepth, sizeof(*ld->dsm));
+		ld->dsm = calloc(td->o.iodepth, sizeof(*ld->dsm));
 
 	return 0;
 }
diff --git a/engines/nfs.c b/engines/nfs.c
index 970962a3..ce748d14 100644
--- a/engines/nfs.c
+++ b/engines/nfs.c
@@ -308,7 +308,7 @@ static int fio_libnfs_close(struct thread_data *td, struct fio_file *f)
 	return ret;
 }
 
-struct ioengine_ops ioengine = {
+static struct ioengine_ops ioengine = {
 	.name		= "nfs",
 	.version	= FIO_IOOPS_VERSION,
 	.setup		= fio_libnfs_setup,
