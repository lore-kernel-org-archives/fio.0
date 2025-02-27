Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABBF2206AE
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639876; cv=none; b=VPiT36bF9ZfZAwxzBmZRH7sC2QXg+kyviKB9B+GlGBp56jD8L0w+s1I5pNOLO79GApq1yjdj9EW+U3J43MXjv0oG8kGAkd1PBYwkXst+2lPvSc3sOJSg2sPOIUzGGCjuAOdmi/EuQskpkZJ3TXC408p4q90R9PSDj/xoxBnWbSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639876; c=relaxed/simple;
	bh=q4WF+GYlkxnbu7VD0xGVXZBFmqcVXZic4r5WICVXp+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=gfyYZzIMgRu6SBVoM3KVs8yu7s/Nt0hZLBZmzep8CRYUHPktmlY5+LvwnsJ4merkeObLqo3y3+HJ8/KBDgNyvJI8iMpgY0sVxs1sPyA9hnHwDzvsa1C5YhZB+lKtgO035H9hj5WREv6TwtviEKpgUFh3wTPWqi99Zb6zESdFL+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mxnNLRTN; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mxnNLRTN"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250227070433epoutp045b3537e00f447704d163c22b55cdfaeb~n-r4JVCNa2521625216epoutp04M
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250227070433epoutp045b3537e00f447704d163c22b55cdfaeb~n-r4JVCNa2521625216epoutp04M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639873;
	bh=Lv4F4KKwIMHlbJgl88CTwV7U1PZKkhK6HPGbz2X8ASE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxnNLRTN9e0Ttsb7KFrshuBLgfLQOb23wMptRKqb/pECqn5rk1lCt5VErXLyBpSgB
	 YYtkMR49ppn5HzWoIPcvaKzalcUGyI4KDHJ0CFtcJZj3/DbRAoVz4/fAnDJLcmPPKo
	 8c0jUayEy143aIUk6GRrSc9bInJ0H7b3i7YGka/A=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20250227070432epcas5p3e2e978bc1588e8b9f508ba4e627118ec~n-r3rA6Yo1433414334epcas5p3q;
	Thu, 27 Feb 2025 07:04:32 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Z3Mlf5LQLz4x9QG; Thu, 27 Feb
	2025 07:04:30 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	8F.D2.19710.C7E00C76; Thu, 27 Feb 2025 16:04:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250227053408epcas5p1490bd53573c697acbf4543fdb2bc035d~n_c8HYuFB1213912139epcas5p1G;
	Thu, 27 Feb 2025 05:34:08 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250227053408epsmtrp18891f06a23a74de9224bc77a01ae90fa~n_c8GzZH21040510405epsmtrp1s;
	Thu, 27 Feb 2025 05:34:08 +0000 (GMT)
X-AuditID: b6c32a44-363dc70000004cfe-ad-67c00e7c7022
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F0.B2.23488.059FFB76; Thu, 27 Feb 2025 14:34:08 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053407epsmtip21d9d602ecdc130431166fb9d29b8724d~n_c7YoKBo1753517535epsmtip2C;
	Thu, 27 Feb 2025 05:34:07 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 20/21] t/run-fio-test: add t/verify.py
