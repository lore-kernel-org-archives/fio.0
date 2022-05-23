Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 052ACC433F5
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 16:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238767AbiEWQ3T (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 12:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238699AbiEWQ3S (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 12:29:18 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5F968F91
        for <fio@vger.kernel.org>; Mon, 23 May 2022 09:29:17 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220523162916epoutp04b7c8be787fdccc4f3e4a757a46638440~xyNUp3SHN1033610336epoutp04K
        for <fio@vger.kernel.org>; Mon, 23 May 2022 16:29:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220523162916epoutp04b7c8be787fdccc4f3e4a757a46638440~xyNUp3SHN1033610336epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653323356;
        bh=RdNRG0kSaSr4i9+ftVS5KQW9G/EzyUIKw6EJKVCMLgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UE+OL0HxHEN4U8kOPF5za79uLzuhgL1liOiarhqpA+QE44xHw1F5VAUU1JWhkVNEJ
         kibRCZubELRsGj8CP5ezsYDyeq+zIcdci67/NN4UxHlKXsQNBfXPfKN/lyNbqZQXi6
         86sBHQ41Cxpr3jKW/R6b+35aP5V96EZqgdSp9JoE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220523162915epcas5p436076086e10d9c7e1c33b45bbccffb55~xyNUPy3O_1056510565epcas5p4y;
        Mon, 23 May 2022 16:29:15 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4L6N7q0k5tz4x9Pt; Mon, 23 May
        2022 16:29:11 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        10.EE.09762.656BB826; Tue, 24 May 2022 01:29:10 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220523131623epcas5p418b049ac287ffc218cf46a88d94b2527~xvk7P77i91988519885epcas5p4O;
        Mon, 23 May 2022 13:16:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220523131623epsmtrp15e8d136eaf0fff8cb29fbf5f607bd878~xvk7PSnef2128021280epsmtrp12;
        Mon, 23 May 2022 13:16:23 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-38-628bb6561263
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F2.E2.11276.7298B826; Mon, 23 May 2022 22:16:23 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220523131622epsmtip235354dc36419bda3e9d712821316406b~xvk6Q94F41290312903epsmtip2e;
        Mon, 23 May 2022 13:16:22 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 5/7] zbd: Check for direct flag only if its block device
Date:   Mon, 23 May 2022 18:40:37 +0530
Message-Id: <20220523131039.17697-6-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220523131039.17697-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsWy7bCmlm7Ytu4kgz+7bSzWXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8XCjcuYHNg8Lp8t9ejbsorR4/MmuQDmqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjOk75QousFecfrebsYHx
        P2sXIyeHhICJxKY7x9m7GLk4hAR2M0rcWDCJCcL5xCixYVI7VOYbo8TBV8+Zuxg5wFpWT5OF
        iO9llJjTf5gZwmllkjh7ZRYTyFw2AW2JV29vMIPYIgLCEvs7WllAipgFWhglGlevZQFJCAt4
        SPT2vmUEsVkEVCWWnupnB9nAK2Aj0TBBGuI+eYnVGw6AzeEUsJW48+EfM0R8HbvE48flELaL
        xOr7+5ggbGGJV8e3sEPYUhIv+9ug7GyJxkd/2SDsEomdt7ZDzbGXuLjnLxPIWmYBTYn1u/Qh
        wrISU0+tAxvJLMAn0fv7CdR4Xokd82BsVYm/926zQNjSEjffXYWyPSReTuphg4TJBEaJFz8X
        sE9glJuFsGIBI+MqRsnUguLc9NRi0wLjvNRyeJwl5+duYgQnLC3vHYyPHnzQO8TIxMF4iFGC
        g1lJhHd7YkeSEG9KYmVValF+fFFpTmrxIUZTYPBNZJYSTc4Hpsy8knhDE0sDEzMzMxNLYzND
        JXFegf+NSUIC6YklqdmpqQWpRTB9TBycUg1MTS0Sjf7T6v45vHhscPVSoZGQ3ZalaoHyjo4s
        aqzZV70cf1+aqnDTQebmj0vFT+4kH5k9W+HpPKZZCdyXbjdt+S4y1/ob06UZW4pkvk7IfXa+
        70u80OTwqawLdgQoLfmsWvP90fONB1V2pWrJrVs9jaXwIPfxc+Lx5dunzJsvF7PMr8oo4QqD
        n1qV9jKVfJam9IJoL68zj94JvzKPObutIPJEnMf+ol9iYjuahY8e52xs/Gu3ckJfcE2jnEak
        sqfSrNlTHKTb9s0V+NG1UG3H2waX4BjPlxtPvbO2C7q2ID9li7dTUJh15G6OU2uuSfUYLtm7
        u1yS1W6Gu8etK0uXfpJ4aO+0RexOcMsjq4pcJZbijERDLeai4kQAFTcf+uEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42LZdlhJXle9szvJ4HmrscWaK7/ZLZom/GW2
        WH23n83i46wXzBZH/79ls1i4cRmTA5vH5bOlHn1bVjF6fN4kF8AcxWWTkpqTWZZapG+XwJUx
        fadcwQX2itPvdjM2MP5n7WLk4JAQMJFYPU22i5GLQ0hgN6PE/fdH2CDi0hIL1yd2MXICmcIS
        K/89Z4eoaWaS2Du1hwkkwSagLfHq7Q1mEFsEqGh/RysLSBGzQBejRE/nKbAiYQEPid7et4wg
        NouAqsTSU/3sIAt4BWwkGiZIQyyQl1i94QDYHE4BW4k7H/4xg5QIAZXs+BEygZFvASPDKkbJ
        1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4HDS0tzBuH3VB71DjEwcjIcYJTiYlUR4tyd2
        JAnxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXA1Br742t6
        WLAjW6v7ns/r1042rzv7XfQx8xHmH/L13EWzivrncT25VqldtGT/qr3vv/n8fnZJSLt9Xxr/
        ltitb35oHeoSE9zyvP63zKHPHFHeOs2c26e+s1fodCjmF5j968GfkNh2p9LeRC6RyMYZHJs+
        x8qahKjsWGOyr1twbnD5/tmlV1qfpF8/vGFbz4cYDhmdyeqvDscafr7JOP1BwKQ/d2XlW/kW
        M5WV/22TuJLWsdg6PF797jSZn/EnP5h738vd/W3lQV2ZmP7CSbO/ai+JWPyvJ+9D0EUdqaCS
        ou1R06XvJInd5Ui2WmVWtyq43Wbrtt8nsnZP2Pgm8WeOZ85q0eJlWteVcqqO3r1yTomlOCPR
        UIu5qDgRAArlh2uWAgAA
X-CMS-MailID: 20220523131623epcas5p418b049ac287ffc218cf46a88d94b2527
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220523131623epcas5p418b049ac287ffc218cf46a88d94b2527
References: <20220523131039.17697-1-ankit.kumar@samsung.com>
        <CGME20220523131623epcas5p418b049ac287ffc218cf46a88d94b2527@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

nvme-ns generic character devices currently do not support
O_DIRECT flag. Check for fio option direct flag only if
filetype is a block device.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 zbd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index b1fd6b4b..627fb968 100644
--- a/zbd.c
+++ b/zbd.c
@@ -466,7 +466,7 @@ out:
 	return res;
 }
 
-/* Verify whether direct I/O is used for all host-managed zoned drives. */
+/* Verify whether direct I/O is used for all host-managed zoned block drives. */
 static bool zbd_using_direct_io(void)
 {
 	struct thread_data *td;
@@ -477,7 +477,7 @@ static bool zbd_using_direct_io(void)
 		if (td->o.odirect || !(td->o.td_ddir & TD_DDIR_WRITE))
 			continue;
 		for_each_file(td, f, j) {
-			if (f->zbd_info &&
+			if (f->zbd_info && f->filetype == FIO_TYPE_BLOCK &&
 			    f->zbd_info->model == ZBD_HOST_MANAGED)
 				return false;
 		}
-- 
2.17.1

