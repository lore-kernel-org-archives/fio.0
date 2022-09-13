Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 288F1C6FA82
	for <fio@archiver.kernel.org>; Tue, 13 Sep 2022 11:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiIMLJl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 13 Sep 2022 07:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiIMLJj (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Sep 2022 07:09:39 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66C21030
        for <fio@vger.kernel.org>; Tue, 13 Sep 2022 04:09:33 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220913110927epoutp032f40255c12dfcd1945ac2b11e8f904a5~UZvWssHIB2030320303epoutp03a
        for <fio@vger.kernel.org>; Tue, 13 Sep 2022 11:09:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220913110927epoutp032f40255c12dfcd1945ac2b11e8f904a5~UZvWssHIB2030320303epoutp03a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663067367;
        bh=k1zpEq3bwvrFKn/KGi/GgYodg3btSzHV5eOunocAmfk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=BOxttjbKHOBm8UziXSDXbgOGNrHYIzrpOezviZ/F6sq07rys8yqckmiBOTbqIk2Uo
         bGkAOLmsdZ+xzZaNI+7ad7HOpAuvpp8gBDJkT5x6DxoC5eleKk/Kanaryz9Q6w4/PB
         FMSpdAzf7PzkXUxFtTXsqi/ywb24XdeHzmWBs4fI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220913110927epcas5p31d62e1cf23f8b44e716eec361e22d7e5~UZvWfPdt_1191611916epcas5p3M;
        Tue, 13 Sep 2022 11:09:27 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MRghj61NQz4x9Px; Tue, 13 Sep
        2022 11:09:25 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0F.46.59633.5E460236; Tue, 13 Sep 2022 20:09:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220913105531epcas5p3576d018441951d5555544a2d5ddefab7~UZjLjsyHs2770327703epcas5p3t;
        Tue, 13 Sep 2022 10:55:31 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220913105531epsmtrp2f4bc27e35955318d0b8e240cd4dc46ff~UZjLix1oh1384413844epsmtrp2k;
        Tue, 13 Sep 2022 10:55:31 +0000 (GMT)
X-AuditID: b6c32a49-06ffe7000000e8f1-9f-632064e59d49
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        66.7F.14392.3A160236; Tue, 13 Sep 2022 19:55:31 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220913105530epsmtip26de9582bbb13ea282cfa121036bd3551~UZjK0sKps0284002840epsmtip2b;
        Tue, 13 Sep 2022 10:55:30 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/1] number_ios and io_size behave differently for trimwrite
Date:   Tue, 13 Sep 2022 16:15:26 +0530
Message-Id: <20220913104527.18734-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsWy7bCmhu7TFIVkg8MrDC3WXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjO+N7fx15wiLni/OpXrA2Md5i6GDk5
        JARMJM6cWMzWxcjFISSwm1Hi+OlWRgjnE6NE2/3ZUM43RonvU3cCORxgLesemEHE9zJK/Pq8
        ngnCaWWSmL34ByPIXDYBbYlXb28wg9giAsIS+ztaWUBsZoFQiZPXvrCD2MICPhJTv58Hq2ER
        UJWY//kV2E28AjYS63oWs0DcJy+xesMBZpAFEgL97BJ/fl6EOtxF4u6iPnYIW1ji1fEtULaU
        xOd3e9kg7GyJTQ9/QtUXSBx50csMYdtLtJ7qZwb5hllAU2L9Ln2IsKzE1FPrmCDu5JPo/f0E
        qpVXYsc8GFtV4u+921C3SUvcfHcVyvaQeHqrA2ytkECsxIEHM9knMMrOQtiwgJFxFaNkakFx
        bnpqsWmBYV5qOTyikvNzNzGC05GW5w7Guw8+6B1iZOJgPMQowcGsJMLbF6KQLMSbklhZlVqU
        H19UmpNafIjRFBhmE5mlRJPzgQkxryTe0MTSwMTMzMzE0tjMUEmcd4o2Y7KQQHpiSWp2ampB
        ahFMHxMHp1QDU/GHoyc4lQ72e7dvX3L78s593cwxy6p+K+qp5O866eqcqLrgi65bZdK2yz/v
        zrvQu8hggdOOOxN2167ILcjgaPj9le/+zOIEfU+tO/cWZ622vOLm91Vr3SbfuSYP638xPiwN
        ObPiYuGeV/fLlsuLu4rv2HilUJgtZUe/+tYdbh9qvqneTDZlr/CXmR2ZuMVFROnJDsPy67oq
        Uz4cshL6P1G5X59vTfesbZeEJyoJdX3ylBbiM+xlUKsPNleZtUjf+HDIHum6TQdPpQWv+L6e
        kUmX/b/S4USxHYHX10fvdTWVTPWV517kfNW2bYeE0PftHb5u0qWsp79eTGt88ZQx4YVFi4JZ
        hZD2hubZMmu/KrEUZyQaajEXFScCAHPS/BPQAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsWy7bCSvO7iRIVkg7cbmC3WXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mr43t/HXnCI
        ueL86lesDYx3mLoYOTgkBEwk1j0w62Lk4hAS2M0osWbJWVaIuLTEwvWJXYycQKawxMp/z9kh
        apqZJBrn32UGSbAJaEu8ensDzBYBKtrf0coCYjMLhEtMPzCZEcQWFvCRmPr9PFgNi4CqxPzP
        r5hAbF4BG4l1PYtZIBbIS6zecIB5AiPPAkaGVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5
        uZsYwWGhpbmDcfuqD3qHGJk4GA8xSnAwK4nw9oUoJAvxpiRWVqUW5ccXleakFh9ilOZgURLn
        vdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXAdG3uyUOqPGqzvf44bl728s6UXrf1Tyuerbjw+6+O
        HsOObovXt2Y2dR979qf4lsOt0ldedtZ+DOKrfzqVfby94VfE9cN+/oIXW0LaL395remldari
        Wq14/pT/15pdeMvKwq92TP6ydNtNLt4Ooy/nxB+t2KG4euF/Hen69nsP3peJ9DFNf8fXqhoy
        z28hR1Xy/NONxsJv9FV28RUGlRS4am4Juc5rps4vXhzxd9LjjN73U3vdZxwSvLuf+VzMnJ0i
        3xr471l271qe1VR1b+bGu7mXXxTxX4yre8y/ciX7n2yhyLiXD+xnljYLybWulq9azJJf/ld6
        5gSpWLbsV2v+XVh2YP39Q4cO3M0P1/+b4KrEUpyRaKjFXFScCABSYJ+VegIAAA==
X-CMS-MailID: 20220913105531epcas5p3576d018441951d5555544a2d5ddefab7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220913105531epcas5p3576d018441951d5555544a2d5ddefab7
References: <CGME20220913105531epcas5p3576d018441951d5555544a2d5ddefab7@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add changes for number_ios such that we actually do trim and then writes
for those number of I/O's. This will make the behaviour similar to
io_size.
Update the documentation to clarify the exact behaviour for trimwrite
workloads.

Ankit Kumar (1):
  backend: number of ios not as expected for trimwrite

 HOWTO.rst | 6 +++++-
 backend.c | 6 ++++--
 fio.1     | 5 ++++-
 3 files changed, 13 insertions(+), 4 deletions(-)

-- 
2.17.1

