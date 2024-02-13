Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F421622627
	for <fio@vger.kernel.org>; Tue, 13 Feb 2024 10:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707820239; cv=none; b=Wx7UjStVn7K3Qkw1gGJJwKCMG+5bVcxKpGzJrVn30qAczIdsNpMmsjNMpX5yU3EIOBs1B8wc2+7Ar+GqkasJtcq6KMq2E0CBvcpbBlYe9eO3iRyq/YOZQF/SY8n0okiNn5IHKG+ObiICYwtY6hmpwNbszV4uJaqYmm6BMCsS5e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707820239; c=relaxed/simple;
	bh=Wtd8h/RInXeOeRtmWHYpvGq9RWXE40ezo74ivF6o4Tg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=SMNinSXlCN73vfyGG4mm9XDgVH9FbHRKVabGiWs0OPZJfsjZnBkSTGv9L45AKn3COlRjPwZCXZfnRinwpTUigbi9tZbM9kAz+SN/6rI+0CqyQLFSk/CeuTlHtvfCaOPXSRRvz/JVEpWQVCNwafb9i6gRNs6t29dGZ5DRRu2Ug8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NHjKK6k2; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NHjKK6k2"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240213103033epoutp02ccb19ba1f01b7c9521e063050ad07fc3~zZXQ-qykT2510125101epoutp02W
	for <fio@vger.kernel.org>; Tue, 13 Feb 2024 10:30:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240213103033epoutp02ccb19ba1f01b7c9521e063050ad07fc3~zZXQ-qykT2510125101epoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707820233;
	bh=kKwr87d2VaxEmtZwO6jXZf5ZaILNDC1sYnjeIe8DO1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHjKK6k2LhEdELZo/6CWpRdDt50rTrk2csTndf+ccxpzKnu8DHeeu6RlT7HJlwuOl
	 SDmBplQ57nIXE9L2M/OoCpXEXrh2eRzzzV6FSu9Lj6/Bp3K6Os9QzY1WPRX2qd9uD4
	 qOTfISyndHKMA6A/lTnOqHOv4YszuzeE6VCnuh4w=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240213103033epcas5p2f7a903defb1021d9d4421d8a4988a286~zZXQxSuMX0287702877epcas5p2X;
	Tue, 13 Feb 2024 10:30:33 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4TYyJm10Xqz4x9Pv; Tue, 13 Feb
	2024 10:30:32 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9A.DD.08567.7C44BC56; Tue, 13 Feb 2024 19:30:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240213101604epcas5p203cad070c072cccae009c31d1ea363ff~zZKnMTm5h0384503845epcas5p2-;
	Tue, 13 Feb 2024 10:16:04 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240213101604epsmtrp2312d748d12cdc81d166cc4931df9f5e2~zZKnLwb2s1175011750epsmtrp2w;
	Tue, 13 Feb 2024 10:16:04 +0000 (GMT)
X-AuditID: b6c32a44-3abff70000002177-87-65cb44c72134
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A8.50.07368.4614BC56; Tue, 13 Feb 2024 19:16:04 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240213101603epsmtip1195bfa9463641507dc517299dc9c1d5d~zZKme3x5-0104101041epsmtip1e;
	Tue, 13 Feb 2024 10:16:03 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/5] engines/xnvme: allocate iovecs only if vectored I/O is
 enabled
