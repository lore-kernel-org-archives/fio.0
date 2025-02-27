Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566DE22068A
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639855; cv=none; b=qsyGim5lss6WY48KJW6LqnHo4Tw7aIsTlwIRsPdHx/Yqggrzw1j9GnJNUgoe5linfVVAQfz6z35bH/1sS42lYhfDudUpeW1U+uQShBIuzhSTMemy7/lq4ZEPd/WWjSJitsQn1ozYQO98xDeqSxd3ekxLOU9EUo85V0GwCAgJulo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639855; c=relaxed/simple;
	bh=hv45QwDLnPmVRQEDoQggElRJy2bNo3Bjlpu1SdXZ1II=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=qbn1SdrJ7VkvzV7+rwTPwSL0ZlgPlqoCKVcwPVxeYoahUor7+/VolgtQgutHSZhtNlG8NANDYLf0V9kp8h2elfJrr3Yl1/DAf4PE8gRTp4sdzqxPl1fki0lf87ihMX2WcDH/jcEHqz+FTK4qZExBZfhiz4JVoMqDeeVC/jfsaeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IoEA3NuD; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IoEA3NuD"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250227070411epoutp0486c43cd630dcb93bb63fa37b5775ea0b~n-rjsaIT32470424704epoutp04Z
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250227070411epoutp0486c43cd630dcb93bb63fa37b5775ea0b~n-rjsaIT32470424704epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639851;
	bh=TmpK8OqQREVDXdGQnzH6Hc9TL94sa6t5lajKaHS+AVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IoEA3NuDsqY4oSpVRgmb4y99vO8+eS6h7SYj8gJ23pOdoAJsHrqGF5FScVrOpo115
	 ehgRAeOVqMh6gaNU5WPbtepYToTrvO/cXZ0m+0qe6BAa9bbgGE4UnO4X5aJrsO6ZDB
	 qCfJknPLw2qGMNrOZhL4tu211/ugD3GWDLB2n/yA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20250227070410epcas5p3c0125da1edecfa6c23eb7d6d32284aae~n-rjblINf0131701317epcas5p3h;
	Thu, 27 Feb 2025 07:04:10 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Z3MlD3n0bz4x9Q2; Thu, 27 Feb
	2025 07:04:08 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4B.C2.19710.66E00C76; Thu, 27 Feb 2025 16:04:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250227053401epcas5p4e0b8bad9fc7a694a99b71c275a9058bd~n_c1E8Nnv0969609696epcas5p4c;
	Thu, 27 Feb 2025 05:34:01 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250227053401epsmtrp2cf57a1d31754ea95af55e1c13590bbe4~n_c1EQNeo2933029330epsmtrp2Z;
	Thu, 27 Feb 2025 05:34:01 +0000 (GMT)
X-AuditID: b6c32a44-36bdd70000004cfe-62-67c00e66b5e2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C8.A3.18729.849FFB76; Thu, 27 Feb 2025 14:34:00 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053400epsmtip2b36657b3b090d9406742dd5d086e9857~n_c0Y-SoX1588515885epsmtip2U;
	Thu, 27 Feb 2025 05:34:00 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 12/21] init: fixup verify_offset option
