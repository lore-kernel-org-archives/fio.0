Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65136C61DA4
	for <fio@archiver.kernel.org>; Fri,  3 Feb 2023 12:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbjBCMfl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Feb 2023 07:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbjBCMf1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2023 07:35:27 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA18F773
        for <fio@vger.kernel.org>; Fri,  3 Feb 2023 04:35:23 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230203123517epoutp02bb21f50f87dd6cdffad7ad1abfc347cb~AUKH3O-Nb0686806868epoutp02F
        for <fio@vger.kernel.org>; Fri,  3 Feb 2023 12:35:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230203123517epoutp02bb21f50f87dd6cdffad7ad1abfc347cb~AUKH3O-Nb0686806868epoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1675427717;
        bh=MvqJCtAo66UbXRYaBrqkm7tW3d1kw4mGPsZsRCGT5BA=;
        h=From:To:Cc:Subject:Date:References:From;
        b=PfmpDrZTVxQLnQ5sV9WmMyVkmecJFYU33yCMqDCUMzz100+IeBUo9UT/A09h32Rus
         lM9DwiQqZMxymjiBj6TRM1hQobEl+vHyb8Bu3jny5MzFXZiDVp8l+K7/x3Wspb0Bie
         s0+J1R/c2zx9aDt3oYkfBEOB2CwhqU3e+//uKg9U=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230203123517epcas5p2b3489d987f8ec8260fd4e6f161249458~AUKHo3Mnx0320203202epcas5p2r;
        Fri,  3 Feb 2023 12:35:17 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4P7Zqm0VBHz4x9Pr; Fri,  3 Feb
        2023 12:35:16 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        63.F8.06765.28FFCD36; Fri,  3 Feb 2023 21:35:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230203123513epcas5p4cb1961d7d1376bf39690f82de639d6f4~AUKECfBNY0743407434epcas5p4N;
        Fri,  3 Feb 2023 12:35:13 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230203123513epsmtrp129d0c954dff3b13b422bb13c93cd8a0d~AUKEBmCd11871318713epsmtrp1m;
        Fri,  3 Feb 2023 12:35:13 +0000 (GMT)
X-AuditID: b6c32a4b-20fff70000011a6d-1c-63dcff82100d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F0.70.05839.18FFCD36; Fri,  3 Feb 2023 21:35:13 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230203123513epsmtip23496646c282547d83e2fda0c5c3a5fa5~AUKDWskbp1185611856epsmtip2Z;
        Fri,  3 Feb 2023 12:35:12 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     fio@vger.kernel.org, axboe@kernel.dk, vincent.fu@samsung.com
