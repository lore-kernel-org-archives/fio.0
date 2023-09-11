Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECFDCA0EDA
	for <fio@archiver.kernel.org>; Mon, 11 Sep 2023 22:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358463AbjIKWLP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbjIKLNV (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Sep 2023 07:13:21 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2E5CDD
        for <fio@vger.kernel.org>; Mon, 11 Sep 2023 04:13:17 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230911111315epoutp03f16320b656cd075202adf2d8633dde69~D09TCBbhD1532415324epoutp03O
        for <fio@vger.kernel.org>; Mon, 11 Sep 2023 11:13:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230911111315epoutp03f16320b656cd075202adf2d8633dde69~D09TCBbhD1532415324epoutp03O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1694430795;
        bh=O0I2JT9CenS+E21gtT83yiYvKUVWX8enBNFCZRpuxbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooqFwXKP3OrTUMC5Xxwq2AKBSei9jLxW718iLK5h98/yu/gLtYQ15PET/ouW+5zoC
         QBZvgmxXzLv7Vv7YldKVn9S1b5nEsi/0GRWDK4EMuo+fYy/mDsz19hM1E/ZzbBWScy
         OXIzNzJifwjCMsu93BmLK89Jit6xC58NqA3OpECE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230911111315epcas5p1594d299321de2bba4cf98822590ef4f3~D09So_lsJ0748607486epcas5p16;
        Mon, 11 Sep 2023 11:13:15 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4RkkbY64qFz4x9Px; Mon, 11 Sep
        2023 11:13:13 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BA.5E.19094.746FEF46; Mon, 11 Sep 2023 20:13:11 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230911110622epcas5p1603928810e5dff20d2cdb2f612b28120~D03SaDxJR1184511845epcas5p1W;
        Mon, 11 Sep 2023 11:06:22 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230911110622epsmtrp1a0fde54bb0e29070c6431f6d399c9c43~D03SZdqsy1588315883epsmtrp1H;
        Mon, 11 Sep 2023 11:06:22 +0000 (GMT)
X-AuditID: b6c32a50-64fff70000004a96-f0-64fef64767ec
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C0.F0.08742.EA4FEF46; Mon, 11 Sep 2023 20:06:22 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230911110621epsmtip267d694991558e2a15a8d1dbd08feee08~D03RkzFno2745027450epsmtip2x;
        Mon, 11 Sep 2023 11:06:21 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 2/2] engines:nvme: fill command fields as per pi check bits
