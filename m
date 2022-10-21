Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E91C43219
	for <fio@archiver.kernel.org>; Fri, 21 Oct 2022 07:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiJUHOc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Oct 2022 03:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiJUHOb (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2022 03:14:31 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A87CDFFA
        for <fio@vger.kernel.org>; Fri, 21 Oct 2022 00:14:26 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221021071420epoutp035a9ccb42958fc86fcc769242800c8590~gBC6vUBnc2035720357epoutp03j
        for <fio@vger.kernel.org>; Fri, 21 Oct 2022 07:14:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221021071420epoutp035a9ccb42958fc86fcc769242800c8590~gBC6vUBnc2035720357epoutp03j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666336460;
        bh=Wb0QZwkwVe/jeixWkcidoguDM0kgt54GGBgJEL3Wfhk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=siJrrKuc6pZQ8U/qQN4zDlo8nYHj7PA3YrjxBPRvRtFB7WcrV7hX9SSg6XFL5DxXO
         nTWVpHH7qw+xBYwbf60nCAn/sjzG7R90blq7zv6t6u+28wZnLF+MHgCJvvgCpgjAR4
         OLYoYUN4mqiJFMZjVtbohQpm52ndz8jeKKK/2SfQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221021071420epcas5p4af57732021a45dd032b5c1584f835ed2~gBC6aAln80911409114epcas5p49;
        Fri, 21 Oct 2022 07:14:20 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Mtwgp6S22z4x9Q1; Fri, 21 Oct
        2022 07:14:14 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4B.7E.10166.4C642536; Fri, 21 Oct 2022 16:14:12 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221021070023epcas5p4fb87f4bf54dee358f193f66d910dd624~gA2vDC4Bo3193131931epcas5p4j;
        Fri, 21 Oct 2022 07:00:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221021070023epsmtrp25dd0c00c035e9d5606bb565db859cef0~gA2vCZb5w1650516505epsmtrp2Q;
        Fri, 21 Oct 2022 07:00:23 +0000 (GMT)
X-AuditID: b6c32a49-7ed91a80000227b6-16-635246c4fe9a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3F.3F.14392.78342536; Fri, 21 Oct 2022 16:00:23 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221021070022epsmtip24c6744d3eba89832409c7b9e074c8806~gA2uTyxAP1507215072epsmtip2X;
        Fri, 21 Oct 2022 07:00:22 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/1] fix segmentation fault with option bandwidth-log
Date:   Fri, 21 Oct 2022 12:18:59 +0530
Message-Id: <20221021064900.12341-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsWy7bCmuu4Rt6Bkg4OTeSzWXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOmNy+krXgPXPFpP7XLA2MXcxdjJwc
        EgImEkt+TmDtYuTiEBLYzSjx8esXNgjnE6PE3OfzWSCcb4wSP75fZodpOXGqlR0isZdRYnHH
        fmYIp5VJoulPPxNIFZuAtsSrtzfAlogICEvs72hlAbGZBUIlTl77AjZJWMBV4vGEp6wgNouA
        qsSahcvB4rwCNhK7l/2FOlBeYvWGA1B2N7vE7o+iELaLROvVLqiLhCVeHd8CZUtJfH63lw3C
        zpbY9PAnE4RdIHHkRS/UHHuJ1lP9QDYH0D2aEut36UOEZSWmnlrHBHEmn0Tv7ydQrbwSO+bB
        2KoSf+/dZoGwpSVuvrvKAjJGQsBD4sUzK5CwkECsxIG2A8wTGGVnISxYwMi4ilEytaA4Nz21
        2LTAMC+1HB5Pyfm5mxjByUjLcwfj3Qcf9A4xMnEwHmKU4GBWEuEteBeQLMSbklhZlVqUH19U
        mpNafIjRFBhiE5mlRJPzgekwryTe0MTSwMTMzMzE0tjMUEmcd/EMrWQhgfTEktTs1NSC1CKY
        PiYOTqkGpnzrs4au0+LWddRsP64vbnG01Oamqf5KrtsWEpYdmYfaRBl235Zkl7ouYJEyt+30
        vRfOnHaOV+/2XnXfZPTrwedwFvE/Do5Xrts7LVstev2ar4ip+MK1Lso7u4QfHwi2We5pt8hg
        gujWiTdW3Ez8W1e+mf3HsuCWE7WOn+8ETJ0+eWvFEo5iB823aQdzS1fsmNrZ7cx6prp0kYEl
        b4H18u7MluYe3+SZxyZz574OLclbfe7rzAfp1VpxKkrthx3kxS9lSR9bZfja8cl2K/m1q6Ld
        jnpJZHyU1/x8JufOzdUu2Q6unfUyJ0On2ze+Vb9odzH0HdcMHYf794IVb4e8TGZMXHFgyuG8
        r1eTLa5VKLEUZyQaajEXFScCAJS3b2TPAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsWy7bCSvG67c1CyQcNBaYs1V36zW6y+289m
        8XHWC2aLDW2CDiweO2fdZfe4fLbUo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDImt69kLXjP
        XDGp/zVLA2MXcxcjJ4eEgInEiVOt7F2MXBxCArsZJfZ0/WbrYuQASkhLLFyfCFEjLLHy33Oo
        mmYmibNHZrGBJNgEtCVevb0BNkgEqGh/RysLiM0sEC4x/cBkRhBbWMBV4vGEp6wgNouAqsSa
        hcvZQWxeARuJ3cv+Qh0hL7F6wwHmCYw8CxgZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn
        525iBAeGluYOxu2rPugdYmTiYDzEKMHBrCTCW/AuIFmINyWxsiq1KD++qDQntfgQozQHi5I4
        74Wuk/FCAumJJanZqakFqUUwWSYOTqkGJv209GOpC/pvP/yyYtP2D/G6l8url+85dmjS5cgT
        izZe32L9cl9o+O6srrI/kyVLVlmZLLfd93Gt4aXnUeUhnO2LOk2djtYu6o/h7Sn0tzQ8ciSp
        JujRG8n3FVcufH3od/ZukPrcNVxsm+6k3BDrvLhcUvrggSCBhzm6eaEFV3X23j0/JcfvcrGY
        0ektNw0TuG+tCQio15y7UTU+dk/BtmWv87dHinvPvv3QhJGzO6FGrW/eir9bo+oOnvmwXyyX
        fU3OnxV2lzJ2aecLTfJdu4XT/sxj36wzWh4eKwq9ZPvLiyaq6gaEasucN3XYxD1967uWtR1h
        SuXdh2dOmaDFtx3oq1kXuIX2FZ1r2Xb8gRJLcUaioRZzUXEiAIVTsLJ7AgAA
X-CMS-MailID: 20221021070023epcas5p4fb87f4bf54dee358f193f66d910dd624
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021070023epcas5p4fb87f4bf54dee358f193f66d910dd624
References: <CGME20221021070023epcas5p4fb87f4bf54dee358f193f66d910dd624@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The log parameters for aggregate read, write and trim only specify
log type. As a result the io_log data structure doesn't have the
relevant thread_data. While specifying fio option bandwidth-log this
results in segmentation fault.
Add a check and use DEF_LOG_ENTRIES for such case.

This was introduced with the commit 0a852a50

Ankit Kumar (1):
  stat: fix segfault with fio option bandwidth-log

 stat.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
2.17.1

