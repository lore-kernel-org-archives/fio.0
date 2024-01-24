Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908A0168A4
	for <fio@vger.kernel.org>; Wed, 24 Jan 2024 07:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080428; cv=none; b=u+/Svl/kUrXUTGt8KCVKlcNwxLFZIW53oDLv5C7I//FNEM0gmcUyL4jtpUNBlRLHEydNLhZq4AHM8ZzQYxJZkrZkJFYKh14PXCoVlZvOxmQkp/WZAEGlFJ5PewhbgObh+1l+Ta5pko/Qnroei2GjGr2R3CrOpa4WMZr1p3RX5g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080428; c=relaxed/simple;
	bh=hpPjlTkaNxmOKW4e5IDL3bV6sSlzonit/2VDsg1kBwU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=iHDL+iRlxmr2C8RgGIn+Ee2hBl1JPukAoBS0VKcyfAhjyGb+iTcf+F2qEYDMfQddP+lOAmvxXTrJsX/fh6EYCLKL/NPk8CRSPXsW+LaV9DIbpSIFKPGnSVjqvLZrXc8TE87FjRND0JqW6O8/AHEzgXYGcdiLkU9Oz2+UrqvcPXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=q1qeHVSL; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="q1qeHVSL"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240124071342epoutp04541600b32c402027b57995400cf063fd~tNxrcjlGa1548815488epoutp04f
	for <fio@vger.kernel.org>; Wed, 24 Jan 2024 07:13:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240124071342epoutp04541600b32c402027b57995400cf063fd~tNxrcjlGa1548815488epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706080422;
	bh=o4xEQZ7+JlFFps73PBmRTOebJIOyZCuMAaSwrqd2i7k=;
	h=From:To:Cc:Subject:Date:References:From;
	b=q1qeHVSLP/Xy8xwKqMf55Yr/i6KfoPidvYTRaWVH1PndK+VaH42wTo/6T5RMmsZun
	 weuPzud/R1gUQUlpyngn5QuIUdV8RJiT8c5FlAM86B+K6/ELJAl/SC6fShx0tT1QVT
	 RyWmTXIiAoUq0DQiiD0qgCMUn09YVMozTlqxuV+U=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240124071342epcas5p4ece54239ca1e6b94c712e5f5996a9335~tNxrOZwfB2519425194epcas5p45;
	Wed, 24 Jan 2024 07:13:42 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4TKZtr1fQZz4x9Q6; Wed, 24 Jan
	2024 07:13:40 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	19.A6.19369.3A8B0B56; Wed, 24 Jan 2024 16:13:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240124061714epcas5p36e87ac4a06e9187bf8d818b04bd1c4cf~tNAYSRB5f1701817018epcas5p3H;
	Wed, 24 Jan 2024 06:17:14 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240124061714epsmtrp1e0b82e57255badf58c93891c537edf0e~tNAYRpMq00248502485epsmtrp1y;
	Wed, 24 Jan 2024 06:17:14 +0000 (GMT)
X-AuditID: b6c32a50-c99ff70000004ba9-e1-65b0b8a3bd61
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	D3.39.18939.A6BA0B56; Wed, 24 Jan 2024 15:17:14 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240124061713epsmtip10f34a52ebab23c0c35d0ba5ed2332623~tNAXf7tKU1302713027epsmtip1t;
	Wed, 24 Jan 2024 06:17:13 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 0/2] log both average and max values over the window
