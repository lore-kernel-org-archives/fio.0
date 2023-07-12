Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2C7EB64DD
	for <fio@archiver.kernel.org>; Thu, 13 Jul 2023 08:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbjGMIpn (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 13 Jul 2023 04:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbjGMIpX (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Jul 2023 04:45:23 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A1518E
        for <fio@vger.kernel.org>; Thu, 13 Jul 2023 01:45:07 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230713084505epoutp03649678e32a5c81b4d43bcaf956029f11~xYOzvJubV1367813678epoutp03C
        for <fio@vger.kernel.org>; Thu, 13 Jul 2023 08:45:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230713084505epoutp03649678e32a5c81b4d43bcaf956029f11~xYOzvJubV1367813678epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1689237906;
        bh=mz4FthJIRwhOE8ezrvWMFIeqv6hqEu5BG9d4uIDsFkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2NDkuTWFh+sZF1p8ixtO4V0W4B+VMCVgNQOvDs6zgcm4QZAGyfQhtZeC9JiG6fSa
         lsjw9EiwgX/vWRW6aVhnwe+iOmDm5AQZntwjDAIevJ+cPr/GXSSV1xwsuH09PcmWHK
         A7hbkGHJytJQkqMZ4ye7719xMgsW2dFhLiUa9ggM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230713084505epcas5p3a0d94f10e49b83fbe07c54c7a8de03bb~xYOzfkUj-1004410044epcas5p3_;
        Thu, 13 Jul 2023 08:45:05 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4R1p8H6RJzz4x9QC; Thu, 13 Jul
        2023 08:45:03 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F3.73.55522.D89BFA46; Thu, 13 Jul 2023 17:45:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230712050112epcas5p1561eaab98f637a0c899158dfc7a87241~xBiC32PwH0750707507epcas5p1P;
        Wed, 12 Jul 2023 05:01:12 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230712050112epsmtrp16c58df6e7b4c7480e71a21a7ca43d48f~xBiC3ODxR0214902149epsmtrp1T;
        Wed, 12 Jul 2023 05:01:12 +0000 (GMT)
X-AuditID: b6c32a49-419ff7000000d8e2-da-64afb98d0f74
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        82.E3.30535.8933EA46; Wed, 12 Jul 2023 14:01:12 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230712050111epsmtip1cc1be579141497f1f93f2da01d6d129f~xBiB9mNgi2840928409epsmtip1B;
        Wed, 12 Jul 2023 05:01:11 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, simon.lund@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 2/4] fdp: fix placement id check
Date:   Wed, 12 Jul 2023 15:50:39 +0530
Message-Id: <20230712102041.20283-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712102041.20283-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdlhTXbd35/oUg52HhC3WXPnNbrH6bj+b
        xcdZL5gtJh26xmhxt3sGu8WGNkEHNo+ds+6ye1w+W+qxaVUnm0ffllWMHp83yQWwRmXbZKQm
        pqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDtV1IoS8wpBQoF
        JBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ0yY9Yml
        YAdrRfv3l0wNjHNZuhg5OSQETCQaby4Hsrk4hAR2M0q8P/SeDcL5xCjRdX8ZVOYbo8TqlxuY
        YVp63h9ihEjsZZRYt2YPlNPJJNG6qJkVpIpNQFvi1dsbQB0cHCICGhJr7qaChJkFsiUWnVoG
        NkhYwFhi7qsVjCA2i4CqxNGtT9hAbF4BG4lP234xQiyTl5h56Ts7yBhOAVuJz4+sIEoEJU7O
        fMICMVJeonnrbGaQEyQE7rFLNP39wgTR6yKxaeEeKFtY4tXxLewQtpTEy/42KDtbYtPDn1A1
        BRJHXvRCPWkv0XqqH+x8ZgFNifW79CHCshJTT61jgtjLJ9H7+wlUK6/EjnkwtqrE33u3ocEr
        LXHz3VUo20Ni0ZuV0ACdwChx5dgklgmMCrOQ/DMLyT+zEFYvYGRexSiZWlCcm55abFpgmJda
        Do/k5PzcTYzgJKnluYPx7oMPeocYmTgYDzFKcDArifCqbFuXIsSbklhZlVqUH19UmpNafIjR
        FBjeE5mlRJPzgWk6ryTe0MTSwMTMzMzE0tjMUEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkG
        JhfTlMuF5iGvRSZdrNj4IGX3kWS7qzYSVd9j9eYVNVzfv5P1xx21y2klAoHFazM2nJ806dW3
        zYXKWz8ffm0307Q6vS14pWHvlzrnv4c7w7qdE/da/pRTXxW5eNHFWJGJ1yTV9mvKnHu4n+fO
        ni1V++3PpIblJ0Qu020R7d8byvhqh/1iSbnwfTcNTP6EV5jc8NTWff+v87sJY6wWr+LCxLxz
        v/Y23Mux+dXEkKR4Jev8QvZYBT8L2e1eW5iWnpi/Z57QpG0TmTJ3qxUwFgcsXhYxv2/91Iq9
        YVcM1TQlQiJmeiiy5H7q073V1/znzuktvt0fDy67eU9dgqHfctqGfP0Q83O/VnLWLfmR/Kdj
        lRJLcUaioRZzUXEiAKjFa5wbBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsWy7bCSnO4M43UpBrOmGVisufKb3WL13X42
        i4+zXjBbTDp0jdHibvcMdosNbYIObB47Z91l97h8ttRj06pONo++LasYPT5vkgtgjeKySUnN
        ySxLLdK3S+DKmDDrE0vBDtaK9u8vmRoY57J0MXJySAiYSPS8P8QIYgsJ7GaU6GhW62LkAIpL
        SyxcnwhRIiyx8t9z9i5GLqCSdiaJdzOawOrZBLQlXr29wQxiiwhoSRxb18QG0ssskC9x/V4u
        SFhYwFhi7qsVYOUsAqoSR7c+YQOxeQVsJD5t+8UIMV9eYual7+wgrZwCthKfH1lBXGMj8fPA
        TnaIckGJkzOfgF3MDFTevHU28wRGgVlIUrOQpBYwMq1ilEwtKM5Nzy02LDDKSy3XK07MLS7N
        S9dLzs/dxAgOYC2tHYx7Vn3QO8TIxMF4iFGCg1lJhLfg4KoUId6UxMqq1KL8+KLSnNTiQ4zS
        HCxK4rzfXvemCAmkJ5akZqemFqQWwWSZODilGpjs/sflmzyLaKoICCiMs3N5LnbKm6t646rG
        a0FP/rtHPHouLVtwhoPzZ4CQwPOP//euTEzYtmGz5aHzE5btvjm7hc9QborznKi53aZnft2/
        cPvOyYV6J68wGdzi2qZsfJd1tvLKwkn9M6Z7Cs4y3myWKjZ/M0f8dNNrv4++iXJck3SD1/2G
        7HSf6wsXvVi0qJrZYeYx4/lKy5i80xrvJQa+tv5l+u3MXM/56bP4ktYm8+z/sCtSJ6Mk+Vnt
        +VM30zc2990szMqvW7w+UPWWe+BxwU8V6U5PPYJeKQSec3zC/VZd4+XpeKkP3Xm3BRLfbFkQ
        d9b4XUTdvLVlMccPsNkvubuhYMde18sXdp289VXqkhJLcUaioRZzUXEiALqFt87PAgAA
X-CMS-MailID: 20230712050112epcas5p1561eaab98f637a0c899158dfc7a87241
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230712050112epcas5p1561eaab98f637a0c899158dfc7a87241
References: <20230712102041.20283-1-ankit.kumar@samsung.com>
        <CGME20230712050112epcas5p1561eaab98f637a0c899158dfc7a87241@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Number of reclaim unit handle descriptors are 1 based, whereas the
input placement id index / indices are 0 based. Add the correct check
for that.

Fixes: a7e8aae0 ("fio: add fdp support ..")

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 fdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fdp.c b/fdp.c
index b83fd660..6e124ce6 100644
--- a/fdp.c
+++ b/fdp.c
@@ -65,7 +65,7 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 	}
 
 	for (i = 0; i < td->o.fdp_nrpli; i++) {
-		if (td->o.fdp_plis[i] > ruhs->nr_ruhs) {
+		if (td->o.fdp_plis[i] >= ruhs->nr_ruhs) {
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.25.1

