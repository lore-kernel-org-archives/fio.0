Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CFFC433F5
	for <fio@archiver.kernel.org>; Mon, 10 Jan 2022 13:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbiAJNCL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 10 Jan 2022 08:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbiAJNA7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 10 Jan 2022 08:00:59 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88CBC061757
        for <fio@vger.kernel.org>; Mon, 10 Jan 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=C9MzWbtA7mocsx0c02Lvx5fr6PrKOIOYebiE0l2uWbY=; b=f8xFqXaoNB30PHaMzpCF/o+4eK
        MParkIyzrsKYWVB1ozj5llAci6hxs4IYblPSOHVpUrLqolVBYtxjBrDaDozj8DHrNRn1BE8/fxBOg
        ZaHn19ggYPED5qswarUcSRfewaID+ehlWA//FykFxNQzcZrbelqPoGj3ltfz6N6TO/HBB/mwGX43B
        4gwKdzWKwwAPrbsuisrJqE6xXLpOMp6sB62ARAWaAWs/F1lGR1EIDejq1Zz5l2c9wteqk3LMRC1Bi
        nwbE3OhiAPcT63nfnuVaThuS9Slte1UuvfrJSC083STn9y/e3Fpx/4W6mqUdI7Zy2wqlhigGEnffU
        q6Nh0URQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n6uHM-000Oqy-Uh
        for fio@vger.kernel.org; Mon, 10 Jan 2022 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id E91AC1BC017A; Mon, 10 Jan 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220110130001.E91AC1BC017A@kernel.dk>
Date:   Mon, 10 Jan 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit a3e33e2fc06582e4170f90ae6e62d6225d52dc7c:

  Merge branch 'github-actions-i686' of https://github.com/vincentkfu/fio (2021-12-23 16:27:33 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b5e99df6ec605b4dc6a3488203f32d5c5bfce8df:

  engines/io_uring: don't set CQSIZE clamp unconditionally (2022-01-09 19:34:27 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      engines/io_uring: don't set CQSIZE clamp unconditionally

 engines/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 00ae3482..a2533c88 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -699,9 +699,15 @@ static int fio_ioring_queue_init(struct thread_data *td)
 	p.flags |= IORING_SETUP_CQSIZE;
 	p.cq_entries = depth;
 
+retry:
 	ret = syscall(__NR_io_uring_setup, depth, &p);
-	if (ret < 0)
+	if (ret < 0) {
+		if (errno == EINVAL && p.flags & IORING_SETUP_CQSIZE) {
+			p.flags &= ~IORING_SETUP_CQSIZE;
+			goto retry;
+		}
 		return ret;
+	}
 
 	ld->ring_fd = ret;
 
