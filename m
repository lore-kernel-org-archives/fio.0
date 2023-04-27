Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC932C77B73
	for <fio@archiver.kernel.org>; Thu, 27 Apr 2023 18:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244554AbjD0SgM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Apr 2023 14:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243558AbjD0SgL (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Apr 2023 14:36:11 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0C4E2
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 11:36:06 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230427183604epoutp04318004c35ec394c107f9291398e7d19e~Z3nz1PFp73113731137epoutp04D
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 18:36:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230427183604epoutp04318004c35ec394c107f9291398e7d19e~Z3nz1PFp73113731137epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682620564;
        bh=QPBrJeJvx7+3uhK+DutobynSoqSJhImoc/EsUdHGa+I=;
        h=From:To:Cc:Subject:Date:References:From;
        b=GJzq1RAS/yXREcm618e/wvRU70KEdYZe7Pq9NwwS/Tyk2tFOVHXG0AVZS5ao61Pun
         ikosli0xszOY8EXkGInuqf5Tq834eGAFbU8zmMtEfzw1THefRwqaITX+rpwCrl1PpV
         hRSsQnscswDqJISvyeFBlxywzd/o07KDHkJ8yjaM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230427183603epcas5p25d6b17fa4ac118381bb3828481801278~Z3nzaWMB-1610016100epcas5p2P;
        Thu, 27 Apr 2023 18:36:03 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Q6kvk30Dwz4x9Pt; Thu, 27 Apr
        2023 18:36:02 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1F.D7.55646.290CA446; Fri, 28 Apr 2023 03:36:02 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230427142401epcas5p1613b998c03d8f635c6942d92c7ae7ee0~Z0LvriOBA0996309963epcas5p1t;
        Thu, 27 Apr 2023 14:24:01 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230427142401epsmtrp2af93f4823ef6a4027f01a56f19a86fb6~Z0Lvp7rbl0417204172epsmtrp2r;
        Thu, 27 Apr 2023 14:24:01 +0000 (GMT)
X-AuditID: b6c32a4b-913ff7000001d95e-84-644ac092acdb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        53.0C.27706.1858A446; Thu, 27 Apr 2023 23:24:01 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230427142400epsmtip29452faab6b8d6b18f8bf3e3e1eecc570~Z0LutKBMr1427414274epsmtip22;
        Thu, 27 Apr 2023 14:24:00 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk
Cc:     vincent.fu@samsung.com, fio@vger.kernel.org,
        ankit.kumar@samsung.com, anuj1072538@gmail.com,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH] t/io_uring: avoid null-ptr dereference incase setup_ring
 fails
