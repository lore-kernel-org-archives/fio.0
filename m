Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F51C433F5
	for <fio@archiver.kernel.org>; Wed,  6 Apr 2022 15:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbiDFP2a (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 6 Apr 2022 11:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235958AbiDFP2N (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Apr 2022 11:28:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9083857A0D9
        for <fio@vger.kernel.org>; Wed,  6 Apr 2022 05:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=PNoECjaZkma2XapxwQC25lHvv+/EbDpufKRTef+dUCg=; b=dV/ipoQ4pTGw8Byy8ZED6QCZtk
        k7RB0emn5DfHtVhug8miE2aQ0WP9PASnNf8ZYMZnZ8xMiKdbdgR58Ppj38XebOWr+FG8N+WK55Fml
        ef44QFwnMXAc4Q0tgabcbK7UGHBZLPkCu8PIQPdZgq5m9KlyOxO3WqUuDi9GGtKm8ahOhb2gz3NYG
        ynk4Rx636ceRQt/SeE/3hzF0jnp2ApTL1j7UKJhr068s8bLh5MRImcCTu1phFPyZTJRcgGUU/k/li
        Zhgh/R/eEr3Z/84Or/9TayQ/HNkPyqNQ4LkixfvJVu92DrZMir0KOQAOi+PJwMns78FWcon9M6Zu7
        KOMLjiqA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nc4KS-007mDX-3X
        for fio@vger.kernel.org; Wed, 06 Apr 2022 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 30BD21BC015E; Wed,  6 Apr 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220406120002.30BD21BC015E@kernel.dk>
Date:   Wed,  6 Apr 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 87933e32e356b15b85c6d9775d5e840994080a4f:

  Rename 'fallthrough' attribute to 'fio_fallthrough' (2022-03-30 17:31:36 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 06bbdc1cb857a11e6d1b7c089126397daca904fe:

  smalloc: fix ptr address in redzone error message (2022-04-05 11:47:35 -0600)

----------------------------------------------------------------
Vincent Fu (1):
      smalloc: fix ptr address in redzone error message

 smalloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/smalloc.c b/smalloc.c
index fa00f0ee..23243054 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -283,13 +283,13 @@ static void sfree_check_redzone(struct block_hdr *hdr)
 	if (hdr->prered != SMALLOC_PRE_RED) {
 		log_err("smalloc pre redzone destroyed!\n"
 			" ptr=%p, prered=%x, expected %x\n",
-				hdr, hdr->prered, SMALLOC_PRE_RED);
+				hdr+1, hdr->prered, SMALLOC_PRE_RED);
 		assert(0);
 	}
 	if (*postred != SMALLOC_POST_RED) {
 		log_err("smalloc post redzone destroyed!\n"
 			"  ptr=%p, postred=%x, expected %x\n",
-				hdr, *postred, SMALLOC_POST_RED);
+				hdr+1, *postred, SMALLOC_POST_RED);
 		assert(0);
 	}
 }
