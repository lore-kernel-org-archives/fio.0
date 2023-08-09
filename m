Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC02DC001B0
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 06:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjHIGD1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 02:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjHIGD1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 02:03:27 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B721FC3
        for <fio@vger.kernel.org>; Tue,  8 Aug 2023 23:03:15 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230809060314epoutp04eb66611dfc40599d2b45e8ee028fe795~5ocMaCu521953719537epoutp04l
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 06:03:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230809060314epoutp04eb66611dfc40599d2b45e8ee028fe795~5ocMaCu521953719537epoutp04l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691560994;
        bh=gd0NtE7hbKwLjuvYMftLl6JJcoDBsxXYTxrjLY771yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpH5Zc3o1J13NcOKfyZ9DMDNuvB92eu2QloL3GYwk9aHfHqHevkdziX/j9h4Sc644
         /06+lP+u/y52NMgxyfasmbp0Qft/gJuYQLQJY/w4BYbS9jz1foKDXqlofw3+l1blVr
         LlhVqOaqourRR9x/6eGRTaMIzlmrR5I/wSE/pULc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230809060313epcas5p3c5e55e18127f794a5a0edcd636777b31~5ocMBl6qe0774107741epcas5p3i;
        Wed,  9 Aug 2023 06:03:13 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4RLKH44rKxz4x9Q7; Wed,  9 Aug
        2023 06:03:12 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        36.D1.55522.02C23D46; Wed,  9 Aug 2023 15:03:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230809055424epcas5p4e01b9ca024f64b1a637002ae65c8903f~5oUexqm2W1660116601epcas5p4E;
        Wed,  9 Aug 2023 05:54:24 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230809055424epsmtrp1f01a1f698a09a73d033e830f18e6e873~5oUexC1iA3170131701epsmtrp1t;
        Wed,  9 Aug 2023 05:54:24 +0000 (GMT)
X-AuditID: b6c32a49-419ff7000000d8e2-15-64d32c20472a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9B.D0.14748.01A23D46; Wed,  9 Aug 2023 14:54:24 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230809055423epsmtip1a066494cfae022cfc5913beb9303618a~5oUdrZNLi0564305643epsmtip1Z;
        Wed,  9 Aug 2023 05:54:23 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 09/10] engines:nvme: pull required 48 bit accessors from
 linux kernel
