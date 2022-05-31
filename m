Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C45FBC433FE
	for <fio@archiver.kernel.org>; Wed,  1 Jun 2022 09:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345160AbiFAJkN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 1 Jun 2022 05:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344258AbiFAJkM (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Jun 2022 05:40:12 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562E24924A
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 02:40:11 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220601094009epoutp02446e89f0ea860e42b593d432fb71b2b6~0dbsZwZkJ2836128361epoutp025
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 09:40:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220601094009epoutp02446e89f0ea860e42b593d432fb71b2b6~0dbsZwZkJ2836128361epoutp025
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1654076409;
        bh=fBOyPamGXff/wKq7HnksghCp6pXR0bFx/TPodgXMNpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXN/dZ98U21Um/naWJKCOsghQz4cwgaSAoZtFKNntvTwXxa2g6JuBEtPA9ZhKXA0r
         9jcD/rlr/JAtcnQDXl1ccQGi9hz03VMIb7FdpdBfqEf02uZwHlUF18Yyv5kBue1rDs
         RmIVPm0tTzXKz7dY0DQwHfUS+3Ohkx1yJg/RYlU4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220601094009epcas5p235c68a716560c4134e70da79f0580a24~0dbsFkl2P0365803658epcas5p2n;
        Wed,  1 Jun 2022 09:40:09 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4LCkdc0BL9z4x9Pv; Wed,  1 Jun
        2022 09:40:04 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        62.E4.10063.2F337926; Wed,  1 Jun 2022 18:40:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220531133743epcas5p4d400c341f29489c51e3ee5590415420c~0NB01DiTp1877418774epcas5p4b;
        Tue, 31 May 2022 13:37:43 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220531133743epsmtrp17c4ca35a21ff4b089876aca1a46a394e~0NB00cGod2715827158epsmtrp1e;
        Tue, 31 May 2022 13:37:43 +0000 (GMT)
X-AuditID: b6c32a49-4b5ff7000000274f-f8-629733f25950
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C7.F4.11276.72A16926; Tue, 31 May 2022 22:37:43 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220531133741epsmtip2beb30a33f98d527bbf0ffedef1714ac8~0NBzjzBBZ2551725517epsmtip25;
        Tue, 31 May 2022 13:37:41 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com
Subject: [PATCH v3 3/9] init: return error incase an invalid value is passed
 as option
Date:   Tue, 31 May 2022 19:01:49 +0530
Message-Id: <20220531133155.17493-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220531133155.17493-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsWy7bCmuu4n4+lJBk8apC2aJvxltlh9t5/N
        4uOsF8wWR/+/ZbNYuHEZkwOrx+WzpR59W1YxenzeJBfAHJVtk5GamJJapJCal5yfkpmXbqvk
        HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCR
        X1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnXF+1la2gi+sFUsnfWNuYNzM0sXI
        wSEhYCKx6Ux9FyMXh5DAbkaJT4c3skE4nxglui59ZIRwvjFKLLx9FaiDE6zj4dq5zBCJvYwS
        Z5ZsYYVwWpkkpv+YyQpSxSagLfHq7Q1mEFtEQFhif0crWDezQKzE820NTCC7hQUiJHYdtAAJ
        swioStw4No0RxOYVsJH4OW8N1DJ5idUbDoCN4RSwlZg3dT3YLgmBVewSS640MUIUuUjMmXKA
        FcIWlnh1fAs7hC0l8bK/DcrOlmh89JcNwi6R2HlrOzOEbS9xcc9fsHuYBTQl1u/ShwjLSkw9
        tY4J4mQ+id7fT5gg4rwSO+bB2KoSf+/dhrpTWuLmO1gAeUi8bdvBAgmTCYwS+17eZZzAKDcL
        YcUCRsZVjJKpBcW56anFpgWGeanl8EhLzs/dxAhOVFqeOxjvPvigd4iRiYPxEKMEB7OSCG/J
        rqlJQrwpiZVVqUX58UWlOanFhxhNgQE4kVlKNDkfmCrzSuINTSwNTMzMzEwsjc0MlcR5Bf43
        JgkJpCeWpGanphakFsH0MXFwSjUwBX8/ELiL5aGiaUKikeKHdz88t8+qjkp52XYuN+Gp3o+7
        hoLMAYLuj2y/7nObEROww+jBXJWEvvDtlVf+m8xV78l8NLezjvlKz8M/qXvNXzcJPp7bOWGm
        ET/3qXu/vk6LsLrdKX0v9cjW16evvI0oOdh3d9sTxZ89+YVv50U90NsWPim1PpJtzd6DDt0J
        xc6nnwcsmXNy5Yb+qUld70PDVXh+MSTm7H/+mpfnt4665tcpp7gfzP2WrjBTOUvj1tzLq0yU
        +eQ6m8wvzj+nfrfgZcS82FcbF6aYR7k/8sr+k//ttNvhTSff9imdjrr/7UNf0EWBKVV+t+f1
        zapwMVy2tsIxeWPJNlnBCu0DbG4tb5VYijMSDbWYi4oTAQVyDZPdAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsWy7bCSvK661LQkg/cdHBZNE/4yW6y+289m
        8XHWC2aLo//fslks3LiMyYHV4/LZUo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKOD9rK1vB
        F9aKpZO+MTcwbmbpYuTkkBAwkXi4di5zFyMXh5DAbkaJCVtvMHYxcgAlpCUWrk+EqBGWWPnv
        OTuILSTQzCQx5xk3iM0moC3x6u0NZhBbBKhmf0cr2ExmgUSJHZN2gY0RFgiTOLbUESTMIqAq
        cePYNEYQm1fARuLnvDVQJ8hLrN5wAGwMp4CtxLyp61khVtlITH2xgHECI98CRoZVjJKpBcW5
        6bnFhgWGeanlesWJucWleel6yfm5mxjBYaSluYNx+6oPeocYmTgYDzFKcDArifCW7JqaJMSb
        klhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVAMTm8uXoylrTWL+
        f52erfZcPejnQaHT0sfm/j/9sOLP9SsTV9sWbuTMuMU3nW+LfjpjWeKS5zcX1kof/OLveqn7
        xtZbP2tKBX/LcLOLLxEJKI14ueqJyD1jaRWZ2i42cYc7e/eFTZjypHzvcaX7f2u+7d/Vumv1
        jJ2/QkKZWr8tjswya5t1LeinTOhixhqDeEnxfL/UVzknEwxPS5yTTJyuV9rLyxPL/+kXy/UT
        /Zk7zR4oWtdU7ipV/1f2/d26FXc2Zh3XLU+rjX1pHO5c43laJcuHRfz8l4tBG222Hdhset9m
        TY/ZBIk33iF357CtFek53Sd075fR1r/LfOadPtywMEe3Z1fd2Q/fEpXVv6+frMRSnJFoqMVc
        VJwIAHVV8BWSAgAA
X-CMS-MailID: 20220531133743epcas5p4d400c341f29489c51e3ee5590415420c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220531133743epcas5p4d400c341f29489c51e3ee5590415420c
References: <20220531133155.17493-1-ankit.kumar@samsung.com>
        <CGME20220531133743epcas5p4d400c341f29489c51e3ee5590415420c@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

Currently, fio exits incase an invalid value is passed as fio
option, but continues even if an invalid value is passed for
I/O engine specific options. Exit in that scenario.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 init.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/init.c b/init.c
index f7d702f8..da800776 100644
--- a/init.c
+++ b/init.c
@@ -2810,6 +2810,15 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				break;
 
 			ret = fio_cmd_ioengine_option_parse(td, opt, val);
+
+			if (ret) {
+				if (td) {
+					put_job(td);
+					td = NULL;
+				}
+				do_exit++;
+				exit_val = 1;
+			}
 			break;
 		}
 		case 'w':
-- 
2.17.1

