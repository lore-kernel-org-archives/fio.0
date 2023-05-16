Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C09C77B75
	for <fio@archiver.kernel.org>; Tue, 16 May 2023 06:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjEPG7e (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 16 May 2023 02:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjEPG7a (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 16 May 2023 02:59:30 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFA335B6
        for <fio@vger.kernel.org>; Mon, 15 May 2023 23:59:28 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230516065925epoutp0452088147e64b7ae8db701224f26d37c1~fjX-U6ZR23176431764epoutp044
        for <fio@vger.kernel.org>; Tue, 16 May 2023 06:59:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230516065925epoutp0452088147e64b7ae8db701224f26d37c1~fjX-U6ZR23176431764epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1684220365;
        bh=1ucs52rd2Z160IKwRyKYQdmYSfSTup8CCWETMPX3l0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rmmi1Y4fNfdxZ+/V27wjPF50XLk0z6nL111pVIPluCaTLLl6P+s13/43JtPJtTZUT
         PNxgyktRhbOwruZSOfp+MlrbJRIrqbRXCgB3AOvr2Asg53fwhrQtYaK681yuKGaOt1
         +4dXv9A4VmV+9AUdxpsgwx8GFmxQsR5wE23q7LsU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230516065925epcas5p10bf8ee0a993b8cb87aae5fe258633644~fjX-JwdIF1458514585epcas5p1x;
        Tue, 16 May 2023 06:59:25 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4QL6Y82VWxz4x9QJ; Tue, 16 May
        2023 06:59:24 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        27.CA.57769.AC923646; Tue, 16 May 2023 15:59:22 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230516065714epcas5p356762595641f6e8c102c8346a1681747~fjWErrnts1785617856epcas5p3t;
        Tue, 16 May 2023 06:57:14 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230516065714epsmtrp2151ee64adf5a2814456fa63d79bff6e8~fjWErAkZX2199921999epsmtrp2l;
        Tue, 16 May 2023 06:57:14 +0000 (GMT)
X-AuditID: b6c32a4a-f3bfd7000001e1a9-fb-646329ca0f0b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        06.B4.28392.94923646; Tue, 16 May 2023 15:57:13 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230516065713epsmtip21e8cb33c32db4460e8b4b3b122981ef3~fjWD6b4-P1553015530epsmtip2e;
        Tue, 16 May 2023 06:57:13 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/1] engines/io_uring: fix coverity issue
Date:   Tue, 16 May 2023 17:47:17 +0530
Message-Id: <20230516121717.28508-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230516121717.28508-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmhu4pzeQUg4tvWCzWXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOONcoWdDIUfH+5zvmBsaLbF2MnBwS
        AiYSvyc8Y+1i5OIQEtjNKPFgxRc2COcTo8SFt0vZIZzPjBL3dv9igWm5+vciVGIXo0RT3y9m
        CKeTSWLuoenMIFVsAtoSr97eALNFBIQl9ne0gnUzC4RKnLz2Baibg0NYwFLi8HNGkDCLgKrE
        jmszwWxeARuJWYfesEMsk5eYeek7mM0pYCsx99Q0JogaQYmTM59AjZSXaN46G+wGCYF97BKv
        Zk+Hes5FomP5Y2YIW1ji1fEtUEOlJD6/2wtVky2x6eFPJgi7QOLIi16oenuJ1lP9zCB3Mgto
        SqzfpQ8RlpWYemodE8RePone30+gWnkldsyDsVUl/t67DQ0saYmb766ygIyREPCQuP8lDxJU
        ExglTm+cyjKBUWEWkndmIXlnFsLmBYzMqxglUwuKc9NTi00LjPJSy+FxnJyfu4kRnAS1vHYw
        PnzwQe8QIxMH4yFGCQ5mJRHe9pnxKUK8KYmVValF+fFFpTmpxYcYTYHhPZFZSjQ5H5iG80ri
        DU0sDUzMzMxMLI3NDJXEedVtTyYLCaQnlqRmp6YWpBbB9DFxcEo1MK2zU3M9tuTnxS+Ptnps
        t7kaG+0QmXDz6NQMH/+wkDdvPssZPF0Zdt1C5tWMA9IpqnvWsHwN0n3Xf7MkyObG3tNO7y4G
        3F/Oen9yRGRycKSCZmzV5LVZ8+oWCj4P1Xosf9l33b5ID90tHWwikzVswyvm7tvWLB2cP/PT
        18nO+3Xfc/yM/mE7p3tl6STJnvUdn6RTjY6be9pFiszyud26P4PJzex859TDxTkC9efzWpzu
        /fEwFxSI1/Hd77tP75bbHHcbpyWuy5sV9nZ8O+Py8YPRg6BvdRu5Ew59vBcUcqw1w8r0eG39
        wwuL7nGp8fDZ8n5WP2cgXGFy4+DrHxe7dzKcybu5gdVDXmxd9f9uaSWW4oxEQy3mouJEABVA
        bEYLBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsWy7bCSvK6XZnKKwVpnizVXfrNbrL7bz2bx
        cdYLZosNbYIOLB47Z91l97h8ttSjb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4Ms41ShY0clS8
        //mOuYHxIlsXIyeHhICJxNW/F9lBbCGBHYwSJ/bzdDFyAMWlJRauT4QoEZZY+e85UAkXUEk7
        k0T/g9tgvWwC2hKv3t5gBrFFgIr2d7SygNjMAuES0w9MZgSZIyxgKXH4OSNImEVAVWLHtZlg
        Nq+AjcSsQ2/YIebLS8y89B3M5hSwlZh7ahoTxDk2Eh375rBC1AtKnJz5BGq8vETz1tnMExgF
        ZiFJzUKSWsDItIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzhAtbR2MO5Z9UHvECMT
        B+MhRgkOZiUR3vaZ8SlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2C
        yTJxcEo1MCXyRKw+tT64Mpc30rh7dcPRq26Z8s2mDzzKW+19mOzlP/Ftiyu0WJp9aOoHW8Vb
        ZrKXBEtM+HgX6RzYs9Xht+7WCpuUtROdG4NUW6auYha1eXrzyMdldZxPC42b7RdtP7TXYP8Z
        3rlpvNYvcr03vNyh9Kxuur991702EftlFk98U3ccF1WPSo5K+6pw+Ibl69t3F0bbOjEvWjh9
        3hP3s7+te6p3njpmUrH5ZKkUu3JT+oOnn3WmOizuNcrZX3vQsfyYq9XDx1VKkb9bzuclXde4
        3rxm7a2M14GiC0JnLc/cPvmoYPxvKcMky7OfP996xBk71bY69FRuYxnTjci6v7L8qXIMH/xv
        cU3yqZvZpcRSnJFoqMVcVJwIAGegHjG/AgAA
X-CMS-MailID: 20230516065714epcas5p356762595641f6e8c102c8346a1681747
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230516065714epcas5p356762595641f6e8c102c8346a1681747
References: <20230516121717.28508-1-ankit.kumar@samsung.com>
        <CGME20230516065714epcas5p356762595641f6e8c102c8346a1681747@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

*** CID 455020:  Integer handling issues  (BAD_SHIFT)
/engines/io_uring.c: 1201 in fio_ioring_cmd_open_file()

In expression "1 << data->lba_shift", left shifting by more than 31 bits
has undefined behavior.  The shift amount, "data->lba_shift", is 4294967295

Fixes: 345fa8f ("engines/io_uring_cmd: add extended LBA support")

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 90e5a856..ff64fc9f 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1198,7 +1198,8 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 			FILE_SET_ENG_DATA(f, data);
 		}
 
-		lba_size = data->lba_ext ? data->lba_ext : (1 << data->lba_shift);
+		assert(data->lba_shift < 32);
+		lba_size = data->lba_ext ? data->lba_ext : (1U << data->lba_shift);
 
 		for_each_rw_ddir(ddir) {
 			if (td->o.min_bs[ddir] % lba_size ||
-- 
2.25.1

