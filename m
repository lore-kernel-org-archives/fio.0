Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B95E21D5B1
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639868; cv=none; b=HImTVGvrMbS15BcsKkOf5S5oX+kQ9Dgaw+cdqn+jqhdom0daRuLpgewlos8NxG5BzPV39CHJRydVy1JwsSXyetsamACx2LvwZJedyd4Jie+YoUzv0Y/NVXFCXQqAAEM+2KCD1Xoswslz3DvqD4W4mZPz0Pw2VuTOBOye9hzP0Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639868; c=relaxed/simple;
	bh=lQzteB8GUsfZQgXE/7nMFlEnmWTN78afGkLvvsMIrPM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=VZTkSNrKy2wte8qjdKwVbqXzq2L6s+L/d/8GUlU1zLQTQOEVrDzwAmWQDzRGL7RUy6Ubj2gGDeqqHyZomejiAJTydua/hKCe1E1bt9n6NqKPvvK9uuawRzMNq1UgAATSyPYbK4+STF14VcXqq7lJHrx2OTUXuseqMuRHgzHNA7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BEEsLgAz; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BEEsLgAz"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250227070425epoutp027820e66dd6dbc7b443d5dce68b5282c0~n-rwyNgcl1670216702epoutp02S
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250227070425epoutp027820e66dd6dbc7b443d5dce68b5282c0~n-rwyNgcl1670216702epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639865;
	bh=RCyOHo4QveVQVI5Mp9Nxq5DWIgJq17JMQcn+f2kYfXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEEsLgAzVsVS0CgmTJL778xjSK09hMhgfnsBsKaqZJenlVscpgYq2UWV9RNjNhcM+
	 HjmaZynb6Q9W00L79z4QBMVWgnKfBvsK0INJsq73XpJ8siPnOhfj+PnYx3frHOFS/y
	 LxzcNXQWZQrGx8HCTZFKcGd/ll91TZMs0y8lZUDo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20250227070424epcas5p3963c2d65a72c63662e94e0ba6f418e15~n-rwbYE781433414334epcas5p3M;
	Thu, 27 Feb 2025 07:04:24 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Z3MlV4fnYz4x9Q6; Thu, 27 Feb
	2025 07:04:22 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	68.D2.19710.47E00C76; Thu, 27 Feb 2025 16:04:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250227053405epcas5p3a607ae211a910b0957d11a9f75baf9a3~n_c5cszVX0147701477epcas5p3o;
	Thu, 27 Feb 2025 05:34:05 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250227053405epsmtrp245105d5232eadf39db944459a25dbf45~n_c5cDhBV2935229352epsmtrp2x;
	Thu, 27 Feb 2025 05:34:05 +0000 (GMT)
X-AuditID: b6c32a44-36bdd70000004cfe-94-67c00e7491cf
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	39.EA.33707.D49FFB76; Thu, 27 Feb 2025 14:34:05 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053404epsmtip2f8b0baceeae2de9dde5b2e75cf36a643~n_c4r4T201588515885epsmtip2j;
	Thu, 27 Feb 2025 05:34:04 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 17/21] t/fiotestlib: display stderr size when it is not
 empty but should be
