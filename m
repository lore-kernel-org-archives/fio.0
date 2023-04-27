Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E79C77B73
	for <fio@archiver.kernel.org>; Thu, 27 Apr 2023 09:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243339AbjD0JuW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Apr 2023 05:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243269AbjD0JuV (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Apr 2023 05:50:21 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E0A92
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 02:50:19 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230427095017epoutp0246b13e87351ce4ab9f13ef7bb030d899~ZwcwMWgIz0691706917epoutp02s
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 09:50:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230427095017epoutp0246b13e87351ce4ab9f13ef7bb030d899~ZwcwMWgIz0691706917epoutp02s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682589017;
        bh=MmRCbhW5lI+P4nHUFosWHgFAR6iiijK3ucNB0a9w6+I=;
        h=From:To:Cc:Subject:Date:References:From;
        b=MnfFQyuWA9G+zQ6dL+6BxfMI8sbKwnVeC2TAy2cBSYRb9vODicU23Py446fHs66eA
         ZXPSpZpXiSSdubVUTLC4vFeSHjeCx8aj7q2Ogev9kW/hWQmPcjOLsJ7ztaZFOR3mao
         zYQOcRHmKFY4xomGTSHkvoFhjtqn7dECgBLSp15k=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230427095017epcas5p254e6faf430a39356ba3487a53f4236f9~Zwcv1foa00182001820epcas5p2h;
        Thu, 27 Apr 2023 09:50:17 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Q6WF40QLnz4x9Pr; Thu, 27 Apr
        2023 09:50:16 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A6.BB.55646.7554A446; Thu, 27 Apr 2023 18:50:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230427094952epcas5p32967ed548e18e60ea3134a03aa046bb8~ZwcYe7X0w0123101231epcas5p3W;
        Thu, 27 Apr 2023 09:49:52 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230427094952epsmtrp1d6e592dc4c810ec85662904554890d92~ZwcYeNqYe2373623736epsmtrp1N;
        Thu, 27 Apr 2023 09:49:52 +0000 (GMT)
X-AuditID: b6c32a4b-b71fa7000001d95e-d4-644a4557fcb7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2F.1D.28392.0454A446; Thu, 27 Apr 2023 18:49:52 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230427094951epsmtip26029ec84cc92f7fcb44702ff09af7ef6~ZwcXfvo6-1492714927epsmtip2K;
        Thu, 27 Apr 2023 09:49:51 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk
Cc:     vincent.fu@samsung.com, fio@vger.kernel.org,
        ankit.kumar@samsung.com, anuj1072538@gmail.com,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH] t/io_uring: fix error handling for setup_ring
