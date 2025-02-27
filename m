Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420DD21D5B0
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639867; cv=none; b=i1OZ2oesj2J8qdyn7sb/vvot26D46Qsf/b/44lTbWrZKhy3o8FgBXlqqsoLWllkezMgtbJ69IcVV1fe3ijPSjZ+yMHox+qsG1T//4rEkkurtzfGIRVuZSPH1+AslaJMJxE4AqvkUi+VZijk9h59dNVJmV7AYTM4ul7mHQd6kT/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639867; c=relaxed/simple;
	bh=tm6egG1t94F+SI7E+vU0BfwQxCMocp+SFfaubKpaRqE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=iYWiHsAZ/Ple/sbJ2eKbs+95ziMt7cAVG4xpWwYPCnAw7EkKPxSPyO+0YO3Xu1tg7OySuK8ImcXnStf3hNo9eQkeDVmmB9D/x+qWoozXJfbuaaqw3HCF1xzuGG5fZoehZ9PpOAaAhhg103OaZ3K7rPZn+xthRKCPbjf5jQDAnHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=LXiyn+XJ; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="LXiyn+XJ"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250227070423epoutp03d98a3e76445658eacad40045a88033e7~n-rvOJ0kM3275632756epoutp03j
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250227070423epoutp03d98a3e76445658eacad40045a88033e7~n-rvOJ0kM3275632756epoutp03j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639863;
	bh=5L3o/oqHkJyZKmTAUlFB/4ViDql0S9Z3g8tHg9SOeyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXiyn+XJEL12RQ7fbSfX5oK0HY4rk0O/aER00nYxSZq6rUfybd12PXGO9DmnYnG7B
	 HTunV8iJe5drQCCtarRUvBEBFdiaKrHyT6Y/az7qcVvXcS9h5brFj4Nwr3VcSRY6Eq
	 DiYxBDIv4Fi3r9r9eJHefqmRL51Ad9WsEoV/gKg8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20250227070423epcas5p49f9256081687510d69a8ab786ca53752~n-ru_MiUI3066230662epcas5p4l;
	Thu, 27 Feb 2025 07:04:23 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Z3MlT0xYtz4x9Q0; Thu, 27 Feb
	2025 07:04:21 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A9.A9.19933.27E00C76; Thu, 27 Feb 2025 16:04:18 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250227053404epcas5p1e5d08c352a8f016c4185f2782689c993~n_c4m93V11213912139epcas5p1A;
	Thu, 27 Feb 2025 05:34:04 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250227053404epsmtrp2aef0ba3e40bc5f0d88d570a9f06264ac~n_c4mXemc2933029330epsmtrp27;
	Thu, 27 Feb 2025 05:34:04 +0000 (GMT)
X-AuditID: b6c32a4a-b87c770000004ddd-74-67c00e721b96
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	E8.EA.33707.C49FFB76; Thu, 27 Feb 2025 14:34:04 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053404epsmtip2b55856be83c8d2f951f8efb4e9b053cd~n_c32vINc1751717517epsmtip21;
	Thu, 27 Feb 2025 05:34:03 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 16/21] t/fiotestlib: improve JSON decoding
