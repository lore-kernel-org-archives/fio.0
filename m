Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB6BC433F5
	for <fio@archiver.kernel.org>; Sat, 12 Mar 2022 13:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbiCLNBO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 12 Mar 2022 08:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiCLNBO (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 12 Mar 2022 08:01:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8ED922FDBE
        for <fio@vger.kernel.org>; Sat, 12 Mar 2022 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=kikT9PxpnTdt0Tuy1oSLHr7GxgJ95oIpVKb9KXDDvOc=; b=A6nPFFwyK6S3yuTbjdKjvnhutA
        yMIvpxJ88GYBM3Hz150Se2tbLv/PwRloVCpj9v+MvQgicol5DPhGKCzcHx67w6m8r6lUTefHJnmr+
        IGW0Ysw6fIOiaToP+NFT/aSnD7EsLDLVyWCmTTSAERJEJj39yW9CCtd4U5+8OlIIvWARbiZiyFxHL
        CIbvLoN0X+wgXGpvkM9emuUhDBj/on4zUVZvEzQoMsXnjUA0oT7k9WAKMcYWxzqh23KYVCbkWO5j/
        8nZCi+mwmuC9O2L3Jscgeq7eLzRAw7iOIfHF5xjMcLMRqlnzWHYYVxVcPs9J83S5FX+Gl+S7CdjES
        YsfIWfGg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nT1Lp-002QSe-Gi
        for fio@vger.kernel.org; Sat, 12 Mar 2022 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id B94FC1BC0141; Sat, 12 Mar 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220312130001.B94FC1BC0141@kernel.dk>
Date:   Sat, 12 Mar 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 16b1e24562347d371d6d62e0bb9a03ad4e2a8a96:

  t/dedupe: handle errors more gracefully (2022-03-11 05:09:20 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1fe261a24794f60bf374cd1852e09ec56997a20a:

  t/dedupe: ensure that 'ret' is initialized (2022-03-11 06:15:53 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      t/dedupe: ensure that 'ret' is initialized

 t/dedupe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/t/dedupe.c b/t/dedupe.c
index 561aa08d..d21e96f4 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -280,7 +280,7 @@ static int insert_chunks(struct item *items, unsigned int nitems,
 			 uint64_t *ndupes, uint64_t *unique_capacity,
 			 struct zlib_ctrl *zc)
 {
-	int i, ret;
+	int i, ret = 0;
 
 	fio_sem_down(rb_lock);
 
