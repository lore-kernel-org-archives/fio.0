Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6650ECAAD5
	for <fio@archiver.kernel.org>; Fri, 26 Aug 2022 11:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245597AbiHZLo4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 26 Aug 2022 07:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243750AbiHZLoz (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Aug 2022 07:44:55 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCE63ED54
        for <fio@vger.kernel.org>; Fri, 26 Aug 2022 04:44:54 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220826114449epoutp01800f59a8d7ff288409cfc29048e5092f~O4nFvA1bt0150801508epoutp01b
        for <fio@vger.kernel.org>; Fri, 26 Aug 2022 11:44:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220826114449epoutp01800f59a8d7ff288409cfc29048e5092f~O4nFvA1bt0150801508epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661514289;
        bh=D9yKSXazjITEAodswW5RPLuiKgzHrXeRBuUClU50QGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyMaWyaoUcQffPIfJAZd5vptmI9iyaSi6YoDlpQAVLFsQ8ZpMFWj/BOmUk8zTIEk1
         a1cSzSHSKsyaDgSbJQaSMcb3iDc4nc+9ZdY/Jf58WpfLqAiVqML3qoDX0HBIpuaqhU
         98R03wH6PqN5W3YpCdfgwHQZ8ezLzvWo43Gy/6Mc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220826114449epcas5p37cd4673d9e02c530b7945972e29a662d~O4nFenapr1119811198epcas5p3X;
        Fri, 26 Aug 2022 11:44:49 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MDdKp5S0Yz4x9Q1; Fri, 26 Aug
        2022 11:44:46 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6F.D8.54060.622B8036; Fri, 26 Aug 2022 20:44:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220826114309epcas5p36e313a77d0dc872fc15319b203e05d56~O4lo6NniA2547825478epcas5p3W;
        Fri, 26 Aug 2022 11:43:09 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220826114309epsmtrp1b6876e51d8907bd1904504629c9ad221~O4lo5bZ4N2758727587epsmtrp1N;
        Fri, 26 Aug 2022 11:43:09 +0000 (GMT)
X-AuditID: b6c32a4b-be1ff7000000d32c-45-6308b226be18
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2E.88.18644.DC1B8036; Fri, 26 Aug 2022 20:43:09 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220826114308epsmtip2d8920da1b0d19e3b73bf644c48b3f71b~O4ln4p0VF0128201282epsmtip2l;
        Fri, 26 Aug 2022 11:43:08 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     joshi.k@samsung.com, ankit.kumar@samsung.com, fio@vger.kernel.org,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 1/2] t/io_uring: prep for including engines/nvme.h in
 t/io_uring
Date:   Fri, 26 Aug 2022 17:03:05 +0530
Message-Id: <20220826113306.4139-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220826113306.4139-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdlhTXVd9E0eyQfd3Ros1V36zWzRN+Mts
        sfpuP5vFx1kvmC2O/n/LZrGhTdCBzWPnrLvsHpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJq
        XnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QaiWFssScUqBQQGJxsZK+
        nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsbihz+ZC+YKVhzd
        cZqpgfEHbxcjJ4eEgInExJ0bWbsYuTiEBHYzStx/2M8C4XxilPj3eQsThPOZUWLbk2YWmJYZ
        H99AVe1ilHh2eD0bXNWjdwuZQKrYBNQljjxvZexi5OAQEdCQWHM3FSTMLJAl8fLHBVYQW1gg
        VGL3yh4WkBIWAVWJl7MtQMK8AhYSs+Y9YYLYJS8x89J3dhCbU8BS4srxLywQNYISJ2c+YYEY
        KS/RvHU2M8gJEgLX2CU+nTnNCtHsIrHl8j12CFtY4tXxLVC2lMTL/jYoO13ix+WnUMsKJJqP
        7WOEsO0lWk/1M4PcxiygKbF+lz5EWFZi6ql1TBB7+SR6f8PcySuxA+5mJYn2lXOgbAmJveca
        oGwPiVt3ToOtFRLoYZT4+F9qAqPCLCTvzELyziyEzQsYmVcxSqYWFOempxabFhjnpZbD4zg5
        P3cTIzgxannvYHz04IPeIUYmDsZDjBIczEoivFbHWJKFeFMSK6tSi/Lji0pzUosPMZoCg3si
        s5Rocj4wNeeVxBuaWBqYmJmZmVgamxkqifNO0WZMFhJITyxJzU5NLUgtgulj4uCUamCazsda
        I7Pp4Qpv6ev+X/z/zHrydqag/C7W2rXuOrt+hXP3sWrLX9uwTW7xOiXPs3Pfpnc9XtH2Imlt
        9bT/vi9awzXn76ldkZxkKLfuuMASjvp7XzVvb/9neWOp/3GbZME3R6QEnv6/tPdaxnEl7Skn
        G9I+2zz1sDi3zSj69nIDnXebJp69n/BK/3S20y0mG4FXSR8iOHUdXj8zDXbiO8vmKuB3ICrw
        pLpU1SSL2NPbUrVuXMtfOquK30ap94dqBd8NrRt5elveVfXISq0utdGT9Ck5eNFOpP/qoyfq
        k4vEAozib8Rurt+lafDc+rV7e9OHn0kLJfYd5xN9p/J735n3l4+EGa6IvnCu4N23toniSizF
        GYmGWsxFxYkAlw+kGRUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsWy7bCSvO7ZjRzJBtN+KlmsufKb3aJpwl9m
        i9V3+9ksPs56wWxx9P9bNosNbYIObB47Z91l97h8ttSjb8sqRo/Pm+QCWKK4bFJSczLLUov0
        7RK4MhY//MlcMFew4uiO00wNjD94uxg5OSQETCRmfHzD0sXIxSEksINRovfLbXaIhITEqZfL
        GCFsYYmV/56DxYUEPjJKXDzHBWKzCahLHHneClYjIqAlcWxdExuIzSyQJ9F19xwLiC0sECyx
        4MQTIJuDg0VAVeLlbAuQMK+AhcSseU+YIMbLS8y89B1sPKeApcSV419YIFZZSJxc/YkJol5Q
        4uTMJywQ4+UlmrfOZp7AKDALSWoWktQCRqZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5
        mxjBoaultYNxz6oPeocYmTgYDzFKcDArifBaHWNJFuJNSaysSi3Kjy8qzUktPsQozcGiJM57
        oetkvJBAemJJanZqakFqEUyWiYNTqoFpm6lGaszj15V/7pzXfKuhYuWq6Cyjy7hpxf7H4VfX
        7623Zjv1eLJNGLNAhfnDiexf45fyPQ9Ks2aJbbmo2OrZav6X8XHAfWfrR38je88vC55iezDn
        yN22kFTNRrYtbzWOz2592rJqvYegeLSNpczusKBbX2QybYQqj60tvZF04WLipf4LYQ5TinwD
        rvWdS/KPemS8+8ENFu4crhUbO7y7uv85zv73gGHW2yT17J1T+Nm47p9acSHj9MVEdXcT5vDo
        eYF6Mgxd7zsTZjqL/mX6w2XKo/qwlk9tQV5Sn5qZ4QXBvTPdD61Zlz8rsqHv/aa3Ea/1P8Yv
        vVCy6cw638+vVok8NplusjCe4//8+QFKLMUZiYZazEXFiQDI2I0azAIAAA==
