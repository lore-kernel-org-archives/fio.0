Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99410C001B2
	for <fio@archiver.kernel.org>; Thu, 22 Dec 2022 04:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiLVEsZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 21 Dec 2022 23:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbiLVEsU (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Dec 2022 23:48:20 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6051AF08
        for <fio@vger.kernel.org>; Wed, 21 Dec 2022 20:48:17 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221222044815epoutp02ff357bdfc3f61a9b69449f3754275620~zBDEXZ3_c0751207512epoutp02Z
        for <fio@vger.kernel.org>; Thu, 22 Dec 2022 04:48:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221222044815epoutp02ff357bdfc3f61a9b69449f3754275620~zBDEXZ3_c0751207512epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1671684495;
        bh=QaiIoBHps7j/UkFsmu2SFWot7aAOgl9bs5XobqsOMbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1lfsSiCtdjoLpjlZqILYrN95cDWlmdsfMoj1HbGRYPIFz4il35FJvHUmJdGZZ9Av
         JkX0ZCqZWvS3MloKRm0lCNCPs9NvxCunz0KYcgMQK8smtBlgNbNNLlGrmzh4El5tS0
         Z+48NdV6obc7F/nsnOPBV7TN09MtWk3xho8XPgSk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221222044815epcas5p470833dcfcff0615006d16fb44921039a~zBDEIP05Q0895308953epcas5p4h;
        Thu, 22 Dec 2022 04:48:15 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4NcyVk0h0Pz4x9Pp; Thu, 22 Dec
        2022 04:48:14 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        11.A8.03362.D81E3A36; Thu, 22 Dec 2022 13:48:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221222044043epcas5p100b3fb17f0ef0ae019461cbc38ab9342~zA8fWzpKy1237912379epcas5p1O;
        Thu, 22 Dec 2022 04:40:43 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221222044043epsmtrp22c0ccf100f83dd6cc49b9c38c7983712~zA8fV1m-y0798207982epsmtrp2R;
        Thu, 22 Dec 2022 04:40:43 +0000 (GMT)
X-AuditID: b6c32a4b-4e5fa70000010d22-25-63a3e18d9646
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        29.12.10542.BCFD3A36; Thu, 22 Dec 2022 13:40:43 +0900 (KST)
Received: from green.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221222044042epsmtip1af53c14d911ce69d9367f4e049648ab3~zA8eZDcQG0424304243epsmtip1T;
        Thu, 22 Dec 2022 04:40:42 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com, simon.lund@samsung.com,
        m.ynddal@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 3/4] engines/xnvme: add subnqn to fio-options
Date:   Thu, 22 Dec 2022 10:09:50 +0530
Message-Id: <20221222043951.24590-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221222043951.24590-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsWy7bCmlm7vw8XJBl3bJS3WXPnNbrH6bj+b
        xcdZL5gtJv1qZLS42z2D3WJDm6ADm8fOWXfZPS6fLfXo27KK0ePzJrkAlqhsm4zUxJTUIoXU
        vOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg1UoKZYk5pUChgMTiYiV9
        O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7Iy765czFpwWqXi4
        7B97A+MxgS5GTg4JAROJzZP3snQxcnEICexmlNiz6z8jhPOJUWLfifmsEM5nRon3TZ8YYVrW
        PFgPldjFKHHh/yZ2CKeJSeLLgUZWkCo2AW2JV29vMIPYIgLCEvs7WsGWMAs0M0qsubiGBSQh
        LGAr8WX/G7CxLAKqEu8/7waL8wrYSHw62sQMsU5eYvWGA2A2J1D99CUXwAZJCOxil3jYe4oV
        oshFYu3dBywQtrDEq+Nb2CFsKYnP7/ayQdjZEpse/mSCsAskjrzohVpgL9F6qh/I5gC6TlNi
        /S59iLCsxNRT68DKmQX4JHp/P4Fq5ZXYMQ/GVpX4e+821FppiZvvrkLZHhIPN72DBuQERokr
        Jy+wTGCUm4WwYgEj4ypGydSC4tz01GLTAuO81HJ4vCXn525iBCcwLe8djI8efNA7xMjEwXiI
        UYKDWUmE99KFxclCvCmJlVWpRfnxRaU5qcWHGE2BATiRWUo0OR+YQvNK4g1NLA1MzMzMTCyN
        zQyVxHlTt85PFhJITyxJzU5NLUgtgulj4uCUamB60XA/2HbZXAknRsaFt19N2Kk4KWXNLcVF
        lpzHNiy8G6Z9QmLPVfEHicxqjBYKi7yPXbRZItVXw+t5eNIEqVmiBfdTLD1ux/JNLXoUIuR7
        egX3xZoW9ejF5lfqMk/oXavVPS/gLNw74QKD7Paz839W/3o461mcnc2E9QbTcuoyi/0W3zrw
        d4K6G2/XXe4X99pzDqxrFZvEp7xXzO0Kb9jklLklhh0BHs1Lnp7icZzyYJ79l7nWG2dtPpa3
        p07Sl93X4v2xqSlhb1zeXdhn9P2ewdaI+6sXn9upZNa2d5uodnFY8QT7iNf3D/oGnHk0jVnf
        q/x11z211IZHnXlHFny6NcWmvelU3p2Nx4yeWs6+qcRSnJFoqMVcVJwIAAK4fp/pAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42LZdlhJTvf0/cXJBs+uSFqsufKb3WL13X42
        i4+zXjBbTPrVyGhxt3sGu8WGNkEHNo+ds+6ye1w+W+rRt2UVo8fnTXIBLFFcNimpOZllqUX6
        dglcGXfXL2csOC1S8XDZP/YGxmMCXYycHBICJhJrHqxnBbGFBHYwSmxYmN/FyAEUl5ZYuD4R
        okRYYuW/5+xdjFxAJQ1MEvO2LQOrZxPQlnj19gYziC0CVLS/o5UFpIhZoJNRYufPA0wgCWEB
        W4kv+98wgtgsAqoS7z/vZgGxeQVsJD4dbWKG2CAvsXrDATCbE6h++pILLBAH2Ugs2P2SaQIj
        3wJGhlWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMHBpaW1g3HPqg96hxiZOBgPMUpw
        MCuJ8F66sDhZiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6p
        Bqb8/clHqv4GufZwWf0Ws7xennGTJz53z8tH35ms9skmzFKpFzv8eIu/Ur9l+qzduyabx755
        npKueeLzn/I9S7MXJ52TM1DTqJO4n6ibd+SOiMNv/aS3PL/m6RkpvfouxW+4efe+D3pMh//V
        TO39vvrfNf+vS5xkF/3ktb0R9V//00c//5zjJa1m7b4rmkJ2Jp6XMXQN/Lrg6skb77eu+sDy
        ZtEEk19v41dcOWYtfe+w3YGc5rNS8unZjS26ntE/FQ7NCLtReeveBeN5VUzuHnd4P799fdTM
        8ZCRRvaqpv4ZF0XLNdinbm1VFrt9ruR1fr3M9RfvTi4WzZph9PPGRuOoyAVrl2vKRa/q3z89
        UsNZiaU4I9FQi7moOBEAEJX+vp0CAAA=
