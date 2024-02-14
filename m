Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339E111CBB
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 06:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707893963; cv=none; b=bxKncyY4LxdITixvwgYtbZtc5ilCiwXRU5YWes+xHW2CEOSNOv6xZIqlINGo66+HhVC9ngkimyKAYjkSEYoV1dtGyaNWaKt3pNwv2axNjJgy14oXm6/g9zpWv3nqSyG24gXEHjl2DffZy8IfnaaRdPPUIawlpB81/KnYzvaKQHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707893963; c=relaxed/simple;
	bh=+FIy1owzPCLA29KjEkoepMkY5XHbbr0/wpkdxmFTFi8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=gVHbmz3PO/6qcaEoFRS7+tByAKwLqN8ukzIhgOvJ6bh4Hh+rVbC/tdlB3Uoru9XVqA0lnKSQoWvI9gRFnd0KEhHW/mqbmoAhyewX+iEQt9sfwVFeDhwzl4/ksnHjY3olXEEE6TSba9VShk+BYfP6ACGp9cDn1k05bbqh++/LHO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XVixhYhW; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XVixhYhW"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240214065917epoutp014e0877ac81c558c768ed4174112345c4~zqIF65D701465114651epoutp01e
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 06:59:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240214065917epoutp014e0877ac81c558c768ed4174112345c4~zqIF65D701465114651epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707893957;
	bh=JCqq4hCNBHHe491uEqxVji3/erRSQZeWfy6R4Ggbx1Y=;
	h=From:To:Cc:Subject:Date:References:From;
	b=XVixhYhWwPwB7MOjywV5wTJrncVu01wTp09msmKqonEnPWn+ZgAjcQ0jEO3Ibcqzf
	 BLW92KPAsCM2By1aOIFvBAsgys8bFDENT8oKH7jbejJmKDmf5VsW+YkpVSCdpT8+iY
	 +VUgIZ1dkcgkws2lShiNfICa7sUoAU44aUvUbhEs=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240214065917epcas5p41bb22f2eec0267d0ef484d045989271f~zqIFkxMq72166921669epcas5p45;
	Wed, 14 Feb 2024 06:59:17 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4TZTZW2tQ4z4x9Q1; Wed, 14 Feb
	2024 06:59:15 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C5.EE.19369.1C46CC56; Wed, 14 Feb 2024 15:59:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240214064924epcas5p12bee438c7815ca28e43a536459bcddc2~zp-c_qD9p0288302883epcas5p1v;
	Wed, 14 Feb 2024 06:49:24 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240214064924epsmtrp122beb56fe05ad258fb002ca3f58cb71b~zp-c_B5VE2450824508epsmtrp1y;
	Wed, 14 Feb 2024 06:49:24 +0000 (GMT)
X-AuditID: b6c32a50-c99ff70000004ba9-5a-65cc64c171ec
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B5.4F.08817.3726CC56; Wed, 14 Feb 2024 15:49:23 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240214064923epsmtip108a4ee2eb37285917eb49c0e39c71c11~zp-cJSzSs0624306243epsmtip1h;
	Wed, 14 Feb 2024 06:49:23 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, joshi.k@samsung.com, Ankit Kumar
	<ankit.kumar@samsung.com>
