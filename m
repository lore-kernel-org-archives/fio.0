Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA1DC04A94
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 06:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjHIGCu (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 02:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjHIGCt (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 02:02:49 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D65E1BF3
        for <fio@vger.kernel.org>; Tue,  8 Aug 2023 23:02:48 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230809060245epoutp04f33b775b370010f57f8d862f3c8fc344~5obxpm31Y1971419714epoutp04G
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 06:02:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230809060245epoutp04f33b775b370010f57f8d862f3c8fc344~5obxpm31Y1971419714epoutp04G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691560965;
        bh=77neg5aIPsT/w1XNuWkNuMvzHHzo21yn9WeTd1jY1Ac=;
        h=From:To:Cc:Subject:Date:References:From;
        b=QfGszXO2gY4YTUxCEAJeSM2NXQZTC6Ni23px3IE4W1XgnXIIXmInA8FmsehoU8Ki3
         jcIdy5etCDXTpDvpiun7chAzVuR3aKXeI1pTRi40Ywu4JK2Ob5ldYxIGADiVw4lp/q
         oR8n5E7pWqyGqw6oDzmyvLvHYfdQZZ8LUtkek4vA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230809060244epcas5p20b02c695cb650687f828f0193d38e316~5obw-F0XO2953329533epcas5p2q;
        Wed,  9 Aug 2023 06:02:44 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4RLKGW4tRlz4x9Q4; Wed,  9 Aug
        2023 06:02:43 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3C.3E.57354.30C23D46; Wed,  9 Aug 2023 15:02:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230809055412epcas5p2730555562d72605bd2956964598d7333~5oUT7dy_v1788317883epcas5p2S;
        Wed,  9 Aug 2023 05:54:12 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230809055412epsmtrp1b45ea50af1916e07df5454b0b000ddbb~5oUT6wRJv3170131701epsmtrp1h;
        Wed,  9 Aug 2023 05:54:12 +0000 (GMT)
X-AuditID: b6c32a44-007ff7000001e00a-71-64d32c036db5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.AE.30535.40A23D46; Wed,  9 Aug 2023 14:54:12 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230809055411epsmtip18aa24dbdf36c4a6da5d0dc082b7a52ff~5oUSeYZOA0790107901epsmtip1C;
        Wed,  9 Aug 2023 05:54:10 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 00/10] Protection information support for io_uring
 passthrough
Date:   Wed,  9 Aug 2023 16:43:04 +0530
Message-Id: <20230809111314.76947-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdlhTU5dZ53KKwf0LqhZrrvxmt1h9t5/N
        4uOsF8wWR/+/ZbOYdOgao8Xy4/+YLDa0CTqwe+ycdZfd4/LZUo9NqzrZPD4+vcXi0bdlFaPH
        501yAWxR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5
        QJcoKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgpMCvSKE3OLS/PS9fJSS6wMDQyM
        TIEKE7IzNk0rKPgoUNHa1sHawDiVt4uRk0NCwESi7+kUdhBbSGA3o8TxTr8uRi4g+xOjRPfj
        ZmYI5xujxLVXFxlhOvbs3MYK0bGXUWJGXyBEUSeTxP+pM1hAEmwC2hKv3t4A6ubgEBHQkFhz
        NxWkhlmghVFid/dssGZhgQCJPRO/MIHUsAioSvxodQUJ8wrYSJzo/scEsUteYual7+wQcUGJ
        kzOfgI1nBoo3b50NdpyEwDV2iSXbelkhGlwkFl58wAJhC0u8Or6FHcKWknjZ3wZlZ0tsevgT
        akGBxJEXvcwQtr1E66l+sJuZBTQl1u/ShwjLSkw9tY4JYi+fRO/vJ1CtvBI75sHYqhJ/792G
        WistcfPdVSjbQ+LZk61skLCKlXi0+inrBEb5WUjemYXknVkImxcwMq9ilEwtKM5NT002LTDM
        Sy2Hx2pyfu4mRnBq1HLZwXhj/j+9Q4xMHIyHGCU4mJVEeG2DL6UI8aYkVlalFuXHF5XmpBYf
        YjQFBvFEZinR5Hxgcs4riTc0sTQwMTMzM7E0NjNUEud93To3RUggPbEkNTs1tSC1CKaPiYNT
        qoHJW/3JBWsZBjG9B1t4Gn55nZo9IcZgsrfjyUC5T73ZV3vvWuRpCk30+1AyU0t2vcqFtVbe
        l+NVOKPVVLNNal+uWprA1eBt4/Iq/4rYzhD2Bdkce4PiGztfbpUtDl27pGPSHv2E24/NfSdr
        bmhm5sz/flrgSUvlCv3NMxtmO5/eJT3l/8lPJVIWs4rtz3jYr/mze/9mwQSd0Jp7HVe66vLu
        Cvj0O65N5wsJUe5PfDBbq5rr61PPd/ZzREzDeH7JHJtyZFG1XfqMgrt/NoRqyUz1jy85feWB
        OEPphs+Pm7zcfN+tqNz6I4/F+vntfX/WWfHemLT/61/r1R5rO1g6LeLNtIWCJuzeM7Fkrbk/
        j4gSS3FGoqEWc1FxIgB/2wvFFgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSnC6L1uUUgwV3FC3WXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiiuGxSUnMyy1KL9O0SuDI2TSso+ChQ0drWwdrAOJW3i5GTQ0LARGLPzm2sXYxcHEIC
        uxkl3r+ey97FyAGUkJZYuD4RokZYYuW/5+wQNe1MEiueXWYCSbAJaEu8enuDGcQWEdCSOLau
        iQ2kiFmgi1Fi7+5pbCAJYQE/iTU774ANZRFQlfjR6goS5hWwkTjR/Y8JYoG8xMxL39kh4oIS
        J2c+YQGxmYHizVtnM09g5JuFJDULSWoBI9MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95Pzc
        TYzgQNXS2sG4Z9UHvUOMTByMhxglOJiVRHhtgy+lCPGmJFZWpRblxxeV5qQWH2KU5mBREuf9
        9ro3RUggPbEkNTs1tSC1CCbLxMEp1cDkbjxDLvn5651nfwf3T7pxavrGT9OZfjgx+Lh1PlJN
        dVJszZIXiltv4Wi3tNl8u5vc2pJ1LNe3dr/l2SNryvV/9qwPHyL/8xR7VM4t4r1g0M8flyYY
        NG23wGEbV8EW0UU2DM2PlJPNFA3v7AhRK489ezir4YTyBnuOrNMFUlO267YLFjH9N7xxk52h
        LG72S66TkbPit3zrF/z3V1m0QVNj9zQ+1SO8M7bebpGru267vLf4cYyD34Ov2k9Sbp5+rPHv
        cfGur7nL2gOPrThs/yKw3kZOcWkhR4LJ9qDOC4eXiKusy/QuLZK6pLPa9uAyff1Pz4qjplgs
        vPdY6f/tj1NVz5f33Mm6a27TnMr9REuJpTgj0VCLuag4EQCtbhsFwwIAAA==
X-CMS-MailID: 20230809055412epcas5p2730555562d72605bd2956964598d7333
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230809055412epcas5p2730555562d72605bd2956964598d7333
References: <CGME20230809055412epcas5p2730555562d72605bd2956964598d7333@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patch series enables protection information support with io_uring
passthrough (io_uring_cmd) ioengine. This support is added for both DIF
(extended logical blocks) and DIX (separate metadata buffer) cases.

The initial patch adds support for metadata buffer. As we are unaware
of metadata size during metadata buffer allocation, we provide an option
md_per_io_size, which must be used to specify metadata size for single IO.

This then enables the protection information support with and without
PRACT bit set for both DIF and DIX cases. The support covers 16-bit and
64-bit guard protection information format, without storage tags. As 32-bit
guard protection information format mandates minimum 16 bits for storage
tag, it is not considered.

This series also borrows relevant kernel crc16-t10 and crc64 rocksoft
generation files, along with 48-bit accessors for reference tags.

Ankit Kumar (10):
  engines:io_uring: add missing error during open file
  engines:io_uring: update arguments to fetch nvme data
  engines:io_uring: enable support for separate metadata buffer
  engines:io_uring: uring_cmd add support for protection info
  io_u: move engine data out of union
  crc: pull required crc16-t10 files from linux kernel
  engines:io_uring: generate and verify pi for 16b guard
  crc: pull required rocksoft crc64 apis from linux kernel
  engines:nvme: pull required 48 bit accessors from linux kernel
  engines:io_uring: generate and verify pi for 64b guard

 HOWTO.rst              |  36 ++++
 crc/crc-t10dif.h       |  10 +
 crc/crc64.c            |  31 +++
 crc/crc64.h            |   4 +
 crc/crc64table.h       | 132 ++++++++++++
 crc/crct10dif_common.c |  78 +++++++
 engines/io_uring.c     | 216 ++++++++++++++++---
 engines/nvme.c         | 467 +++++++++++++++++++++++++++++++++++++++--
 engines/nvme.h         | 230 +++++++++++++++++++-
 fio.1                  |  35 +++
 io_u.h                 |   2 +-
 11 files changed, 1191 insertions(+), 50 deletions(-)
 create mode 100644 crc/crc-t10dif.h
 create mode 100644 crc/crc64table.h
 create mode 100644 crc/crct10dif_common.c

-- 
2.25.1

