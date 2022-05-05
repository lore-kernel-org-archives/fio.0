Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B26C433EF
	for <fio@archiver.kernel.org>; Thu,  5 May 2022 13:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbiEEOBH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 5 May 2022 10:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238597AbiEEOBG (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 5 May 2022 10:01:06 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9418823159
        for <fio@vger.kernel.org>; Thu,  5 May 2022 06:57:26 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220505135724epoutp02c8d5ee7d3fe5137810121afeb3f5cda7~sOhl74lyV1557715577epoutp02A
        for <fio@vger.kernel.org>; Thu,  5 May 2022 13:57:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220505135724epoutp02c8d5ee7d3fe5137810121afeb3f5cda7~sOhl74lyV1557715577epoutp02A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651759044;
        bh=TKmuVdHOk9heHeFH5Zo1Pnecj4/MVMgfCi/TEWp2iZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQfs93FKYOAdZsssWt+sWVichpDFZcfkESkbQeT4uTp7DP4MlolItQoSRRK7htwC8
         d6HNQJ/MOL97J4S1K2qJL5aMkFa+3Oxjz2kAIDU7bihqXNrut/vPRfb61MxCxtJgbJ
         ymsbj7QgShrwlDrdnPekLyfqKtaFUuCoAsCIZMvk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220505135723epcas5p12744ea0b3b1c105137b3f71614e74731~sOhk1NZ691142511425epcas5p1M;
        Thu,  5 May 2022 13:57:23 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4KvFcw6wMTz4x9Pw; Thu,  5 May
        2022 13:57:20 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AC.2D.09827.0C7D3726; Thu,  5 May 2022 22:57:20 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220505132543epcas5p21198504e47717ff87ec88a1771a6c63d~sOF7_NAwo0945609456epcas5p25;
        Thu,  5 May 2022 13:25:43 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220505132543epsmtrp13ae362cf3a126bb90709d730a3456d2f~sOF79jTU-0694906949epsmtrp1P;
        Thu,  5 May 2022 13:25:43 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-31-6273d7c0a2bc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.B1.08853.750D3726; Thu,  5 May 2022 22:25:43 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220505132543epsmtip26bc6e2cba010d495449dbc2a38bc39cd~sOF7FvXWa0592205922epsmtip2K;
        Thu,  5 May 2022 13:25:42 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com,
        simon.lund@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 2/3] docs: documentation for xnvme ioengine
