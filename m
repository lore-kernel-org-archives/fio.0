Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D656C4332F
	for <fio@archiver.kernel.org>; Thu, 22 Dec 2022 04:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbiLVEs2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 21 Dec 2022 23:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234933AbiLVEsX (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Dec 2022 23:48:23 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94841AF28
        for <fio@vger.kernel.org>; Wed, 21 Dec 2022 20:48:21 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221222044819epoutp017ffc6fc1926a1730cc1ad7c94019ea19~zBDICUfDr2135021350epoutp01f
        for <fio@vger.kernel.org>; Thu, 22 Dec 2022 04:48:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221222044819epoutp017ffc6fc1926a1730cc1ad7c94019ea19~zBDICUfDr2135021350epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1671684499;
        bh=nUaPbGHP3A0MnmyxyHf6yjR2QG5hPdd7OQygMsGv4lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0+ZgoHCRxwOLoeuy8r8NjIeacl90OMY9EemD64bFUBuBZ7R3hWMl87cqCnO/yw0B
         awKN5y66HTb3GS1YyXqHNpQiHF1yWZEl9BarD64sRmlmleAlU5QAu52pPcPL3hFnA/
         aGDEHuMj2RlMRYKil7RbQneS2Cj68gOqA78WOrMM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221222044819epcas5p42815923144814d417528f38cff270f8f~zBDHm55Pa2338023380epcas5p4h;
        Thu, 22 Dec 2022 04:48:19 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4NcyVn4qJvz4x9Q6; Thu, 22 Dec
        2022 04:48:17 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2A.A8.03362.191E3A36; Thu, 22 Dec 2022 13:48:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221222044044epcas5p28ae5bcdf96a63e6440eeaa191438b293~zA8gYFPk21093810938epcas5p2a;
        Thu, 22 Dec 2022 04:40:44 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221222044044epsmtrp2fd27e10b7800bdcf7f28d5283ad817c0~zA8gXWxf20798207982epsmtrp2T;
        Thu, 22 Dec 2022 04:40:44 +0000 (GMT)
X-AuditID: b6c32a4b-4e5fa70000010d22-35-63a3e19195a0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        99.12.10542.CCFD3A36; Thu, 22 Dec 2022 13:40:44 +0900 (KST)
Received: from green.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221222044043epsmtip13f20408f9d9d361ebc5b02200c1ea87b~zA8fcLCaQ0421704217epsmtip1U;
        Thu, 22 Dec 2022 04:40:43 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com, simon.lund@samsung.com,
        m.ynddal@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 4/4] engines/xnvme: add support for picking mem backend
