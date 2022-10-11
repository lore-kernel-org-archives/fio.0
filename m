Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9319C433FE
	for <fio@archiver.kernel.org>; Wed, 12 Oct 2022 05:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJLFMY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 12 Oct 2022 01:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLFMX (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 Oct 2022 01:12:23 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6028AA379
        for <fio@vger.kernel.org>; Tue, 11 Oct 2022 22:12:21 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221012051216epoutp0403f03d1c2ca6ef84f147856f5b5db1f5~dOkxUqGZs1968419684epoutp04f
        for <fio@vger.kernel.org>; Wed, 12 Oct 2022 05:12:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221012051216epoutp0403f03d1c2ca6ef84f147856f5b5db1f5~dOkxUqGZs1968419684epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1665551536;
        bh=IFyMBZSmSL3wpYBZJul9Z3iJ1JKoXWw1IY6kwh+EWVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swA3xx1h1/UQ0vmwFocbLzCWuMCN34QsYu0fPvXlXjBfd4r9sLgsjo0bmY4nG6+as
         iikEYxIOsRlt47H6uHFG3T3SW04tPuem9NLxcZ7yA9l9RppTUnjPg6rFzZO/1jYjlx
         LxoAug+6VFmE8RF6IPRgCPTH8DUKgvG7nVwu9GHE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221012051216epcas5p2b8986e24352da14386604408fee8f8ba~dOkxGsG8v3145031450epcas5p2a;
        Wed, 12 Oct 2022 05:12:16 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MnLP856RZz4x9Q0; Wed, 12 Oct
        2022 05:12:12 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        41.39.39477.AAC46436; Wed, 12 Oct 2022 14:12:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221011110948epcas5p1a129c0869d780bf1b236141d18e8023f~c-zpaRD_F1781417814epcas5p1P;
        Tue, 11 Oct 2022 11:09:48 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221011110948epsmtrp21307ab673ec64fa04fd3dfc933e7934e~c-zpZneeH2450924509epsmtrp2I;
        Tue, 11 Oct 2022 11:09:48 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-ac-63464caaf647
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        65.A7.14392.CFE45436; Tue, 11 Oct 2022 20:09:48 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221011110947epsmtip209e4f587cc74f508ee241de085d4c873~c-zopHdhb1002610026epsmtip2P;
        Tue, 11 Oct 2022 11:09:47 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/1] engines/io_uring: set coop taskrun, single issuer and
 defer taskrun
