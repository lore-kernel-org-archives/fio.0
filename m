Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BC8ECDFA1
	for <fio@archiver.kernel.org>; Wed, 26 Oct 2022 19:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbiJZTj0 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234763AbiJZTjX (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Oct 2022 15:39:23 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573DEA4877
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 12:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=jBQSrUgEcuMbM1qx2mfokToGPzPmTKbwkJ/VutyJXxw=; b=hh9PRGol3irMST4ObvFy53xh9g
        YRP7n7jtjECwSUlTwvIGvcyP5BqnseyOLaHvbDuMGIDAca8s9KOZb9ucqMYQ6STzt6eRFe312d5zb
        07xQkxauxK5GPLuOXnTkRL21Xz8863VR0ifK6jEn/u4myT8TuYmHY4tPs2Yz/c/JohQOhWDCpCWmR
        lS87tCRFAffLKpJh6Z+XGaUcy7J7hP2nTSbp25rJJQY0Zu7CBRcOCv4kruDFB/BDZZE9jNEwWY6lO
        1+v/lr95nJAM/SLLddNN7JNyY6nzxmpdk9a5RIF0+yU9wI7MaJRNGIBHS/c95SPjfLVHfv8CJ9kqZ
        OuMN/eJw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmFD-000HfT-8a; Wed, 26 Oct 2022 13:39:20 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmFA-0008UP-Hz; Wed, 26 Oct 2022 13:39:16 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 26 Oct 2022 13:38:56 -0600
Message-Id: <20221026193902.32571-4-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221026193902.32571-1-logang@deltatee.com>
References: <20221026193902.32571-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com, logang@deltatee.com, hch@lst.de
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v11 3/9] iov_iter: introduce iov_iter_get_pages_[alloc_]flags()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add iov_iter_get_pages_flags() and iov_iter_get_pages_alloc_flags()
which take a flags argument that is passed to get_user_pages_fast().

This is so that FOLL_PCI_P2PDMA can be passed when appropriate.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uio.h |  6 ++++++
 lib/iov_iter.c      | 32 ++++++++++++++++++++++++--------
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 2e3134b14ffd..9ede533ce64c 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -247,8 +247,14 @@ void iov_iter_pipe(struct iov_iter *i, unsigned int direction, struct pipe_inode
 void iov_iter_discard(struct iov_iter *i, unsigned int direction, size_t count);
 void iov_iter_xarray(struct iov_iter *i, unsigned int direction, struct xarray *xarray,
 		     loff_t start, size_t count);
+ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
+		size_t maxsize, unsigned maxpages, size_t *start,
+		unsigned gup_flags);
 ssize_t iov_iter_get_pages2(struct iov_iter *i, struct page **pages,
 			size_t maxsize, unsigned maxpages, size_t *start);
+ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
+		struct page ***pages, size_t maxsize, size_t *start,
+		unsigned gup_flags);
 ssize_t iov_iter_get_pages_alloc2(struct iov_iter *i, struct page ***pages,
 			size_t maxsize, size_t *start);
 int iov_iter_npages(const struct iov_iter *i, int maxpages);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index c3ca28ca68a6..53efad017f3c 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1430,7 +1430,8 @@ static struct page *first_bvec_segment(const struct iov_iter *i,
 
 static ssize_t __iov_iter_get_pages_alloc(struct iov_iter *i,
 		   struct page ***pages, size_t maxsize,
-		   unsigned int maxpages, size_t *start)
+		   unsigned int maxpages, size_t *start,
+		   unsigned int gup_flags)
 {
 	unsigned int n;
 
@@ -1442,7 +1443,6 @@ static ssize_t __iov_iter_get_pages_alloc(struct iov_iter *i,
 		maxsize = MAX_RW_COUNT;
 
 	if (likely(user_backed_iter(i))) {
-		unsigned int gup_flags = 0;
 		unsigned long addr;
 		int res;
 
@@ -1492,33 +1492,49 @@ static ssize_t __iov_iter_get_pages_alloc(struct iov_iter *i,
 	return -EFAULT;
 }
 
-ssize_t iov_iter_get_pages2(struct iov_iter *i,
+ssize_t iov_iter_get_pages(struct iov_iter *i,
 		   struct page **pages, size_t maxsize, unsigned maxpages,
-		   size_t *start)
+		   size_t *start, unsigned gup_flags)
 {
 	if (!maxpages)
 		return 0;
 	BUG_ON(!pages);
 
-	return __iov_iter_get_pages_alloc(i, &pages, maxsize, maxpages, start);
+	return __iov_iter_get_pages_alloc(i, &pages, maxsize, maxpages,
+					  start, gup_flags);
+}
+EXPORT_SYMBOL_GPL(iov_iter_get_pages);
+
+ssize_t iov_iter_get_pages2(struct iov_iter *i, struct page **pages,
+		size_t maxsize, unsigned maxpages, size_t *start)
+{
+	return iov_iter_get_pages(i, pages, maxsize, maxpages, start, 0);
 }
 EXPORT_SYMBOL(iov_iter_get_pages2);
 
-ssize_t iov_iter_get_pages_alloc2(struct iov_iter *i,
+ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 		   struct page ***pages, size_t maxsize,
-		   size_t *start)
+		   size_t *start, unsigned gup_flags)
 {
 	ssize_t len;
 
 	*pages = NULL;
 
-	len = __iov_iter_get_pages_alloc(i, pages, maxsize, ~0U, start);
+	len = __iov_iter_get_pages_alloc(i, pages, maxsize, ~0U, start,
+					 gup_flags);
 	if (len <= 0) {
 		kvfree(*pages);
 		*pages = NULL;
 	}
 	return len;
 }
+EXPORT_SYMBOL_GPL(iov_iter_get_pages_alloc);
+
+ssize_t iov_iter_get_pages_alloc2(struct iov_iter *i,
+		struct page ***pages, size_t maxsize, size_t *start)
+{
+	return iov_iter_get_pages_alloc(i, pages, maxsize, start, 0);
+}
 EXPORT_SYMBOL(iov_iter_get_pages_alloc2);
 
 size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum,
-- 
2.30.2

