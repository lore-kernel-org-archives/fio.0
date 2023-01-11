Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C93AC67871
	for <fio@archiver.kernel.org>; Wed, 11 Jan 2023 06:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjAKG4f (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 11 Jan 2023 01:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbjAKG4A (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 Jan 2023 01:56:00 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E068FF5
        for <fio@vger.kernel.org>; Tue, 10 Jan 2023 22:55:55 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230111065553epoutp03c2c9b11a0513df4f7b992e86efa99492~5LsOLfTsQ2169421694epoutp03I
        for <fio@vger.kernel.org>; Wed, 11 Jan 2023 06:55:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230111065553epoutp03c2c9b11a0513df4f7b992e86efa99492~5LsOLfTsQ2169421694epoutp03I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1673420153;
        bh=WS2HGQH7FMqNpqNyHvHyzvFlUCUVCXuR0ZO4X2iGNc8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=mrpHYn3nKfNF0wF+g02B3jNg7z7WiA8udXBGACjseBGrdtjn7YhkkX22YjTWccaPh
         rCV4r/oUEHaqkHEJAs2UawFjWNpsQXHEQ4FPSXjME2KmFdX3TTKnXwpd8jPzL+eB92
         H0fl1Dwc35/JpXhvLoXWFE2dayrjxjyszGj2VjL0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230111065553epcas5p427f42d9796b54757fbe401767a24ffe4~5LsNalqbN2604226042epcas5p4V;
        Wed, 11 Jan 2023 06:55:53 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4NsJNl2ndpz4x9Pw; Wed, 11 Jan
        2023 06:55:51 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        40.73.62806.77D5EB36; Wed, 11 Jan 2023 15:55:51 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230111064841epcas5p3b26ec4b04ab5ddbfc5ce4caea0dc4687~5Ll7kbpc_2398823988epcas5p3j;
        Wed, 11 Jan 2023 06:48:41 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230111064841epsmtrp1f6b02a5ba38f4de1027bb535be6704c4~5Ll7jyLaD1758417584epsmtrp1K;
        Wed, 11 Jan 2023 06:48:41 +0000 (GMT)
X-AuditID: b6c32a4a-c43ff7000000f556-fb-63be5d775a80
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        53.AD.02211.9CB5EB36; Wed, 11 Jan 2023 15:48:41 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230111064840epsmtip24aca92f35123edbaf43f1019093ffe7a~5Ll60jvp50277102771epsmtip2R;
        Wed, 11 Jan 2023 06:48:40 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 0/1] Update doc for option rw_sequencer
Date:   Wed, 11 Jan 2023 12:18:04 +0530
Message-Id: <20230111064805.10001-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsWy7bCmlm557L5kg57tIhZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYppOYl56dk5qXbKnkH
        xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
        l9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnzDpwmbngNHPF93OzWRoYvzF1MXJy
        SAiYSBxafJSxi5GLQ0hgN6PEhW07WSCcT4wSh2a+YIZwvjFKTGndzgzTMuF1NxtEYi+jxK+e
        K6wQTjOTxJ+Hr9lBqtgEtCVevb0B1iEiICyxv6OVBcRmFgiVOHntC1iNsICVxL3fG8AOYRFQ
        lfh5dz4biM0rYCOx/ssZRoht8hKrNxwAO0NCoJ9d4mr/VKjLXSSOn53NBmELS7w6voUdwpaS
        eNnfBmVnS2x6+BOqvkDiyIteqBfsJVpP9QPZHEAHaUqs36UPEZaVmHpqHRPEnXwSvb+fQLXy
        SuyYB2OrSvy9d5sFwpaWuPnuKpTtIXHz9GOwc4QEYiW+PbvAOIFRdhbChgWMjKsYJVMLinPT
        U4tNC4zyUsvhMZWcn7uJEZyQtLx2MD588EHvECMTB+MhRgkOZiUR3pWce5KFeFMSK6tSi/Lj
        i0pzUosPMZoCw2wis5Rocj4wJeaVxBuaWBqYmJmZmVgamxkqifOmbp2fLCSQnliSmp2aWpBa
        BNPHxMEp1cDErv3GtqF1As/Gwxbuay//rN/OfXjO9tqdU2TZPB5Mtf1oMO2QXtrUPYKKFwOy
        bpyRT5N5t3HewYwd13fJy8XN6v3Koae0P/Sa2bzV3rmp7+e9D/4cfLC0NNbRxUxw/4L8jj4u
        nsb239/kRU80/OPd1V17q2YS/+7Fp1hfZAuzZh78dCdp4f5NX1+kVNZu/ilu4Hj1Sp50VSB3
        fvW5tlMKR05q5OvZ+ZhffcV2Kb7wg9nvCLGsFwcYgj5mVskl6N20eB8i18wQcufdXu1uY+UZ
        m4Krd5c0TY30cdsgyPgj48ut4NkFkuU7vl7/duz+yy9NR35NKrD/P3nLZ++ePJvnc+xWKkxO
        nJ35X0XM6Z2EEktxRqKhFnNRcSIAz+0nQ9EDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsWy7bCSvO7J6H3JBocfylusufKb3WL13X42
        i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJUx68Bl5oLT
        zBXfz81maWD8xtTFyMkhIWAiMeF1N1sXIxeHkMBuRon1N3+wdjFyACWkJRauT4SoEZZY+e85
        O0RNI5PEj0MnmUESbALaEq/e3gCzRYCK9ne0soDYzALhEtMPTGYEsYUFrCTu/d4AtoxFQFXi
        5935bCA2r4CNxPovZxghFshLrN5wgHkCI88CRoZVjJKpBcW56bnFhgWGeanlesWJucWleel6
        yfm5mxjBgaGluYNx+6oPeocYmTgYDzFKcDArifCu5NyTLMSbklhZlVqUH19UmpNafIhRmoNF
        SZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVAOTSI6M/Mp9F0sUmtf9+S4tpuv4T1DET9SmUGoG
        F8tjNem1E433rPNmevEoa+sJE5ZFR5SqNj7+Fe3lUrbsVTSXumNFqdlmfh7GqzMyRZ+t1uLz
        inBUKg8wevRRN+bDzeo/nkGzIiPKZzbM3Hphlc+bvJBsm7x1B+T7/tU9VirPPa3z4Qvv1wzt
        qU9mrG6pPPhj/U3eG1aRraIS50M3PWesmHbCxMs7gCOx4NuTbbNjHwt/+1xazZ6jzzjZwWCC
        bEdi/e3Hs7fN6H8Yal+7TXd7iHzFzDXveWd6NlaJpYZm/Vl77RSfq3jUCi0Px7NZT46Wdtxa
        v5/11+GLv8+rHn3seDb8nMZ/U8bFUYvzz51WYinOSDTUYi4qTgQAPOxTMHsCAAA=
X-CMS-MailID: 20230111064841epcas5p3b26ec4b04ab5ddbfc5ce4caea0dc4687
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230111064841epcas5p3b26ec4b04ab5ddbfc5ce4caea0dc4687
References: <CGME20230111064841epcas5p3b26ec4b04ab5ddbfc5ce4caea0dc4687@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Fixes: https://github.com/axboe/fio/issues/1223

Changes since v1:
 - Changed the wording for rw_sequencer=sequential as per
   Vincent's feedback.
 - Added few examples explaining about rw_sequencer.

Ankit Kumar (1):
  doc: clarify the usage of rw_sequencer

 HOWTO.rst | 35 ++++++++++++++++++++++++++++-------
 fio.1     | 47 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 69 insertions(+), 13 deletions(-)

-- 
2.17.1

