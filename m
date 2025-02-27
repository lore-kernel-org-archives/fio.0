Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36BB21B9CB
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639851; cv=none; b=si/6+YbcbdXpHW1szyN8VZNC/eq2EeaiIiCc23GKSf0XPMlhDzZ5wFThM2kKBL5rBH3rM84+puZZ5KroGW9r0V9f9McW0k4tUCm//dzKOY5wRWGWoK1sjrn1p13eJVVY5z+oZJPC5PksdNMlm4LaskxYVKMu4eKiJy+gyeq7PGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639851; c=relaxed/simple;
	bh=V/+OlpTLbAT0xO51u1UgjC9DHKe0wM2+7BCuXSkstmc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=r/8dCFV5D7Hd9OHjdiY2ARuqVYDcWfR/U1mARGql0NStLODpCIjX27BnmqT4T16oK9DIslDeLWwiFB+v+BTPbeMUH02xuZZOQvKdzdSE4F15Peuapayr2dog35HSFton0AkLWGxgoUvFKPeFed/tzeHYC3KshGh7OSk9EiKZeTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JZ/5OlCF; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JZ/5OlCF"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250227070407epoutp034131a898881d5308ef35f2e688f3a619~n-rgsxU0B3275632756epoutp03W
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250227070407epoutp034131a898881d5308ef35f2e688f3a619~n-rgsxU0B3275632756epoutp03W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639848;
	bh=Qr4Z5sleYsmb8sGB5MmiVLITNHrbiNCrVeZf6H+hEDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZ/5OlCFJomqkeIvIVd6OumMnGxXz0X01l7jIz0d+FG0+vNiCrYIaDSu16/t6QriH
	 aSNb1Z5j8LVNIC26B240JokG8BiDHOa4CrTIW2Xv+nYbNn9oKdMiuztbMfH7ApqoRx
	 UyIpVN9c1LP03p9cJC+MZZRJGfIa7vVmAGYtL+c8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20250227070407epcas5p3618ae641acc600bec29129eff09bfa7a~n-rgSyaWL0230602306epcas5p3Z;
	Thu, 27 Feb 2025 07:04:07 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Z3Ml94BgCz4x9Pw; Thu, 27 Feb
	2025 07:04:05 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0B.6B.19956.36E00C76; Thu, 27 Feb 2025 16:04:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250227053400epcas5p1229c23f190b23adcaaeae26d321c3942~n_c0SBT-T1213912139epcas5p13;
	Thu, 27 Feb 2025 05:34:00 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250227053400epsmtrp2ab76d9d569d77ac77fedb3d2d2e03040~n_c0RR2EB2933029330epsmtrp2K;
	Thu, 27 Feb 2025 05:34:00 +0000 (GMT)
X-AuditID: b6c32a4b-fe9f470000004df4-9a-67c00e634c33
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	70.EA.33707.849FFB76; Thu, 27 Feb 2025 14:34:00 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053359epsmtip29796574d629f5117fa6c156562aa85e9~n_czh_Mj31588515885epsmtip2R;
	Thu, 27 Feb 2025 05:33:59 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 11/21] backend: fix verify issue during readwrite