Date:   Thu, 27 Apr 2023 20:40:04 +0530
Message-Id: <20230427151004.1146679-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmhm64q1eKwc67qhZrrvxmt/j49TeL
        RdOEv8wWq+/2s1l8nPWC2eJxdwejA5vHzll32T0uny316NuyitHj8ya5AJaobJuM1MSU1CKF
        1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoN1KCmWJOaVAoYDE4mIl
        fTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMqQs72Av2cFa8
        vfaFqYHxCnsXIyeHhICJxILjt1m7GLk4hAR2M0rs2zkPyvnEKLHg7w9mCOczo0Tni2+sMC1v
        J31ggUjsYpT40/wUyulkkngweS5YFZuAusSR562MILaIgLDE/o5WsCJmgRZGiWU/97GBJIQF
        7CQuNnaBNbAIqEr8PvAYLM4rYC0x7e8DqAvlJWZe+s4OEReUODnzCQuIzQwUb946G+w+CYFd
        7BKfn58CSnAAOS4SKy/bQvQKS7w6vgVqjpTEy/42KDtd4sflp0wQdoFE87F9jBC2vUTrqX5m
        kDHMApoS63fpQ4RlJaaeWscEsZZPovf3E6hWXokd82BsJYn2lXOgbAmJvecaoGwPiQc72phB
        bCGBWImL3/rZJjDKz0LyzSwk38xC2LyAkXkVo2RqQXFuemqxaYFxXmo5PGaT83M3MYLToJb3
        DsZHDz7oHWJk4mA8xCjBwawkwstb6Z4ixJuSWFmVWpQfX1Sak1p8iNEUGMQTmaVEk/OBiTiv
        JN7QxNLAxMzMzMTS2MxQSZxX3fZkspBAemJJanZqakFqEUwfEwenVAPT0utmeiyWO9SWf9h1
        6/eu5fpRV2/oZhzY/THKrWDLoVXydvKGrOdTRaMeH+6vFbgirxVb+OfXxM6cdcw1LWqHHhle
        vxS1v7Y67Pr3jC3rdh24d9o4Rior9NvncN6iiP9iv8/m6Un4rLq5cemhqN/vmhLLlHc+yfJL
        t97mcsP+rs6a/L6OLJatTpnVy8R3funMjXfS8mP85pLquL4s+EVB7Ic1PlH8RcaVr7c2WN/2
        2iR5KIBHb4pOf6/8ybmZn38dZpo+79TJX/tCgv9cu/1AfpVCV2PYuuQ/pdfmCT+sFvp2+D2f
        s7tddFxRQNC6v4fubjKXW7DL2HOlMFOSePW7T82HgpVjlqUrqx3x1FmqxFKckWioxVxUnAgA
        SGvdawwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsWy7bCSvK6Dq1eKwfKPEhZrrvxmt/j49TeL
        RdOEv8wWq+/2s1l8nPWC2eJxdwejA5vHzll32T0uny316NuyitHj8ya5AJYoLpuU1JzMstQi
        fbsEroypCzvYC/ZwVry99oWpgfEKexcjJ4eEgInE20kfWLoYuTiEBHYwSnR09EIlJCROvVzG
        CGELS6z895wdoqidSWLL+WtsIAk2AXWJI89bwYpEgIr2d7SCTWIW6GKU2P31LytIQljATuJi
        YxeYzSKgKvH7wGOwZl4Ba4lpfx9AbZOXmHnpOztEXFDi5MwnLCA2M1C8eets5gmMfLOQpGYh
        SS1gZFrFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcklpaOxj3rPqgd4iRiYPxEKME
        B7OSCC9vpXuKEG9KYmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTSE0tSs1NTC1KLYLJMHJxS
        DUwKb/tsF+roqyh8bmU+NMHwhO1UEfnemPdMblFzcv4nyp1P5zz1f/1an3SZJbvvmnmWrk39
        elq61TYnWtgg6/Gh0hP9c5Mzd7744T8t8O7hhccmqEw2vi49/e3LylJ7rj7laVFaEx1ybrxX
        f1jUmbf8RuZUbrHb27p2P4x+/4Ft2v6tYaetFt96HCTzL1jvyUHDVwtYpi6/81I5me3HTH6B
        SGfGFA7V0yaN0+xNV3W5NiyTWtl3r/r9IquMjPs7ErxXXo5VqOAOl3HOqjhWsmj69BvOhRMj
        tKfIBYqKXJtmEpaW5VZUI9139vWvwxOXHLpzycZFuMAgYI3P43d382ay6/zO+37R4/NPsxmK
        ubuVWIozEg21mIuKEwF2QRaPuAIAAA==
X-CMS-MailID: 20230427094952epcas5p32967ed548e18e60ea3134a03aa046bb8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230427094952epcas5p32967ed548e18e60ea3134a03aa046bb8
References: <CGME20230427094952epcas5p32967ed548e18e60ea3134a03aa046bb8@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

s->sq_ring.ring_entries and s->cq_ring.ring_entries will be NULL,
incase setup_ring fails. This will cause a segmentation fault.

In case setup_ring fails, bail out by setting finish.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 t/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/t/io_uring.c b/t/io_uring.c
index 6b0efef8..e00f278d 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -1059,12 +1059,14 @@ static int submitter_init(struct submitter *s)
 		err = 0;
 	} else if (!aio) {
 		err = setup_ring(s);
-		sprintf(buf, "Engine=io_uring, sq_ring=%d, cq_ring=%d\n", *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
+		if (!err)
+			sprintf(buf, "Engine=io_uring, sq_ring=%d, cq_ring=%d\n", *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
 	} else {
 		sprintf(buf, "Engine=aio\n");
 		err = setup_aio(s);
 	}
 	if (err) {
+		finish = 1;
 		printf("queue setup failed: %s, %d\n", strerror(errno), err);
 		return 1;
 	}
@@ -1282,6 +1284,9 @@ static void *submitter_uring_fn(void *data)
 	submitter_init(s);
 #endif
 
+	if (finish)
+		return NULL;
+
 	if (register_ring)
 		io_uring_register_ring(s);
 
-- 
2.25.1

