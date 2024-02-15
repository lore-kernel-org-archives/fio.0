Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E11412BE8B
	for <fio@vger.kernel.org>; Thu, 15 Feb 2024 11:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707995357; cv=none; b=Y+F0Be3y44DdQEmWvmPgubH8d3NN1LIq1UYqGytlelB/W1RxlCQMaKdD14kCvbSSosA1oqAfJloI1HNwKAX6sTkKT4ZPu22vg0im+Vz1LCtloy+yyFwi15TAsKCE+OcAHp6P9ggcJefipy95LAjmVN2P5zv2ASTnFdFUBtfktDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707995357; c=relaxed/simple;
	bh=6ij4iDuNYjeHU+YLs+U6jMvR8m6qFXGuUU7wLKG4pyM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=b/OmKvPdmJyTHe4aSrf+LH+rrAy7r1PnwC/x0hndIGEJigelvJa30LdfHpWdtFUo5CSSBkGZFmivuvsuMCvVymuw99XQwysMw2NJ9skGGYXEfX78YWk1zYCxxdgP7F6p9JaPohNv1rybhvggQW6tQxGy9m/BTADSkfdsqADoSjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rPmDbvXf; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rPmDbvXf"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240215110912epoutp010a36833f7b44f8a359a49e674ebec9ec~0BLlFwP0-0601606016epoutp01m
	for <fio@vger.kernel.org>; Thu, 15 Feb 2024 11:09:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240215110912epoutp010a36833f7b44f8a359a49e674ebec9ec~0BLlFwP0-0601606016epoutp01m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707995352;
	bh=Qj4TZy6pwc0fDDNYM1hb9HEOURX4pXI/VwQ3tFTZtVE=;
	h=From:To:Cc:Subject:Date:References:From;
	b=rPmDbvXfKS0dOeP6qJEGsPlDfV0IOpET+w9KaOx/dEzSXIdxyor7HN8hIsXOE8rRe
	 NkxkrFg8tZJebu+b2IsOhHJQNzbmdNogWwRcUgVYhOw2+m0PYLklAneytZMyowdDB8
	 EkJKCWcTc/icKdX20gaw3a2ZNnEtaSCNKnN/KFAs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240215110911epcas5p41051b078a57a2f3040ff46c21e3899da~0BLkLDFAv2634026340epcas5p4n;
	Thu, 15 Feb 2024 11:09:11 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TbC4P6MPmz4x9Q0; Thu, 15 Feb
	2024 11:09:09 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4C.A3.08567.5D0FDC56; Thu, 15 Feb 2024 20:09:09 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240215100103epcas5p3271477465b0155deb7483f26858087ec~0AQE9LQyn1352613526epcas5p3y;
	Thu, 15 Feb 2024 10:01:03 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240215100103epsmtrp2e0f63f84d0721395656d0b089e0f962b~0AQE8k7Qx1302013020epsmtrp2E;
	Thu, 15 Feb 2024 10:01:03 +0000 (GMT)
X-AuditID: b6c32a44-3abff70000002177-c3-65cdf0d5ca18
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AA.2E.08817.FD0EDC56; Thu, 15 Feb 2024 19:01:03 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240215100102epsmtip2096b90dfd29b60c5d4de6f5d702ba5ee~0AQEEVEkA2363023630epsmtip2o;
	Thu, 15 Feb 2024 10:01:02 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, joshi.k@samsung.com, Ankit Kumar
	<ankit.kumar@samsung.com>
