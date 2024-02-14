Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E501119E
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 07:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707894070; cv=none; b=Z6ULEg9Kb2Z8GgCiYYt8zSd06stfgOeQBynpPqPzP2LfIuh5BHU6pxL6RHWI1KK+IAFaMb3qop2632wk2Rjw+gjqJGp6Rjmjbwr0+Lfj8zeB/B1EeWjJBRXJK9bPx0zBKvyR2M0WJIccIf8qnWth/Zt+/k2u7/xvpiJDtRKYogs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707894070; c=relaxed/simple;
	bh=OawGq7rx0ThZxk62S1qwu/MrXCR7fQepBpy5iHXnyQo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=tQ84c8jrOyR6Ha9drJXKbCOgWhIChq8PaODmZCgN326sGfmYFI/mG15IUA0DZTnJGC0EuOP6+hSl8TmoyCzzi3oX2zykBrgnGov/ofYAQlPcAalJxcDTkP9cS8zZec5pKs9h+ehJAT7IC2VK4uhu3imq48lR2pG9GX8STOuXBKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=UzJAseqQ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UzJAseqQ"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240214070106epoutp040cea4e7e8c737935371e7c55bd63d4d5~zqJrEMrKN2917529175epoutp04y
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 07:01:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240214070106epoutp040cea4e7e8c737935371e7c55bd63d4d5~zqJrEMrKN2917529175epoutp04y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707894066;
	bh=460LWuJjcpqAYIEyRQhgPK3zlrAWkvK5NlEgRG4j/Yo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UzJAseqQmtqR/1KFrsi5y+luBrUrE7VZDNnQ2yHbHMwwa0XRauBcrdUMBHYsKlGBq
	 pB5ZmzCw0bN3QOptznYPHZexIBIw4WdW9MTCSgDVmBRAWJRcerJegWcJSZ+c+wiS5W
	 XcwGmi6YQJL8oIESJEKijObuuQFuaK0hBSOvTiU0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240214070106epcas5p14cf09395f9c261652af348bfdb271d09~zqJq0d2OV0169701697epcas5p10;
	Wed, 14 Feb 2024 07:01:06 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TZTcc1GFRz4x9QB; Wed, 14 Feb
	2024 07:01:04 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CE.A1.09634.0356CC56; Wed, 14 Feb 2024 16:01:04 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240214070029epcas5p3e34d6ccbff484755ef10224621c3cac8~zqJIgFKJn2318723187epcas5p3D;
	Wed, 14 Feb 2024 07:00:29 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240214070029epsmtrp284f4ed51a78322c5f30251c382311da4~zqJIfeGP40307903079epsmtrp2X;
	Wed, 14 Feb 2024 07:00:29 +0000 (GMT)
