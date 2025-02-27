Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76F021E08B
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639875; cv=none; b=XzfjIqq1NWl7s/vsJJTgC3I6mfey3gRrvmMTAHT2dfCA99O4J0sEXmD69d3fZ1nYyFcyAieL/z9S7MyBy98mIjyRqUox8kF41rlkJ57sVpVa6O7+uci2X8Wz6OaL1XIJjhpSs0y/Rsf+dgtAE50waMS/duvHtuvbTD8Q7DjONBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639875; c=relaxed/simple;
	bh=zHVFABe7nqektBHQVhT0qJZtuNWp0MkdqD9Px/kkmnY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=G8zyZyJoM3GAP4IZHAxgIXCqDwg4a20Wx09WgEO77BUCEDmFRNlDBDuWFrP7WXuCbTnnxzJlzMMFqeM9W8cyaApblI/YZ9v+RMIKW3ynDNoBWqVjk8hV3zcyK13pwVXGyj4xbVgkm3wG84RmPCWo9Mbd0OhOzoE7u1jkZxeI1D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kc89YPXL; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kc89YPXL"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250227070431epoutp0107007b7ebeca3d38baf7c4300b4ce1ca~n-r27oDdw2773727737epoutp01n
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250227070431epoutp0107007b7ebeca3d38baf7c4300b4ce1ca~n-r27oDdw2773727737epoutp01n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639871;
	bh=K3he/NWOLP05HnP0tOCmjjXxzpUTbpJJA2hDwSRAI5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kc89YPXLCi483exsDmQ3/1nX3QvFMrqOxyFy18LtVOwG37+XAsFtLUUfAByB3w0LR
	 AwrcFmQJuuCsZRl40YXX2ykwU7eYzRFmfpTDl4OlKH5c8HqpxMOvgcSLN57o0Um3+q
	 +HaKOZLkxHz4uoLpbR9u7eENeEvnNukVqxvAGZH8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20250227070431epcas5p28fb32db6a20eb407af980d8a75182828~n-r2vCyA01044010440epcas5p29;
	Thu, 27 Feb 2025 07:04:31 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Z3Mld4t4dz4x9QH; Thu, 27 Feb
	2025 07:04:29 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	46.B9.19933.97E00C76; Thu, 27 Feb 2025 16:04:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250227053407epcas5p3289616e55ee4e603edbe9f10d350a060~n_c7QnqI-0147701477epcas5p3t;
	Thu, 27 Feb 2025 05:34:07 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250227053407epsmtrp226183746dfd4f9fa5c0704c1aa688a03~n_c7PzWbl2933029330epsmtrp2-;
	Thu, 27 Feb 2025 05:34:07 +0000 (GMT)
X-AuditID: b6c32a4a-4525924000004ddd-8b-67c00e798bea
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	03.5A.18949.F49FFB76; Thu, 27 Feb 2025 14:34:07 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053406epsmtip2199b3f3b30553d1585fa2072f21807c3~n_c6j-poS1780517805epsmtip2M;
	Thu, 27 Feb 2025 05:34:06 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 19/21] t/fiotestcommon: add a success pattern for long tests
