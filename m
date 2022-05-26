Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D87AC433EF
	for <fio@archiver.kernel.org>; Thu, 26 May 2022 16:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346876AbiEZQsa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 26 May 2022 12:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347535AbiEZQs3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 May 2022 12:48:29 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507305AA57
        for <fio@vger.kernel.org>; Thu, 26 May 2022 09:48:28 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220526164826epoutp032d3ea53219c92a38409fb939d7670049~ytZ67phPj0544805448epoutp03f
        for <fio@vger.kernel.org>; Thu, 26 May 2022 16:48:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220526164826epoutp032d3ea53219c92a38409fb939d7670049~ytZ67phPj0544805448epoutp03f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653583706;
        bh=fpa39xt0qgPH6fPU1oRP7u8iBV/8sqpX5nWQj6UNSFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLc3CyKmy8kou6vNiInytUn1L7WrwL6rWgJYEcK4dyP7O4SETDF1gV0qJagRQfTTo
         OJuOQnUH3deAfWZh3Ajmf9dUe/7uKXTqWdJJ4op8Z/UN/Pyu3Ds8Dmvc8mHiRt3E+7
         Orm9TysQQAc14R/Sq9JmMSpi3kJNXZPkXA7hW7I4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220526164825epcas5p101b4c5f5dd5134882990a27d843f6aac~ytZ58wZ-V1652716527epcas5p1w;
        Thu, 26 May 2022 16:48:25 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4L8DQY6SDnz4x9Pv; Thu, 26 May
        2022 16:48:21 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        37.BC.10063.55FAF826; Fri, 27 May 2022 01:48:21 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220526145403epcas5p4add1a5a36f1ce8c5472c3d31f1c785b0~yr2DAVMEB1170711707epcas5p4D;
        Thu, 26 May 2022 14:54:03 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220526145403epsmtrp17cd758913e4e7d03cc2e4bdf72797293~yr2C-prhQ0379103791epsmtrp1Y;
        Thu, 26 May 2022 14:54:03 +0000 (GMT)
X-AuditID: b6c32a49-4cbff7000000274f-d6-628faf55c941
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B5.93.11276.B849F826; Thu, 26 May 2022 23:54:03 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220526145402epsmtip20500f5e18d8405509c555f6e22f242cb~yr2B-hmVr1809018090epsmtip2G;
        Thu, 26 May 2022 14:54:02 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 5/8] docs: document options for io_uring_cmd I/O engine
