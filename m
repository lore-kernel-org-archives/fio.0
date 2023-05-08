Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99ABC77B75
	for <fio@archiver.kernel.org>; Fri, 12 May 2023 09:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239781AbjELJLh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 May 2023 05:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239984AbjELJLf (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 May 2023 05:11:35 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7ABC26AE
        for <fio@vger.kernel.org>; Fri, 12 May 2023 02:11:33 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230512091130epoutp03e1635c4f5f372b52c021a83928c823d6~eWmKU6YBW1011110111epoutp03F
        for <fio@vger.kernel.org>; Fri, 12 May 2023 09:11:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230512091130epoutp03e1635c4f5f372b52c021a83928c823d6~eWmKU6YBW1011110111epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1683882690;
        bh=S+cPwLGwF4uvvLS584ffeRs8Zo1x1STykmyg/aSv7yI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=dbL2xiJv0YLomX1ITTlzZhlvq8eao8X5egwMuQ42F+QbFeRWw/pNxLBERhGYNnnHl
         A8LMgrqUZz7Bh1iCBzJzrU68pxwhMp3yxle8/4LGBp49WTQxTIO2hlLYdPxYT+T/Za
         dCdCeFbKnIbTmHS8MrDu9RAZRY60gpmPrHivBXMw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230512091129epcas5p1891f695019432d17b6791f8bf8a62b09~eWmJ_2Tb41011210112epcas5p1c;
        Fri, 12 May 2023 09:11:29 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4QHjgM4ygJz4x9Px; Fri, 12 May
        2023 09:11:27 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2A.F9.54880.EB20E546; Fri, 12 May 2023 18:11:26 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230508104106epcas5p30f01a4afec7405be8f46f99b73fa9207~dJPQZhscU3201532015epcas5p3h;
        Mon,  8 May 2023 10:41:06 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230508104106epsmtrp222e359d84e6e3e647546bc670dfd1f10~dJPQY4jGf0041600416epsmtrp2L;
        Mon,  8 May 2023 10:41:06 +0000 (GMT)
X-AuditID: b6c32a49-b21fa7000001d660-b3-645e02bebe7c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        10.8B.28392.2C1D8546; Mon,  8 May 2023 19:41:06 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230508104105epsmtip1744ff08a3154e885f3f6e2ba025dcae7~dJPPfaD6p2832628326epsmtip1Z;
        Mon,  8 May 2023 10:41:05 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/1] io_uring_cmd engine extende LBA fixes and cleanup