Cc:     Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH] filesetup: do not ask O_RDWR for read-only workload
Date:   Fri,  3 Feb 2023 18:04:21 +0530
Message-Id: <20230203123421.126720-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsWy7bCmhm7T/zvJBiemW1isvtvPZvFx1gtm
        i6P/37JZPO7uYHRg8bh8ttSjb8sqRo/Pm+QCmKOybTJSE1NSixRS85LzUzLz0m2VvIPjneNN
        zQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAlikplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVS
        C1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjP6D/QzF/zlqFhw+ghLA+Nq9i5GTg4JAROJ
        D13L2LoYuTiEBHYzSiyb+ooZwvnEKLGj+xoThPONUWLL+QOsXYwcYC1zd4RDxPcySszevIUV
        wvnMKDFv5S4mkCI2AU2JC5NLQVaICDhITHm5hg3EZhZQl3h3ZiWYLSzgIrHw5EVGEJtFQFVi
        z643LCA2r4ClxJujf1khzpOXmHnpOztEXFDi5MwnLBBz5CWat84Gu1RCYBm7xNdVp5khGlwk
        1vW/Z4OwhSVeHd8C9aeUxMv+Nig7WeLSzHNMEHaJxOM9B6Fse4nWU/3MIPczA92/fpc+xC4+
        id7fT5ggfueV6GgTgqhWlLg36SnUmeISD2csgbI9JM6/nwpmCwnESnzffZ95AqPcLCQfzELy
        wSyEZQsYmVcxSqYWFOempxabFhjnpZbDozI5P3cTIziVaXnvYHz04IPeIUYmDsZDjBIczEoi
        vMtP30kW4k1JrKxKLcqPLyrNSS0+xGgKDNaJzFKiyfnAZJpXEm9oYmlgYmZmZmJpbGaoJM6r
        bnsyWUggPbEkNTs1tSC1CKaPiYNTqoHJf9b0Rw8klikfTD3+wODx1q5GDSkZ1zXzTl498Ccp
        MMb7a9DEkw8ez5hxQLyiaIZKadc5llcP2RpdVndPXj/t1Wz1Mx/llytrnG1osD21eaGanef0
        szfzW3TeT2/1XPx19y6TNSc6y7eKmznmFggy5V88sXLSLrH5p6Y/jG3duiZgx4+S70m9m2X2
        Z1Spn0zM2/206Nxb60q5Dzr/XjeszhSZG1eleHHJi6XLF6+Xevj8+tRJlf11+0RvByxnLH7o
        YeMncMfnE8Phucock2dtn+V0VJXN6435wbrbPIf4E6axqi+4wuXCtfKEV83xRb65Hlp888Sm
        i13q5fkRvz5I69L8MEfOdlch0RMnpugsKlNiKc5INNRiLipOBADj/QVq7gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsWy7bCSvG7j/zvJBts2GlisvtvPZvFx1gtm
        i6P/37JZPO7uYHRg8bh8ttSjb8sqRo/Pm+QCmKO4bFJSczLLUov07RK4MvoP9DMX/OWoWHD6
        CEsD42r2LkYODgkBE4m5O8K7GLk4hAR2M0q8X9nD1MXICRQXl2i+9oMdwhaWWPnvOZgtJPCR
        UeLwY0mQXjYBTYkLk0tBwiICLhL3Lz1mAbGZBdQl3p1ZyQZiCwPFF568yAhiswioSuzZ9Qas
        hlfAUuLN0b+sEOPlJWZe+s4OEReUODnzCdQceYnmrbOZJzDyzUKSmoUktYCRaRWjZGpBcW56
        brFhgWFearlecWJucWleul5yfu4mRnCwaWnuYNy+6oPeIUYmDsZDjBIczEoivMtP30kW4k1J
        rKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJg1OqgeniXia2aCujwi9F
        4ofUn7EebnOYrHPjQWb+74yXQhOyptQc/fbVu0xQ9WbWI6/zPUlFL14su3nJxrV5r+XVTyUG
        bELc1tr+TkeKdQK2lfPm57XHx+xpy3uwbPKPLXN+38jNk/O4GeCz0jK1VWWKvUKJ7O/ZTpvf
        SyZsX3zv+NN7rEGvjO89iXmw/NYq/lv56d06iu3fdZ+6lLFt+2T+3HfifJ2p/nPesM48lLM6
        qe3BlID7r23Fqt++CAx97ez5u2tXlIJFzY9rq0I+xL54ednIguks+yS7xQ/fCkhlGG/5YKpr
        rFB6ysulc/fPnetyov4mPbA373gUEFNWtVwptVwsO96vT+hHSYt1wPHauUosxRmJhlrMRcWJ
        AN+A+bulAgAA
X-CMS-MailID: 20230203123513epcas5p4cb1961d7d1376bf39690f82de639d6f4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230203123513epcas5p4cb1961d7d1376bf39690f82de639d6f4
References: <CGME20230203123513epcas5p4cb1961d7d1376bf39690f82de639d6f4@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Use O_RDONLY flag when read is requested on char-type files.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---

Before this patch: unexpected permission-denial for unprivileged-user.

$ ls -l /dev/ng0n1
cr--r--r-- 1 root root 242, 0 Feb  3 16:30 /dev/ng0n1

$ ./fio -iodepth=1 -rw=randread -ioengine=io_uring_cmd -bs=4k -numjobs=1
-size=4k -cmd_type=nvme -filename=/dev/ng0n1 -name=t
t: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=io_uring_cmd, iodepth=1
fio-3.33-71-g7d7a
Starting 1 process
fio: pid=131312, err=13/file:filesetup.c:805, func=open(/dev/ng0n1),
error=Permission denied

 filesetup.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index 1d3cc5ad..d77b8ba4 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -768,10 +768,7 @@ open_again:
 		else
 			from_hash = file_lookup_open(f, flags);
 	} else if (td_read(td)) {
-		if (f->filetype == FIO_TYPE_CHAR && !read_only)
-			flags |= O_RDWR;
-		else
-			flags |= O_RDONLY;
+		flags |= O_RDONLY;
 
 		if (is_std)
 			f->fd = dup(STDIN_FILENO);
-- 
2.25.1

