Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF681C43217
	for <fio@archiver.kernel.org>; Fri, 18 Nov 2022 05:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbiKRFjH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 18 Nov 2022 00:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbiKRFjF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Nov 2022 00:39:05 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9578719008
        for <fio@vger.kernel.org>; Thu, 17 Nov 2022 21:38:55 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221118053852epoutp039d75cb05952c4382f865295f243695de~olzjHVXvl1067710677epoutp03n
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 05:38:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221118053852epoutp039d75cb05952c4382f865295f243695de~olzjHVXvl1067710677epoutp03n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668749932;
        bh=2lzbE6nJp7k2Wf9GjFyJvr9wuloYiK4dP0UD8NGefx0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=CM21rdsg2P///XfUCDfCEYePAGBJb/7cwnkbzb4LZiVGfo2iEl2ciszM8vBjJOZcP
         wZ+moYfXKOfSKVSaDK6k8cJpS6WTumm54Fox97FHybUGuJ727VMbgKwUoyyNsOEwez
         PfhQ7CAmyAHoYFSGx4ihiDzg8K8rLeabN7LE5044=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221118053851epcas5p1473f65ad81ed0f1e61d4804396ff7264~olzidvSw41759817598epcas5p18;
        Fri, 18 Nov 2022 05:38:51 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4ND5Dn2H3rz4x9QC; Fri, 18 Nov
        2022 05:38:49 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BF.34.39477.96A17736; Fri, 18 Nov 2022 14:38:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221118052632epcas5p48ffea1e5c9b88f99b2bc90147e93321d~oloyCzoUF3267232672epcas5p4n;
        Fri, 18 Nov 2022 05:26:32 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221118052632epsmtrp1475bc816926f5c4ecc25fad8f7907752~oloyCNKxW2947929479epsmtrp1X;
        Fri, 18 Nov 2022 05:26:32 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-22-63771a69e46b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        24.55.18644.88717736; Fri, 18 Nov 2022 14:26:32 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221118052631epsmtip19b165c048446c8de89571003d2a9da7e~oloxVAcKU2282222822epsmtip1L;
        Fri, 18 Nov 2022 05:26:31 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/2] Fix percentage random workload and add test case