Date: Thu, 27 Feb 2025 16:17:26 +0530
Message-Id: <20250227104727.1794982-21-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmum4N34F0g/6Xohar7/azWXyc9YLZ
	4nF3B6PFhjZBBxaPnbPusntcPlvq0bdlFaPH501yASxR2TYZqYkpqUUKqXnJ+SmZeem2St7B
	8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QAuVFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnF
	JbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZE9ZNZC5YxFZxbK9IA+MKli5GTg4J
	AROJxvZOti5GLg4hgd2MElPnf2aCcD4xSlw9Mgcq841RYvazVewwLRdfTWOBSOxllNiy5AhU
	yw9GidMd35lAqtgEtCVevb3B3MXIwSEioCGx5m4qSJhZwEaieeU+sEHCAmYSjyZvAitnEVCV
	2DT3K5jNK2AvMeXcVWaIZfISMy99B6vnBIq/6WxkgagRlDg58wkLxEx5ieats5lBbpAQOMQu
	ce/zXqhmF4mOT5+YIGxhiVfHt0B9ICXxsr8Nys6W2PTwJ1RNgcSRF71QvfYSraf6we5nFtCU
	WL9LHyIsKzH11DomiL18Er2/n0C18krsmAdjq0r8vXcbGr7SEjffXYWyPSRWLHnBCgmrSYwS
	r99NYJ7AqDALyT+zkPwzC2H1AkbmVYySqQXFuempyaYFhnmp5fBITs7P3cQIToNaLjsYb8z/
	p3eIkYmD8RCjBAezkggvZ+aedCHelMTKqtSi/Pii0pzU4kOMpsAAn8gsJZqcD0zEeSXxhiaW
	BiZmZmYmlsZmhkrivM07W9KFBNITS1KzU1MLUotg+pg4OKUamM4+FfxfpWTm98lywo9Iy8q1
	AjE/tjjOYvno/PC5UcyczgUfd66SldlgWf3ldM2uQye3sDMnWHAzbdRPVsni8lrgczTidyhf
	wCxPhqtrmWvsnQuPv39+q7Vmub/PhSWV2xONp3A2+hk1Hp124p+A8eWQesulH59vsXUReVQu
	JlEdvewG22KFE4KlW+pM5epts+PuWN0xPBFx5bdLpdbXBD2rD6yTDQ7w29rHM/lP/vEm38lX
	92h24RaOYN1Hj1ctWTHlo8i80gymAqGL/An8r1Tuec66nMmTY3CX79oDyelKT6c3WFWv5zVc
	dJtnrtVHFYeP6Tu3p3zublRXSl619tjKRe1Ho77KWjN+ba21VWIpzkg01GIuKk4EAAkaW3oM
	BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsWy7bCSvG7Az/3pBqfb5SxW3+1ns/g46wWz
	xePuDkaLDW2CDiweO2fdZfe4fLbUo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDImrJvIXLCI
	reLYXpEGxhUsXYycHBICJhIXX00Dsrk4hAR2M0qcOvyfvYuRAyghLbFwfSJEjbDEyn/P2SFq
	vjFKbD/UygiSYBPQlnj19gYziC0ioCVxbF0TG0gvs4CdxNr3PiBhYQEziUeTNzGB2CwCqhKb
	5n4Fs3kF7CWmnLvKDDFfXmLmpe/sIDYnUPxNZyPYbUJAYxZM/AZVLyhxcuYTsDgzUH3z1tnM
	ExgFZiFJzUKSWsDItIpRMrWgODc9N9mwwDAvtVyvODG3uDQvXS85P3cTIzhItTR2ML771qR/
	iJGJg/EQowQHs5IIL2fmnnQh3pTEyqrUovz4otKc1OJDjNIcLErivCsNI9KFBNITS1KzU1ML
	UotgskwcnFINTA3RZ8T/2zwzZfz3ifn4dDmrIGZ+g0+ejyyP5+vw3i1nk75vcWr2uT/mDxuM
	tHJMLEJ9/vwTrWWbvGhhxOLjDdtPhChVdW49sLSXV1rqd05Ef83pzsAlP/cfm63bwsG6O0LA
	MfftrtNPdB+tiVDWZjTmOPq6+nLgh+XZm3oD4r6rl6iyn8o9eF1MMK1mx6HwOSsLFLTqirhP
	SZ066KIf1b1/5e4VmtXddTvWT/gYf65i4uuNGk2ef6VXCYpVXjl842fkz1mu/E8NjulqsX7o
	ffmgrnNvpkbvg+8Lv0xLChLijWNvbz57i289U1PggwcxR4qmrnK86OFRcFwrP+WvHJOezoIJ
	P3Zt/x4VyF0poMRSnJFoqMVcVJwIAHftV4DBAgAA
X-CMS-MailID: 20250227053408epcas5p1490bd53573c697acbf4543fdb2bc035d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053408epcas5p1490bd53573c697acbf4543fdb2bc035d
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053408epcas5p1490bd53573c697acbf4543fdb2bc035d@epcas5p1.samsung.com>

From: Vincent Fu <vincent.fu@samsung.com>

Add the verify test script to our test runner.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/run-fio-tests.py | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 101e95f7..7ceda067 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1107,6 +1107,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux],
     },
+    {
+        'test_id':          1017,
+        'test_class':       FioExeTest,
+        'exe':              't/verify.py',
+        'parameters':       ['-f', '{fio_path}'],
+        'success':          SUCCESS_LONG,
+        'requirements':     [],
+    },
 ]
 
 
-- 
2.25.1