Date:   Wed,  9 Aug 2023 16:43:13 +0530
Message-Id: <20230809111314.76947-10-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230809111314.76947-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIJsWRmVeSWpSXmKPExsWy7bCmlq6CzuUUg4VzVCzWXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gC5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgY
        mQIVJmRnLPn0nLmglbviz7zVTA2Mbzm6GDk5JARMJI7efcjexcjFISSwm1Hi660vLBDOJ0aJ
        CVNXQmW+MUqcfvicEaal7+B7MFtIYC9QYrMFRFEnk8TrvlOsIAk2AW2JV29vMHcxcnCICGhI
        rLmbClLDLNDCKLG7ezZYjbBAuETjz0MsIDaLgKrEoY87wGxeAVuJ94/mQC2Tl5h56Ts7iM0J
        FF+15gZUjaDEyZlPwGxmoJrmrbOZIeq/skv8uJkHsldCwEVi41MbiLCwxKvjW9ghbCmJl/1t
        UHa2xKaHP5kg7AKJIy96ocbYS7Se6gc7n1lAU2L9Ln2IsKzE1FPrmCC28kn0/n4C1corsWMe
        jK0q8ffebRYIW1ri5rurULaHROO5d9DAncAose3ybOYJjAqzkHwzC8k3sxBWL2BkXsUomVpQ
        nJueWmxaYJiXWg6P4+T83E2M4LSp5bmD8e6DD3qHGJk4GA8xSnAwK4nw2gZfShHiTUmsrEot
        yo8vKs1JLT7EaAoM7onMUqLJ+cDEnVcSb2hiaWBiZmZmYmlsZqgkzvu6dW6KkEB6Yklqdmpq
        QWoRTB8TB6dUA5P/0xv+Ajlna6M0d6h+nRjHHne2PXR36fGdm1s/ZB7hnvPutvqNpO7Fk3Kb
        cieVsxmGXU9W8NqxYD1LCpPKhmNZR7kY2xmL3U06jPZGNn15ZcIc0D7rwum0PZ8ul7gLejD+
        iNL6d2uqwY3G2rU8UT+/d0vIexT/1FdaWLQwSObyr5vJ2XdddnseOjBJWJHDYerk9lw1o0t7
        D1u28D126du646mqVdaLXy97U13k3O6cYGZeI/BQo/tEj/ZSFuHD20++lxYo+vRCxu+H9un1
        t48fs5i4u1u7T+bs8ZDYXgfnsm7h1h0sB1oaPeVrXdeeY7a+rej++1uUmH8b37YVlwuCzli0
        7JV9fdDoz0KhCCWW4oxEQy3mouJEAO+Q2PUkBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWy7bCSnK6A1uUUg/tT+C3WXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiiuGxSUnMyy1KL9O0SuDKWfHrOXNDKXfFn3mqmBsa3HF2MnBwSAiYSfQffM3YxcnEI
        CexmlDjRcpq1i5EDKCEtsXB9IkSNsMTKf8/ZIWramSSWtnUzgSTYBLQlXr29wQxiiwhoSRxb
        18QGUsQs0MUosXf3NDaQQcICoRLXl/iB1LAIqEoc+riDBcTmFbCVeP9oDiPEAnmJmZe+s4PY
        nEDxVWtugNUICdhILHw7kRmiXlDi5MwnYHFmoPrmrbOZJzAKzEKSmoUktYCRaRWjZGpBcW56
        brJhgWFearlecWJucWleul5yfu4mRnBoa2nsYLw3/5/eIUYmDsZDjBIczEoivLbBl1KEeFMS
        K6tSi/Lji0pzUosPMUpzsCiJ8xrOmJ0iJJCeWJKanZpakFoEk2Xi4JRqYHpX2baG5c1EL/N7
        CavUWqsT+q84X6m2+Hvrb6Ov2//41UbNsd4siw5vrQ1arSm4LV3i0+JLVnIqWXm3fHQZ+PRi
        OaTins0+69hl1yDH/zTp6rIEzqsrMl4tudkwZ4LRc7U1T5doi5kuNZq99BtbIieDmU5l2fL2
        Cad+LmH+L+Xh8Xnmtopjr7laltar7Ls2Kzb+k4F7foXrlouztyz5vit9zuJkjjMvtJj/ffae
        aORUrW5iePVW7OvfHH5f5Y0908p3L/fg+bk3xudfqkrWQhmP8Ct7NrAu/cOxRKyM4euH3ZvT
        /b/4MG/bIa6j/TS+KzW5M3/x1S2Xl/+6uXrxllUSPg2W96pl/jUyP3st+EqJpTgj0VCLuag4
        EQCCj5Zn3AIAAA==
X-CMS-MailID: 20230809055424epcas5p4e01b9ca024f64b1a637002ae65c8903f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230809055424epcas5p4e01b9ca024f64b1a637002ae65c8903f
References: <20230809111314.76947-1-ankit.kumar@samsung.com>
        <CGME20230809055424epcas5p4e01b9ca024f64b1a637002ae65c8903f@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Pull the 48 bit helpers, required for supporting 48 bit reference tags.
Add GPL 2.0 license to nvme.c and nvme.h files.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/nvme.c |  1 +
 engines/nvme.h | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/engines/nvme.c b/engines/nvme.c
index e89faee5..724950be 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * nvme structure declarations and helper functions for the
  * io_uring_cmd engine.
diff --git a/engines/nvme.h b/engines/nvme.h
index a1102dfe..fb1f7760 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * nvme structure declarations and helper functions for the
  * io_uring_cmd engine.
@@ -440,4 +441,20 @@ int fio_nvme_reset_wp(struct thread_data *td, struct fio_file *f,
 int fio_nvme_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 				unsigned int *max_open_zones);
 
+static inline void put_unaligned_be48(__u64 val, __u8 *p)
+{
+	*p++ = val >> 40;
+	*p++ = val >> 32;
+	*p++ = val >> 24;
+	*p++ = val >> 16;
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline __u64 get_unaligned_be48(__u8 *p)
+{
+	return (__u64)p[0] << 40 | (__u64)p[1] << 32 | (__u64)p[2] << 24 |
+		p[3] << 16 | p[4] << 8 | p[5];
+}
+
 #endif
-- 
2.25.1

