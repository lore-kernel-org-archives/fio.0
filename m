Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F57721D595
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639838; cv=none; b=SvcfzOn6rgcZpYZpN9B4UJRetKg5ezbti1pHJGqrTOQSkyRiPQPcJSbRGqsMfrUtf0HM1C188e0zOZNyG1JoQGST3zyVVIELA2dL28TQg5vvVBTNUuDecJwTBfJy8eJG63mZKMRzdkw4QAsQcQwFY4Tb4WDA8H1bzQzuxzBKfW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639838; c=relaxed/simple;
	bh=ldw5jo/Zl6+a+5yHevlCSWHJKxdBCUN7/nZUCKfgkQE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=idjVN3zal+weDyP0jwBBJSsTltVWHfHqyJLJYz6UhsvWy8khcJCHt/AYykMEv0du3y8xWp6BX9NFaVi/Qt7FNiHKHp9kRK47Fckw6iptqDZtrYT5jJ7M+n2sm4bOtfUAb7kyU5swuBph1scAvpUtHHDmiR4wros6eYzOrxmgEnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=sTx0bg9h; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sTx0bg9h"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250227070354epoutp0268fb8a63e8382abb671bb2e66fd7f02d~n-rUGR1I61433914339epoutp02h
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250227070354epoutp0268fb8a63e8382abb671bb2e66fd7f02d~n-rUGR1I61433914339epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639834;
	bh=MnhUvBN6HPeu7M4dH58E8VSqJow2rBM4raOUAHGW99Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTx0bg9hkl3Xha+TCuVyI4zGzR1Lo0sfoEk9G8MSj8g5O+Bwdmd6DlrmUpL0crBDK
	 2JGi1iSCfB+8WGQ5ib1KBM2jK4DvNGtgHl2ZcE9tLISy9GhjZtt/yJ4+hwrzXLiPWI
	 mo1vMnWKcVmzc0VcfbkS60BdnsjwTOjiILtr8uLM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20250227070354epcas5p416a6acd1aab33ee1afda51ee3a0fd769~n-rTzEogi0845808458epcas5p4r;
	Thu, 27 Feb 2025 07:03:54 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Z3Mkw2dd2z4x9Pp; Thu, 27 Feb
	2025 07:03:52 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F5.B2.19710.75E00C76; Thu, 27 Feb 2025 16:03:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250227053356epcas5p44dcd9c9219192e5d7ecd7cf6280a3b46~n_cw3OXrf0987109871epcas5p4E;
	Thu, 27 Feb 2025 05:33:56 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250227053356epsmtrp28efe4f9c57b2980f63246009ec31d228~n_cw2m1wP2933029330epsmtrp2C;
	Thu, 27 Feb 2025 05:33:56 +0000 (GMT)
X-AuditID: b6c32a44-36bdd70000004cfe-2a-67c00e575303
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	CF.DA.33707.449FFB76; Thu, 27 Feb 2025 14:33:56 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053355epsmtip25f160d3662ffaac21db2782c2ff77e3a~n_cwKkFg71753517535epsmtip2d;
	Thu, 27 Feb 2025 05:33:55 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 07/21] verify: disable header seed check for verify_only
 jobs