Date:   Thu, 26 May 2022 20:18:06 +0530
Message-Id: <20220526144809.14877-6-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220526144809.14877-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7bCmlm7o+v4kg1mLDC3WXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8XCjcuYHNg8Lp8t9ejbsorR4/MmuQDmqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjJsHLrAX3DWuOPFiB3sD
        4wnNLkZODgkBE4knv/sYuxi5OIQEdjNK9G86zgaSEBL4xCix/J0VROIbo8TPxi5mmI69+79D
        dexllPj1ZhMThNPKJLH78TN2kCo2AW2JV29vgHWICAhL7O9oZQEpYhZoYZRoXL2WBSQhLOAl
        ceH1GbAiFgFViUUPt4I18wrYSHy7BVEjISAvsXrDAbAaTgFbiXO3Z7CBDJIQ2MQu8b21Geom
        F4nrMx+xQtjCEq+Ob2GHsKUkXva3QdnZEo2P/rJB2CUSO29th+q1l7i45y/QCxxA12lKrN+l
        DxGWlZh6ah0TiM0swCfR+/sJE0ScV2LHPBhbVeLvvdtQd0pL3Hx3Fcr2kPi8vYEVEioTGCXe
        721hmcAoNwthxQJGxlWMkqkFxbnpqcWmBYZ5qeXwaEvOz93ECE5bWp47GO8++KB3iJGJg/EQ
        owQHs5II74WnvUlCvCmJlVWpRfnxRaU5qcWHGE2BATiRWUo0OR+YOPNK4g1NLA1MzMzMTCyN
        zQyVxHkF/jcmCQmkJ5akZqemFqQWwfQxcXBKNTCtSG2IVdij76Aj/PrzJbtFi1T3/LwhdjJd
        4LZC7tTPyqEqcvPKTF4EGYr43nGtPiv011490/q2sm25XXHf2twVG37Oin2uuTrsUeud1t2t
        f3QiGVzmHp+idElxOluWjyvH/7shazr22v5sXPznq33C6kbZ/5MmvrPklAqVe+B+wZfneuiS
        xvjjmswPA10ussZniGi+E4hLMexc80z0lwi/2t4H9XavVhhMSpHLfvvzUOZnFs7md/5Mbdl8
        K0X7olgYZVrl/CrTNl3a8Ml5KUu4ZEzcwRMer5qLxR2KHfdJb269/eRiyZW+0tUPN96xvGgi
        rlOdt+H6uRdSc57Zxu5pOul++Rh7hwv7/0cvjymxFGckGmoxFxUnAgBXQoi25AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42LZdlhJXrd7Sn+Swed2Los1V36zWzRN+Mts
        sfpuP5vFx1kvmC2O/n/LZrFw4zImBzaPy2dLPfq2rGL0+LxJLoA5issmJTUnsyy1SN8ugSvj
        5oEL7AV3jStOvNjB3sB4QrOLkZNDQsBEYu/+74wgtpDAbkaJ3X/zuxg5gOLSEgvXJ0KUCEus
        /PecvYuRC6ikmUni1PMdrCAJNgFtiVdvbzCD2CJARfs7WllAipgFuhglejpPMYEkhAW8JC68
        PgNWxCKgKrHo4VZ2EJtXwEbi2621LBAb5CVWbzgAVsMpYCtx7vYMNoiDbCT+7bvINIGRbwEj
        wypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOCg0tLcwbh91Qe9Q4xMHIyHGCU4mJVE
        eC887U0S4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJg1OqgUkr
        aIbfnpe3Eh1jXk3i3swj5FmpoZ7k0Dxtl93fCs28HU7RR4sjraUMf7HqzpoSEG2ruvaC/aSD
        lkmhF45/bFgUfyF581UVzzeGLDJFc8TrNp42YcuataBH/P6fPbkym5Q4Rbk1e5+93SE1a076
        cxmbnvd7uUNfsbJM3T8nyCCjXHJx0JKtHqICYWqVOyUf8qw1qGXfrObG72v4qMVXfVnJip6A
        3Zd+zFzDMHGS7Is/voqsJ3RX1f1Vvxj+n3uN4LNgA/O8M7N0pPfcfeMwP71POstq5gkjF7YD
        S7ZOlbdc7XB5c29u3pv9n6dUyV87ksNzprs+rbNKX5LnXXLSmZcMRYL1M4LvplbMsJFdqcRS
        nJFoqMVcVJwIAEGvVdGZAgAA
X-CMS-MailID: 20220526145403epcas5p4add1a5a36f1ce8c5472c3d31f1c785b0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145403epcas5p4add1a5a36f1ce8c5472c3d31f1c785b0
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145403epcas5p4add1a5a36f1ce8c5472c3d31f1c785b0@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Update documentation with io_uring_cmd I/O engine specific options.
Add missing io_uring I/O engine entry from fio man page.
Update docs with missing io_uring engine specific options.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 39 ++++++++++++++++++++++++++++++---------
 fio.1     | 28 +++++++++++++++++++++++++---
 2 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 84bea5c5..fb06a788 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1948,6 +1948,10 @@ I/O engine
 			for both direct and buffered IO.
 			This engine defines engine specific options.
 
