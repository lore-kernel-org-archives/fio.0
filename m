Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D5EECAAA1
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 12:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbiJ0MDc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 08:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235495AbiJ0MDb (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 08:03:31 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8A1814E7
        for <fio@vger.kernel.org>; Thu, 27 Oct 2022 05:03:29 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221027120328epoutp02fb4c5a3d7d95bac6c5eb15a50cf72650~h63EdRA851747617476epoutp027
        for <fio@vger.kernel.org>; Thu, 27 Oct 2022 12:03:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221027120328epoutp02fb4c5a3d7d95bac6c5eb15a50cf72650~h63EdRA851747617476epoutp027
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666872208;
        bh=YlAlYD4hh8Xz423WNPRYA3ifvJOhc+8NUJE4df/9Hag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p1fhqVaf6xnWI8lWRn09CJhAxAYMhgDRCt3ESXvPR1GwmJVip533dDUdXXQhoGb5O
         De+pODXPqcuF4jzify6ovM43o0YFqp61jBvhI4eITcMpxYxU6+D6q31mBp9LF5dOGP
         z3+wSzAakTE0F/9R/2gruTnCBVzNVGKNsfGtB6Cc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221027120327epcas5p12b8ebc075c79c3758508e2a973fdcd19~h63EF1KRT2204722047epcas5p1L;
        Thu, 27 Oct 2022 12:03:27 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Mykpk065dz4x9Pr; Thu, 27 Oct
        2022 12:03:26 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DC.A2.56352.D837A536; Thu, 27 Oct 2022 21:03:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20221021114405epcas5p3aa29c8e403dbe5584a53a12821661966~gEucfLp2z1496114961epcas5p3w;
        Fri, 21 Oct 2022 11:44:05 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221021114405epsmtrp17f225e95d72f8a1794260bc0537bc5bb~gEuceW_si3172931729epsmtrp1u;
        Fri, 21 Oct 2022 11:44:05 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-11-635a738de21d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1C.9A.14392.50682536; Fri, 21 Oct 2022 20:44:05 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221021114404epsmtip1ef59b629b0ac778e013c9c93d8963c62~gEubTaAyt0315503155epsmtip1I;
        Fri, 21 Oct 2022 11:44:04 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/2] parse: set min and max limit for FIO_OPT_STR_SET
