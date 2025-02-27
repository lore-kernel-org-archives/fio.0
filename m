Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305FB21D3C9
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639831; cv=none; b=ff+Yeyz92zHTL6262kXzHEd2fUfAO09OwcwxbcVDclZ3p+fLCt2x4a+0lIN4FHRZIf2/huuWq9nouQy4S+7J5y+5PQjoRaUpAUa/DICZQoIc/Tl66gRDf/eUKhaF/ZQnpN3kXVYJw39S5EXvNarg7dDkZVYqUvl077YYPR6EUn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639831; c=relaxed/simple;
	bh=Pxmg8l4vXgF+GksAG8jNZZc64VR4sYXKpC2SxqEG1XQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=sN4UZr+z0ww4SyyzExOobVH/qqvhrEJwzTeiymiwR3djAZ44WUQarPzNj0G2VUK35SKXDx+KJg47GCd/w5IeyHHTX7X9Ddf3/BWiR2V/Z+qgaF+BkTd6k5NloElYR9otOQqFOVGJkbDvYCTXZGEtXyz6goKm3E8SYIJDamSyUJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=SdxdnmR4; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SdxdnmR4"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250227070347epoutp04d721ac8347cc45f13b8fb7c3cc401763~n-rNd9WwU2363523635epoutp04x
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:03:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250227070347epoutp04d721ac8347cc45f13b8fb7c3cc401763~n-rNd9WwU2363523635epoutp04x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639827;
	bh=HYc1tCv7vsSqEEY/m4/iKz3sQxR/guJFe6Xd+NjQgcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdxdnmR49pTUsBlZH25+Rbd50hKzvqu2MskYrxDCLU4hdySn0NU5mdwBYy94FSh0f
	 qKXhsZbtcDMhHWFAUH+i22KniZCzyBV1cLOQqIh8wKylCSOjgQHgcvLjoqSy4tWcGZ
	 zhJh+h3/GISjbJs+LaA39eJDtiYGV9NOAJy4M4x4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20250227070346epcas5p41d988c86b676acddcc5fd88a016d7ca9~n-rM3sadz0845808458epcas5p4O;
	Thu, 27 Feb 2025 07:03:46 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Z3Mkm6XCGz4x9QC; Thu, 27 Feb
	2025 07:03:44 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0D.01.29212.05E00C76; Thu, 27 Feb 2025 16:03:44 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053354epcas5p24b589399f9687af1ca1b8ee9b0b246f3~n_cvL0jGV1906519065epcas5p2M;
	Thu, 27 Feb 2025 05:33:54 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250227053354epsmtrp18bd688109bfa957e7ca4b90369c8c248~n_cvLM_TV1011210112epsmtrp1Z;
	Thu, 27 Feb 2025 05:33:54 +0000 (GMT)
X-AuditID: b6c32a50-801fa7000000721c-66-67c00e504908
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	2F.DA.33707.249FFB76; Thu, 27 Feb 2025 14:33:54 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053353epsmtip21a256b57dfb1ca5f6daab91186571732~n_cueVMsj1751717517epsmtip2a;
	Thu, 27 Feb 2025 05:33:53 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 05/21] verify: disable header seed checking instead of
 overwriting it
