Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F155C433F5
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 16:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238791AbiEWQ3g (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 12:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238809AbiEWQ3f (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 12:29:35 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06592689B6
        for <fio@vger.kernel.org>; Mon, 23 May 2022 09:29:30 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220523162927epoutp01445565490a1c48ab305c41f70302ff93~xyNfU_Yoa0946809468epoutp01k
        for <fio@vger.kernel.org>; Mon, 23 May 2022 16:29:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220523162927epoutp01445565490a1c48ab305c41f70302ff93~xyNfU_Yoa0946809468epoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653323367;
        bh=Ws79hfofKdzrLuhNSOqXyB19rBDD4PkPMZB7VgTbWTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayhJG/c+BlanYbE+e/hx583ikIcgo72+8Amg0+AIPiBpyzmXfmi8UCp84XBZsidh9
         qpjj9gsbuuG6BksMgWu7ENVIjguySSzuYKfwJzjSHBtY+hdCB7OxYtoqCjhkJi0AJD
         Obc7ATjFiqMq5NnnZ9ycMky1ClReHOpyRs153hTk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220523162926epcas5p16d5d53d4ed221c21081eb006e664edcf~xyNet7FA41532115321epcas5p1k;
        Mon, 23 May 2022 16:29:26 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4L6N84009Yz4x9Pq; Mon, 23 May
        2022 16:29:23 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        60.DF.09827.366BB826; Tue, 24 May 2022 01:29:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220523131629epcas5p4ab9e6158624a4c6a055bb0e410f46079~xvlAMI-lh1988519885epcas5p4X;
        Mon, 23 May 2022 13:16:29 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220523131629epsmtrp125ae42104e68dc9154d628fbd0520636~xvlALf7oY2128021280epsmtrp1-;
        Mon, 23 May 2022 13:16:29 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-cb-628bb6634589
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        84.E2.11276.D298B826; Mon, 23 May 2022 22:16:29 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220523131628epsmtip2c9acdd18fc15631879996027966313f3~xvk-NU-Je1953719537epsmtip25;
        Mon, 23 May 2022 13:16:28 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 7/7] examples: add 2 example job file for io_uring_cmd
 engine
Date:   Mon, 23 May 2022 18:40:39 +0530
Message-Id: <20220523131039.17697-8-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220523131039.17697-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7bCmhm7ytu4kg1+LLCzWXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8XCjcuYHNg8Lp8t9ejbsorR4/MmuQDmqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjIPNG1kL2kQrnr64wNLA
        eEKwi5GTQ0LARGLtmpOMXYxcHEICuxkltnzbwgzhfGKUOPHuDSuE841R4uqdg+wwLSv/dzJB
        JPYySkxZvBKqpZVJYsvyHhaQKjYBbYlXb28wg9giAsIS+ztaWUCKmAVaGCUaV68FKxIW8Jfo
        uHYfrIhFQFViVe8nJhCbV8BGYvLan2wQ6+QlVm84AFbDKWArcefDP7BtEgLb2CUOv2xmhihy
        kfjaswOqQVji1fEtULdKSbzsb4OysyUaH/2FqimR2HlrO1SvvcTFPX+BFnMAXacpsX6XPkRY
        VmLqqXVg9zAL8En0/n7CBBHnldgxD8ZWlfh77zYLhC0tcfPdVSjbQ2L5/V3skFCZwCgx7+gc
        lgmMcrMQVixgZFzFKJlaUJybnlpsWmCUl1oOj7fk/NxNjODEpeW1g/Hhgw96hxiZOBgPMUpw
        MCuJ8G5P7EgS4k1JrKxKLcqPLyrNSS0+xGgKDMCJzFKiyfnA1JlXEm9oYmlgYmZmZmJpbGao
        JM4r8L8xSUggPbEkNTs1tSC1CKaPiYNTqoGpuvqwn1rYr+uvn80Ok8k6du1HVMiUebaMOazP
        hBcVp77P7HpXETHHSVp7yk/+rX5uvyXY+ab6cN1Yw6L2KcbO9lTW5BnC7omnpijtWhF2U9m3
        01PbcUmjnNisCdmbw/kyvxx6tWqSidjW/L//bN2Wfy56cWX+jotX2izW9X5hbNtSVagbP+9c
        qHPbLNF5z5jP7D3zP6/JR+Rfm4vZq+VfJHbETNlu2dA6U1d2itUc93sp9jfX6rOenLi62qSy
        rnnB9L+Lnb/FOE+0ef6G9+Mt288XVOxnJfNvf7cx6tL1pF/Hq3svBj11eh9acjtVd25clwGr
        5VXeJ6uOMTxelrnY2CI/uoy9SVXfuHlP1e8HSizFGYmGWsxFxYkAP1n8EeUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42LZdlhJXle3szvJYGoTp8WaK7/ZLZom/GW2
        WH23n83i46wXzBZH/79ls1i4cRmTA5vH5bOlHn1bVjF6fN4kF8AcxWWTkpqTWZZapG+XwJVx
        sHkja0GbaMXTFxdYGhhPCHYxcnJICJhIrPzfydTFyMUhJLCbUWLanbmsXYwcQAlpiYXrEyFq
        hCVW/nvODlHTzCTx+eBLFpAEm4C2xKu3N5hBbBGgov0drSwgRcwCXYwSPZ2nmEASwgK+Em0H
        1zOC2CwCqhKrej+BxXkFbCQmr/3JBrFBXmL1hgNggzgFbCXufPjHDHKEEFDNjh8hExj5FjAy
        rGKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93ECA4qLc0djNtXfdA7xMjEwXiIUYKDWUmE
        d3tiR5IQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTBdW
        bo1VadD+9vi1za68Bd8XiL13P/Vwwv/PLHrcDDtlxTbxLNfNDbe6m3v29fJOPQ92E43NDxsq
        WKRc6vOiMmbcYNesSWbQmVFf7nxiL38R+5vLHO96z9zraE9+9/fwm8VTZ+4Rymth/+1e86Ws
        X4Lxc+GDNdV/171sbF19Wpl/07njrk0TtrB9qLhvuiAz897qX0XHDRaq31dPevJFj+N5gfXV
        es35/Etu6YcmLn/a65zaw/pXPfLWSk3XgG3b9x5asUJbu3bKVt6bSVdebf62OaYg8OLUDXkG
        R3U3slUxt1adNC+fa5jzqGP/iVMbprHbnQxq1lhvZnzgvXr/hecqYpKT1rS2qM17fPX0uzQl
        luKMREMt5qLiRADAqq9SmQIAAA==
X-CMS-MailID: 20220523131629epcas5p4ab9e6158624a4c6a055bb0e410f46079
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220523131629epcas5p4ab9e6158624a4c6a055bb0e410f46079
References: <20220523131039.17697-1-ankit.kumar@samsung.com>
        <CGME20220523131629epcas5p4ab9e6158624a4c6a055bb0e410f46079@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

examples/uring-cmd-ng.fio has usage for conventional nvme-ns char device
examples/uring-cmd-zoned.fio has usage for ZNS nvme-ns char device

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 examples/uring-cmd-ng.fio    | 35 +++++++++++++++++++++++++++++++
 examples/uring-cmd-zoned.fio | 40 ++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)
 create mode 100644 examples/uring-cmd-ng.fio
 create mode 100644 examples/uring-cmd-zoned.fio

