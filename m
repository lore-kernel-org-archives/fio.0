Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F70EB64DD
	for <fio@archiver.kernel.org>; Tue, 11 Jul 2023 07:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbjGKHpg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 11 Jul 2023 03:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjGKHp3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Jul 2023 03:45:29 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABF210FD
        for <fio@vger.kernel.org>; Tue, 11 Jul 2023 00:45:16 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230711074514epoutp0122abcf1467fb47182d4dd245bd26eafe~wwH_JMbxG2178721787epoutp01h
        for <fio@vger.kernel.org>; Tue, 11 Jul 2023 07:45:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230711074514epoutp0122abcf1467fb47182d4dd245bd26eafe~wwH_JMbxG2178721787epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1689061514;
        bh=1wRG0IjLss/DUOplqzBDVw9TjdsEbDB82pNcHZCGIpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCn2n1xJJrlRTXQFRE26fIMWeFW7/WZieEtaPslpFb8yRgcVk0vWN4aLjrmXkbnQr
         AXvEWazXCx2lT/YMLrqrweKq4RmaAOJMum7jacLpbXwsUR2Y7jzGGDpuPy2prREYS2
         GjLTpAcUOX5/vtO4hiysDV1vlWIo0Vqpz+8A+F0A=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230711074513epcas5p1d80f9394916450566ba0f11b64c15ebb~wwH9qLpNE0799007990epcas5p11;
        Tue, 11 Jul 2023 07:45:13 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4R0Xw83pdqz4x9Px; Tue, 11 Jul
        2023 07:45:12 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F5.75.44250.8880DA46; Tue, 11 Jul 2023 16:45:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230711073512epcas5p4d10da8eefbc198953212cbfd5ca83198~wv-NXhtcK0134101341epcas5p4Z;
        Tue, 11 Jul 2023 07:35:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230711073512epsmtrp1fb371ad37d4df186f17404eb471bcb47~wv-NWwZFz0951509515epsmtrp1N;
        Tue, 11 Jul 2023 07:35:12 +0000 (GMT)
X-AuditID: b6c32a4a-c4fff7000000acda-d1-64ad088835d8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5D.15.34491.0360DA46; Tue, 11 Jul 2023 16:35:12 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230711073511epsmtip13b20c1077b975f0db31cc6cc346c374d~wv-MbwEuL2856428564epsmtip1T;
        Tue, 11 Jul 2023 07:35:10 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, simon.lund@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/3] fdp: use macro for max ruhs and fix placement id check
