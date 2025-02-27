Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966DE21B9CB
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639831; cv=none; b=uMOUZyTfF/RIkW3bqw1MoX+a2079CkA61woAJad/7TePshN80478tEBEPgWkuG5vFQZbG2BNKfcURGvFg75400swNtzR5avOn+DJlTk2/0boAwMxCH8eFfH0yEf8UDA4vE27SlhzSDqCRPWt0927PHh3GrBCa7g8qbPzRNvkoSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639831; c=relaxed/simple;
	bh=oXhtPyFWN9idJNvUpycGWSsKp7GaSpUqQd5JZHwF2Bo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=HWBZbmap5s9dFni7BlH4JoJJfmNyQ6aaSADp7UNpM+XoV6f7L0ZdPhW24USbW9ILZo2sr1XoIf8EIU2YPcSDGh/dv8O2kPFaN1790scdmlRI/tR21+R7ETwI/N4zmhRRqP1CKDVEXu9p8lSPqHa4DbE9QmWgTI+0/BIn5CxEYbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XxG5weTn; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XxG5weTn"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250227070342epoutp027d17c8f5982fd3511a5e2a45f55cdf35~n-rIi1PnV1628716287epoutp02D
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250227070342epoutp027d17c8f5982fd3511a5e2a45f55cdf35~n-rIi1PnV1628716287epoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639822;
	bh=8NvqFGLNk3PViua+R2sdCJXB8bNEBMZsBEDt9yNVnxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XxG5weTnD7pt5hlQLDjnLDnWE52uhg0H3so94SltNoKsGb12rrSN5RXj4o0u28yKi
	 wKf5N4oPvnJgE/g69hBCamSH2iSRqzwZzHXq+DKYm2wpaniZyoMu0M0FCUxASxzLxY
	 ew41QBt1LwDjp+XxpQLgGgo4Cq/t/i5AdY5HR3R4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20250227070341epcas5p1bedcbc65bbb96aaeb32ac98906f92ce8~n-rIVwE4t0319303193epcas5p1R;
	Thu, 27 Feb 2025 07:03:41 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Z3Mkg7397z4x9Pv; Thu, 27 Feb
	2025 07:03:39 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	50.C1.20052.B4E00C76; Thu, 27 Feb 2025 16:03:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250227053352epcas5p4a23427648652b41f186022f058b42e64~n_ctg1x7o0969609696epcas5p4E;
	Thu, 27 Feb 2025 05:33:52 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250227053352epsmtrp1031419519b7adeac0fa38d8cfcb8e2d0~n_ctgLdM41011210112epsmtrp1W;
	Thu, 27 Feb 2025 05:33:52 +0000 (GMT)
X-AuditID: b6c32a49-3d20270000004e54-9f-67c00e4bc35d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D2.A3.18729.049FFB76; Thu, 27 Feb 2025 14:33:52 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053352epsmtip265ccdb36adfe05b5e94d4c4540036d8e~n_cszsX1R1586815868epsmtip2g;
	Thu, 27 Feb 2025 05:33:52 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 03/21] init: write sequence behavior change for verify_only
 mode
