Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C7BC04A94
	for <fio@archiver.kernel.org>; Mon, 14 Aug 2023 09:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbjHNJly (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 14 Aug 2023 05:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235153AbjHNJlc (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Aug 2023 05:41:32 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E82E63
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 02:41:25 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230814094123epoutp031431bbbecba859552b7ee7e9a96cbbdf~7NpF7bxJ40936409364epoutp03X
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 09:41:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230814094123epoutp031431bbbecba859552b7ee7e9a96cbbdf~7NpF7bxJ40936409364epoutp03X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1692006083;
        bh=V7LL+szWdwS+f2bor/ck0cr+iFI948W/zDAZo4lP8wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3XWucjNiOZMCvCQd9aHW81bO3xMycV7ooWf4esMmc6kEE0/UuxTYjIVAWnIL5j17
         njplzZYYWomWwfBof1+1iNuVwodNQNIj0xvRcK2STTmCwRNhSwjTkR1DwHgjQMwVOP
         DFX3ECj+37CmK/C55meed7Ai5qSpz6yU4ouOx3N0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230814094123epcas5p23d2bf079c4763fa0ab4b52edb96d5396~7NpFhaEcG3215632156epcas5p2e;
        Mon, 14 Aug 2023 09:41:23 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4RPTtT3Vrmz4x9Pq; Mon, 14 Aug
        2023 09:41:21 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C4.4E.55522.1C6F9D46; Mon, 14 Aug 2023 18:41:21 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230814093853epcas5p4973ef04622e9bafbc73a9a71c84b94ca~7Nm59R0hN1183811838epcas5p4p;
        Mon, 14 Aug 2023 09:38:53 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230814093853epsmtrp2e92e06d7f7d34b9b437a7c4c524c91eb~7Nm58Y4L81882118821epsmtrp2f;
        Mon, 14 Aug 2023 09:38:53 +0000 (GMT)
X-AuditID: b6c32a49-67ffa7000000d8e2-84-64d9f6c1934d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FE.CF.14748.C26F9D46; Mon, 14 Aug 2023 18:38:52 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230814093851epsmtip193abd6aacbfefb06e7cfb1bef1fae0fe~7Nm4bWakt0860808608epsmtip1t;
        Mon, 14 Aug 2023 09:38:51 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 09/10] engines:nvme: pull required 48 bit accessors from
 linux kernel
Date:   Mon, 14 Aug 2023 20:27:46 +0530
Message-Id: <20230814145747.114725-10-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230814145747.114725-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCJsWRmVeSWpSXmKPExsWy7bCmpu7BbzdTDPqWiFusufKb3WL13X42
        i4+zXjBbHP3/ls1i0qFrjBbLj/9jstjQJujA7rFz1l12j8tnSz02repk8/j49BaLR9+WVYwe
        nzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AF2ipFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAw
        MgUqTMjOaNr3la2glbviQecetgbGtxxdjJwcEgImEp9Xr2XrYuTiEBLYzShx7+gqdgjnE6PE
        p+edUM43RolZD5ewwrT8W3GaCSKxl1Hi3fV9jBBOJ5PE0zOf2ECq2AS0JV69vcHcxcjBISKg
        IbHmbipIDbNAC6PE7u7ZYJOEBaIkVi2+yghiswioShyc9AgszitgJ/Hr5FOobfISMy99Zwex
        OYHi/6f8ZoeoEZQ4OfMJC4jNDFTTvHU2M8gCCYGP7BL9564wQzS7SDRffgk1SFji1fEt7BC2
        lMTnd3vZIOxsiU0PfzJB2AUSR170QvXaS7Se6gd7gFlAU2L9Ln2IsKzE1FPrmCD28kn0/n4C
        1corsWMejK0q8ffebRYIW1ri5rurULaHxPabf6FBOpFRYsGH7YwTGBVmIflnFpJ/ZiGsXsDI
        vIpRMrWgODc9tdi0wDAvtRwezcn5uZsYwclTy3MH490HH/QOMTJxMB5ilOBgVhLhveV+LUWI
        NyWxsiq1KD++qDQntfgQoykwwCcyS4km5wPTd15JvKGJpYGJmZmZiaWxmaGSOO/r1rkpQgLp
        iSWp2ampBalFMH1MHJxSDUybNq98fzPB65LwzCdX/mxPuPdh6dXLD/nlsvWmt7zm+OF9IOG9
        gpOoV7dAR3v1BwFj52VvFr9PCi6P8nglKjjHdbmExc3PsrvSxa+ed0w7b8OiYrn+SBfbq/m/
        +PW9m8sF3wZP/DzlyJHOH5USAs8ncWz3S+n7uu3iwxTJ7YIdn04/XX/W9grTuU7Le8s2Hxdb
        f3Cv1dmOiFDVjFWvqsrcwh1DTLjXte1Lmzv3/anmnTGhW9LubHq41f323kjfc/NNcl/uaF0z
        fVl+ouek42/6dP1FWFeGeX12DG8wfVny5cvPRpO+CgaFN4sXrXTtORMTUp8oFa/ZmcHj2nWB
        QaCTa99H3rZdOklqT7h3FJxQYinOSDTUYi4qTgQA48MWeycEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWy7bCSnK7ut5spBh9iLNZc+c1usfpuP5vF
        x1kvmC2O/n/LZjHp0DVGi+XH/zFZbGgTdGD32DnrLrvH5bOlHptWdbJ5fHx6i8Wjb8sqRo/P
        m+QC2KK4bFJSczLLUov07RK4Mpr2fWUraOWueNC5h62B8S1HFyMnh4SAicS/FaeZuhi5OIQE
        djNKPFuyja2LkQMoIS2xcH0iRI2wxMp/z9khatqZJFbs3ccCkmAT0JZ49fYGM4gtIqAlcWxd
        ExtIEbNAF6PE3t3T2EASwgIRElfXLQCzWQRUJQ5OesQKYvMK2En8OvmUFWKDvMTMS9/ZQWxO
        oPj/Kb/BbCEBW4lVC/dC1QtKnJz5BGwxM1B989bZzBMYBWYhSc1CklrAyLSKUTK1oDg3PTfZ
        sMAwL7Vcrzgxt7g0L10vOT93EyM4tLU0djDem/9P7xAjEwfjIUYJDmYlEd5b7tdShHhTEiur
        Uovy44tKc1KLDzFKc7AoifMazpidIiSQnliSmp2aWpBaBJNl4uCUamCK0i2cslPqR8jSzw2b
        vCIjvwpe+c+4VMV78tLdvBOzt66z/npC7ucTIcstus4ej/+nXNlsvCxQZ3+rWJLTRwN9syxr
        JXWva+ZTjLNfMJfmXp1b/27/4TspCfwRYemODSvrchmqOwJWe4borZjBmq0qaX4yVrh13z6D
        hXbNc2+tMeUNPJYW0HeG99ZZ+ffR1i0u5kv3GyxlSDp9hdmvvdTlrMzSv4Xyb9Zydz/8Mcdt
        xd/NLg9DKyW99bZ9u368eomv7UnNO5ZXOdRrHj4uKVU8JjOJLSJVTmRBlKawzEabv3P23dkq
        t3wJS4mRavr7wJLE21L2K1cGZDQ/ZXOSPmdXtHilxaWKCQt21SxxTVJiKc5INNRiLipOBAAd
        DsKY3AIAAA==
X-CMS-MailID: 20230814093853epcas5p4973ef04622e9bafbc73a9a71c84b94ca
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230814093853epcas5p4973ef04622e9bafbc73a9a71c84b94ca
References: <20230814145747.114725-1-ankit.kumar@samsung.com>
        <CGME20230814093853epcas5p4973ef04622e9bafbc73a9a71c84b94ca@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Pull the 48 bit helpers, required for supporting 48 bit reference tags.
Add GPL 2.0 license to nvme.c and nvme.h files.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/nvme.c |  1 +
 engines/nvme.h | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/engines/nvme.c b/engines/nvme.c
index 6896dfc0..41e7d07b 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * nvme structure declarations and helper functions for the
  * io_uring_cmd engine.
diff --git a/engines/nvme.h b/engines/nvme.h
index a1102dfe..fb1f7760 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * nvme structure declarations and helper functions for the
  * io_uring_cmd engine.
@@ -440,4 +441,20 @@ int fio_nvme_reset_wp(struct thread_data *td, struct fio_file *f,
 int fio_nvme_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 				unsigned int *max_open_zones);
 
+static inline void put_unaligned_be48(__u64 val, __u8 *p)
+{
+	*p++ = val >> 40;
+	*p++ = val >> 32;
+	*p++ = val >> 24;
+	*p++ = val >> 16;
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline __u64 get_unaligned_be48(__u8 *p)
+{
+	return (__u64)p[0] << 40 | (__u64)p[1] << 32 | (__u64)p[2] << 24 |
+		p[3] << 16 | p[4] << 8 | p[5];
+}
+
 #endif
-- 
2.25.1

