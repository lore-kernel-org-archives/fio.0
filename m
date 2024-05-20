Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C27850261
	for <fio@vger.kernel.org>; Mon, 20 May 2024 10:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716200411; cv=none; b=PhnkEtUK9An6UBYqdR1Mhc09tqTLgJSVCogEsvjI9m/10kK8lF5+cmxadKCaa+XdCAvHYxoYzqRjiv5w7fYMFus0HpmkP5sasBlOer4ptJUv0Kjr2GgPPjBhCZUcsTNHP4d27WJ9yTBIHkSkeByFirUHp/3T7eVtc+n8yz+y8tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716200411; c=relaxed/simple;
	bh=k1nkImQJS+SK8HpU7AFSCsGy/XxpdxvrBZGPVl3i1Ws=;
	h=Date:From:To:Message-ID:MIME-Version:Content-Type:References; b=elxlAA5nBSJkLEIxX0VtmKXWxNPxOpjkTkGZXM7qcj4KrnGnBEUGEWWoSXCJQOw0Jdr52/73b03TYUx0UsM5Dlk7GJfZwU30WrEiCWc/nAypZvw5y+BEA/s9pgbJKQb/S8e0pRjnjb4A2gU0VdeT1zsLY+LCmE/X3be1/cVwqEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MCgbDOrs; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MCgbDOrs"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240520102003epoutp0381399e27adc02af915e4a8b3d8d6a75e~RKyyl6SaG0843508435epoutp03I
	for <fio@vger.kernel.org>; Mon, 20 May 2024 10:20:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240520102003epoutp0381399e27adc02af915e4a8b3d8d6a75e~RKyyl6SaG0843508435epoutp03I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1716200403;
	bh=k1nkImQJS+SK8HpU7AFSCsGy/XxpdxvrBZGPVl3i1Ws=;
	h=Date:From:To:References:From;
	b=MCgbDOrsJGnBLEGKEH7IB3XNnaIotMqGIuyFGSfXbVkUdn+IA+zpnuO6gGJjo/NpC
	 EExDkaEIO4lhpwJEFd4pk1XL0TFm6KjS4vdRXtAV0eJerMD0ySk3usx845IWildHnt
	 WaaAWHI8Htcw8hSv/zQerOkdo6s/nWv64yg6vUrg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240520102003epcas2p49cb49d6980486504f76b53523a529412~RKyyRzsso1743617436epcas2p4x
	for <fio@vger.kernel.org>; Mon, 20 May 2024 10:20:03 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.102]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4VjYTv0m1rz4x9Pq for
	<fio@vger.kernel.org>; Mon, 20 May 2024 10:20:03 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	D6.26.09673.3D32B466; Mon, 20 May 2024 19:20:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20240520102002epcas2p3d0944968114a664556cbd74d53beddee~RKyxwyCnn2490224902epcas2p3Q
	for <fio@vger.kernel.org>; Mon, 20 May 2024 10:20:02 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240520102002epsmtrp232c4b210cf3616c6696e05303bc8a8b5~RKyxwRnqX1668516685epsmtrp25
	for <fio@vger.kernel.org>; Mon, 20 May 2024 10:20:02 +0000 (GMT)