Date:   Thu, 22 Dec 2022 10:09:51 +0530
Message-Id: <20221222043951.24590-5-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221222043951.24590-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsWy7bCmuu7Eh4uTDZZ081qsufKb3WL13X42
        i4+zXjBbTPrVyGhxt3sGu8WGNkEHNo+ds+6ye1w+W+rRt2UVo8fnTXIBLFHZNhmpiSmpRQqp
        ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAq5UUyhJzSoFCAYnFxUr6
        djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWleel6eaklVoYGBkamQIUJ2RnvmltYCq5IV8x6
        fI2tgXG5WBcjJ4eEgInE/xmtLF2MXBxCArsZJX6fvMoO4XxilDh+ex6U85lR4saTiawwLTd7
        rjJCJHYBtUyYyAySEBJoYpI40mYKYrMJaEu8ensDLC4iICyxvwNiB7NAM6PEmotrWEASwgLu
        ElP+NbCD2CwCqhL3D20Ci/MK2Ej0nrnGBrFNXmL1hgNggzgFbCWmL7kANkhCYB+7xMnv/5kg
        ilwkmu8/Y4ewhSVeHd8CZUtJfH63F2pQtsSmhz+h6gskjrzoZYaw7SVaT/UD2RxA12lKrN+l
        DxGWlZh6ah1YObMAn0Tv7ydQrbwSO+bB2KoSf+/dZoGwpSVuvrsKZXtIzF/wgAkSQhMYJXb8
        mco+gVFuFsKKBYyMqxglUwuKc9NTi00LjPNSy+HRlpyfu4kRnL60vHcwPnrwQe8QIxMH4yFG
        CQ5mJRHeSxcWJwvxpiRWVqUW5ccXleakFh9iNAUG4ERmKdHkfGACzSuJNzSxNDAxMzMzsTQ2
        M1QS503dOj9ZSCA9sSQ1OzW1ILUIpo+Jg1OqgWnTx8TsfvVrf+fuj+V/1nH3wO/SJYu7uFas
        Etqz3OlTd9CPbfFip55HbygRluyQ4t7zrGSJkoTV8nl8hoqfBGdOytgbfOH7pjnn1k6a/tBX
        LtDWdwrDykua9bIf2XLlM8zm+TNdkqxItdr7I0knKGq3WlC1U3lRy6xnpm+ebnx8P7tV3Xq/
        S+PV/Wbz4v9E1IQs5PTXb/qd4OzXv6ROqi53XYCHsN2Uwm+pk57+8v9346KYeeyPqNA4xpeG
        L7bfv2MiU6t3/8WrBqMDLx6unZm+ejuLwvSGX/w+94uqfq7fv6Wwkrml2b3wvr6B3E9ew6yU
        Szcexe+63Xfv9Tx9xowG09DPLoLqxRJ3pW8FHFRiKc5INNRiLipOBABxzQ5Y6AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42LZdlhJTvfM/cXJBkcaFS3WXPnNbrH6bj+b
        xcdZL5gtJv1qZLS42z2D3WJDm6ADm8fOWXfZPS6fLfXo27KK0ePzJrkAligum5TUnMyy1CJ9
        uwSujHfNLSwFV6QrZj2+xtbAuFysi5GTQ0LAROJmz1XGLkYuDiGBHYwS7Y+PsHQxcgAlpCUW
        rk+EqBGWWPnvOTtETQOTxI6Hd5lAEmwC2hKv3t5gBrFFgIr2d7SygBQxC3QySuz8eQCsSFjA
        XWLKvwZ2EJtFQFXi/qFNLCA2r4CNRO+Za2wQG+QlVm84ADaIU8BWYvqSC2A1QkA1C3a/ZJrA
        yLeAkWEVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZweGlp7WDcs+qD3iFGJg7GQ4wS
        HMxKIryXLixOFuJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNT
        qoFploDjJJu4WZuuvDWOcd8acLyyq2/KjBP7PouENxwqXDD/hkVZzY2jSvkTRD+Ilc3eE5o+
        w0K8efPdVs4FATfUTdes2L6IK3Xr1fRfgoKJV/b3cJ3espSzgfXMq6fzdNjl8lKF5v5/6qxt
        dEzg9IXlXkcW3w07tt1VjXH9y+X8994n8ked1DC5OS2x6023wrQJPYc1L+mE373z4umv9esE
        Jns/kapd3L3k9zTVt3zeQhknNl6e9mLr4sC5+9oiHTxPPDZS2T/3U6ja0pTHyke4bHKmSP1Q
        qDIQrayaOkfxaoaC6u5rUS8+n1zG9/n5lcwvxn3x7FE6+c5Guz7bLAsJXffll6xs+1/1ksRv
        hktdHyuxFGckGmoxFxUnAgDpr5UVngIAAA==
X-CMS-MailID: 20221222044044epcas5p28ae5bcdf96a63e6440eeaa191438b293
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221222044044epcas5p28ae5bcdf96a63e6440eeaa191438b293
References: <20221222043951.24590-1-ankit.kumar@samsung.com>
        <CGME20221222044044epcas5p28ae5bcdf96a63e6440eeaa191438b293@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add option to the xnvme fio engine for picking a
memory backend. Update the fio document.

