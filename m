Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B47C2BB41
	for <fio@archiver.kernel.org>; Tue, 16 Aug 2022 08:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbiHPIVu (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 16 Aug 2022 04:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbiHPIUv (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 16 Aug 2022 04:20:51 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497822CE0F
        for <fio@vger.kernel.org>; Mon, 15 Aug 2022 23:04:09 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220816060407epoutp02c300a3de9b0cb7db19711789be506ce1~Lvgwop04w3196531965epoutp02E
        for <fio@vger.kernel.org>; Tue, 16 Aug 2022 06:04:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220816060407epoutp02c300a3de9b0cb7db19711789be506ce1~Lvgwop04w3196531965epoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660629847;
        bh=sx9KZK66dlLUe0RUvDxnE0bzk9ZGqqXkmeH6CBJBdFs=;
        h=From:To:Cc:Subject:Date:References:From;
        b=k23aWH6+KKOQxhbAnX0cna4CaUsAq5cJ2ITh03NMpl7uB+btm86uT9XF4WIA6QU9x
         bcHUO2YZpvj6IyCqyHu7Q5djqP2GewAXY4sGMsZ/gM6nH8i2e52Ql72IJGdov3dksh
         HEWpik5AcQpkvPBNK3B6y0nrwwK0xGSOMA4bivyA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220816060406epcas5p129594d311a0f541006f8f0b1ef57c341~Lvgv5Xxw82874828748epcas5p1r;
        Tue, 16 Aug 2022 06:04:06 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4M6LFH01hNz4x9Q6; Tue, 16 Aug
        2022 06:04:03 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6B.D3.49477.C433BF26; Tue, 16 Aug 2022 15:03:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220816054808epcas5p2295e7b76603cdd2183f9e2c2698cd90a~LvSz6DfbB2625726257epcas5p2b;
        Tue, 16 Aug 2022 05:48:08 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220816054808epsmtrp170a8b225414b47646a4b6c4f7712ce60~LvSzdP_CP2229122291epsmtrp1g;
        Tue, 16 Aug 2022 05:48:08 +0000 (GMT)
X-AuditID: b6c32a49-843ff7000000c145-90-62fb334c11ab
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        66.DA.08802.79F2BF26; Tue, 16 Aug 2022 14:48:07 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220816054807epsmtip1c59b2885b46e45c25f298a2164e5d975~LvSyv9hfP1625416254epsmtip1x;
        Tue, 16 Aug 2022 05:48:07 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     vincent.fu@samsung.com, fio@vger.kernel.org,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/2] *** Two small patches for xnvme I/O engine ***
Date:   Tue, 16 Aug 2022 11:08:19 +0530
Message-Id: <20220816053821.440-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsWy7bCmuq6P8e8kg+5ThhZrrvxmt1h9t5/N
        4uOsF8wWj7s7GB1YPC6fLfXo27KK0ePzJrkA5qhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hT
        MwNDXUNLC3MlhbzE3FRbJRefAF23zBygZUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XU
        gpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7Iwdzy+wFexgrtj/fQ1TA+NNpi5GTg4JAROJ
        jvm/GEFsIYHdjBJLDsl0MXIB2Z8YJVZPucYE4XxmlFj67x0LTMeX55/YIRK7GCWezfjBCuG0
        MkkseHYQbBabgLbEq7c3mEFsEQFhif0drUDdHBzMAhESJ194gISFBZwlVkw7yA5iswioStzp
        fgxm8wpYSXxsecsIsUxeYvWGA8wg8yUEmtklehffZoVIuEg0fJjBDGELS7w6voUdwpaSeNnf
        BmVnS2x6+BPqzwKJIy96oertJVpP9TND3KMpsX6XPkRYVmLqqXVg5cwCfBK9v59AtfJK7JgH
        Y6tK/L13GxoQ0hI3312Fsj0k7r6czgQyUkggVuLLOssJjLKzEBYsYGRcxSiZWlCcm55abFpg
        mJdaDo+m5PzcTYzgFKTluYPx7oMPeocYmTgYDzFKcDArifAKvviRJMSbklhZlVqUH19UmpNa
        fIjRFBhkE5mlRJPzgUkwryTe0MTSwMTMzMzE0tjMUEmc1+vqpiQhgfTEktTs1NSC1CKYPiYO
        TqkGJsFs9wNuKn4N067oLm08z1reezMm0Xw9X2mN9wV2j/9vr/2fwqP7lmFfw8Kcvvsl8bt2
        2mSfsheqalr7zl2/c8m6ueGp7+MKd/dy+O/mUHSVdS9PYHy3TzpI6qum2u4VPa/f/V+xc8pS
        qUjzt2+4Kp1WsG/TiH7O1qXhNX8X/8G3nbPWdapd+fftxku5133CsV8CJLYfWlFjK+Z6i+ed
        VVLnhrluizgl1CZ/XZ/0fW2mZcGM2zYV6VsWfv/5R/LdvLVKRkpMR7u71i64oKzK3WExTUrw
        QMpxgyUf1kxTsl6x3J+Pt6e1Q2Zy3p1/Um7LFFhD+T9kbfrVm7WzkE/E9VnYkYIUKafS17wm
        9uFflFiKMxINtZiLihMBKD9K2soDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJMWRmVeSWpSXmKPExsWy7bCSnO50/d9JBteXW1qsufKb3WL13X42
        i4+zXjBbPO7uYHRg8bh8ttSjb8sqRo/Pm+QCmKO4bFJSczLLUov07RK4MnY8v8BWsIO5Yv/3
        NUwNjDeZuhg5OSQETCS+PP/E3sXIxSEksINRYt3e80AOB1BCWmLh+kSIGmGJlf+eQ9U0M0l8
        3NAK1swmoC3x6u0NZhBbBKhof0crC4jNLBAl8fDyRTBbWMBZYsW0g+wgNouAqsSd7sdgNq+A
        lcTHlreMEAvkJVZvOMA8gZFnASPDKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4IDQ
        0trBuGfVB71DjEwcjIcYJTiYlUR4BV/8SBLiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQ
        QHpiSWp2ampBahFMlomDU6qBSfrpdt7v0SrcHkp+Ooc8d1y/OSPUwDDpFhtDU86ClOOy37Xd
        Pe9ff66beevgC9ebgdL861eImU2qPPAlXyZfd6NLkU/nixBG9SD++ukLlsslPvVn/Dz3s7rc
        3bJV31alJu+7a/JBa+N8adZJgfweWo3Bi/u3nHj02uFQ1I+pcXm+Sw+FOBxs2cW4R3cXc8T7
        ScUrios6uv0Xvwg3VHtdWfjUMELlbXKK3oNEkf6uP12NunZOthps7571ruZqWlzHJVu2S655
        44rXvYc5ViUlWtS5Ht3EcqP7q9c3pj5dbmbFIoN1mvO3v36Xf7YnaWe35+1HvGJ50+s9pt/g
        PZkg2n474Le1zN1HDQeKKl8psRRnJBpqMRcVJwIAf2YHR3cCAAA=
X-CMS-MailID: 20220816054808epcas5p2295e7b76603cdd2183f9e2c2698cd90a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220816054808epcas5p2295e7b76603cdd2183f9e2c2698cd90a
References: <CGME20220816054808epcas5p2295e7b76603cdd2183f9e2c2698cd90a@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Fix segmentation fault issue if thread=1 is not specified.
Update the fio documentation.

Ankit Kumar (2):
  engines/xnvme: fix segfault issue with xnvme ioengine
  doc: update fio doc for xnvme engine

 HOWTO.rst       | 37 ++++++++++++++++++++++++++-----------
 engines/xnvme.c | 17 ++++++++++++++---
 fio.1           | 34 +++++++++++++++++++++-------------
 3 files changed, 61 insertions(+), 27 deletions(-)

-- 
2.17.1

