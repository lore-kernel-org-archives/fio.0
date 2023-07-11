Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28DFEB64DC
	for <fio@archiver.kernel.org>; Tue, 11 Jul 2023 07:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjGKHpg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 11 Jul 2023 03:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjGKHp3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Jul 2023 03:45:29 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A04D10FC
        for <fio@vger.kernel.org>; Tue, 11 Jul 2023 00:45:16 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230711074514epoutp0398a08aeab18e786c9a1f5c22277268fb~wwH_M0ev-0653906539epoutp03e
        for <fio@vger.kernel.org>; Tue, 11 Jul 2023 07:45:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230711074514epoutp0398a08aeab18e786c9a1f5c22277268fb~wwH_M0ev-0653906539epoutp03e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1689061514;
        bh=vEaloqRMHQyu0FZge3NPUmAdZdR1H/LYCBWP1xuH8hs=;
        h=From:To:Cc:Subject:Date:References:From;
        b=RJ+SXd0YLB0kVVkTyhjS2UMsv/+ilqAIZzuHK1cyH+udj3kIfkjnDg8aLH4Oo85W5
         7zq/A6iNLQRI9hm8WmwDY5/7Z2XVnmBfo4JOjIY6tTAm6B718eWIgFsFET8ZC2WtJR
         cAONCTxXQr/ob0o1xR1JyGOmiNdyIckL4MIDqvtk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230711074513epcas5p313d87785a4b37fef0031164a5a5d0d26~wwH9qO3xs2957629576epcas5p3P;
        Tue, 11 Jul 2023 07:45:13 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4R0Xw81s2Wz4x9Q8; Tue, 11 Jul
        2023 07:45:12 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        49.3B.55522.5880DA46; Tue, 11 Jul 2023 16:45:09 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230711073511epcas5p223fd93816f8249258482a445305a9656~wv-MUh5G41978519785epcas5p2M;
        Tue, 11 Jul 2023 07:35:11 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230711073510epsmtrp123fe6c7160f19b9243e41f7051a8f456~wv-MTzl2Y0951309513epsmtrp1O;
        Tue, 11 Jul 2023 07:35:10 +0000 (GMT)
X-AuditID: b6c32a49-67ffa7000000d8e2-77-64ad08846f96
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        30.95.30535.E260DA46; Tue, 11 Jul 2023 16:35:10 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230711073509epsmtip1fc3b71e7f57588262129fc7b327a2c78~wv-LYI24-0243302433epsmtip1N;
        Tue, 11 Jul 2023 07:35:09 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, simon.lund@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/3] fdp fixes, random placment id and xnvme support 
