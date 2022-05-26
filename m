Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B132C433F5
	for <fio@archiver.kernel.org>; Thu, 26 May 2022 16:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345880AbiEZQsG (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 26 May 2022 12:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235796AbiEZQsF (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 May 2022 12:48:05 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE61E562EA
        for <fio@vger.kernel.org>; Thu, 26 May 2022 09:48:02 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220526164800epoutp028d4de7d0ad2da1d859533c1b8c9b06ff~ytZjHxnay3273632736epoutp025
        for <fio@vger.kernel.org>; Thu, 26 May 2022 16:48:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220526164800epoutp028d4de7d0ad2da1d859533c1b8c9b06ff~ytZjHxnay3273632736epoutp025
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653583681;
        bh=1cfQnN87dhNTBBaO4S7MyFD0zkF4e9nDnwpFIdNaFgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJ/NdfXUgbAy6SDfNjH9Jf4zT/mNXUYmGKLqrtaqyn2YpNNB5aY/u3rwddl0/VTfz
         XKo8B+djOOgpI4hR6nyFFPMTMjH6rpMhl9LnZbumM6pFxiFh2UsspMzB9iPdaJ1SM7
         o2cVIsVPlVNDgEp23UOrgEMmZHx2dfSYMJbw5qg8=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220526164759epcas5p3617b03498e06c7b86896193d5b61b4f4~ytZiKUA-o1959819598epcas5p3x;
        Thu, 26 May 2022 16:47:59 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4L8DQ420khz4x9Pp; Thu, 26 May
        2022 16:47:56 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C0.B1.09827.C3FAF826; Fri, 27 May 2022 01:47:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220526145349epcas5p3b905edd0d1015dfa3cb7b08c4e9344c4~yr12HXxSO1826518265epcas5p3I;
        Thu, 26 May 2022 14:53:49 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220526145349epsmtrp20487792b2107127b66e06151c2dc8f22~yr12Gm4xH1477014770epsmtrp2t;
        Thu, 26 May 2022 14:53:49 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-f9-628faf3ca68f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        5F.3E.08924.D749F826; Thu, 26 May 2022 23:53:49 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220526145348epsmtip2b1fb8da970473516f53b10c9221e8620~yr11NYpTx1808718087epsmtip2D;
        Thu, 26 May 2022 14:53:48 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com
Subject: [PATCH v2 1/8] io_uring.h: add IORING_SETUP_SQE128 and
 IORING_SETUP_CQE32
Date:   Thu, 26 May 2022 20:18:02 +0530
Message-Id: <20220526144809.14877-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220526144809.14877-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsWy7bCmlq7N+v4kgwl/uCyaJvxltlh9t5/N
        4uOsF8wWR/+/ZbNYuHEZkwOrx+WzpR59W1YxenzeJBfAHJVtk5GamJJapJCal5yfkpmXbqvk
        HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCR
        X1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnbGi7zZTwW/hit1nzjE2MD7n72Lk
        5JAQMJGYtmUKYxcjF4eQwG5GiY/XprCBJIQEPjFKrOzIh7A/M0ocvB4E0/Czs4MdomEXo8TJ
        z5+YIJxWJolDrVOYQKrYBLQlXr29wQxiiwgIS+zvaGUBsZkFYiWeb2sAqxEWCJFYNuUnK4jN
        IqAqcXrbP0YQm1fARuJF+wtGiG3yEqs3HACbwylgK3Hu9gw2kGUSAqvYJZacWsoOUeQicbhp
        LjOELSzx6vgWqLiUxOd3e9kg7GyJxkd/oewSiZ23tkPV20tc3PMX6CAOoOM0Jdbv0ocIy0pM
        PbWOCeJmPone30+YIOK8EjvmwdiqEn/v3WaBsKUlbr67ygIyRkLAQ+LSCRlImExglPh66i77
        BEa5WQgbFjAyrmKUTC0ozk1PLTYtMMpLLYfHWXJ+7iZGcJrS8trB+PDBB71DjEwcjIcYJTiY
        lUR4LzztTRLiTUmsrEotyo8vKs1JLT7EaAoMv4nMUqLJ+cBEmVcSb2hiaWBiZmZmYmlsZqgk
        zivwvzFJSCA9sSQ1OzW1ILUIpo+Jg1Oqgang3jJzl7CWuubr4Wd1HLS2S8+2/XTB2r7+7x/W
        J4sTGA5Vi1379anr0p09Ytob7DdULk0p5v1T2VuT27DoqXhy22df63Vy0i3C7/pnblP8esC/
        /WmGknrmLLm5VmGX9oT3GV4LEUswfBre/ULpxPXXL0si7ZZuqG1xazqj8ueD0yttC4u5/HXB
        v2qfWnR2l/3I+3h5a/yt59tvu6udqQ18xXij+/XeboErf0t5ZjtNuDeXe8eCJ2cjmvQTXla4
        Lk9xOPx+yfLOV7OP9VrMaHhnX2Nu9tVZ/lxGrsaeefxTvcv+h1VPraw3DZp4Q5Tnm1d2o7x+
        gn3au4XhfTdl9QL32wXZxH192yJ67eiz5UosxRmJhlrMRcWJAFwbRjDcAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42LZdlhJXrd2Sn+SQc93IYumCX+ZLVbf7Wez
        +DjrBbPF0f9v2SwWblzG5MDqcflsqUffllWMHp83yQUwR3HZpKTmZJalFunbJXBlrOi7zVTw
        W7hi95lzjA2Mz/m7GDk5JARMJH52drCD2EICOxglZp9y6mLkAIpLSyxcnwhRIiyx8t9zoBIu
        oJJmJoknPX9YQRJsAtoSr97eYAaxRYCK9ne0soDYzAKJEjsm7WIEsYUFgiQaVp1iArFZBFQl
        Tm/7BxbnFbCReNH+ghFigbzE6g0HwOZwCthKnLs9gw3iHhuJf/suMk1g5FvAyLCKUTK1oDg3
        PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4kLS0djDuWfVB7xAjEwfjIUYJDmYlEd4LT3uThHhT
        EiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamDa2t+k2rhi54Wn
        lnduKt/mO7LnI1vzaw3elUs3PnLYu/5IsDqz57T5qzetywgpLJ1QHlEoveVXxd3TEmr/oxLX
        twYz7/DM2XHTzDJBXrMoL3uqsIpth2vit23x3MbzL29+zHtaXdogIC/s7ALFh01MLy3Pftwg
        EJckvk59g8HhkDr3metsdser6tczT/CUypk3h2nf0Rt7Dv/71clTxzwt01z70kub22Uny5jD
        3pvM3Jw103DXvbBVH6LXftW9tZrhxDur+XlqptNTf7hLzFmzzv7xmoUx66L69xSobBZ6nz/v
        3P7+TM68eJVZczY7bbjk801fPORrYUTj6YmG51qSMtUu9JuKrztwR2i6a6WbEktxRqKhFnNR
        cSIAnFSKI5MCAAA=
X-CMS-MailID: 20220526145349epcas5p3b905edd0d1015dfa3cb7b08c4e9344c4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145349epcas5p3b905edd0d1015dfa3cb7b08c4e9344c4
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145349epcas5p3b905edd0d1015dfa3cb7b08c4e9344c4@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

This asks the kernel to setup a ring with 128-byte SQE and
32-byte CQE entries. It may fail with -EINVAL if the kernel
doesn't support this feature. If the kernel does support this
feature, then the ring will support big-sqe/big-cqe entries
which some commands may require.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 os/linux/io_uring.h | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index 42b2fe84..2fa66135 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -60,7 +60,17 @@ struct io_uring_sqe {
 		__s32	splice_fd_in;
 		__u32	file_index;
 	};
-	__u64	__pad2[2];
+	union {
+		struct {
+			__u64	addr3;
+			__u64	__pad2[1];
+		};
+		/*
+		 * If the ring is initialized with IORING_SETUP_SQE128, then
+		 * this field is used for 80 bytes of arbitrary command data
+		 */
+		__u8	cmd[0];
+	};
 };
 
 enum {
@@ -101,6 +111,24 @@ enum {
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
+#define IORING_SETUP_SUBMIT_ALL	(1U << 7)	/* continue submit on error */
+/*
+ * Cooperative task running. When requests complete, they often require
+ * forcing the submitter to transition to the kernel to complete. If this
+ * flag is set, work will be done when the task transitions anyway, rather
+ * than force an inter-processor interrupt reschedule. This avoids interrupting
+ * a task running in userspace, and saves an IPI.
+ */
+#define IORING_SETUP_COOP_TASKRUN	(1U << 8)
+/*
+ * If COOP_TASKRUN is set, get notified if task work is available for
+ * running and a kernel transition would be needed to run it. This sets
+ * IORING_SQ_TASKRUN in the sq ring flags. Not valid with COOP_TASKRUN.
+ */
+#define IORING_SETUP_TASKRUN_FLAG	(1U << 9)
+
+#define IORING_SETUP_SQE128		(1U << 10) /* SQEs are 128 byte */
+#define IORING_SETUP_CQE32		(1U << 11) /* CQEs are 32 byte */
 
 enum {
 	IORING_OP_NOP,
@@ -192,6 +220,12 @@ struct io_uring_cqe {
 	__u64	user_data;	/* sqe->data submission passed back */
 	__s32	res;		/* result code for this event */
 	__u32	flags;
+
+	/*
+	 * If the ring is initialized with IORING_SETUP_CQE32, then this field
+	 * contains 16-bytes of padding, doubling the size of the CQE.
+	 */
+	__u64 big_cqe[];
 };
 
 /*
-- 
2.17.1

