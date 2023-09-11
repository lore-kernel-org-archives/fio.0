Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E8ACA0EC9
	for <fio@archiver.kernel.org>; Mon, 11 Sep 2023 22:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbjIKWPj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236687AbjIKLNM (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Sep 2023 07:13:12 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFBFCC3
        for <fio@vger.kernel.org>; Mon, 11 Sep 2023 04:13:08 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230911111306epoutp03f73dc593167784dddca842f82ac23485~D09KoOv6v1520915209epoutp03L
        for <fio@vger.kernel.org>; Mon, 11 Sep 2023 11:13:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230911111306epoutp03f73dc593167784dddca842f82ac23485~D09KoOv6v1520915209epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1694430786;
        bh=earoDVp4pC7w+yB9ObnYl7IPwuYK+jJ2M50u3LxwJ/k=;
        h=From:To:Cc:Subject:Date:References:From;
        b=fb/yIYnLKUVWGDl891+UsMLxYyaI1An3ciHawqGoxg1l04Yf8W70gpf+yu0KhnpWL
         skhPKN3KPT8j4vErd9Fitb73RKSPL6WTYyRYI5DFSdq1bR83Cb6WklNvpbtU7LsrZi
         jXTkn2AHunSyjcHHewnheamgVfxBdJvR7TFB0iHY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230911111305epcas5p255702dd417bcdce8105090fcfe11a657~D09J7Z5oN0313903139epcas5p2-;
        Mon, 11 Sep 2023 11:13:05 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4RkkbN0ZMhz4x9Px; Mon, 11 Sep
        2023 11:13:04 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F0.84.09638.F36FEF46; Mon, 11 Sep 2023 20:13:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230911110620epcas5p20ba906dcc78e21b1936dd37e5b5a1090~D03QduHVj1698116981epcas5p2x;
        Mon, 11 Sep 2023 11:06:20 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230911110620epsmtrp29eac804efb34a5a0f7117ace2825542f~D03QdBXTk0402704027epsmtrp2c;
        Mon, 11 Sep 2023 11:06:20 +0000 (GMT)
X-AuditID: b6c32a4a-6d5ff700000025a6-d2-64fef63fecbf
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7E.3D.08649.CA4FEF46; Mon, 11 Sep 2023 20:06:20 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230911110619epsmtip2224168d8e47c6fba3c36476b74314434~D03Pet3AK2755727557epsmtip24;
        Mon, 11 Sep 2023 11:06:19 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/2] E2E PI two small fixes for io_uring passthru engine.