Date:   Fri, 21 Oct 2022 17:02:35 +0530
Message-Id: <20221021113236.32340-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221021113236.32340-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsWy7bCmpm5vcVSywbZNlhZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYppOYl56dk5qXbKnkH
        xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
        l9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnzJyzhLHgC2vFryXPWBoYr7N0MXJy
        SAiYSDxYcAzI5uIQEtjNKHHhcxsjhPOJUaJj/0s2COcbo8Tfp7NYYVqePlzEDpHYyyixcuUE
        VginlUniyeGfYFVsAtoSr97eYAaxRQSEJfZ3tIItZBYIlTh57Qs7iC0s4Crx/OIpoH0cHCwC
        qhI/1leAhHkFbCQufzjOCLFMXmL1hgNgYzgFbCU2dk1kBtklIbCKXWLDq3Y2iCIXiTPN55kg
        bGGJV8e3sEPYUhIv+9ug7GyJTQ9/QtUUSBx50csMYdtLtJ7qZwa5gVlAU2L9Ln2IsKzE1FPr
        mCBO5pPo/f0EqpVXYsc8GFtV4u+929BwlJa4+e4qlO0h8en2S2ZImExglDhxfQPjBEa5WQgr
        FjAyrmKUTC0ozk1PLTYtMM5LLYfHWnJ+7iZGcKLS8t7B+OjBB71DjEwcjIcYJTiYlUR4z94I
        TxbiTUmsrEotyo8vKs1JLT7EaAoMv4nMUqLJ+cBUmVcSb2hiaWBiZmZmYmlsZqgkzrt4hlay
        kEB6YklqdmpqQWoRTB8TB6dUA5OoX4H02S2xrQmRukKeSpqCp+Z38FYKPPKr9Q2Ie82ZsvgB
        q8GhOWFTFt5+/9uvovax9ZcpF3QX6axk+zBR88Hd1A0pjEt3xh7yN/D4Z53ZfmN5bh1z74yO
        hP3Xnqzb2eHT4/R+72GDkg/Wfsr/4tNf6vSedD+mURxRqG/f5K6nuuXQnB8hV7S+L8v9rLv+
        343iD18uNb/wOTL5xyO1N89/CaTIfdm1dJumpc+p7z0VF2flKq6NKKxf80jzeL0DX+2j6a+X
        C+Zb3T+wt+ugmN6920uS2D/94ulrOZ2ln698cP/fHZE8NyZPX5Kt83F35CGmjbKCbvNWdv48
        Hr3+zIpf88RfHD3Pf3phuviVU2eVlFiKMxINtZiLihMBLaGCWt0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsWy7bCSnC5rW1CyQfsHM4s1V36zW6y+289m
        8XHWC2aLDW2CDiweO2fdZfe4fLbUo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDJmzlnCWPCF
        teLXkmcsDYzXWboYOTkkBEwknj5cxN7FyMUhJLCbUeLmh1WMXYwcQAlpiYXrEyFqhCVW/nsO
        VdPMJNG7/BErSIJNQFvi1dsbzCC2CFDR/o5WsKHMAuES0w9MZgSxhQVcJZ5fPAU2k0VAVeLH
        +gqQMK+AjcTlD8cZIebLS6zecABsDKeArcTGrolgthBQzf3LZxknMPItYGRYxSiZWlCcm55b
        bFhgmJdarlecmFtcmpeul5yfu4kRHEZamjsYt6/6oHeIkYmD8RCjBAezkgivRV1QshBvSmJl
        VWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTBycUg1MaY2PHqQflduxYe30
        H482sTs8sV04VzVD/UKjsPTHNRfU/5i9+/LH/zJrQf+2FvFFL++ZLS9J2hv/rrX81/OOHiuu
        Tb5NNRMsXmxMqRbYurD6ZlY5y6qzYV6+osuPzN95Vt5W0+/51oRw7WWRVwr3aTzeoBf1vm65
        tuja62Jzl8bvjNrf9rcv8eYTGY3Z2ZOvTRO88mO6xE7G4wu0ns1cZvP1Gm+l/bYZptk6btYL
        jov8rN7I/T33f9BaadWvytnMIcdPaC5qFv8f+/nhHoVpilPnL+J6f+Cj1qaZe3oXyy3rXzxd
        p0iVs+iWlPQnt3+T/QpnPdqpydK0ZJ/tqxvzv07pfc818f72hVNSHH7fuF6lxFKckWioxVxU
        nAgArfHC3JICAAA=
X-CMS-MailID: 20221021114405epcas5p3aa29c8e403dbe5584a53a12821661966
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021114405epcas5p3aa29c8e403dbe5584a53a12821661966
References: <20221021113236.32340-1-ankit.kumar@samsung.com>
        <CGME20221021114405epcas5p3aa29c8e403dbe5584a53a12821661966@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

type FIO_OPT_STR_SET suggests the passed value should be
empty or boolean value ([0|1]).
But the given type accepts any integer value as there is
no limit for min and max values. Add a limit to that.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/parse.c b/parse.c
index 656a5025..6bad0d94 100644
--- a/parse.c
+++ b/parse.c
@@ -1434,7 +1434,7 @@ static void option_init(struct fio_option *o)
 		return;
 	if (o->name && !o->lname)
 		log_err("Option %s: missing long option name\n", o->name);
-	if (o->type == FIO_OPT_BOOL) {
+	if (o->type == FIO_OPT_BOOL || o->type == FIO_OPT_STR_SET) {
 		o->minval = 0;
 		o->maxval = 1;
 	}
-- 
2.17.1

