Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7384CC433F5
	for <fio@archiver.kernel.org>; Wed,  1 Jun 2022 09:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351180AbiFAJkm (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 1 Jun 2022 05:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351171AbiFAJkg (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Jun 2022 05:40:36 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8179F4B1E1
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 02:40:30 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220601094028epoutp03da075603f7331b331600bfb205776440~0db_P9PkR1277112771epoutp03i
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 09:40:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220601094028epoutp03da075603f7331b331600bfb205776440~0db_P9PkR1277112771epoutp03i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1654076428;
        bh=jdjE3XE5zdlO0jfxBkLP46aGfug5+RsEIdGE3yokG0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJ7+8K45K15wIoOcEDUe+qrMyqIJjpu186+iSsJ0OHccayr7b0deiKK4tL2PsArL3
         HQ48Si7IUc6prdVhiSLdvWTgJb7Lxij9aJxJ+cLqDXnIjGZDfvu113mKR/OIfhuGbH
         M9+TkxriTnRZ9ae53T+iVeXrVIJPNLC5nTar2Z+A=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220601094027epcas5p1a1457878d2320ea6962288342d89ec3f~0db86yVFn3212532125epcas5p1L;
        Wed,  1 Jun 2022 09:40:27 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LCkdz1wn7z4x9Pw; Wed,  1 Jun
        2022 09:40:23 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7D.B0.09762.00437926; Wed,  1 Jun 2022 18:40:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220531133747epcas5p4a9a89962301b8853ca13ba017546ae38~0NB5BkPQ92608526085epcas5p47;
        Tue, 31 May 2022 13:37:47 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220531133747epsmtrp28ebbd8133a57bd23c7c62febe29eb28b~0NB5A6Ldj0338303383epsmtrp2G;
        Tue, 31 May 2022 13:37:47 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-54-62973400b642
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        39.F4.11276.B2A16926; Tue, 31 May 2022 22:37:47 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220531133746epsmtip2a3dc7836af622ff9a6f311356a33ce93~0NB38LDfA2727927279epsmtip2i;
        Tue, 31 May 2022 13:37:46 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 6/9] docs: document options for io_uring_cmd I/O engine
Date:   Tue, 31 May 2022 19:01:52 +0530
Message-Id: <20220531133155.17493-7-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220531133155.17493-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsWy7bCmli6DyfQkg86JQhZrrvxmt2ia8JfZ
        YvXdfjaLj7NeMFsc/f+WzWLhxmVMDmwel8+WevRtWcXo8XmTXABzVLZNRmpiSmqRQmpecn5K
        Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr6dTVF+
        aUmqQkZ+cYmtUmpBSk6BSYFecWJucWleul5eaomVoYGBkSlQYUJ2xqUfa9kKZlpUbO7xbGBc
        otvFyMkhIWAi0bn0O3sXIxeHkMBuRok/R/YyQTifGCVafiyBynxjlLg+8wA7TMuS3qeMEIm9
        jBI3+96wQDitTBInuq6CVbEJaEu8enuDGcQWERCW2N/RClbELNDCKNG4ei2Qw8EhLOAlMWmD
        LEgNi4CqxL7TrWC9vAI2Em09f1khtslLrN5wAGwOp4CtxLyp61lB5kgIbGKXaP6+E6rIRaL7
        zB4oW1ji1fEtUKdKSXx+t5cNws6WaHz0F8oukdh5azszhG0vcXHPXyaQe5gFNCXW79KHCMtK
        TD21jgnEZhbgk+j9/YQJIs4rsWMejK0q8ffebRYIW1ri5rurULaHxMTuWcyQQJnAKNG+7gXj
        BEa5WQgrFjAyrmKUTC0ozk1PLTYtMM5LLYfHWnJ+7iZGcNLS8t7B+OjBB71DjEwcjIcYJTiY
        lUR4S3ZNTRLiTUmsrEotyo8vKs1JLT7EaAoMwInMUqLJ+cC0mVcSb2hiaWBiZmZmYmlsZqgk
        zivwvzFJSCA9sSQ1OzW1ILUIpo+Jg1OqgWluscU9wzfP3cy5slgn9qZ+Pf5cZ2rRCuuLt7jT
        zT9M/byGvfXbFv4EXw6Rg4s+SxhxvxV4890/4n5ZSI3G92L/70LPa0PmJx/rCPW4VzPppdO/
        EO+jlpPe7pGoPnNsHvOlhsSfP3kt1tVW37XcXXinlvHelyWVWQZXtI7WP00/Y3BAsDfa60ms
        vbVCq6na42OuM50a9vAvdvhg8o9r+8vLPPu1TfwFr2z9VaWVxRt+QsriQlj7ndwQN7eHKQ/c
        HnNLt656fC9rds9sXw1pw29bJzcVuEzr6T7nY9k8b61qdUdzYPrRhWxb+R67TlabLGv5w13q
        Vek+Fe7SV+m6WwVyZ560NnLRNOVpdjZUVWIpzkg01GIuKk4EAKNLG6rjAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42LZdlhJXldbalqSwcI/ShZrrvxmt2ia8JfZ
        YvXdfjaLj7NeMFsc/f+WzWLhxmVMDmwel8+WevRtWcXo8XmTXABzFJdNSmpOZllqkb5dAlfG
        pR9r2QpmWlRs7vFsYFyi28XIySEhYCKxpPcpI4gtJLCbUeLtIbMuRg6guLTEwvWJECXCEiv/
        PWfvYuQCKmlmkti/+hALSIJNQFvi1dsbzCC2CFDR/o5WFpAiZoEuRomezlNMIIOEBbwkJm2Q
        BalhEVCV2He6lR3E5hWwkWjr+csKsUBeYvWGA2BzOAVsJeZNXc8KcY+NxNQXCxgnMPItYGRY
        xSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHFBamjsYt6/6oHeIkYmD8RCjBAezkghv
        ya6pSUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwXYmO
        lo6PfXNbN0FXiP3m7pcJR/6au3Iq2EZFtQe9WqyaFjP3+oLtbd3f5jpahLEFLz5peIyr5pXB
        QqlXO3SWLz4TZKQouGrZN43AG7954uR1o/bkLOm43r11Lu+Sw8Isx/fEHPQQNTps/bte9YVN
        Ve72G/ffL355ku3og5KFXf+nv5zuyKz6KtLwraDjw9SjDYYHrjW7OwZU/8yzNLdzfnJr1f3i
        yjk/pl84+VzVatpURVtV1am7m35pstTu9Dx1JN29UUy66/35BSZy2+W3eOwP2/ht8+MNvhsy
        v5xUbOOS9ljDZK/z7UNV4+SqK/0p90N31McYV8vr5ZhWKB7f/ueJ7nvbDNZoHbFge963SizF
        GYmGWsxFxYkArt6bJZcCAAA=
X-CMS-MailID: 20220531133747epcas5p4a9a89962301b8853ca13ba017546ae38
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220531133747epcas5p4a9a89962301b8853ca13ba017546ae38
References: <20220531133155.17493-1-ankit.kumar@samsung.com>
        <CGME20220531133747epcas5p4a9a89962301b8853ca13ba017546ae38@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Update documentation with io_uring_cmd I/O engine specific options.
Add missing io_uring I/O engine entry from fio man page.
Update docs with missing io_uring engine specific options.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 41 +++++++++++++++++++++++++++++++----------
 fio.1     | 33 ++++++++++++++++++++++++++++-----
 2 files changed, 59 insertions(+), 15 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 8ab3ac4b..28ac2b7c 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1952,6 +1952,10 @@ I/O engine
 			for both direct and buffered IO.
 			This engine defines engine specific options.
 
+		**io_uring_cmd**
+			Fast Linux native asynchronous I/O for pass through commands.
+			This engine defines engine specific options.
+
 		**libaio**
 			Linux native asynchronous I/O. Note that Linux may only support
 			queued behavior with non-buffered I/O (set ``direct=1`` or
@@ -2255,22 +2259,34 @@ with the caveat that when used on the command line, they must come after the
 	values for trim IOs are ignored. This option is mutually exclusive with
 	the :option:`cmdprio_percentage` option.
 
-.. option:: fixedbufs : [io_uring]
+.. option:: fixedbufs : [io_uring] [io_uring_cmd]
+
+	If fio is asked to do direct IO, then Linux will map pages for each
+	IO call, and release them when IO is done. If this option is set, the
+	pages are pre-mapped before IO is started. This eliminates the need to
+	map and release for each IO. This is more efficient, and reduces the
+	IO latency as well.
+
+.. option:: nonvectored : [io_uring] [io_uring_cmd]
 
-    If fio is asked to do direct IO, then Linux will map pages for each
-    IO call, and release them when IO is done. If this option is set, the
-    pages are pre-mapped before IO is started. This eliminates the need to
-    map and release for each IO. This is more efficient, and reduces the
-    IO latency as well.
+	With this option, fio will use non-vectored read/write commands, where
+	address must contain the address directly. Default is -1.
 
-.. option:: registerfiles : [io_uring]
+.. option:: force_async=int : [io_uring] [io_uring_cmd]
+
+	Normal operation for io_uring is to try and issue an sqe as
+	non-blocking first, and if that fails, execute it in an async manner.
+	With this option set to N, then every N request fio will ask sqe to
+	be issued in an async manner. Default is 0.
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
@@ -2278,14 +2294,19 @@ with the caveat that when used on the command line, they must come after the
 	This frees up cycles for fio, at the cost of using more CPU in the
 	system.
 
-.. option:: sqthread_poll_cpu : [io_uring]
+.. option:: sqthread_poll_cpu : [io_uring] [io_uring_cmd]
 
 	When :option:`sqthread_poll` is set, this option provides a way to
 	define which CPU should be used for the polling thread.
 
+.. option:: cmd_type=str : [io_uring_cmd]
+
+	Specifies the type of uring passthrough command to be used. Supported
+	value is nvme. Default is nvme.
+
 .. option:: hipri
 
-   [io_uring], [xnvme]
+   [io_uring] [io_uring_cmd] [xnvme]
 
         If this option is set, fio will attempt to use polled IO completions.
         Normal IO completions generate interrupts to signal the completion of
diff --git a/fio.1 b/fio.1
index bdba3142..948c01f9 100644
--- a/fio.1
+++ b/fio.1
@@ -1739,6 +1739,15 @@ Basic \fBpreadv\fR\|(2) or \fBpwritev\fR\|(2) I/O.
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
@@ -2040,35 +2049,49 @@ for trim IOs are ignored. This option is mutually exclusive with the
 \fBcmdprio_percentage\fR option.
 .RE
 .TP
-.BI (io_uring)fixedbufs
+.BI (io_uring,io_uring_cmd)fixedbufs
 If fio is asked to do direct IO, then Linux will map pages for each IO call, and
 release them when IO is done. If this option is set, the pages are pre-mapped
 before IO is started. This eliminates the need to map and release for each IO.
 This is more efficient, and reduces the IO latency as well.
 .TP
-.BI (io_uring,xnvme)hipri
+.BI (io_uring,io_uring_cmd)nonvectored
+With this option, fio will use non-vectored read/write commands, where address
+must contain the address directly. Default is -1.
+.TP
+.BI (io_uring,io_uring_cmd)force_async
+Normal operation for io_uring is to try and issue an sqe as non-blocking first,
+and if that fails, execute it in an async manner. With this option set to N,
+then every N request fio will ask sqe to be issued in an async manner. Default
+is 0.
+.TP
+.BI (io_uring,io_uring_cmd,xnvme)hipri
 If this option is set, fio will attempt to use polled IO completions. Normal IO
 completions generate interrupts to signal the completion of IO, polled
 completions do not. Hence they are require active reaping by the application.
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
+value is nvme. Default is nvme.
+.TP
 .BI (libaio)userspace_reap
 Normally, with the libaio engine in use, fio will use the
 \fBio_getevents\fR\|(3) system call to reap newly returned events. With
-- 
2.17.1