Date:   Mon, 11 Sep 2023 21:54:58 +0530
Message-Id: <20230911162500.271118-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsWy7bCmpq79t38pBmevalqsufKb3WL13X42
        i4+zXjBbHP3/ls1iQ5ugA6vHzll32T0uny316NuyitHj8ya5AJaobJuM1MSU1CKF1Lzk/JTM
        vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoK1KCmWJOaVAoYDE4mIlfTubovzS
        klSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyM5f1H2AtWs1bM//iArYFx
        PksXIyeHhICJxLkPa9m6GLk4hAR2M0o0Xz3HBOF8YpQ4s+c9lPONUWLV1l9wLSe+rGcCsYUE
        9jJKXLiaCWF3Mkk87hICsdkEtCVevb3B3MXIwSEioCGx5m4qSJhZIFSiv6UDbIywgKfE4ykP
        wGwWAVWJL8dBruDk4BWwlXh66TobxCp5iZmXvrNDxAUlTs58wgIxR16ieetsZoiaXewSny9H
        QNguEk2db9khbGGJV8e3QNlSEp/f7YWamS2x6eFPJgi7QOLIi16oOfYSraf6wU5mFtCUWL9L
        HyIsKzH11DomiLV8Er2/n0C18krsmAdjq0r8vXcbGjrSEjffXYWyPSRurXvFCAmdWImjH/+z
        T2CUn4Xkm1lIvpmFsHkBI/MqRsnUguLc9NRi0wKjvNRyeKwm5+duYgSnPC2vHYwPH3zQO8TI
        xMF4iFGCg1lJhLfk0N8UId6UxMqq1KL8+KLSnNTiQ4ymwCCeyCwlmpwPTLp5JfGGJpYGJmZm
        ZiaWxmaGSuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUwyYcd3V8qYZAqVr2d/WLEUXN7Q6sV
        kqo+71gtY96dX+Cs+FJlwoOU2GuzfeQz/DOfuvh7d3Xe+hHBeq7qK8cEzoJivVIvo0dHu//8
        65+dqhthk1PWWT/hC+f78GmeXyxrBP68+VvC+2Mh3wKeL2csDpjmxwbdrSmNtez4eCo7UvXW
        +1maX/9PPu26IPbAZJPaZ2FCfz4oXta7sbRsb2PGwdx1x5Qc/y8wLtCKnMp4TWPt7cKUFoW6
        Cfz7nzEZmK46uTle91ZBz39p+wzLyZp/hD4wdq258ipLw1/MUkzq9bZ5TyqDSmsK8k6F7Gex
        5NA5Evf67NuI6q5ohbXcX7ksf/HrLrUJibvLozftrZkSS3FGoqEWc1FxIgCI8MpQAgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsWy7bCSvO6aL/9SDKYcl7BYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFhjZBB1aPnbPusntcPlvq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBnL
        +4+wF6xmrZj/8QFbA+N8li5GTg4JAROJE1/WM3UxcnEICexmlDh6q5eti5EDKCEtsXB9IkSN
        sMTKf8/ZIWramSS2/lzJCJJgE9CWePX2BjOILSKgJXFsXRMbiM0sEC7ROBukgZNDWMBT4vGU
        B2DLWARUJb4cXwtWwytgK/H00nU2iAXyEjMvfWeHiAtKnJz5hAVijrxE89bZzBMY+WYhSc1C
        klrAyLSKUTK1oDg3PTfZsMAwL7Vcrzgxt7g0L10vOT93EyM4BLU0djDem/9P7xAjEwfjIUYJ
        DmYlEd6SQ39ThHhTEiurUovy44tKc1KLDzFKc7AoifMazpidIiSQnliSmp2aWpBaBJNl4uCU
        amBiEr7g9aVlzjn1Z1Mso+q2Vq24med3JfYTw7qQP1a1HGKL36ybvHmqpnHEnbVmrzhf8tm/
        WfOqbOuk4if3k011boRWSNx7m1QiU/pknmXAu3SOyxLxfQ4+JqxdTVkzpF8oLXaMtnVI8GSc
        uf7QLG0Rq4JVp+1WKwl+iG63iAvR3Sr3fcvViHt6NbFTlx98+WHumodzjCy5El/2RzyWKEo8
        EjSv6Old5/me9cbfO4NXiLmGFS/7zHx5lkDFyWXX9GcqfOJtiPykrh398OGPPssc6/KZB39Y
        JUo91Hptp7WdYaabplJ15vVfHfrTnK8avuG9PP+YkNadtFjpdfJrPgm/M4i/EqTV7Bi8UiEl
        1leJpTgj0VCLuag4EQAkLyMIsAIAAA==
X-CMS-MailID: 20230911110620epcas5p20ba906dcc78e21b1936dd37e5b5a1090
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230911110620epcas5p20ba906dcc78e21b1936dd37e5b5a1090
References: <CGME20230911110620epcas5p20ba906dcc78e21b1936dd37e5b5a1090@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

1. The fio verify cannot work when end to end data protection is enabled
This issue is only when nvme namespace has extended logical blocks, as
the PI portion of data buffer conflicts with any specified verify
option. Disallow verify for this case.
2. There is no need to fill LBA reference and application tag in the
command if the relevant bits for PI check is not set.

Ankit Kumar (2):
  engines:io_uring_cmd: disallow verify for e2e pi with extended blocks
  engines:nvme: fill command fields as per pi check bits

 engines/io_uring.c | 14 ++++++++++++++
 engines/nvme.c     | 15 ++++++++++-----
 2 files changed, 24 insertions(+), 5 deletions(-)

-- 
2.25.1

