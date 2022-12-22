Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870B8C4332F
	for <fio@archiver.kernel.org>; Thu, 22 Dec 2022 04:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiLVEsI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 21 Dec 2022 23:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLVEsH (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Dec 2022 23:48:07 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12451A80E
        for <fio@vger.kernel.org>; Wed, 21 Dec 2022 20:48:05 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221222044801epoutp04dfacb08c9032d13596c2f058fb29acd5~zBC3XjNVB0118401184epoutp04T
        for <fio@vger.kernel.org>; Thu, 22 Dec 2022 04:48:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221222044801epoutp04dfacb08c9032d13596c2f058fb29acd5~zBC3XjNVB0118401184epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1671684481;
        bh=H6O/TDU5GDKQBHdJJuWU24eqo7nZhc75f7ZB2WRu0XY=;
        h=From:To:Cc:Subject:Date:References:From;
        b=UKthJiFFW6iofkIEgCZEbIqIwJUGmZHS4Qlydq0CPFzfPrd6kmTAlApIZRXLp3Hwv
         NUhgMEQauKl6AlBWa6r2w1KHtNYIfU/k4fc0MYOlA/xTLjx6b18dIohFk2yLeODzxz
         2fjNTuwzsndnvhXKlorxE3JndvUU869Lj8Jfv2B8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221222044801epcas5p397e051f5c2b9c350063f5c5e3e32bba4~zBC3HeqYW1046210462epcas5p3R;
        Thu, 22 Dec 2022 04:48:01 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4NcyVR5Rqqz4x9Q8; Thu, 22 Dec
        2022 04:47:59 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        32.88.03362.D71E3A36; Thu, 22 Dec 2022 13:47:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20221222044040epcas5p3abbde8c4a3775d39d237b0b6cf6dd04a~zA8cLyGWp2795027950epcas5p3w;
        Thu, 22 Dec 2022 04:40:40 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221222044040epsmtrp1835a7a780e4ffb2158aa49fdb802b680~zA8cK0vKY0236302363epsmtrp1E;
        Thu, 22 Dec 2022 04:40:40 +0000 (GMT)
X-AuditID: b6c32a4b-287ff70000010d22-de-63a3e17d6489
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        82.64.02211.7CFD3A36; Thu, 22 Dec 2022 13:40:40 +0900 (KST)
Received: from green.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221222044039epsmtip1957df28bb39ed69a2aef2d0669aec0f9~zA8bPgzdI0421704217epsmtip1R;
        Thu, 22 Dec 2022 04:40:38 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com, simon.lund@samsung.com,
        m.ynddal@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/4] new options and fixes for xnvme ioengine
