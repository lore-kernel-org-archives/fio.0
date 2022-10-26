Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55218FA3742
	for <fio@archiver.kernel.org>; Wed, 26 Oct 2022 19:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbiJZTj2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbiJZTjX (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Oct 2022 15:39:23 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B55980EB9
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 12:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=ZKzeHAseABZVh8sd+FhS8dmH5rKh2MAqOmNnK2azrFk=; b=nYtIjEx6jaSnDrrkHr6UplS+Nx
        YlOPqWyTmdl9lIrz6nrjbCRwWf201zKe64UCxP/OtGQWNvOHs2xSRps6HO12FF1YwiDpzr0q5HWL8
        FkssQIzu88XaladZCkuE6/aEdVf0LTQ06jG1cczIYELZ1qG1ronTHrG+na1a0bhXQCpMVBV+xB7XM
        bW5oZLzl6MCFwd4iFSAyPb7ZKX8HqG75YDM6yXC3/OI7dhYSeJHAGyEp3dpemsN2/B2gvroFTAfeq
        LkJXCCZSdAXZUY1eU6ViEWxmk3aaWR1zgyo524Y8YcOfR0jz11oSKT6FV5Ncrn/ZoJTjZdOTNGr0z
        mGfiDaBQ==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmFC-000HfR-2l; Wed, 26 Oct 2022 13:39:19 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmFA-0008UJ-9J; Wed, 26 Oct 2022 13:39:16 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Wed, 26 Oct 2022 13:38:54 -0600
Message-Id: <20221026193902.32571-2-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221026193902.32571-1-logang@deltatee.com>
References: <20221026193902.32571-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v11 1/9] mm: allow multiple error returns in try_grab_page()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

In order to add checks for P2PDMA memory into try_grab_page(), expand
the error return from a bool to an int/error code. Update all the
callsites handle change in usage.

Also remove the WARN_ON_ONCE() call at the callsites seeing there
already is a WARN_ON_ONCE() inside the function if it fails.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 include/linux/mm.h |  2 +-
 mm/gup.c           | 26 ++++++++++++++------------
 mm/huge_memory.c   | 19 +++++++++++++------
 mm/hugetlb.c       | 17 +++++++++--------
 4 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8bbcccbc5565..62a91dc1272b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1129,7 +1129,7 @@ static inline void get_page(struct page *page)
 	folio_get(page_folio(page));
 }
 
-bool __must_check try_grab_page(struct page *page, unsigned int flags);
+int __must_check try_grab_page(struct page *page, unsigned int flags);
 
 static inline __must_check bool try_get_page(struct page *page)
 {
diff --git a/mm/gup.c b/mm/gup.c
index fe195d47de74..e2f447446384 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -202,17 +202,19 @@ static void gup_put_folio(struct folio *folio, int refs, unsigned int flags)
  * time. Cases: please see the try_grab_folio() documentation, with
  * "refs=1".
  *
- * Return: true for success, or if no action was required (if neither FOLL_PIN
- * nor FOLL_GET was set, nothing is done). False for failure: FOLL_GET or
- * FOLL_PIN was set, but the page could not be grabbed.
+ * Return: 0 for success, or if no action was required (if neither FOLL_PIN
+ * nor FOLL_GET was set, nothing is done). A negative error code for failure:
+ *
+ *   -ENOMEM		FOLL_GET or FOLL_PIN was set, but the page could not
+ *			be grabbed.
  */
-bool __must_check try_grab_page(struct page *page, unsigned int flags)
+int __must_check try_grab_page(struct page *page, unsigned int flags)
 {
 	struct folio *folio = page_folio(page);
 
 	WARN_ON_ONCE((flags & (FOLL_GET | FOLL_PIN)) == (FOLL_GET | FOLL_PIN));
 	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
-		return false;
+		return -ENOMEM;
 
 	if (flags & FOLL_GET)
 		folio_ref_inc(folio);
@@ -232,7 +234,7 @@ bool __must_check try_grab_page(struct page *page, unsigned int flags)
 		node_stat_mod_folio(folio, NR_FOLL_PIN_ACQUIRED, 1);
 	}
 
-	return true;
+	return 0;
 }
 
 /**
@@ -624,8 +626,9 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 		       !PageAnonExclusive(page), page);
 
 	/* try_grab_page() does nothing unless FOLL_GET or FOLL_PIN is set. */
