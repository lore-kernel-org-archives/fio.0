Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8B9EB64DD
	for <fio@archiver.kernel.org>; Sun, 16 Jul 2023 12:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjGPMAO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 16 Jul 2023 08:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjGPMAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 16 Jul 2023 08:00:13 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7C2191
        for <fio@vger.kernel.org>; Sun, 16 Jul 2023 05:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=cI47/DMLuo2YqP4ggySojBfTwykoi0fQwIFOyMrQLxc=; b=qf9asPXk1+RRPxao2JJyKYvGVa
        tU14sFy931bpWuJLUrb8pj33v4pyohtlHUkKtOq1M2fFq5SEQ5NuT6DI0V0wP4D/DvSYZ/aTnbCHM
        4M0AC3fB83oEtPGXvJ6DUGBVI88P2bufmzT0Wof6LX0Q/ad/TxYksCrRCkh+uNAdbHOPuDz/4Y1Tr
        2jRQz+n7zPse7L37Fthm55AJwGLoAsHfnm1H0LQNdqO/bsAhX+yCZm/M5Qe9sqUirYKJBSh9Mv2zr
        zePa42XWMGnaQMKDgO7hGTQyg8YqWvvx80VraKu4Zx1OKbCBwJluwyw5ypb++UGClss+fW7D8Pnvt
        9VBZZhTw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qL0Q5-008Mcx-1y
        for fio@vger.kernel.org;
        Sun, 16 Jul 2023 12:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id C9DCA1BC0155; Sun, 16 Jul 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230716120001.C9DCA1BC0155@kernel.dk>
Date:   Sun, 16 Jul 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 14adf6e31487aa2bc8e47cd037428036089a3834:

  thinktime: Avoid calculating a negative time left to wait (2023-07-14 14:03:34 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 04361e9a23d6e0448fd6fbbd4e14ecdfff60e314:

  Merge branch 'patch-3' of https://github.com/yangjueji/fio (2023-07-15 09:57:43 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'patch-3' of https://github.com/yangjueji/fio

Jueji Yang (1):
      fix: io_uring sqpoll issue_time empty when kernel not yet read sq

 engines/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 407d65ce..f30a3c00 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -646,7 +646,7 @@ static int fio_ioring_commit(struct thread_data *td)
 	 */
 	if (o->sqpoll_thread) {
 		struct io_sq_ring *ring = &ld->sq_ring;
-		unsigned start = *ld->sq_ring.head;
+		unsigned start = *ld->sq_ring.tail - ld->queued;
 		unsigned flags;
 
 		flags = atomic_load_acquire(ring->flags);
