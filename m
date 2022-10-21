Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79126FA3742
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 12:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbiJ0MDk (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 08:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiJ0MDi (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 08:03:38 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8A783F1C
        for <fio@vger.kernel.org>; Thu, 27 Oct 2022 05:03:35 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221027120332epoutp04bdd82904422077562c370f75734acbf4~h63Ij4DAP0381503815epoutp04F
        for <fio@vger.kernel.org>; Thu, 27 Oct 2022 12:03:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221027120332epoutp04bdd82904422077562c370f75734acbf4~h63Ij4DAP0381503815epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666872212;
        bh=sROe2YaKPvT2m0+tQayOOmtITXxjPN5v/QkJOUumHH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+7wijpbNRrQZIqeaS+5QbaIYIrxJZ7UYXVJPTtgvUN2qB32YRJpWEfW/WhssJNTN
         22h9823WH2aRq0MGxxjlLYhPMeIEYH1EQbGAkQ6BidJqc7o1aqfDchnaBiyTSDnZa0
         BBWiT9EEEChsheQz/1UeNwEVbhXSF31icWTMPmR8=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221027120331epcas5p2cde72c414a5392981fdab94a7ee0daad~h63HzaPI42583425834epcas5p27;
        Thu, 27 Oct 2022 12:03:31 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Mykpn5zVcz4x9Ps; Thu, 27 Oct
        2022 12:03:29 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        15.95.01710.1937A536; Thu, 27 Oct 2022 21:03:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221021114407epcas5p20666d7d1e4a0f8b65a09e4df02e99187~gEudsp2EQ1251612516epcas5p2K;
        Fri, 21 Oct 2022 11:44:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221021114407epsmtrp25605511a87a1f961e918699e315a5d68~gEudr8qrk2098020980epsmtrp2j;
        Fri, 21 Oct 2022 11:44:07 +0000 (GMT)
X-AuditID: b6c32a49-a41ff700000006ae-86-635a7391f320
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.9A.14392.70682536; Fri, 21 Oct 2022 20:44:07 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221021114406epsmtip12ee33544437989433d9fe04c028f7cb1~gEuctab1l0497804978epsmtip1o;
        Fri, 21 Oct 2022 11:44:05 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 2/2] io_uring: update documentation and small fix for
 sqthread_poll
Date:   Fri, 21 Oct 2022 17:02:36 +0530
Message-Id: <20221021113236.32340-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221021113236.32340-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsWy7bCmpu7E4qhkg11XdCzWXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOmLzTv+CvXMWLT8tZGxi7JbsYOTkk
        BEwk/pzawQpiCwnsZpRY/TCpi5ELyP7EKPHhyAuoxDdGif0HvGEa+jZfYIEo2sso0dk8kxHC
        aWWSmN6xlx2kik1AW+LV2xvMILaIgLDE/o5WFhCbWSBU4uS1L2A1wkB298uvTCA2i4CqxOP7
        3WwgNq+AjcSdPRPZILbJS6zecABsDqeArcTGronMEPFl7BKHZ3FC2C4S25q2skDYwhKvjm9h
        h7ClJD6/2ws1J1ti08OfTBB2gcSRF71Qc+wlWk/1A9kcQLdpSqzfpQ8RlpWYemodE8TJfBK9
        v59AtfJK7JgHY6tK/L13G2qttMTNd1ehbA+JnUdWsELCZAKjRMO91ywTGOVmIaxYwMi4ilEy
        taA4Nz212LTAMC+1HB5lyfm5mxjBKUrLcwfj3Qcf9A4xMnEwHmKU4GBWEuE9eyM8WYg3JbGy
        KrUoP76oNCe1+BCjKTD8JjJLiSbnA5NkXkm8oYmlgYmZmZmJpbGZoZI47+IZWslCAumJJanZ
        qakFqUUwfUwcnFINTD7Kx5uPcei90C1/lDO79fGBxFjj6Yfqzk6S6vn6YfK+Gys025bZVtTe
        vnXnmrrdxAxOsTCJfSzKXIuX/Mib4Tqj7fmOhen8Cl3uDrHqRmeD1R6fS9kYuFpvx9054V5T
        zJ4s0413Kr0utm2l6/pXsVukI5XFNzBZn0pPPuVTLPZnZdKPW1FeuamZQrrywqxueuXlAWw5
        NyIOv4+UuJNpE1h7YLMPr0eKoXHv7BVnJt+0PnwhQXGGV73aroPe8uukWMum8564vND3pWp6
        8hfNe3Xlu5UTwmK/SShE2rSpeJl4l8/ulvl6dOrLKZ9T41/mOn4V6XZoUYhY+l521sS0N6ra
        v3jPTixl31/XZiOuxFKckWioxVxUnAgALbRPh9oDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsWy7bCSnC57W1CywfvtXBZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGVM3ulf8Feu
        4sWn5awNjN2SXYycHBICJhJ9my+wdDFycQgJ7GaU2PDrMFsXIwdQQlpi4fpEiBphiZX/nrND
        1DQzSRw/c5wNJMEmoC3x6u0NZhBbBKhof0crC4jNLBAuMf3AZEYQW1ggWKLh5R0wm0VAVeLx
        /W6wXl4BG4k7eyayQSyQl1i94QDYHE4BW4mNXRPBbCGgmvuXzzJOYORbwMiwilEytaA4Nz23
        2LDAMC+1XK84Mbe4NC9dLzk/dxMjOIy0NHcwbl/1Qe8QIxMH4yFGCQ5mJRFei7qgZCHelMTK
        qtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYbF/NWzfh3PkL5yQv
        lNtNSFNYmfElpSnh4+WX/JzPlgY2nxCLLz7dbjF9mUrUfLea22L/JFwY97uUigT/qHE2M+h4
        uE2RW8tM/MAS26kH1kkciFstVHfiVUr4kfdCnx03OAdu+sgSwGRSpsP8/JDcph6WGy635tyL
        iz2oXnvxsZZqxMOLO2KSLgju+WziV38ipF55waU1kY8mKl1oMekTvqN/eHuimd3fmswJt96F
        XmLwWXz/sJl5U8A3jlK9w9FPDvRP//RH6z9zwNwImR5306sSgk5G7Vd2uM3YkP7xifWUiWtL
        lNeq5ItW8Bmk2Zxdv+C5VcPnzM+ruX/3uy8XXMbBXcpz/XqOgOCF+Bc5SizFGYmGWsxFxYkA
        XgiDZJICAAA=
X-CMS-MailID: 20221021114407epcas5p20666d7d1e4a0f8b65a09e4df02e99187
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021114407epcas5p20666d7d1e4a0f8b65a09e4df02e99187
References: <20221021113236.32340-1-ankit.kumar@samsung.com>
        <CGME20221021114407epcas5p20666d7d1e4a0f8b65a09e4df02e99187@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

type for sqthread_poll should be FIO_OPT_STR_SET, as this only
requires it to be set. This also fixes the issue:
https://github.com/axboe/fio/issues/927

Update the HOWTO and man page to specify the missing types for all
the remaining io_uring options.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst          | 6 +++---
 engines/io_uring.c | 2 +-
 fio.1              | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index e89d05f0..4b6ae4cc 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2274,7 +2274,7 @@ with the caveat that when used on the command line, they must come after the
 	map and release for each IO. This is more efficient, and reduces the
 	IO latency as well.
 
-.. option:: nonvectored : [io_uring] [io_uring_cmd]
+.. option:: nonvectored=int : [io_uring] [io_uring_cmd]
 
 	With this option, fio will use non-vectored read/write commands, where
 	address must contain the address directly. Default is -1.
@@ -2301,7 +2301,7 @@ with the caveat that when used on the command line, they must come after the
 	This frees up cycles for fio, at the cost of using more CPU in the
 	system.
 
-.. option:: sqthread_poll_cpu : [io_uring] [io_uring_cmd]
+.. option:: sqthread_poll_cpu=int : [io_uring] [io_uring_cmd]
 
 	When :option:`sqthread_poll` is set, this option provides a way to
 	define which CPU should be used for the polling thread.
@@ -2351,7 +2351,7 @@ with the caveat that when used on the command line, they must come after the
 	When hipri is set this determines the probability of a pvsync2 I/O being high
 	priority. The default is 100%.
 
-.. option:: nowait : [pvsync2] [libaio] [io_uring]
+.. option:: nowait=bool : [pvsync2] [libaio] [io_uring] [io_uring_cmd]
 
 	By default if a request cannot be executed immediately (e.g. resource starvation,
 	waiting on locks) it is queued and the initiating process will be blocked until
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 6906e0a4..3c656b77 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -226,7 +226,7 @@ static struct fio_option options[] = {
 	{
 		.name	= "sqthread_poll",
 		.lname	= "Kernel SQ thread polling",
-		.type	= FIO_OPT_INT,
+		.type	= FIO_OPT_STR_SET,
 		.off1	= offsetof(struct ioring_options, sqpoll_thread),
 		.help	= "Offload submission/completion to kernel thread",
 		.category = FIO_OPT_C_ENGINE,
diff --git a/fio.1 b/fio.1
index 4324a975..9e33c9e1 100644
--- a/fio.1
+++ b/fio.1
@@ -2063,7 +2063,7 @@ release them when IO is done. If this option is set, the pages are pre-mapped
 before IO is started. This eliminates the need to map and release for each IO.
 This is more efficient, and reduces the IO latency as well.
 .TP
-.BI (io_uring,io_uring_cmd)nonvectored
+.BI (io_uring,io_uring_cmd)nonvectored \fR=\fPint
 With this option, fio will use non-vectored read/write commands, where address
 must contain the address directly. Default is -1.
 .TP
@@ -2092,7 +2092,7 @@ available items in the SQ ring. If this option is set, the act of submitting IO
 will be done by a polling thread in the kernel. This frees up cycles for fio, at
 the cost of using more CPU in the system.
 .TP
-.BI (io_uring,io_uring_cmd)sqthread_poll_cpu
+.BI (io_uring,io_uring_cmd)sqthread_poll_cpu \fR=\fPint
 When `sqthread_poll` is set, this option provides a way to define which CPU
 should be used for the polling thread.
 .TP
@@ -2115,7 +2115,7 @@ than normal.
 When hipri is set this determines the probability of a pvsync2 I/O being high
 priority. The default is 100%.
 .TP
-.BI (pvsync2,libaio,io_uring)nowait
+.BI (pvsync2,libaio,io_uring,io_uring_cmd)nowait \fR=\fPbool
 By default if a request cannot be executed immediately (e.g. resource starvation,
 waiting on locks) it is queued and the initiating process will be blocked until
 the required resource becomes free.
-- 
2.17.1