Date:   Fri, 18 Nov 2022 10:44:52 +0530
Message-Id: <20221118051454.31288-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsWy7bCmpm6mVHmywf4ePos1V36zW6y+289m
        8XHWC2aLDW2CDiweO2fdZfe4fLbUo2/LKkaPz5vkAliism0yUhNTUosUUvOS81My89JtlbyD
        453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYqKZQl5pQChQISi4uV9O1sivJLS1IVMvKL
        S2yVUgtScgpMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7IzFv7byFbwnaPi8+f/LA2Mk9m7GDk5
        JARMJBqPnmMFsYUEdjNKdD+P7WLkArI/MUos2bGbGcL5zCgx5/8xVpiOKa/+MEIkdjFKTH31
        HMppZZKY1HiXBaSKTUBb4tXbG8wgtoiAsMT+jlawOLNAqMTJa1/AdgsLuEr8u36GEcRmEVCV
        +LlwKpjNK2Aj8WHBZCaIbfISqzccADtDQqCfXWLl4ZtQCReJJW9fQj0hLPHq+BYoW0riZX8b
        lJ0tsenhT6j6AokjL3qZIWx7idZT/UA2B9BBmhLrd+lDhGUlpp5axwRxJ59E7+8nUK28Ejvm
        wdiqEn/v3WaBsKUlbr67CmV7SMxd184CCcdYiUvvzzNNYJSdhbBhASPjKkbJ1ILi3PTUYtMC
        o7zUcnhEJefnbmIEpyMtrx2MDx980DvEyMTBeIhRgoNZSYQ392JpshBvSmJlVWpRfnxRaU5q
        8SFGU2CYTWSWEk3OBybEvJJ4QxNLAxMzMzMTS2MzQyVx3sUztJKFBNITS1KzU1MLUotg+pg4
        OKUamFh0/8X1/dnb9GCJtufBA1rXdBLL75786XhVLnfqtMKMyXNFZq76fk40+MDTiR+WvPdz
        DWe60uVw7ox8Vtd353MWX5a2W58PNPQtfmTYtnlFVI3q1TWigt/KbycFy5vsvrI/J+HILP3w
        Ny94JylOC3qwwfzS543bqtd0PRI31ZQ+Jb5Q/veV/536ajH3bGPqioyu3Fd5aPPu8F5+nely
        G9d+Fpt1ukQ4Y8Pet/1B9r33D7qFli8Pm+t52cg2Seqgm/P+OxyZ2o6xV5UPhW9fMluXf+Pz
        a9ziUa0G/sUbDj4vSis75hkRIi7k+OWoymexFyEPalQ0b5tPvlC040NeTu+uhjm8TDFvZzAv
        zuBe2qbEUpyRaKjFXFScCAAXgGZz0AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsWy7bCSnG6HeHmywa3rLBZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGUs/LeRreA7
        R8Xnz/9ZGhgns3cxcnJICJhITHn1h7GLkYtDSGAHo8TFH6tZuhg5gBLSEgvXJ0LUCEus/Pcc
        rF5IoJlJYsvpeBCbTUBb4tXbG8wgtghQzf6OVhYQm1kgXGL6gcmMILawgKvEv+tnwGwWAVWJ
        nwungtm8AjYSHxZMZoKYLy+xesMB5gmMPAsYGVYxSqYWFOem5xYbFhjlpZbrFSfmFpfmpesl
        5+duYgSHhZbWDsY9qz7oHWJk4mA8xCjBwawkwpt7sTRZiDclsbIqtSg/vqg0J7X4EKM0B4uS
        OO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBiZFRsl/Mxn2vDj3UnrjgV19xo0+sfkrHfIrGtcf
        XhTZd++vdvQuoxW6dQX7OG2YD1yMfv0pn/3vLiW9e5FNGcs9wpKf/5yn01JxUODuDNP3gWrt
        YUsu1woXb/Q3mm/+VGNd4aOLmpI3hJrvzL3ddnDb31c5L917Tmv9mcGX/aPHo3CfWrus7KUn
        x87PW39291rpl6nWf93XmVvKPOQN7Giws1zOV8K4lr1PYfum8vJ4qVTW8j0LPJuStpWxTxdu
        /Gz0n1347/r33s4aTr/ePtQtPeS2Kvenuex13rkyxzb5MU49wLBwPRvr5HaOK+516/9OlJBN
        iHx8qyFToMt/PzfvWiPdWu+dh/xq5tR9f6LEUpyRaKjFXFScCACnUVCEegIAAA==
X-CMS-MailID: 20221118052632epcas5p48ffea1e5c9b88f99b2bc90147e93321d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221118052632epcas5p48ffea1e5c9b88f99b2bc90147e93321d
References: <CGME20221118052632epcas5p48ffea1e5c9b88f99b2bc90147e93321d@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Sometimes while running a mix of sequential and random I/O's the
generated sequential offset is outside the I/O region. This usually
happens if the previous I/O is the last block in the region which
results in this sequential I/O offset to be just outside the region.
This results in fio finishing without doing the specified amount of
I/O's.
With this fix fio now generates a random offset within the region.

Added a test case for the same (test_id: 28)
As I see there is a pending patch with test_id: 27
so I decided to skip it to avoid conflict.

This now fixes the issue: https://github.com/axboe/fio/issues/1486

Ankit Kumar (2):
  io_u: fix offset generation for mix of random and sequential workload
  test: add test for mix random and sequential workload

 io_u.c                |  5 ++++-
 t/jobs/t0028-post.fio | 27 +++++++++++++++++++++++++++
 t/jobs/t0028-pre.fio  | 21 +++++++++++++++++++++
 t/run-fio-tests.py    | 34 ++++++++++++++++++++++++++++++++++
 4 files changed, 86 insertions(+), 1 deletion(-)
 create mode 100644 t/jobs/t0028-post.fio
 create mode 100644 t/jobs/t0028-pre.fio

-- 
2.17.1