Date: Thu, 27 Feb 2025 16:17:22 +0530
Message-Id: <20250227104727.1794982-17-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmpm4R34F0g947ehar7/azWXyc9YLZ
	4nF3B6PFhjZBBxaPnbPusntcPlvq0bdlFaPH501yASxR2TYZqYkpqUUKqXnJ+SmZeem2St7B
	8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QAuVFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnF
	JbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZfbfuMxcsE6z4MXkfewPjRZ4uRk4O
	CQETiY6dn5i6GLk4hAR2M0o8P/ScBcL5xCjx6NNmVjhn49277DAtt75+YYRI7GSUmHrlLlTV
	D0aJ1leNjCBVbALaEq/e3mDuYuTgEBHQkFhzNxUkzCxgI9G8ch/YIGEBK4mVz+ewgdgsAqoS
	U49uZwWxeQXsJe5tvcMGsUxeYual72D1nEDxN52NLBA1ghInZz5hgZgpL9G8dTYzyA0SAsfY
	Ja49uQjV7CKxfuYnKFtY4tXxLVAfSEl8frcXKp4tsenhTyYIu0DiyIteZgjbXqL1VD/Y/cwC
	mhLrd+lDhGUlpp5axwSxl0+i9/cTqFZeiR3zYGxVib/3brNA2NISN99dhbI9JH6cfcUGCatJ
	jBJbmy8zTmBUmIXkn1lI/pmFsHoBI/MqRsnUguLc9NRi0wKjvNRyeCwn5+duYgQnQi2vHYwP
	H3zQO8TIxMF4iFGCg1lJhJczc0+6EG9KYmVValF+fFFpTmrxIUZTYIBPZJYSTc4HpuK8knhD
	E0sDEzMzMxNLYzNDJXHe5p0t6UIC6YklqdmpqQWpRTB9TBycUg1M4j5ul5228rwQdrz5a6e1
	/5EznB+Xv+Etmz2x2O9R4ctSDptzKZcXb57w4snpBZqcSusYKp9rvl7pcWPqEi7JF2eLzU/+
	fLneJkNK/k3iytjr4tEaHZ8m1PNpmerflpy1MvUgR2zlQoc+q9u6OVHCh1evuqYZsN97/tLT
	0X7tTu9O9sle7n2yQlNly8tJSqvUa477fmLfPPsI21dleemlgjy+j1Tu339aOWN7j7DaxndL
	fB5zblr7VKy+OCMjizX/+XzmN6cL58ybHihV8f9Fmry999XLyhemNz0Iep9x3OpVzB9t/XjD
	y2wbJR6yHWVKzdvYHLGLdXrA6c3fzi46vS24w/dUdKLs8f8zgpXOOSmxFGckGmoxFxUnAgDb
	jni0DQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsWy7bCSvK7Pz/3pBu/OaFmsvtvPZvFx1gtm
	i8fdHYwWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGX03brPXLBM
	sOLH5H3sDYwXeboYOTkkBEwkbn39wtjFyMUhJLCdUWL1+mmsXYwcQAlpiYXrEyFqhCVW/nvO
	DlHzjVGi+e9VRpAEm4C2xKu3N5hBbBEBLYlj65rYQHqZBewk1r73AQkLC1hJrHw+hw3EZhFQ
	lZh6dDsriM0rYC9xb+sdNoj58hIzL31nB7E5geJvOhtZQGwhoDELJn5jgqgXlDg58wlYnBmo
	vnnrbOYJjAKzkKRmIUktYGRaxSiaWlCcm56bXGCoV5yYW1yal66XnJ+7iREcnlpBOxiXrf+r
	d4iRiYPxEKMEB7OSCC9n5p50Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzKOZ0pQgLpiSWp2amp
	BalFMFkmDk6pBqaltbc+7pJ/qvQ8TGBFVnyUY/ndRf71y1aWMPYKhJ2auXhVYh+/+NE/U4MC
	kv8umVTp4hew6+XxS7vLpjxc9sy4861HT3HaNMXmIKOrF4wl18fePPstLGtVU4rquaK3Hztj
	Lp8obL2xsvbPj/3r8kOnnLb++PhO1T0hjQtvXiwI0MwONp/I5XntQ7uG9rf5v50i+gz77LMT
	rs0pf/YpOj88XzT03IY3Pj7LZJV+TjtnFvPT/3WD5QXJ+/Ib75V+ti1WWZO17QuH9yQl75v/
	5XmiO/J2OGiobtr1NuDCAf6imYrOVueO18etTzy9buvaWSeOP359TORjtEuUg8rGFz89r19p
	+bpgw4Y09c07Q7eaK7EUZyQaajEXFScCAMBSo1W+AgAA
X-CMS-MailID: 20250227053404epcas5p1e5d08c352a8f016c4185f2782689c993
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053404epcas5p1e5d08c352a8f016c4185f2782689c993
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053404epcas5p1e5d08c352a8f016c4185f2782689c993@epcas5p1.samsung.com>

From: Vincent Fu <vincent.fu@samsung.com>

Sometimes error/informational messages appear at the end of the JSON
data. Try to parse as JSON only the text between the first { and the
last }.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/fiotestlib.py | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/t/fiotestlib.py b/t/fiotestlib.py
index 61adca14..916dc17f 100755
--- a/t/fiotestlib.py
+++ b/t/fiotestlib.py
@@ -260,12 +260,13 @@ class FioJobFileTest(FioExeTest):
             return
 
         #
-        # Sometimes fio informational messages are included at the top of the
-        # JSON output, especially under Windows. Try to decode output as JSON
-        # data, skipping everything until the first {
+        # Sometimes fio informational messages are included outside the JSON
+        # output, especially under Windows. Try to decode output as JSON data,
+        # skipping outside the first { and last }
         #
         lines = file_data.splitlines()
-        file_data = '\n'.join(lines[lines.index("{"):])
+        last = len(lines) - lines[::-1].index("}")
+        file_data = '\n'.join(lines[lines.index("{"):last])
         try:
             self.json_data = json.loads(file_data)
         except json.JSONDecodeError:
@@ -320,12 +321,13 @@ class FioJobCmdTest(FioExeTest):
             file_data = file.read()
 
         #
-        # Sometimes fio informational messages are included at the top of the
-        # JSON output, especially under Windows. Try to decode output as JSON
-        # data, skipping everything until the first {
+        # Sometimes fio informational messages are included outside the JSON
+        # output, especially under Windows. Try to decode output as JSON data,
+        # skipping outside the first { and last }
         #
         lines = file_data.splitlines()
-        file_data = '\n'.join(lines[lines.index("{"):])
+        last = len(lines) - lines[::-1].index("}")
+        file_data = '\n'.join(lines[lines.index("{"):last])
         try:
             self.json_data = json.loads(file_data)
         except json.JSONDecodeError:
-- 
2.25.1

