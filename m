Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736CEECAAA1
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 15:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJ1Po7 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 11:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiJ1Po6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 11:44:58 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E73129C88
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 08:44:55 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20221028154453usoutp022795b0adeeb4e24d9ef1a54db46f5f9b~iRhrkh5GV3010630106usoutp02Y
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 15:44:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20221028154453usoutp022795b0adeeb4e24d9ef1a54db46f5f9b~iRhrkh5GV3010630106usoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666971893;
        bh=YSqdGTCurNjjDybcjv0ytgoTN9ZbOjBbRjsv/GnrhV0=;
        h=From:To:CC:Subject:Date:References:From;
        b=WhHW+MZvpYS1ss2f7gpyEbod7uNQdQUdWbM6CpZ5M7DB92LVUs2TjiC4mHmkmAOpM
         CExdvTsi1Xwughqg3lqVDHh9cVCCJ39QaNcLqbb3AZZDrxMkYzGKRTzie0CQ/duwRd
         Hdqr2jEA9Ls/v7tR9xeQZSlDo81SMQavjO/cGiz8=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221028154453uscas1p19b5f5a364d9156ce0516d433f9c9a879~iRhrans3J2150521505uscas1p17
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 15:44:53 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 36.08.18126.5F8FB536; Fri,
        28 Oct 2022 11:44:53 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221028154452uscas1p12fbf5143b7b41f22f08fa0f93791a092~iRhrJbyjj1427014270uscas1p1N
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 15:44:52 +0000 (GMT)
X-AuditID: cbfec36f-ff9ff700000146ce-ea-635bf8f5f40f
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id CC.EE.36264.4F8FB536; Fri,
        28 Oct 2022 11:44:52 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Fri, 28 Oct 2022 08:44:51 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Fri,
        28 Oct 2022 08:44:51 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Ankit Kumar <ankit.kumar@samsung.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "gost.dev@samsung.com" <gost.dev@samsung.com>,
        Simon Lund <simon.lund@samsung.com>