Subject: [PATCH v2 0/3] Support trim with multiple ranges
Date: Thu, 15 Feb 2024 20:48:09 +0530
Message-Id: <20240215151812.138370-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsWy7bCmlu7VD2dTDZbNVrdYc+U3u8Xqu/1s
	Fh9nvWC2OPr/LZvFhjZBB1aPnbPusntcPlvq0bdlFaPH501yASxR2TYZqYkpqUUKqXnJ+SmZ
	eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QFuVFMoSc0qBQgGJxcVK+nY2Rfml
	JakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZyw/NYSzYK1Cx/Ld/A+N8
	ri5GTg4JAROJxdvWs4LYQgK7GSW+LmGEsD8xSny7n9LFyAVkf2OU+Nn+nwmm4czSs8wQib2M
	Elve32GFcDqZJLp2bQRrZxPQlnj19gZQFQeHiICGxJq7qSBhZoFQif6WDhYQW1jAUuLt6wdg
	NouAqkTrjU6wK3gFbCU6ZkLYEgLyEjMvfWeHiAtKnJz5hAVijrxE89bZYEdICGxjl7h1dTk7
	RIOLxI2+11C2sMSr41ugbCmJz+/2skHY2RKbHv6E+qZA4siLXmYI216i9VQ/2M3MApoS63fp
	Q4RlJaaeWscEsZdPovf3E6hWXokd82BsVYm/926zQNjSEjffXYWyPSSWNh9jhoRorMSE2RMZ
	JzDKz0Lyziwk78xC2LyAkXkVo2RqQXFuemqyaYFhXmo5PFaT83M3MYJTnpbLDsYb8//pHWJk
	4mA8xCjBwawkwjup90yqEG9KYmVValF+fFFpTmrxIUZTYBhPZJYSTc4HJt28knhDE0sDEzMz
	MxNLYzNDJXHe161zU4QE0hNLUrNTUwtSi2D6mDg4pRqY1mvd4l0n8nb6rZVHlkixxTFnRuqv
	WXm7661awMJT+mcvVne8P8N+t222rXSEqT6D14fc1r4fU7ulnf9Nn7DhREfwzbL/rzfosGlF
	lmirrEwwfphdxill891JytQh5VS53z91sXiB3bdKl0opfNh1+NvtQ/tmbojbqxX348uGgG2t
	e7Y8fMDlxbF0brfOl85icYHGRO9WnaUny3b13tlUFqArnD7DYl1jy8KQiIt3pe7wqF1sPMF/
	Yh9n9YGHHUJyZ3vEu9udjD5MtOudsG3vdtb9DNUSn21LztbkfExKP6V0JdL97Nvt1RsKT34z
	K732VjeZVfTBpNdn4+SS/8hn3Fn29FblyzUnQuecnZp3R4mlOCPRUIu5qDgRAOvgg64CBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsWy7bCSvO79B2dTDf5uk7RYc+U3u8Xqu/1s
	Fh9nvWC2OPr/LZvFhjZBB1aPnbPusntcPlvq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBnL
	D81hLNgrULH8t38D43yuLkZODgkBE4kzS88ydzFycQgJ7GaUmPR9B2sXIwdQQlpi4fpEiBph
	iZX/nrND1LQzSbz+1MsIkmAT0JZ49fYGM4gtIqAlcWxdExuIzSwQLtE4G6SBk0NYwFLi7esH
	LCA2i4CqROuNTlYQm1fAVqJjJoQtISAvMfPSd3aIuKDEyZlPWCDmyEs0b53NPIGRbxaS1Cwk
	qQWMTKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS83M3MYIDUEtrB+OeVR/0DjEycTAeYpTg
	YFYS4Z3UeyZViDclsbIqtSg/vqg0J7X4EKM0B4uSOO+3170pQgLpiSWp2ampBalFMFkmDk6p
	BqZNc5reSbpdmKTOdPl1n/3JAwXKfQr2TnXitpOCbz/4xuCm+qqxcoe3sGTwW+6wr3OlFvV3
	bi74IHg95sKqqHP3j9sfUX7yykzSTTBYtb9Yu9AizzfjlrzHglbWFGO29VdPvLyyRnDV0R/P
	jCNlruzoDK5v/nV2f09PRu79ql47k6d/26vebmv3yTwirMx8ak5BadXOVQsepU60Fle5XV76
	c0dpotsKDnvZXR0Kpws+Mi9faFKWG7Lk5y6z046/J/9sbfrKJF5X8S9y2aEvSybMvSixPe/I
	ymmqbGwy9zIv/XLQeCrH1Ga2USxHMlGa5ajMUivFzxtCHzll+q/YyKyVE5qnr7w6h62jce7p
	7UosxRmJhlrMRcWJAPw1y0+vAgAA
X-CMS-MailID: 20240215100103epcas5p3271477465b0155deb7483f26858087ec
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240215100103epcas5p3271477465b0155deb7483f26858087ec
References: <CGME20240215100103epcas5p3271477465b0155deb7483f26858087ec@epcas5p3.samsung.com>

NVMe specification allow multiple ranges for the dataset management
command. The block ioctl only accepts a single entry for trim, but
with nvme character device we can send multiple ranges.

The first patch in this series adds an option num_range to send multiple
range per trim request. This will only work if the data direction is
solely trim i.e. trim or randtrim.

The next two patches in this series updates io_uring_cmd ioengine with
the required changes.

Note: The first patch which changes the io_u request for multiple ranges
can be used in future for NVMe copy command which copies multiple source
range entries to single destination.

Changes since v1:
 - Remove unnecessary else conditions and bump server version as
   suggested by Jens.
 - Separate function to fill buffer with source range entries as
   suggested by Jens.
 - Debug log for trim offsets and man page update for num_range
   as suggested by Vincent.
 
Ankit Kumar (3):
  trim: add support for multiple ranges
  engines/nvme: pass offset and len instead of io_u
  engines/io_uring: add multi range dsm support

 HOWTO.rst                               |  9 +++
 backend.c                               | 20 ++++-
 cconv.c                                 |  2 +
 engines/io_uring.c                      | 34 +++++++--
 engines/nvme.c                          | 72 +++++++++++-------
 engines/nvme.h                          |  7 +-
 examples/uring-cmd-trim-multi-range.fio | 21 ++++++
 fio.1                                   |  7 ++
 fio.h                                   | 18 +++++
 init.c                                  | 13 ++++
 io_u.c                                  | 97 +++++++++++++++++++++----
 io_u.h                                  |  4 +
 ioengines.h                             |  2 +
 options.c                               | 11 +++
 server.h                                |  2 +-
 thread_options.h                        |  3 +
 16 files changed, 266 insertions(+), 56 deletions(-)
 create mode 100644 examples/uring-cmd-trim-multi-range.fio

-- 
2.25.1

