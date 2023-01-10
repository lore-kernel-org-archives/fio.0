Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E97C54EBE
	for <fio@archiver.kernel.org>; Tue, 10 Jan 2023 06:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjAJG6M (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 10 Jan 2023 01:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjAJG6L (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 10 Jan 2023 01:58:11 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821BD41664
        for <fio@vger.kernel.org>; Mon,  9 Jan 2023 22:58:07 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230110065805epoutp037a7c5f566c46cd1b16bbb4426aa74992~44E2EXaLz2214222142epoutp039
        for <fio@vger.kernel.org>; Tue, 10 Jan 2023 06:58:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230110065805epoutp037a7c5f566c46cd1b16bbb4426aa74992~44E2EXaLz2214222142epoutp039
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1673333885;
        bh=oOIuq7FJq0nLocTIm/S/K7L/RqJ10idO05eCod/zjlg=;
        h=From:To:Cc:Subject:Date:References:From;
        b=EZ60comTNJE7EW2NtSvkfsMwjQaZ/lHQ14ITd72JFooJQ7rodHWcDkzca+VfG2/Pq
         rrmOwiW8S76A/w7395l6EFIKkTL0MWqq1jGLl2LOg49PSm+6XZAiZBWy+jQjQI9H2l
         7ZN9fNIAWMaMiKqU9zclQl4Viewg7GnMlk62RX28=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230110065804epcas5p4b56c6d040d36e41bda197783d5d0c087~44E1pjFmm2762327623epcas5p4D;
        Tue, 10 Jan 2023 06:58:04 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4NrhTl5schz4x9QJ; Tue, 10 Jan
        2023 06:58:03 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AD.83.02301.37C0DB36; Tue, 10 Jan 2023 15:57:55 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230110064318epcas5p36cdc6d71c75a4d724b8cff16b3802712~4338Gq5gZ2908829088epcas5p3t;
        Tue, 10 Jan 2023 06:43:18 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230110064318epsmtrp214b30855dfc7ea8c9db0c42c3f81c120~4338F4y5m2002920029epsmtrp2c;
        Tue, 10 Jan 2023 06:43:18 +0000 (GMT)
X-AuditID: b6c32a49-201ff700000108fd-4a-63bd0c736722
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        07.11.10542.6090DB36; Tue, 10 Jan 2023 15:43:18 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230110064317epsmtip2098baf4cc2f61de55d0668c716de9788~4337VU_LD1106811068epsmtip2h;
        Tue, 10 Jan 2023 06:43:17 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: clarify the usage of rw_sequencer
Date:   Tue, 10 Jan 2023 12:12:39 +0530
Message-Id: <20230110064240.30344-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsWy7bCmhm4xz95kgxeLdSzWXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOmH5mBlvBJqaK9RtbWBoYPzN2MXJy
        SAiYSPTs2MjcxcjFISSwm1Hi2uEedgjnE6PEjfYJUM5nRokZjWuZYVqa/05mhEjsYpS4cLwV
        ymlmktjZPJcVpIpNQFvi1dsbYB0iAsIS+ztaWUBsZoFQiZPXvrCD2MICWhLzvnwAq2ERUJXY
        v/AlWC+vgI3Ejg2L2SG2yUus3nAA7EAJgW52ic6fU9kgEi4Sn9dNhvpCWOLV8S1QDVISn9/t
        harJltj08CcThF0gceRFL9QL9hKtp/qBbA6ggzQl1u/ShwjLSkw9tY4J4k4+id7fT6BaeSV2
        zIOxVSX+3rvNAmFLS9x8dxXK9pA4tOMd2AlCArESa/8dYJ7AKDsLYcMCRsZVjJKpBcW56anF
        pgWGeanl8JhKzs/dxAhOSFqeOxjvPvigd4iRiYPxEKMEB7OSCO9Kzj3JQrwpiZVVqUX58UWl
        OanFhxhNgWE2kVlKNDkfmBLzSuINTSwNTMzMzEwsjc0MlcR5U7fOTxYSSE8sSc1OTS1ILYLp
        Y+LglGpgsrpcZeyQEGnP7b8g9EVXe19N6kT97Xq9v9aKKzoqCvRVnLYs+GT5qu0F61yuOaZF
        HxeKCLcIumwWzzHfWyp+1Xfvy4ag1xXiKuuKXBWZjdyC18mIMl/zXmip+nWp085N4uHCtrEC
        Kut0JNWOhebdSU3PO/z710RRfoZDGgdYUi3E/i3avXli9op7R5btdeB/eKU6Tar86VevrT3u
        taGnd6fMjPE6Es/mPnF/V+vk6vP1MTlplU86hIR8y3/v/f9c6YBtzJpNp3TioiIPv9vxkuG/
        w72zYktsC9uYq6Wd6jfUHCq+ebn1sYiqKdPsJZp/NT+9tZ26NPtzY/xWxTl81dfzNM7LiX57
        1Gs020mJpTgj0VCLuag4EQD+A8yl0QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsWy7bCSvC4b595kg/M/2CzWXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4MqYfmYGW8Em
        por1G1tYGhg/M3YxcnJICJhINP+dDGRzcQgJ7GCUaDk+k6WLkQMoIS2xcH0iRI2wxMp/z9kh
        ahqZJDY/2M0MkmAT0JZ49fYGmC0CVLS/o5UFxGYWCJeYfmAy2AJhAS2JeV8+gNWwCKhK7F/4
        khXE5hWwkdixYTE7xAJ5idUbDjBPYORZwMiwilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/
        dxMjODC0tHYw7ln1Qe8QIxMH4yFGCQ5mJRHelZx7koV4UxIrq1KL8uOLSnNSiw8xSnOwKInz
        Xug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgusRvNefz8rSVFm4ykVqLLfUNWD5n1klMe/MnOuNj
        HOO3IK7djrXmd7rvtdw+fDt7FYOI4jXnPSccJ95boHfb7pbqoysBPy5L35bmTq16pOf0yDVz
        4fnc/UZ/jc5LBAbxsPdNLFQU+3Vsd/0fj9mrX0x+7HrH5Yxy3AOfzs4bAVYJXNonr3uZp2XU
        pT1u0fTZ+He9NHPw+ROXqlqTXsbdMdFaqCmnerbG8obpnpNxiX1qCruFue4cE7E8atWoUbb6
        XqdtZU3rtsVasXeCvgc9XPLr0KsVTY1WfzY/mnajrGiylm6yQeGnyrP9lbbzwtXefqt90XZg
        y3Opt2zXlzy5dehsVequJ8EV7xYcVZwfosRSnJFoqMVcVJwIAPBQTt57AgAA
X-CMS-MailID: 20230110064318epcas5p36cdc6d71c75a4d724b8cff16b3802712
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230110064318epcas5p36cdc6d71c75a4d724b8cff16b3802712
References: <CGME20230110064318epcas5p36cdc6d71c75a4d724b8cff16b3802712@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Update man page clarifying the usage of rw_sequencer=sequential
Fixes: https://github.com/axboe/fio/issues/1223

Ankit Kumar (1):
  doc: clarify the usage of rw_sequencer

 HOWTO.rst | 10 +++++-----
 fio.1     | 12 ++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)

-- 
2.17.1