Date:   Tue, 11 Oct 2022 16:29:35 +0530
Message-Id: <20221011105935.10455-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221011105935.10455-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsWy7bCmpu4qH7dkg2XfpSzWXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOmL9yG2vBdJ6K9c39zA2Mzzm7GDk5
        JARMJG5un8jYxcjFISSwm1Fiw95GNpCEkMAnRon+U6YQiW+MEjtWL2CB6WhfNY8NIrGXUeLS
        i32MEB2tTBKLViiD2GwC2hKv3t5gBrFFBIQl9ne0gjUzC4RKnLz2hR3EFhaIkri4qxushkVA
        VaKxuxmshlfARmLOzY2MEMvkJVZvOABWwylgK9HUeY0ZZLGEwCp2ic1tV4EGcQA5LhKXjvFD
        1AtLvDq+hR3ClpL4/G4vG4SdLbHp4U8mCLtA4siLXmYI216i9VQ/M8gYZgFNifW79CHCshJT
        T61jgjiZT6L39xOoVl6JHfNgbFWJv/duQ8NEWuLmu6tQtofE0gf3mSHhM4FRYsqqZUwTGOVm
        IaxYwMi4ilEytaA4Nz212LTAKC+1HB5nyfm5mxjBSUrLawfjwwcf9A4xMnEwHmKU4GBWEuFl
        nO+ULMSbklhZlVqUH19UmpNafIjRFBh+E5mlRJPzgWkyryTe0MTSwMTMzMzE0tjMUEmcd/EM
        rWQhgfTEktTs1NSC1CKYPiYOTqkGpvRql6lL31/lszb30PYP9XTTrXof0v17L+OJ1kLbb1dC
        Iw7zLVzrXHxKOT/+5oyLf5vCtjz+qhO6b+n5z89m3TTisXMpXKWn/7i+vZar7+HRZ0HTM2XP
        Cxj8Ur603d/x/8GrD0RuuH/i8JBtlc73O83YPnvH1HihtDW2MzX3e5xh+WvCILXo07TnnIUX
        z1/QEkpdNyn8qX1J5YrcqaVvLOfuMj0T3KbQm/TmSsNrDibXu9M5LiXfz6l/JaM9ZdqPU8tP
        N6V1nPwuPZHnvsblY1M1Nn3VDJ9iabRsSZnU1VbmVUYmRfGbJCwenN4joT9v6doXhckCs1Yl
        yWdNOad8+4nFoclp7jfbd3i+NU36dlSJpTgj0VCLuag4EQBXe39u2wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsWy7bCSvO4fP9dkg2n3uCzWXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4MqYv3Iba8F0
        nor1zf3MDYzPObsYOTkkBEwk2lfNY+ti5OIQEtjNKPFx9X72LkYOoIS0xML1iRA1whIr/z1n
        B7GFBJqZJFacNgax2QS0JV69vcEMYosA1ezvaGUBsZkFwiWmH5jMCGILC0RIXPmxlwnEZhFQ
        lWjsbgar4RWwkZhzcyMjxHx5idUbDoDN4RSwlWjqvMYMsctGYtfTS+wTGPkWMDKsYpRMLSjO
        Tc8tNiwwzEst1ytOzC0uzUvXS87P3cQIDiMtzR2M21d90DvEyMTBeIhRgoNZSYSXcb5TshBv
        SmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTBycUg1MezoL9GqvuU9x
        Faubc/Kz01nbhd09b5hnOr6V9Wrq3vv727zJ85oehNRdfHMnf9v5qEVKc+R5/Borph7Z4WJz
        2W95V69lh+BbvcS8QMUbivNPHC8RDSrxVDPRktlmEvDmmudv+zhrjY2c/A99ldY1uN83claP
        +GP0ytbeN9ld4N7pXU6crom/fiwOOHxN/Jmoo8eZGVnpXLuFrT92N/coP+6u/G6+LvfJK6b1
        KYv+d23avOdK4Z0cL4mClOWif/ddcN5rJ95ex2KjN5NBJOHkg9da9zZ5FTmItZ/X2KHLwbrx
        6wNJY43K7MdXejclcz6P+rPPYi/bE5FbpbvmTFl1ROuLdJLDCgZ1DreFRteVWIozEg21mIuK
        EwH2wNGrkgIAAA==
X-CMS-MailID: 20221011110948epcas5p1a129c0869d780bf1b236141d18e8023f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221011110948epcas5p1a129c0869d780bf1b236141d18e8023f
References: <20221011105935.10455-1-ankit.kumar@samsung.com>
        <CGME20221011110948epcas5p1a129c0869d780bf1b236141d18e8023f@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add missing changes to io_uring_cmd I/O engine for COOP_TASKRUN
This was introduced for io_uring in commit 4d22c103

Add missing changes to io_uring_cmd I/O engine to set single issuer
and defer taskrun. This was introduced for io_uring in commit e453f369

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index c679177f..6906e0a4 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -889,9 +889,30 @@ static int fio_ioring_cmd_queue_init(struct thread_data *td)
 	p.flags |= IORING_SETUP_CQSIZE;
 	p.cq_entries = depth;
 
+	/*
+	 * Setup COOP_TASKRUN as we don't need to get IPI interrupted for
+	 * completing IO operations.
+	 */
+	p.flags |= IORING_SETUP_COOP_TASKRUN;
+
+	/*
+	 * io_uring is always a single issuer, and we can defer task_work
+	 * runs until we reap events.
+	 */
+	p.flags |= IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN;
+
 retry:
 	ret = syscall(__NR_io_uring_setup, depth, &p);
 	if (ret < 0) {
+		if (errno == EINVAL && p.flags & IORING_SETUP_DEFER_TASKRUN) {
+			p.flags &= ~IORING_SETUP_DEFER_TASKRUN;
+			p.flags &= ~IORING_SETUP_SINGLE_ISSUER;
+			goto retry;
+		}
+		if (errno == EINVAL && p.flags & IORING_SETUP_COOP_TASKRUN) {
+			p.flags &= ~IORING_SETUP_COOP_TASKRUN;
+			goto retry;
+		}
 		if (errno == EINVAL && p.flags & IORING_SETUP_CQSIZE) {
 			p.flags &= ~IORING_SETUP_CQSIZE;
 			goto retry;
-- 
2.17.1

