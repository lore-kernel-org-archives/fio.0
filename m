Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16A421D599
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639837; cv=none; b=SgRm3Sl0ucNIp+NkS61JBkhZx/keQQjmBZZNigatM0kV9RcVNLo9HKG6/wXH/SVbxu39I2+qdvoc9kn05+5ueyRdWusVaeAd1Wsw138/7PesTR2IKcB19JaDmZRJ9VI9a8iICcUKenaEFzfPWbldMBLoPR6CXCkg81GphDLjPKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639837; c=relaxed/simple;
	bh=+k/Sffsx41+kYk6f34L6Ig5JFGMNAUDSI1e410IhW9c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ULdl0VQfNXB59eIRaSiyunEibbLmBq5m9za4gBtXgX48tw6cHgcu0To48Z4d70hwLxlSbUmbVwTxsJu7iIZE962L8OVz20xXYNn/y1/NIvyq6xq5wPGDyyfaYJEXR7kWIdSfgtYH8cntvAW/zkHi6ItRX0Qdcsbldn0RnuLXaQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=K/AYwj3e; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="K/AYwj3e"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250227070353epoutp03afb5fbfc2f4cf9f43d83d875fea002fb~n-rTXvElM3265932659epoutp03K
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250227070353epoutp03afb5fbfc2f4cf9f43d83d875fea002fb~n-rTXvElM3265932659epoutp03K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639833;
	bh=jMLf97+2A4+SGB90H1mxtb5Bfaq1qoLLHOVTKsgE0J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/AYwj3e79CAZ+uHk+6UsjSlJj0BCdYqYyDvQLFKUg1yuD81GwGH7Vzyq0Lta2nOp
	 Sx/2758Silt0TdnYIDl8uX+2Pmg+UmqDqVTUibg5Jbs0IlkpJQHj2mvNl+DJbFVMUN
	 nF4HTlF63mIQnuwbHI66pvMvFFW5MZBo87OnQcIw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20250227070353epcas5p27fa0052930401afc5639b976d0e4a050~n-rS3jUHD1466914669epcas5p28;
	Thu, 27 Feb 2025 07:03:53 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Z3Mkv0TnFz4x9Pq; Thu, 27 Feb
	2025 07:03:51 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	34.C1.20052.45E00C76; Thu, 27 Feb 2025 16:03:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250227053355epcas5p11eb32d301d8546cf1634743af4193dca~n_cwHcoYy1213912139epcas5p1q;
	Thu, 27 Feb 2025 05:33:55 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250227053355epsmtrp10a780306ee74551f140a9136eaf3a359~n_cwG2P-l1011210112epsmtrp1a;
	Thu, 27 Feb 2025 05:33:55 +0000 (GMT)
X-AuditID: b6c32a49-3fffd70000004e54-b8-67c00e54cf59
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	7F.DA.33707.349FFB76; Thu, 27 Feb 2025 14:33:55 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053354epsmtip2732fc9b562d8e90cfc49ac763d81a8b7~n_cvUpyxU1586815868epsmtip2h;
	Thu, 27 Feb 2025 05:33:54 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 06/21] verify: enable header seed check for 100% write jobs
