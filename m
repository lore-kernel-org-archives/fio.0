Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3874CC433EF
	for <fio@archiver.kernel.org>; Thu, 26 May 2022 16:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348192AbiEZQsk (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 26 May 2022 12:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347258AbiEZQsi (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 May 2022 12:48:38 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98968A075
        for <fio@vger.kernel.org>; Thu, 26 May 2022 09:48:34 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220526164833epoutp010c0e6dfdb8c3e084242e0fba3b216c4f~ytaBJK3RJ3208332083epoutp01O
        for <fio@vger.kernel.org>; Thu, 26 May 2022 16:48:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220526164833epoutp010c0e6dfdb8c3e084242e0fba3b216c4f~ytaBJK3RJ3208332083epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653583713;
        bh=8K8QMR9pvY8+4hYpQqXeGKJabICVE89Xsn4AWgLjLn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uwjKx2G69QgZRA9TUYIwzksZIhCZ10qCyeM9mhuP6ew7K5XepEpZWcWlhJ5w+XSYV
         9mnm2OhX1xk/KWJeigmINI7MgNMLrwaAc6B1Y3SWoQ10rf299+HeYGnhkMbziUwa4T
         sjyg+ad6abWpIQGxVhLSAt7dlKn3lUSynJi2BYEs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220526164832epcas5p477fc131233db772d0872f90f503a18dc~ytaAKWl9V1413414134epcas5p4s;
        Thu, 26 May 2022 16:48:32 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4L8DQh2n3sz4x9Pp; Thu, 26 May
        2022 16:48:28 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        37.B1.09827.C5FAF826; Fri, 27 May 2022 01:48:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220526145404epcas5p264b0af9a5ab117cc8276710c9b648f38~yr2EGC4d42150521505epcas5p2d;
        Thu, 26 May 2022 14:54:04 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220526145404epsmtrp1698a83406216a597b6a6ac752277f805~yr2EFWScB0378803788epsmtrp1e;
        Thu, 26 May 2022 14:54:04 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-21-628faf5cc3ba
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B0.4E.08924.C849F826; Thu, 26 May 2022 23:54:04 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220526145403epsmtip2de5d90bb3b090588c9463ba885f13245~yr2DF3Z_f1808318083epsmtip2F;
        Thu, 26 May 2022 14:54:03 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 6/8] zbd: Check for direct flag only if its block device
Date:   Thu, 26 May 2022 20:18:07 +0530
Message-Id: <20220526144809.14877-7-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220526144809.14877-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsWy7bCmhm7M+v4kg5sbhS3WXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8XCjcuYHNg8Lp8t9ejbsorR4/MmuQDmqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjK6vx1kL1vNWPD3bwdLA
        eIGri5GTQ0LAROLalteMXYxcHEICuxkluvauZwNJCAl8YpS4/5oVwv7MKHH3kz9MQ9f+Z1AN
        uxglHm9uY4VwWpkkVs9+wwxSxSagLfHq7Q0wW0RAWGJ/RysLSBGzQAujROPqtSwgCWEBb4mn
        L1eDFbEIqEocuPGKCcTmFbCReLpoJRPEOnmJ1RsOgNVwCthKnLs9gw1kkITAJnaJaXunsUMU
        uUg8/n6VDcIWlnh1fAtUXEriZX8blJ0t0fjoL1RNicTOW9uZIWx7iYt7/gIt4wC6TlNi/S59
        iLCsxNRT68BuYBbgk+j9/QTqHl6JHfNgbFWJv/dus0DY0hI3312Fsj0k9txshIbKBEaJZ68O
        sk9glJuFsGIBI+MqRsnUguLc9NRi0wKjvNRyeKwl5+duYgQnLS2vHYwPH3zQO8TIxMF4iFGC
        g1lJhPfC094kId6UxMqq1KL8+KLSnNTiQ4ymwACcyCwlmpwPTJt5JfGGJpYGJmZmZiaWxmaG
        SuK8Av8bk4QE0hNLUrNTUwtSi2D6mDg4pRqYTKt6Op0k3zH4C6YG+9dKPRHtn2N6Tlet4FzA
        pSsVl7zVeeX3TnRmahCv17kitHNF3Q2Fm71V6wN/MqtrCCdu+u2t+K/uzXFm67XOtYU8F/j3
        za41vR6VZrwzRyjy8de2GR90m6Nueu/ep/ZlfXWRi7ifl1joJmF3nfwz52K8F5x9N1+5b7WC
        sc0c5rJFHPXaSud/7v99z5lj9obk/n7736EHvA2FBV8EJJcoV/37MFcli01b9uOcLTev2mw5
        MouN533KzpPsJyU3JzZsbnGSnlHxu6Mwi2nv6U4vnbW7J7sJPTuXLbt9rZhN4arLodHZJnul
        jX7FbPm+5n9bjEVrn+Iv3/0hc/1ObHFbZ6XEUpyRaKjFXFScCAAW7dWU4wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnluLIzCtJLcpLzFFi42LZdlhJXrdnSn+SweMjohZrrvxmt2ia8JfZ
        YvXdfjaLj7NeMFsc/f+WzWLhxmVMDmwel8+WevRtWcXo8XmTXABzFJdNSmpOZllqkb5dAldG
        19fjrAXreSuenu1gaWC8wNXFyMkhIWAi0bX/GWMXIxeHkMAORoll234zdzFyACWkJRauT4So
        EZZY+e85O0RNM5PEzPVbGEESbALaEq/e3mAGsUWAivZ3tLKAFDELdDFK9HSeYgJJCAt4Szx9
        uRqsiEVAVeLAjVdgcV4BG4mni1YyQWyQl1i94QBYDaeArcS52zPYQGwhoJp/+y4yTWDkW8DI
        sIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzistLR2MO5Z9UHvECMTB+MhRgkOZiUR
        3gtPe5OEeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYMp7
        e0R33Yo1ef4Kho61Nho5PdE+OQdXJdjvDH5rwtO2o4Ota8l71/mZBl+SSmc9efj79k9blguz
        05YapSg3CCpybmZ+dKX6Yti7pm2rnvBXKq7d/jfbYq5apNh0djtPlVdPHSMyEu6alXOfN1Vg
        yLZ/0L13rzuXnl1M/bQtLct/Hu/+yzCvIL6njWfl1LcfxL9Od9nltkKWYXPrt8k8XU5BHte+
        nrm2ceWen7nFadtamlc/nLBQXs3CRnpW+h3vLvsU/WOfJCV8p88O+qPYF8d1frfVpSc9zXy5
        SYtMmy9MqXhlL/K9r+Sk7Zf/rtI7zm1h/Vq65dMsyRnVSqtYpuyo3/9i2fHgTPfYlKTOz0os
        xRmJhlrMRcWJAOKNoTWaAgAA
X-CMS-MailID: 20220526145404epcas5p264b0af9a5ab117cc8276710c9b648f38
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145404epcas5p264b0af9a5ab117cc8276710c9b648f38
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145404epcas5p264b0af9a5ab117cc8276710c9b648f38@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

nvme-ns generic character devices currently do not support O_DIRECT flag.
Check for fio option for direct flag only if filetype is a block device.

t/zbd skip test case #1 for character devices as don't require
direct I/O.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 t/zbd/test-zbd-support | 3 ++-
 zbd.c                  | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 7e2fff00..a1ec5684 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -251,8 +251,9 @@ require_conv_zones() {
 	return 0
 }
 
-# Check whether buffered writes are refused.
+# Check whether buffered writes are refused for regular block devices.
 test1() {
+    require_regular_block_dev || return $SKIP_TESTCASE
     run_fio --name=job1 --filename="$dev" --rw=write --direct=0 --bs=4K	\
 	    "$(ioengine "psync")" --size="${zone_size}" --thread=1	\
 	    --zonemode=zbd --zonesize="${zone_size}" 2>&1 |
diff --git a/zbd.c b/zbd.c
index b1fd6b4b..627fb968 100644
--- a/zbd.c
+++ b/zbd.c
@@ -466,7 +466,7 @@ out:
 	return res;
 }
 
-/* Verify whether direct I/O is used for all host-managed zoned drives. */
+/* Verify whether direct I/O is used for all host-managed zoned block drives. */
 static bool zbd_using_direct_io(void)
 {
 	struct thread_data *td;
@@ -477,7 +477,7 @@ static bool zbd_using_direct_io(void)
 		if (td->o.odirect || !(td->o.td_ddir & TD_DDIR_WRITE))
 			continue;
 		for_each_file(td, f, j) {
-			if (f->zbd_info &&
+			if (f->zbd_info && f->filetype == FIO_TYPE_BLOCK &&
 			    f->zbd_info->model == ZBD_HOST_MANAGED)
 				return false;
 		}
-- 
2.17.1

