Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA1017F8
	for <fio@vger.kernel.org>; Mon, 22 Jan 2024 06:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705904042; cv=none; b=GcgtmhHFdVg00UewbXauBBwQcMG5HboY+BzJwFV5mVn6PWG1j9+2p8UlM9ti+OsZNuhQEG/V/VGcwltO0eP0Iq4j5cTs8XccT5n/4BnO+CxhNs9FEKnVK85dt9oSV/QRlfQWL+aasVd2Em39PDCTCpMdmCq39aPrcZhvdoUzVQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705904042; c=relaxed/simple;
	bh=9jOIIdswFsObuCVMDcEBICP+Xz1GgG9iNJxKv9UXm9c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=pL8SZShMrapm6WzMgEbU6KF6aZnf3nKeGH1f3CsnhTmRVuAtB5Nhybj2bWm/j2scFTIyaTj+GKVdGoDEW0rGSgsabhEnna3EhYNnH1cayEivZShoYBALIDUsiXf4rZaL7uz7KE/7sExE+TdsiykHjc38sAjI1MPJTbtsftQdwjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XOtV6UW/; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XOtV6UW/"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240122061349epoutp014ee936e37e90730215664d59d5667ab2~slq1BJwKS1861818618epoutp01L
	for <fio@vger.kernel.org>; Mon, 22 Jan 2024 06:13:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240122061349epoutp014ee936e37e90730215664d59d5667ab2~slq1BJwKS1861818618epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1705904029;
	bh=iq1FpIncUn2GQP7Xm75imw78YiEMDAWW94OmAv6uy/w=;
	h=From:To:Cc:Subject:Date:References:From;
	b=XOtV6UW/NJNwlR+tdlDyHBv1iRwmLp7WmrpjyAEZ3/y3x+NQPeb6bG6QiXe8rfO0X
	 y36cWa8EcvC5ge4gyzFthqgBNtjkc7cJUGDt1OWFlFgI6vY/kEBXLlQm9WrYxqksLK
	 8vUaUzezsSA/37ytgnt5oYm+ajN4b9Rh3RSj9o7o=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240122061349epcas5p338197f385e73471b01f52948e2e98f0d~slq0y72jN2939229392epcas5p3K;
	Mon, 22 Jan 2024 06:13:49 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4TJKfj3Hnvz4x9QF; Mon, 22 Jan
	2024 06:13:49 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	43.1A.09634.D970EA56; Mon, 22 Jan 2024 15:13:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240122060524epcas5p1ef9946a897a9a25b6b89072f01fdc924~sljelTgdX0123701237epcas5p1L;
	Mon, 22 Jan 2024 06:05:24 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240122060524epsmtrp148526d98e3622632b42abf18a24a47f5~sljekv0aY1826318263epsmtrp1T;
	Mon, 22 Jan 2024 06:05:24 +0000 (GMT)
X-AuditID: b6c32a49-eebff700000025a2-12-65ae079d17dd
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	D3.AF.18939.4A50EA56; Mon, 22 Jan 2024 15:05:24 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240122060523epsmtip17b0fa6540ffe2796887661382a86f216~sljd1E7rs2204422044epsmtip1M;
	Mon, 22 Jan 2024 06:05:23 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/2] log both average and max values over the window
