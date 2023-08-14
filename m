Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06BA9C05052
	for <fio@archiver.kernel.org>; Mon, 14 Aug 2023 09:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbjHNJlW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 14 Aug 2023 05:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbjHNJlN (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Aug 2023 05:41:13 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44CFE62
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 02:41:11 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230814094110epoutp02403108c037b9597855396c586b52f7f7~7No5a6m7V2562725627epoutp02o
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 09:41:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230814094110epoutp02403108c037b9597855396c586b52f7f7~7No5a6m7V2562725627epoutp02o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1692006070;
        bh=lwpuni5fiwTz43zHZP6vnkU5/IwlesjkW4ru/K/Zoj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NANuOGcQy8FvKI0wHlTh95x7v7PZqj2gPdfsISE7jyP5lzRTopoK7/8gJj5OMlzqp
         +z5i9BP4uXlsJvZAmr7bZxxyPyx3TAC1YDq4OxfMNrl9lK7J638ttzWjhHwlc4yM/J
         8KMDoQaDfGkUX0hqbjATE9oSRScKDtbmKwWaavqY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230814094109epcas5p20de8baf08a35a77994a88e483b743be7~7No5L485U1266512665epcas5p2f;
        Mon, 14 Aug 2023 09:41:09 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4RPTtB4Dgjz4x9Ps; Mon, 14 Aug
        2023 09:41:06 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        69.3E.55522.2B6F9D46; Mon, 14 Aug 2023 18:41:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230814093845epcas5p1e05696c12c9a9720252b80a522d7199c~7NmzQmVIH0636706367epcas5p1Y;
        Mon, 14 Aug 2023 09:38:45 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230814093845epsmtrp122301f5b9c761a8c6d29e200e60eb64b~7NmzP8Daf2343923439epsmtrp1Y;
        Mon, 14 Aug 2023 09:38:45 +0000 (GMT)
X-AuditID: b6c32a49-67ffa7000000d8e2-61-64d9f6b259ae
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
        DE.31.64355.526F9D46; Mon, 14 Aug 2023 18:38:45 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230814093844epsmtip1bc669f1f4573c4b3880874658a2f35b4~7Nmx3p2gc0860508605epsmtip1p;
        Mon, 14 Aug 2023 09:38:44 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 05/10] io_u: move engine data out of union
Date:   Mon, 14 Aug 2023 20:27:42 +0530
Message-Id: <20230814145747.114725-6-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230814145747.114725-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsWy7bCmlu6mbzdTDN4cErBYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        AbpESaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBg
        ZApUmJCdMenkL7aCBpaKs9+uMTUw9jB3MXJySAiYSExs/sLWxcjFISSwm1Hi1uW5jBDOJ0aJ
        A5cfscE5J99sZ4NpObFhEjtEYiejxL7Wt8wQTieTxJYHrYwgVWwC2hKv3t4ASnBwiAhoSKy5
        mwpSwyzQwiixu3s2K0iNsICtxO2pe1lBalgEVCWeLFIBCfMChXu+z2CBWCYvMfPSd3YQm1PA
        TuL/lN/sEDWCEidnPgGrYQaqad46G+wGCYGX7BJ7V32Fes5FYvKZ01C2sMSr41vYIWwpiZf9
        bVB2tsSmhz+ZIOwCiSMveqHq7SVaT/WD3c8soCmxfpc+RFhWYuqpdUwQe/kken8/gWrlldgx
        D8ZWlfh77zbU/dISN99dhbI9JNZ9ncoECauJjBLblj5ln8CoMAvJP7OQ/DMLYfUCRuZVjJKp
        BcW56anFpgWGeanl8FhOzs/dxAhOnVqeOxjvPvigd4iRiYPxEKMEB7OSCO8t92spQrwpiZVV
        qUX58UWlOanFhxhNgeE9kVlKNDkfmLzzSuINTSwNTMzMzEwsjc0MlcR5X7fOTRESSE8sSc1O
        TS1ILYLpY+LglGpgmsaj1bpcSkXxQnjwi6ipaY8XazxknS+z5Y/09ROmSS067I9a/9pulrns
        NzfBZNHbv0eE5v644acY01S/4uJsvs6uU/ccP7hG7XnE4nzywgyWiWIzjrKK5blW3yzrbM5U
        VSyavjhmRp701lUr/ryROB9XVN3Dla/Xmqi25vB7Y+6s/j1HrDb8v73MzTVmmYFU0AL+a+Jp
        hU9Mrkzsk++8s+PV5NucKVMPbc29/XPNHI2sxW8/mDu65H78qr6m7Fb0z2m/yrxy9sisXZHZ
        0OMmxPTBfoGRvdq9i2Eb/zjUxL+R9n7TxyogccL+0Mc7rX+3V+dLnN/3Utx9rqtSg/2N/Dlb
        rj9QXtwmJJ9z994GBiWW4oxEQy3mouJEAE1QumomBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsWy7bCSnK7qt5spBn8azC3WXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiiuGxSUnMyy1KL9O0SuDImnfzFVtDAUnH22zWmBsYe5i5GTg4JAROJExsmsYPYQgLb
        GSXWP7fsYuQAiktLLFyfCFEiLLHy33OgEi6gknYmic5NBxlBEmwC2hKv3t4AmyMioCVxbF0T
        G0gRs0AXo8Te3dPYQBLCArYSt6fuZQUZyiKgKvFkkQpImBco3PN9BgvEAnmJmZe+g93AKWAn
        8X/Kb6h7bCVWLQRpBakXlDg58wlYPTNQffPW2cwTGAVmIUnNQpJawMi0ilE0taA4Nz03ucBQ
        rzgxt7g0L10vOT93EyM4oLWCdjAuW/9X7xAjEwfjIUYJDmYlEd5b7tdShHhTEiurUovy44tK
        c1KLDzFKc7AoifMq53SmCAmkJ5akZqemFqQWwWSZODilGphyDHa8Old7dP17h3fvF01/9J1j
        quCKHec69NSWbCl+HHKl5Looo2q857e7c8+v3cOmf7XuurFFmgr3nGuKs2Q+PDW/k2Ife9FB
        yaR6owJz1cxvDyXn1r65xyY0T9TVzVozNnwx94nW1eWhC2TWftkefybgjk6pr7jx7fSj3JuX
        uFVrqcTYeso80Fj812uTZNefc7mfl0mdmhp2MePfhQzJJu/96/kZP+rd05/I7ys36dWJsIJD
        6+IORF5Zv5O9x+ZfVGda/Jn6uHSPlQy3JjQ6+VRtUxOcLFGpNomL0WNl3sm+J8FGTMxau352
        LTlWE/H5HMNtG82nPy5ksEQobDH9OLfseto6Zr2sjlnHZ+orsRRnJBpqMRcVJwIAJP0mwtcC
        AAA=
X-CMS-MailID: 20230814093845epcas5p1e05696c12c9a9720252b80a522d7199c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230814093845epcas5p1e05696c12c9a9720252b80a522d7199c
References: <20230814145747.114725-1-ankit.kumar@samsung.com>
        <CGME20230814093845epcas5p1e05696c12c9a9720252b80a522d7199c@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

io_uring_cmd ioengine requires engine data to store nvme protection
information data.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 io_u.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_u.h b/io_u.h
index b432a540..786251d5 100644
--- a/io_u.h
+++ b/io_u.h
@@ -89,8 +89,8 @@ struct io_u {
 	union {
 		unsigned int index;
 		unsigned int seen;
-		void *engine_data;
 	};
+	void *engine_data;
 
 	union {
 		struct flist_head verify_list;
-- 
2.25.1

