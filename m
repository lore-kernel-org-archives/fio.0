Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4C5C2BB41
	for <fio@archiver.kernel.org>; Tue, 16 Aug 2022 08:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiHPIVR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 16 Aug 2022 04:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbiHPIUe (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 16 Aug 2022 04:20:34 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7298F81B04
        for <fio@vger.kernel.org>; Mon, 15 Aug 2022 23:04:26 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220816060421epoutp013ffc47e8097b1d2af5e11988cd38dc62~Lvg_cURLr1264312643epoutp01d
        for <fio@vger.kernel.org>; Tue, 16 Aug 2022 06:04:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220816060421epoutp013ffc47e8097b1d2af5e11988cd38dc62~Lvg_cURLr1264312643epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660629861;
        bh=Om9BgP1obYkY6T83GqZlENCafVLmFnsnHClo6fHk39I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alJBd2WJnUBkeF+CZdojt/Ob8KW95Nefp1MhJJ2MiB+IEUgcpM8YfVoNbg1BJIMkq
         RLIADnuRLZOrj2toJyZtHkIT7BIrcv6Jf5EWMFci4dylrWrtcLZGC9QN4ADzKhYunD
         tGiERXBNpRLHcjsFK/sWaEeXaUaeChRDN/vVM/lk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220816060421epcas5p42b6b302800e34ed1939ef94afc6d3707~Lvg_KTYDr0605106051epcas5p4d;
        Tue, 16 Aug 2022 06:04:21 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4M6LFZ4511z4x9Pt; Tue, 16 Aug
        2022 06:04:18 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AD.E3.49477.0633BF26; Tue, 16 Aug 2022 15:04:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220816054809epcas5p1ef377b2a3e72983f569c967c8768ee43~LvS0uO49K1363013630epcas5p1Z;
        Tue, 16 Aug 2022 05:48:09 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220816054809epsmtrp24fd6ab2b9ac0ad84f898757ccdf6d544~LvS0Y6nM02873228732epsmtrp2U;
        Tue, 16 Aug 2022 05:48:09 +0000 (GMT)
X-AuditID: b6c32a49-82dff7000000c145-e3-62fb33600c1c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C6.DA.08802.89F2BF26; Tue, 16 Aug 2022 14:48:08 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220816054808epsmtip121212915e89f28ee6377d8911f471376~LvSzkiCC51654916549epsmtip1l;
        Tue, 16 Aug 2022 05:48:08 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     vincent.fu@samsung.com, fio@vger.kernel.org,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/2] engines/xnvme: fix segfault issue with xnvme ioengine
