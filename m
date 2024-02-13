Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1720922627
	for <fio@vger.kernel.org>; Tue, 13 Feb 2024 10:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707820231; cv=none; b=cdHi4do2i5Hw6R6WT4WiPvcTBrZJoQ7jm0aTwxlDGUo1SIqVRReCoxL/BqAAC3h9VU8pAc4FgWhd6HLbvRWFN0beg6pETIGUKXXmXCk2QpPWELBCXO1XZmQaotqAOngy2U7lu4hiTM7wuotgpiESATtzSQWkErDE7bgTpmbrfCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707820231; c=relaxed/simple;
	bh=jfAOZybPy9azoucFOhmUQhbxwpx4ixXMgIZBhgQKq74=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=e6r02dg53Pge1M0lFkjIY656vWRZblU/F9FzuQ9dXoOcCELf5Ge9s7pEypiLWzi5hrrHhzcw2mH+Vd54GbSl+PEPzS1qmxXcYHqzA9D+2tCSkiaByjU/XwNKv7XeDwWlG91zObJeHmaIL1oGbOPqRSPHetASM0K4ESY0Q9WtIGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PTJeAcZG; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PTJeAcZG"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240213103025epoutp0256bf67323330d0e7a2583617de080424~zZXJqUMQ32511425114epoutp02L
	for <fio@vger.kernel.org>; Tue, 13 Feb 2024 10:30:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240213103025epoutp0256bf67323330d0e7a2583617de080424~zZXJqUMQ32511425114epoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707820225;
	bh=UI1TZ4X0rU8Aq/rM5pPvwip9gcFudC2VR/O3c4owprs=;
	h=From:To:Cc:Subject:Date:References:From;
	b=PTJeAcZGlFPsFvGlQkOlBQLnLCOtHkZ91mAA0bw42mnitMphsa3070i6rRrEeiqg9
	 zc1VrYI9YG0hlNnyYSKrv50OHQ071jWkcLWAac/WYmpx5pRRvKdsSwKQzgKUzRhmeU
	 Qrsg0wDQ2YfALsOLeEYKVBWfcr4VvvwoAGwfKC20=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240213103025epcas5p191d56b8f76e89eaf8953714a23a4542f~zZXJd3Xjo2272422724epcas5p1b;
	Tue, 13 Feb 2024 10:30:25 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4TYyJc0wmVz4x9Pp; Tue, 13 Feb
	2024 10:30:24 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	57.DD.08567.0C44BC56; Tue, 13 Feb 2024 19:30:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240213101603epcas5p226dc1964544edfb1549fba7734884151~zZKmaAwzl1345113451epcas5p2T;
	Tue, 13 Feb 2024 10:16:03 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240213101603epsmtrp2dbb5b60d1649df89e6026f2430797c45~zZKmZeFOJ1175211752epsmtrp2p;
	Tue, 13 Feb 2024 10:16:03 +0000 (GMT)
X-AuditID: b6c32a44-3abff70000002177-77-65cb44c0080d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F7.50.07368.3614BC56; Tue, 13 Feb 2024 19:16:03 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240213101602epsmtip1995fa290e1ad6e2ae8459306e36a24bd~zZKlpv1Pa0051100511epsmtip1b;
	Tue, 13 Feb 2024 10:16:02 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/5] Protection information support for xnvme ioengine