X-CMS-MailID: 20220826114309epcas5p36e313a77d0dc872fc15319b203e05d56
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220826114309epcas5p36e313a77d0dc872fc15319b203e05d56
References: <20220826113306.4139-1-anuj20.g@samsung.com>
        <CGME20220826114309epcas5p36e313a77d0dc872fc15319b203e05d56@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Change page_size and cal_clat_percentiles name to something different
as these are indirectly picked from engines/nvme.h (fio.h and stat.h)

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 t/io_uring.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/t/io_uring.c b/t/io_uring.c
index 35bf1956..a42abd46 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -117,7 +117,7 @@ static struct submitter *submitter;
 static volatile int finish;
 static int stats_running;
 static unsigned long max_iops;
-static long page_size;
+static long t_io_uring_page_size;
 
 static int depth = DEPTH;
 static int batch_submit = BATCH_SUBMIT;
@@ -195,9 +195,9 @@ static unsigned long plat_idx_to_val(unsigned int idx)
 	return cycles_to_nsec(base + ((k + 0.5) * (1 << error_bits)));
 }
 
-unsigned int calc_clat_percentiles(unsigned long *io_u_plat, unsigned long nr,
-				   unsigned long **output,
-				   unsigned long *maxv, unsigned long *minv)
+unsigned int calculate_clat_percentiles(unsigned long *io_u_plat,
+		unsigned long nr, unsigned long **output,
+		unsigned long *maxv, unsigned long *minv)
 {
 	unsigned long sum = 0;
 	unsigned int len = plist_len, i, j = 0;
@@ -251,7 +251,7 @@ static void show_clat_percentiles(unsigned long *io_u_plat, unsigned long nr,
 	bool is_last;
 	char fmt[32];
 
-	len = calc_clat_percentiles(io_u_plat, nr, &ovals, &maxv, &minv);
+	len = calculate_clat_percentiles(io_u_plat, nr, &ovals, &maxv, &minv);
 	if (!len || !ovals)
 		goto out;
 
@@ -786,7 +786,7 @@ static void *allocate_mem(struct submitter *s, int size)
 		return numa_alloc_onnode(size, s->numa_node);
 #endif
 
-	if (posix_memalign(&buf, page_size, bs)) {
+	if (posix_memalign(&buf, t_io_uring_page_size, bs)) {
 		printf("failed alloc\n");
 		return NULL;
 	}
@@ -1543,9 +1543,9 @@ int main(int argc, char *argv[])
 
 	arm_sig_int();
 
-	page_size = sysconf(_SC_PAGESIZE);
-	if (page_size < 0)
-		page_size = 4096;
+	t_io_uring_page_size = sysconf(_SC_PAGESIZE);
+	if (t_io_uring_page_size < 0)
+		t_io_uring_page_size = 4096;
 
 	for (j = 0; j < nthreads; j++) {
 		s = get_submitter(j);
-- 
2.25.1

