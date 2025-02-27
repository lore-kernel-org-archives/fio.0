Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C878D2206B3
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639862; cv=none; b=H5qjMNiBAE8fdbsU3cxNsN4w0QUycsA5WKFghkN4HWUUOJEEAIgoi099wjN1Lh9x9Kj5txP3/plzJY3G8rvcXjTdfuFufNhBg9T5zeYd7zrvuYp9qbrhcsg3eOSzGfl8LhhI0zsXm4OZiGEa5fkwn9AfHZm2v7mo/pEosSWc9Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639862; c=relaxed/simple;
	bh=1CUT0XKUBfBVk7RSQACGoRMHriythnNVZDSrXANn0II=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=KJpNWGw7Rb6sB1hvUVzSaZ4f6BFF3h3yy3Dxg9/ULBJyatCEoQTId371boBxKsEDgG9nN+46gBOlmkEGOmpNQUbboR8LlnpWO9Fa3IzNw5bqxsxjimokV887KlsscIczh8tL4g/YpY6eMwnNZEIHrN6grM1VOxkIf/TSpJMO9YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kvz0aM7q; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kvz0aM7q"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250227070418epoutp04a390b9113843629866bba04749fc40ee~n-rq70uZk2468124681epoutp04a
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250227070418epoutp04a390b9113843629866bba04749fc40ee~n-rq70uZk2468124681epoutp04a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639859;
	bh=GI/06E4xHtQHExDDD/pbyKFE2cjzgkefyT/9WFkL0FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvz0aM7q3ePT1UIDFIbm1/fsB96CgdZR8BMY4RUetJYr7J4Mtgc7bzrtN14n6COlo
	 WVI9yG4sFX77aRlhAF8AP4A/OSjiuwJdCpU34HOTHnEuZTfresYophS5wo6J6CCHp3
	 utYp5tzfUFWhQnp80rEyfkAqG2d3XCHZ/TzZWCaQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20250227070418epcas5p4ab5646e6dc99a1783cb90be9ba66e285~n-rquHcBc1979319793epcas5p4U;
	Thu, 27 Feb 2025 07:04:18 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Z3MlP1c5jz4x9QL; Thu, 27 Feb
	2025 07:04:17 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2D.7B.19956.F6E00C76; Thu, 27 Feb 2025 16:04:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250227053403epcas5p4e470dca673eadd6c1f44cf5045053504~n_c3yDIA90510105101epcas5p4K;
	Thu, 27 Feb 2025 05:34:03 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250227053403epsmtrp1e44efb3902970c7120fb5326622266d3~n_c3xZs6g1040410404epsmtrp1u;
	Thu, 27 Feb 2025 05:34:03 +0000 (GMT)
X-AuditID: b6c32a4b-fe9f470000004df4-d2-67c00e6fb408
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BE.A3.18729.B49FFB76; Thu, 27 Feb 2025 14:34:03 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053403epsmtip2878646871e4f0550d7935cdd1bcfe817~n_c3Bcymn1753517535epsmtip2-;
	Thu, 27 Feb 2025 05:34:02 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 15/21] t/fiotestcommon: do not require nvmecdev argument for
 Requirements
