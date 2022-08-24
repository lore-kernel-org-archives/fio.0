Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFB7C00140
	for <fio@archiver.kernel.org>; Wed, 24 Aug 2022 10:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236387AbiHXKRM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 24 Aug 2022 06:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236417AbiHXKRH (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 24 Aug 2022 06:17:07 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE917822F
        for <fio@vger.kernel.org>; Wed, 24 Aug 2022 03:17:05 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220824101701epoutp01bd60f1eafce525590f74bd8b28135fd8~OQH3RKE8Y2170521705epoutp01H
        for <fio@vger.kernel.org>; Wed, 24 Aug 2022 10:17:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220824101701epoutp01bd60f1eafce525590f74bd8b28135fd8~OQH3RKE8Y2170521705epoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661336221;
        bh=D9yKSXazjITEAodswW5RPLuiKgzHrXeRBuUClU50QGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pkqGIgmI3eV2du4yD3hXmr5JYnZ6E/8gQ3mN5FZX+h8HJ0bGoSMo5oCTK34u2YEf4
         a7znZj7dsOSvFaxNAZNgDlsH5kxRknnMo0FNa3cU3/PWkY+m3EaeOiseGq3W11NmLI
         ozA9jaY43oh8CbcfwyggvSTcZPlEg/kczxF06THE=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220824101701epcas5p4c21c0be37db5fc83faa9ee9b5db8ea90~OQH2sZRaC1520615206epcas5p4s;
        Wed, 24 Aug 2022 10:17:01 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MCMTR1jjYz4x9Pv; Wed, 24 Aug
        2022 10:16:59 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        30.35.18001.79AF5036; Wed, 24 Aug 2022 19:16:55 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220824094125epcas5p48b88f023cce31317adc68abc225df95c~OPox6lMS82762727627epcas5p4q;
        Wed, 24 Aug 2022 09:41:25 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220824094125epsmtrp261dfd6442d7a5978e52f47abc3f9c873~OPox58de_0183401834epsmtrp21;
        Wed, 24 Aug 2022 09:41:25 +0000 (GMT)
X-AuditID: b6c32a4a-2c3ff70000004651-d0-6305fa97d67b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        5F.C8.18644.542F5036; Wed, 24 Aug 2022 18:41:25 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220824094124epsmtip1cde9dea332d3a4022512f25e20845f74~OPowyHgOA2008920089epsmtip16;
        Wed, 24 Aug 2022 09:41:24 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     joshi.k@samsung.com, ankit.kumar@samsung.com, fio@vger.kernel.org,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH 1/2] t/io_uring: prep for including engines/nvme.h in
 t/io_uring
