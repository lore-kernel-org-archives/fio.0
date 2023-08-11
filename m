Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E71EB64DD
	for <fio@archiver.kernel.org>; Fri, 11 Aug 2023 07:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjHKHr1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 11 Aug 2023 03:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbjHKHrZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 11 Aug 2023 03:47:25 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C671FDD
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 00:47:24 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230811074723epoutp0195a2f4f74d90db585d3bebf259d74701~6RJsi6sVe2539025390epoutp019
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 07:47:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230811074723epoutp0195a2f4f74d90db585d3bebf259d74701~6RJsi6sVe2539025390epoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691740043;
        bh=z6PgEz3ELbeX/kaPQy8Jd7jhQAc2PN8YtIZGtGXRb8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgMvJ2QkUbdCql99naPLPaFgufVCEJI/mBlMOpUEb8cvP3ESCjuy7KmioqnWhsv4n
         EQeUvYEHhqfUDDLonFqK8ifVIbnZ1G4TGFl07OSmL3k8MDzIpufBjulfPqa0MxaYRb
         5uVr5/wFF37fpFfRAJ4rAaYJp6QpNF5yWikVhluY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230811074722epcas5p1d25b5e058d6640dcf698e0871382e9e6~6RJsKZu-W0501305013epcas5p1Q;
        Fri, 11 Aug 2023 07:47:22 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4RMbVJ5ngSz4x9Pw; Fri, 11 Aug
        2023 07:47:20 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        91.B6.06099.887E5D46; Fri, 11 Aug 2023 16:47:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230811060647epcas5p1fadd4d56b4276a477760611d42445ddb~6Px3VR14d2170921709epcas5p1b;
        Fri, 11 Aug 2023 06:06:47 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230811060647epsmtrp2876d2ebf3eaf153f8297cb738d157c04~6Px3Ulq3v2376023760epsmtrp2O;
        Fri, 11 Aug 2023 06:06:47 +0000 (GMT)
X-AuditID: b6c32a4b-d308d700000017d3-2a-64d5e788b8e9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        65.E0.14748.7FFC5D46; Fri, 11 Aug 2023 15:06:47 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230811060645epsmtip1142aa1a264ec67b459fcb7da9c35c9fb~6Px2Arq193108331083epsmtip1D;
        Fri, 11 Aug 2023 06:06:45 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 09/10] engines:nvme: pull required 48 bit accessors from
 linux kernel
Date:   Fri, 11 Aug 2023 16:55:46 +0530
Message-Id: <20230811112547.92345-10-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230811112547.92345-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmlm7H86spBt/adC3WXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gC5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgY
        mQIVJmRnHH/Zx17Qyl3R8P8LawPjW44uRk4OCQETiXd72hi7GLk4hAR2M0p8vP0WyvkE5Gx8
        yAbhfGOUWHBuCVMXIwdYy+ImHZBuIYG9jBIv5lRA1HQyScx/spUdJMEmoC3x6u0NZpB6EQEN
        iTV3U0FqmAVaGCV2d89mBYkLC0RJnJvsCVLOIqAq8anjDCuIzStgK7Gt6zAjxHXyEjMvfWcH
        KecEii9aIQZRIihxcuYTFhCbGaikeetsZpDxEgJf2SU+nZ4E1esicWr1DhYIW1ji1fEt7BC2
        lMTnd3vZIOxsiU0PfzJB2AUSR170MkPY9hKtp/rBzmcW0JRYv0sfIiwrMfXUOiaIvXwSvb+f
        QLXySuyYB2OrSvy9dxtqrbTEzXdXoWwPiUlnt7FAgmoCo8Th/iNsExgVZiH5ZxaSf2YhrF7A
        yLyKUTK1oDg3PbXYtMA4L7UcHsXJ+bmbGMFJU8t7B+OjBx/0DjEycTAeYpTgYFYS4bUNvpQi
        xJuSWFmVWpQfX1Sak1p8iNEUGN4TmaVEk/OBaTuvJN7QxNLAxMzMzMTS2MxQSZz3devcFCGB
        9MSS1OzU1ILUIpg+Jg5OqQamkp2zD8/e4/8l88yZjydvGhmsrr8asObhZi/jLQc/hBkbHvP/
        tG7dxOAX5XXz7Dh2hTku0fwhMXPr+sLvFrL7mXenOU7zvsjNpnnH8+yrr7ff7jj1p26XduOv
        mVkB6/qztj/YY9OdyekwLXrGI7Ffr7js3xlP7mCqV7D/E+uiUMHWaWTQW1OWXt7IsLO0Wkj+
        imuOkXbIvWWy+yYuPdn5r6xtoeckt5qSpwknDzpNO9PgGr700f3UP3PTgxj6vuSsO8BxQSVq
        lWBZ/M+934tfbXG8ncH7X+3UhDlJWqyO+z5mT8z6UHby9M6cczW/Li7/vPDMnhtPGG4sbXkw
        Y6ewfsmNpO8JiW7/33fwTJFl3K/EUpyRaKjFXFScCACT9rGvIwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWy7bCSnO7381dTDK6/FbBYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CL4rJJSc3JLEst0rdL4Mo4/rKPvaCVu6Lh/xfWBsa3HF2MHBwSAiYSi5t0uhi5OIQE
        djNK3L/czwIRl5ZYuD6xi5ETyBSWWPnvOTtETTuTRNvH2ewgCTYBbYlXb28wg9giAloSx9Y1
        sYEUMQt0MUrs3T2NDSQhLBAhcWb5NlYQm0VAVeJTxxkwm1fAVmJb12FGiA3yEjMvfWcHWcwJ
        FF+0QgwkLCRgI/Fq5m82iHJBiZMzn7CA2MxA5c1bZzNPYBSYhSQ1C0lqASPTKkbJ1ILi3PTc
        ZMMCw7zUcr3ixNzi0rx0veT83E2M4MDW0tjBeG/+P71DjEwcjIcYJTiYlUR4bYMvpQjxpiRW
        VqUW5ccXleakFh9ilOZgURLnNZwxO0VIID2xJDU7NbUgtQgmy8TBKdXAlLJx51a1JVL3d3/R
        X/vI7e0Pe/0d7tmlHZnT2dZfPnOa4+SjGXbH77fcYJv+ti++SMBex/T/Y5n8syfDNW5vMhPf
        klJbttjsomScYNYrVauSM20zwkSP3Sm/kHTD7uiqRezC7zLX3UsxuvTt0weh9+HpNlenZ0YE
        d9dHRFjXVi36subR+115kzkFzhxQCbG6dubME6M7bpHtklclGN767zXxZsos/Xj/2dL3st+t
        s06feSqfHtB3dlnV4vMvMtKOsorbFTlfzF6T7rq/9u7XntO1RjNerroxlc81abdo/eU0JUmD
        /7H7/nTs386z1E5234/tYqsn3bvXcF6OaUdhC+PWdTtq1oWeN7wqbH3Re60SS3FGoqEWc1Fx
        IgDHC8Kr2wIAAA==
X-CMS-MailID: 20230811060647epcas5p1fadd4d56b4276a477760611d42445ddb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811060647epcas5p1fadd4d56b4276a477760611d42445ddb
References: <20230811112547.92345-1-ankit.kumar@samsung.com>
        <CGME20230811060647epcas5p1fadd4d56b4276a477760611d42445ddb@epcas5p1.samsung.com>
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
index e308331f..18740138 100644
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

