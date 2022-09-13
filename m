Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7DD7C6FA82
	for <fio@archiver.kernel.org>; Tue, 13 Sep 2022 11:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiIMLKC (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 13 Sep 2022 07:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiIMLKB (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Sep 2022 07:10:01 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EE313D26
        for <fio@vger.kernel.org>; Tue, 13 Sep 2022 04:09:58 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220913110954epoutp026bcd3ab71bdb9698b2b19b09bc35b22f~UZvvKL61O0513405134epoutp02O
        for <fio@vger.kernel.org>; Tue, 13 Sep 2022 11:09:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220913110954epoutp026bcd3ab71bdb9698b2b19b09bc35b22f~UZvvKL61O0513405134epoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663067394;
        bh=QKDGrMMukmGpkiRW3ZfPI0b2j8OvbU3kdf8hmZ5x7io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPuah4JJ7gqHxydx/WLCNTopQOVgyLw4y40s5ozJwY0MIa68rRQZoundaHra4t+Wp
         qPLugHMwKEg/OPuLiH3XxXMi0GO8NNXy30nzTXpDyZA1eptLSRJBHGUPrbxFYMgXbx
         8O/BgvUyi8+zP9632fVUJ3Ug3y63Rv4W6h9g3Rzw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220913110953epcas5p1b35ae8f99a73396323295b02c027b099~UZvuZ5qE41484714847epcas5p1s;
        Tue, 13 Sep 2022 11:09:53 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MRgjC3GlYz4x9Pq; Tue, 13 Sep
        2022 11:09:51 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F8.56.59633.6F460236; Tue, 13 Sep 2022 20:09:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220913105532epcas5p43dcd5a649dbad6bc6d39574677cb73b9~UZjMXlpOf1424214242epcas5p41;
        Tue, 13 Sep 2022 10:55:32 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220913105532epsmtrp12c714577419d447460c5532d502b663e~UZjMW9L1B1107011070epsmtrp1L;
        Tue, 13 Sep 2022 10:55:32 +0000 (GMT)
X-AuditID: b6c32a49-06ffe7000000e8f1-d7-632064f60a62
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        22.0E.18644.3A160236; Tue, 13 Sep 2022 19:55:31 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220913105531epsmtip2a8f464a4fa285de85c288fc97fa7772c~UZjLpRWhg2257922579epsmtip2Z;
        Tue, 13 Sep 2022 10:55:31 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/1] backend: number of ios not as expected for trimwrite
Date:   Tue, 13 Sep 2022 16:15:27 +0530
Message-Id: <20220913104527.18734-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220913104527.18734-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsWy7bCmlu63FIVkg9MvZSzWXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOON76iLngq1DFk3uVDYz/+boYOTgk
        BEwk5kzW6WLk4hAS2M0o0XB3CguE84lRoqflLxuE85lR4szlK6xdjJxgHaueP4Kq2sUoseHZ
        QSYIp5VJYs/5eewgVWwC2hKv3t5gBrFFBIQl9ne0soDYzAKhEievfQGrERbwlFh4fC+YzSKg
        KvHm1HpGEJtXwEZi4dNNzBDb5CVWbzgAZnMK2EpMWXESbJmEwCp2ibsXjjFBFLlIXHnyA6pB
        WOLV8S3sELaUxMv+Nig7W2LTw59Q9QUSR170QtXbS7Se6mcGBQazgKbE+l36EGFZiamn1jFB
        3Mwn0fv7CVQrr8SOeTC2qsTfe7dZIGxpiZvvrkLZHhLnFk4Ah5aQwARGiUetURMY5WYhbFjA
        yLiKUTK1oDg3PbXYtMAwL7UcHmfJ+bmbGMFJSstzB+PdBx/0DjEycTAeYpTgYFYS4e0LUUgW
        4k1JrKxKLcqPLyrNSS0+xGgKDL+JzFKiyfnANJlXEm9oYmlgYmZmZmJpbGaoJM47RZsxWUgg
        PbEkNTs1tSC1CKaPiYNTqoGprmTJH9nCs3xfj54IfTczZIfBRaZXV1uZY5l/lnfN3Gk8rzlN
        3GxZQ3SlqZj7tZ8v4r4H20y+u0m+8IDX294SU2bd5T2K8142elZcOu9+ZfNztvJZ0zZdEujZ
        aDbx88VKAcV7/ycsW9Xk1DJhR2LSHrWvXSUHvm475bN3k0q98/Vnxm8WeO01TX7dZTuds+fg
        jMPspuZLGj482Xa65fm+BzNaEmrebRS9Fm38fX4s8/nNnKsqKnicpoqmGTP/mGFf+a7rVEC8
        X5FTxNfD98/+43VqEM9vVYue+uiiSjrjUzadlUevrtv65XxMwl3WWj0di+2mqhutXPxnKrsd
        0/32kudG++8y3WNBCev91yzZr8RSnJFoqMVcVJwIAI4gjjXbAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsWy7bCSvO7iRIVkg9eXLC3WXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mo43vqIueCr
        UMWTe5UNjP/5uhg5OSQETCRWPX/E0sXIxSEksINR4tafD6xdjBxACWmJhesTIWqEJVb+e84O
        UdPMJPFv4nYmkASbgLbEq7c3mEFsEaCi/R2tLCA2s0C4xPQDkxlBbGEBT4mFx/eyg9gsAqoS
        b06tB4vzCthILHy6iRligbzE6g0HwGxOAVuJKStOgs0XAqr5N+0Z4wRGvgWMDKsYJVMLinPT
        c4sNC4zyUsv1ihNzi0vz0vWS83M3MYLDSEtrB+OeVR/0DjEycTAeYpTgYFYS4e0LUUgW4k1J
        rKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJg1OqgWnq5GXcU972Lbu/
        W9/t2pt5Bttb3kf4mym/WC8+a0Pj+fCHrgV3s7VKffMnJS/t2TWVm6+q5paxdfJKvV0TGkTv
        ld+cIGSwgZXt1ITm+3zV8Zox6jP5NmuUL7y67GNDX+yy67d4xJatPxz7tOqn3DSxDdLrGkOn
        rrjeUb+6JDP+/I/0VucD2itny7oH8/BfP3XGtPHvs5yn9d2sLIF7dlfbOUsEz3PqevuOf+nC
        2VNS7GXfPV0xaVa7zrz0Jdf4DT9W6GkUHj8kIFfvdTG4gXvjoqhO14Y7f5aEZno51+6Pcr6Q
        aTCb84N5y/Kvm1d81tRREnSe/CZj74uKHVlvKw8nTJd+nXuBZ3q57ddC7UAlluKMREMt5qLi
        RACa63sakgIAAA==
X-CMS-MailID: 20220913105532epcas5p43dcd5a649dbad6bc6d39574677cb73b9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220913105532epcas5p43dcd5a649dbad6bc6d39574677cb73b9
References: <20220913104527.18734-1-ankit.kumar@samsung.com>
        <CGME20220913105532epcas5p43dcd5a649dbad6bc6d39574677cb73b9@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

number_ios should be twice for trimwrite, just like size or
io_size. Update the documentation for "rw=trimwrite" to explain the
changes.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 6 +++++-
 backend.c | 6 ++++--
 fio.1     | 5 ++++-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 2c6c6dbe..924f5ed9 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1129,7 +1129,11 @@ I/O type
 				Random mixed reads and writes.
 		**trimwrite**
 				Sequential trim+write sequences. Blocks will be trimmed first,
-				then the same blocks will be written to.
+				then the same blocks will be written to. So if ``io_size=64K``
+				is specified, Fio will trim a total of 64K bytes and also
+				write 64K bytes on the same trimmed blocks. This behaviour
+				will be consistent with ``number_ios`` or other Fio options
+				limiting the total bytes or number of I/O's.
 
 	Fio defaults to read if the option is not specified.  For the mixed I/O
 	types, the default is to split them 50/50.  For certain types of I/O the
diff --git a/backend.c b/backend.c
index fe614f6e..ec535bcc 100644
--- a/backend.c
+++ b/backend.c
@@ -971,9 +971,11 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 		total_bytes += td->o.size;
 
 	/* In trimwrite mode, each byte is trimmed and then written, so
-	 * allow total_bytes to be twice as big */
-	if (td_trimwrite(td))
+	 * allow total_bytes or number of ios to be twice as big */
+	if (td_trimwrite(td)) {
 		total_bytes += td->total_io_size;
+		td->o.number_ios *= 2;
+	}
 
 	while ((td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
 		(!flist_empty(&td->trim_list)) || !io_issue_bytes_exceeded(td) ||
diff --git a/fio.1 b/fio.1
index 67d7c710..c67bd464 100644
--- a/fio.1
+++ b/fio.1
@@ -900,7 +900,10 @@ Random mixed reads and writes.
 .TP
 .B trimwrite
 Sequential trim+write sequences. Blocks will be trimmed first,
-then the same blocks will be written to.
+then the same blocks will be written to. So if `io_size=64K' is specified,
+Fio will trim a total of 64K bytes and also write 64K bytes on the same
+trimmed blocks. This behaviour will be consistent with `number_ios' or
+other Fio options limiting the total bytes or number of I/O's.
 .RE
 .P
 Fio defaults to read if the option is not specified. For the mixed I/O
-- 
2.17.1

