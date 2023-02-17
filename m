Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8003C05027
	for <fio@archiver.kernel.org>; Fri, 17 Feb 2023 07:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjBQHIe (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 17 Feb 2023 02:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBQHId (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 17 Feb 2023 02:08:33 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4877A83FF
        for <fio@vger.kernel.org>; Thu, 16 Feb 2023 23:08:30 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230217070825epoutp04368acd2bf390a177c29914bcf086a6f6~EiuuhXHSL1476114761epoutp04W
        for <fio@vger.kernel.org>; Fri, 17 Feb 2023 07:08:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230217070825epoutp04368acd2bf390a177c29914bcf086a6f6~EiuuhXHSL1476114761epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1676617705;
        bh=dcpDuu6TOQH9ME/Af6tJKJObo5nsjbF+GIdmpCkaA6U=;
        h=From:To:Cc:Subject:Date:References:From;
        b=dqF9RlG4RXJKZ0egHsGR6+JDMc9/XaLKiYuGY/Yb3LfFElCEWFxPDp0JHZvfLtRkT
         IDfO6SuEKJUkhoXScV80cLvrhQiDPD/I1wukkUxaLiTTreRhBsZXcoyHYSuE5JVhGx
         MnVnI9SBDDneU6THUgu/ZzZkP+NgXHj1RzZ32pw4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230217070825epcas5p26161277169a7e30812e3a16782a744af~EiuuEi_ca0794507945epcas5p2c;
        Fri, 17 Feb 2023 07:08:25 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4PJ2w81p9hz4x9Q3; Fri, 17 Feb
        2023 07:08:24 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4B.93.06765.7E72FE36; Fri, 17 Feb 2023 16:08:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230217070403epcas5p1f2c7eec62578c28429e8029681f7d341~Eiq5tI0Jx1251912519epcas5p1-;
        Fri, 17 Feb 2023 07:04:03 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230217070403epsmtrp20c1be2c3741c2f1a8d9c26343e7a5cf7~Eiq5se_vT2856128561epsmtrp2k;
        Fri, 17 Feb 2023 07:04:03 +0000 (GMT)
X-AuditID: b6c32a4b-46dfa70000011a6d-46-63ef27e79ba5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.4C.05839.2E62FE36; Fri, 17 Feb 2023 16:04:02 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230217070402epsmtip192df05daa03a911a8e3ab9c5c5b1aa6c~Eiq4_diST1404814048epsmtip1Z;
        Fri, 17 Feb 2023 07:04:02 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/1] fix runtime when used with thinktime
Date:   Fri, 17 Feb 2023 12:33:21 +0530
Message-Id: <20230217070322.14163-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsWy7bCmpu5z9ffJBl1rJC3WXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOaPjxirXgFkvFuiPPWBsYnzF3MXJy
        SAiYSKx+fpG1i5GLQ0hgN6PE4dU/2SCcT4wSzx9cZYdwvjFKTPm3iQWmpfXbM0aIxF5Giad9
        PVD9zUwS6269ZwKpYhPQlnj19gbYEhEBYYn9Ha1g3cwCoRInr31hB7GFBSwljr39yQpiswio
        Smyb+BasnlfARuLush+MENvkJVZvOMAMskBCoJ9dYlnzRjaIhIvEvcvnoWxhiVfHt7BD2FIS
        n9/thYpnS2x6+JMJwi6QOPKiF+pre4nWU/1ANgfQQZoS63fpQ4RlJaaeWscEcSefRO/vJ1Ct
        vBI75sHYqhJ/792GhoS0xM13V6FsD4nmxpVgtpBArMTfRfOYJjDKzkLYsICRcRWjZGpBcW56
        arFpgXFeajk8ppLzczcxghOSlvcOxkcPPugdYmTiYDzEKMHBrCTCu+nmm2Qh3pTEyqrUovz4
        otKc1OJDjKbAMJvILCWanA9MiXkl8YYmlgYmZmZmJpbGZoZK4rzqtieThQTSE0tSs1NTC1KL
        YPqYODilGphS9Gf2fX+j+Ihb5OPF8xznZEy2i/fUHuWwMr5k2rlaVuCQk+pswxUMr3c9llz7
        c+3e3J/L/F2yJacc6Z7f/P6Gz2lro79/nn85cl8utTpP7udbl5vr46cdPuR0Jbt8qaeGT82L
        WUJMk3Vk28rktZZVJE9OPpS2sTujTv7wHCfe2vL6esXQV0w1Ey51v8+47bTMNGqr/0k30X/S
        EiUHw+7qTy1omJ+bmsYZOaWtlz1kzxXhZz2OljUm0unalQrBfM3zbn0/GFRmXnLR7stxxcDs
        ZWtW1x/oEcpi1n3F1xCRFbpCxkx+WaLI9FLZLfOZc34eP3vq+M7TRk1fTn1yWP7jINtLhppD
        GjzuzUdNXiixFGckGmoxFxUnAgA11sLr0QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsWy7bCSnO4jtffJBguvWlmsufKb3WL13X42
        i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXR8OMVa8Et
        lop1R56xNjA+Y+5i5OSQEDCRaP32jLGLkYtDSGA3o8Skd9fYuxg5gBLSEgvXJ0LUCEus/Pec
        HaKmkUnixex2sGY2AW2JV29vgNkiQEX7O1pZQGxmgXCJ6QcmM4LYwgKWEsfe/mQFsVkEVCW2
        TXwLVs8rYCNxd9kPRogF8hKrNxxgnsDIs4CRYRWjZGpBcW56brFhgWFearlecWJucWleul5y
        fu4mRnBgaGnuYNy+6oPeIUYmDsZDjBIczEoivJtuvkkW4k1JrKxKLcqPLyrNSS0+xCjNwaIk
        znuh62S8kEB6YklqdmpqQWoRTJaJg1Oqgam17sgvqWuMl2e6X37qq/o90mWZxr039rsLtAun
        TTna6//uTPQCn3Mrl3+aOVMpbOOTbHu9HOWKs62HtZfVnZZYclBRZEM1g0KHn5WOutQF0xt5
        /+Vnc/QbtW/lL1kfGXThftNiffXGBbuFPpw76xIV7brNrut9fZDrFBtDiya5w3Vsq8vXvluu
        sPLTvZ6LR1svR0da280NL2p+uFUwb+EG1VqhTd8eJlusN3Tdm/HvSczrnj9PD/RvS7BeczXs
        4IqDglOvOB+PeFfwSeVfm/6cZYckqt4JigZqTZE60y7/SLmh7Qmb3JtkFS9BIwdDvq9lu/eZ
        eMjFrn3/u8VI9plfrdO670wr+A4oqx1x3aLEUpyRaKjFXFScCAD2dqc4ewIAAA==
X-CMS-MailID: 20230217070403epcas5p1f2c7eec62578c28429e8029681f7d341
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230217070403epcas5p1f2c7eec62578c28429e8029681f7d341
References: <CGME20230217070403epcas5p1f2c7eec62578c28429e8029681f7d341@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Runtime for fio jobs when used in conjuction with thinktime,
thinktime_iotime and thinktime_spin were sometimes more than
what is specified. Added a fix so that fio doesn't spin or sleep
for any duration beyond runtime.

For the first cycle when we specify thinktime and thinktime_iotime,
fio starts by doing I/O for thinktime + thinktime_iotime, which
should just be for thinktime_iotime. Addedd a fix for that.

Ankit Kumar (1):
  backend: fix runtime when used with thinktime

 backend.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

-- 
2.17.1