+		**io_uring_cmd**
+			Fast Linux native asynchronous I/O for pass through commands.
+			This engine defines engine specific options.
+
 		**libaio**
 			Linux native asynchronous I/O. Note that Linux may only support
 			queued behavior with non-buffered I/O (set ``direct=1`` or
@@ -2253,20 +2257,32 @@ with the caveat that when used on the command line, they must come after the
 
 .. option:: fixedbufs : [io_uring]
 
-    If fio is asked to do direct IO, then Linux will map pages for each
-    IO call, and release them when IO is done. If this option is set, the
-    pages are pre-mapped before IO is started. This eliminates the need to
-    map and release for each IO. This is more efficient, and reduces the
-    IO latency as well.
+	If fio is asked to do direct IO, then Linux will map pages for each
+	IO call, and release them when IO is done. If this option is set, the
+	pages are pre-mapped before IO is started. This eliminates the need to
+	map and release for each IO. This is more efficient, and reduces the
+	IO latency as well.
+
+.. option:: nonvectored : [io_uring] [io_uring_cmd]
+
+	With this option, fio will use non-vectored read/write commands, where
+	address must contain the address directly.
 
-.. option:: registerfiles : [io_uring]
+.. option:: force_async=int : [io_uring] [io_uring_cmd]
+
+	Normal operation for io_uring is to try and issue an sqe as
+	non-blocking first, and if that fails, execute it in an async manner.
+	With this option set to N, then every N request fio will ask sqe to
+	be issued in an async manner.
+
+.. option:: registerfiles : [io_uring] [io_uring_cmd]
 
 	With this option, fio registers the set of files being used with the
 	kernel. This avoids the overhead of managing file counts in the kernel,
 	making the submission and completion part more lightweight. Required
 	for the below :option:`sqthread_poll` option.
 
-.. option:: sqthread_poll : [io_uring] [xnvme]
+.. option:: sqthread_poll : [io_uring] [io_uring_cmd] [xnvme]
 
 	Normally fio will submit IO by issuing a system call to notify the
 	kernel of available items in the SQ ring. If this option is set, the
@@ -2274,14 +2290,19 @@ with the caveat that when used on the command line, they must come after the
 	This frees up cycles for fio, at the cost of using more CPU in the
 	system.
 
-.. option:: sqthread_poll_cpu : [io_uring]
+.. option:: sqthread_poll_cpu : [io_uring] [io_uring_cmd]
 
 	When :option:`sqthread_poll` is set, this option provides a way to
 	define which CPU should be used for the polling thread.
 
+.. option:: cmd_type=str : [io_uring_cmd]
+
+	Specifies the type of uring passthrough command to be used. Supported
+	value is nvme.
+
 .. option:: hipri
 
-   [io_uring], [xnvme]
+   [io_uring] [xnvme]
 
         If this option is set, fio will attempt to use polled IO completions.
         Normal IO completions generate interrupts to signal the completion of
diff --git a/fio.1 b/fio.1
index ded7bbfc..66d4adbb 100644
--- a/fio.1
+++ b/fio.1
@@ -1738,6 +1738,15 @@ Basic \fBpreadv\fR\|(2) or \fBpwritev\fR\|(2) I/O.
 .B pvsync2
 Basic \fBpreadv2\fR\|(2) or \fBpwritev2\fR\|(2) I/O.
 .TP
+.B io_uring
+Fast Linux native asynchronous I/O. Supports async IO
+for both direct and buffered IO.
+This engine defines engine specific options.
+.TP
+.B io_uring_cmd
+Fast Linux native asynchronous I/O for passthrough commands.
+This engine defines engine specific options.
+.TP
 .B libaio
 Linux native asynchronous I/O. Note that Linux may only support
 queued behavior with non-buffered I/O (set `direct=1' or
@@ -2045,6 +2054,15 @@ release them when IO is done. If this option is set, the pages are pre-mapped
 before IO is started. This eliminates the need to map and release for each IO.
 This is more efficient, and reduces the IO latency as well.
 .TP
+.BI (io_uring,io_uring_cmd)nonvectored
+With this option, fio will use non-vectored read/write commands, where address
+must contain the address directly.
+.TP
+.BI (io_uring,io_uring_cmd)force_async
+Normal operation for io_uring is to try and issue an sqe as non-blocking first,
+and if that fails, execute it in an async manner. With this option set to N,
+then every N request fio will ask sqe to be issued in an async manner.
+.TP
 .BI (io_uring,xnvme)hipri
 If this option is set, fio will attempt to use polled IO completions. Normal IO
 completions generate interrupts to signal the completion of IO, polled
@@ -2052,22 +2070,26 @@ completions do not. Hence they are require active reaping by the application.
 The benefits are more efficient IO for high IOPS scenarios, and lower latencies
 for low queue depth IO.
 .TP
-.BI (io_uring)registerfiles
+.BI (io_uring,io_uring_cmd)registerfiles
 With this option, fio registers the set of files being used with the kernel.
 This avoids the overhead of managing file counts in the kernel, making the
 submission and completion part more lightweight. Required for the below
 sqthread_poll option.
 .TP
-.BI (io_uring,xnvme)sqthread_poll
+.BI (io_uring,io_uring_cmd,xnvme)sqthread_poll
 Normally fio will submit IO by issuing a system call to notify the kernel of
 available items in the SQ ring. If this option is set, the act of submitting IO
 will be done by a polling thread in the kernel. This frees up cycles for fio, at
 the cost of using more CPU in the system.
 .TP
-.BI (io_uring)sqthread_poll_cpu
+.BI (io_uring,io_uring_cmd)sqthread_poll_cpu
 When `sqthread_poll` is set, this option provides a way to define which CPU
 should be used for the polling thread.
 .TP
+.BI (io_uring_cmd)cmd_type \fR=\fPstr
+Specifies the type of uring passthrough command to be used. Supported
+value is nvme.
+.TP
 .BI (libaio)userspace_reap
 Normally, with the libaio engine in use, fio will use the
 \fBio_getevents\fR\|(3) system call to reap newly returned events. With
-- 
2.17.1

