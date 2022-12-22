Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59772C4332F
	for <fio@archiver.kernel.org>; Thu, 22 Dec 2022 04:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbiLVEsX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 21 Dec 2022 23:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234829AbiLVEsR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Dec 2022 23:48:17 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D701A80E
        for <fio@vger.kernel.org>; Wed, 21 Dec 2022 20:48:16 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221222044814epoutp02e774b623ce4348901a741290be83d094~zBDDio8Xg0754307543epoutp02j
        for <fio@vger.kernel.org>; Thu, 22 Dec 2022 04:48:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221222044814epoutp02e774b623ce4348901a741290be83d094~zBDDio8Xg0754307543epoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1671684494;
        bh=nIcwU94CAdpTB6q5sf7DW651JFiNmyPJ3BsiNOfM9+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hO0+qSdubv1mVSbutGmfkQYvbGMyn3NXWbfrtmotzgPfE7TlSJeapvztL+H3FE82o
         Co+1UmV/Vie3VOdUuZe1Fb73QF00M2I/xVPfvoZlaC4d9E9FEwgOWnuxbb+q4/WE4d
         EHfZ3oBxabZPP1HTZ+ZiXQxau9UZDZHnPzuvU3FQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221222044814epcas5p229876aa45f0457b8084605c92d9eca7b~zBDDAOuZt0954709547epcas5p2u;
        Thu, 22 Dec 2022 04:48:14 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4NcyVh26M6z4x9Q0; Thu, 22 Dec
        2022 04:48:12 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7E.98.03362.781E3A36; Thu, 22 Dec 2022 13:48:07 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221222044042epcas5p1d8fc77f1bf60d9857d6073a3e2c73ddb~zA8eSkNL01237812378epcas5p1L;
        Thu, 22 Dec 2022 04:40:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221222044042epsmtrp103ff4dc5fce716eff07caab7b3c87549~zA8eR5tow0236302363epsmtrp1G;
        Thu, 22 Dec 2022 04:40:42 +0000 (GMT)
X-AuditID: b6c32a4b-4e5fa70000010d22-11-63a3e1872c5f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        64.64.02211.ACFD3A36; Thu, 22 Dec 2022 13:40:42 +0900 (KST)
Received: from green.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221222044041epsmtip18d9ddb0a61295b3b1de8ef8f53eff2b1~zA8dV2lrt0411404114epsmtip1x;
        Thu, 22 Dec 2022 04:40:41 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com, simon.lund@samsung.com,
        m.ynddal@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 2/4] engines/xnvme: user space vfio based backend
Date:   Thu, 22 Dec 2022 10:09:49 +0530
Message-Id: <20221222043951.24590-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221222043951.24590-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsWy7bCmhm77w8XJBp0NlhZrrvxmt1h9t5/N
        4uOsF8wWk341Mlrc7Z7BbrGhTdCBzWPnrLvsHpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJq
        XnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QaiWFssScUqBQQGJxsZK+
        nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsa1xtXMBVOlK569
        OcTewNgk1sXIySEhYCLx/dAK9i5GLg4hgd2MEt/P3oByPjFKHLqzmhnC+cYo8e/aDBaYlp6e
        yUwQib2MEtvnXGSDcJqYJHYcfgVWxSagLfHq7Q1mEFtEQFhif0crC0gRs0Azo8Sai2vAioQF
        HCUW3/nIBGKzCKhKPOh8CmbzCthInGnoZIJYJy+xesMBsEGcArYS05dcABskIbCJXWLJgdOM
        EEUuEn2H25ghbGGJV8e3sEPYUhIv+9ug7GyJTQ9/Qg0tkDjyoheq3l6i9VQ/kM0BdJ2mxPpd
        +hBhWYmpp9aBlTML8En0/n4C1corsWMejK0q8ffebWiwSEvcfHeVBWSMhICHxPanCZBAmcAo
        0fpoM+MERrlZCBsWMDKuYpRMLSjOTU8tNi0wzksth0dbcn7uJkZw+tLy3sH46MEHvUOMTByM
        hxglOJiVRHgvXVicLMSbklhZlVqUH19UmpNafIjRFBh+E5mlRJPzgQk0ryTe0MTSwMTMzMzE
        0tjMUEmcN3Xr/GQhgfTEktTs1NSC1CKYPiYOTqkGJssy7h8zp9fdswzjvrbh7E3Wi7HvEvjc
        l7mLGU0133NeqtBOfV9u89oi8bkTN7SsX7N3yzXz5oCd5Stffy67v4tnbeGE9m2+Kmo7ipZO
        MT0jO+uRXCUXn/frhJXcbAfO7dj0Se+r/l/Ry9PeGIk1MmqnTbqa0Xc452au3Ks0pzcT8/LC
        Dzg+1Hhu9XeV7k9/qRDx6fOePfmobCsvdWy9AL/3uhp2F7ZH072EdzttqlyZ+Ssrafq9neGK
        Donfm/+uW5d5YLbdxHsRxz9+fZTQfCbUq2G5f+/DsqOPLHdtyNk0Zf7qu42rczbwaP+OLrE+
        xPKwK/jdGdb7Wj8EZ4lF+Trvsr14xOiSvO2S6js5rl+VWIozEg21mIuKEwE+5ayd6AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42LZdlhJTvfU/cXJBvtuCVqsufKb3WL13X42
        i4+zXjBbTPrVyGhxt3sGu8WGNkEHNo+ds+6ye1w+W+rRt2UVo8fnTXIBLFFcNimpOZllqUX6
        dglcGdcaVzMXTJWuePbmEHsDY5NYFyMnh4SAiURPz2SmLkYuDiGB3YwSsy5/BHI4gBLSEgvX
        J0LUCEus/PecHaKmgUlizaedbCAJNgFtiVdvbzCD2CJARfs7WllAipgFOhkldv48wASSEBZw
        lFh85yOYzSKgKvGg8ymYzStgI3GmoZMJYoO8xOoNB8AGcQrYSkxfcoEFxBYCqlmw+yXTBEa+
        BYwMqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgsNLS3MH4/ZVH/QOMTJxMB5ilOBg
        VhLhvXRhcbIQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFIN
        THWG1t4zr0s7S38J/3h152vHOfnai0ySVr59xag6K97e+qBqpVTo8UCb6RsSlxwsCmi3NHfn
        K35WZSGdI/j4YxFr5pY37TmiIjP6A3RCelwW8KyQ+uAaKrbF6HGJ9w15I0eNREmdKvNlry+5
        8pgUz3mjyMisGiCurGTbadzVZObeEhzAuHezT0ci82HzwhyO8MtTuf0nC8gVJzof1WH1e2em
        9vzp0kTjXdfmV6Qcigx8svBr6b2TX5c0FDD/2GKkpPssiSnL1+45z23fJJ3vS02+75ZqUOvM
        cTB6FFeabMP5R756vuHb/TEJ7/6Zl3bqe7mbaUxX5+7PYfgYudS3KOznZ43FnrduB9dHK7EU
        ZyQaajEXFScCAJRgdZGeAgAA