Date: Tue, 13 Feb 2024 21:03:11 +0530
Message-Id: <20240213153315.134202-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240213153315.134202-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmpu4Jl9OpBvenMVqsufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASlW2TkZqYklqkkJqXnJ+SmZduq+Qd
	HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RQSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
	XGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCd8Wn1L5aCuRwVzy/OYG9gvMDWxcjJ
	ISFgInH+Tj9TFyMXh5DAbkaJh48XMUM4nxgl/u26xQrhfGOU2Lx6M1zLjH/n2SESexkljjc1
	QVV1MkmcPfGTHaSKTUBb4tXbG0CzODhEBDQk1txNBQkzC9hJXD38EmyQsECoxKev81lBSlgE
	VCW2vHMCCfMK2Er83LwCape8xMxL38EmcgK17n3XwgZRIyhxcuYTFoiR8hLNW2eDXS0hcIxd
	Ys/nI0wQzS4Sb77+YYSwhSVeHd/CDmFLSXx+txdqQbbEpoc/oeoLJI686GWGsO0lWk/1g53P
	LKApsX6XPkRYVmLqqXVMEHv5JHp/P4Fq5ZXYMQ/GVpX4e+82C4QtLXHz3VUo20Oi6+RnaFBN
	ZJS4/n0R6wRGhVlI/pmF5J9ZCKsXMDKvYpRMLSjOTU9NNi0wzEsth0dycn7uJkZwGtRy2cF4
	Y/4/vUOMTByMhxglOJiVRHgvzTiRKsSbklhZlVqUH19UmpNafIjRFBjeE5mlRJPzgYk4ryTe
	0MTSwMTMzMzE0tjMUEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGJvsXIq3Rc0PvPz61ZvLN
	1LnPjbdc3qbHFXcjyeA7+5e7H5Jn3Tnm0uwmYbWsSMTj+rz9i7OPZu0tcuJbfdhQdUrJ1qNt
	vTvfBmz/9/BL9Vo/hQyWy0sb7vMuK826V+5wXZ+/aNoMW89sBsbfm2OOWjJ6nv0zJcLPaK4g
	m6G87OE2bvulE5eeMbN9sOcf7/+IPS+f8H5tvc0evKI14RP/KqdHV9iYd3mtfP5CykT0i17H
	poxb82fav5sqHse99OjlZpm+WpZslzV9d2+dF1v/U3mheaBFVxhLHMMcrajpJa9mqv3re7fx
	n2DM1H9BG92top0nCOfc08wI3XuHj8WbR529VOj8o3uaN6ZL9VTXeymxFGckGmoxFxUnAgBI
	oc5QDAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsWy7bCSnG6K4+lUg9adLBZrrvxmt1h9t5/N
	4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGV8Wv2LpWAu
	R8XzizPYGxgvsHUxcnJICJhIzPh3nr2LkYtDSGA3o0THt90sXYwcQAlpiYXrEyFqhCVW/nvO
	DmILCbQzSeycVA5iswloS7x6e4MZxBYR0JI4tq4JbCazgIPEv11bwGxhgWCJ55t/gY1kEVCV
	2PLOCSTMK2Ar8XPzCqgT5CVmXvoONp5TwE5i77sWNohVthJXpqxmh6gXlDg58wkLxHh5ieat
	s5knMArMQpKahSS1gJFpFaNkakFxbnpusmGBYV5quV5xYm5xaV66XnJ+7iZGcJBqaexgvDf/
	n94hRiYOxkOMEhzMSiK8l2acSBXiTUmsrEotyo8vKs1JLT7EKM3BoiTOazhjdoqQQHpiSWp2
	ampBahFMlomDU6qByef3Mt9L6iW8Vw+fq/GfvFnZ6IFy9MatAbNDJ7Dd/8FZWDfPV/WMZ33I
	X2YbydrZP3aUfdj53eXNAvENmWvVTmlVu0xb+kxN7XXwn9KnLEG7hV4rPRP9U2mt+SF6aeYb
	Vma1aum+xAvnc/bsFOvuWHC51OeVt7DyuV9+tcscZuk/Zp6t73rE6uNWXtEfdsxx7TNtqmet
	7z+dVR90Je/BiXfRHVMf6r54uu/1s0BPjf+mH3ffWd/RkO2v/vzoA52nxt8/qLosjnqu6tzI
	zlibsc2a+9d+1quCTOynWP/XGE1Ozv0yJbXi0rr1Cw9abJ3UFnyS+3DfrCu7ZeZfWJDYIPXT
	bIV8EXf4XLtqa83cHiWW4oxEQy3mouJEAOU0qynBAgAA
X-CMS-MailID: 20240213101604epcas5p203cad070c072cccae009c31d1ea363ff
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240213101604epcas5p203cad070c072cccae009c31d1ea363ff
References: <20240213153315.134202-1-ankit.kumar@samsung.com>
	<CGME20240213101604epcas5p203cad070c072cccae009c31d1ea363ff@epcas5p2.samsung.com>

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/xnvme.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/engines/xnvme.c b/engines/xnvme.c
index 2a0b3520..88bbba4e 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -325,6 +325,7 @@ failure:
 static int xnvme_fioe_init(struct thread_data *td)
 {
 	struct xnvme_fioe_data *xd = NULL;
+	struct xnvme_fioe_options *o = td->eo;
 	struct fio_file *f;
 	unsigned int i;
 
@@ -347,12 +348,14 @@ static int xnvme_fioe_init(struct thread_data *td)
 		return 1;
 	}
 
-	xd->iovec = calloc(td->o.iodepth, sizeof(*xd->iovec));
-	if (!xd->iovec) {
-		free(xd->iocq);
-		free(xd);
-		log_err("ioeng->init(): !calloc(xd->iovec), err(%d)\n", errno);
-		return 1;
+	if (o->xnvme_iovec) {
+		xd->iovec = calloc(td->o.iodepth, sizeof(*xd->iovec));
+		if (!xd->iovec) {
+			free(xd->iocq);
+			free(xd);
+			log_err("ioeng->init(): !calloc(xd->iovec), err(%d)\n", errno);
+			return 1;
+		}
 	}
 
 	xd->prev = -1;
-- 
2.25.1

