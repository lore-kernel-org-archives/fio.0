Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C3FC433F5
	for <fio@archiver.kernel.org>; Fri,  3 Dec 2021 21:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353853AbhLCVOk (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Dec 2021 16:14:40 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:13297 "EHLO
        mailout2.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353850AbhLCVOi (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Dec 2021 16:14:38 -0500
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20211203211113usoutp02e0136cd36985cd544b7a85857596c06a~9WvrzYvs_2655726557usoutp02m;
        Fri,  3 Dec 2021 21:11:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20211203211113usoutp02e0136cd36985cd544b7a85857596c06a~9WvrzYvs_2655726557usoutp02m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1638565873;
        bh=8nxqXlRgGzadelM3p6OewjXL1mGriI2Pgd+Fghoaf14=;
        h=From:To:CC:Subject:Date:References:From;
        b=k8jPrGuST7rwjhzHRMl6xZ8K9rsWPvGflYpMTQ5/wX3BQujCLYYsjREofxfWbUKt+
         AyNc8aYSexk/dyq2N1BMnOOl7JBjMoFWSN248BiD8GJQqcNyfjSq7t5ChSy88RTbND
         JMeofg0YlXRoYxFcHEsyyYJG6OYuR/3BvwWKZaKM=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211203211113uscas1p290ca585025d1758453ddfa5d928a9585~9WvrlovMv2327923279uscas1p2t;
        Fri,  3 Dec 2021 21:11:13 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 5D.53.09687.1F78AA16; Fri, 
        3 Dec 2021 16:11:13 -0500 (EST)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211203211112uscas1p2e92f1c3a04f7bfe27d6fe69d519995d2~9WvrQuxdo1871618716uscas1p2M;
        Fri,  3 Dec 2021 21:11:12 +0000 (GMT)
X-AuditID: cbfec370-9c5ff700000025d7-58-61aa87f18c17
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 05.8B.09671.0F78AA16; Fri, 
        3 Dec 2021 16:11:12 -0500 (EST)
Received: from SSI-EX1.ssi.samsung.com (105.128.2.226) by
        SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Fri, 3 Dec 2021 13:10:10 -0800
Received: from SSI-EX1.ssi.samsung.com ([::1]) by SSI-EX1.ssi.samsung.com
        ([fe80::f93d:5544:8666:3356%7]) with mapi id 15.01.2242.008; Fri, 3 Dec 2021
        13:10:10 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 0/2] two small cleanup patches
Thread-Topic: [PATCH 0/2] two small cleanup patches
Thread-Index: AQHX6Ion97xP2BbixE21iY8pEtSbMw==
Date:   Fri, 3 Dec 2021 21:10:09 +0000
Message-ID: <20211203211050.51241-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWy7djX87of21clGsy7w2ax+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoEr4/bL1WwFM5kq1m1YxNbAeIuxi5GTQ0LARGLe
        1C7WLkYuDiGBlYwS83a/YYJwWpkkvi+8AeRwgFUd3+UMEV/LKPHm3FRmCOcDo8Txpi2McO2/
        7m5mB+lgE9CUeLu/AGSFiECYxM9H21lBbGYBdYljGzewgZQIC+hJnF0tBlFiLLGisZkZwtaT
        +HCzDayERUBF4lpvFEiYV8BaYkrfV7CjGQXEJL6fWsMEMVFc4taT+UwQzwhKLJq9hxnCFpP4
        t+shG4StKHH/+0t2iHo9iRtTp7BB2NoSyxa+ZoaYLyhxcuYTFoh6SYmDK25A2W/ZJV7eVYCw
        XSR+bFwDNV9a4ur1qVD2OUaJB/+CQaEgIXCdUWLFl8WsEAlriYV/1kMdyifx99cjRkh48kp0
        tAlNYFSaheSFWUjOm4XkvFlIzlvAyLKKUby0uDg3PbXYOC+1XK84Mbe4NC9dLzk/dxMjMF2c
        /ne4YAfjrVsf9Q4xMnEwHmKU4GBWEuE1qVyVKMSbklhZlVqUH19UmpNafIhRmoNFSZz39J+G
        RCGB9MSS1OzU1ILUIpgsEwenVANT9xW5y6qBd4sDTVRqXlul/ZTdWNffbXBlX2FUwJo+Zgdv
        yYVTxdljPvJVHpNY+GHq0lLv86/3iX1foZmYp/Hzl8nuufcyj8h3WvJIxvUvW//sRoOc4rnU
        5YazLfbnzCxepFIXeLpaQSHx822zf788Sxp3tDgnVibf7/ZK3bf6yBfJnvVzH7PbPA2RvfyA
        2cD8oW7K3i0b26cJLNBRiFSemSq/d0NBpPQ/Vd3CbxFVF17skXjpxRi3UirwRZ1EdAX35Y8/
        WLqmz4/3Od5WcYxT2DXrfL/h5dTnypvLqs+k62lNzbVf0VUXJJB4kr+Oi2PFOn6f2MYPqxk/
        POV2ybuptrR/kufEikWNzCyT9ZRYijMSDbWYi4oTAf8yjAKGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWS2cA0UfdD+6pEg/knZC1W3+1ns/g46wWz
        A5PH5bOlHp83yQUwRXHZpKTmZJalFunbJXBl3H65mq1gJlPFug2L2BoYbzF2MXJwSAiYSBzf
        5dzFyMUhJLCaUeLflW8sEM4HRokTmzcyQjgrGSW6W36DdbAJaEq83V/QxcjJISIQJvHz0XZW
        EJtZQF3i2MYNbCAlwgJ6EmdXi0GUGEusaGxmhrD1JD7cbAMrYRFQkbjWGwUS5hWwlpjS95UR
        xGYUEJP4fmoNE8REcYlbT+aD2RICAhJL9pxnhrBFJV4+/scKYStK3P/+kh2iXk/ixtQpbBC2
        tsSyha+ZIeYLSpyc+YQFol5S4uCKGywTGEVnIVkxC0n7LCTts5C0L2BkWcUoXlpcnJteUWyY
        l1quV5yYW1yal66XnJ+7iREYI6f/HY7cwXj01ke9Q4xMHIyHGCU4mJVEeE0qVyUK8aYkVlal
        FuXHF5XmpBYfYpTmYFES5xVynRgvJJCeWJKanZpakFoEk2Xi4JRqYApjkNzW6fBi1r79ktNz
        wxxv6O7+eOxdYtPNz+vkTR7c0ZB9H1q6rGCFyzmWzXe9WzIniOVdq7XvaXuw68ndZ9+yH4TH
        VgpwMwf/ZGwtb3saWp2f7VTSeiu46vuxm0E53++oP57V2viWUfnwlbvbE2M65votmL7wX0yO
        pb/IhavXLvFz5R35GeMrfjlG2meSy833X7JDtjipyjVOcf5kKWTMsaU94363S8Uff4mdpa9K
        BLUWKr72WtT3dt1kphMxK84yPTz+UFNGlz9fjXHKbj9dvnC263pB1mX2QSoF23Z+VJiX9fX8
        A/Pw5dnqzJ+utjfpz3wl5nv6+oRnSy+2749axXh/estCg5L1xoaRJkosxRmJhlrMRcWJAMRG
        OogAAwAA
X-CMS-MailID: 20211203211112uscas1p2e92f1c3a04f7bfe27d6fe69d519995d2
CMS-TYPE: 301P
X-CMS-RootMailID: 20211203211112uscas1p2e92f1c3a04f7bfe27d6fe69d519995d2
References: <CGME20211203211112uscas1p2e92f1c3a04f7bfe27d6fe69d519995d2@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Jens, please consider these two small cleanup patches.

Vincent Fu (2):
  io_ddir: return appropriate string for DDIR_INVAL
  libfio: drop unneeded reset of rwmix_issues

 io_ddir.h | 2 +-
 libfio.c  | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--=20
2.25.1