X-AuditID: b6c32a45-82dff700000025c9-b6-664b23d318eb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	78.47.08390.2D32B466; Mon, 20 May 2024 19:20:02 +0900 (KST)
Received: from localhost (unknown [10.229.54.230]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240520102002epsmtip288a8b921be2dec2e3100bc0410174f70~RKyxofB-11673316733epsmtip21
	for <fio@vger.kernel.org>; Mon, 20 May 2024 10:20:02 +0000 (GMT)
Date: Mon, 20 May 2024 19:09:09 +0900
From: Minwoo Im <minwoo.im@samsung.com>
To: fio@vger.kernel.org
Message-ID: <ZkshRcr4c0GN8xLi@localhost>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsWy7bCmme5lZe80g1tnmS0+znrB7MDo8XmT
	XABjVLZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BeYFecWJucWleul5eaomVoYGBkSlQ
	YUJ2xv9T01gLzjBVrHxj0sC4gamLkZNDQsBE4sGWd+xdjFwcQgI7GCX+tN6DcnqYJNYd2csM
	4Uxgkljw8wI7TMu9A59ZIRJ7GSUeHu2Eamlkklg2+SgzSBWLgKrE1s9LwDrYBNQlGqa+YgGx
	RQTEJa69WAcW5xXQkHh9fSqULShxcuYTFpBBEgLP2STWLrwGNIgDyHGROPYuAWKzsMSr41ug
	rpCS+PxuLxuEXS7x880kRgi7QuLgrNtsEK32Eteep4CEmQUyJG637oIKK0scucUCEeaT6Dj8
	lx0izCvR0SYEMURZ4uOhQ8wQtqTE8kuvoRZ5SBzavpEVxBYSiJWYc2gd+wRG6VlI7p+FZNks
	oKnMApoS63fpQ5jSEsv/cSCJLmBkXcUollpQnJueWmxUYAiPuOT83E2M4LSj5bqDcfLbD3qH
	GJk4GA8xSnAwK4nwbtrimSbEm5JYWZValB9fVJqTWnyI0RQY5hOZpUST84GJL68k3tDE0sDE
	zMzQ3MjUwFxJnPde69wUIYH0xJLU7NTUgtQimD4mDk6pBqa2TYn33Vc0vfk14ZWEjYbrpEOz
	GhymLzqyeEPqWZG8nuSt3ybN+tC7qlt8mX7ch2K2O7l2b54f87t/q21Pi9fr6BkTe1KYVj8+
	zv08YsHSM42MM70aezpqNkzR6Px9b7VbYzRvTLGMy6l/m2yfbEhrav3WUz/jfUXy1eOLA8xP
	bYmfzXlIyHMXv2RZ2HHmGQvCnt+2Xj2rPPoAy4z/c6JDah272WzmPO893mgW7layaPeM9ItH
	ghx71B//Txfsdtqsaxf67Xa9Hrfw/sO2O2Nn3i533Pmtdc6smU57FsrcvnN098aXCquiF7/b
	elA3ZcLjAPZiroqjE3/FNAgIiRmvN1+kM6VrZXtvTe21fW2uSizFGYmGWsxFxYkA08lgC8QD
	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLJMWRmVeSWpSXmKPExsWy7bCSvO4lZe80g5vLjS0+znrB7MDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGmq47LAX8Faf+HWRpYOTpYuTkkBAwkbh34DNrFyMXh5DAbkaJ
	LQ9PsUAkJCX2nb7JCmELS9xvOQJV9J9R4tyig2AJFgFVia2fl7CD2GwC6hINU1+BNYsIiEtc
	e7EOLM4roCHx+vpUKFtQ4uTMJ2A1zED1f+ZdYu5i5ACypSWW/+OYwMgzC0nVLCRVsxCqFjAy
	r2KUTC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECA4RLa0djHtWfdA7xMjEwXiIUYKDWUmE
	d9MWzzQh3pTEyqrUovz4otKc1OJDjNIcLErivN9e96YICaQnlqRmp6YWpBbBZJk4OKUamIJ8
	KqdfeJndyHl9bdCJpI35R5cavTtia9zwtOTULomrzGKX7aaZ/frOJHNO9/HEaXUXHiw8LXzM
	OP7AdS3d3EeJxm69V9s65sxK8bPbHqXD93i7bpxO8ppedWmN7ZOqt7HNTl774ziH/1Lt7Zsm
	XfV6I/i6NtYi6fGV3XPLI7kC584QEwj4MHOBRBZ/7hLz3sdWXJztW5Yf6oozVX0rfqvVYG+n
	w84fbMZ6QV/Ld3i8WhcuzvmbXX9piF7WNcXjv+MZz1Y/+7X51E0HnkjTm/JnNqr+6Hze1lWg
	pFR8/tqS9Myc3vZsmd+H1vrq6ybWSgcyOZXlaIuIy05ckBU9rU5qmWNg1LIz3uu+qdfeUWIp
	zkg01GIuKk4EAJEcJY6AAgAA
X-CMS-MailID: 20240520102002epcas2p3d0944968114a664556cbd74d53beddee
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----18bPhOHZ4t-_CcSgAyEj2-9JxUxziaFjkQ7CDPyIhvGVJv9g=_23b1f_"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240520102002epcas2p3d0944968114a664556cbd74d53beddee
References: <CGME20240520102002epcas2p3d0944968114a664556cbd74d53beddee@epcas2p3.samsung.com>

------18bPhOHZ4t-_CcSgAyEj2-9JxUxziaFjkQ7CDPyIhvGVJv9g=_23b1f_
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline

subscribe fio

------18bPhOHZ4t-_CcSgAyEj2-9JxUxziaFjkQ7CDPyIhvGVJv9g=_23b1f_
Content-Type: text/plain; charset="utf-8"


------18bPhOHZ4t-_CcSgAyEj2-9JxUxziaFjkQ7CDPyIhvGVJv9g=_23b1f_--
