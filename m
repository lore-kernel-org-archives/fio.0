Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747EC1E32D4
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639824; cv=none; b=hgVYsyThXjqZYm+wKDcp0PaLvhnnAODFz6B6QTgauiHopEWVB7QhgCs17BdlutJVkcEaO92/Gjv+qRQ0i/rPJXLkCR/UeEuLBcWfVGQdOrK7ivdMWnQatJmp1WDdF+JbmoUy3k0Q2mpymym5K8noFvK8PL8/VNAeTTXQ9WbgLYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639824; c=relaxed/simple;
	bh=CWnJV/nrixbiQrR84ZubHRW9SIuAMie8Cle+8zfZVGQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=bFsUeq5YGv+m6n1w0EdSflyPewHuRYOGme+Avsx+lpaQtLeeWhKP0qTe3Zw1hN/5SEUYc3/PUx5+UsSRwjxHXKeI6mo7f1L9j5WYoFaofuyi7bjJcgHlv0pdCD8WR5XX+mdAUNLWX3MdnIvRAQkslp8Gh1R8H+XEacQnBUDr1Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XQAHCBkK; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XQAHCBkK"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250227070339epoutp036729cfa71bdc9768659826ca13c72988~n-rFyr7Jn3231532315epoutp03S
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250227070339epoutp036729cfa71bdc9768659826ca13c72988~n-rFyr7Jn3231532315epoutp03S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639819;
	bh=b7qALhZMdGVNv5nWYZ6nngAp27XHUUnBM9fymkXhp6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQAHCBkKHyET0PY62TzhyUfK42DXal3hsx9E0+1grRiQC4wcI2Hj/ObPE/P3dNrp7
	 P64Lpj1O/TH0ETP9PSCvaF1uqFXZaYwlO2xReTL7Ib5rQSTzq6XCzUHkatwGR/xzXY
	 udHh6LKT3lX215W7Cgim4MhHNfdzEKGBfob8cwAw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20250227070337epcas5p1e96834a8681f4d14d802d91b4fcc5b93~n-rENDx550319303193epcas5p18;
	Thu, 27 Feb 2025 07:03:37 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Z3Mkc0Fp0z4x9Pw; Thu, 27 Feb
	2025 07:03:36 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EC.69.19933.54E00C76; Thu, 27 Feb 2025 16:03:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250227053351epcas5p3907c153178ec99417f93e7d71778ac69~n_cr2aPiu0099900999epcas5p3L;
	Thu, 27 Feb 2025 05:33:51 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250227053351epsmtrp1c4f04fabedc6c68705c7d01e1394b289~n_cr1z4OE1011310113epsmtrp1S;
	Thu, 27 Feb 2025 05:33:51 +0000 (GMT)
X-AuditID: b6c32a4a-c1fda70000004ddd-d2-67c00e45ed3c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	96.4A.18949.E39FFB76; Thu, 27 Feb 2025 14:33:51 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053350epsmtip216af14265e5fed1df1aa865c93eeda59~n_crJiy1L1753517535epsmtip2a;
	Thu, 27 Feb 2025 05:33:50 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 01/21] filesetup: remove unnecessary check