Date:   Tue, 11 Jul 2023 18:24:31 +0530
Message-Id: <20230711125434.14691-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmum4rx9oUg+cvmC3WXPnNbrH6bj+b
        xcdZQO6kQ9cYLe52z2C32NAm6MDmsXPWXXaPy2dLPTat6mTz6NuyitHj8ya5ANaobJuM1MSU
        1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoP1KCmWJOaVAoYDE
        4mIlfTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyML68fMxc8
        4qjYfugBUwNjC1sXIyeHhICJRPvP40A2F4eQwG5Gib1n1rJCOJ8YJd5/ncEO4XxjlFjypp8d
        puXJ39VQib2MEtPeXWEESQgJdDJJXJxlCWKzCWhLvHp7g7mLkYNDREBDYs3dVJAws0C2xKJT
        y5hBbGEBV4kHfZvASlgEVCVmnZcBCfMK2Eh8nrOZEWKVvMTMS9/ZIeKCEidnPmGBGCMv0bx1
        NjPICRICx9glJh6bDdXgInHz1gZmCFtY4tXxLVA3S0m87G+DsrMlNj38yQRhF0gcedELVW8v
        0XqqH+weZgFNifW79CHCshJTT61jgtjLJ9H7+wlUK6/EjnkwtqrE33u3WSBsaYmb765C2R4S
        u5uOsUFCJ1bi0NS3TBMY5WcheWcWkndmIWxewMi8ilEytaA4Nz212LTAMC+1HB6tyfm5mxjB
        iVDLcwfj3Qcf9A4xMnEwHmKU4GBWEuEtOLgqRYg3JbGyKrUoP76oNCe1+BCjKTCIJzJLiSbn
        A1NxXkm8oYmlgYmZmZmJpbGZoZI47+vWuSlCAumJJanZqakFqUUwfUwcnFINTG0rA7TDQl6w
        K9U9iTgt+2ulm8nGm6J3D5+173ryY2H1/uY6g/dB9y5EWZZGNO51i7G6WvsmJfv29vi/O1bN
        2XUzSkRV7+aymw+TDz6qeBB3JT39lsyuuzNn7f9rN7Flo9n2dIWojjuK7DvdV87Wc//p4XfO
        8sOz63uXz67P+Me22WDDPzPlP8n3WDUmzjB8xCLbUlMYu1DI2OXTJyWzFd4P3CItc9ps/hae
        9y3zENCaV2TAnPXia/vSvakZb6Rsi7882JTrHtP20zzSuUGLTXAfj4y3rqplumSafXnwaZ7E
        6m2mF9eVa5ddvdy2aN+9rW/utieerTi8M11mx2F1sRsnpadaTUj/+3eBgH6PiBJLcUaioRZz
        UXEiAMouLNINBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsWy7bCSnK4e29oUg6frLCzWXPnNbrH6bj+b
        xcdZL5gtJh26xmhxt3sGu8WGNkEHNo+ds+6ye1w+W+qxaVUnm0ffllWMHp83yQWwRnHZpKTm
        ZJalFunbJXBlfHn9mLngEUfF9kMPmBoYW9i6GDk5JARMJJ78Xc3excjFISSwm1Hi2eyHLF2M
        HEAJaYmF6xMhaoQlVv57DlXTziRx9NYJZpAEm4C2xKu3N8BsEQEtiWPrmthAepkF8iWu38sF
        CQsLuEo86NvEDBJmEVCVmHVeBiTMK2Aj8XnOZkaI8fISMy99Z4eIC0qcnPmEBcRmBoo3b53N
        PIGRbxaS1CwkqQWMTKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS83M3MYJDUktrB+OeVR/0
        DjEycTAeYpTgYFYS4S04uCpFiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+3170pQgLpiSWp2amp
        BalFMFkmDk6pBqadXsVze+oDjs097S5ygO9tcvVzxqNK2ncamSVKvh8/8aYq9bnsr1XCl98p
        1XUvdv48s71U6J7tlKbdO74Yv3V4+sE5UfJ++a37LcEPxEMXnjhm45+l+emXpt/N3Ie8Yivf
        xiWYrli1+7gVZ4HS5m9JN1bmiR4W/y3+/P1Vj5XX1i08rLzBv/LpnJ1XeIVPreWcOq/xlMHi
        oviPfHu/yP3rW7r79MuagxtvHL95oWvdX45rW85vWx998eE55nMqk/8puXgdd+pq4fC+xPFf
        8kxO2xkZj5tzZmv/T9g7ydcmUehvirJFscWUmB6BVapKRWqsrnXVuptdp3Csv70l5Trfygd/
        RAtt62QCNHbc83h+VImlOCPRUIu5qDgRADYkZce4AgAA
X-CMS-MailID: 20230711073511epcas5p223fd93816f8249258482a445305a9656
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230711073511epcas5p223fd93816f8249258482a445305a9656
References: <CGME20230711073511epcas5p223fd93816f8249258482a445305a9656@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This series now enables us to either roundrobin or select a random
placement ID from the available ones. In future a non-unifrom
placement id selection such as zipf, pareto etc can be added.

The current boundary check for input placment ids was not correct.
Added a fix for that.

This series also adds FDP support to the xnvme I/O engine.

Ankit Kumar (3):
  fdp: use macro for max ruhs and fix placement id check
  fdp: support random placement id selection
  engines/xnvme: add support for fdp

 HOWTO.rst              | 19 ++++++++--
 configure              |  2 +-
 engines/io_uring.c     |  2 +-
 engines/xnvme.c        | 78 +++++++++++++++++++++++++++++++++++++++++-
 examples/xnvme-fdp.fio | 36 +++++++++++++++++++
 fdp.c                  | 20 +++++++----
 fdp.h                  | 12 +++++++
 fio.1                  | 20 +++++++++--
 fio.h                  |  2 ++
 init.c                 |  2 ++
 options.c              | 20 +++++++++++
 thread_options.h       |  2 ++
 12 files changed, 201 insertions(+), 14 deletions(-)
 create mode 100644 examples/xnvme-fdp.fio

-- 
2.25.1