diff --git a/examples/uring-cmd-ng.fio b/examples/uring-cmd-ng.fio
new file mode 100644
index 00000000..db4292d3
--- /dev/null
+++ b/examples/uring-cmd-ng.fio
@@ -0,0 +1,35 @@
+; io_uring_cmd I/O engine for nvme-ns generic character device
+;
+; This job-file is intended to be used as:
+;
+; fio examples/uring-cmd-ng.fio \
+;   --section=default \
+;   --ioengine=io_uring_cmd \
+;   --sqthread_poll=1 \
+;   --cmd_type=nvme \
+;   --filename=/dev/ng0n1
+;
+; NOTE: If you want to override the default bs, iodepth, and workload, then
+; invoke it as:
+;
+; FIO_BS="512" FIO_RW="write" FIO_IODEPTH=16 fio examples/uring-cmd-ng.fio \
+;   --section=override --ioengine=io_uring_cmd --cmd_type=nvme \
+;   --filename=/dev/ng0n1
+;
+[global]
+rw=randread
+size=12G
+iodepth=1
+bs=4K
+thread=1
+time_based=1
+runtime=7
+ramp_time=3
+norandommap=1
+
+[default]
+
+[override]
+rw=${FIO_RW}
+iodepth=${FIO_IODEPTH}
+bs=${FIO_BS}
diff --git a/examples/uring-cmd-zoned.fio b/examples/uring-cmd-zoned.fio
new file mode 100644
index 00000000..2649d2fe
--- /dev/null
+++ b/examples/uring-cmd-zoned.fio
@@ -0,0 +1,40 @@
+; io_uring_cmd I/O engine for nvme-ns generic zoned character device
+;
+; NOTE: with write workload iodepth must be set to 1 as there is no IO
+; scheduler.
+;
+; Writes 1GB at QD1 using 4K BS and verifies it.
+;
+; This job-file is intended to be used as:
+;
+; fio examples/uring-cmd-zoned.fio \
+;   --section=default \
+;   --ioengine=io_uring_cmd \
+;   --sqthread_poll=1 \
+;   --cmd_type=nvme \
+;   --filename=/dev/ng0n1
+;
+; NOTE: If you want to override the default bs, size and workload, then
+; invoke it as:
+;
+; FIO_BS="32k" FIO_RW="randwrite" FIO_SIZE="2G" fio \
+;   examples/uring-cmd-zoned.fio --section=override --ioengine=io_uring_cmd \
+;   --sqthread_poll=1 --cmd_type=nvme --filename=/dev/ng0n1
+;
+[global]
+zonemode=zbd
+rw=write
+size=1G
+iodepth=1
+bs=4K
+thread=1
+ramp_time=1
+norandommap=1
+verify=crc32c
+
+[default]
+
+[override]
+rw=${FIO_RW}
+size=${FIO_SIZE}
+bs=${FIO_BS}
-- 
2.17.1