Date: Mon, 22 Jan 2024 16:52:58 +0530
Message-Id: <20240122112300.47805-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsWy7bCmhu5c9nWpBuv/S1isufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASlW2TkZqYklqkkJqXnJ+SmZduq+Qd
	HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RQSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
	XGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdceFzTcE3topbzRMZGxj3sXYxcnBI
	CJhIrFoT18XIxSEksJtRYtK7TSxdjJxAzidGid71FhAJIHvBpAmMIAmQhr2vFjBBJHYySkw5
	eIMNwulkkjj8fx07SBWbgLbEq7c3mEFWiAhoSKy5mwoSZhawk7h6+CUbiC0s4CLxYvcXVhCb
	RUBV4t2XdrDNvAI2EnvXXWWHWCYvMfPSd3aIuKDEyZlPWCDmyEs0b53NDFGzil1iyyJeCNtF
	Ytm3E1C9whKvjm+BsqUkXva3QdnZEpse/mSCsAskjrzohZpjL9F6qh/sZGYBTYn1u/QhwrIS
	U0+tY4JYyyfR+/sJVCuvxI55MLaqxN97t1kgbGmJm++uQtkeEjsf3mKEBGisROOJS6wTGOVn
	IflmFpJvZiFsXsDIvIpRMrWgODc9tdi0wDAvtRweqcn5uZsYwWlOy3MH490HH/QOMTJxMB5i
	lOBgVhLh5VddlSrEm5JYWZValB9fVJqTWnyI0RQYxBOZpUST84GJNq8k3tDE0sDEzMzMxNLY
	zFBJnPd169wUIYH0xJLU7NTUgtQimD4mDk6pBqaKTJmA+lVTlnHsn9d6wbdgy7vZT1483Rl2
	32PhxZ31aZ2Vt+YqHD+0Zdu5MKEYO5G7tyyduIMeP/7/ef235Fcb+Gokv1s1eN+96iUQt1hx
	aY5T8tHSxXzeO55oMb8t0Csp7Zqmx3pojnAE6wHDl8m1e5mVqlfcOiUSHyXFsOxJ0UJ7+73r
	NE9OLFpl9F1+3Vaf4h/f9dwKGqRffArT3LJ94bH7M7Oazr0+KRP/eOL6ruSr60qMt75X3e2z
	4KMkZ3zuk5h/N+6eYPXkZPXv/5I0kbFt71H5E3VMldvFH/PnLTKOrREXl510eUZzzRylS4WX
	1Tq8ntqcejer6+ON/kO3Ni4zZD9wLX7Hw+aH8rquSizFGYmGWsxFxYkA2z1fwvwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsWy7bCSnO4S1nWpBtNfy1qsufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJVx4XNNwTe2
	ilvNExkbGPexdjFyckgImEjsfbWAqYuRi0NIYDujxL6vd5i7GDmAEtISC9cnQtQIS6z895wd
	oqadSeJi71ZGkASbgLbEq7c3mEFsEQEtiWPrmthAbGYBB4l/u7aA2cICLhIvdn8BW8YioCrx
	7ks7C4jNK2AjsXfdVXaIBfISMy99Z4eIC0qcnPmEBWKOvETz1tnMExj5ZiFJzUKSWsDItIpR
	NLWgODc9N7nAUK84Mbe4NC9dLzk/dxMjONy0gnYwLlv/V+8QIxMH4yFGCQ5mJRFeftVVqUK8
	KYmVValF+fFFpTmpxYcYpTlYlMR5lXM6U4QE0hNLUrNTUwtSi2CyTBycUg1MQbzzV0WtcJ63
	2MTg6XGz1S5RG+dubn+/7U/nLNOtq3U3RJlan56y2evczUWhpTmPToqVn3Y+WOD8yMLtagnj
	E/bTHNsv+GTPtmjzjC/YKv5+dazorGWimvcidZ8sk71/8Jn/jK2G/TwdeZJ7F3vf33z3bFGh
	8mFVj7XSX4/2abxgc0wWXfYr9qmHbr5IQMx2peLQwIANqifPiGrfkREN1zc9yxaucqL/wYXL
	opbTahI28gvarLlRN7v640qrwgLZrxtdmviajD3nzdy63aqZO2xe4LRdR89L79BLiBR+OuX7
	J4MVlevDL7rO018jyvD116kEMfl/IZLx2z6yTE52S0rZ8qmpfe6vsIXr9hzkVmIpzkg01GIu
	Kk4EAObq0UKmAgAA
X-CMS-MailID: 20240122060524epcas5p1ef9946a897a9a25b6b89072f01fdc924
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240122060524epcas5p1ef9946a897a9a25b6b89072f01fdc924
References: <CGME20240122060524epcas5p1ef9946a897a9a25b6b89072f01fdc924@epcas5p1.samsung.com>

This series modifies option log_max_value to report average, max or both
the values. The log_max_value option type has been changed from boolean to
integer with min and max capped to 0 and 2 respectively. There is no
change to existing log formats while reporting only average or max values.
The fio documentation has been updated specifying the new log format
when both values are reported.

Ankit Kumar (2):
  stat: log out both average and max over the window
  docs: update fio man page for log_max_value

 HOWTO.rst | 23 +++++++++++------
 client.c  |  6 +++--
 fio.1     | 29 +++++++++++++++-------
 iolog.c   | 74 ++++++++++++++++++++++++++++++++++++++++---------------
 iolog.h   | 21 +++++++++++++---
 options.c |  8 +++---
 server.c  |  6 +++--
 stat.c    | 32 ++++++++++++++----------
 8 files changed, 140 insertions(+), 59 deletions(-)

-- 
2.25.1

