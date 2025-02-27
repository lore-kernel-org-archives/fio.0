Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737DA21D599
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639844; cv=none; b=SzKe52kAuN0/71Zkf/f02G7ALqHzDk6YC09Iv0URPpOkgp9jTcfkoblHLxz+G63m/nn9KURMR8hlWnIRoUGG2JxHaQOTVv6tzaNud60ju/mJ5rnSZTHEt2li8/BUQUXBZHeaF+2fusvkB3/lcz+3lRPrIEwzpNUm/m2KtvlHy3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639844; c=relaxed/simple;
	bh=QRcAcfX93hlRHs7giswem/dqIlIMuR5p/4gbtOlcaLo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=AXXZc1tuuzn5EfFuhIUepb7U9NFMEhf2au0XLKw07g4n+/gsd9EhAsgYFK/fKd/ybtIX28Hh/yeYqPYBkYKCgp67Zs+bKJExQOagKhY3NVPi2lb1567KlPa8TGrf/WGr68hYY90qsYZgkSKOIi/5nvTdFl+timu9oPO0zDfU3Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=suFx6qyx; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="suFx6qyx"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250227070400epoutp01c3fcac732b8791655b0766a71291bb52~n-rZ2Zj-U2750427504epoutp01I
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250227070400epoutp01c3fcac732b8791655b0766a71291bb52~n-rZ2Zj-U2750427504epoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639840;
	bh=EKI+eFJ9TIxI+7qNQjsHjptKQLxC4O1UC1va96CIoAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suFx6qyxJ4qMlvvYaRpY4uffx3Q4olFTiQoBUbdW4O8WOMhxB0hfrTtBk1LURiez5
	 5nddrDLbmmio5mVo/Xxn0ZaobpcRq7iP77qJ4I4lqpIzxARLDZEcdx1b1bD+u/6FM4
	 NvYASCs6sypAEkvlWcs4+N/LZnZfgttjabbXYiDI=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20250227070400epcas5p49a447eb7f80dcd12493fda9d2b427edd~n-rZknQVq0973309733epcas5p4i;
	Thu, 27 Feb 2025 07:04:00 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Z3Ml23Vbkz4x9Px; Thu, 27 Feb
	2025 07:03:58 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4D.B2.19710.E5E00C76; Thu, 27 Feb 2025 16:03:58 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250227053358epcas5p3dc60854eed31f0469175d649854fa81f~n_cykFhaK0471304713epcas5p3y;
	Thu, 27 Feb 2025 05:33:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250227053358epsmtrp1e7b1afb3680d19dfbba6ff57671ff37a~n_cyjaG0h1011310113epsmtrp1b;
	Thu, 27 Feb 2025 05:33:58 +0000 (GMT)
X-AuditID: b6c32a44-363dc70000004cfe-3d-67c00e5ec235
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	26.A3.18729.649FFB76; Thu, 27 Feb 2025 14:33:58 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053357epsmtip22e6c2f53e96c5164b8067e65ffdb170a~n_cx1ivWk1753617536epsmtip2X;
	Thu, 27 Feb 2025 05:33:57 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 09/21] verify: fix verify issues with norandommap
Date: Thu, 27 Feb 2025 16:17:15 +0530
Message-Id: <20250227104727.1794982-10-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmpm4c34F0g+kvJSzWXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
	jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOWHXFqeCUdMWaD68ZGxh7xboYOTgk
	BEwk/kyu6mLk4hAS2M0o8f3yfkYI5xOjxPZ/25ghnG+MElNb9rF0MXKCdazt28wEkdjLKDFh
	wWZmkISQwA9GidkLQkBsNgFtiVdvbzCDrBAR0JBYczcVJMwsYCdx9fBLNhBbWMBRovneTnYQ
	m0VAVeLg22+sIDavgL3EwdU7WSF2yUvMvPQdrIYTKP6ms5EFokZQ4uTMJywQM+UlmrfOBjtU
	QuAUu8S7L5PZIZpdJFY+Ogw1SFji1fEtUHEpiZf9bVB2tsSmhz+ZIOwCiSMvepkhbHuJ1lP9
	YPczC2hKrN+lDxGWlZh6ah0TxF4+id7fT6BaeSV2zIOxVSX+3rsNDStpiZvvrkLZHhJd329B
	A3QSo8SzQ18YJzAqzELyzywk/8xCWL2AkXkVo2RqQXFuemqyaYFhXmo5PIqT83M3MYJToJbL
	DsYb8//pHWJk4mA8xCjBwawkwsuZuSddiDclsbIqtSg/vqg0J7X4EKMpMMAnMkuJJucDk3Be
	SbyhiaWBiZmZmYmlsZmhkjhv886WdCGB9MSS1OzU1ILUIpg+Jg5OqQamPK78Q2Vvd15evLpy
	Wd5BUSPrjICsZOagWVIlivpmGpXRk1VedTalF3LnyNyfyfctb8vklFnn7yV+vVJ5Z9cL3dxQ
	+VulFRvadIUXOenOml8ty9sjm7ZZaWvYOubugkA/9sUh056aTLNsvHQ30lX9lpZxhInizzVG
	r0LjO2TcLXrNhCa+N2Nf+LSQYcveNjeW85vnTzi2Ye3eyhC72MWMO1M/Tmj9Y7e0I3lN58Zd
	y2WXb9s3217VunI6m/2+W3ElOy4vVvq4bIvux9NPi866sQj62TN833TG49zUH2bsKve3aZjO
	V1D3jZqYvdVK8Mu7VcFKdW8LpMI+igeuMLWM2H/i/7fTC1hYFl5mklquxFKckWioxVxUnAgA
	3BssbAoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSvK7bz/3pBqu2ClisufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJWx6opTwSnp
	ijUfXjM2MPaKdTFyckgImEis7dvM1MXIxSEksJtR4tzyL8xdjBxACWmJhesTIWqEJVb+e84O
	UfONUWL+vBmMIAk2AW2JV29vMIPYIgJaEsfWNbGB2MwCDhL/dm0Bs4UFHCWa7+1kB7FZBFQl
	Dr79xgpi8wrYSxxcvZMVYoG8xMxL38FqOIHibzobWUBsIQE7iQUTvzFB1AtKnJz5hAVivrxE
	89bZzBMYBWYhSc1CklrAyLSKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4TLU0dzBu
	X/VB7xAjEwfjIUYJDmYlEV7OzD3pQrwpiZVVqUX58UWlOanFhxilOViUxHnFX/SmCAmkJ5ak
	ZqemFqQWwWSZODilGpj6J08NdDD9pfL+YHKKwY4deRJzD66t05rBffKsUevkBmHLmPu3n7tp
	1v5KPFNz4tCsCf8tor7fUHyh4WweeDc+mS3K6mBtEN+CeztjZJJncYous7722G//Xf2fBfFX
	2WXNr96WCVp0m2PWY9aulv7PpZNzqljsD59YxTzpD4s7E29J/gGBVd3lLNfC0/2Oz42r/Ra8
	Vij2pE+kuqbblutnNOuCpEs0g3NO95vYxP9d6/PevGVZtOWMe3a6S0OlK7SX7Lyw1nHCU85z
	dgnz5wueVeftXmzIvm96z759h6+t+riia8u9ggMfZuidmaDybs2sNUznlqbc37ipWK95wvMC
	r7bcSXu8bgvu7axKXi2ixFKckWioxVxUnAgA9XviGMICAAA=