Date: Thu, 27 Feb 2025 16:17:18 +0530
Message-Id: <20250227104727.1794982-13-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7bCmlm4a34F0gyMPpSzWXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
	jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOuPMorGAhf8WXlfuZGxi7eboYOTgk
	BEwkHpzg62Lk4hAS2M0ocWXSTlYI5xOjxKMLjYwQzjdGiZ/LnjF1MXKCdfx9/hMqsZdRouvH
	SRYI5wejxNo9jawgVWwC2hKv3t5gBtkhIqAhseZuKkiYWcBO4urhl2wgtrCAucThKaeYQWwW
	AVWJta9egMV5Bewluu/uYodYJi8x89J3MJsTKP6ms5EFokZQ4uTMJywQM+UlmrfOZoaoP8Yu
	cf2mI8RrLhJzu8IhwsISr45vgRopJfH53V42CDtbYtPDn1B/FUgcedELNcZeovVUP9j1zAKa
	Eut36UOEZSWmnlrHBLGVT6L39xOoVl6JHfNgbFWJv/dus0DY0hI3312Fsj0kfq08wwYJqUmM
	Eu2Tp7NNYFSYheSbWUi+mYWwegEj8ypGydSC4tz01GTTAsO81HJ4DCfn525iBCdALZcdjDfm
	/9M7xMjEwXiIUYKDWUmElzNzT7oQb0piZVVqUX58UWlOavEhRlNgcE9klhJNzgem4LySeEMT
	SwMTMzMzE0tjM0Mlcd7mnS3pQgLpiSWp2ampBalFMH1MHJxSDUyrSle+zNX5mC1X59Q4I9Gj
	SJjvRoPfJTGnpkkt7Hrall9mmEyXkMlaO3lDqy3bi2tvPFfov42XcQuMVDYSiLqg6FlzqPD0
	0z27OQ90JaY+3xv8c+KR9Zb9dirsshu+v3vnK6QnXPvQfKbDjWrrX3/XXr/cnsjuYFcdct98
	65/6zX+nZk7uuJ5rYdFRWhW4fFXKp02B0lMF1Jnufvvy5vy1CvU2VfMjZVpZ5/NuFbAuWFP3
	MeaKq1P4q2sZVSXLrt3lWHh9wtT7up+LH559uj67+e6TqWU3/hz5d+YL98ZlZUqSmRt1Lpcl
	PGDi8xG+L1sVcDi26cOZroiNK/qfyXp4Mzsuju6pf3DdkyFvjYsSS3FGoqEWc1FxIgA+qGw6
	CQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSvK7Hz/3pBs/mWVusufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJVx51FYwUL+
	ii8r9zM3MHbzdDFyckgImEj8ff6TsYuRi0NIYDejxKpPH5i7GDmAEtISC9cnQtQIS6z895wd
	ouYbo8T82fPZQRJsAtoSr97eYAaxRQS0JI6ta2IDsZkFHCT+7doCZgsLmEscnnIKrIZFQFVi
	7asXYHFeAXuJ7ru72CEWyEvMvPQdzOYEir/pbGQBsYUE7CQWTPzGBFEvKHFy5hMWiPnyEs1b
	ZzNPYBSYhSQ1C0lqASPTKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4DDV0tzBuH3V
	B71DjEwcjIcYJTiYlUR4OTP3pAvxpiRWVqUW5ccXleakFh9ilOZgURLnFX/RmyIkkJ5Ykpqd
	mlqQWgSTZeLglGpgMsyZ4JD5wCXyjJndpDe9/azZBoKTXk9ZvuT+h00LLWscOtJN/pRe+lN8
	/0eITt3JWfdeb/hzPqj/D1uI4dPpJ7MlNll+TXz23HDmvwcfp73fOc3wlN3RmtlmGQca150T
	XOQ64bJHgfu2S9Ez0pLf39LQKDucru7k9LCSpzjx0rol716t5diYVS+1/e15w9M+BR+iFK93
	ZgRtmjafQz3Z2jitpGqNmLMym3Lo5Ur5iO59n5KqHYsvy+88u7ZmatjPMKGN2t+dJkzk/sss
	nVYt9dzp2vGZPKL93et97ni7T/t948CFXd8XS2R4vO2yOiElsiaTxYHr8PSj+ue3eV5vvXt9
	TZas5v2qj1ztBYV/2pRYijMSDbWYi4oTAad6lGrCAgAA
X-CMS-MailID: 20250227053401epcas5p4e0b8bad9fc7a694a99b71c275a9058bd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053401epcas5p4e0b8bad9fc7a694a99b71c275a9058bd
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053401epcas5p4e0b8bad9fc7a694a99b71c275a9058bd@epcas5p4.samsung.com>

Verify offset should swap verification header within the verify interval.
If this is not the case return error. Update the doc. accordingly.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst |  3 ++-
 fio.1     |  3 ++-
 init.c    | 11 +++++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index ca0044ce..4293c03c 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3929,7 +3929,8 @@ Verification
 .. option:: verify_offset=int
 
 	Swap the verification header with data somewhere else in the block before
-	writing. It is swapped back before verifying.
+	writing. It is swapped back before verifying. This should be within the
+	range of :option:`verify_interval`.
 
 .. option:: verify_interval=int
 
diff --git a/fio.1 b/fio.1
index fd580258..a0f204c0 100644
--- a/fio.1
+++ b/fio.1
@@ -3654,7 +3654,8 @@ same offset with multiple outstanding I/Os.
 .TP
 .BI verify_offset \fR=\fPint
 Swap the verification header with data somewhere else in the block before
-writing. It is swapped back before verifying.
+writing. It is swapped back before verifying. This should be within the range
+of \fBverify_interval\fR.
 .TP
 .BI verify_interval \fR=\fPint
 Write the verification header at a finer granularity than the
diff --git a/init.c b/init.c
index 00a3a8c7..bf257ea1 100644
--- a/init.c
+++ b/init.c
@@ -873,6 +873,17 @@ static int fixup_options(struct thread_data *td)
 				o->verify_write_sequence = 0;
 		}
 
+		/*
+		 * Verify header should not be offset beyond the verify
+		 * interval.
+		 */
+		if (o->verify_offset + sizeof(struct verify_header) >
+		    o->verify_interval) {
+			log_err("fio: cannot offset verify header beyond the "
+				"verify interval.\n");
+			ret |= 1;
+		}
+
 		/*
 		 * Disable rand_seed check when we have verify_backlog,
 		 * zone reset frequency for zonemode=zbd, or norandommap.
-- 
2.25.1