Date: Thu, 27 Feb 2025 16:17:09 +0530
Message-Id: <20250227104727.1794982-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmhq4334F0g4vXOSzWXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
	jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOOPLqKXNBr0BFz+6vrA2MbbxdjBwc
	EgImEq8ne3QxcnEICexmlHi07AwThPOJUWLL9HlsEM43RokVr6YwdjFygnWsffSAGSKxl1Fi
	zub/UFU/GCVmf53LAlLFJqAt8ertDWaQHSICGhJr7qaChJkF7CSuHn7JBmILCwRJ9E5azgpS
	wiKgKjFrCQdImBeo5Pzcx6wQu+QlZl76zg5icwrYS7zpbGSBqBGUODnzCQvESHmJ5q2zwe6R
	EDjFLrHmZw8zRLOLxNPWYywQtrDEq+Nb2CFsKYmX/W1QdrbEpoc/mSDsAokjL3qheu0lWk/1
	g53PLKApsX6XPkRYVmLqqXVMEHv5JHp/P4Fq5ZXYMQ/GVpX4e+821FppiZvvrkLZHhKTvv9g
	gQTVJEaJpQdvsk9gVJiF5J9ZSP6ZhbB6ASPzKkbJ1ILi3PTUYtMCw7zUcngcJ+fnbmIEJ0Et
	zx2Mdx980DvEyMTBeIhRgoNZSYSXM3NPuhBvSmJlVWpRfnxRaU5q8SFGU2B4T2SWEk3OB6bh
	vJJ4QxNLAxMzMzMTS2MzQyVx3uadLelCAumJJanZqakFqUUwfUwcnFINTAFSIfu7vjuKLTmz
	Y7lSW4rpMfM3ch1LrDt/Z+Ssbv2lqTmlXuTJwy4Z4ajJV8OuLm7+0q8lsFBp393cCKmLrELK
	7cwVFavUrofPmLBw8rIFk3o61YN/eNvMmXHps9KOR0ofj8ksY69ocsrjmVv7T32SqBGz2aaU
	pcvzf/AttjyeyaUaPOMX981tmxfxlm5b9zlc7K7fHreLR94JcIvsrF2zX65VOoEvOE8ny2tm
	vO6Fklr36Qd84v7VGNwVzuYUmvGooJbx1aPdT6cuabKqrH7y1uNhLFdi+wwVhQwJB5c4x8mJ
	ky4vjL4p9PxEncGXqK8TXOdaWM9Q+ed/7xBz85tVac2Jl59LiAm/YGisVWIpzkg01GIuKk4E
	AO+jS1YLBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsWy7bCSvK7Dz/3pBjPmG1usufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJVx5NVT5oJe
	gYqe3V9ZGxjbeLsYOTkkBEwk1j56wNzFyMUhJLCbUWLxlvssXYwcQAlpiYXrEyFqhCVW/nvO
	DhIWEvjGKLGTESTMJqAt8ertDWYQW0RAS+LYuiY2EJtZwEHi364tbCDlwgIBEpeWBYGYLAKq
	ErOWcIBU8ArYSZyf+5gVYri8xMxL39lBbE4Be4k3nY0sILYQUM2Cid+YIOoFJU7OfMICMV1e
	onnrbOYJjAKzkKRmIUktYGRaxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHKBamjsY
	t6/6oHeIkYmD8RCjBAezkggvZ+aedCHelMTKqtSi/Pii0pzU4kOM0hwsSuK84i96U4QE0hNL
	UrNTUwtSi2CyTBycUg1MS+beFr6z/bKEfPjfL5NS6j5HXePOM592LODn2mSXqV1tZl+a/DbP
	t9O53H/6yZwTDyNKwy6v3lSWwNjAJOO0y2uu2nsV2aDJFf9X9DdMeKP78/dUhbSfHPq5b5Jk
	OGtswt9zsrpcu/vnoHRWa0ym8NVjWVnbP4Z6X7UIZr1TtrVCPmKbgpbF1sJuBoVS+Z8dDCFn
	VjQcc2YwOvfOe+qdxfXRz3KSBDfO1ZJMW73V/tDTKY/sVvO1nft1OzPatfrQzMOKp0v0zTif
	PGlc4bGf33nBw59yFZJMyzlmyZ+4Nq3MeL1Q3v4P158mfVS9P2+aS82vo1OUrX5m1ctc3Jqx
	qebv/RVybi8n8drJ6DDkKLEUZyQaajEXFScCAEf563u/AgAA
X-CMS-MailID: 20250227053352epcas5p4a23427648652b41f186022f058b42e64
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053352epcas5p4a23427648652b41f186022f058b42e64
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053352epcas5p4a23427648652b41f186022f058b42e64@epcas5p4.samsung.com>

Change the behavior for verify_only mode to not disable
verify_write_sequence unless its explicitly enabled.

Update the fio doc. accordingly.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 3 ++-
 fio.1     | 3 ++-
 init.c    | 6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 3f2bde18..c7c131e7 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3816,7 +3816,8 @@ Verification
 	invocation of this workload. This option allows one to check data multiple
 	times at a later date without overwriting it. This option makes sense only
 	for workloads that write data, and does not support workloads with the
-	:option:`time_based` option set.
+	:option:`time_based` option set. :option:`verify_write_sequence` will be
+	disabled in this mode, unless its explicitly enabled.
 
 .. option:: do_verify=bool
 
diff --git a/fio.1 b/fio.1
index 3c5f02b3..88d3be81 100644
--- a/fio.1
+++ b/fio.1
@@ -3542,7 +3542,8 @@ Do not perform specified workload, only verify data still matches previous
 invocation of this workload. This option allows one to check data multiple
 times at a later date without overwriting it. This option makes sense only
 for workloads that write data, and does not support workloads with the
-\fBtime_based\fR option set.
+\fBtime_based\fR option set. \fBverify_write_sequence\fR option will be
+disabled in this mode, unless its explicitly enabled.
 .TP
 .BI do_verify \fR=\fPbool
 Run the verify phase after a write phase. Only valid if \fBverify\fR is
diff --git a/init.c b/init.c
index 96a03d98..dc3e7ed1 100644
--- a/init.c
+++ b/init.c
@@ -854,8 +854,10 @@ static int fixup_options(struct thread_data *td)
 			o->verify_interval = gcd(o->min_bs[DDIR_WRITE],
 							o->max_bs[DDIR_WRITE]);
 
-		if (td->o.verify_only)
-			o->verify_write_sequence = 0;
+		if (o->verify_only) {
+			if (!fio_option_is_set(o, verify_write_sequence))
+				o->verify_write_sequence = 0;
+		}
 	}
 
 	if (td->o.oatomic) {
-- 
2.25.1

