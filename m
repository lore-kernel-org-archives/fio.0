Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B45C433FE
	for <fio@archiver.kernel.org>; Wed, 12 Oct 2022 05:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiJLFMR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 12 Oct 2022 01:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLFMQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 Oct 2022 01:12:16 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E1B89ADE
        for <fio@vger.kernel.org>; Tue, 11 Oct 2022 22:12:14 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221012051211epoutp02701726f73161fdd94f319b13ffb37745~dOksk9njM0115801158epoutp02M
        for <fio@vger.kernel.org>; Wed, 12 Oct 2022 05:12:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221012051211epoutp02701726f73161fdd94f319b13ffb37745~dOksk9njM0115801158epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1665551531;
        bh=LyEBDGNdQmW8mOxKYP4i1+dVZd43YEMoNztWNAl2l+I=;
        h=From:To:Cc:Subject:Date:References:From;
        b=AOdrtjHSqYJ+OZ2acs5FzMREX0TYNMfd3aGVdBh8xH+EMd6wGhsVyGYkzTGEPVuyl
         UoOp3D6FNPV17ftV+WX/WftZUfjtyC8+Sf4bV6o5FpMZ+9Xieh2uHuZPjYy7e6a+Be
         VDn71szyQzpvH5fNtZ7b2X10JlkiWzLRyUNyobV0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221012051211epcas5p1d01fcb3536f14c5517aaf5cd7c19151d~dOksQkJwZ1613616136epcas5p1f;
        Wed, 12 Oct 2022 05:12:11 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MnLP31kgTz4x9QJ; Wed, 12 Oct
        2022 05:12:07 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        27.01.56352.6AC46436; Wed, 12 Oct 2022 14:12:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221011110947epcas5p2f840397a3e45e1d9326619a10d52ffa3~c-zoi1oNd2158521585epcas5p2G;
        Tue, 11 Oct 2022 11:09:47 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221011110947epsmtrp25ea943d0a7a753850f9d8d010abf1fd2~c-zoiPiwv2450924509epsmtrp2F;
        Tue, 11 Oct 2022 11:09:47 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-86-63464ca60338
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.A7.14392.BFE45436; Tue, 11 Oct 2022 20:09:47 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221011110946epsmtip2835e3c7f1ef820f3ac037e79af28730d~c-znzGxDf1002610026epsmtip2O;
        Tue, 11 Oct 2022 11:09:46 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/1] Add missing flags to the uring passthrough engine
Date:   Tue, 11 Oct 2022 16:29:34 +0530
Message-Id: <20221011105935.10455-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsWy7bCmpu4yH7dkg79XOC3WXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOuPluN1PBUpaK/zeOMzYwHmbuYuTk
        kBAwkTi8eypjFyMXh5DAbkaJ9mP3mCCcT4wSh/6uhHK+MUr8erCLDaal7cwXsHYhgb2MEp82
        1kAUtTJJnNj2GqyITUBb4tXbG2BFIgLCEvs7WllAbGaBUImT176wdzFycAgLuElMfsUHYrII
        qEqsPloNUsErYCPxfeJOJohV8hKrNxxgBhkvIdDNLvHo4j+wVgkBF4kTszUhaoQlXh3fwg5h
        S0l8frcX6sxsiU0Pf0LNKZA48qIX6mN7idZT/cwgY5gFNCXW79KHCMtKTD21jgniSD6J3t9P
        oFp5JXbMg7FVJf7eu80CYUtL3Hx3lQXiGg+JOZdLIAESK9HZcYVlAqPsLIQFCxgZVzFKphYU
        56anFpsWGOellsMjKTk/dxMjOA1pee9gfPTgg94hRiYOxkOMEhzMSiK8jPOdkoV4UxIrq1KL
        8uOLSnNSiw8xmgIDbCKzlGhyPjAR5pXEG5pYGpiYmZmZWBqbGSqJ8y6eoZUsJJCeWJKanZpa
        kFoE08fEwSnVwCTp1p+zhi/LLOLrixbxb3MLGCtk/H3j57yNe/2GkdFx9ozG81F6vo9a37Oa
        6Vj42eVyPFN+rHc+OO6JzZXLTLG2O1cwpQX286o2C69e18ilu3tr79Gjq9e/S+DJnvaNaWWJ
        bysnt8jbXW7pVqfnfvCPe77ntxNT/izr4mvSd448n1XuFX2zV3NWtXrbwmkibb2Ta++tepW3
        66ecW5Lj6WqpY/VTN1e9ecItYm+zMfbU88jF3w+83XvV5s5xixX3Mh41nK81ZpSUfnlFPKyk
        rslvURHHqkDGGOU5urV3fJsrLE1uL7/85UGqdIVGmubHvQ2n90nqsugnNf5a+X23OONf8+km
        r24ve+e88+51KyWW4oxEQy3mouJEAFqQKyPMAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsWy7bCSvO5vP9dkgzWfBSzWXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mq4+W43U8FS
        lor/N44zNjAeZu5i5OSQEDCRaDvzBcjm4hAS2M0o8X7NN7YuRg6ghLTEwvWJEDXCEiv/PWeH
        qGlmkpjT9p8FJMEmoC3x6u0NsEEiQEX7O1rB4swC4RLTD0xmBJkjLOAmMfkVH4jJIqAqsfpo
        NUgFr4CNxPeJO5kgxstLrN5wgHkCI88CRoZVjJKpBcW56bnFhgWGeanlesWJucWleel6yfm5
        mxjBQaGluYNx+6oPeocYmTgYDzFKcDArifAyzndKFuJNSaysSi3Kjy8qzUktPsQozcGiJM57
        oetkvJBAemJJanZqakFqEUyWiYNTqoHJ0J6L+1L22n1Njv3Lb1jmJefUsGb+s5yv7CPD41e6
        bpEn28YrfH+5F1utnHwzSiCv6JXag7Vyc9Qmz14p779T7ffEQM3GiEdfDMqqdW6/FXphtVGy
        vK/DPqWH90BtivCXl9PdLzIoH0qNf8IQunKNwjKexQxnO2f/PN+4pOHmtZ+Ty7+yXbBWf295
        au1CNxGGjItrl/cUPDu4YkmigX2r5rY3mQ1F8+cvSBU2j1yuF7q86Y7bjT0pQWdNT+yUudp/
        V6jgjMAmy8/ezGxnrdVyGW04hGNEaw7JRop/uP9x5okq99B1JgY+qeIC8+NkZ4i86L38N0ry
        yvfa8FqlryrOftpp5gqslufX7Im4UarEUpyRaKjFXFScCACjPnNLeQIAAA==
X-CMS-MailID: 20221011110947epcas5p2f840397a3e45e1d9326619a10d52ffa3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221011110947epcas5p2f840397a3e45e1d9326619a10d52ffa3
References: <CGME20221011110947epcas5p2f840397a3e45e1d9326619a10d52ffa3@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add flag IORING_SETUP_COOP_TASKRUN for ring setup, to the uring
passthrough I/O engine. This was introduced to the normal io_uring
engine with commit 4d22c103

Add flag IORING_SETUP_SINGLE_ISSUER & IORING_SETUP_DEFER_TASKRUN for
ring setup, to the uring passthrough I/O engine. This was introduced
to the normal io_uring engine with commit e453f369

Ankit Kumar (1):
  engines/io_uring: set coop taskrun, single issuer and defer taskrun

 engines/io_uring.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

-- 
2.17.1