Date: Thu, 27 Feb 2025 16:17:12 +0530
Message-Id: <20250227104727.1794982-7-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmum4I34F0g4enzC3WXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
	jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOOLb0B2PBOY6KllfH2BoYf7B1MXJy
	SAiYSMw4tJ69i5GLQ0hgN6PE25Z2FpCEkMAnRomWd8kQCSD74v1PzDAdL490MUEkdjJKtK/+
	xgLh/GCUWHMYYi6bgLbEq7c3gDo4OEQENCTW3E0FCTML2ElcPfySDSQsLOAt0dMiDxJmEVCV
	aL+4kgnE5gUqaZn9mgVil7zEzEvf2UFsTgF7iTedjSwQNYISJ2c+YYEYKS/RvHU2M8gJEgL7
	2CUOTHnOCtHsIvHg4FWoo4UlXh3fwg5hS0m87G+DsrMlNj38yQRhF0gcedELVW8v0XqqH+x8
	ZgFNifW79CHCshJTT61jgtjLJ9H7+wlUK6/EjnkwtqrE33u3oe6Xlrj57iqU7SGxqnUjMySo
	JjFKrGs7xTSBUWEWkn9mIflnFsLqBYzMqxglUwuKc9NTi00LDPNSy+FxnJyfu4kRnAS1PHcw
	3n3wQe8QIxMH4yFGCQ5mJRFezsw96UK8KYmVValF+fFFpTmpxYcYTYEBPpFZSjQ5H5iG80ri
	DU0sDUzMzMxMLI3NDJXEeZt3tqQLCaQnlqRmp6YWpBbB9DFxcEo1MMn5dq+pVJ2xc1reNd5L
	W6UnHH0Upn91gjP/HaWZ5hscm++68tzp/m2VOStJT2dBp/bF90+O3rrfH8fQ9eSLoeHdwI3H
	D7el7mre5/bpvOL29kNLy9Meb2b5/cH4fwBv+fS72tI8Xx9/qNzxtnTqp3O6TMWJuzLUZy5t
	PrvaM2yG0b/0vaf88qOPJC+1sQ83q1W9fPjCBg+JFKsTCqFbIsIkdhTx8CRXBWzpuJU9qUzo
	hM5MhkK3aXz3Hn3/33r5TKzxJ4c0mwvK/8++n1aSlid9iXFz+n0r/9OTGj26BFUOV8+96vHQ
	NCKkrkHkb6nmxTcx0meWPJptLTjjVPj7m7ZFtS9Mcxa+Eue4MGlGU7oSS3FGoqEWc1FxIgBN
	0QuiCwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsWy7bCSvK7zz/3pBveOKFqsufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJVxbOkPxoJz
	HBUtr46xNTD+YOti5OSQEDCReHmkiwnEFhLYzijxbldNFyMHUFxaYuH6RIgSYYmV/56zdzFy
	AZV8Y5S4d/8NWC+bgLbEq7c3mEFsEQEtiWPrmsDizAIOEv92bWEDmSMs4C3R0yIPEmYRUJVo
	v7gSbBWvgJ1Ey+zXLBDz5SVmXvrODmJzCthLvOlsZIE4x05iwcRvUPWCEidnPmGBGC8v0bx1
	NvMERoFZSFKzkKQWMDKtYhRNLSjOTc9NLjDUK07MLS7NS9dLzs/dxAgOTq2gHYzL1v/VO8TI
	xMF4iFGCg1lJhJczc0+6EG9KYmVValF+fFFpTmrxIUZpDhYlcV7lnM4UIYH0xJLU7NTUgtQi
	mCwTB6dUA1NwhEFMaNRVccGYWSzrSj4q1W1VzZkzQdRjSeYa40nrKtZ86bSaPk9O5Wzdsdon
	2x5+fPLQM6U9vPwLh+v2PxzH/xkYpLPzH395fXulrblc38zFWzpE3n/IO9t1WuDlw6bsfjOx
	aen5nUZS+eFXY3+7tukwZ7QnZO48VF+zWNrZwjT6z9Vkjck5n50f6+xKUlXTW77ceaJKbcQH
	l/LoKw/k139pbFyUddf2kqNXNduzXbvFn4h5csfvcGlhsJ+1+n7ne/5+v4J9m886bHbZq2pu
	OOkTl5JcT9E83U2Zdt9+eKzJbtYWXXhtzuZb4trnz5Y5Rs1k+xjYcoJdlNmvZ0Zyx5ktTz5w
	FnA+SZpspcRSnJFoqMVcVJwIAB0uT5i9AgAA
X-CMS-MailID: 20250227053355epcas5p11eb32d301d8546cf1634743af4193dca
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053355epcas5p11eb32d301d8546cf1634743af4193dca
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053355epcas5p11eb32d301d8546cf1634743af4193dca@epcas5p1.samsung.com>

There are 3 modes where verify can be performed. write, read and
readwrite. The existing readwrite condition prohibits header seed check
for write or read workloads. For write workloads, there shouldn't be any
extra limitation that triggers header seed mismatch which cannot be
triggered with readwrite workloads. Hence modify this condition to only
disable verify header seed checks for read workload.

The subsequent patches fixes header seed mismatch issues.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init.c b/init.c
index 99661ca8..7a1a6840 100644
--- a/init.c
+++ b/init.c
@@ -864,7 +864,7 @@ static int fixup_options(struct thread_data *td)
 		 * zone reset frequency for zonemode=zbd.
 		 * Unless we were explicitly asked to enable it.
 		 */
-		if (!td_rw(td) || (td->flags & TD_F_VER_BACKLOG) ||
+		if (!td_write(td) || (td->flags & TD_F_VER_BACKLOG) ||
 		    o->zrf.u.f) {
 			if (!fio_option_is_set(o, verify_header_seed))
 				o->verify_header_seed = 0;
-- 
2.25.1

