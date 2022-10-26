Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F2CFA3744
	for <fio@archiver.kernel.org>; Wed, 26 Oct 2022 19:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbiJZTj3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234924AbiJZTjX (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Oct 2022 15:39:23 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5853FA4BB3
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 12:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=89QTElwZFXRfggrOmp22BVYbNApHwJCc7/AtxsSaqyQ=; b=BKBAE+/espiVTYbdIDYi7jxont
        oi+2tSnLWNiJjICgnDvK+jFYFxOBLFuTHXnUBQ8pQyyYlTYraWLTOCKq91O3BdDauh4plxZ0GolJQ
        DlMJzXhr0blFGOMUaDfxBJMsrINS1IoPt6a7iU2dZ8nPbRSlWZ81xoJt7lSc6ez538IX1vQx7Pdry
        K5p+v1xyA7Wp50MhjUA56sRXex8GMJxDbHzXVmdDPqxMtklWMVOX/kHJCGs7PITsa76ZSTGakDyXd
        b1boZRdlY0UxP6Li2NIe7b7U+bhpFcLd96c5oMAJkt7njrFUbAnjb2JNSm4HR/CVg1oNIU7iqY6UL
        6+gptl2g==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmFD-000HfR-Ld; Wed, 26 Oct 2022 13:39:20 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmFB-0008Ub-1r; Wed, 26 Oct 2022 13:39:17 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>,
        John Hubbard <jhubbard@nvidia.com>
Date:   Wed, 26 Oct 2022 13:39:00 -0600
Message-Id: <20221026193902.32571-8-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221026193902.32571-1-logang@deltatee.com>
References: <20221026193902.32571-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com, logang@deltatee.com, hch@lst.de, jhubbard@nvidia.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v11 7/9] block: set FOLL_PCI_P2PDMA in bio_map_user_iov()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When a bio's queue supports PCI P2PDMA, set FOLL_PCI_P2PDMA for
iov_iter_get_pages_flags(). This allows PCI P2PDMA pages to be
passed from userspace and enables the NVMe passthru requests to
use P2PDMA pages.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
---
 block/blk-map.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 34735626b00f..8750f82d7da4 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -267,6 +267,7 @@ static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
 {
 	unsigned int max_sectors = queue_max_hw_sectors(rq->q);
 	unsigned int nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS);
+	unsigned int gup_flags = 0;
 	struct bio *bio;
 	int ret;
 	int j;
@@ -278,6 +279,9 @@ static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
 	if (bio == NULL)
 		return -ENOMEM;
 
+	if (blk_queue_pci_p2pdma(rq->q))
+		gup_flags |= FOLL_PCI_P2PDMA;
+
 	while (iov_iter_count(iter)) {
 		struct page **pages, *stack_pages[UIO_FASTIOV];
 		ssize_t bytes;
@@ -286,11 +290,11 @@ static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
 
 		if (nr_vecs <= ARRAY_SIZE(stack_pages)) {
 			pages = stack_pages;
-			bytes = iov_iter_get_pages2(iter, pages, LONG_MAX,
-							nr_vecs, &offs);
+			bytes = iov_iter_get_pages(iter, pages, LONG_MAX,
+						   nr_vecs, &offs, gup_flags);
 		} else {
-			bytes = iov_iter_get_pages_alloc2(iter, &pages,
-							LONG_MAX, &offs);
+			bytes = iov_iter_get_pages_alloc(iter, &pages,
+						LONG_MAX, &offs, gup_flags);
 		}
 		if (unlikely(bytes <= 0)) {
 			ret = bytes ? bytes : -EFAULT;
-- 
2.30.2