Date:   Tue, 16 Aug 2022 11:08:20 +0530
Message-Id: <20220816053821.440-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220816053821.440-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsWy7bCmum6C8e8kg9lf2CzWXPnNbrH6bj+b
        xcdZL5gtHnd3MDqweFw+W+rRt2UVo8fnTXIBzFHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGm
        ZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAy5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqp
        BSk5BSYFesWJucWleel6eaklVoYGBkamQIUJ2Rlv/n1mK5jCU/H1wB/WBsZeri5GTg4JAROJ
        y6s2MnUxcnEICexmlHh55zs7hPOJUeLG97fMIFVCAp8ZJZacjYPpePHjOSNE0S5GiZ+9b5kg
        ilqZJOZekQSx2QS0JV69vQHWLCIgLLG/o5Wli5GDg1kgQuLkCw+QsLCAl8T3WQtYQcIsAqoS
        C67ag5i8AlYSi9pNIDbJS6zecABsCKeAtcS3L5vAtkoILGKX2Pf2MytEkYvE8elHmCFsYYlX
        x7ewQ9hSEp/f7WWDsLMlNj38yQRhF0gcedELVW8v0XqqnxniMk2J9bv0IcKyElNPrQMrZxbg
        k+j9/QSqlVdixzwYW1Xi773bLBC2tMTNd1ehbA+J7q8HGSEB0scoMX0J/wRGuVkIGxYwMq5i
        lEwtKM5NTy02LTDMSy2HR1hyfu4mRnBa0vLcwXj3wQe9Q4xMHIyHGCU4mJVEeAVf/EgS4k1J
        rKxKLcqPLyrNSS0+xGgKDL2JzFKiyfnAxJhXEm9oYmlgYmZmZmJpbGaoJM7rdXVTkpBAemJJ
        anZqakFqEUwfEwenVAPTzsCazK/NUm/VGKICpI344t9nNLKt1gwLUfaqOtB7ueN75PG/rh+X
        qEzl6K+XXPaEb5uW+9WXcwoZNesmrZ7MraYhYu/vXXbvnmX+j1A15beBv9e2FCc/XLe3QKzh
        ivzsBTb5n1W8n3lqnJQumM2p+NhmTdJk+Vl3fn7+Lcq38uq9RNU6x2aecyu16thzV/ZXTmuZ
        avxCTV1PcM3Nm2k7BQ/uFE7wUD7LtPnhZgvX8iix4tl7/ZtEZl3uX2Mbt5UtsDz5WLnY4okP
        +zzLZ6o6u3lP4xFcba7wdqvSm1O1N1jffKj0dolNNOfqiy/9LbjEqOW26KYPyfMK/nZuqytZ
        LazdUVE6WbbtVEFqqxJLcUaioRZzUXEiADrRBMjUAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsWy7bCSnO4M/d9JBj0bTC3WXPnNbrH6bj+b
        xcdZL5gtHnd3MDqweFw+W+rRt2UVo8fnTXIBzFFcNimpOZllqUX6dglcGW/+fWYrmMJT8fXA
        H9YGxl6uLkZODgkBE4kXP54zdjFycQgJ7GCU+HF1AlsXIwdQQlpi4fpEiBphiZX/nrND1DQz
        ScxrWM8GkmAT0JZ49fYGM4gtAlS0v6OVBcRmFoiSeHj5IpgtLOAl8X3WAlaQmSwCqhILrtqD
        mLwCVhKL2k0gxstLrN5wAGwKp4C1xLcvmxhBbCGgkjtNP5gmMPItYGRYxSiZWlCcm55bbFhg
        lJdarlecmFtcmpeul5yfu4kRHDxaWjsY96z6oHeIkYmD8RCjBAezkgiv4IsfSUK8KYmVValF
        +fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwhT3+suDvv+oPjw/2hp8W
        cM4XsTFsaZo6U2VPUtCSHGHm6eZhW0RF9bOEt2zt5K1vW7yx/tH3kxrLw7XuZD1nudcp8C3G
        fXX4zoVHJy6ZtNZc6sGF61OuvhTp57Tx0HjJpsBV4LoyJKrkzzwZKw/xz72qa7q+n5N3+/yn
        c5e9dmDcnt5Gr8Kz0rU6Z29VrrdT/lRzdNKj/b++Gna92qra337dJFlh1bfpGRtWWcnccP4j
        yq84Y/KD3IhDk9qWSXuvzFmx5dR+iR+Xv4r+3Fbc8NEnL/vA83SDTdPk8m6f9WjlF8kLkXro
        YCrS0Lbe+qDs4e2H41b51Pgqixnarm3n/7p8MpOa5405n34XJf3aqMRSnJFoqMVcVJwIAF78
        HW2NAgAA
X-CMS-MailID: 20220816054809epcas5p1ef377b2a3e72983f569c967c8768ee43
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220816054809epcas5p1ef377b2a3e72983f569c967c8768ee43
References: <20220816053821.440-1-ankit.kumar@samsung.com>
        <CGME20220816054809epcas5p1ef377b2a3e72983f569c967c8768ee43@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

fix segfault when xnvme ioengine is called without thread=1.
The segfault happens because td->io_ops_data is accessed at
two locations xnvme_fioe_cleanup and xnvme_fioe_iomem_free,
during the error handling call.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/xnvme.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/engines/xnvme.c b/engines/xnvme.c
index c11b33a8..d8647481 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -205,9 +205,14 @@ static void _dev_close(struct thread_data *td, struct xnvme_fioe_fwrap *fwrap)
 
 static void xnvme_fioe_cleanup(struct thread_data *td)
 {
-	struct xnvme_fioe_data *xd = td->io_ops_data;
+	struct xnvme_fioe_data *xd = NULL;
 	int err;
 
+	if (!td->io_ops_data)
+		return;
+
+	xd = td->io_ops_data;
+
 	err = pthread_mutex_lock(&g_serialize);
 	if (err)
 		log_err("ioeng->cleanup(): pthread_mutex_lock(), err(%d)\n", err);
@@ -367,8 +372,14 @@ static int xnvme_fioe_iomem_alloc(struct thread_data *td, size_t total_mem)
 /* NOTE: using the first device for buffer-allocators) */
 static void xnvme_fioe_iomem_free(struct thread_data *td)
 {
-	struct xnvme_fioe_data *xd = td->io_ops_data;
-	struct xnvme_fioe_fwrap *fwrap = &xd->files[0];
+	struct xnvme_fioe_data *xd = NULL;
+	struct xnvme_fioe_fwrap *fwrap = NULL;
+
+	if (!td->io_ops_data)
+		return;
+
+	xd = td->io_ops_data;
+	fwrap = &xd->files[0];
 
 	if (!fwrap->dev) {
 		log_err("ioeng->iomem_free(): failed no dev-handle\n");
-- 
2.17.1