Date: Thu, 27 Feb 2025 16:17:17 +0530
Message-Id: <20250227104727.1794982-12-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmum4y34F0g00HuS3WXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
	jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjO2LzvG0vBffaK7rOrmRoYF7B1MXJy
	SAiYSCw/eJKxi5GLQ0hgN6NES9sTNgjnE6PEvLsrEJwfU1tZYVpOLNnNDGILCexklNi1zxWi
	6AejxLenq1hAEmwC2hKv3t4AKuLgEBHQkFhzNxUkzCxgJ3H18Euw1cICjhJLp7eyg5SwCKhK
	TJzpDBLmFbCX2NszgwVilbzEzEvf2UFsTqD4m85GFogaQYmTM5+wQIyUl2jeOpsZ5AQJgUPs
	EnufzGSHaHaRmLbqCxOELSzx6vgWqLiUxOd3e6Hez5bY9PAnVE2BxJEXvcwQtr1E66l+sPOZ
	BTQl1u/ShwjLSkw9tY4JYi+fRO/vJ1CtvBI75sHYqhJ/792Gul9a4ua7q1C2h8TTG1ug4TmJ
	UWLW2ztMExgVZiH5ZxaSf2YhrF7AyLyKUTK1oDg3PbXYtMA4L7UcHsfJ+bmbGMFJUMt7B+Oj
	Bx/0DjEycTAeYpTgYFYS4eXM3JMuxJuSWFmVWpQfX1Sak1p8iNEUGN4TmaVEk/OBaTivJN7Q
	xNLAxMzMzMTS2MxQSZy3eWdLupBAemJJanZqakFqEUwfEwenVANT2hlv8/Lfq2ae26OasIK5
	4H/ZI+7oV+HhE1ceni7xsPfdvB4V4YUcR7bN4f76LoBryczX+569kp2Uqi/sULFr8cxTYUv5
	tO2OTf3V63k+4N8KA+HowwKBx559YPVNiX79af2em8dTJG3i1j9YNEFzi6fl9R+XvZ8urIu7
	YRdW6Xmy30HklpPbgquXt533/5l4a4dhiE+X+L84nnT380u/Oe5guCtvOP2rhYehhVd+N9+b
	Kr7LRy5FMv7lV/nzaeaTy0oLLPQEE+yKp08SZnt56Y7N6jPZy7h5Mh8fyvq0Ya3unk7n/aL3
	kn6XT9npaHD195Y3e2KLGK5MNp7zgscgNbk/tUEn5vDfWd779v5eZaDEUpyRaKjFXFScCADA
	+igECwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsWy7bCSvK7Hz/3pBo/PsVqsufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJWxed83loL7
	7BXdZ1czNTAuYOti5OSQEDCROLFkN3MXIxeHkMB2Rompz5qAEhxACWmJhesTIWqEJVb+e84O
	YgsJfGOU2NecBGKzCWhLvHp7gxnEFhHQkji2rglsJrOAg8S/XVvAbGEBR4ml01vZQUayCKhK
	TJzpDBLmFbCX2NszgwVivLzEzEvfwcZzAsXfdDayQKyyk1gw8RsTRL2gxMmZT1ggxstLNG+d
	zTyBUWAWktQsJKkFjEyrGEVTC4pz03OTCwz1ihNzi0vz0vWS83M3MYKDUytoB+Oy9X/1DjEy
	cTAeYpTgYFYS4eXM3JMuxJuSWFmVWpQfX1Sak1p8iFGag0VJnFc5pzNFSCA9sSQ1OzW1ILUI
	JsvEwSnVwGS56e3WN3lL5DtsU9rSmKrfdO8MEHyyueUCx4eZIXEvagMP/VnWJmKqtN36/OHr
	9UuNkrdaf4yUsUw2srvc/oL99tfwYG3l6PUnzUpfK0TND8kw6/v+7pK1kLb8/ylVvs/Tk/ad
	zeEtXrhU1irm/2HWqVVnDBX/NYTMbH3Llyd340szw9f1YWn/55qVSJz6/OhqYeCB5/4Tvv4y
	XWUX+SL8nsjNyC0Lvm2a1X1Ou9JWRqN8yqZdAglWzzgWuDCd6NoQ/VXXsEKT93TlTYmq2aGX
	EtY+TeENKNtw9WBlXDXTCcObe2ed6I/Iy5/0P69Yo/bNKk3RL/ffP+zYEPyJ8e43j6Nbknpe
	Hpg4v/i5RKASS3FGoqEWc1FxIgCcO5YdvQIAAA==
X-CMS-MailID: 20250227053400epcas5p1229c23f190b23adcaaeae26d321c3942
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053400epcas5p1229c23f190b23adcaaeae26d321c3942
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053400epcas5p1229c23f190b23adcaaeae26d321c3942@epcas5p1.samsung.com>

In readwrite mode if specified io_size > size, offsets can overlap.
This will result in verify errors. Add check to handle this case.

Fixes: d782b76f ("Don break too early in readwrite mode")

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 backend.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/backend.c b/backend.c
index f5cfffdb..b75eea80 100644
--- a/backend.c
+++ b/backend.c
@@ -978,8 +978,11 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 	if (td_write(td) && td_random(td) && td->o.norandommap)
 		total_bytes = max(total_bytes, (uint64_t) td->o.io_size);
 
-	/* Don't break too early if io_size > size */
-	if (td_rw(td) && !td_random(td))
+	/*
+	 * Don't break too early if io_size > size. The exception is when
+	 * verify is enabled.
+	 */
+	if (td_rw(td) && !td_random(td) && td->o.verify == VERIFY_NONE)
 		total_bytes = max(total_bytes, (uint64_t)td->o.io_size);
 
 	/*
-- 
2.25.1

