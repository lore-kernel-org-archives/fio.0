Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF752C4332F
	for <fio@archiver.kernel.org>; Fri,  4 Nov 2022 12:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiKDMiS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 4 Nov 2022 08:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbiKDMiO (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Nov 2022 08:38:14 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7894E2DA95
        for <fio@vger.kernel.org>; Fri,  4 Nov 2022 05:38:12 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221104123808epoutp04fca0f93053646c9f95bebd47e31fa7b5~kYfn5LdD53092630926epoutp04C
        for <fio@vger.kernel.org>; Fri,  4 Nov 2022 12:38:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221104123808epoutp04fca0f93053646c9f95bebd47e31fa7b5~kYfn5LdD53092630926epoutp04C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667565488;
        bh=LTssuTXWDoR736O4BGKsB8UEyF4nLqzg1N10ciJNlRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a54PorqIrvVGgG5QPPG6RZ7bdKHYaUh+sOTilMy8bch+C2WiOPbKIGPEQXkTD/9uW
         AZTtHcDlBE8RBs7IaNTM4SipMPzoJtcBscSTW9rN/07VEW9iSWpiklkUPqoSmJnM9P
         cXY7VD4mTwbaLhA45OjOmG2WA9bfzD+dVG9uEPiQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221104123807epcas5p4e3ecb4de0a7808d02523dea4d6576f77~kYfnXc7zX1700017000epcas5p4i;
        Fri,  4 Nov 2022 12:38:07 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4N3gC21DYfz4x9Px; Fri,  4 Nov
        2022 12:38:06 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AF.1B.01710.BA705636; Fri,  4 Nov 2022 21:38:03 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221104112442epcas5p4dab9270f5d970618f1a13cc39e26016a~kXfg6A5KJ2575525755epcas5p4p;
        Fri,  4 Nov 2022 11:24:42 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221104112442epsmtrp1fad3fa115f866fde0a516a82885f4774~kXfg5ZxxI1354313543epsmtrp1d;
        Fri,  4 Nov 2022 11:24:42 +0000 (GMT)
X-AuditID: b6c32a49-a41ff700000006ae-6b-636507abd8c5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4B.34.18644.A76F4636; Fri,  4 Nov 2022 20:24:42 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221104112441epsmtip2bbe2c1a62732a9a2af633a18186dbe73~kXff2P5H00272702727epsmtip22;
        Fri,  4 Nov 2022 11:24:41 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 2/2] doc: update about sqthread_poll