X-CMS-MailID: 20250227053358epcas5p3dc60854eed31f0469175d649854fa81f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053358epcas5p3dc60854eed31f0469175d649854fa81f
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053358epcas5p3dc60854eed31f0469175d649854fa81f@epcas5p3.samsung.com>

When norandommap is enabled, fio logs the I/O entries in a RB tree. This
is to account for offset overlaps and overwrites. Then during verify
phase, the I/O entries are picked from the top and in this case the
smallest offset is verified first and so on. This creates a mismatch
during the header verification as the seed generated at the time of read
differs from what was logged during write. Skip seed verification in
this scenario.

fixes #1756

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 12 +++++++-----
 fio.1     |  3 ++-
 init.c    |  6 +++---
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 6d462af3..fa6b44a5 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1564,11 +1564,13 @@ I/O type
 	this option is given, fio will just get a new random offset without looking
 	at past I/O history. This means that some blocks may not be read or written,
 	and that some blocks may be read/written more than once. If this option is
-	used with :option:`verify` and multiple blocksizes (via :option:`bsrange`),
-	only intact blocks are verified, i.e., partially-overwritten blocks are
-	ignored.  With an async I/O engine and an I/O depth > 1, it is possible for
-	the same block to be overwritten, which can cause verification errors.  Either
-	do not use norandommap in this case, or also use the lfsr random generator.
+	used with :option:`verify` then :option:`verify_header_seed` will be
+	disabled. If this option is used with :option:`verify` and multiple blocksizes
+	(via :option:`bsrange`), only intact blocks are verified, i.e.,
+	partially-overwritten blocks are ignored. With an async I/O engine and an I/O
+	depth > 1, it is possible for the same block to be overwritten, which can
+	cause verification errors. Either do not use norandommap in this case, or also
+	use the lfsr random generator.
 
 .. option:: softrandommap=bool
 
diff --git a/fio.1 b/fio.1
index 3fbc1657..07f09f07 100644
--- a/fio.1
+++ b/fio.1
@@ -1368,7 +1368,8 @@ Normally fio will cover every block of the file when doing random I/O. If
 this option is given, fio will just get a new random offset without looking
 at past I/O history. This means that some blocks may not be read or written,
 and that some blocks may be read/written more than once. If this option is
-used with \fBverify\fR and multiple blocksizes (via \fBbsrange\fR),
+used with \fBverify\fR then \fBverify_header_seed\fR will be disabled. If this
+option is used with \fBverify\fR and multiple blocksizes (via \fBbsrange\fR),
 only intact blocks are verified, i.e., partially-overwritten blocks are
 ignored.  With an async I/O engine and an I/O depth > 1, it is possible for
 the same block to be overwritten, which can cause verification errors.  Either
diff --git a/init.c b/init.c
index 3d6230cb..91f056e3 100644
--- a/init.c
+++ b/init.c
@@ -863,12 +863,12 @@ static int fixup_options(struct thread_data *td)
 		}
 
 		/*
-		 * Disable rand_seed check when we have verify_backlog, or
-		 * zone reset frequency for zonemode=zbd.
+		 * Disable rand_seed check when we have verify_backlog,
+		 * zone reset frequency for zonemode=zbd, or norandommap.
 		 * Unless we were explicitly asked to enable it.
 		 */
 		if (!td_write(td) || (td->flags & TD_F_VER_BACKLOG) ||
-		    o->zrf.u.f) {
+		    o->zrf.u.f || o->norandommap) {
 			if (!fio_option_is_set(o, verify_header_seed))
 				o->verify_header_seed = 0;
 		}
-- 
2.25.1

