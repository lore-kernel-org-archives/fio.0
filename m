Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD50C43217
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 05:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiLAF3D (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 00:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLAF3C (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 00:29:02 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F3BA13F8
        for <fio@vger.kernel.org>; Wed, 30 Nov 2022 21:29:00 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221201052857epoutp02d59b81fb5bb7ad6b4b61eb0e61c7f5d9~slDnEDvc_0212802128epoutp02j
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 05:28:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221201052857epoutp02d59b81fb5bb7ad6b4b61eb0e61c7f5d9~slDnEDvc_0212802128epoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669872537;
        bh=KkSqpOof0LK1bE10K8pt6WvKTAD4b0BEwyNZSosDLCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghA51/RW4r9soB11GOTP9KUGrqXzhaWMEEWlG2FvSftIOV7VCdwBE7e6C+xI2ouCr
         oTj7odl/cCfXG+/uHY47C+YEg7NCRsw8jSGMR3r4kS7YIiGwcEIg7dUDGN+bGjj5qQ
         WwuL2mi4Y4lH73hxMpLovTsuHxBcBL3Ijqf6oUQo=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221201052857epcas5p480d67876d5c02039c70316aec6016629~slDmy4NPt2269622696epcas5p4t;
        Thu,  1 Dec 2022 05:28:57 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4NN4PM5Z5Dz4x9QQ; Thu,  1 Dec
        2022 05:28:55 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A5.F0.39477.59B38836; Thu,  1 Dec 2022 14:28:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221201052005epcas5p1f948fe465553e592d81edf1be6a3ccb7~sk73TQD_v0203102031epcas5p1j;
        Thu,  1 Dec 2022 05:20:05 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221201052005epsmtrp230c6a57855aeb2a941002d6fb23c084b~sk73Slusl2702327023epsmtrp2q;
        Thu,  1 Dec 2022 05:20:05 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-4b-63883b95e50c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        69.AF.18644.58938836; Thu,  1 Dec 2022 14:20:05 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221201052004epsmtip19f208f88a6dc15804b5d6fd3552ab8a4~sk72IxivF0178601786epsmtip16;
        Thu,  1 Dec 2022 05:20:03 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 1/1] doc: update about size
Date:   Thu,  1 Dec 2022 10:38:32 +0530
Message-Id: <20221201050832.18513-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221201050832.18513-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsWy7bCmuu5U645kgxkHeCzWXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOmPzpF2PBJeGK5QvtGxh7BLoYOTkk
        BEwkfrR9YOpi5OIQEtjNKNH7cSczhPOJUWL34SesEM5nRokHt++ywbSc3r8CKrGLUWLPgufs
        IAkhgVYmid/tViA2m4C2xKu3N5hBbBEBYYn9Ha0sIDazQKjEyWtfgOo5OIQF9CQ23bQGCbMI
        qEp8+bSWFSTMK2AjcWtLGMQqeYnVGw6ATeEUsJW48WUN2HESAsvYJdpfnWADqZcQcJF4+7wU
        ol5Y4tXxLewQtpTE53d7oU7Oltj08CcThF0gceRFLzOEbS/ReqqfGWQMs4CmxPpd+hBhWYmp
        p9YxQRzMJ9H7+wlUK6/EjnkwtqrE33u3WSBsaYmb765C2R4SnT2LoAE6gVHi/IqXjBMY5WYh
        rFjAyLiKUTK1oDg3PbXYtMAoL7UcHmPJ+bmbGMEJSstrB+PDBx/0DjEycTAeYpTgYFYS4e34
        3JYsxJuSWFmVWpQfX1Sak1p8iNEUGHwTmaVEk/OBKTKvJN7QxNLAxMzMzMTS2MxQSZx38Qyt
        ZCGB9MSS1OzU1ILUIpg+Jg5OqQYmlSkPvjwUeyDNdY35sKfSP7ZuXcl6EcUryp/UOLL1QnqT
        P3p2sImdf1Dl/56h9FfLkRlTryVt0tCaebI4KWvu1IVXNys3MzpuSa87seOPn2fWa1XxQzwf
        Htb8fb8++u3iSo7lyV/nex/ObF99MoJ/f9u0Zf6tV/2bWS5tLNT021tgZlmzuLI9fc++LXV3
        qwpv7f+58+TE+HnNM2oW/w5hMFjyI4KD4efXbpYHk01bdG7buh15WW+f+PKs/O6HwjFfdh/o
        qVe4dJ/vgGDy9Vcrd+/9v/H4zb65ggEL/tipvuzYGHeptlannOPQ3G0HvusKbBHoNJfz3qBv
        7u/4wntjx/qOjVoVbDFfhPiSv7XpKLEUZyQaajEXFScCAPLqp3HZAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsWy7bCSnG6rZUeywdd5vBZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGVM/vSLseCS
        cMXyhfYNjD0CXYycHBICJhKn969g7WLk4hAS2MEocebSZMYuRg6ghLTEwvWJEDXCEiv/PWeH
        qGlmknj1eQkTSIJNQFvi1dsbzCC2CFDR/o5WFhCbWSBcYvoBiDnCAnoSm25ag4RZBFQlvnxa
        ywoS5hWwkbi1JQxivLzE6g0HwKZwCthK3PiyBswWAippWdzNPoGRbwEjwypGydSC4tz03GLD
        AqO81HK94sTc4tK8dL3k/NxNjOAQ0tLawbhn1Qe9Q4xMHIyHGCU4mJVEeDs+tyUL8aYkVlal
        FuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwCTaZLf+o9i0KwtMeONP
        /Dx9JD9OjmMi7+ZIaeUyvT87maew/F3r5jfZP7B4dn72ZflP/ccqrL7PFApaXNQ2md3OSrfn
        SPler98vFUX4Qs81mXD8nH2LUX2x6OSPB9fxzHj8XmRvw+OO9FebLrWwLlp06PIe1Szf4vKk
        U2LJPj0q2Y2hHS9P6Rt8Fbn5ru5Y3/4XO3l7AvQetT/2C5nI+4xrn9+5bxKnVhhN2rYv4lPH
        VFavvIingue0/wv/3vKFWfRvQ2276NvFG/YrZ3Jc2DT/tqV8cyv7oQOTO1jmf54st2wF8xXv
        y/Mfphddu2ledu2JVuaBGsmceC/3Cr2Xv5d6nOJQqT4ifnbG4nn+xV1KLMUZiYZazEXFiQAD
        YTbekAIAAA==
X-CMS-MailID: 20221201052005epcas5p1f948fe465553e592d81edf1be6a3ccb7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221201052005epcas5p1f948fe465553e592d81edf1be6a3ccb7
References: <20221201050832.18513-1-ankit.kumar@samsung.com>
        <CGME20221201052005epcas5p1f948fe465553e592d81edf1be6a3ccb7@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

In few cases with fio option size the number of bytes of data transferred
is actually less than what we specified. This can happen if there are
gaps or holes while doing I/O's or if we are running a mix of sequential
and random workload.
Update the documentation for that.

Fixes: https://github.com/axboe/fio/issues/1486

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 7 +++++--
 fio.1     | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 2ea84558..0aaf033a 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1875,8 +1875,11 @@ I/O size
 .. option:: size=int
 
 	The total size of file I/O for each thread of this job. Fio will run until
-	this many bytes has been transferred, unless runtime is limited by other options
-	(such as :option:`runtime`, for instance, or increased/decreased by :option:`io_size`).
+	this many bytes has been transferred, unless runtime is altered by other means
+	such as (1) :option:`runtime`, (2) :option:`io_size` (3) :option:`number_ios`,
+	(4) gaps/holes while doing I/O's such as ``rw=read:16K``, or (5) sequential
+	I/O reaching end of the file which is possible when :option:`percentage_random`
+	is less than 100.
 	Fio will divide this size between the available files determined by options
 	such as :option:`nrfiles`, :option:`filename`, unless :option:`filesize` is
 	specified by the job. If the result of division happens to be 0, the size is
diff --git a/fio.1 b/fio.1
index 746c4472..62af0bd2 100644
--- a/fio.1
+++ b/fio.1
@@ -1676,8 +1676,11 @@ simulate a smaller amount of memory. The amount specified is per worker.
 .TP
 .BI size \fR=\fPint[%|z]
 The total size of file I/O for each thread of this job. Fio will run until
-this many bytes has been transferred, unless runtime is limited by other options
-(such as \fBruntime\fR, for instance, or increased/decreased by \fBio_size\fR).
+this many bytes has been transferred, unless runtime is altered by other means
+such as (1) \fBruntime\fR, (2) \fBio_size\fR, (3) \fBnumber_ios\fR, (4)
+gaps/holes while doing I/O's such as `rw=read:16K', or (5) sequential I/O
+reaching end of the file which is possible when \fBpercentage_random\fR is
+less than 100.
 Fio will divide this size between the available files determined by options
 such as \fBnrfiles\fR, \fBfilename\fR, unless \fBfilesize\fR is
 specified by the job. If the result of division happens to be 0, the size is
-- 
2.17.1