Date: Thu, 27 Feb 2025 16:17:23 +0530
Message-Id: <20250227104727.1794982-18-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmlm4J34F0g9YVFhar7/azWXyc9YLZ
	4nF3B6PFhjZBBxaPnbPusntcPlvq0bdlFaPH501yASxR2TYZqYkpqUUKqXnJ+SmZeem2St7B
	8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QAuVFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnF
	JbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZC34+YiuYwVax4WNaA+Mmli5GTg4J
	AROJA+s/sXUxcnEICexmlDiz7S8jhPOJUeLGsXcIzoMt7UAtHGAty6abgnQLCexklFi6Ogqi
	5gejxIT2t4wgCTYBbYlXb28wg9SLCGhIrLmbChJmFrCRaF65jx3EFhaIlZgy7yETiM0ioCqx
	ecEMsDivgL3E772H2CCuk5eYeek7WJwTKP6ms5EFokZQ4uTMJywQM+UlmrfOZga5QUJgH7vE
	o1ldzBDNLhI/Zn9lhbCFJV4d38IOYUtJfH63F2pBtsSmhz+ZIOwCiSMveqF67SVaT/WD3c8s
	oCmxfpc+RFhWYuqpdUwQe/kken8/gWrlldgxD8ZWlfh77zY0dKUlbr67CmV7SNxc/Roa0pMY
	JR79/MM+gVFhFpJ/ZiH5ZxbC6gWMzKsYJVMLinPTU5NNCwzzUsvhUZycn7uJEZwCtVx2MN6Y
	/0/vECMTB+MhRgkOZiURXs7MPelCvCmJlVWpRfnxRaU5qcWHGE2BAT6RWUo0OR+YhPNK4g1N
	LA1MzMzMTCyNzQyVxHmbd7akCwmkJ5akZqemFqQWwfQxcXBKNTCFTzo0d8P7gqNl5lxLX9Zd
	OmJRccLr2bY1k09t1GMXfrQ5aZfJpFa2oCuevVkJofdC60NYLh0teNcW4qbyRYJrd//NI9P3
	17pelElc/c7mVHKm0oKJF39WG//XPdcSYemlJOLsNjG786c6s9kzsbX21tKxfIb3N07u6Tf6
	LL9x08Q1fevb9x1OSHk4/5+Aw73VFxw7/4XJ7tN6GrDptlWSsfK+6rtf6844qvTomJ42Nl4z
	adq2mK2roieGTd3L2+K093Ayy6ztb/2W/7o+ecnqP2/TNgrZLr+8+GxFwkK382Jlr/Yks37J
	OXXjv3WX0Ww1Bs1H/nYtZ1zsHlf82BFUuaT039K6/tgN6audRf1eKrEUZyQaajEXFScCAKQu
	UeYKBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsWy7bCSvK7vz/3pBruXa1isvtvPZvFx1gtm
	i8fdHYwWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGUs+PmIrWAG
	W8WGj2kNjJtYuhg5OCQETCSWTTftYuTiEBLYzijRO6WZESIuLbFwfWIXIyeQKSyx8t9zdoia
	b4wSby82soEk2AS0JV69vcEMYosIaEkcW9fEBtLLLGAnsfa9D0hYWCBa4sTtJ6wgNouAqsTm
	BTPYQWxeAXuJ33sPsUHMl5eYeek7WJwTKP6ms5EFxBYCGrNg4jcmiHpBiZMzn4DFmYHqm7fO
	Zp7AKDALSWoWktQCRqZVjKKpBcW56bnJBYZ6xYm5xaV56XrJ+bmbGMGhqRW0g3HZ+r96hxiZ
	OBgPMUpwMCuJ8HJm7kkX4k1JrKxKLcqPLyrNSS0+xCjNwaIkzquc05kiJJCeWJKanZpakFoE
	k2Xi4JRqYMo9wPA5/GNGCSf71FdFTV+epCZHf2KaxrvPhGNWJpNxd8zMj0Utk9p/OBhKK70/
	LXEsTzhpubtiTKl0R5BN2tIfoXUu0c1njZS52MMV5h0LXzZpxYWnapvNw6W0rv8uOLYqS7rN
	4m8jzy59G6a6UwuWznvruv2m19vUFIuvxr5Lvplsf/5r/bvktpOv5qd+dzgy97+j5pvs4yZ/
	dL3cM4I5Et6tX8IU/e36x6lL7oRfa1aN9LT/NSlkaUXx2z6XQ9W7q+W33/7L4/w12+LSyu1r
	5i3+6nmz0Tszktnsxc3Xaw5fbwjayKC29czt82HfbyUwu/Yl1/zKjroTEGOmoXa0pdMzY6XT
	rKCFlr/0vJVYijMSDbWYi4oTAU5Qdie8AgAA
X-CMS-MailID: 20250227053405epcas5p3a607ae211a910b0957d11a9f75baf9a3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053405epcas5p3a607ae211a910b0957d11a9f75baf9a3
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053405epcas5p3a607ae211a910b0957d11a9f75baf9a3@epcas5p3.samsung.com>

From: Vincent Fu <vincent.fu@samsung.com>

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/fiotestlib.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/t/fiotestlib.py b/t/fiotestlib.py
index 916dc17f..913cb605 100755
--- a/t/fiotestlib.py
+++ b/t/fiotestlib.py
@@ -139,7 +139,7 @@ class FioExeTest(FioTest):
         if 'stderr_empty' in self.success:
             if self.success['stderr_empty']:
                 if stderr_size != 0:
-                    self.failure_reason = f"{self.failure_reason} stderr not empty,"
+                    self.failure_reason = f"{self.failure_reason} stderr not empty size {stderr_size},"
                     self.passed = False
             else:
                 if stderr_size == 0:
-- 
2.25.1

