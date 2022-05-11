Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33291C433EF
	for <fio@archiver.kernel.org>; Wed, 11 May 2022 19:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242789AbiEKTMa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 11 May 2022 15:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345016AbiEKTM2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 May 2022 15:12:28 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73B97357A
        for <fio@vger.kernel.org>; Wed, 11 May 2022 12:12:25 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220511191219epoutp014081ced50dd027664e2828abbde88cb5~uIsRM4-mX0534405344epoutp01B
        for <fio@vger.kernel.org>; Wed, 11 May 2022 19:12:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220511191219epoutp014081ced50dd027664e2828abbde88cb5~uIsRM4-mX0534405344epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652296339;
        bh=IF11MS+kXdeC7R8jCgEKA6TsQmrIcXIDGPQDbWmt2Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTijOdmi8yDn8EwF7KiF1qRVnhg3LaK6Mv7xR2L3lGUUpKpGDmrvHEeNGrsWCEVQ+
         D73RNQ1BRFPfQGejk/GOioZGgBg0TlMCgDlgcLIwX2q1S5NMrBg7qF0hfUPbLobLIg
         AHTIrdCD2YUwBA3kMLGcj5oEdJ1ufaTF+b9zKFlY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220511191219epcas5p3aa68164fd05c1c71f4ee5f0064378dad~uIsQrFooV0254502545epcas5p3L;
        Wed, 11 May 2022 19:12:19 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Kz4KX4MKrz4x9Pp; Wed, 11 May
        2022 19:12:16 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FF.26.09762.09A0C726; Thu, 12 May 2022 04:12:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220511163558epcas5p4c73dffb818b0dd543d813a480e07daa9~uGjwAFBRw0527805278epcas5p4Z;
        Wed, 11 May 2022 16:35:58 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220511163558epsmtrp19e7651b36a0f90f0b02c418914e349d0~uGjv-e0cX2080420804epsmtrp1C;
        Wed, 11 May 2022 16:35:58 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-3f-627c0a90b8d5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4A.E0.08924.EE5EB726; Thu, 12 May 2022 01:35:58 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220511163557epsmtip25f61f268281eee27f67a517a2719d2e1~uGjvJH3ee3223932239epsmtip2n;
        Wed, 11 May 2022 16:35:57 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com,
        simon.lund@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 2/3] docs: documentation for xnvme ioengine
Date:   Wed, 11 May 2022 22:00:18 +0530
Message-Id: <20220511163019.5608-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220511163019.5608-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsWy7bCmhu4Erpokg+/r5SzWXPnNbrH6bj+b
        xcdZL5gtFm5cxmRxt3sGuwOrx+WzpR59W1YxenzeJBfAHJVtk5GamJJapJCal5yfkpmXbqvk
        HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCR
        X1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnfH71Qr2grMmFUunn2NtYFym1cXI
        ySEhYCLx/voK9i5GLg4hgd2MEvcXPmeFcD4xSiyeeosRwvnMKLFuwT62LkYOsJYNxxwg4rsY
        JR5POcoG4bQySbzr2MkOMpdNQFvi1dsbzCC2iICwxP6OVhYQm1mgUGLrnX5GEFtYwFqifd9Z
        JhCbRUBV4sCRPrBeXqD47DP3mCDuk5dYveEA2BxOARuJ3uaVzCDLJASWsUts+7GHFaLIReLJ
        hRdsELawxKvjW9ghbCmJl/1tUHa2ROOjv1A1JRI7b21nhrDtJS7u+csE8hmzgKbE+l36EGFZ
        iamn1jFB3Mwn0fv7CdQ9vBI75sHYqhJ/791mgbClJW6+uwple0jMuNrEDAmUfkaJh73NjBMY
        5WYhrFjAyLiKUTK1oDg3PbXYtMA4L7UcHmvJ+bmbGMGpSst7B+OjBx/0DjEycTAeYpTgYFYS
        4d3fV5EkxJuSWFmVWpQfX1Sak1p8iNEUGIATmaVEk/OByTKvJN7QxNLAxMzMzMTS2MxQSZz3
        VPqGRCGB9MSS1OzU1ILUIpg+Jg5OqQamzNs3d8/b4v/m0DIBrbozx9z+qqwTVP2xUeFjUU9y
        5TytLxNkG5LZtpyczvK20e2/ZpOiWeFEyfCGVWnFtbyz01orQ3P2bSjYsZp3zW7Hyc/YxY1T
        39jqrvFdYbxAzNk67UHzdCmXMv7eUzYCPO8FVWUvfl8h+U8pKW+qIvsO/jlJt6o6A7vN7Ftn
        T56r27rufUKCj5nFrueij1dY+UkEOh3Li9rIJ/K2V/vXn2t1068V3/2dGZ8299qJCJHvmxus
        7so5O/wLzVV9tPOkt8pvPqOJCv82rFvPWb7i0uw3bz2CJ96/ZJ+Y88Yi5UhI+LQmtRnFPS+l
        vgo9mCFcH3BdrNBVJOaN3p6+AFOJqTVKLMUZiYZazEXFiQArH9MX3gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42LZdlhJXvfd0+okg2cfeS3WXPnNbrH6bj+b
        xcdZL5gtFm5cxmRxt3sGuwOrx+WzpR59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CV8fvVCvaC
        syYVS6efY21gXKbVxcjBISFgIrHhmEMXIxeHkMAORok/5x6wQcSlJRauT+xi5AQyhSVW/nvO
        DlHTzCRxZfYHNpAEm4C2xKu3N5hBbBGgov0drSwgNrNAqUTTx1VgNcIC1hLt+84ygdgsAqoS
        B470sYPYvEDx2WfuMUEskJdYveEA2BxOARuJ3uaVYLYQUM3pX4vYJzDyLWBkWMUomVpQnJue
        W2xYYJSXWq5XnJhbXJqXrpecn7uJERxIWlo7GPes+qB3iJGJg/EQowQHs5II7/6+iiQh3pTE
        yqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamNZMunqnblra2516
        nesC5/zmbnzDpxXBLpPknfTr5v5X/cHXNYsTF8odMbW10bTlOGuw7hqT1X+NZaX/dt7tag08
        eLDdbOnH6B3K12vKVANN5mwP2WC+/lftrFcWO1p2lLzi5zPKcpNL3rv8vk67VeiZA8VZk/5d
        cf/+jWmCW1vPQ8NTdQIHmxw2LX56yNmRf61zdtjpqkjRW2zB6rsDf29KSZtgtf3Im0S2ogyR
        dg5NpT8r368pNm714tvutb5bs2SNSIT7QZZ7nDM5LGpC5n4MvJbgwGKxTsSlsvxCyvHTH9wm
        NW7eJ5j0wuhQxlfW3QFeBeZ3zaUT4ybkLJ/ce+vyhPCk/w6Pbd7/uc83T4mlOCPRUIu5qDgR
        AIwddluTAgAA