Date:   Thu, 22 Dec 2022 10:09:47 +0530
Message-Id: <20221222043951.24590-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsWy7bCmlm7tw8XJBpenaVisufKb3WL13X42
        i4+zXjBbTPrVyGhxt3sGu8WGNkEHNo+ds+6ye1w+W+rRt2UVo8fnTXIBLFHZNhmpiSmpRQqp
        ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAq5UUyhJzSoFCAYnFxUr6
        djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWleel6eaklVoYGBkamQIUJ2RmLD1kU9LJVnJjz
        la2B8T1LFyMnh4SAicSu/n7mLkYuDiGB3YwS0zevh3I+MUr8+rCAEcL5xiixbu9JVpiW/aen
        MYPYQgJ7GSXmTIyEKGpikpg0/Ro7SIJNQFvi1dsbYEUiAsIS+ztaWUCKmAWaGSXWXFwD5HBw
        CAvYSkzp1gSpYRFQlZg/fwUzSJhXwEbi428LiF3yEqs3HGCGsBexS1y6JQxhu0i8aj4OFReW
        eHV8CzuELSXxsr8Nys6W2PTwJxOEXSBx5EUvVL29ROupfrBVzAKaEut36UOEZSWmnloHVs4s
        wCfR+/sJVCuvxI55MLaqxN97t6EhJy1x891VKNtD4t+hRUyQIImVWH5xIusERtlZCBsWMDKu
        YpRMLSjOTU8tNi0wzksth8dScn7uJkZwctLy3sH46MEHvUOMTByMhxglOJiVRHgvXVicLMSb
        klhZlVqUH19UmpNafIjRFBhiE5mlRJPzgekxryTe0MTSwMTMzMzE0tjMUEmcN3Xr/GQhgfTE
        ktTs1NSC1CKYPiYOTqkGptOHbR7Vfe6Jujnl2UZejU1zC3trPuYstGo6OadHbavIyoAa180b
        4n4we9b16UdyLjl6+skubslGh9RfM/6sLt362cU3xjDd+G7En68uWZ2Bk8Qmzn2//ed8W5ud
        KRXBqxL9+Wddl9bb+VDuhDbHquCm5iu3nmVMOOn2/vxaNi9W/qnB/keuxKkdfN83NSJ83ZeS
        7sVX5tptne13Me9DIBNT57TPL86GxYlu4g6JzHr2OGfP0k9iM7seNa1ec+ewZ4vqsvszt0Ww
        fVn9Rjj35LmI2Y9UGMsfO3R0rJ7WumKKofo9ibaewyv0225+kbZawNWQzlmops6lv+XfVLf8
        Dy5WZ6ZPPBp69qpkTvuCo1+UWIozEg21mIuKEwGzmjmI1wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPJMWRmVeSWpSXmKPExsWy7bCSnO6J+4uTDS59YLRYc+U3u8Xqu/1s
        Fh9nvWC2mPSrkdHibvcMdosNbYIObB47Z91l97h8ttSjb8sqRo/Pm+QCWKK4bFJSczLLUov0
        7RK4MhYfsijoZas4MecrWwPje5YuRk4OCQETif2npzF3MXJxCAnsZpTYunIzaxcjB1BCWmLh
        +kSIGmGJlf+es4PYQgINTBJz36qD2GwC2hKv3t5gBrFFgGr2d7SygMxhFuhklNj58wATyBxh
        AVuJKd2aIDUsAqoS8+evYAYJ8wrYSHz8bQExXl5i9YYDzBMYeRYwMqxilEwtKM5Nzy02LDDM
        Sy3XK07MLS7NS9dLzs/dxAgOEy3NHYzbV33QO8TIxMF4iFGCg1lJhPfShcXJQrwpiZVVqUX5
        8UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTCdnNh0he9Dr2m/nHJhQ/bz
        BTI3Ew5mBRs+/HvyjvYH5is+XRtnXDskcEeEe5uk2duMioLFDQF8fIVrG3UqLV1q/LgXHWxZ
        wilzh/3YOs455jfF2c3aHm85pRL0aKuY0lnDIv3LARqswvkptycsPqzPMefJty0JTXo7l0vy
        puYKvpFOObyko+awQ3XlJJf1xurTNkfsdvATuHXuYJtU0priu7OddzA5RF35YPdWw/1T4lQr
        /r1fD+msnViqN2HVI0v7LENmu99SN5ndFy7s3a4fk+4dLPd1mozc9VlMkzMF1V9EOE8rjH6V
        Lc3+rODJXEMLn4QoPR293uIj3H+fFi5OeNu47Yj6n6yVP0rPaCixFGckGmoxFxUnAgA6BiNy
        ggIAAA==
X-CMS-MailID: 20221222044040epcas5p3abbde8c4a3775d39d237b0b6cf6dd04a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221222044040epcas5p3abbde8c4a3775d39d237b0b6cf6dd04a
References: <CGME20221222044040epcas5p3abbde8c4a3775d39d237b0b6cf6dd04a@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patch series adds
1. Few minor fixes and cleanups to the xnvme I/O engine.
2. xNVMe recently added a user-space VFIO based backend implemented
   using libvfn. This allow users to select that instead of SPDK.
3. Add subnqn option for fabrics target with multiple systems.
4. Add an option to select memory backend.

Ankit Kumar (4):
  engines/xnvme: fixes for xnvme ioengine
  engines/xnvme: user space vfio based backend
  engines/xnvme: add subnqn to fio-options
  engines/xnvme: add support for picking mem backend

 HOWTO.rst       | 27 ++++++++++++++++++++++++++-
 engines/xnvme.c | 44 ++++++++++++++++++++++++++++++++++++++------
 fio.1           | 32 +++++++++++++++++++++++++++++++-
 3 files changed, 95 insertions(+), 8 deletions(-)

-- 
2.17.1