Date:   Fri,  4 Nov 2022 16:43:14 +0530
Message-Id: <20221104111314.25535-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221104111314.25535-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsWy7bCmpu4a9tRkg5kSFmuu/Ga3WH23n83i
        46wXzBYb2gQdWDx2zrrL7nH5bKlH35ZVjB6fN8kFsERl22SkJqakFimk5iXnp2TmpdsqeQfH
        O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX
        2CqlFqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGdcOq5TcI+34v+fWawNjH+4uhg5OSQE
        TCTu9i1iArGFBHYzSqz/LNfFyAVkf2KUONX1khnC+cwo0fb6EStMx/Kz81khErsYJb5272GE
        aG9lkuiYKwViswloS7x6e4MZxBYREJbY39HKAmIzC4RKnLz2hR3EFgYa9PnwXrA4i4CqxIOV
        z8HO4BWwkbhys5cRYpm8xOoNB4DmcHBwCthKbDshDxFexS6xcQI7hO0iMeHsGihbWOLV8S1Q
        tpTEy/42KDtbYtPDn0wQdoHEkRe9zBC2vUTrqX6w8cwCmhLrd+lDhGUlpp5axwRxMZ9E7+8n
        UK28EjvmwdiqEn/v3WaBsKUlbr67CmV7SEx8fJkREjwTGCVWb+5gmcAoNwthxQJGxlWMkqkF
        xbnpqcWmBYZ5qeXwGEvOz93ECE5PWp47GO8++KB3iJGJg/EQowQHs5II76dtyclCvCmJlVWp
        RfnxRaU5qcWHGE2BwTeRWUo0OR+YIPNK4g1NLA1MzMzMTCyNzQyVxHkXz9BKFhJITyxJzU5N
        LUgtgulj4uCUamDa1v2wyV1f6kSr/vLrlucSRJXvCz5g+MZ35dimZUtlRNdWFim1/2Y+ud5i
        7vvkxQ5HJgUK7di68vhTY5O6TOO/dxNDD2zOndA1s9/YOXb3iaop2/vXqirxBnTHnL/IfK/i
        wI4vExpvGxyttLt5NmFiFGfU9MbQa8mNXHk3rGacZJit+GdW5cbui9Uh2xJ1LgU5Naj+3XB5
        vqjBtx9KdR/epapu5z229/tSTX+GNa8f1r74pLHik9vCPw8fun2aYO/Rm3Hz0HGX+Hkaf9my
        xfkblt4+9D65+YfEogN6t1+pxwQveXGmv7S22bv11l0DzlKWOdYeaY2vTdbvvvHnSWanyIRK
        bje7Gxen3pE4ZHdypxJLcUaioRZzUXEiABPG0U3YAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsWy7bCSvG7Vt5Rkg6nH1S3WXPnNbrH6bj+b
        xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mq4dFyn4B5v
        xf8/s1gbGP9wdTFyckgImEgsPzuftYuRi0NIYAejxMGr59i7GDmAEtISC9cnQtQIS6z895wd
        oqaZSeLv9EWsIAk2AW2JV29vMIPYIkBF+ztaWUBsZoFwiekHJjOC2MJACz4f3gsWZxFQlXiw
        8jkTiM0rYCNx5WYvI8QCeYnVGw4wg+zlFLCV2HZCHiQsBFSyctFklgmMfAsYGVYxSqYWFOem
        5xYbFhjlpZbrFSfmFpfmpesl5+duYgQHkZbWDsY9qz7oHWJk4mA8xCjBwawkwvtpW3KyEG9K
        YmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTSE0tSs1NTC1KLYLJMHJxSDUypzYr9oasOVX0Q
        9rVq11t4Pz1D4W3vtRvRHxyOeRq92WjUy2UszRvfsiP4Xba4RuIW/0l/a1cW619IN/K8tlXi
        e+nqv2+K2xcc2/100hYvmVMXMtkXSc3M6W840fHYypd3wh2zhrlfll6r2aXtcjNh3d40O40I
        ZZt5+89drzeJj54gIDOT00DPumLTCfdKRnG90qp/W3l//Nv0Y2URu/rG47W/J8xYqNTSuPBW
        TsmTPXw+bZeVfq3muM2fxv1zbt/9HVOvMD/alprd+Ez5+snMZWaPLz2PUPy8UHb6Rf3nBpzK
        ncb8SgW/naeYe8QXpZopbvNkSUkNuHmx+P0Gz7lpAt/3djjpB1vs2fnguZQSS3FGoqEWc1Fx
        IgB530/nkQIAAA==
X-CMS-MailID: 20221104112442epcas5p4dab9270f5d970618f1a13cc39e26016a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104112442epcas5p4dab9270f5d970618f1a13cc39e26016a
References: <20221104111314.25535-1-ankit.kumar@samsung.com>
        <CGME20221104112442epcas5p4dab9270f5d970618f1a13cc39e26016a@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Update that when sqthread_poll is enabled the submission and completion
latencies reported may not be accurate. This is because the actual submission
is done by the kernel polling thread.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 4 +++-
 fio.1     | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 0fb5593e..dea625fe 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2299,7 +2299,9 @@ with the caveat that when used on the command line, they must come after the
 	kernel of available items in the SQ ring. If this option is set, the
 	act of submitting IO will be done by a polling thread in the kernel.
 	This frees up cycles for fio, at the cost of using more CPU in the
-	system.
+	system. The submission and completion latencies reported may not be
+	accurate as fio has no idea when the kernel polling thread submits the
+	actual I/O.
 
 .. option:: sqthread_poll_cpu : [io_uring] [io_uring_cmd]
 
diff --git a/fio.1 b/fio.1
index 4324a975..95c5ce55 100644
--- a/fio.1
+++ b/fio.1
@@ -2090,7 +2090,9 @@ sqthread_poll option.
 Normally fio will submit IO by issuing a system call to notify the kernel of
 available items in the SQ ring. If this option is set, the act of submitting IO
 will be done by a polling thread in the kernel. This frees up cycles for fio, at
-the cost of using more CPU in the system.
+the cost of using more CPU in the system. The submission and completion
+latencies reported may not be accurate as fio has no idea when the kernel
+polling thread submits the actual I/O.
 .TP
 .BI (io_uring,io_uring_cmd)sqthread_poll_cpu
 When `sqthread_poll` is set, this option provides a way to define which CPU
-- 
2.17.1