Date: Thu, 27 Feb 2025 16:17:13 +0530
Message-Id: <20250227104727.1794982-8-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmhm4434F0gwUPTC3WXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
	jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjO2LBwPVvBSZGKbytbWBoY3wl0MXJy
	SAiYSMyfcZ+pi5GLQ0hgN6PE07/H2SGcT4wS90/sZIRz/nyYxwzT8vTBaxaIxE5GiUXXO5gh
	nB+MEo8X/wSrYhPQlnj19gaQzcEhIqAhseZuKkiYWcBO4urhl2wgtrCAv8TmW2eYQGwWAVWJ
	HVvmgLXyAtXcfbaFDWKZvMTMS9/ZQWxOAXuJN52NLBA1ghInZz5hgZgpL9G8dTbYDRICx9gl
	5r5ezgjR7CKxru8Z1NXCEq+Ob2GHsKUkPr/bC7UgW2LTw59MEHaBxJEXvVD19hKtp/rB7mcW
	0JRYv0sfIiwrMfXUOiaIvXwSvb+fQLXySuyYB2OrSvy9d5sFwpaWuPnuKpTtITH7301o8E5i
	lDh2+SnbBEaFWUj+mYXkn1kIqxcwMq9ilEwtKM5NT002LTDMSy2Hx3Jyfu4mRnAi1HLZwXhj
	/j+9Q4xMHIyHGCU4mJVEeDkz96QL8aYkVlalFuXHF5XmpBYfYjQFBvhEZinR5HxgKs4riTc0
	sTQwMTMzM7E0NjNUEudt3tmSLiSQnliSmp2aWpBaBNPHxMEp1cD0wPIlT/KBC6U9bNt1Tt6s
	e9BTInC8r+7tkyUpXvfE5u+0rLG5F/9t18kZkke4fvlX931o3r1v3YRN+4XvMHH/nv+z8d0k
	fe/F07c4cSz91Xbbed0l+6U2Fkrz5NYw7I77tUjjT96UhGgh928GdU1v303gs7wT/en481+N
	+sHnTqx5d2flpLwrDxZsW+Da2FN8uc/huPbFzQGvP1xMP5rwY+rxB8a6586v3ZPC+e5azJ9J
	yec1OQJvBp3bu+umUrzsp+QvMVV1Z28YJXhtlS96bMTCUnn0L/Ok6pmv69TVHV9WXC48sWm2
	wtPMx6rH1aoPTOu50fDG8dgimax8NaF+Q+4vNZITn/j9W2pYus3+9VwlluKMREMt5qLiRADp
	HSGLDQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsWy7bCSvK7Lz/3pBq33pSzWXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4MrYsHA9W8FJ
	kYpvK1tYGhjfCXQxcnJICJhIPH3wmqWLkYtDSGA7o8Srp43sXYwcQAlpiYXrEyFqhCVW/nvO
	DlHzjVHi6akLTCAJNgFtiVdvbzCD2CICWhLH1jWxgdjMAg4S/3ZtAbOFBXwlfl24zQJiswio
	SuzYMgesnlfATuLuM4gaCQF5iZmXvrOD2JwC9hJvOhvB6oWAahZM/MYEUS8ocXLmExaI+fIS
	zVtnM09gFJiFJDULSWoBI9MqRtHUguLc9NzkAkO94sTc4tK8dL3k/NxNjOAA1Qrawbhs/V+9
	Q4xMHIyHGCU4mJVEeDkz96QL8aYkVlalFuXHF5XmpBYfYpTmYFES51XO6UwREkhPLEnNTk0t
	SC2CyTJxcEo1MPHM+Prk8ctlu/7uEk3kqyhcaMTrULmXPfd42O3DH2cWNhh4HHqvN9Vrq5Bp
	W81ixyNfyi9r7Z43zbt0wdMzEsIz1mWXiBbvS5/h3HTWVuZVt9TBEzwPniv2Z/EoLpiZy11e
	yxKtz37woaJulnXPRReGve94QtglNe26tpqv5f6/1fp9YanHhu/x6hdn7fzWrrjoodHsXXWf
	z68K5P7yMKvwWrHeu4J9GzvPnUxeed2s6pl+W6/K2pXKphKvfTrmM0kfttb+G/3OQj1no4vv
	98/PhWYwCfKVhB5cNHFpwaV95+0OLW519/hlo+xpkprzKIh1rWz9PfUkc+nZKxbscDkedNVF
	88mT052H+edZ/FNiKc5INNRiLipOBADi5MepvwIAAA==
X-CMS-MailID: 20250227053356epcas5p44dcd9c9219192e5d7ecd7cf6280a3b46
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053356epcas5p44dcd9c9219192e5d7ecd7cf6280a3b46
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053356epcas5p44dcd9c9219192e5d7ecd7cf6280a3b46@epcas5p4.samsung.com>

For the invoked verify_only job, header seed can match only if it
exactly matches the original write job. This means either randrepeat
should be true, or we must use the same randseed which was used with the
original write job. After write the verify_only workload shouldn't be
changed from sequential to random or vice versa.

Considering these constraints disable verify_header_seed for verify_only
jobs. Users will still be able to enable header seed checking if they
explicitly set the verify_header_sequence option.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 5 +++--
 fio.1     | 5 +++--
 init.c    | 3 +++
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index a221b9d8..05bdeebb 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3816,8 +3816,9 @@ Verification
 	invocation of this workload. This option allows one to check data multiple
 	times at a later date without overwriting it. This option makes sense only
 	for workloads that write data, and does not support workloads with the
-	:option:`time_based` option set. :option:`verify_write_sequence` will be
-	disabled in this mode, unless its explicitly enabled.
+	:option:`time_based` option set. :option:`verify_write_sequence` and
+	:option:`verify_header_seed` will be disabled in this mode, unless they are
+	explicitly enabled.
 
 .. option:: do_verify=bool
 
diff --git a/fio.1 b/fio.1
index dd6d9546..1342a23a 100644
--- a/fio.1
+++ b/fio.1
@@ -3542,8 +3542,9 @@ Do not perform specified workload, only verify data still matches previous
 invocation of this workload. This option allows one to check data multiple
 times at a later date without overwriting it. This option makes sense only
 for workloads that write data, and does not support workloads with the
-\fBtime_based\fR option set. \fBverify_write_sequence\fR option will be
-disabled in this mode, unless its explicitly enabled.
+\fBtime_based\fR option set. Options \fBverify_write_sequence\fR and
+\fBverify_header_seed\fR will be disabled in this mode, unless they are
+explicitly enabled.
 .TP
 .BI do_verify \fR=\fPbool
 Run the verify phase after a write phase. Only valid if \fBverify\fR is
diff --git a/init.c b/init.c
index 7a1a6840..3d6230cb 100644
--- a/init.c
+++ b/init.c
@@ -857,6 +857,9 @@ static int fixup_options(struct thread_data *td)
 		if (o->verify_only) {
 			if (!fio_option_is_set(o, verify_write_sequence))
 				o->verify_write_sequence = 0;
+
+			if (!fio_option_is_set(o, verify_header_seed))
+				o->verify_header_seed = 0;
 		}
 
 		/*
-- 
2.25.1