Date:   Fri, 28 Apr 2023 01:14:15 +0530
Message-Id: <20230427194415.1160701-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmpu6kA14pBtcPC1qsufKb3eLj198s
        Fk0T/jJbrL7bz2bxcdYLZovH3R2MDmweO2fdZfe4fLbUo2/LKkaPz5vkAliism0yUhNTUosU
        UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgHYrKZQl5pQChQISi4uV
        9O1sivJLS1IVMvKLS2yVUgtScgpMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7IzThwSLPjMVrF/
        bV0D433WLkZODgkBE4lPZ1+ydzFycQgJ7GaUOLn8LwuE84lR4vG5m2wgVUIC3xglXu0Ugel4
        +28BM0TRXkaJmzdmQ7V3MklMWHWJBaSKTUBd4sjzVkYQW0RAWGJ/RyvYWGaBFkaJZT/3gY0V
        FgiUWNyxBqyIRUBV4v+pB2A2r4C1ROuuFSwQ6+QlZl76zg4RF5Q4OfMJWJwZKN68dTbYGRIC
        u9glDs58wQ7R4CLRvekhlC0s8er4FihbSuLzu71sEHa6xI/LT5kg7AKJ5mP7GCFse4nWU/1A
        QzmAFmhKrN+lDxGWlZh6ah0TxF4+id7fT6BaeSV2zIOxlSTaV86BsiUk9p5rgLI9JH5/vssC
        CcZYiQfnTrBNYJSfheSdWUjemYWweQEj8ypGydSC4tz01GLTAuO81HJ4vCbn525iBKdALe8d
        jI8efNA7xMjEwXiIUYKDWUmEl7fSPUWINyWxsiq1KD++qDQntfgQoykwjCcyS4km5wOTcF5J
        vKGJpYGJmZmZiaWxmaGSOK+67clkIYH0xJLU7NTUgtQimD4mDk6pBiYdj5nMAd5lcycJ7jzD
        ulHk83fXN5W/HO5M+t+rU/PZzSxX5FvhntnuvgpNf2Q1rnntlg57UuzQExCob81Y/IVhZt6U
        ALVlP/4IPdo84eu0KUcvu8/a80Dw+7KZ86Y+k3j+ZWqU3+EQy4+KfCK7pn/ifO3UbWPYbz5v
        cuzmHqGQ25s0y6+ZvbqiYWp6sdDy/Pup+74dc2p+ay+buqf/VWQZ14EAc/dGRbdNbdvSFs5u
        3+M313DaMvd9//seL7u+PODNgkT5CoOLHNcK5///zznRer7ucxHFo5uOnVUq6lGcxVmZ9JZT
        1Vkx6rFurJtl09br6eda+We90znCfFt7tiG35kcTi0sPUtJN/hRf23xUiaU4I9FQi7moOBEA
        kgjkXQoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsWy7bCSvG5jq1eKwdHfPBZrrvxmt/j49TeL
        RdOEv8wWq+/2s1l8nPWC2eJxdwejA5vHzll32T0uny316NuyitHj8ya5AJYoLpuU1JzMstQi
        fbsErowThwQLPrNV7F9b18B4n7WLkZNDQsBE4u2/BcxdjFwcQgK7GSXa2l6zQyQkJE69XMYI
        YQtLrPz3nB2iqJ1JYuOD32BFbALqEkeet4IViQAV7e9oZQEpYhboYpTY/fUv2AphAX+Jt01r
        mEFsFgFVif+nHoA18ApYS7TuWsECsUFeYual7+wQcUGJkzOfgMWZgeLNW2czT2Dkm4UkNQtJ
        agEj0ypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOBw1NLcwbh91Qe9Q4xMHIyHGCU4
        mJVEeHkr3VOEeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRq
        YNLRLFz06nLhjbkJvN8LJWy4/kjxWEyJC3/IfPSINYN15EOpLwYz1XmWBTQZayvFrzt0pfJR
        4NXp0/ZkK0V1epnnnknR9Oyf+fXI9cU9h97smG25+5Ox4OOt0nuthfeab4m4ciMjYSWT1qa1
        Z5bsu/qVZ2eD4dlF1zmezshwELl48e7RHjZtJ56EjiWTZlf5LHlTbt6VcDLj7uoeh6ha7e0L
        +UJ25vTt3y1ZclDokt5qA5mdL09tPLA5TSLO8Vp9WoO27sJWhpTJd57Z7zhmwqDUsGPFrikX
        Xuf7B+/+/HrpHTvBDVa/Vl43mSB/9/LVZyrTvn3bNf9Ockmd/e8Apd6CWUoXbeom8gUlCkrk
        fNNVYinOSDTUYi4qTgQA6kpHL7YCAAA=
X-CMS-MailID: 20230427142401epcas5p1613b998c03d8f635c6942d92c7ae7ee0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230427142401epcas5p1613b998c03d8f635c6942d92c7ae7ee0
References: <CGME20230427142401epcas5p1613b998c03d8f635c6942d92c7ae7ee0@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

s->sq_ring.ring_entries and s->cq_ring.ring_entries will be NULL,
incase setup_ring fails. This will cause a segmentation fault. Avoid
dereferencing them in such a scenario.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 t/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/t/io_uring.c b/t/io_uring.c
index 2f8d63fb..bf0aa26e 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -1059,7 +1059,8 @@ static int submitter_init(struct submitter *s)
 		err = 0;
 	} else if (!aio) {
 		err = setup_ring(s);
-		sprintf(buf, "Engine=io_uring, sq_ring=%d, cq_ring=%d\n", *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
+		if (!err)
+			sprintf(buf, "Engine=io_uring, sq_ring=%d, cq_ring=%d\n", *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
 	} else {
 		sprintf(buf, "Engine=aio\n");
 		err = setup_aio(s);
-- 
2.25.1