Subject: [PATCH 0/3] Support trim with multiple ranges
Date: Wed, 14 Feb 2024 17:36:21 +0530
Message-Id: <20240214120624.135416-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsWy7bCmlu7BlDOpBtdvcFisufKb3WL13X42
	i4+zXjBbHP3/ls1iQ5ugA6vHzll32T0uny316NuyitHj8ya5AJaobJuM1MSU1CKF1Lzk/JTM
	vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoK1KCmWJOaVAoYDE4mIlfTubovzS
	klSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMtUdPMxV856s4/OMRWwPj
	Us4uRk4OCQETicUvFrF0MXJxCAnsYZToX36HFcL5xCjx8UATE4TzjVFiV/M3ZpiWtm9/GSES
	exklPp3/CpYQEuhkkuj/wghiswloS7x6ewMozsEhIqAhseZuKkiYWSBUor+lgwXEFhYwk/h2
	7CGYzSKgKvHw9V12EJtXwFZixo35ULvkJWZe+g4VF5Q4OfMJC8QceYnmrbOZQW6QENjGLjFl
	UQvYLgkBF4kD+zwheoUlXh3fwg5hS0m87G+DsrMlNj38yQRhF0gcedELtcteovVUP9gYZgFN
	ifW79CHCshJTT61jgljLJ9H7+wlUK6/EjnkwtqrE33u3WSBsaYmb765C2R4Sz3csZYeETqzE
	8YOPmSYwys9C8s0sJN/MQti8gJF5FaNUakFxbnpqsmmBoW5eajk8XpPzczcxgtOeVsAOxtUb
	/uodYmTiYDzEKMHBrCTCe2nGiVQh3pTEyqrUovz4otKc1OJDjKbAMJ7ILCWanA9MvHkl8YYm
	lgYmZmZmJpbGZoZK4ryvW+emCAmkJ5akZqemFqQWwfQxcXBKNTCJmOw/oHs2+9vce+d/Lmnq
	cAqwWWonKhBoffQy173UhL/73Coelchvn7T2rkV/Nr8uzz1ByT63O6uCTjEenJb/uNL61NRP
	NasC/8ZefzotV6Tr1kPh8xbiMtYnZr159zHjZldd4cV33tvvP5a7xyGy4shdkfseRV9ZonQd
	Z350qph5942o6e6I0Hk2bPKPDd6fWj6f9dWXjQeWOMpHV9Szn/rCtn+Z6uGcoJk1S+7WltjV
	aJhNjDw78WpYAf+V1mtHKhPzWytuKlX+WyTJfU3A4NRp9gVTNH9NLL4g9TN4rizzuaYp7RFR
	b07e2NqStDEm9OS7/XXJ5lmfHRdE3y5p2ujjrrz7qEVIst6EhfYsSizFGYmGWsxFxYkAFQyA
	rQQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsWy7bCSnG5x0plUg3ObrC3WXPnNbrH6bj+b
	xcdZL5gtjv5/y2axoU3QgdVj56y77B6Xz5Z69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8ba
	o6eZCr7zVRz+8YitgXEpZxcjJ4eEgIlE27e/jF2MXBxCArsZJZ6+38XWxcgBlJCWWLg+EaJG
	WGLlv+fsEDXtTBIdV5+ygSTYBLQlXr29wQxiiwhoSRxb1wQWZxYIl2icDdLAySEsYCbx7dhD
	FhCbRUBV4uHru2BxXgFbiRk35jNDLJCXmHnpO1RcUOLkzCcsEHPkJZq3zmaewMg3C0lqFpLU
	AkamVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwSGopbWDcc+qD3qHGJk4GA8xSnAw
	K4nwXppxIlWINyWxsiq1KD++qDQntfgQozQHi5I477fXvSlCAumJJanZqakFqUUwWSYOTqkG
	ps1lu1wEvpu2u/qnmdnIzeKzt3lvvsqFqS5uYqPYtUn9fE+upKz9ycB+6dJzV5UfnE8n37yr
	wlNjcqcxqSno7twYD6292223ZF2+3TxbXyFA7YDmBcti19aJfJpnld92RIZF1M94q9/3QFSL
	I/pOzbfuwpu6vX+MGw+EHVx8IiDstdjmjKlTOvzX80oc+jN353G1nrS91X+e606SF5+80CEn
	dk9mpso2/8ArjurSOnX/+DSlV84LOlPpsL9/S8gavtmZWq9L2+5MDbq3oF9LbqvF0hKRmkWm
	cuLs5w+IOKscK9Ev3Kz8jP+NRJXn3yvz3H+v2WL4N2Gn99va/4F7bk3nZ1ga+uEbz+8dosKR
	SizFGYmGWsxFxYkAUV/EprACAAA=
X-CMS-MailID: 20240214064924epcas5p12bee438c7815ca28e43a536459bcddc2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240214064924epcas5p12bee438c7815ca28e43a536459bcddc2
References: <CGME20240214064924epcas5p12bee438c7815ca28e43a536459bcddc2@epcas5p1.samsung.com>

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

Ankit Kumar (3):
  trim: add support for multiple ranges
  engines/nvme: pass offset and len instead of io_u
  engines/io_uring: add multi range dsm support

 HOWTO.rst                               |   7 ++
 backend.c                               |  20 +++++-
 cconv.c                                 |   2 +
 engines/io_uring.c                      |  34 ++++++++--
 engines/nvme.c                          |  68 ++++++++++++--------
 engines/nvme.h                          |   7 +-
 examples/uring-cmd-trim-multi-range.fio |  21 ++++++
 examples/uring-cmd-trim-multi-range.png | Bin 0 -> 61922 bytes
 fio.1                                   |   6 ++
 fio.h                                   |  18 ++++++
 init.c                                  |  13 ++++
 io_u.c                                  |  81 +++++++++++++++++++-----
 io_u.h                                  |   4 ++
 ioengines.h                             |   2 +
 options.c                               |  11 ++++
 thread_options.h                        |   3 +
 16 files changed, 244 insertions(+), 53 deletions(-)
 create mode 100644 examples/uring-cmd-trim-multi-range.fio
 create mode 100644 examples/uring-cmd-trim-multi-range.png

-- 
2.25.1

