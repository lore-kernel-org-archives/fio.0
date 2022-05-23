Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91EBC433F5
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 16:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238806AbiEWQ3E (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 12:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238797AbiEWQ3C (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 12:29:02 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5DC5DA08
        for <fio@vger.kernel.org>; Mon, 23 May 2022 09:29:01 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220523162856epoutp04edf74b8a1a2d92d0528fd76e64609b11~xyNCD0uDu1033610336epoutp04J
        for <fio@vger.kernel.org>; Mon, 23 May 2022 16:28:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220523162856epoutp04edf74b8a1a2d92d0528fd76e64609b11~xyNCD0uDu1033610336epoutp04J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653323336;
        bh=1cfQnN87dhNTBBaO4S7MyFD0zkF4e9nDnwpFIdNaFgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1ulQojmAEuKZHGcy7PoGaU+qLBo+xQtwwOTvkYSOAXbF1ltKg9chOQyGfX4Za/pe
         wkHryGVqbI445b9BSLs6lY+ljN3FGhQ4nxnx4Y71hOU7F4uztAvb3IsLaNtWG/ETpd
         muC+pIxDSN34iU/d6gxMun+Jabp4jbW6bLiPJD4M=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220523162854epcas5p1acf951b9ddf5e4d7de9f50f826274601~xyNA8pl0b1532115321epcas5p1U;
        Mon, 23 May 2022 16:28:54 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4L6N7R6x84z4x9Ps; Mon, 23 May
        2022 16:28:51 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7B.DE.09762.346BB826; Tue, 24 May 2022 01:28:51 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220523131616epcas5p1a1779b1fdcf24631eea353d97757f063~xvk0ibRT73077130771epcas5p18;
        Mon, 23 May 2022 13:16:16 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220523131616epsmtrp18797490700ea11cac19792b51528a97d~xvk0hzB9l2128021280epsmtrp1v;
        Mon, 23 May 2022 13:16:16 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-16-628bb643a3fa
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        70.E2.11276.0298B826; Mon, 23 May 2022 22:16:16 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220523131615epsmtip2cc9d404d72ee42c37a5d272b341c884b~xvkzokxwK1064510645epsmtip2d;
        Mon, 23 May 2022 13:16:15 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com
Subject: [PATCH 2/7] io_uring.h: add IORING_SETUP_SQE128 and
 IORING_SETUP_CQE32
Date:   Mon, 23 May 2022 18:40:34 +0530
Message-Id: <20220523131039.17697-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220523131039.17697-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsWy7bCmuq7ztu4kg0mHTC2aJvxltlh9t5/N
        4uOsF8wWR/+/ZbNYuHEZkwOrx+WzpR59W1YxenzeJBfAHJVtk5GamJJapJCal5yfkpmXbqvk
        HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCR
        X1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnbGi7zZTwW/hit1nzjE2MD7n72Lk
        5JAQMJH4s3c3C4gtJLCbUeJLl0cXIxeQ/YlR4m/rdzYI5xujxMfeo2wwHfvnfmKGSOxllJg1
        7zQrhNPKJNE8aTPYLDYBbYlXb28wg9giAsIS+ztaweLMArESz7c1MIHYwgKBEo8P7QazWQRU
        JR7fu8oIYvMK2Eh823ydEWKbvMTqDQfA5nAK2Erc+fAPbLOEwCp2iZMXXwBt5gByXCRe3+GC
        qBeWeHV8CzuELSXxsr8Nys6WaHz0F+qDEomdt7YzQ9j2Ehf3/GUCGcMsoCmxfpc+RFhWYuqp
        dUwQJ/NJ9P5+wgQR55XYMQ/GVpX4e+82C4QtLXHz3VUo20Oi9ed7aABNYJT4vH4f0wRGuVkI
        KxYwMq5ilEwtKM5NTy02LTDOSy2HR1pyfu4mRnCi0vLewfjowQe9Q4xMHIyHGCU4mJVEeLcn
        diQJ8aYkVlalFuXHF5XmpBYfYjQFht9EZinR5HxgqswriTc0sTQwMTMzM7E0NjNUEucV+N+Y
        JCSQnliSmp2aWpBaBNPHxMEp1cB0x/BlEt+TNa8M2la/fHz9dP6etK9Vvk2KskU3n8/abqE6
        Z8dOZa2lL3v3POyxmcnIfKNPn/dpQlhh635/mRUTS6fErBFl13kntPBt5+/Uezt/9LtPervg
        05L/IukvLCv+TWX0PdP+5dsukyOhk29O5F0XHC5v/1fkkUjrhvOt+2MqjK7oTCv4F/vDZ/kB
        ldjnZYpt07rTRfdLlQYa3am6abY5r+pp4KIYAaOM11NPVD5be703/k/+ynu7E6sLymSk3K6s
        fjqN9XnO8xqRdTM692c+Y55dnh3SsXWSlqGRS2vI/+IvTHtlvy/f7qz1LqV7pWd3hnJZwO0w
        7fblP+/On+Az9dmzBGut9MW/cpx9lViKMxINtZiLihMBtNKnJd0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42LZdlhJXlehszvJ4GijikXThL/MFqvv9rNZ
        fJz1gtni6P+3bBYLNy5jcmD1uHy21KNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgyVvTdZir4
        LVyx+8w5xgbG5/xdjJwcEgImEvvnfmLuYuTiEBLYzSjR+HgRUxcjB1BCWmLh+kSIGmGJlf+e
        s0PUNDNJXLo2hRUkwSagLfHq7Q1mEFsEqGh/RysLiM0skCixY9IuRhBbWMBfYt+lm+wgNouA
        qsTje1fB4rwCNhLfNl9nhFggL7F6wwGwOZwCthJ3PvxjBrlBCKhmx4+QCYx8CxgZVjFKphYU
        56bnFhsWGOallusVJ+YWl+al6yXn525iBAeSluYOxu2rPugdYmTiYDzEKMHBrCTCuz2xI0mI
        NyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGJtvK+BC+ZdtP
        aR6xLexV/qhionVG8H6QDMs6xU8dTHaN8QXNp2IPdJjfD1jRPYvLR1tUZ9eutPWC1Z+y1rQo
        iAanPczv/qqu0Ln+xeHW6Ma9005d+bXiwyrfJsMzdzZ1PTvW6VXltkMxKF0v5OQZv6L08AO+
        Uz379LXfbdTnY078/lPaQ69PWTuZTevanJo/M9Ttwv694S9dmNIo2/OwJ2y9QVFj+/aIWRzr
        zZvXcsyd5FyqYLRC7KpFqBrvM/ldU/wjL0RIyQko9Uxdq/Rk07LQDyJ8E5rWZE+q4dYUrToc
        9zq7p/5RuXSypEOAxhT2S2+P9EV0GOoLhd1bYe9Ust3402eb+/tzJT4duqrEUpyRaKjFXFSc
        CABY77iikwIAAA==
X-CMS-MailID: 20220523131616epcas5p1a1779b1fdcf24631eea353d97757f063
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220523131616epcas5p1a1779b1fdcf24631eea353d97757f063
References: <20220523131039.17697-1-ankit.kumar@samsung.com>
        <CGME20220523131616epcas5p1a1779b1fdcf24631eea353d97757f063@epcas5p1.samsung.com>
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