X-AuditID: b6c32a49-eebff700000025a2-6a-65cc653098a3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	10.20.08817.D056CC56; Wed, 14 Feb 2024 16:00:29 +0900 (KST)
Received: from unvme-desktop (unknown [107.99.41.39]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240214070028epsmtip1d7e17357fe89491d7d8d53a09721ed94~zqJH9RkVl1083910839epsmtip1V;
	Wed, 14 Feb 2024 07:00:28 +0000 (GMT)
Date: Wed, 14 Feb 2024 17:47:38 +0530
From: Ankit Kumar <ankit.kumar@samsung.com>
To: Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org
Subject: Re: [PATCH 4/5] engines/xnvme: add checks for verify, block size
 and metadata size
Message-ID: <20240214121738.GA135471@unvme-desktop>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ad292863-b1d3-41d1-8c47-4eaadfda3591@gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsWy7bCmhq5B6plUgxXTOCw+znrBbLGhTdCB
	yWPnrLvsHp83yQUwRWXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoq
	ufgE6Lpl5gBNV1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevl
	pZZYGRoYGJkCFSZkZyw7uZG94BxbxdQ7cg2Mh1i7GDk4JARMJI5dje1i5OQQEtjNKPGsI6aL
	kQvI/sQosfZYBzOE841R4uaiBmaQKpCGH08b2CESexkljjw6xQLhvGKUuLCjgQWkikVAVWLK
	2SdgNpuAtsSrtzfAukUEVCQOHpgKFmcWEJe4umAbmC0sECtxft5kRhCbV8BY4sKSqawQtqDE
	yZkQczgFbCWm3ulmBFkmIbCJXWLa71vsECe5SLw4upEVwhaWeHV8C1RcSuLzu71sEHa2xKaH
	P5kg7AKJIy96od6xl2g91c8McVCGxPO7j6DqZSWmnlrHBBHnk+j9/QSql1dixzwYW1Xi773b
	LBC2tMTNd1ehbA+JuQuvQEPlB6PE74cHmCcwys1C8tAsJPsgbB2JBbs/AdkcQLa0xPJ/HBCm
	psT6XfoLGFlXMUqmFhTnpqcWmxYY5qWWw+M4OT93EyM4vWl57mC8++CD3iFGJg7GQ4wSHMxK
	IryXZpxIFeJNSaysSi3Kjy8qzUktPsRoCoygicxSosn5wASbVxJvaGJpYGJmZmZiaWxmqCTO
	+7p1boqQQHpiSWp2ampBahFMHxMHp1QDkwVb9uQ5T0UrXmrfX6Q2u7rxP+dr15Ye793iTbM2
	HfKRVM92nvw6XJApiPGTv/DUdXU3/nzrvOE9pf4R28kVt5i9J998YL2bw956gYLhc57LhZbN
	J7qqlNTrbZY/O9D74IzhB6lJppXLn1v57mQ/c1Yrm8vPVLfrzbvKKXInrGIDVgnwOm5Ku2HX
	Os1j0xKGfZKaCyKiWrKviM47m1n+Olb9sGDKS78jWtvZX27+1CFZcXLXw+uTts9P2qp5zjor
	1+2bUTz7+3/KuR1XFGKkY93v/V5x4e/JCa3c5RLSb581rgjc+yzuWUfG7HAHp92nLwjcX6Tg
	qe5+6j7ntIZZ0Ruk/t5utfMI1/kdu2aPhRJLcUaioRZzUXEiAHEZezX4AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsWy7bCSnC5v6plUg1kr2C0+znrBbLGhTdCB
	yWPnrLvsHp83yQUwRXHZpKTmZJalFunbJXBlNHfPZy7oY6m407+UtYFxNnMXIyeHhICJxI+n
	DexdjFwcQgK7GSWuXfnF2MXIAZSQlli4PhGiRlhi5b/nUDUvGCVe37zCCJJgEVCVmHL2CQuI
	zSagLfHq7Q2woSICKhIHD0wFizMLiEtcXbANzBYWiJXYumw2G4jNK2AscWHJVFaIoT8YJe49
	X8oOkRCUODnzCVSzlsSNfy+ZQA5iBjpo+T8OkDCngK3E1DvdjBMYBWYh6ZiFpGMWQscCRuZV
	jJKpBcW56bnFhgVGeanlesWJucWleel6yfm5mxjBgamltYNxz6oPeocYmTgYDzFKcDArifBe
	mnEiVYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvt9e9KUIC6YklqdmpqQWpRTBZJg5OqQYmD/5D
	Rx0+/vu2a/cDw9CpAXc9O3U9cq/enl22MCtEo6+1s4Q39kXoDx454YunDRdpfN++9nx9l32m
	7om5Z9dxsmja3Kxc+CYhZXEuq93lrHNLpp2cvbOk3bfgwmr2tzO/MbFENNhvcJqwo6/3T2cE
	s8jKBb/c4u5Mi591/cvGCrEF+6trVkS8OTApPjS51//8+/jmRZNsp51zO7fXMFhmf7Bf0bPf
	Lo4iOf+DsiYaL3gsPnVSspJJ9JVz7689mPht0g++W6dn3V29IVO5R931bfL/p25q3RdWphr5
	NPQKXysIKpI53KjZ9eFE4YP9b7o3qt4T7jkuyRbzPeW6K/MpIS/vWmtdmwCvhdZLVJeYK7EU
	ZyQaajEXFScCAAU3Y1m7AgAA
X-CMS-MailID: 20240214070029epcas5p3e34d6ccbff484755ef10224621c3cac8
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----O_pYLLZqQaQzAUO0kznoQ8X86FPiJ6Lw49rSWpfKB5g8Z3ah=_53c69_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240213101606epcas5p34f9948ca837dcb8a2413ede602a7e39c
References: <20240213153315.134202-1-ankit.kumar@samsung.com>
	<CGME20240213101606epcas5p34f9948ca837dcb8a2413ede602a7e39c@epcas5p3.samsung.com>
	<20240213153315.134202-5-ankit.kumar@samsung.com>
	<ad292863-b1d3-41d1-8c47-4eaadfda3591@gmail.com>

------O_pYLLZqQaQzAUO0kznoQ8X86FPiJ6Lw49rSWpfKB5g8Z3ah=_53c69_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Tue, Feb 13, 2024 at 02:20:32PM -0500, Vincent Fu wrote:
> 
> I thought this was wrong at first but I tried it on a device formatted in
> extended LBA mode (4096+64) and indeed lba_nbytes was 4160. I also checked
> the xNVMe source code and found where this can be set to be the sum of the
> LBA data and metadata sizes. It would be helpful to improve the xNVMe
> documentaion to make explicit what this value is.
> 
> Vincent
>

Thanks for pointing it out, we will update the xNVMe documentation
accordingly.

------O_pYLLZqQaQzAUO0kznoQ8X86FPiJ6Lw49rSWpfKB5g8Z3ah=_53c69_
Content-Type: text/plain; charset="utf-8"


------O_pYLLZqQaQzAUO0kznoQ8X86FPiJ6Lw49rSWpfKB5g8Z3ah=_53c69_--
