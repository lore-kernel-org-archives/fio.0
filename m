Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FC4C7EE24
	for <fio@archiver.kernel.org>; Mon, 15 May 2023 05:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbjEOFuI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 15 May 2023 01:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjEOFty (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 15 May 2023 01:49:54 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D473270F
        for <fio@vger.kernel.org>; Sun, 14 May 2023 22:49:47 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230515054942epoutp018356e490da3842cd2d3c1ad49c23f096~fOx1Z-dKQ0635506355epoutp01i
        for <fio@vger.kernel.org>; Mon, 15 May 2023 05:49:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230515054942epoutp018356e490da3842cd2d3c1ad49c23f096~fOx1Z-dKQ0635506355epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1684129782;
        bh=oUDCRyFL0PUPg3EYQPPXpPGqV+NvGZKMXwk4zac8bms=;
        h=From:To:Cc:Subject:Date:References:From;
        b=L+zjg5l6lRoGFF4cSbLcbE//G/J8RnOuaCKhPkCxidz5e6dm8LryX0A3YAV0KniC8
         tZJYsY6wR5/v0wqHJC3vFUyP7Na5uZAhvC5m8L0fp/+FPrE4DJSdMV0ktii1VLJnuu
         MuaVwch+K6nuLNYOq8vfg5g+KV7DQ1xCzALI1yYc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230515054942epcas5p162f389842a0ac024f7ae722be42abe2e~fOx0sFvQD0112701127epcas5p1H;
        Mon, 15 May 2023 05:49:42 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4QKT380gs8z4x9Q7; Mon, 15 May
        2023 05:49:40 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        66.88.57769.1F7C1646; Mon, 15 May 2023 14:49:37 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230515054350epcas5p4643d68a6f79cae867b88be678154329b~fOstar3Sv1342713427epcas5p43;
        Mon, 15 May 2023 05:43:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230515054350epsmtrp23b4c526b1f78a7119a595c7dfff0d3e3~fOstZ6MnD0359303593epsmtrp2i;
        Mon, 15 May 2023 05:43:50 +0000 (GMT)
X-AuditID: b6c32a4a-ccfff7000001e1a9-fc-6461c7f1081a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BF.FC.27706.696C1646; Mon, 15 May 2023 14:43:50 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230515054349epsmtip2df5094abc7d86491bdf989b343dc139a~fOssf0yla0718907189epsmtip2l;
        Mon, 15 May 2023 05:43:49 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 0/2] io_uring_cmd cleanup and fixes