Date:   Mon,  8 May 2023 21:31:17 +0530
Message-Id: <20230508160118.25334-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsWy7bCmpu4+prgUgy/PNCzWXPnNbrH6bj+b
        xcdZL5gtjv5/y2axoU3QgdVj56y77B6Xz5Z69G1ZxejxeZNcAEtUtk1GamJKapFCal5yfkpm
        XrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0FYlhbLEnFKgUEBicbGSvp1NUX5p
        SapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGkh3TmAvusFXsuvOXtYFx
        O2sXIyeHhICJxKzT19m6GLk4hAR2M0pM2rSZFcL5xCjxfsFVNpAqIYHPjBLt0yRgOo72L2CB
        KNrFKLGw8zIThNPJJHHuwj6wuWwC2hKv3t5gBrFFBIQl9ne0soDYzAJZEidWtAHZHBzCAm4S
        Hz6ygpgsAqoSG6/FgVTwCthI3J9zAOo6eYmZl76zQ8QFJU7OfAI1RV6ieetsZpC1EgLb2CU2
        LGxkgWhwkZh4ZCUbhC0s8er4FnYIW0ri87u9UPFsiU0PfzJB2AUSR170MkPY9hKtp/qZQe5h
        FtCUWL9LHyIsKzH11DomiL18Er2/n0C18krsmAdjq0r8vXcb6gRpiZvvrkLZHhJfbv9iAhkp
        JBArMa0tcQKj/Cwk38xC8s0shMULGJlXMUqmFhTnpqcWmxYY5qWWw2M1OT93EyM45Wl57mC8
        ++CD3iFGJg7GQ4wSHMxKIrxvl0SnCPGmJFZWpRblxxeV5qQWH2I0BYbwRGYp0eR8YNLNK4k3
        NLE0MDEzMzOxNDYzVBLnVbc9mSwkkJ5YkpqdmlqQWgTTx8TBKdXANOWS2EST6wZ95fNavB/1
        SSo4rzq6/SfHDF6vlysfxKb+75tRscHU21DNvt+gVEjA5NmuyqXPbntZFfo03nV/aMHvErXn
        fQ97JrdSa1O+1xenG2cv7GNsWD35v/1f/eDq6VJed86kvnjv96WkcJvMm6t3GGLsknd++bnx
        zFGT/p1ZPgVCHsnZvn7pWisdnSeEvZ3x1u3Ig7cfP/Xk79VPvtf5xSuA42CherKR/y+zWacq
        MqwZGjWa/bafvLorgWtf5Lr6vZukuA99WuN36Ci/MJ+8ZtyDbZMW/JTiy14VuVfxdu2bXaXm
        1t1NO34KOc1Y+WHleW6PC51hvIarDz1YIs0VpLRONZ1nwhORAn0ZJZbijERDLeai4kQARoBj
        PwIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsWy7bCSnO6hixEpBufniFusufKb3WL13X42
        i4+zXjBbHP3/ls1iQ5ugA6vHzll32T0uny316NuyitHj8ya5AJYoLpuU1JzMstQifbsErowl
        O6YxF9xhq9h15y9rA+N21i5GTg4JAROJo/0LWLoYuTiEBHYwSnx+PoO9i5EDKCEtsXB9IkSN
        sMTKf8/ZQWwhgXYmiXPLhUFsNgFtiVdvbzCD2CJANfs7WllAWpkF8iS+rVIBMYUF3CQ+fGQF
        MVkEVCU2XosDKeYVsJG4P+cA1AHyEjMvfWeHiAtKnJz5hAXEZgaKN2+dzTyBkW8WktQsJKkF
        jEyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCQ09LawfjnlUf9A4xMnEwHmKU4GBW
        EuFdlRCWIsSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVAPT
        Ss3lgp12QjenvF+6886JDbmqHZMVhc5ZXDX/zpkVlsRRZpN1M6C7c0e87F9uY0GhbUbF7ZpR
        h1rnu7NxmM55VndwVoZrwdE7s60j6s6Hrd398/zDV1e9fuoIf808IyLi9W2e3ZPUB1mGh3vl
        7EwV5e6vsQkOOGOy9IfG899zQzZ83vpYaaPE7PipM1kn5rwv6v7GnyLqcXOxiYhh6Qvdr9Ji
        6lXBHixrnh1bsSPzycfDFj7O6/7HKYYdu/uztejjR2euW+838ur0/zgV7lkTkvv1SFDl/ks9
        wXbszG3Mx89YKAsI2k9vYXa64PXXonOWavbndU0f864923Tt7trrqnfY73Rz9Esv3MuZc+y7
        EktxRqKhFnNRcSIA3T0F/qwCAAA=
X-CMS-MailID: 20230508104106epcas5p30f01a4afec7405be8f46f99b73fa9207
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230508104106epcas5p30f01a4afec7405be8f46f99b73fa9207
References: <CGME20230508104106epcas5p30f01a4afec7405be8f46f99b73fa9207@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The io_uring_cmd ioengine assumes that logical block size is power of 2.
In case of extended LBA where metadata is transferred as part of LBA
this is not correct. Use division operation for that. The existing
calculation for power of 2 LBA remains the same.

The current implementation doesn't support protection info and
metadata transferred as separate buffer, return error for these
scenarios.

Add checks to verify that block sizes are multiple of LBA size.
Add support for 64 LBA formats as per the latest NVM command set
specification.

Ankit Kumar (1):
  engines/io_uring: io_uring_cmd engine cleanup and fixes

 engines/io_uring.c | 31 +++++++++++++++++++++----
 engines/nvme.c     | 57 +++++++++++++++++++++++++++++++++++++---------
 engines/nvme.h     |  3 ++-
 3 files changed, 75 insertions(+), 16 deletions(-)

-- 
2.25.1