Date:   Thu,  5 May 2022 18:49:34 +0530
Message-Id: <20220505131935.32076-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220505131935.32076-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsWy7bCmhu6B68VJBhOmmlisufKb3WL13X42
        i4+zXjBbLNy4jMnibvcMdgdWj8tnSz36tqxi9Pi8SS6AOSrbJiM1MSW1SCE1Lzk/JTMv3VbJ
        OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfzqYov7QkVSEj
        v7jEVim1ICWnwKRArzgxt7g0L10vL7XEytDAwMgUqDAhO2PCnruMBZ+MKm4dvMjUwPhZo4uR
        k0NCwETi2PJFrF2MXBxCArsZJbqfT2WGcD4xSjy7tJsFwvnGKDFj4iZGmJZ1G86wQST2Mko0
        fH3KDuG0Mkmc2L2MDaSKTUBb4tXbG8wgtoiAsMT+jlYWEJtZoFBi651+sEnCAtYS7fvOMoHY
        LAKqEqda24EGcXDwCthIzHkeCLFMXmL1hgNgYzgFbCWeHFsIdpGEwCp2iSNnzrCC1EsIuEhc
        7faGqBeWeHV8CzuELSXxsr8Nys6WaHz0lw3CLpHYeWs7M4RtL3Fxz18mkDHMApoS63fpQ4Rl
        JaaeWscEcTGfRO/vJ0wQcV6JHfNgbFWJv/dus0DY0hI3312Fsj0k+hf+Z4IEyQRGiakPGlkm
        MMrNQlixgJFxFaNkakFxbnpqsWmBUV5qOTzSkvNzNzGCE5WW1w7Ghw8+6B1iZOJgPMQowcGs
        JMLrvLQgSYg3JbGyKrUoP76oNCe1+BCjKTD4JjJLiSbnA1NlXkm8oYmlgYmZmZmJpbGZoZI4
        7+n0DYlCAumJJanZqakFqUUwfUwcnFINTFZOqZ0B0xcJ9d3yv+gsE1ssNpXZR83ua8YbCR6r
        /pJDaRtmvJvltj7yt9tLK8lr7o2Ra+YZsNbcU157fkbJBuUfN5eLeYTIrOWuL/kXNGfFR+X/
        JhHbBXTubb/CrnkwaptxQstLDb4WgdRda995f/30Pp2pU5X/v4IAQ0Gw/GrrJK+7bQmbV142
        CW2P4dy0Z3/FX/skO7eCN9sTb8RamZaGFTn3JCheTr3mucbBPGxpZ/aWiTvCr8y18mZg37DX
        pjb+su7pFfcOe1nL6/84q6gzR3TWtAWxGmpVC7yUxb9u1DbgtrW4WPhLrj9xy+tTFim5hV7G
        a1n4+77Yp1avT9wmzTjpm3vo2nn7D1YosRRnJBpqMRcVJwIAFFVvi90DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42LZdlhJXjf8QnGSQc8HU4s1V36zW6y+289m
        8XHWC2aLhRuXMVnc7Z7B7sDqcflsqUffllWMHp83yQUwR3HZpKTmZJalFunbJXBlTNhzl7Hg
        k1HFrYMXmRoYP2t0MXJySAiYSKzbcIati5GLQ0hgN6PEhrfPmboYOYAS0hIL1ydC1AhLrPz3
        nB2ipplJYtaN26wgCTYBbYlXb28wg9giQEX7O1pZQGxmgVKJpo+r2EBsYQFrifZ9Z5lAbBYB
        VYlTre3sIPN5BWwk5jwPhJgvL7F6wwGwMZwCthJPji0EGyMEVHK25wTzBEa+BYwMqxglUwuK
        c9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxggNJS3MH4/ZVH/QOMTJxMB5ilOBgVhLhdV5akCTE
        m5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QDU6vSxcecPmKs
        twVU2PtvueR/ZLS9plTYm/w/ZNruc16y2y6mK9kxTLI8Lvp6tnXjnfSZ4ctyOw7Jle1+9Of5
        Lee3U5xrrhuHJZXGBrurX993VdLXRiPuyIrXNyoVzt1yz8yvldFq4lt378dR15mKLHwbGNN2
        ntwllsHx6s2qYxafL32+2NLN7uR0qaDwtcj53eV1V2SPLijfqbfZ5Su7zCLTmiXzj53bescr
        4J5JpFI/g/valo1Pmtpu/9Eve61wMPDx3nDVXdkLOU7l/O/crvfE3HDF5u0ulzi2XznFNrd8
        YVjE1iWLFFt7th3RZ5mvylSxvEvlPjsj805GL0vbtzcPrdn7zN91mvizvA1uJ5VYijMSDbWY
        i4oTAZy7Vq6TAgAA
X-CMS-MailID: 20220505132543epcas5p21198504e47717ff87ec88a1771a6c63d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220505132543epcas5p21198504e47717ff87ec88a1771a6c63d
References: <20220505131935.32076-1-ankit.kumar@samsung.com>
        <CGME20220505132543epcas5p21198504e47717ff87ec88a1771a6c63d@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 51 ++++++++++++++++++++++++++++++++++++++++--
 fio.1     | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 114 insertions(+), 4 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 6a3e09f5..187f9ab1 100644
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
@@ -2725,6 +2731,47 @@ with the caveat that when used on the command line, they must come after the
 
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
 I/O depth
 ~~~~~~~~~
 
diff --git a/fio.1 b/fio.1
index 609947dc..909bf7e2 100644
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
@@ -2480,6 +2486,63 @@ Defines the time between the SIGTERM and SIGKILL signals. Default is 1 second.
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
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
-- 
2.17.1

