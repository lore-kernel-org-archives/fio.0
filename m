Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD17C43334
	for <fio@archiver.kernel.org>; Wed, 22 Jun 2022 12:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiFVM3f (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 22 Jun 2022 08:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbiFVM3f (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Jun 2022 08:29:35 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B83462F8
        for <fio@vger.kernel.org>; Wed, 22 Jun 2022 05:29:32 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220622122928epoutp01841c8ef98b53541f793dd5a04bf4af3d~68ShgjwHo0638606386epoutp01I
        for <fio@vger.kernel.org>; Wed, 22 Jun 2022 12:29:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220622122928epoutp01841c8ef98b53541f793dd5a04bf4af3d~68ShgjwHo0638606386epoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1655900968;
        bh=GstNBZLyDPfY5sddW9Tihw0CAIf+xyRCu7eoMBQk62M=;
        h=From:To:Cc:Subject:Date:References:From;
        b=T2s5O493ab/sjMbw3ly9Wr7mtVdHIGgiiGhOBIylWq5rAdW2AA6eROA0GUpnh3J/n
         b5jbc6/d5K4+flj4hwionvNUPYoDA73t76Ic7Sg52JCf5YH/x1HuvszN/a3KwPnTHL
         5NqC4uOdmPW89k9jxj75vRJnEiiDyng07Kj8rLcA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220622122928epcas5p47e7cdd0575cb159b7c72544272f37e94~68ShH5bSJ0367703677epcas5p4R;
        Wed, 22 Jun 2022 12:29:28 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4LSjPM18C7z4x9Pp; Wed, 22 Jun
        2022 12:29:27 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1F.42.09639.72B03B26; Wed, 22 Jun 2022 21:29:27 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220622113122epcas5p209ab7fab23d77d895b8a16ccf812041f~67fyuv9sV2353323533epcas5p2Z;
        Wed, 22 Jun 2022 11:31:22 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220622113122epsmtrp1b189a5618c2046b7f2ad62d32a861eeb~67fyuHu4z2510325103epsmtrp1a;
        Wed, 22 Jun 2022 11:31:22 +0000 (GMT)
X-AuditID: b6c32a4b-e6dff700000025a7-2d-62b30b269782
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1D.62.08905.A8DF2B26; Wed, 22 Jun 2022 20:31:22 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220622113121epsmtip25e75c377a41be86f07b86444027a8eac~67fxztXCU2168521685epsmtip2a;
        Wed, 22 Jun 2022 11:31:21 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/1] *** option to disable xnvme build even if found ***
Date:   Wed, 22 Jun 2022 16:55:45 +0530
Message-Id: <20220622112546.13503-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsWy7bCmuq469+Ykg8/7mS3WXPnNbrH6bj+b
        xcdZL5gtFm5cxuTA4nH5bKlH35ZVjB6fN8kFMEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8eb
        mhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYALVNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2Cql
        FqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGf8u6JdcISp4uSbxawNjL8Zuxg5OSQETCQ+
        3zjB1sXIxSEksJtRou3LFVYI5xOjxIUFl1ggnG+MEtdvbWSCadk9rw0qsZdR4tGZ+UwQTiuT
        xILeBewgVWwC2hKv3t5gBrFFBIQl9ne0soDYzAKREp/+zWQFsYUFPCTaluwFm8oioCpxfk4H
        2FG8AjYSS3/OgzpQXmL1hgPMIAskBJrZJVp3zmOGSLhIXLoJ84WwxKvjW9ghbCmJl/1tUHa2
        xKaHP6HOLpA48qIXqtdeovVUP5DNAXSQpsT6XfoQYVmJqafWMUHcySfR+/sJVCuvxI55MLaq
        xN97t1kgbGmJm++uQtkeEkc+zmIDsYUEYiUOrLvEPIFRdhbChgWMjKsYJVMLinPTU4tNC4zz
        UsvhEZWcn7uJEZyGtLx3MD568EHvECMTB+MhRgkOZiURXhvuDUlCvCmJlVWpRfnxRaU5qcWH
        GE2BYTaRWUo0OR+YCPNK4g1NLA1MzMzMTCyNzQyVxHm9rm5KEhJITyxJzU5NLUgtgulj4uCU
        amDaav5yj279moK3detnflVeHOvoqHLYlO2aLq+su+OfJ7K3tE+2JTee/fMsMXDzgQd2fQ31
        E+fMW8rmx/7m9L/qhGU3LVxkdWfMY99vXGt4b87UmptBlSXVnmZFd96asSpP65m7jPf0Ez7B
        vjzfYPWMAOfNzEXmXSt0bNpiE2cUX/WNFWyadaCcja3vtZfjwviX5qyBkeFznyoca99jHS58
        aa+14ax/fvqPI89vfPJp91GxlYWLima0Zp/RefbrOsfZBx7ep8Wy/NcuNHlsvj7l/THvz/8/
        xSReXiRVWqC/LvSHS4OvVHbvkz/hRj9c/1wsOvFLuz8jtX3lyp8SRfdmnGlz93Jdy7n0l2le
        03klluKMREMt5qLiRADs7GbuzAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsWy7bCSvG7X301JBrffSFqsufKb3WL13X42
        i4+zXjBbLNy4jMmBxePy2VKPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyvh3RbvgCFPFyTeL
        WRsYfzN2MXJySAiYSOye18bSxcjFISSwm1GiZdZ8ti5GDqCEtMTC9YkQNcISK/89Z4eoaWaS
        eNjQAdbMJqAt8ertDWYQWwSoaH9HKwuIzSwQLbH/TDOYLSzgIdG2ZC8TiM0ioCpxfg5EL6+A
        jcTSn/OgjpCXWL3hAPMERp4FjAyrGCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGCw0FL
        cwfj9lUf9A4xMnEwHmKU4GBWEuG14d6QJMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB
        9MSS1OzU1ILUIpgsEwenVANT+1Rm7sW3Z6kbfq3Z+iX3tU3HsS+dQb5CPWfKHxw2Svj7VVl/
        C7tXyeO/r6ZJ9Gu5Gb8VO2Ms+U/p8dUUvthj2bl3xfy3TvygVTNng63rpkyd5PAThYVHV2iJ
        W08p8/E1y1qtGhivceemcoPF4mWFvS5Tf+TM3dmaeaYxJURyw0/r014FN5zmeKtKyOw5PDf/
        MDfDbwOtzx4XnmisFW/eZRpe1fZwgu1GmVSbZ9EHnxqcmVr6ovhdT1oOX+w75aTJorlHXv09
        a5/ybcJkBrkPt3xlHSatXFbeLGPX7y0uaR7V91H0Ws0DrnRmrt/CC06csDrFdOC1/9TiPcxe
        J8Q1ri94lHs4zSv+xCe/JBYlluKMREMt5qLiRADB8RHmdgIAAA==
X-CMS-MailID: 20220622113122epcas5p209ab7fab23d77d895b8a16ccf812041f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220622113122epcas5p209ab7fab23d77d895b8a16ccf812041f
References: <CGME20220622113122epcas5p209ab7fab23d77d895b8a16ccf812041f@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add config option to disable xnvme ioengine build even if
its support is present. Remove enable xnvme build option
as by default we are anyway probing for it.

Ankit Kumar (1):
  configure: add option to disable xnvme build

 configure | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.17.1