Date: Thu, 27 Feb 2025 16:17:21 +0530
Message-Id: <20250227104727.1794982-16-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmum4+34F0g7/P5S1W3+1ns/g46wWz
	xePuDkaLDW2CDiweO2fdZfe4fLbUo2/LKkaPz5vkAliism0yUhNTUosUUvOS81My89JtlbyD
	453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYqKZQl5pQChQISi4uV9O1sivJLS1IVMvKL
	S2yVUgtScgpMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7IzJqwpKPjOXnH29xzmBsYFbF2MnBwS
	AiYSfU/6WbsYuTiEBHYzSnSvXswC4XxilFjbPwGsSkjgG6PEkRVRMB0r3z5jgyjayyhx7u5t
	ZgjnB6NE+8c1zCBVbALaEq/e3gCyOThEBDQk1txNBQkzC9hINK/cxw5iCwtES9xtucECYrMI
	qEosvHqGBaScV8BeovtyBMQueYmZl76DlXMChd90NoKV8woISpyc+YQFYqS8RPPW2WAnSAgc
	YpfYM7cP6jUXiU8nQF4DsYUlXh3fwg5hS0m87G+DsrMlNj38yQRhF0gcedHLDGHbS7Se6gc7
	n1lAU2L9Ln2IsKzE1FPrmCD28kn0/n4C1corsWMejK0q8ffebRYIW1ri5rurULaHxLu+zeyQ
	oJrEKPH1cyfjBEaFWUj+mYXkn1kIqxcwMq9ilEwtKM5NTy02LTDOSy2HR3Fyfu4mRnAK1PLe
	wfjowQe9Q4xMHIyHGCU4mJVEeDkz96QL8aYkVlalFuXHF5XmpBYfYjQFhvdEZinR5HxgEs4r
	iTc0sTQwMTMzM7E0NjNUEudt3tmSLiSQnliSmp2aWpBaBNPHxMEp1cCUWvdaxcNnpbhPe7nn
	9b03Ah/EtMyRfb5xyoGY4reles6J8+4bBC91ilgSdCD75b8TZ5dqiNccvf4hZk1QuZPHSptV
	7bpP2m4pTVv6vcZ3QVvbu+NPNwcw1B5wDNcSUWnZ2CPMYN+ov8pq3m15s8STxRY2izaZrmDd
	5jnjyuWY5fum+Hw10hZ6+3B9298LDl/izRmmWErPLf521uz+P6k6w5SUo7pXRau5m5z+eR3O
	1WsJ2jvxN6PQrXUyvbezxSUFnfedyDm978cdLwlG8Z+Vh8IWJr7iXiN1v2fZ3wevZs8N5WPy
	nuOp+HtldIpt2SSRjBxbDbn77a4eKlfqv0l6NuSGimisz5Z6o8twOEqJpTgj0VCLuag4EQCy
	PVV9CgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsWy7bCSvK73z/3pBjOfGFisvtvPZvFx1gtm
	i8fdHYwWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGVMWFNQ8J29
	4uzvOcwNjAvYuhg5OSQETCRWvn0GZHNxCAnsZpQ4/Hc6kMMBlJCWWLg+EaJGWGLlv+fsEDXf
	GCVmf5vHCpJgE9CWePX2BjOILSKgJXFsXRNYL7OAncTa9z4gYWGBSInOg9cYQWwWAVWJhVfP
	sICU8ArYS3RfjoAYLy8x89J3dhCbEyj8prORBcQWApqyYOI3JhCbV0BQ4uTMJ2BxZqD65q2z
	mScwCsxCkpqFJLWAkWkVo2RqQXFuem6xYYFhXmq5XnFibnFpXrpecn7uJkZwiGpp7mDcvuqD
	3iFGJg7GQ4wSHMxKIrycmXvShXhTEiurUovy44tKc1KLDzFKc7AoifOKv+hNERJITyxJzU5N
	LUgtgskycXBKNTCtPxA9meOwfrt4ndpvCQ3HfMEFPZvu2bcuqxeVPfO307MzwUrqjuiiN0fa
	t954sUq/6CqfatIPiye9D49O9syY/u306X/JBm1dAQuXTzpyZ76eck38hIhD1XP2txrrpNV6
	M5/YESFzNaB/27vt11o69Py2br9nE75v4uO3HfH2v5jSK/V3pujouXjc2Pa5yUtnOsd+o50d
	K6SCjlYtcRV9p+XRw3mx5svVGJ8GLZkPJdZHNjkUq3g7/gwqvyfKGDIvcU5B1y/96Dnyp5XE
	PybNzPFMLZ4w40vWk/M88YnK4skiOip5z9QPP81xO1caXNrIst84UWdeeEFc87FFsi2uGcs5
	uz0XnmBfPU+qTImlOCPRUIu5qDgRAGJaMVbAAgAA
X-CMS-MailID: 20250227053403epcas5p4e470dca673eadd6c1f44cf5045053504
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053403epcas5p4e470dca673eadd6c1f44cf5045053504
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053403epcas5p4e470dca673eadd6c1f44cf5045053504@epcas5p4.samsung.com>

From: Vincent Fu <vincent.fu@samsung.com>

Enable Requirements checking for test suites that do not have an
nvmecdev argument. macOS does not support NUMA placement so we need to
skip some tests on that platform when the test suite does not have an
nvmecdev argument. This will be used in an upcoming patch for a set of
verify tests.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/fiotestcommon.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/t/fiotestcommon.py b/t/fiotestcommon.py
index f5012c82..6c146b66 100644
--- a/t/fiotestcommon.py
+++ b/t/fiotestcommon.py
@@ -101,7 +101,7 @@ class Requirements():
         Requirements._unittests = os.path.exists(unittest_path)
 
         Requirements._cpucount4 = multiprocessing.cpu_count() >= 4
-        Requirements._nvmecdev = args.nvmecdev
+        Requirements._nvmecdev = args.nvmecdev if hasattr(args, 'nvmecdev') else False
 
         req_list = [
                 Requirements.linux,
-- 
2.25.1