X-CMS-MailID: 20221222044042epcas5p1d8fc77f1bf60d9857d6073a3e2c73ddb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221222044042epcas5p1d8fc77f1bf60d9857d6073a3e2c73ddb
References: <20221222043951.24590-1-ankit.kumar@samsung.com>
        <CGME20221222044042epcas5p1d8fc77f1bf60d9857d6073a3e2c73ddb@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add an option to use user-space VFIO-based backend,
implemented using libvfn.
Update xnvme engine options for missing backends.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst       | 5 ++++-
 engines/xnvme.c | 7 ++++---
 fio.1           | 6 +++++-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 97fe5350..aba6c9b3 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2845,6 +2845,9 @@ with the caveat that when used on the command line, they must come after the
 	**posix**
 		Use the posix asynchronous I/O interface to perform one or
 		more I/O operations asynchronously.
+	**vfio**
+		Use the user-space VFIO-based backend, implemented using
+		libvfn instead of SPDK.
 	**nil**
 		Do not transfer any data; just pretend to. This is mainly used
 		for introspective performance evaluation.
@@ -2875,7 +2878,7 @@ with the caveat that when used on the command line, they must come after the
 
 .. option:: xnvme_dev_nsid=int : [xnvme]
 
-	xnvme namespace identifier for userspace NVMe driver, such as SPDK.
+	xnvme namespace identifier for userspace NVMe driver, SPDK or vfio.
 
 .. option:: xnvme_iovec=int : [xnvme]
 
diff --git a/engines/xnvme.c b/engines/xnvme.c
index dcc54998..ee6b67c1 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -113,7 +113,8 @@ static struct fio_option options[] = {
 		.lname = "xNVMe Asynchronous command-interface",
 		.type = FIO_OPT_STR_STORE,
 		.off1 = offsetof(struct xnvme_fioe_options, xnvme_async),
-		.help = "Select xNVMe async. interface: [emu,thrpool,io_uring,libaio,posix,nil]",
+		.help = "Select xNVMe async. interface: "
+			"[emu,thrpool,io_uring,io_uring_cmd,libaio,posix,vfio,nil]",
 		.category = FIO_OPT_C_ENGINE,
 		.group = FIO_OPT_G_XNVME,
 	},
@@ -122,7 +123,7 @@ static struct fio_option options[] = {
 		.lname = "xNVMe Synchronous. command-interface",
 		.type = FIO_OPT_STR_STORE,
 		.off1 = offsetof(struct xnvme_fioe_options, xnvme_sync),
-		.help = "Select xNVMe sync. interface: [nvme,psync]",
+		.help = "Select xNVMe sync. interface: [nvme,psync,block]",
 		.category = FIO_OPT_C_ENGINE,
 		.group = FIO_OPT_G_XNVME,
 	},
@@ -131,7 +132,7 @@ static struct fio_option options[] = {
 		.lname = "xNVMe Admin command-interface",
 		.type = FIO_OPT_STR_STORE,
 		.off1 = offsetof(struct xnvme_fioe_options, xnvme_admin),
-		.help = "Select xNVMe admin. cmd-interface: [nvme,block,file_as_ns]",
+		.help = "Select xNVMe admin. cmd-interface: [nvme,block]",
 		.category = FIO_OPT_C_ENGINE,
 		.group = FIO_OPT_G_XNVME,
 	},
diff --git a/fio.1 b/fio.1
index 1074b52a..004d3ba0 100644
--- a/fio.1
+++ b/fio.1
@@ -2584,6 +2584,10 @@ Use Linux aio for Asynchronous I/O
 Use the posix asynchronous I/O interface to perform one or more I/O operations
 asynchronously.
 .TP
+.BI vfio
+Use the user-space VFIO-based backend, implemented using libvfn instead of
+SPDK.
+.TP
 .BI nil
 Do not transfer any data; just pretend to. This is mainly used for
 introspective performance evaluation.
@@ -2621,7 +2625,7 @@ Use Linux Block Layer ioctl() and sysfs for admin commands.
 .RE
 .TP
 .BI (xnvme)xnvme_dev_nsid\fR=\fPint
-xnvme namespace identifier for userspace NVMe driver such as SPDK.
+xnvme namespace identifier for userspace NVMe driver SPDK or vfio.
 .TP
 .BI (xnvme)xnvme_iovec
 If this option is set, xnvme will use vectored read/write commands.
-- 
2.17.1

