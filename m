Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D17B2C433FE
	for <fio@archiver.kernel.org>; Wed, 26 Oct 2022 19:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbiJZTjZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbiJZTjX (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Oct 2022 15:39:23 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8CCA484B
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 12:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=eODUXFVF5uLMTvvIBzODsepVghJsXdNa3rItqm1oDO8=; b=QHL9uO/wig9ic5SGOGPfh06oc+
        5lmmBSbhqPXRPKndPNrrFddik9sEHp8FwEHkA7MQsxyNvOEmeCZVpRfZjib6hMtqNOyfhm6IMBDqB
        6p4/nWU1ycVlAkGk0ZkJRCLRoMj0FXQdG7tqeGvJPewhE0go5tLdJWlqPiBLCIgaz+FSQ/xQgPFpF
        BEUyeHScHCi3Z3HfD2CSWd+t6XWMK0hnqFBmZswxhrpXY93rkJ7Kt7EDJsuMXnwpel7A9hoEKiKi6
        uaJOVOc5L8MjsXehsLCH0C+c5M9YZCFmN8gCpmG55MS3AYwB4T7C7fz+3Y0wJoZ1LLUyZutrnv0/4
        hc8S2ofw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmFD-000HfU-8b; Wed, 26 Oct 2022 13:39:20 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmFA-0008US-Lz; Wed, 26 Oct 2022 13:39:16 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>,
        John Hubbard <jhubbard@nvidia.com>
Date:   Wed, 26 Oct 2022 13:38:57 -0600
Message-Id: <20221026193902.32571-5-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221026193902.32571-1-logang@deltatee.com>
References: <20221026193902.32571-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com, logang@deltatee.com, hch@lst.de, jhubbard@nvidia.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v11 4/9] block: add check when merging zone device pages
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Consecutive zone device pages should not be merged into the same sgl
or bvec segment with other types of pages or if they belong to different
pgmaps. Otherwise getting the pgmap of a given segment is not possible
without scanning the entire segment. This helper returns true either if
both pages are not zone device pages or both pages are zone device
pages with the same pgmap.

Add a helper to determine if zone device pages are mergeable and use
this helper in page_is_mergeable().

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
---
 block/bio.c            |  2 ++
 include/linux/mmzone.h | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 633a902468ec..439469370b7c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -863,6 +863,8 @@ static inline bool page_is_mergeable(const struct bio_vec *bv,
 		return false;
 	if (xen_domain() && !xen_biovec_phys_mergeable(bv, page))
 		return false;
+	if (!zone_device_pages_have_same_pgmap(bv->bv_page, page))
+		return false;
 
 	*same_page = ((vec_end_addr & PAGE_MASK) == page_addr);
 	if (*same_page)
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 5f74891556f3..9c49ec5d0e25 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -986,6 +986,25 @@ static inline bool is_zone_device_page(const struct page *page)
 {
 	return page_zonenum(page) == ZONE_DEVICE;
 }
+
+/*
+ * Consecutive zone device pages should not be merged into the same sgl
+ * or bvec segment with other types of pages or if they belong to different
+ * pgmaps. Otherwise getting the pgmap of a given segment is not possible
+ * without scanning the entire segment. This helper returns true either if
+ * both pages are not zone device pages or both pages are zone device pages
+ * with the same pgmap.
+ */
+static inline bool zone_device_pages_have_same_pgmap(const struct page *a,
+						     const struct page *b)
+{
+	if (is_zone_device_page(a) != is_zone_device_page(b))
+		return false;
+	if (!is_zone_device_page(a))
+		return true;
+	return a->pgmap == b->pgmap;
+}
+
 extern void memmap_init_zone_device(struct zone *, unsigned long,
 				    unsigned long, struct dev_pagemap *);
 #else
@@ -993,6 +1012,11 @@ static inline bool is_zone_device_page(const struct page *page)
 {
 	return false;
 }
+static inline bool zone_device_pages_have_same_pgmap(const struct page *a,
+						     const struct page *b)
+{
+	return true;
+}
 #endif
 
 static inline bool folio_is_zone_device(const struct folio *folio)
-- 
2.30.2