Date: Tue, 13 Feb 2024 21:03:10 +0530
Message-Id: <20240213153315.134202-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsWy7bCmpu4Bl9OpBncXsVqsufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASlW2TkZqYklqkkJqXnJ+SmZduq+Qd
	HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RQSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
	XGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCd8fz3a/aCLzwVBxbsZm5gnMfVxcjJ
	ISFgItH2+RtLFyMXh5DAbkaJJ5fvMUE4nxglHp28xgpSJSTwjVHi7pxkmI5NE+dAFe1llFhw
	5Rk7hNPJJPHl/W82kCo2AW2JV29vMHcxcnCICGhIrLmbChJmFrCTuHr4JRtIWFjATeLCVB0Q
	k0VAVeLEQ10Qk1fAVuL2BDWITfISMy99ZwexeQUEJU7OfMICMUReonnrbGaQpRICm9glfk/9
	zwbR4CLxZEEzC4QtLPHq+BZ2CFtK4vO7vVA12RKbHv5kgrALJI686GWGsO0lWk/1gx3MLKAp
	sX6XPkRYVmLqqXVMEHv5JHp/P4Fq5ZXYMQ/GVpX4e+821FppiZvvrkLZHhKnpv9mh4RgrMTX
	fS2MExjlZyF5ZxaSd2YhbF7AyLyKUTK1oDg3PTXZtMAwL7UcHqnJ+bmbGMFpTstlB+ON+f/0
	DjEycTAeYpTgYFYS4b0040SqEG9KYmVValF+fFFpTmrxIUZTYAhPZJYSTc4HJtq8knhDE0sD
	EzMzMxNLYzNDJXHe161zU4QE0hNLUrNTUwtSi2D6mDg4pRqY3BnSpwSX3rh541Vh1ZFrEcd3
	34/9aWa2K1Oq0sFHwdiEnUcsa97Rva3z2dINUg6cedwjHrWwtaX99YITyfVNZ8JiM2dse1S2
	WOWYbpsj91Hz9hfz6up5Nd0Kjd8ZzZ3Kpy4/h/XLVdWf2vNnTIk275Q23Vdne40h42qWbknG
	c7Nf/KK825ndT9wInGx8WPn/obnzeb7Vpi1f2Vo9+VRX4bG8B7PkLv+/MG0ja9XVeEsHzTt7
	/jxXbeZ85Dy3Nb3UkaXL8VL3prgDpw8XJDV58ZZJemZds3j4acXNeN5Fy6a52Z49qWQUUcr6
	13GlN/MFi6jgQ5N9Fh72Mllb/ZRraQm75aX5ohvPuk9iYOlUYinOSDTUYi4qTgQA8Oj2p/wD
	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsWy7bCSnG6y4+lUg7+7uC3WXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mp4/vs1e8EX
	nooDC3YzNzDO4+pi5OSQEDCR2DRxDlMXIxeHkMBuRommRTNZuhg5gBLSEgvXJ0LUCEus/Pec
	HaKmnUli0elfzCAJNgFtiVdvb4DZIgJaEsfWNbGB2MwCDhL/dm1hA5kjLOAmcWGqDojJIqAq
	ceKhLojJK2ArcXuCGsR0eYmZl76zg9i8AoISJ2c+YYEYIi/RvHU28wRGvllIUrOQpBYwMq1i
	lEwtKM5Nz002LDDMSy3XK07MLS7NS9dLzs/dxAgOOS2NHYz35v/TO8TIxMF4iFGCg1lJhPfS
	jBOpQrwpiZVVqUX58UWlOanFhxilOViUxHkNZ8xOERJITyxJzU5NLUgtgskycXBKNTAxdjDn
	R6hFvLooFCNYGe/f8ci+c0LOP++jC2ZFHRPJs21JSgrRvjUnovnkW+nCuNnLqoMC+sMavu+4
	cyFvp9wq055Da9bc/1HVtK+58Uhiv531lbKsDp1LHqtvP1uWun+9qU9HjcNT59VB53Z8P/RE
	LEQvM/lL3vbkmBVus/pkHi5MsVbsO/f+tuKyfROm/Fgi8yH0M1e4QMfn00Fn/5UI/H+3YsHr
	T2yvlJnyN/3e0ZJda96ZYFjnyzu93epu6dn36d/CEmatmbrMJa1Yd65f4fbj3bWMD9eKnNj1
	Sbfnsf9ux4V1jRyK7ZIGus7SonYaR4++jtqVLFnSsedd69KNe3rfCr7TmWddXyC+P1qJpTgj
	0VCLuag4EQD8JlX+qAIAAA==
X-CMS-MailID: 20240213101603epcas5p226dc1964544edfb1549fba7734884151
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240213101603epcas5p226dc1964544edfb1549fba7734884151
References: <CGME20240213101603epcas5p226dc1964544edfb1549fba7734884151@epcas5p2.samsung.com>

This series enables protection information support with xnvme ioengine.
The support is provided with the kernel backends that can handle
passthrough commands via nvme character device (/dev/ngXnY), or with
user space nvme drivers such as SPDK and libvfn.

The initial patch adds support for metadata buffer. As we are unaware
of metadata size during metadata buffer allocation, we provide an
option md_per_io_size. This must be used to specify metadata size for
single IO, if namespace is formatted with separate metadata buffer.

This then enables the protection information support with and without
PRACT bit set for both DIF and DIX cases. The support only covers 16-bit
and 64-bit guard protection information format, without storage tags.

For the sake of consistency metadata and protection information specific
options are the same as the ones used by io_uring_cmd ioengine and SPDK's
external ioengine.

Ankit Kumar (5):
  engines/xnvme: allocate iovecs only if vectored I/O is enabled
  engines/xnvme: add support for metadata
  engines:xnvme: add support for end to end data protection
  engines/xnvme: add checks for verify, block size and metadata size
  examples: add PI example with xnvme ioengine

 HOWTO.rst             |  10 +-
 configure             |   2 +-
 engines/xnvme.c       | 331 +++++++++++++++++++++++++++++++++++++++---
 examples/xnvme-pi.fio |  53 +++++++
 examples/xnvme-pi.png | Bin 0 -> 71285 bytes
 fio.1                 |  10 +-
 6 files changed, 378 insertions(+), 28 deletions(-)
 create mode 100644 examples/xnvme-pi.fio
 create mode 100644 examples/xnvme-pi.png

-- 
2.25.1

