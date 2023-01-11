Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B07C9C54EBE
	for <fio@archiver.kernel.org>; Wed, 11 Jan 2023 06:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbjAKG4d (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 11 Jan 2023 01:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbjAKG4A (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 Jan 2023 01:56:00 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161D02675
        for <fio@vger.kernel.org>; Tue, 10 Jan 2023 22:55:59 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230111065557epoutp03df29462e58c8886d5607a26ef89e70b4~5LsRoeW1o1975719757epoutp03k
        for <fio@vger.kernel.org>; Wed, 11 Jan 2023 06:55:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230111065557epoutp03df29462e58c8886d5607a26ef89e70b4~5LsRoeW1o1975719757epoutp03k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1673420157;
        bh=kK9vibrJjmC3VONBqgSAujsdMkBYTj3vqk1xhHdiOAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0Xx+lgMuN52OJ5SR4bHDwPIIUfoG92jbhhpyqjXaeZDsHVj5BDOGmUHvPC+md408
         O0aaiLFDSJ+VpyUmmYmez+l3CvWZxx8OWti6uGgTff8VNOKVzx83rcqDjep/qEPHk1
         58r5uTKCo+FUftfWZ95amInlmcywveOneDd9XxwU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230111065557epcas5p2464b37b406ab8b046a31e497cfdc9ba0~5LsRRA8Z_2155221552epcas5p2-;
        Wed, 11 Jan 2023 06:55:57 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4NsJNq4w5Jz4x9Q9; Wed, 11 Jan
        2023 06:55:55 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.73.62806.B7D5EB36; Wed, 11 Jan 2023 15:55:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230111064842epcas5p1340926e9fbd7fff97070ae2b6c90816c~5Ll8aFbbf2112621126epcas5p1I;
        Wed, 11 Jan 2023 06:48:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230111064842epsmtrp1a9da410fa6a80da80aeb2e3e24b59b70~5Ll8ZhWeK1758417584epsmtrp1L;
        Wed, 11 Jan 2023 06:48:42 +0000 (GMT)
X-AuditID: b6c32a4a-ea5fa7000000f556-12-63be5d7b571d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F3.AD.02211.ACB5EB36; Wed, 11 Jan 2023 15:48:42 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230111064841epsmtip291a6859cfc19193125f7db13d067671a~5Ll7o57mD0276402764epsmtip2X;
        Wed, 11 Jan 2023 06:48:41 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 1/1] doc: clarify the usage of rw_sequencer
Date:   Wed, 11 Jan 2023 12:18:05 +0530
Message-Id: <20230111064805.10001-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230111064805.10001-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsWy7bCmum517L5kg31HxC3WXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjO+Nzwha3go3zF5k2PWBoYL0h2MXJy
        SAiYSLx7087WxcjFISSwm1Giccl0ZgjnE6PE51VbGCGcb4wS8y/2s8G0vL01EaplL6NE19+3
        rBBOM5PE0+dHWEGq2AS0JV69vcEMYosICEvs72hlAbGZBUIlTl77wg5iCwvYSdxdPxOsnkVA
        VaJ301qwOK+AjcSy7/3sENvkJVZvOAA2h1PAVuLJqY1Q8VXsErPn+EHYLhLPdv2DigtLvDq+
        BcqWknjZ3wZlZ0tseviTCcIukDjyopcZwraXaD3VD2RzAN2mKbF+lz5EWFZi6ql1TBAn80n0
        /n4C1corsWMejK0q8ffebRYIW1ri5rurULaHxIQHB8CBJSQwgVGi457WBEa5WQgbFjAyrmKU
        TC0ozk1PLTYtMMpLLYdHWnJ+7iZGcJrS8trB+PDBB71DjEwcjIcYJTiYlUR4V3LuSRbiTUms
        rEotyo8vKs1JLT7EaAoMvonMUqLJ+cBEmVcSb2hiaWBiZmZmYmlsZqgkzpu6dX6ykEB6Yklq
        dmpqQWoRTB8TB6dUAxPjmVXXdePvJRk+YRGSWCRT3jFXb94B9zzduc1HcqsKOwKOfd/5jUm0
        unSXK6/t0Vs/77w78WbZj7dM7+b5OPgknJ3Lq2vcN8fObL0Ty4mywjW7P6nEfgh4efrsAgNp
        HpVFbq+rZRvfPLnH79mTvNvnIM+m2QUd3OuZyg5/XHP99oP16wU8lQ+pTSlIruJiSc8Xv/j5
        xitLrv8Xrp1a8k+Mq2Enw3XBfyf/zf7Zutsk4OOGW/eaOn+kbFiTv2ulzc3CZLf6+wuiD2xo
        263ufmoeU+y/jidaN8+sms7x7oJ89Zx5/zSlewXbmRYH/OziOvj65C3/Gz5ruTx/nQ5bJnW5
        LHpulfDTzMQpurfeveCcocRSnJFoqMVcVJwIAL5k0APcAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsWy7bCSvO6p6H3JBlt2S1isufKb3WL13X42
        i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXxueELW8FH
        +YrNmx6xNDBekOxi5OSQEDCReHtrIhuILSSwm1Hi4unILkYOoLi0xML1iRAlwhIr/z1n72Lk
        AippZJKYuPcrM0iCTUBb4tXbG2C2CFDR/o5WFhCbWSBcYvqByYwgtrCAncTd9TNZQWwWAVWJ
        3k1r2UFsXgEbiWXf+9khFshLrN5wAGwOp4CtxJNTG9kh7rGR2HZ7P9sERr4FjAyrGCVTC4pz
        03OLDQsM81LL9YoTc4tL89L1kvNzNzGCw0hLcwfj9lUf9A4xMnEwHmKU4GBWEuFdybknWYg3
        JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZJg5OqQamuffXypxkEVzp
        dLXiztd2fu+nuSd0r7UYeUzhmPptvci+YmW7uCrl+J7ybx8NYgLqpl3Ic7X5Uyv/hy2lszqD
        wb6j7sF93SUPJeITX33vCzu95GJy12ZHga1d+y4x6Jeetbfl6+DZYXNz8oSt16NVm5gviRqu
        7/g0eaf6nG0HP54Sd7DVW1b5dNUF3V1Kp/bpux7l/x13MTU87GnsddugJZOev3Ct6nev5+E/
        s3dLstHnY8JzosMzwu+v8/2cduGAiMrm2kMiMzP/WjV8WPYwpaJ1W2qXyrOPB/99y5z/ep/a
        P80bf19PaF/BVOcW2BTNlMy6O1sgj7/DyMhr1gOnA438/+Yc+31oA+uf86eFlViKMxINtZiL
        ihMBi3K6qJICAAA=
X-CMS-MailID: 20230111064842epcas5p1340926e9fbd7fff97070ae2b6c90816c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230111064842epcas5p1340926e9fbd7fff97070ae2b6c90816c
References: <20230111064805.10001-1-ankit.kumar@samsung.com>
        <CGME20230111064842epcas5p1340926e9fbd7fff97070ae2b6c90816c@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Update man page clarifying the usage of rw_sequencer=sequential
Added few examples explaining the offset generation for rw_sequencer.

Fixes: https://github.com/axboe/fio/issues/1223

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 35 ++++++++++++++++++++++++++++-------
 fio.1     | 47 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 69 insertions(+), 13 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 0a48a453..17caaf5d 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1176,13 +1176,34 @@ I/O type
 			Generate the same offset.
 
 	``sequential`` is only useful for random I/O, where fio would normally
-	generate a new random offset for every I/O. If you append e.g. 8 to randread,
-	you would get a new random offset for every 8 I/Os. The result would be a
-	seek for only every 8 I/Os, instead of for every I/O. Use ``rw=randread:8``
-	to specify that. As sequential I/O is already sequential, setting
-	``sequential`` for that would not result in any differences.  ``identical``
-	behaves in a similar fashion, except it sends the same offset 8 number of
-	times before generating a new offset.
+	generate a new random offset for every I/O. If you append e.g. 8 to
+	randread, i.e. ``rw=randread:8`` you would get a new random offset for
+	every 8 I/Os. The result would be a sequence of 8 sequential offsets
+	with a random starting point. However this behavior may change if a
+	sequential I/O reaches end of the file. As sequential I/O is already
+	sequential, setting ``sequential`` for that would not result in any
+	difference. ``identical`` behaves in a similar fashion, except it sends
+	the same offset 8 number of times before generating a new offset.
+
+	Example #1::
+
+		rw=randread:8
+		rw_sequencer=sequential
+		bs=4k
+
+	The generated sequence of offsets will look like this:
+	4k, 8k, 12k, 16k, 20k, 24k, 28k, 32k, 92k, 96k, 100k, 104k, 108k,
+	112k, 116k, 120k, 48k, 52k ...
+
+	Example #2::
+
+		rw=randread:8
+		rw_sequencer=identical
+		bs=4k
+
+	The generated sequence of offsets will look like this:
+	4k, 4k, 4k, 4k, 4k, 4k, 4k, 4k, 92k, 92k, 92k, 92k, 92k, 92k, 92k, 92k,
+	48k, 48k, 48k ...
 
 .. option:: unified_rw_reporting=str
 
diff --git a/fio.1 b/fio.1
index eb87533f..527b3d46 100644
--- a/fio.1
+++ b/fio.1
@@ -952,12 +952,47 @@ Generate the same offset.
 .P
 \fBsequential\fR is only useful for random I/O, where fio would normally
 generate a new random offset for every I/O. If you append e.g. 8 to randread,
-you would get a new random offset for every 8 I/Os. The result would be a
-seek for only every 8 I/Os, instead of for every I/O. Use `rw=randread:8'
-to specify that. As sequential I/O is already sequential, setting
-\fBsequential\fR for that would not result in any differences. \fBidentical\fR
-behaves in a similar fashion, except it sends the same offset 8 number of
-times before generating a new offset.
+i.e. `rw=randread:8' you would get a new random offset for every 8 I/Os. The
+result would be a sequence of 8 sequential offsets with a random starting
+point.  However this behavior may change if a sequential I/O reaches end of the
+file. As sequential I/O is already sequential, setting \fBsequential\fR for
+that would not result in any difference. \fBidentical\fR behaves in a similar
+fashion, except it sends the same offset 8 number of times before generating a
+new offset.
+.P
+.P
+Example #1:
+.RS
+.P
+.PD 0
+rw=randread:8
+.P
+rw_sequencer=sequential
+.P
+bs=4k
+.PD
+.RE
+.P
+The generated sequence of offsets will look like this:
+4k, 8k, 12k, 16k, 20k, 24k, 28k, 32k, 92k, 96k, 100k, 104k, 108k, 112k, 116k,
+120k, 48k, 52k ...
+.P
+.P
+Example #2:
+.RS
+.P
+.PD 0
+rw=randread:8
+.P
+rw_sequencer=identical
+.P
+bs=4k
+.PD
+.RE
+.P
+The generated sequence of offsets will look like this:
+4k, 4k, 4k, 4k, 4k, 4k, 4k, 4k, 92k, 92k, 92k, 92k, 92k, 92k, 92k, 92k, 48k,
+48k, 48k ...
 .RE
 .TP
 .BI unified_rw_reporting \fR=\fPstr
-- 
2.17.1