Date:   Tue, 11 Jul 2023 18:24:32 +0530
Message-Id: <20230711125434.14691-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230711125434.14691-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42LZdlhTU7eDY22KwcwPkhZrrvxmt1h9t5/N
        4uOsF8wWkw5dY7S42z2D3WJDm6ADm8fOWXfZPS6fLfXYtKqTzaNvyypGj8+b5AJYo7JtMlIT
        U1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4D2KymUJeaUAoUC
        EouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyMybducVW
        cESg4u60+ywNjP95uhg5OSQETCTW9c1l7GLk4hAS2M0o8W/zYyjnE6PEoVsNrBDON0aJBUfm
        MsG07Lh+kB0isZdR4seHm1AtnUwS3Q+usoNUsQloS7x6e4O5i5GDQ0RAQ2LN3VSQMLNAtsSi
        U8uYQWxhAW+JDy8gylkEVCW+ft/OCmLzCthILHo9AWqZvMTMS9/BajgFbCWWdS5jgqgRlDg5
        8wkLxEx5ieats5lBbpAQuMUuMW9/B1Szi0Tvtq8sELawxKvjW9ghbCmJl/1tUHa2xKaHP6Hq
        CySOvOhlhrDtJVpP9YPdzyygKbF+lz5EWFZi6ql1TBB7+SR6fz+BauWV2DEPxlaV+HvvNtRa
        aYmb766ygIyREPCQmPIsCSQsJDCBUWLFXpYJjAqzkHwzC8k3sxAWL2BkXsUomVpQnJueWmxa
        YJSXWg6P4+T83E2M4BSp5bWD8eGDD3qHGJk4GA8xSnAwK4nwFhxclSLEm5JYWZValB9fVJqT
        WnyI0RQY3BOZpUST84FJOq8k3tDE0sDEzMzMxNLYzFBJnPd169wUIYH0xJLU7NTUgtQimD4m
        Dk6pBqacnuTjNXH/pzYwzWE6H5aQOXXNyoal90q1rj+borxk1dt9zrUpnzMTTAxEDxkrWHNe
        OfHlVcYnuQmrlEvvl10Rn/I9/G5M56Qsn6nXlonm3FRs6WM6JW1pULKy0XeKsnmS5s+8qK8b
        5gjMSwsTNnSe79H2+KeOdZH2DuO/Sy8oxvTeNljvbqf8Qqj8vuMH+wSXCYovDMK33n91S/9T
        9FfO+hMzNy5w21Mg/lDJ42rZM0dL94ajLQaHPqi9nhfMJT8n5FydS3yr0/KyZe2aOpVz+HNW
        fVR5kpNp26NoLHRA5w6TU+qiL0mvP51etri374KR3MLGmRmmXD7bfLaoVxR6vDv7QfzjqZh0
        y/W2E5RYijMSDbWYi4oTAdbTg+gaBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsWy7bCSnK4B29oUgzM7mC3WXPnNbrH6bj+b
        xcdZL5gtJh26xmhxt3sGu8WGNkEHNo+ds+6ye1w+W+qxaVUnm0ffllWMHp83yQWwRnHZpKTm
        ZJalFunbJXBlTLpzi63giEDF3Wn3WRoY//N0MXJySAiYSOy4fpC9i5GLQ0hgN6PErGs/gRwO
        oIS0xML1iRA1whIr/z2Hqmlnkjj39R4zSIJNQFvi1dsbYLaIgJbEsXVNbCC9zAL5Etfv5YKE
        hQW8JT68uMoOYrMIqEp8/b6dFcTmFbCRWPR6AhPEfHmJmZe+g9VwCthKLOtcBhYXAqpZePY9
        I0S9oMTJmU9YQGxmoPrmrbOZJzAKzEKSmoUktYCRaRWjZGpBcW56brFhgWFearlecWJucWle
        ul5yfu4mRnAQa2nuYNy+6oPeIUYmDsZDjBIczEoivAUHV6UI8aYkVlalFuXHF5XmpBYfYpTm
        YFES5xV/0ZsiJJCeWJKanZpakFoEk2Xi4JRqYFpx8dtC76qED3K/z+/2LRCdXBL32My8JaRD
        c8Yc258bexN3SdsyM657xn9+Om/FFN0r59msjJ8vSKmV52lTb1zYdyf38uWPR+xOed22fsDi
        UTpJOOLoGY24EJb5Ul6JK4r1tBqOtghdrNsiE7TPQiNRSFbXsExZvUQy2uS0+OqbTNvubz79
        3Fdi06xCp11C4TfWe34o9QtzWvjshnLWbz0n1lt7rPg7GL2+MUVcFF83X0dmu/jpm6zas3V3
        CT9R+5cfeulv3IZXJ6saltTO7ZFqcjMqEZ3re9bft8FTcd7hC7a9GunsE2a+DGR5EbcluHdx
        stq97++VnP5t2/Myhl2h2Sg6zGyj+g5mkfXxSizFGYmGWsxFxYkAIT3dztECAAA=
X-CMS-MailID: 20230711073512epcas5p4d10da8eefbc198953212cbfd5ca83198
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230711073512epcas5p4d10da8eefbc198953212cbfd5ca83198
References: <20230711125434.14691-1-ankit.kumar@samsung.com>
        <CGME20230711073512epcas5p4d10da8eefbc198953212cbfd5ca83198@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Use macro for max ruhs.
Number of reclaim unit handle descriptors are 1 based, whereas the
input placement id index / indices are 0 based. Add the correct check
for that.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c | 2 +-
 fdp.c              | 8 ++++----
 fdp.h              | 2 ++
 3 files changed, 7 insertions(+), 5 deletions(-)

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
index d92dbc67..72afca01 100644
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
@@ -65,7 +65,7 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 	}
 
 	for (i = 0; i < td->o.fdp_nrpli; i++) {
-		if (td->o.fdp_plis[i] > ruhs->nr_ruhs) {
+		if (td->o.fdp_plis[i] >= ruhs->nr_ruhs) {
 			ret = -EINVAL;
 			goto out;
 		}
diff --git a/fdp.h b/fdp.h
index 81691f62..4a5e0e54 100644
--- a/fdp.h
+++ b/fdp.h
@@ -3,6 +3,8 @@
 
 #include "io_u.h"
 
+#define FDP_MAX_RUHS	128
+
 struct fio_ruhs_info {
 	uint32_t nr_ruhs;
 	uint32_t pli_loc;
-- 
2.25.1