Subject: fio xNVMe blog post part 2
Thread-Topic: fio xNVMe blog post part 2
Thread-Index: Adjq4tJmQG4BA8dEQYa+IoFbWrGNcQ==
Date:   Fri, 28 Oct 2022 15:44:51 +0000
Message-ID: <2eee1b17de1a49e9b7975a659fbd35b2@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsWy7djXc7pff0QnG7zfy23xcdYLZgdGj8+b
        5AIYo7hsUlJzMstSi/TtErgyTu7ay1pwnbnixv6zLA2MLcxdjJwcEgImEpOmtDN2MXJxCAms
        ZJR49nAhC4Qzn0ni1swjcFUPlsJUrWWU2Nq+mgnC+QTknF7EBuEsY5SY++8CUBkHB5uApsTb
        /QUg3SIC+hJ7H+9mBalhFpjIJLFjegcrSEJYQFni1NzLLBBFGhKnf21mh7D1JFpXPwWrYRFQ
        lfh05jMbyExeASuJq78TQcKMAmIS30+tYQKxmQXEJW49mc8EcamgxKLZe6CuFpP4t+shG4St
        KHH/+0t2iHodiQW7P7FB2NoSyxa+BqvnBeo9OfMJC0S9pMTBFTfAQSEh8JJd4vWU+6wQCReJ
        fSeOQtnSEn/vLmOCKGoHen7jF6juCYwS159IQdjWEv86r0Ft5pP4++sROIAkBHglOtqEJjAq
        zULywywk981Cct8sJPctYGRZxSheWlycm55abJSXWq5XnJhbXJqXrpecn7uJEZgkTv87nL+D
        8fqtj3qHGJk4GA8xSnAwK4nw1p+NThbiTUmsrEotyo8vKs1JLT7EKM3BoiTOGzVDK1lIID2x
        JDU7NbUgtQgmy8TBKdXAJLpw4vkzis8u3Hm5dfIGPi/d+NeHHnRkvj5z6u4pi6Db2mUzzLMa
        w+bc5T93LUr30GmWpcmLvKYwZ91fczPgfPfCW2VR9e7z429+XO3xn2XP5awJZl1OK1W2fRW9
        FjdjnofdNFexytYZBpJdL+e+yy8+ZjI7efoT/dS5fjfnFRTcKDl86m2H59VndZf1iuZ5THK0
        SdIyvPKi5yPb/DXTTvWwPGJbmP427GfqiRi7A03iDem2V/xCP77acvHLzvbbdSKe1X0cr5cX
        m3fyLdy0KV1K66hVA0+M3NTbkZoLlYPS72pUuOyVeDdTeC9jGbPxn/RdsZvmW6gbHP1rf+HW
        buN7Tbefst7fdjhyhmBbzx0lluKMREMt5qLiRACrnGDagQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWS2cA0SffLj+hkgzk/DS0+znrB7MDo8XmT
        XABjFJdNSmpOZllqkb5dAlfGyV17WQuuM1fc2H+WpYGxhbmLkZNDQsBE4sHSdsYuRi4OIYHV
        jBITl0yBcj4xSjy8cIUVwlnGKDFp9W22LkYODjYBTYm3+wtAukUE9CX2Pt4NVsMsMJFJYsf0
        DlaQhLCAssSpuZdZIIo0JE7/2swOYetJtK5+ClbDIqAq8enMZ7CZvAJWEld/J4KEGQXEJL6f
        WsMEYjMLiEvcejKfCeJSAYkle85DXS0q8fLxP1YIW1Hi/veX7BD1OhILdn9ig7C1JZYtfA1W
        zysgKHFy5hMWiHpJiYMrbrBMYBSdhWTFLCTts5C0z0LSvoCRZRWjeGlxcW56RbFRXmq5XnFi
        bnFpXrpecn7uJkZgXJz+dzh6B+PtWx/1DjEycTAeYpTgYFYS4a0/G50sxJuSWFmVWpQfX1Sa
        k1p8iFGag0VJnPdl1MR4IYH0xJLU7NTUgtQimCwTB6dUA5Pn1uy1H5+wKcsdWnxwzcodSvcc
        vnuxeTFe6zK5qHZTXXD59dfzp62asvN8qq5O/PI5nMo1dko36r64R9/xtxZ8WBsovfDKopht
        CxkC9r74/SZpS53iQxPdYL9ua2ULYabDKfta765fv/cUi71U+H1Tn8zFq0NNvpsd3Vzs03fi
        0FMlvydqFyarVF3Qbn3Y039Sej/X1bC7C4W4/T1eLGN00Go7rbio96vUKXZhRaPKyhU1OTsT
        DuS+qTITvlelsf3MT7OjVvG7qtq2HprRcKYr2dTbhVM18MJ3kXdr0tamWkyZ90RueWLufOOt
        gUHyk9bu+e9jPv+JvvHCE/+2zrhXXXMgZC7LuRsC/v5cypxKLMUZiYZazEXFiQCW4OUG+gIA
        AA==
X-CMS-MailID: 20221028154452uscas1p12fbf5143b7b41f22f08fa0f93791a092
CMS-TYPE: 301P
X-CMS-RootMailID: 20221028154452uscas1p12fbf5143b7b41f22f08fa0f93791a092
References: <CGME20221028154452uscas1p12fbf5143b7b41f22f08fa0f93791a092@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Ankit Kumar and I have another fio blog post covering more features of xNVM=
e and fio's xNVMe ioengine.

We discuss the polling options available from xNVMe and also provide exampl=
es and performance comparisons including coverage of the new io_uring comma=
nd ioengine and backend. We wrap up with a short discussion of xNVMe's SPDK=
 backend. Take a look!

https://github.com/vincentkfu/fio-blog/wiki/xNVMe-ioengine-Part-2

Feedback is welcome!

Vincent