Date: Wed, 24 Jan 2024 17:04:11 +0530
Message-Id: <20240124113413.52550-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmlu7iHRtSDc7MY7NYc+U3u8Xqu/1s
	Fh9nvWC22NAm6MDisXPWXXaPy2dLPfq2rGL0+LxJLoAlKtsmIzUxJbVIITUvOT8lMy/dVsk7
	ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ihkkJZYk4pUCggsbhYSd/Opii/tCRVISO/
	uMRWKbUgJafApECvODG3uDQvXS8vtcTK0MDAyBSoMCE7o+frJPaCG5wVPbsvsDUwPmLvYuTk
	kBAwkfh1fAtzFyMXh5DAHkaJZStWsEM4nxgltu49zATnbDq6H67l+dK/UFU7GSU2fp8GVdXJ
	JPF8+XImkCo2AW2JV29vAA3m4BAR0JBYczcVJMwsYCdx9fBLNhBbWMBd4t/e42A2i4CqxJqN
	y5hBbF4BG4kzs+ZCLZOXmHnpOztEXFDi5MwnLBBz5CWat85mhqhZxi7x7KAOhO0i0fW7nRHC
	FpZ4dXwL1BwpiZf9bVB2tsSmhz+ZIOwCiSMveqHm2Eu0nuoHO5lZQFNi/S59iLCsxNRT65gg
	1vJJ9P5+AtXKK7FjHoytKvH33m0WCFta4ua7q1C2h8SLpldg44UEYiVO3e5hmcAoPwvJN7OQ
	fDMLYfMCRuZVjFKpBcW56anJpgWGunmp5fCITc7P3cQITndaATsYV2/4q3eIkYmD8RCjBAez
	kgjvDcl1qUK8KYmVValF+fFFpTmpxYcYTYFhPJFZSjQ5H5hw80riDU0sDUzMzMxMLI3NDJXE
	eV+3zk0REkhPLEnNTk0tSC2C6WPi4JRqYFqSrr1WNPGzuMCdqvZ7/hzpal2Hou913lmfd7ZS
	4ccU10OnGTYzbYzrnKvxUD13Rpjl/i47xTr+typ1Ovw7ugu+8n1mWT7VoneB+dy1L7gEQ1b0
	1izut3jN7sO4/1MR85zKpgepy9TerNswbZ9s8xnngwcKpYp72flOnPB5uKLx7m9Xd85Pidts
	39k8PHvgicKkU4lfDT7WTQ6uTNs/d+erbSUTuTJMYjaXilccPXg6v+X5qQ/Fs1c+2Re23qgk
	4+B5t9xIjsu3Wm98Pe+Zc2GGV+fSHd67PihNrziTw723ZP7Rq8tXhPI/mJ+1yvtB0O+HuyJO
	73BJE5nz9lTk0kNpk2IbM+WbX71ZpPi2Xvm3EktxRqKhFnNRcSIAqw3O6QAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsWy7bCSnG7W6g2pBrtbxS3WXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mro+TqJveAG
	Z0XP7gtsDYyP2LsYOTkkBEwkni/9C2RzcQgJbGeUWLXtElMXIwdQQlpi4fpEiBphiZX/nkPV
	tDNJ3PtwFqyZTUBb4tXbG8wgtoiAlsSxdU1sIDazgIPEv11bwGxhAXeJf3uPg9ksAqoSazYu
	A6vnFbCRODNrLtQR8hIzL31nh4gLSpyc+YQFYo68RPPW2cwTGPlmIUnNQpJawMi0ilE0taA4
	Nz03ucBQrzgxt7g0L10vOT93EyM44LSCdjAuW/9X7xAjEwfjIUYJDmYlEd4bkutShXhTEiur
	Uovy44tKc1KLDzFKc7AoifMq53SmCAmkJ5akZqemFqQWwWSZODilGpjstt+2YLn57OOklZd8
	A1K0emZWlMs0bmdgCdeeLD9X6NLrdQzyjctCv/6Xvmgtn/HmVE265OSiNek7H6+b+ExnWumT
	r7tUe7ssjHlM8j5u+J0c9yjk0MS8JzNml7N72Z1fwjhTIEbkf75xbJ/VVm/XIzc3nBCsX7vH
	WT//wMTV9YtkubxYixXy+Ze6uVVsXdr4NOJnG3cw34mN/U/ueP6LeDThzmrO7HN22hnzvrZW
	F1foSM5QVNhr1cGirrxH6N++F+F/mg/MS9/HX/9HqotVMGoyR5wh+zemJ+fWLNwd++bsoR02
	k4/wt6QtbauokFmukt63waWc1375RuHLAYx8CuJXY/0tY1dqXJLSsFdiKc5INNRiLipOBABv
	wf3UpwIAAA==
X-CMS-MailID: 20240124061714epcas5p36e87ac4a06e9187bf8d818b04bd1c4cf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240124061714epcas5p36e87ac4a06e9187bf8d818b04bd1c4cf
References: <CGME20240124061714epcas5p36e87ac4a06e9187bf8d818b04bd1c4cf@epcas5p3.samsung.com>

This series adds an alias log_window_value to option log_max_value which
now report average, max or both the values. The log_window_value option
type has been changed from boolean to string but retains backward
compatibility by allowing =0 and =1 values to specify avg and max values
respectively.
There is no change to existing log formats while reporting only average
or max values.

The fio documentation has been updated specifying the new log format
when both values are reported.

Changes since v1:
 - Use posval for strings instead of magic numbers as suggested by
   Jens.
 - Change option name to log_window_value and add alias to log_max_value
   as suggested by Vincent.

Ankit Kumar (2):
  stat: log out both average and max over the window
  docs: update fio man page for log_window_value

 HOWTO.rst | 45 +++++++++++++++++++++++++--------
 client.c  |  6 +++--
 fio.1     | 52 +++++++++++++++++++++++++++++---------
 iolog.c   | 74 ++++++++++++++++++++++++++++++++++++++++---------------
 iolog.h   | 21 +++++++++++++---
 options.c | 34 +++++++++++++++++++++----
 server.c  |  6 +++--
 stat.c    | 32 ++++++++++++++----------
 8 files changed, 203 insertions(+), 67 deletions(-)

-- 
2.25.1

