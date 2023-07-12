Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C5EC0015E
	for <fio@archiver.kernel.org>; Thu, 13 Jul 2023 08:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbjGMIpm (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 13 Jul 2023 04:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbjGMIpU (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Jul 2023 04:45:20 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F28B2D46
        for <fio@vger.kernel.org>; Thu, 13 Jul 2023 01:44:58 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230713084456epoutp02b4ba5dbf0c242399f23f5b8e579a9921~xYOqtG_TK2436124361epoutp02C
        for <fio@vger.kernel.org>; Thu, 13 Jul 2023 08:44:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230713084456epoutp02b4ba5dbf0c242399f23f5b8e579a9921~xYOqtG_TK2436124361epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1689237896;
        bh=PLjsko1Q13FPd6zpn1PFpDMJKnekgRsKYt5PihoPV7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+m/oqHjBbV51fBrMp2at2cWcGVJzV/JnBl3uUe1pP9jiamEeT3GrtJ5mXfpsn0FE
         pU/fLTNIktrsn1UcnqAUIryTPpYNJ+oX18diL2Sy27zQoEYq/vOSQR35juVFg8f9LN
         ZL/Vn9mkVk7UegiM+ieQSM0AXHb0qecOcqX2qMNA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230713084456epcas5p32a363eacf51b086f4b1bf13f19cf9687~xYOqcVy4y1605316053epcas5p32;
        Thu, 13 Jul 2023 08:44:56 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4R1p861KCmz4x9Pp; Thu, 13 Jul
        2023 08:44:54 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3D.63.55522.389BFA46; Thu, 13 Jul 2023 17:44:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230712050111epcas5p3c755e75f3b6ed71604dd423f20c44985~xBiB6pKs91953519535epcas5p3_;
        Wed, 12 Jul 2023 05:01:11 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230712050111epsmtrp23fdd0bc462130ee6516a5f5d4488c996~xBiB5sQ4B1198511985epsmtrp2k;
        Wed, 12 Jul 2023 05:01:11 +0000 (GMT)
X-AuditID: b6c32a49-419ff7000000d8e2-c0-64afb9830fed
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
        DC.C8.64355.7933EA46; Wed, 12 Jul 2023 14:01:11 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230712050110epsmtip194321769b0f86c8a2e21a7b39e66ec3f~xBiA6Xhl92840928409epsmtip1A;
        Wed, 12 Jul 2023 05:01:10 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, simon.lund@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 1/4] fdp: use macros
Date:   Wed, 12 Jul 2023 15:50:38 +0530
Message-Id: <20230712102041.20283-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712102041.20283-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdlhTXbd55/oUg8k7WS3WXPnNbrH6bj+b
        xcdZL5gtJh26xmhxt3sGu8WGNkEHNo+ds+6ye1w+W+qxaVUnm0ffllWMHp83yQWwRmXbZKQm
        pqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDtV1IoS8wpBQoF
        JBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ7x8do+1
        YCd/xdNvc5gbGOfzdDFyckgImEh823SXqYuRi0NIYDejRNu7FVDOJ0aJcz0H2OCcbf/es8K0
        LJ74jBkisZNRYvnKPqiqTiaJtrnXWUCq2AS0JV69vQFUxcEhIqAhseZuKkiYWSBbYtGpZcwg
        trCAusTDV4/BhrIIqEpM370KzOYVsJG4uvMiO8QyeYmZl76zg4zhFLCV+PzICqJEUOLkzCcs
        ECPlJZq3zga7R0LgFrvE/1Uz2CB6XSQWrF/BAmELS7w6vgVqppTE53d7oWqyJTY9/MkEYRdI
        HHnRywxh20u0nuoHO59ZQFNi/S59iLCsxNRT65gg9vJJ9P5+AtXKK7FjHoytKvH33m2otdIS
        N99dhbI9JPbdXsoICaoJjBJTFvYzTWBUmIXkn1lI/pmFsHoBI/MqRsnUguLc9NRi0wLDvNRy
        eCQn5+duYgQnSS3PHYx3H3zQO8TIxMF4iFGCg1lJhFdl27oUId6UxMqq1KL8+KLSnNTiQ4ym
        wPCeyCwlmpwPTNN5JfGGJpYGJmZmZiaWxmaGSuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUw
        zZifyNYX4n/gK/sJN5Mpb+12Zn+8GjzRecnBVI+HTV7Z7Tx2sz5flCpZnbqQ98Dsed5i+yuv
        NZ67fqqwk+Hs2YYtF5lO720OSli92tT5V+qVbMYT1rd4FZ9e+hTQJB1a+uW24uKpJsWLWmVP
        HlTJnfLvntWaAyHXZ139UHi3NfLzgh33Hk44t2/tZ48ZZklitfLSgrm2KmnH+PZypwsmX6k1
        m1x8qfr07p8S9ow6gVdVC12ut/KnaM384XfXw8CkKkU7/HKghI/L6qSj81OSo00PnPh/+tC1
        ghe3bsxcVSBhXM3gt1B7bcLDv6evPPTNmX15AfvC+7Fhu24Hnio5Kjb5lXDdi6luHp187G/u
        miixFGckGmoxFxUnAgBEngZdGwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsWy7bCSnO5043UpBu92aVisufKb3WL13X42
        i4+zXjBbTDp0jdHibvcMdosNbYIObB47Z91l97h8ttRj06pONo++LasYPT5vkgtgjeKySUnN
        ySxLLdK3S+DKePnsHmvBTv6Kp9/mMDcwzufpYuTkkBAwkVg88RlzFyMXh5DAdkaJFX/esnQx
        cgAlpCUWrk+EqBGWWPnvOTtETTuTxJ4Da9lBEmwC2hKv3t5gBrFFBLQkjq1rYgPpZRbIl7h+
        LxckLCygLvHw1WNWEJtFQFVi+u5VYDavgI3E1Z0X2SHmy0vMvPSdHaSVU8BW4vMjK5CwEFDJ
        zwM72SHKBSVOznzCAmIzA5U3b53NPIFRYBaS1CwkqQWMTKsYRVMLinPTc5MLDPWKE3OLS/PS
        9ZLzczcxgkNXK2gH47L1f/UOMTJxMB5ilOBgVhLhLTi4KkWINyWxsiq1KD++qDQntfgQozQH
        i5I4r3JOZ4qQQHpiSWp2ampBahFMlomDU6qBaVrWRynuCey/FvruUhRQEcs3S/sif9Tr8r2s
        v/vrC9ZeFDP7wXjh8vr0fa7stqk3eW6f1LnI79h+ZnPW/3UHCs52hRcnXPBazP97QbvD9n+s
        pzmS+Gu4fynGss5wcDA5N2GKiZTL9vJGwfrKE/9O5sfsunXoVkZzuL/SdJujrpO37tgRuimI
        QUbP7cWUnLhaLracnqqgiUFT7Dd1KRmfuqvV8MO2+P6T5LzVLQn25w/M8e9qUS4LXt6ZveKD
        W6ZF0o2gPZd1iiY6lU17I/Smu326jmXiDrvXAreWF/6tv2P+qHDm6S/bP8xaz7OiQeeTSHH7
        s++S9Tvuv106JbMl95za1XsbX65meuh3g22atxJLcUaioRZzUXEiAFIu46bMAgAA
X-CMS-MailID: 20230712050111epcas5p3c755e75f3b6ed71604dd423f20c44985
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230712050111epcas5p3c755e75f3b6ed71604dd423f20c44985
References: <20230712102041.20283-1-ankit.kumar@samsung.com>
        <CGME20230712050111epcas5p3c755e75f3b6ed71604dd423f20c44985@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

use macros for directive type and max ruhs.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c | 2 +-
 fdp.c              | 8 ++++----
 fdp.h              | 3 +++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 5021239e..407d65ce 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1310,7 +1310,7 @@ static int fio_ioring_cmd_fetch_ruhs(struct thread_data *td, struct fio_file *f,
 	struct nvme_fdp_ruh_status *ruhs;
 	int bytes, ret, i;
 
-	bytes = sizeof(*ruhs) + 128 * sizeof(struct nvme_fdp_ruh_status_desc);
+	bytes = sizeof(*ruhs) + FDP_MAX_RUHS * sizeof(struct nvme_fdp_ruh_status_desc);
 	ruhs = scalloc(1, bytes);
 	if (!ruhs)
 		return -ENOMEM;
diff --git a/fdp.c b/fdp.c
index d92dbc67..b83fd660 100644
--- a/fdp.c
+++ b/fdp.c
@@ -45,7 +45,7 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 	struct fio_ruhs_info *ruhs, *tmp;
 	int i, ret;
 
-	ruhs = scalloc(1, sizeof(*ruhs) + 128 * sizeof(*ruhs->plis));
+	ruhs = scalloc(1, sizeof(*ruhs) + FDP_MAX_RUHS * sizeof(*ruhs->plis));
 	if (!ruhs)
 		return -ENOMEM;
 
@@ -56,8 +56,8 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 		goto out;
 	}
 
-	if (ruhs->nr_ruhs > 128)
-		ruhs->nr_ruhs = 128;
+	if (ruhs->nr_ruhs > FDP_MAX_RUHS)
+		ruhs->nr_ruhs = FDP_MAX_RUHS;
 
 	if (td->o.fdp_nrpli == 0) {
 		f->ruhs_info = ruhs;
@@ -123,6 +123,6 @@ void fdp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
 		ruhs->pli_loc = 0;
 
 	dspec = ruhs->plis[ruhs->pli_loc++];
-	io_u->dtype = 2;
+	io_u->dtype = FDP_DIR_DTYPE;
 	io_u->dspec = dspec;
 }
diff --git a/fdp.h b/fdp.h
index 81691f62..6ecbfcbe 100644
--- a/fdp.h
+++ b/fdp.h
@@ -3,6 +3,9 @@
 
 #include "io_u.h"
 
+#define FDP_DIR_DTYPE	2
+#define FDP_MAX_RUHS	128
+
 struct fio_ruhs_info {
 	uint32_t nr_ruhs;
 	uint32_t pli_loc;
-- 
2.25.1

