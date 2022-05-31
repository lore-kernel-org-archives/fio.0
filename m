Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813A0C433EF
	for <fio@archiver.kernel.org>; Wed,  1 Jun 2022 09:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236901AbiFAJkF (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 1 Jun 2022 05:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351175AbiFAJkD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Jun 2022 05:40:03 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602D843EF0
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 02:40:01 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220601093957epoutp02eb772c40a22df04537eb0fd73fb28a98~0dbhSQvY-2839228392epoutp020
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 09:39:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220601093957epoutp02eb772c40a22df04537eb0fd73fb28a98~0dbhSQvY-2839228392epoutp020
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1654076397;
        bh=1cfQnN87dhNTBBaO4S7MyFD0zkF4e9nDnwpFIdNaFgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HhN/QkfezYylCXRgCuSDsNJjWwZ1Pw8wBw9k7IqUXPEihN0weLqVQJgOIZvHYI7Y2
         WhJRC59j1wDjgW7S79PZ/Dc3BFZqbnG86Sa0W4ePIK4jsIHTz+JkPwSQzgZTegFX/a
         C1SnUyICq9+qL6aNOYqu3hDYNqswMgBWYUuf3XDA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220601093956epcas5p4ba1cd76a10a6f069d35bcd17cd28876b~0dbggbb181720217202epcas5p4G;
        Wed,  1 Jun 2022 09:39:56 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LCkdP4mBHz4x9Q4; Wed,  1 Jun
        2022 09:39:53 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FA.D4.10063.8E337926; Wed,  1 Jun 2022 18:39:52 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220531133740epcas5p1e7c1049ef44fc7d25b78f239f035a29d~0NByawOk11281012810epcas5p1z;
        Tue, 31 May 2022 13:37:40 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220531133740epsmtrp256b628409a547830965ee1a1039312c7~0NByZ9RsF0382803828epsmtrp2V;
        Tue, 31 May 2022 13:37:40 +0000 (GMT)
X-AuditID: b6c32a49-4cbff7000000274f-dd-629733e810ec
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        32.4E.08924.42A16926; Tue, 31 May 2022 22:37:40 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220531133739epsmtip2b21134bed20379c462c6763f036e9886~0NBxfqTkU2552725527epsmtip2-;
        Tue, 31 May 2022 13:37:39 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com
Subject: [PATCH v3 1/9] io_uring.h: add IORING_SETUP_SQE128 and
 IORING_SETUP_CQE32
Date:   Tue, 31 May 2022 19:01:47 +0530
Message-Id: <20220531133155.17493-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220531133155.17493-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsWy7bCmlu4L4+lJBucPGFo0TfjLbLH6bj+b
        xcdZL5gtjv5/y2axcOMyJgdWj8tnSz36tqxi9Pi8SS6AOSrbJiM1MSW1SCE1Lzk/JTMv3VbJ
        OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfzqYov7QkVSEj
        v7jEVim1ICWnwKRArzgxt7g0L10vL7XEytDAwMgUqDAhO2NF322mgt/CFbvPnGNsYHzO38XI
        wSEhYCIx7VxVFyMXh5DAbkaJOT9+sEM4nxgl1v1cwArhfGaUWDhxBXMXIydYx4lzz5khErsY
        JT5eWwDltDJJLLn0nxWkik1AW+LV2xtgHSICwhL7O1pZQGxmgViJ59samEB2CwuESKw5wwYS
        ZhFQlWi4dwQszCtgI3HssDjELnmJ1RsOgE3hFLCVmDd1PStEfBW7xPT+WgjbReLZ4ecsELaw
        xKvjW9ghbCmJz+/2skHY2RKNj/5C2SUSO29th/rFXuLinr9ga5kFNCXW79KHCMtKTD21jgni
        YD6J3t9PmCDivBI75sHYqhJ/792GWistcfPdVSjbQ+LZqXXQEJnAKHHj3m72CYxysxBWLGBk
        XMUomVpQnJueWmxaYJiXWg6PsuT83E2M4CSl5bmD8e6DD3qHGJk4GA8xSnAwK4nwluyamiTE
        m5JYWZValB9fVJqTWnyI0RQYfBOZpUST84FpMq8k3tDE0sDEzMzMxNLYzFBJnFfgf2OSkEB6
        YklqdmpqQWoRTB8TB6dUA9Pq0H/lwnE5ar6p0+b2dm37njjD1qDP6fHMY4mWB47oaH6UuRQl
        9dVr3YKMBWtjN/l1f//D96rkXrnGvqRbdf45ad4Pu2Lnv4o6ONt354nyRUaMrrwsD86nPz9S
        ZCD/eYtAcsJhGaYC1oDW39sn79msns3Wtdf0/5crZy9t/Dd54UrxuR+qjoou6Be4vONcoGpe
        fU/Xuw0FJe8Vr23Q1rRKcqmqvsMTetnt2mWpg3t/ccpfs1tcKnqBTWNxgdVyy/PFy75xdRz1
        urBm5Re/dNWLux9dFP9VuO1ccVriBlHG4JMBbMW3+TgKKnZb/WgJCV8TJ6NSN6G8VEr7ymG5
        2JbH0cfvpU7XOm6/QE7s1nMlluKMREMt5qLiRAB3CaN32wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42LZdlhJXldFalqSwbeNMhZNE/4yW6y+289m
        8XHWC2aLo//fslks3LiMyYHV4/LZUo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKWNF3m6ng
        t3DF7jPnGBsYn/N3MXJySAiYSJw495y5i5GLQ0hgB6PEs9MH2boYOYAS0hIL1ydC1AhLrPz3
        nB2ipplJ4vfli6wgCTYBbYlXb28wg9giQEX7O1pZQGxmgUSJHZN2MYLYwgJBEs17H4PFWQRU
        JRruHWECmc8rYCNx7LA4xHx5idUbDoCN4RSwlZg3dT3YeCGgkqkvFjBOYORbwMiwilEytaA4
        Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOJC0tHYw7ln1Qe8QIxMH4yFGCQ5mJRHekl1Tk4R4
        UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpg0ju8adWsl7M/
        7Gnf9ZV3c9xtw7KErkfZi57eDztXUSj71nHj73f1qd/nTff6JSXe2nnhNnOa+LqWWcJHLbO/
        BnrWr9lXr9i1sSXJa0l6UqqixF+tia7Sh2fEqyz/4yQ4Q9uRVWDTul235C+uyX65WP1rwubg
        A+vOsnFlCGzY1s52Jlb/iNjC61FZ54wmTrGaU5KzxPPJtgUSV7f3X/n2yKdcjYc5ZEfS/Rcl
        gr5qF79MsZ1hbDiBa4u9k+40p/uxwj9N6+VW3dm/TYDXLUGqdepRM4u+155va5f8/PTQ+pFJ
        iKHV2d0VjWIPDebEGTgJrCvuLUvTv113jWX5nWrT9WfDa6VM772xUe8PKPlwW4mlOCPRUIu5
        qDgRAHFtQHWTAgAA
X-CMS-MailID: 20220531133740epcas5p1e7c1049ef44fc7d25b78f239f035a29d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220531133740epcas5p1e7c1049ef44fc7d25b78f239f035a29d
References: <20220531133155.17493-1-ankit.kumar@samsung.com>
        <CGME20220531133740epcas5p1e7c1049ef44fc7d25b78f239f035a29d@epcas5p1.samsung.com>
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