Date:   Mon, 15 May 2023 16:33:38 +0530
Message-Id: <20230515110340.21984-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsWy7bCmpu7H44kpBhOmcFqsufKb3WL13X42
        i4+zXjBbHP3/ls1iQ5ugA6vHzll32T0uny316NuyitHj8ya5AJaobJuM1MSU1CKF1Lzk/JTM
        vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoK1KCmWJOaVAoYDE4mIlfTubovzS
        klSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyM9sebmQoesVf0bONuYFzM
        1sXIySEhYCLx4dpDpi5GLg4hgd2MEpc/zWGEcD4xSkw5NIMFwvnGKPFwySRGmJZv045Atexl
        lHi2/yQrSEJIoJNJ4v+OCBCbTUBb4tXbG8wgtoiAsMT+jlYWEJtZIEvixIo2IJuDQ1jATOLn
        tmyQMIuAqsTT3/vBTuIVsJHY9Ok0K8QueYmZl76zQ8QFJU7OfAI1Rl6ieetsZpAbJAS2sUsc
        mrqDGaLBReLT0YtQtrDEq+Nb2CFsKYnP7/ZC/ZwtsenhTyYIu0DiyIteqHp7idZT/cwgtzEL
        aEqs36UPEZaVmHpqHRPEXj6J3t9PoFp5JXbMg7FVJf7eu80CYUtL3Hx3Fcr2kPj29BrYu0IC
        sRJvf5pMYJSfheSbWUi+mYWweAEj8ypGydSC4tz01GLTAqO81HJ4rCbn525iBKc8La8djA8f
        fNA7xMjEwXiIUYKDWUmEt31mfIoQb0piZVVqUX58UWlOavEhRlNgEE9klhJNzgcm3bySeEMT
        SwMTMzMzE0tjM0MlcV5125PJQgLpiSWp2ampBalFMH1MHJxSDUzWE8/tTPnr45neevfZ/4tv
        PpvFZ92t3mC91OrXyYd3kxeGhFxaYzm5qGz5M041H5vpNVOOPNGZzvxz06Xze5wj9RlY9LtE
        XFs22vw6lp7g95VLa93Bh0LRs+cZBscviFJY/Oz3X4ckTcVvMtc01u3Ss3JOklQ08D1xceuG
        Rtmvxz77TlIxTJ52V6A7frvQ7RVnFH/duOLinviZOyCxk1X/R5S+Ted9cQ+2ohUyel1xGVNP
        d8+3vyPx4oAKo5adi/ULq6wa3V3RCSkfrDr/vZ4bl7X2wd2/c9KZ+EufdNQxCTjsOHtj1/TX
        qZNY5v585pSQleZe1rus6G3/hq1dGw+ccHT6Nmvlwf3yEdNyVlYpsRRnJBpqMRcVJwIAcIS8
        fwIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsWy7bCSvO60Y4kpBncXqVisufKb3WL13X42
        i4+zXjBbHP3/ls1iQ5ugA6vHzll32T0uny316NuyitHj8ya5AJYoLpuU1JzMstQifbsEroz2
        x5uZCh6xV/Rs425gXMzWxcjJISFgIvFt2hGmLkYuDiGB3YwSZ3c+Yexi5ABKSEssXJ8IUSMs
        sfLfc3aImnYmiS19x1hBEmwC2hKv3t5gBrFFgIr2d7SygPQyC+RJfFulAmIKC5hJ/NyWDVLB
        IqAq8fT3frC1vAI2Eps+nWaFGC8vMfPSd3aIuKDEyZlPWEBsZqB489bZzBMY+WYhSc1CklrA
        yLSKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4+LQ0dzBuX/VB7xAjEwfjIUYJDmYl
        Ed72mfEpQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTDZ
        Tr/medXoRetr9mjh2tVh0Xu0lob+W+CrvSYyYPvSUKdQh+TiWYucKj+VPUqq+7VbwFL8+tKg
        6Ak/lThcfP+GrP7C3Laj0mnrm/3PVnFKhd1nl1btmlx80lLt1jrtx+u2akey+N4ScxKbalTD
        bPzo6Tvh2V9eRywoYdn6m2NR1LKYkLVmMha6sYefHnRkVF/89GrlNtlOYc5P31IXqUvJSV3J
        +NY0t/J63d/UdZtOHT1bIMV5ImSR1cyCCUdePJJ1nTm1LXPPHxf9hHNnN0rslJhz8OAunuJ7
        sqIiZ90k9Nr2swr8m2bGHe8e/rn7zfdjjIcif1vfm7m3I3Su24NucffVUtyu+r+adjccF9yu
        xFKckWioxVxUnAgAhJBeZK0CAAA=
X-CMS-MailID: 20230515054350epcas5p4643d68a6f79cae867b88be678154329b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230515054350epcas5p4643d68a6f79cae867b88be678154329b
References: <CGME20230515054350epcas5p4643d68a6f79cae867b88be678154329b@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The NVM command set specification 1.0c supports 64 LBA formats.
The first patch adds support for that.

The io_uring_cmd ioengine assumes that logical block size is always
power of 2. But with namespace formats where metadata is transferred
at the end of logical block i.e. an extended logical block this is
not true.
This second patch adds the support for extended logical block sizes.
This however doesn't include support for protection info and metadata
transferred as separate buffer, we return error for those.

Changes from v1:
* Split the original patch into 2 as suggested by Vincent and Jens
* Address all review comments from Vincent

Ankit Kumar (2):
  engines/nvme: support for 64 LBA formats
  engines/io_uring: io_uring_cmd engine fixes

 engines/io_uring.c | 30 ++++++++++++++++++---
 engines/nvme.c     | 66 ++++++++++++++++++++++++++++++++++++++--------
 engines/nvme.h     |  6 ++---
 3 files changed, 84 insertions(+), 18 deletions(-)

-- 
2.25.1