-	if (unlikely(!try_grab_page(page, flags))) {
-		page = ERR_PTR(-ENOMEM);
+	ret = try_grab_page(page, flags);
+	if (unlikely(ret)) {
+		page = ERR_PTR(ret);
 		goto out;
 	}
 	/*
@@ -960,10 +963,9 @@ static int get_gate_page(struct mm_struct *mm, unsigned long address,
 			goto unmap;
 		*page = pte_page(*pte);
 	}
-	if (unlikely(!try_grab_page(*page, gup_flags))) {
-		ret = -ENOMEM;
+	ret = try_grab_page(*page, gup_flags);
+	if (unlikely(ret))
 		goto unmap;
-	}
 out:
 	ret = 0;
 unmap:
@@ -2536,7 +2538,7 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
 		}
 		SetPageReferenced(page);
 		pages[*nr] = page;
-		if (unlikely(!try_grab_page(page, flags))) {
+		if (unlikely(try_grab_page(page, flags))) {
 			undo_dev_pagemap(nr, nr_start, flags, pages);
 			break;
 		}
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1cc4a5f4791e..52f2b2a2ffae 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1035,6 +1035,7 @@ struct page *follow_devmap_pmd(struct vm_area_struct *vma, unsigned long addr,
 	unsigned long pfn = pmd_pfn(*pmd);
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
+	int ret;
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
 
@@ -1066,8 +1067,9 @@ struct page *follow_devmap_pmd(struct vm_area_struct *vma, unsigned long addr,
 	if (!*pgmap)
 		return ERR_PTR(-EFAULT);
 	page = pfn_to_page(pfn);
-	if (!try_grab_page(page, flags))
-		page = ERR_PTR(-ENOMEM);
+	ret = try_grab_page(page, flags);
+	if (ret)
+		page = ERR_PTR(ret);
 
 	return page;
 }
@@ -1193,6 +1195,7 @@ struct page *follow_devmap_pud(struct vm_area_struct *vma, unsigned long addr,
 	unsigned long pfn = pud_pfn(*pud);
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
+	int ret;
 
 	assert_spin_locked(pud_lockptr(mm, pud));
 
@@ -1226,8 +1229,10 @@ struct page *follow_devmap_pud(struct vm_area_struct *vma, unsigned long addr,
 	if (!*pgmap)
 		return ERR_PTR(-EFAULT);
 	page = pfn_to_page(pfn);
-	if (!try_grab_page(page, flags))
-		page = ERR_PTR(-ENOMEM);
+
+	ret = try_grab_page(page, flags);
+	if (ret)
+		page = ERR_PTR(ret);
 
 	return page;
 }
@@ -1435,6 +1440,7 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
+	int ret;
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
 
@@ -1459,8 +1465,9 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 	VM_BUG_ON_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
 			!PageAnonExclusive(page), page);
 
-	if (!try_grab_page(page, flags))
-		return ERR_PTR(-ENOMEM);
+	ret = try_grab_page(page, flags);
+	if (ret)
+		return ERR_PTR(ret);
 
 	if (flags & FOLL_TOUCH)
 		touch_pmd(vma, addr, pmd, flags & FOLL_WRITE);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b586cdd75930..e8d01a19ce46 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7224,14 +7224,15 @@ follow_huge_pmd_pte(struct vm_area_struct *vma, unsigned long address, int flags
 		page = pte_page(pte) +
 			((address & ~huge_page_mask(h)) >> PAGE_SHIFT);
 		/*
-		 * try_grab_page() should always succeed here, because: a) we
-		 * hold the pmd (ptl) lock, and b) we've just checked that the
-		 * huge pmd (head) page is present in the page tables. The ptl
-		 * prevents the head page and tail pages from being rearranged
-		 * in any way. So this page must be available at this point,
-		 * unless the page refcount overflowed:
+		 * try_grab_page() should always be able to get the page here,
+		 * because: a) we hold the pmd (ptl) lock, and b) we've just
+		 * checked that the huge pmd (head) page is present in the
+		 * page tables. The ptl prevents the head page and tail pages
+		 * from being rearranged in any way. So this page must be
+		 * available at this point, unless the page refcount
+		 * overflowed:
 		 */
-		if (WARN_ON_ONCE(!try_grab_page(page, flags))) {
+		if (try_grab_page(page, flags)) {
 			page = NULL;
 			goto out;
 		}
@@ -7269,7 +7270,7 @@ follow_huge_pud(struct mm_struct *mm, unsigned long address,
 	pte = huge_ptep_get((pte_t *)pud);
 	if (pte_present(pte)) {
 		page = pud_page(*pud) + ((address & ~PUD_MASK) >> PAGE_SHIFT);
-		if (WARN_ON_ONCE(!try_grab_page(page, flags))) {
+		if (try_grab_page(page, flags)) {
 			page = NULL;
 			goto out;
 		}
-- 
2.30.2

