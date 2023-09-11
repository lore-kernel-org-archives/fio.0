Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A9CCA0EC9
	for <fio@archiver.kernel.org>; Mon, 11 Sep 2023 22:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359194AbjIKWPp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236691AbjIKLNU (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Sep 2023 07:13:20 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC77CC3
        for <fio@vger.kernel.org>; Mon, 11 Sep 2023 04:13:15 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230911111314epoutp04358f4fcb3bd1c1de07ddfaeccaa15a98~D09RlCINh2737627376epoutp04q
        for <fio@vger.kernel.org>; Mon, 11 Sep 2023 11:13:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230911111314epoutp04358f4fcb3bd1c1de07ddfaeccaa15a98~D09RlCINh2737627376epoutp04q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1694430794;
        bh=+Enhez8UbuLGRZVqxU0oYB6QN7nSp/UsYSRB3GpxXcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qzM4/7oWtPuDVDOVAX6GaGAU1yvlD3nxm+d6t3a6D5P3yhRBAB9vl3PCKG6XIAqNh
         xD6tZy30elPpBWcY21txYqm734jnrZcaBllKc5IsHNt/sYtd8vDwozUmMf5QYzc16N
         dZCTyRSvVEtXWp9pGjYTfRYWmC4+tbpN1w5qfG4A=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230911111313epcas5p1610a3f1d5aea5a7cec87032918cdbc50~D09RRLmL_0749607496epcas5p1_;
        Mon, 11 Sep 2023 11:13:13 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4RkkbW6jwQz4x9Q1; Mon, 11 Sep
        2023 11:13:11 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
        09.5E.19094.346FEF46; Mon, 11 Sep 2023 20:13:07 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230911110621epcas5p42694479993ca275323ce86d39b29b5f7~D03Rcufcd1578015780epcas5p46;
        Mon, 11 Sep 2023 11:06:21 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230911110621epsmtrp1d08f32e36896c9006d4077132356ae44~D03RcBW801588315883epsmtrp1-;
        Mon, 11 Sep 2023 11:06:21 +0000 (GMT)
X-AuditID: b6c32a50-39fff70000004a96-e2-64fef6430c30
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        30.F0.08742.DA4FEF46; Mon, 11 Sep 2023 20:06:21 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230911110620epsmtip27efd8e561ada25db54df4ad6f5dde097~D03QoDvDV2756627566epsmtip2x;
        Mon, 11 Sep 2023 11:06:20 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/2] engines:io_uring_cmd: disallow verify for e2e pi with
 extended blocks