Date: Thu, 27 Feb 2025 16:17:25 +0530
Message-Id: <20250227104727.1794982-20-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmpm4l34F0g0PzZC1W3+1ns/g46wWz
	xePuDkaLDW2CDiweO2fdZfe4fLbUo2/LKkaPz5vkAliism0yUhNTUosUUvOS81My89JtlbyD
	453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYqKZQl5pQChQISi4uV9O1sivJLS1IVMvKL
	S2yVUgtScgpMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7IzPk7dzFxwnbWi5+oetgbGnSxdjJwc
	EgImEu82XWbsYuTiEBLYzSjRvWwaM4TziVHi2oUVTBDON0aJORN3s8O03Hs1FaplL6PEgobH
	LBDOD0aJqzdaGUGq2AS0JV69vQE0i4NDREBDYs3dVJAws4CNRPPKfWCDhAV8JHrXnQQrZxFQ
	lVgwaxZYnFfAXmJB4xtGiGXyEjMvfQeLcwLF33Q2skDUCEqcnPmEBWKmvETz1tlgZ0sIHGOX
	2LrzHVSzi8TVC89ZIWxhiVfHt0B9ICXx+d1eNgg7W2LTw59MEHaBxJEXvcwQtr1E66l+sPuZ
	BTQl1u/ShwjLSkw9tY4JYi+fRO/vJ1CtvBI75sHYqhJ/792Ghq+0xM13V6FsD4mTxz9DA24S
	o0Tjyo8sExgVZiH5ZxaSf2YhrF7AyLyKUTK1oDg3PbXYtMAoL7UcHsvJ+bmbGMGJUMtrB+PD
	Bx/0DjEycTAeYpTgYFYS4eXM3JMuxJuSWFmVWpQfX1Sak1p8iNEUGOATmaVEk/OBqTivJN7Q
	xNLAxMzMzMTS2MxQSZy3eWdLupBAemJJanZqakFqEUwfEwenVANT74wrua4tc9Rl38pXP6oT
	ec2h9SI4INsv87vO6XuulmZLb1lGehUV7rhvZMXMXyPwNy1XlVdedcKE853bFxqFRJ7cIHjo
	Yn/uzMrq7Jk56f+mdb8QTXRXaU9c92emxvGEr/uvPddou8571fFC+xHl5UG3dyZXshxI/Gmg
	d/C+btKNTzwP/Oa/EtV1yE+y+uojfa0tc43B7n875vEJCAq6dj70YmZcxlbB637KNeD75MWK
	z2O84t67Mouf5Q9h3eH0/PZc++j1UbtOCe9rqBLSqZTuFqp5Y29z7PbKKAUv3Y8/NR94rtTZ
	6yNuJHg34I5VdLty1o8VB16s/RR9JLtPnX/KTwnXxTGG0arNikosxRmJhlrMRcWJAP3m21MN
	BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsWy7bCSvK7/z/3pBh17VCxW3+1ns/g46wWz
	xePuDkaLDW2CDiweO2fdZfe4fLbUo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDI+Tt3MXHCd
	taLn6h62BsadLF2MnBwSAiYS915NZQSxhQR2M0os31ffxcgBFJeWWLg+EaJEWGLlv+fsXYxc
	QCXfGCWeTWlkB0mwCWhLvHp7gxnEFhHQkji2rokNpJdZwE5i7XsfkLCwgI9E77qTYONZBFQl
	FsyaBdbKK2AvsaDxDSPEfHmJmZe+g8U5geJvOhtZIM6xk1gw8RsTRL2gxMmZT8DizED1zVtn
	M09gFJiFJDULSWoBI9MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgINXS2sG4Z9UH
	vUOMTByMhxglOJiVRHg5M/ekC/GmJFZWpRblxxeV5qQWH2KU5mBREuf99ro3RUggPbEkNTs1
	tSC1CCbLxMEp1cCko8bDJPDPlEdC48RuYcvmj0K29l9abopZbCm9y/H4w7JjR73NL9lMYpHa
	tvziNMFeM/a4e+3yFp++HHrGt/66ac6l43JLWBaVWMWfF5h/imGSfsqpSpeHCn7tt5bmSqX1
	TNuio98RzjJ5ebrBvnzbPdvE1A4vfaJdy6m/Skis77cPm7eHQKdbbb4r+8PbWT8CKl8HP1xs
	ZXDvaqrsim3vsz04AtdvmCY8e7fvL8W/f297Hk9oK9nR/3D2ox/m/4Tfvi8MFW7WqfjML22i
	coFN12mteOSX5zEPVh3f7R3tkP7xpqXbvntPo5l1t276tE+6mktvcwrTbPWnondOX7wV2pmV
	e05F9AvfWYbWyjdKLMUZiYZazEXFiQDz30HUwQIAAA==
X-CMS-MailID: 20250227053407epcas5p3289616e55ee4e603edbe9f10d350a060
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053407epcas5p3289616e55ee4e603edbe9f10d350a060
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053407epcas5p3289616e55ee4e603edbe9f10d350a060@epcas5p3.samsung.com>

From: Vincent Fu <vincent.fu@samsung.com>

On Windows the verify test script runs for longer than 10 minutes. Add a
success pattern that accommodates this test.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/fiotestcommon.py | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/t/fiotestcommon.py b/t/fiotestcommon.py
index 6c146b66..9003b4c1 100644
--- a/t/fiotestcommon.py
+++ b/t/fiotestcommon.py
@@ -19,6 +19,11 @@ SUCCESS_DEFAULT = {
     'stderr_empty': True,
     'timeout': 600,
     }
+SUCCESS_LONG = {
+    'zero_return': True,
+    'stderr_empty': True,
+    'timeout': 1800,
+    }
 SUCCESS_NONZERO = {
     'zero_return': False,
     'stderr_empty': False,
-- 
2.25.1

