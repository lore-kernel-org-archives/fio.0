Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E83C433EF
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 16:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238808AbiEWQ3L (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 12:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbiEWQ3K (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 12:29:10 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B03E68F85
        for <fio@vger.kernel.org>; Mon, 23 May 2022 09:29:09 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220523162907epoutp0358ec3c6afef5353aacfbe0853d20be78~xyNMiG-8_1562815628epoutp03c
        for <fio@vger.kernel.org>; Mon, 23 May 2022 16:29:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220523162907epoutp0358ec3c6afef5353aacfbe0853d20be78~xyNMiG-8_1562815628epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653323347;
        bh=gIGjnZojww3aYY1l5f5t8LFv1XY55RCsueDq2F81pEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vG3LS1b13fa+qg8yo2BxBVVAx5k7bdglAncwBjeuq+txzHYKjRRCxy/st8ghweKC1
         5YEj0VT9nWbPYoZ2gtYAo+vE1ebNmhSkFBobrqLzjALazUqGfDXy1jXYnPh1kjyLeL
         U3ibwDyhrDXbxPTyc7OxWW6XT2eVs03zWEtc1atc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220523162906epcas5p3d29d7bf311acdae2d322ca3b2fa014a9~xyNLYJVPK0505105051epcas5p3x;
        Mon, 23 May 2022 16:29:06 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4L6N7g6J2Xz4x9Pp; Mon, 23 May
        2022 16:29:03 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2A.CF.09827.F46BB826; Tue, 24 May 2022 01:29:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220523131621epcas5p2e6c71932c10003f423dbd38762089957~xvk5J3xDT0493104931epcas5p2B;
        Mon, 23 May 2022 13:16:21 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220523131621epsmtrp2e02f01cca80cdb39326fe84483075134~xvk5IbIUB2951529515epsmtrp2n;
        Mon, 23 May 2022 13:16:21 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-af-628bb64fbeca
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.6D.08924.5298B826; Mon, 23 May 2022 22:16:21 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220523131620epsmtip27b47c1dc00b25688d54a2a8a1ed2b4b6~xvk4GjMrv2113921139epsmtip2W;
        Mon, 23 May 2022 13:16:20 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 4/7] docs: document options for io_uring_cmd I/O engine
Date:   Mon, 23 May 2022 18:40:36 +0530
Message-Id: <20220523131039.17697-5-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220523131039.17697-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsWy7bCmlq7/tu4kg1Xn9SzWXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8XCjcuYHNg8Lp8t9ejbsorR4/MmuQDmqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjAs72AueKVc8u+jTwPhE
        pouRk0NCwERiw+mp7F2MXBxCArsZJY4u72aEcD4xStxefJ8JwvnMKPG58zcLTMusZ8/ZIBK7
        GCV2d0+D6m9lktjz+RMrSBWbgLbEq7c3mEFsEQFhif0drSwgRcwCLYwSjavXgo0SFnCXOLJ3
        CyOIzSKgKtFz7SCYzStgI7Hu+nYmiHXyEqs3HAAbxClgK3Hnwz9mkEESApvYJb7+28cIUeQi
        8WrWS2YIW1ji1fEt7BC2lMTnd3vZIOxsicZHf6HsEomdt7ZD1dtLXNzzF2gZB9B1mhLrd+lD
        hGUlpp5aB3YDswCfRO/vJ1D38ErsmAdjq0r8vXcbGizSEjffXYWyPSSm79gIDaIJjBKn3q1i
        nsAoNwthxQJGxlWMkqkFxbnpqcWmBUZ5qeXwWEvOz93ECE5aWl47GB8++KB3iJGJg/EQowQH
        s5II7/bEjiQh3pTEyqrUovz4otKc1OJDjKbAAJzILCWanA9Mm3kl8YYmlgYmZmZmJpbGZoZK
        4rwC/xuThATSE0tSs1NTC1KLYPqYODilGpiyT3qr/d3rb723nuuzwx7VE6lCx8tl1D6lpuy5
        vESbx71Z/8gtxtyu6TP+PNz3oHRP5wY7J21OoUV/l+R5iPIdV1tcdGuxWENm3CGTx8ImAl55
        O3UK5k+ZZXOwM+HeD/mXTgmNCRNuBq0O01+//6Jhpdy7sHet7rsN5jfqzkznKOyqPVQfqd9b
        4/HG3cUksbvwyZf1Vy+sEdxobrpFcc7bipVa851Em+5Vdh/73LHJ+vniFa/XHZ1i9iGi2OdU
        84moe8U1E6xfFSwxuGvAnin2XV45fj9H8SXm6y6x35cb3I+Oeur1QHz3YvHn4b9slnqIrPtv
        1Oob8yfTnH1R1zJBkzZbh9uSZxsLKo1UE5RYijMSDbWYi4oTAYOwuODjAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42LZdlhJXle1szvJ4MQTeYs1V36zWzRN+Mts
        sfpuP5vFx1kvmC2O/n/LZrFw4zImBzaPy2dLPfq2rGL0+LxJLoA5issmJTUnsyy1SN8ugSvj
        wg72gmfKFc8u+jQwPpHpYuTkkBAwkZj17DlbFyMXh5DADkaJZ73PWLoYOYAS0hIL1ydC1AhL
        rPz3nB2ipplJ4u68HcwgCTYBbYlXb2+A2SJARfs7WllAipgFuhglejpPMYEkhAXcJY7s3cII
        YrMIqEr0XDsIZvMK2Eisu76dCWKDvMTqDQfABnEK2Erc+fCPGeQIIaCaHT9CJjDyLWBkWMUo
        mVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERxQWlo7GPes+qB3iJGJg/EQowQHs5II7/bE
        jiQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamK4wCl08
        fTC7x04keZrphv3hCy20Qqx+lz9fK1EUd8rgv1iKzVSDyGcmXzgy5985+WH6yXtHGi9Lbu38
        0NG+iSN9vqhs144qr5u3bT1m7NZXk/DJ+Jj2mm9mjhlznuS/41eLy4o4258eM5ed9NX/uund
        59NWvf1hWL5+x7RJ3XPMlDfv2X1iscy7hLkVd2epvd4xh/fbbNlz1zOaWKJeRGVsCz3TNTej
        SWqi3M7pZUY3Z9tPKC3LYlH1dH3/bE0ESwVHZOoL43Oa1ovd72vJ/Pwx8amtr56koFrOiXcb
        S4pynAIXG8YutOt+L7fy/bzoolzOGYzLtjGwLz118/N8S4//LkUPdvPLmaZrL6+1P6vEUpyR
        aKjFXFScCADLpBKFlwIAAA==
X-CMS-MailID: 20220523131621epcas5p2e6c71932c10003f423dbd38762089957
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220523131621epcas5p2e6c71932c10003f423dbd38762089957
References: <20220523131039.17697-1-ankit.kumar@samsung.com>
        <CGME20220523131621epcas5p2e6c71932c10003f423dbd38762089957@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Update documentation with io_uring_cmd I/O engine specific options.
Add missing io_uring I/O engine entry from fio man page.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 17 +++++++++++++----
 fio.1     | 19 ++++++++++++++++---
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 84bea5c5..5c74c80c 100644
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
@@ -2259,14 +2263,14 @@ with the caveat that when used on the command line, they must come after the
     map and release for each IO. This is more efficient, and reduces the
     IO latency as well.
 
-.. option:: registerfiles : [io_uring]
+.. option:: registerfiles : [io_uring] [io_uring_cmd]
 
 	With this option, fio registers the set of files being used with the
 	kernel. This avoids the overhead of managing file counts in the kernel,
 	making the submission and completion part more lightweight. Required
 	for the below :option:`sqthread_poll` option.
 
-.. option:: sqthread_poll : [io_uring] [xnvme]
+.. option:: sqthread_poll : [io_uring] [io_uring_cmd] [xnvme]
 
 	Normally fio will submit IO by issuing a system call to notify the
 	kernel of available items in the SQ ring. If this option is set, the
@@ -2274,14 +2278,19 @@ with the caveat that when used on the command line, they must come after the
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
index ded7bbfc..7e15cfba 100644
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
@@ -2052,22 +2061,26 @@ completions do not. Hence they are require active reaping by the application.
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