Date:   Mon, 11 Sep 2023 21:54:59 +0530
Message-Id: <20230911162500.271118-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230911162500.271118-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmlq7zt38pBqsvilmsufKb3WL13X42
        i4+zXjBbHP3/ls1iQ5ugA6vHzll32T0uny316NuyitHj8ya5AJaobJuM1MSU1CKF1Lzk/JTM
        vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoK1KCmWJOaVAoYDE4mIlfTubovzS
        klSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMyRfvMBbc5q74cnsKewPj
        PM4uRk4OCQETianHVjJ3MXJxCAnsYZT4c/YOO4TziVHi6O2FjBDON0aJE1MvMMG0XFrZwwKR
        2Mso0Tm1FSwhJNDJJPGwIwzEZhPQlnj19gbQXA4OEQENiTV3U0HCzAKhEv0tHSwgtrBAjMTR
        hb/AbBYBVYmrC1axg9i8ArYSbx/9YoPYJS8x89J3dpAxnAJ2Eg9OM0OUCEqcnPmEBWKkvETz
        1tlgH0gIXGKXOLtoBtSdLhK/331lh7CFJV4d3wJlS0m87G+DsrMlNj38CVVfIHHkRS8zhG0v
        0XqqH+x8ZgFNifW79CHCshJTT61jgtjLJ9H7+wlUK6/EjnkwtqrE33u3WSBsaYmb765C2R4S
        R7r2sUFCaiKjxKaLhhMYFWYheWcWkndmIWxewMi8ilEqtaA4Nz012bTAUDcvtRwex8n5uZsY
        welQK2AH4+oNf/UOMTJxMB5ilOBgVhLhLTn0N0WINyWxsiq1KD++qDQntfgQoykwvCcyS4km
        5wMTcl5JvKGJpYGJmZmZiaWxmaGSOO/r1rkpQgLpiSWp2ampBalFMH1MHJxSDUwFPIsMDp5L
        XndEPtQvroHRe8m9K3GZxvn3Y1Z+99725s3eZ0dTXc6vrPCU8HV+0XtWxUmzT+ZKoDT7LR2x
        JZMWHnv6OPtk88XCVzm2x3tjei2yvzKfmGQVGHUj90NIyFOF0EV+UWeXT2aLF0zcZLNydrmi
        6Inbe57qtetLTVzz+8LinGM6d74nSznVaCyPP2zR/lPx/jm+2kruRd82uqyWknhypKGzeOPS
        k768r5fffl8iYSo94bXi0eKzqnyrv7Nt8nt638em6qxgTFpcq5GakyTL89jP7wu/vFT73KG/
        K0zib7qa8rTFvQW3//nP+MF7UW/n5PWa4TWhLlvZWbX/vMncNeeRw/aZt0++rLmtxFKckWio
        xVxUnAgAClE5QhAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsWy7bCSvO7aL/9SDG59kbVYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFhjZBB1aPnbPusntcPlvq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmT
        L95hLLjNXfHl9hT2BsZ5nF2MnBwSAiYSl1b2sHQxcnEICexmlLjSsYy5i5EDKCEtsXB9IkSN
        sMTKf8/ZIWramSRe/DvHCpJgE9CWePX2BjOILSKgJXFsXRMbiM0sEC7ROBukgZNDWCBK4v3b
        SWD1LAKqElcXrAKL8wrYSrx99IsNYoG8xMxL39lB9nIK2Ek8OA02UgioZMLhz6wQ5YISJ2c+
        YYEYLy/RvHU28wRGgVlIUrOQpBYwMq1ilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAgO
        WC3NHYzbV33QO8TIxMF4iFGCg1lJhLfk0N8UId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rziL3pT
        hATSE0tSs1NTC1KLYLJMHJxSDUyx6pLSE958nzOJ9dlBk9tX9M7kS93rf11jKLruy07/KY8D
        Qo223/gu+n7ntGvTNjZd+7m8cct6poQnNRMC/DeZVk54t/6WTWIo/3P1kx8dJs593X0jODQh
        kLkwo8W++fcijhi1kH3P+XYuOTjt+QHzKi+Ph8/O7FNOPTXr6umqxaxKwS8mHhWuavVZJan4
        tTby5IJvOduXre66XqH8b+eR948lbJ4LeDw+1sTwwW1G50Gfx816TNU5+Un7Xy7JTfdf9fr+
        9oetl2QnqOp0XZXcZeYX9DbV8jX3PfWaE3M1kpIZe8yPWQVyTvtmI/E4YIfqVKZdyz+ve3u+
        4X/4z7VeE3nKojZ/OaWu89H09rI9IUosxRmJhlrMRcWJAIif+u/HAgAA
X-CMS-MailID: 20230911110621epcas5p42694479993ca275323ce86d39b29b5f7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230911110621epcas5p42694479993ca275323ce86d39b29b5f7
References: <20230911162500.271118-1-ankit.kumar@samsung.com>
        <CGME20230911110621epcas5p42694479993ca275323ce86d39b29b5f7@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

For extended logical block sizes we cannot use verify when end to end
data protection checks are enabled. The CRC field in PI section of
data buffer creates conflict during verify phase.
The verify check is also redundant as end to end data protection already
ensures data integrity. So disallow use of verify for this case.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 6cdf1b4f..05703df8 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -18,6 +18,7 @@
 #include "../lib/memalign.h"
 #include "../lib/fls.h"
 #include "../lib/roundup.h"
+#include "../verify.h"
 
 #ifdef ARCH_HAVE_IOURING
 
@@ -1299,6 +1300,19 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 				return 1;
 			}
                 }
+
+		/*
+		 * For extended logical block sizes we cannot use verify when
+		 * end to end data protection checks are enabled, as the PI
+		 * section of data buffer conflicts with verify.
+		 */
+		if (data->ms && data->pi_type && data->lba_ext &&
+		    td->o.verify != VERIFY_NONE) {
+			log_err("%s: for extended LBA, verify cannot be used when E2E data protection is enabled\n",
+				f->file_name);
+			td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
+			return 1;
+		}
 	}
 	if (!ld || !o->registerfiles)
 		return generic_open_file(td, f);
-- 
2.25.1