Date:   Mon, 11 Sep 2023 21:55:00 +0530
Message-Id: <20230911162500.271118-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230911162500.271118-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsWy7bCmlq77t38pBg2d5hZrrvxmt1h9t5/N
        4uOsF8wWR/+/ZbPY0CbowOqxc9Zddo/LZ0s9+rasYvT4vEkugCUq2yYjNTEltUghNS85PyUz
        L91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKuSQlliTilQKCCxuFhJ386mKL+0
        JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITujp+EmS8Ec7or18/cyNjD+
        4uhi5OSQEDCR2Hr5KXMXIxeHkMAeRolFO+YzQjifGCVuXPoG5XxjlHj2ZBkLTEvzzDOsEIm9
        jBIX2v9COZ1MEt/fvGMDqWIT0JZ49fYG0GAODhEBDYk1d1NBwswCoRL9LR1gg4QFvCX6vtxn
        B7FZBFQl/p9eyA5SzitgK9FxXA5il7zEzEvfwcKcAnYSD04zg4R5BQQlTs58wgIxUV6ieets
        sA8kBC6xS1z4uADqTheJaTdvskHYwhKvjm9hh7ClJF72t0HZ2RKbHv5kgrALJI686GWGsO0l
        Wk/1g13PLKApsX6XPkRYVmLqqXVMEHv5JHp/P4Fq5ZXYMQ/GVpX4e+821AnSEjffXYWyPSRm
        L+yFhvRERonpn7pYJzAqzELyzywk/8xCWL2AkXkVo1RqQXFuemqyaYGhbl5qOTySk/NzNzGC
        E6JWwA7G1Rv+6h1iZOJgPMQowcGsJMJbcuhvihBvSmJlVWpRfnxRaU5q8SFGU2B4T2SWEk3O
        B6bkvJJ4QxNLAxMzMzMTS2MzQyVx3tetc1OEBNITS1KzU1MLUotg+pg4OKUamBa5u9iaxhY1
        G5/Sv6dxgOPdya53DzM2mW/87vazkZv1O2fBpei/X0q+3ly8K/A657bE5QEJJ6qPXDl5fZfy
        3+OHHl32tF0y8cjcpXtr6/85rfR7lh25snXL3aBcwYPv5cuMnPTducv3uTtPjCoP/T5n90er
        16s1nNN8X0TMMZ8tdHmvn7VX928HG9dFns8mNQq2Pny+6sU6Uf89S135zJedlNilY5gR8bfy
        9Gvtnz5tDxbc9c/6376TT9ej7oH30/Xr0v4a7H8uedpQe0W1bP0q6SDRnuvvexr09DpSNny+
        crZz5zkhuXll3AnH7zE5/NiQJ3vuWJv0jNMKpzl3hEZ6pOXPZt8ene9aqOpcV6rEUpyRaKjF
        XFScCAAZl7ZyEQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWy7bCSvO66L/9SDHatk7VYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFhjZBB1aPnbPusntcPlvq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBk9
        DTdZCuZwV6yfv5exgfEXRxcjJ4eEgIlE88wzrF2MXBxCArsZJS7fWQbkcAAlpCUWrk+EqBGW
        WPnvOTtETTuTxMtPvawgCTYBbYlXb28wg9giAloSx9Y1sYHYzALhEo2zQRo4OYQFvCX6vtwH
        s1kEVCX+n17IDjKfV8BWouO4HMR8eYmZl76DhTkF7CQenAabKARUMeHwZ7BNvAKCEidnPmGB
        mC4v0bx1NvMERoFZSFKzkKQWMDKtYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIDlct
        zR2M21d90DvEyMTBeIhRgoNZSYS35NDfFCHelMTKqtSi/Pii0pzU4kOM0hwsSuK84i96U4QE
        0hNLUrNTUwtSi2CyTBycUg1MEjFy53jFKtrSHnQJlcZ9qetZ2tilra27pPvIDEfGA6vP2G6y
        nND5LsslcWpUbJyMA98u1s7P3dOiDeSmXTu4pOQdx6Ugln+fU7e4B2fyrDzlUmGStLTgzVnd
        KeoTrs9errrE4ZDTUtafz5/f6732Zb55Tbfh0XOO5y8fj7C4rfJD4va3BR7L9bu+nHR+NHn6
        wR9uOVEfMo58ZD76c/ur4ml/Jjct63mot09AdPlc1mPdhkIv53KY66z8V+Sp15GRvTX8jFEw
        q9qXLefmLf+gvlTmjHpOJxvzn9ZThd+Ze+Zddjm0LOAjV+f/JeEXT7AdWMt+4921meefWBz4
        oqV9P2/r1vodSlL3ebsKL5aEXlBiKc5INNRiLipOBAAk2WF/xgIAAA==
X-CMS-MailID: 20230911110622epcas5p1603928810e5dff20d2cdb2f612b28120
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230911110622epcas5p1603928810e5dff20d2cdb2f612b28120
References: <20230911162500.271118-1-ankit.kumar@samsung.com>
        <CGME20230911110622epcas5p1603928810e5dff20d2cdb2f612b28120@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Fill the application and reference tag field for read and write
command only when pi_chk has the relevant bit set.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/nvme.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/engines/nvme.c b/engines/nvme.c
index 08503b33..75a5e0c1 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -415,19 +415,24 @@ void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	case NVME_NS_DPS_PI_TYPE2:
 		switch (data->guard_type) {
 		case NVME_NVM_NS_16B_GUARD:
-			cmd->cdw14 = (__u32)slba;
+			if (opts->io_flags & NVME_IO_PRINFO_PRCHK_REF)
+				cmd->cdw14 = (__u32)slba;
 			break;
 		case NVME_NVM_NS_64B_GUARD:
-			cmd->cdw14 = (__u32)slba;
-			cmd->cdw3 = ((slba >> 32) & 0xffff);
+			if (opts->io_flags & NVME_IO_PRINFO_PRCHK_REF) {
+				cmd->cdw14 = (__u32)slba;
+				cmd->cdw3 = ((slba >> 32) & 0xffff);
+			}
 			break;
 		default:
 			break;
 		}
-		cmd->cdw15 = (opts->apptag_mask << 16 | opts->apptag);
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_APP)
+			cmd->cdw15 = (opts->apptag_mask << 16 | opts->apptag);
 		break;
 	case NVME_NS_DPS_PI_TYPE3:
-		cmd->cdw15 = (opts->apptag_mask << 16 | opts->apptag);
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_APP)
+			cmd->cdw15 = (opts->apptag_mask << 16 | opts->apptag);
 		break;
 	case NVME_NS_DPS_PI_NONE:
 		break;
-- 
2.25.1