X-CMS-MailID: 20220511163558epcas5p4c73dffb818b0dd543d813a480e07daa9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220511163558epcas5p4c73dffb818b0dd543d813a480e07daa9
References: <20220511163019.5608-1-ankit.kumar@samsung.com>
        <CGME20220511163558epcas5p4c73dffb818b0dd543d813a480e07daa9@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 55 +++++++++++++++++++++++++++++++++++++++++--
 fio.1     | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 121 insertions(+), 4 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 6a3e09f5..84bea5c5 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2171,6 +2171,12 @@ I/O engine
 		**exec**
 			Execute 3rd party tools. Could be used to perform monitoring during jobs runtime.
 
+		**xnvme**
+			I/O engine using the xNVMe C API, for NVMe devices. The xnvme engine provides
+			flexibility to access GNU/Linux Kernel NVMe driver via libaio, IOCTLs, io_uring,
+			the SPDK NVMe driver, or your own custom NVMe driver. The xnvme engine includes
+			engine specific options. (See https://xnvme.io).
+
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -2260,7 +2266,7 @@ with the caveat that when used on the command line, they must come after the
 	making the submission and completion part more lightweight. Required
 	for the below :option:`sqthread_poll` option.
 
-.. option:: sqthread_poll : [io_uring]
+.. option:: sqthread_poll : [io_uring] [xnvme]
 
 	Normally fio will submit IO by issuing a system call to notify the
 	kernel of available items in the SQ ring. If this option is set, the
@@ -2275,7 +2281,7 @@ with the caveat that when used on the command line, they must come after the
 
 .. option:: hipri
 
-   [io_uring]
+   [io_uring], [xnvme]
 
         If this option is set, fio will attempt to use polled IO completions.
         Normal IO completions generate interrupts to signal the completion of
@@ -2725,6 +2731,51 @@ with the caveat that when used on the command line, they must come after the
 
 	If set, stdout and stderr streams are redirected to files named from the job name. Default is true.
 
+.. option:: xnvme_async=str : [xnvme]
+
+	Select the xnvme async command interface. This can take these values.
+
+	**emu**
+		This is default and used to emulate asynchronous I/O.
+	**thrpool**
+		Use thread pool for Asynchronous I/O.
+	**io_uring**
+		Use Linux io_uring/liburing for Asynchronous I/O.
+	**libaio**
+		Use Linux aio for Asynchronous I/O.
+	**posix**
+		Use POSIX aio for Asynchronous I/O.
+	**nil**
+		Use nil-io; For introspective perf. evaluation
+
+.. option:: xnvme_sync=str : [xnvme]
+
+	Select the xnvme synchronous command interface. This can take these values.
+
+	**nvme**
+		This is default and uses Linux NVMe Driver ioctl() for synchronous I/O.
+	**psync**
+		Use pread()/write() for synchronous I/O.
+
+.. option:: xnvme_admin=str : [xnvme]
+
+	Select the xnvme admin command interface. This can take these values.
+
+	**nvme**
+		This is default and uses linux NVMe Driver ioctl() for admin commands.
+	**block**
+		Use Linux Block Layer ioctl() and sysfs for admin commands.
+	**file_as_ns**
+		Use file-stat to construct NVMe idfy responses.
+
+.. option:: xnvme_dev_nsid=int : [xnvme]
+
+	xnvme namespace identifier, for userspace NVMe driver.
+
+.. option:: xnvme_iovec=int : [xnvme]
+
+	If this option is set. xnvme will use vectored read/write commands.
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/fio.1 b/fio.1
index 609947dc..ded7bbfc 100644
--- a/fio.1
+++ b/fio.1
@@ -1965,6 +1965,12 @@ via kernel NFS.
 .TP
 .B exec
 Execute 3rd party tools. Could be used to perform monitoring during jobs runtime.
+.TP
+.B xnvme
+I/O engine using the xNVMe C API, for NVMe devices. The xnvme engine provides
+flexibility to access GNU/Linux Kernel NVMe driver via libaio, IOCTLs, io_uring,
+the SPDK NVMe driver, or your own custom NVMe driver. The xnvme engine includes
+engine specific options. (See \fIhttps://xnvme.io/\fR).
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
@@ -2039,7 +2045,7 @@ release them when IO is done. If this option is set, the pages are pre-mapped
 before IO is started. This eliminates the need to map and release for each IO.
 This is more efficient, and reduces the IO latency as well.
 .TP
-.BI (io_uring)hipri
+.BI (io_uring,xnvme)hipri
 If this option is set, fio will attempt to use polled IO completions. Normal IO
 completions generate interrupts to signal the completion of IO, polled
 completions do not. Hence they are require active reaping by the application.
@@ -2052,7 +2058,7 @@ This avoids the overhead of managing file counts in the kernel, making the
 submission and completion part more lightweight. Required for the below
 sqthread_poll option.
 .TP
-.BI (io_uring)sqthread_poll
+.BI (io_uring,xnvme)sqthread_poll
 Normally fio will submit IO by issuing a system call to notify the kernel of
 available items in the SQ ring. If this option is set, the act of submitting IO
 will be done by a polling thread in the kernel. This frees up cycles for fio, at
@@ -2480,6 +2486,66 @@ Defines the time between the SIGTERM and SIGKILL signals. Default is 1 second.
 .TP
 .BI (exec)std_redirect\fR=\fbool
 If set, stdout and stderr streams are redirected to files named from the job name. Default is true.
+.TP
+.BI (xnvme)xnvme_async\fR=\fPstr
+Select the xnvme async command interface. This can take these values.
+.RS
+.RS
+.TP
+.B emu
+This is default and used to emulate asynchronous I/O
+.TP
+.BI thrpool
+Use thread pool for Asynchronous I/O
+.TP
+.BI io_uring
+Use Linux io_uring/liburing for Asynchronous I/O
+.TP
+.BI libaio
+Use Linux aio for Asynchronous I/O
+.TP
+.BI posix
+Use POSIX aio for Asynchronous I/O
+.TP
+.BI nil
+Use nil-io; For introspective perf. evaluation
+.RE
+.RE
+.TP
+.BI (xnvme)xnvme_sync\fR=\fPstr
+Select the xnvme synchronous command interface. This can take these values.
+.RS
+.RS
+.TP
+.B nvme
+This is default and uses Linux NVMe Driver ioctl() for synchronous I/O
+.TP
+.BI psync
+Use pread()/write() for synchronous I/O
+.RE
+.RE
+.TP
+.BI (xnvme)xnvme_admin\fR=\fPstr
+Select the xnvme admin command interface. This can take these values.
+.RS
+.RS
+.TP
+.B nvme
+This is default and uses Linux NVMe Driver ioctl() for admin commands
+.TP
+.BI block
+Use Linux Block Layer ioctl() and sysfs for admin commands
+.TP
+.BI file_as_ns
+Use file-stat as to construct NVMe idfy responses
+.RE
+.RE
+.TP
+.BI (xnvme)xnvme_dev_nsid\fR=\fPint
+xnvme namespace identifier, for userspace NVMe driver.
+.TP
+.BI (xnvme)xnvme_iovec
+If this option is set, xnvme will use vectored read/write commands.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
-- 
2.17.1