Date: Thu, 27 Feb 2025 16:17:07 +0530
Message-Id: <20250227104727.1794982-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmhq4r34F0g44lKhZrrvxmt1h9t5/N
	4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
	l9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnNO/ewFTQzl7xtecHUwPjSdYuRk4O
	CQETiatfOtm7GLk4hAR2M0rs+HSNGcL5xChx5NUlJgjnG6NEy5rTQC0cYC2Pj6eDdAsJ7GWU
	eDizGqLmB6PE2955bCAJNgFtiVdvbzCD1IsIaEisuZsKEmYWsJO4evglWImwgJXE9U3PmUFs
	FgFViZn9H1hAbF6gmglPn7NAXCcvMfPSd3YQm1PAXuJNZyNUjaDEyZlPWCBmyks0b50NdrSE
	wDF2iSOrLkA1u0gsuXKJEcIWlnh1fAs7hC0l8bK/DcrOltj08CcThF0gceRFLzOEbS/Reqof
	7H5mAU2J9bv0IcKyElNPrWOC2Msn0fv7CVQrr8SOeTC2qsTfe7ehTpCWuPnuKpTtIfGnsQsa
	0pMYJTb0/2OawKgwC8k/s5D8Mwth9QJG5lWMkqkFxbnpqcWmBUZ5qeXwOE7Oz93ECE6CWl47
	GB8++KB3iJGJg/EQowQHs5IIL2fmnnQh3pTEyqrUovz4otKc1OJDjKbAAJ/ILCWanA9Mw3kl
	8YYmlgYmZmZmJpbGZoZK4rzNO1vShQTSE0tSs1NTC1KLYPqYODilGph2OWgG/YryMFt3tGie
	/VURqfrGFu7pO058XMU2f8vclJWHvCZs3elUIBSqd/yl7rmXn/OerOncE8wq5MD/aeGyqcnf
	Gr1Kvyy4u+RtldWya04zasIPbfy4qvxH7J+8eQrPFkhc+rU84ahS0LfNy7fEvT1+vk4oxtDb
	XsSSnevP6wSFp+/ev3t68vp2rmkr2TbqNOSG/fz2dtq32fZGNdENT6X5v9n6tch9uB0om3wl
	NeBP2dQq52Ub9Wo7pRYuuRIt6HZwy/9MlSaexy9ennGsX9G0PF7wuOip3J6ZbxKvdpxlPlNW
	dNBRYIt6Z0dc64sfHIxLuDm/N9xsZE3mXuO2umCm+oG/C133rvj8584zDSWW4oxEQy3mouJE
	AAkfChELBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSvK79z/3pBt/vM1msufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXRvHsDU0E7
	e8XXnh9MDYwnWbsYOTgkBEwkHh9P72Lk4hAS2M0osaF3CyNEXFpi4frELkZOIFNYYuW/5+wQ
	Nd8YJVbcvc0OkmAT0JZ49fYGM4gtIqAlcWxdExuIzSzgIPFv1xYwW1jASuL6pudgNSwCqhIz
	+z+wgNi8AnYSE54+Z4FYIC8x89J3sJmcAvYSbzobweJCQDULJn5jgqgXlDg58wkLxHx5ieat
	s5knMArMQpKahSS1gJFpFaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcJhqae1g3LPq
	g94hRiYOxkOMEhzMSiK8nJl70oV4UxIrq1KL8uOLSnNSiw8xSnOwKInzfnvdmyIkkJ5Ykpqd
	mlqQWgSTZeLglGpg2rnTrMdLZKU+05wZqTXyugEKC8S1LhRUfj45bz5H3um25em1rU2VSQuz
	13DwGkyeWTKVIzTBnUHhs/RToZWee6U0pxxy/mhssJfxgyNT3eJpYmdK1lSYKFmf1RL/fmjv
	+w0/7J27virfkGH6WXzDdY3hqclP55ryeTYHRy6eEu3KfWjNI52w4LpfSj+3HMwPcJjcf3bG
	P7Xb3+dc9BAKstZyMuDVjOP+supqqoBhVuqub7Hbu6/Z85yc/l/j2WbbyH2CEy/csL7V/uac
	88zGDv9VHSfuiPMUzCoMyVsZV7N97ZLKp4dFth50kCyLnXPr4w82O8WNf0yiLWN8HZ8lvo80
	3XTUIn/uJblWhf+MSizFGYmGWsxFxYkAq28tkcICAAA=
X-CMS-MailID: 20250227053351epcas5p3907c153178ec99417f93e7d71778ac69
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053351epcas5p3907c153178ec99417f93e7d71778ac69
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053351epcas5p3907c153178ec99417f93e7d71778ac69@epcas5p3.samsung.com>

If read_iolog_file is set, the goto statement moves it beyond this
point. So remove this redundant check.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 filesetup.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index cb42a852..50406c69 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1388,16 +1388,10 @@ int setup_files(struct thread_data *td)
 	if (err)
 		goto err_out;
 
-	/*
-	 * iolog already set the total io size, if we read back
-	 * stored entries.
-	 */
-	if (!o->read_iolog_file) {
-		if (o->io_size)
-			td->total_io_size = o->io_size * o->loops;
-		else
-			td->total_io_size = o->size * o->loops;
-	}
+	if (o->io_size)
+		td->total_io_size = o->io_size * o->loops;
+	else
+		td->total_io_size = o->size * o->loops;
 
 done:
 	if (td->o.zone_mode == ZONE_MODE_ZBD) {
-- 
2.25.1