Signed-off-by: Mads Ynddal <m.ynddal@samsung.com>
Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst       | 17 +++++++++++++++++
 engines/xnvme.c | 11 +++++++++++
 fio.1           | 22 ++++++++++++++++++++++
 3 files changed, 50 insertions(+)

diff --git a/HOWTO.rst b/HOWTO.rst
index 0fec38a7..0a48a453 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2885,6 +2885,23 @@ with the caveat that when used on the command line, they must come after the
 	Sets the subsystem NQN for fabrics. This is for xNVMe to utilize a
 	fabrics target with multiple systems.
 
+.. option:: xnvme_mem=str : [xnvme]
+
+	Select the xnvme memory backend. This can take these values.
+
+	**posix**
+		This is the default posix memory backend for linux NVMe driver.
+	**hugepage**
+		Use hugepages, instead of existing posix memory backend. The
+		memory backend uses hugetlbfs. This require users to allocate
+		hugepages, mount hugetlbfs and set an enviornment variable for
+		XNVME_HUGETLB_PATH.
+	**spdk**
+		Uses SPDK's memory allocator.
+	**vfio**
+		Uses libvfn's memory allocator. This also specifies the use
+		of libvfn backend instead of SPDK.
+
 .. option:: xnvme_iovec=int : [xnvme]
 
 	If this option is set. xnvme will use vectored read/write commands.
diff --git a/engines/xnvme.c b/engines/xnvme.c
index 208d917d..bb92a121 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -75,6 +75,7 @@ struct xnvme_fioe_options {
 	unsigned int xnvme_dev_nsid;
 	unsigned int xnvme_iovec;
 	char *xnvme_be;
+	char *xnvme_mem;
 	char *xnvme_async;
 	char *xnvme_sync;
 	char *xnvme_admin;
@@ -109,6 +110,15 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group = FIO_OPT_G_XNVME,
 	},
+	{
+		.name = "xnvme_mem",
+		.lname = "xNVMe Memory Backend",
+		.type = FIO_OPT_STR_STORE,
+		.off1 = offsetof(struct xnvme_fioe_options, xnvme_mem),
+		.help = "Select xNVMe memory backend",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_XNVME,
+	},
 	{
 		.name = "xnvme_async",
 		.lname = "xNVMe Asynchronous command-interface",
@@ -193,6 +203,7 @@ static struct xnvme_opts xnvme_opts_from_fioe(struct thread_data *td)
 	opts.nsid = o->xnvme_dev_nsid;
 	opts.subnqn = o->xnvme_dev_subnqn;
 	opts.be = o->xnvme_be;
+	opts.mem = o->xnvme_mem;
 	opts.async = o->xnvme_async;
 	opts.sync = o->xnvme_sync;
 	opts.admin = o->xnvme_admin;
diff --git a/fio.1 b/fio.1
index 134aed54..eb87533f 100644
--- a/fio.1
+++ b/fio.1
@@ -2631,6 +2631,28 @@ xnvme namespace identifier for userspace NVMe driver SPDK or vfio.
 Sets the subsystem NQN for fabrics. This is for xNVMe to utilize a fabrics
 target with multiple systems.
 .TP
+.BI (xnvme)xnvme_mem\fR=\fPstr
+Select the xnvme memory backend. This can take these values.
+.RS
+.RS
+.TP
+.B posix
+This is the default posix memory backend for linux NVMe driver.
+.TP
+.BI hugepage
+Use hugepages, instead of existing posix memory backend. The memory backend
+uses hugetlbfs. This require users to allocate hugepages, mount hugetlbfs and
+set an enviornment variable for XNVME_HUGETLB_PATH.
+.TP
+.BI spdk
+Uses SPDK's memory allocator.
+.TP
+.BI vfio
+Uses libvfn's memory allocator. This also specifies the use of libvfn backend
+instead of SPDK.
+.RE
+.RE
+.TP
 .BI (xnvme)xnvme_iovec
 If this option is set, xnvme will use vectored read/write commands.
 .TP
-- 
2.17.1

