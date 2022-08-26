Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F2CECAAD4
	for <fio@archiver.kernel.org>; Fri, 26 Aug 2022 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237428AbiHZMAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 26 Aug 2022 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbiHZMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Aug 2022 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04264E00B
        for <fio@vger.kernel.org>; Fri, 26 Aug 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=ZHlLkeW+OoKPHUPL9KTTVa7QiLT3gRwLoId4BYQ37Sw=; b=ok7gwfVCRSkL4Tv40EfPPBDPDd
        VJJvrSfSjOGVZYh0oxOSVgWbGo6hwQKMXlmkypy3ZO4S6YwmkZV0W28OokNJ0qL/3xlIOso8h//rQ
        WyuUsEVuiX+d2ZGHu4Np2hIOz5LSjL39FLA8t51rSqOjiNqdRX2dKYw7eqiYLG/AIk22XbXfEAHTD
        AxGRWfOVk2zUiRa1hCH8qSwTL1IB1jFidd5dEIuNfdmc7HKOYbvlQTLdEmpkqtzgLFuBmHX1yaEtK
        5EzVXLpHovbvhYMtzLNm9HzN2x9o9CGQUCH297HMxYXdTM9MeJSbuxKVrAoSNasBIiKR1ZDUPsQeJ
        zMUheZnA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oRY0L-000Vzz-9a
        for fio@vger.kernel.org; Fri, 26 Aug 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 6527E1BC0142; Fri, 26 Aug 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220826120002.6527E1BC0142@kernel.dk>
Date:   Fri, 26 Aug 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 05ef0e4e822ffa81d6e92ed538d32cc37a907279:

  Merge branch 'master' of https://github.com/kraj/fio (2022-08-24 20:09:29 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c27ae7ae6c3d9108bba80ff71cf36bf7fc8b34c9:

  engines/io_uring: delete debug code (2022-08-25 11:19:34 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      engines/io_uring: delete debug code

 engines/io_uring.c | 6 ------
 1 file changed, 6 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 89d64b06..94376efa 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -445,18 +445,12 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 	struct io_uring_cqe *cqe;
 	struct io_u *io_u;
 	unsigned index;
-	static int eio;
 
 	index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
 
 	cqe = &ld->cq_ring.cqes[index];
 	io_u = (struct io_u *) (uintptr_t) cqe->user_data;
 
-	if (eio++ == 5) {
-		printf("mark EIO\n");
-		cqe->res = -EIO;
-	}
-
 	if (cqe->res != io_u->xfer_buflen) {
 		if (cqe->res > io_u->xfer_buflen)
 			io_u->error = -cqe->res;