X-CMS-MailID: 20221222044043epcas5p100b3fb17f0ef0ae019461cbc38ab9342
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221222044043epcas5p100b3fb17f0ef0ae019461cbc38ab9342
References: <20221222043951.24590-1-ankit.kumar@samsung.com>
        <CGME20221222044043epcas5p100b3fb17f0ef0ae019461cbc38ab9342@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

For fio to utilize a fabrics target with multiple systems, it needs a
way for the user to specify which subsystem to use. This is done by
providing 'subnqn' as fio-option.

Signed-off-by: Simon A. F. Lund <simon.lund@samsung.com>
Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst       |  5 +++++
 engines/xnvme.c | 11 +++++++++++
 fio.1           |  4 ++++
 3 files changed, 20 insertions(+)

diff --git a/HOWTO.rst b/HOWTO.rst
index aba6c9b3..0fec38a7 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2880,6 +2880,11 @@ with the caveat that when used on the command line, they must come after the
 
 	xnvme namespace identifier for userspace NVMe driver, SPDK or vfio.
 
+.. option:: xnvme_dev_subnqn=str : [xnvme]
+
+	Sets the subsystem NQN for fabrics. This is for xNVMe to utilize a
+	fabrics target with multiple systems.
+
 .. option:: xnvme_iovec=int : [xnvme]
 
 	If this option is set. xnvme will use vectored read/write commands.
diff --git a/engines/xnvme.c b/engines/xnvme.c
index ee6b67c1..208d917d 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -78,6 +78,7 @@ struct xnvme_fioe_options {
 	char *xnvme_async;
 	char *xnvme_sync;
 	char *xnvme_admin;
+	char *xnvme_dev_subnqn;
 };
 
 static struct fio_option options[] = {
@@ -145,6 +146,15 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group = FIO_OPT_G_XNVME,
 	},
+	{
+		.name = "xnvme_dev_subnqn",
+		.lname = "Subsystem nqn for Fabrics",
+		.type = FIO_OPT_STR_STORE,
+		.off1 = offsetof(struct xnvme_fioe_options, xnvme_dev_subnqn),
+		.help = "Subsystem NQN for Fabrics",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_XNVME,
+	},
 	{
 		.name = "xnvme_iovec",
 		.lname = "Vectored IOs",
@@ -181,6 +191,7 @@ static struct xnvme_opts xnvme_opts_from_fioe(struct thread_data *td)
 	struct xnvme_opts opts = xnvme_opts_default();
 
 	opts.nsid = o->xnvme_dev_nsid;
+	opts.subnqn = o->xnvme_dev_subnqn;
 	opts.be = o->xnvme_be;
 	opts.async = o->xnvme_async;
 	opts.sync = o->xnvme_sync;
diff --git a/fio.1 b/fio.1
index 004d3ba0..134aed54 100644
--- a/fio.1
+++ b/fio.1
@@ -2627,6 +2627,10 @@ Use Linux Block Layer ioctl() and sysfs for admin commands.
 .BI (xnvme)xnvme_dev_nsid\fR=\fPint
 xnvme namespace identifier for userspace NVMe driver SPDK or vfio.
 .TP
+.BI (xnvme)xnvme_dev_subnqn\fR=\fPstr
+Sets the subsystem NQN for fabrics. This is for xNVMe to utilize a fabrics
+target with multiple systems.
+.TP
 .BI (xnvme)xnvme_iovec
 If this option is set, xnvme will use vectored read/write commands.
 .TP
-- 
2.17.1