Date:   Wed, 24 Aug 2022 15:01:08 +0530
Message-Id: <20220824093109.308791-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220824093109.308791-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdlhTS3f6L9Zkg0f3rC3WXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8WGNkEHNo+ds+6ye1w+W+rRt2UVo8fnTXIBLFHZNhmpiSmpRQqp
        ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAq5UUyhJzSoFCAYnFxUr6
        djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWleel6eaklVoYGBkamQIUJ2RmLH/5kLpgrWHF0
        x2mmBsYfvF2MnBwSAiYS7YtfM3YxcnEICexmlPi7o5kZwvnEKLFr21Uo5zOjxIe2U2wwLZN+
        nmQGsYUEdjFK/PkgAlf0q3kxC0iCTUBd4sjzVqC5HBwiAhoSa+6mgoSZBbIkXv64wApiCwsE
        Sdw+uwSshEVAVeLLRw2QMK+AlcS1FxuYIVbJS8y89J0dxOYUsJa4vOIGO0SNoMTJmU9YIEbK
        SzRvnQ12p4TANXaJ/inrmSCaXST+nX/EDmELS7w6vgXKlpL4/G4v1C/pEj8uP4WqL5BoPraP
        EcK2l2g91c8MchuzgKbE+l36EGFZiamn1jFB7OWT6P39BKqVV2LHPBhbSaJ95RwoW0Ji77kG
        KNtD4vW3hdDw7GOUOPmniXUCo8IsJP/MQvLPLITVCxiZVzFKphYU56anFpsWGOWllsPjODk/
        dxMjODFqee1gfPjgg94hRiYOxkOMEhzMSiK8VsdYkoV4UxIrq1KL8uOLSnNSiw8xmgLDeyKz
        lGhyPjA155XEG5pYGpiYmZmZWBqbGSqJ807RZkwWEkhPLEnNTk0tSC2C6WPi4JRqYIrKyhTV
        WuQ5cUNeKfPdtM59jDWRew++0eBdtP23kvrExIrzDFcdb2j0lVoIfJ6qzpgzUXrr505TpoK8
        Kz+uRZpzrfRIv+Jwhfvm9ziru7/5jOqXG6zSklJ64h9k5yATa191Lj/cuO2Vybo93zrML7rU
        pz9RfvvSqWqC1+GbG+9tXu65NvGv6ILrG3K7LhVE7XOYzOYz87FOPOOkJfaCdb/W8RmV/Vsl
        uKtQ45alqnCGtpDRv76N5iY5T2y2OkulX+vdVSt6z+eTCA/PXu1nftWCKxb7L1SeHPJoll/r
        8bSS1dPCJva/KrE6HxCRM6P09YTZTOlvsn78W5uw5PZ1XlElkfVlcgK3jmqysqX6KbEUZyQa
        ajEXFScCAJAbc5YVBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsWy7bCSnK7rJ9ZkgymfZSzWXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8WGNkEHNo+ds+6ye1w+W+rRt2UVo8fnTXIBLFFcNimpOZllqUX6
        dglcGYsf/mQumCtYcXTHaaYGxh+8XYycHBICJhKTfp5k7mLk4hAS2MEo8XDeV3aIhITEqZfL
        GCFsYYmV/56zQxR9ZJR4c2c7K0iCTUBd4sjzVrAiEQEtiWPrmthAbGaBPImuu+dYQGxhgQCJ
        uxPXATVzcLAIqEp8+agBEuYVsJK49mIDM8R8eYmZl76D7eUUsJa4vOIGmC0EVHPszTEWiHpB
        iZMzn7BAjJeXaN46m3kCo8AsJKlZSFILGJlWMUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefn
        bmIEB6+W1g7GPas+6B1iZOJgPMQowcGsJMJrdYwlWYg3JbGyKrUoP76oNCe1+BCjNAeLkjjv
        ha6T8UIC6YklqdmpqQWpRTBZJg5OqQYmxldbv5lJx3RN2vbnfNaUzxnGk+02s/6dspyBUWSW
        uN21qbxlLWpfn7W0/dvyr/eT/M22heq+nhwbAr3SpzE52tm8bNBXW/9lkWM9r47CxbOl3m0z
        Dx5av7WHl701gOdEhWJc2L8EZT6tZXO21fAY5kgqBEuc2Hf420NvmxQdq3dXLy/06pSLvyiU
        8zdMuCdIKe2Ec5N69RG7fvl7zG/a8x8fPK0eu+a5wfL587S3L3M/ve/CR3YxRfYX1w6ZyyXK
        RTUKBOSwnovcfI8pdM3i8sDbMec/Pjpw4kZGantCeO4mi0uxGVXeHI1HZzPrGaxT/BNb237i
        Fv8mpTkv9+RkxOVVPfz0ymqXyo9lGbuVWIozEg21mIuKEwHpdBUhzQIAAA==
X-CMS-MailID: 20220824094125epcas5p48b88f023cce31317adc68abc225df95c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220824094125epcas5p48b88f023cce31317adc68abc225df95c
References: <20220824093109.308791-1-anuj20.g@samsung.com>
        <CGME20220824094125epcas5p48b88f023cce31317adc68abc225df95c@epcas5p4.samsung.com>
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