Date: Thu, 27 Feb 2025 16:17:11 +0530
Message-Id: <20250227104727.1794982-6-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmhm4A34F0g+Z/EhZrrvxmt1h9t5/N
	4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
	l9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnPNh7m7lgO2/FycmfmBsYD3F1MXJy
	SAiYSFzuambvYuTiEBLYwygx89NfZpCEkMAnRolvV6Th7OM3lWEa1vxYzATRsJNR4nnrGSjn
	B6PE7NY2FpAqNgFtiVdvbwBN4uAQEdCQWHM3FSTMLGAncfXwSzYQW1ggXGJn/z2wEhYBVYlD
	BxJBwrxAJRuO32aE2CUvMfPSd3YQm1PAXuJNZyMLRI2gxMmZT1ggRspLNG+dzQxygoTAMXaJ
	GaeOQDW7SNw6eYgZwhaWeHV8CzuELSXxsr8Nys6W2PTwJxOEXSBx5EUvVL29ROupfrDbmAU0
	Jdbv0ocIy0pMPbWOCWIvn0Tv7ydQrbwSO+bB2KoSf+/dZoGwpSVuvrsKZXtIbOi4AQ3oSYwS
	jxYsYZvAqDALyT+zkPwzC2H1AkbmVYxSqQXFuempyaYFhrp5qeXwOE7Oz93ECE6CWgE7GFdv
	+Kt3iJGJg/EQowQHs5IIL2fmnnQh3pTEyqrUovz4otKc1OJDjKbAAJ/ILCWanA9Mw3kl8YYm
	lgYmZmZmJpbGZoZK4rzNO1vShQTSE0tSs1NTC1KLYPqYODilGphEGk1nRLw09P7NLvuzY93S
	Pbf5VQWL628fKXny3XQ708Ysxg6z6lShD8FFJdzW5acE417FG874nbvk3S3ZW+0TJxhlmi6s
	rqy/FFZ3J+nqI+mXTrY1q82yU1O296W/ak7n2uPVJvgxwc+zRPOQ5+O7ty8HmzVLMDD0NDHX
	Ht80t0XzkFrblmiX2MNNN99K9M7fuUJtXrZFfPTGxN3rnp85Uh5u9/7WHrm6h5c6RH6lB1xb
	95D7gsp6HpdtMxn/aXhvEkp9vjRte84O5g6uA/KKVanmzzSzHkbc6H/eJGGq881FqFU/jONZ
	y8tou+rX65TCTv00/5Ok+7xMMvfRXBfLHVPPdTAxVBr7z5U+rsRSnJFoqMVcVJwIAMRrpVIL
	BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsWy7bCSvK7Tz/3pBo8vqlmsufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXxYO9t5oLt
	vBUnJ39ibmA8xNXFyMkhIWAisebHYqYuRi4OIYHtjBJ//v9h7GLkAEpISyxcnwhRIyyx8t9z
	doiab4wSXUfusYEk2AS0JV69vcEMYosIaEkcW9cEFmcWcJD4t2sLmC0sECpx99cZZpCZLAKq
	EocOgM3kFbCT2HD8NiPEfHmJmZe+s4PYnAL2Em86G1lAbCGgmgUTvzFB1AtKnJz5hAVivLxE
	89bZzBMYBWYhSc1CklrAyLSKUTS1oDg3PTe5wFCvODG3uDQvXS85P3cTIzg8tYJ2MC5b/1fv
	ECMTB+MhRgkOZiURXs7MPelCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZVzOlOEBNITS1KzU1ML
	UotgskwcnFINTH0Fc1+6rlob9dzNK8xNJJdn80feaWelVl65e1104Sy3pHDXDV+evJ0oet9b
	cc9Olm0zmdx6E79cztzz6MeHaIVXen2+vDazmu14z9iv2x3/u4dX+uJSxr0Jja/fVT+8U8cY
	bDybb5dWsIcYRy3nPv4fB6LcNuyZdd6g+u8WNt1n/xnmrTvc+nFG/Pv8C0rnBcO3z94RLb8w
	Q59r8cu12bOana9KrSrdnb1J6KmYTOY7puNPvkg1/M/vNeUvbliaH1H8Xei0UozUttYI0beP
	365pDX7AeHwCm/QRE5XElmt6B2dwbfnqN/vXbvOP1Ye4z+wpL5PcmRzlvPJ10ZXVG3ZK+zFJ
	lJ58GLHa8mp4tZ4SS3FGoqEWc1FxIgB7HCs3vgIAAA==
X-CMS-MailID: 20250227053354epcas5p24b589399f9687af1ca1b8ee9b0b246f3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053354epcas5p24b589399f9687af1ca1b8ee9b0b246f3
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053354epcas5p24b589399f9687af1ca1b8ee9b0b246f3@epcas5p2.samsung.com>

The existing header seed is overwritten if zone reset frequency is set or
if verify backlog is enabled. Disable verify header seed check for these
scenarios, unless there is an explicit request to enable it.

Note: There is no fio behavior change intended by this patch.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 init.c   | 11 +++++++++++
 verify.c |  8 --------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/init.c b/init.c
index dc3e7ed1..99661ca8 100644
--- a/init.c
+++ b/init.c
@@ -858,6 +858,17 @@ static int fixup_options(struct thread_data *td)
 			if (!fio_option_is_set(o, verify_write_sequence))
 				o->verify_write_sequence = 0;
 		}
+
+		/*
+		 * Disable rand_seed check when we have verify_backlog, or
+		 * zone reset frequency for zonemode=zbd.
+		 * Unless we were explicitly asked to enable it.
+		 */
+		if (!td_rw(td) || (td->flags & TD_F_VER_BACKLOG) ||
+		    o->zrf.u.f) {
+			if (!fio_option_is_set(o, verify_header_seed))
+				o->verify_header_seed = 0;
+		}
 	}
 
 	if (td->o.oatomic) {
diff --git a/verify.c b/verify.c
index 49d44982..928bdd54 100644
--- a/verify.c
+++ b/verify.c
@@ -934,14 +934,6 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 			memswp(p, p + td->o.verify_offset, header_size);
 		hdr = p;
 
-		/*
-		 * Make rand_seed check pass when have verify_backlog or
-		 * zone reset frequency for zonemode=zbd.
-		 */
-		if (!td_rw(td) || (td->flags & TD_F_VER_BACKLOG) ||
-		    td->o.zrf.u.f)
-			io_u->rand_seed = hdr->rand_seed;
-
 		if (td->o.verify != VERIFY_PATTERN_NO_HDR) {
 			ret = verify_header(io_u, td, hdr, hdr_num, hdr_inc);
 			if (ret)
-- 
2.25.1

