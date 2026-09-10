Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6444BB26C
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 16:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789056811; cv=none; b=JihBW06rlA7VZ7Kr/t0XFBd88OVR5n1zzim/aNPx0LMK/9qUBWLvJ5ODimE8QZ1v0B0TpuEah8NrexbGRLWLanaC9Lbcs/tMRDMMrxHu/SUEOGM2SuVZuYC4ZRAEaXI0A2XUuuO/tsW1DdrubV1WV6dKQuH2XZ0Y0Qql4gGibug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789056811; c=relaxed/simple;
	bh=cZ9kAkq0t7EJu5cJNyZyri+ctcidmk0KEURCuhG3k00=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P9yZfvv0RMSAFzhOpcmNJxvqRwelYxbJVQO77sazR/CyZxUvVBSOdd9Qq4Nxt+jGPBIBFAn3fkJZwZ+b3AhL/KDz9rXVVOSZEaYVq1edGO4sQjQ2Vg6T5NPT7qiQXgMfJq1R04pcWTVeODjlt+ybUvuhGoGviCpHtSaoekY2vYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=XlbpnTGJ; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="XlbpnTGJ"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AF6jwK2395824
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 09:13:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=NZHelw0dM
	7oedA2BOc+PV6YQzxDGH5GTZocqhCEFmUw=; b=XlbpnTGJzc6Tf94SCgXg1XKLZ
	PkJRB7nh4IP0cYu93+0L4t048sYGpWdWxHEklIazKf5XSTTwfFBxcGMrv6BY0SYB
	z0p5v/bFsUM6H0ocgXcJP3Ni/8VkECLqYVBaX/bgLLo86Ql+y7qGMZ7G0vCJFJOc
	RtqglKOde5OcQKj+suCnMTvYw2NljZmGDafOR8yMg7bAgM3qq3nCqIaacmG5umfZ
	YBsbCE3tRJjxs/PBdX9BkYGCZRQJrC+MVWUlQu5tdQUq7SBIoMv7X/6MTTLh6XtS
	bFbKkKVYl3a0/Xh2U4CElCTaiXVtgJdeeFc6JpMkrop9Pk1DjihyEFhnjLmKQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gkcyeqd44-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 09:13:29 -0700 (PDT)
Received: from twshared27352.01.snb1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Thu, 10 Sep 2026 16:13:27 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 5C3182BB6C9FD; Thu, 10 Sep 2026 09:13:11 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <fio@vger.kernel.org>
CC: <axboe@kernel.dk>, <vincentfu@gmail.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 0/4] fio: fix eta
Date: Thu, 10 Sep 2026 09:13:06 -0700
Message-ID: <20260910161310.1478081-1-kbusch@meta.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE5NyBTYWx0ZWRfX5ZrQjxne+yIK
 HaGbCWSzIUm3OdXLt4EqmyA0EQxbToPCDkeGtbjl6l/b69R55Kuy/s6ugddHYmWGbI8d/egp/Nu
 cwlu8f8Il5/MpueiIsLDPd0iZBEjTd2Pv44NROOzthwrPcurTrH5iS4b3A9lov/fbHzDnhOzxbp
 7S8PyIBjF2LXzZ/HQM97/u4T6cF+GRUIJFrbPmdedthYIYzEGfzQ8pNQnIdvuKZXMQ7/cb2Phmy
 WSaqy3oqusI9WBELIusb+3FkIptmyPdChwtoXFV68NztjCpSLEoZeICBv3aCr0ePRpKkPVCDT1W
 GQya/u/RC150GI0sPUnH+1xX7U/Blj/DCdE4P0WhjPV0R6eFYNt9AYuvXKcXKVYkuGzVNk1sfbp
 s3nPGnpxFtR7YA+fpjMbOrIFDMiIhnO+8UQqnM3onF8vHQKlOUsFTnM7t7BOn1lagFzIxYjLHbl
 gfGIHohxwN3dlGiGtOA==
X-Authority-Analysis: v=2.4 cv=C/t8WgP+ c=1 sm=1 tr=0 ts=6aa2d729 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=PAz_-FQ8hEVmOPYdF0yf:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=3ZPer1PrDAVJDb21DGMA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE5NyBTYWx0ZWRfX+A3m9Q9Tzzy1
 lmpzZ2b2rV+z25Ul0DNN8kZ2TVXbSMFQEohAQ7E7D1Y3BiJHe9Xc3RbD5AaINcgJ3iRdga+bbo2
 CZ+A9d+lkILJmsQGrVBW1ZVdzRx88xw=
X-Proofpoint-GUID: Dl0AFPZCP42GkmhaEaGRtTh7OIacqxvd
X-Proofpoint-ORIG-GUID: Dl0AFPZCP42GkmhaEaGRtTh7OIacqxvd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Changes:

Fix up the state machine rather than hack around it.

v1: https://lore.kernel.org/fio/20260903172101.1886315-1-kbusch@meta.com/

Keith Busch (4):
  eta: count a job that is setting up as running
  backend: don't mark a job as running before it has set up
  eta: cap the ETA at the job's own remaining runtime
  eta: remove now unused done_secs

 backend.c | 23 ++++++++++++++++-------
 eta.c     | 20 +++++++++++++++-----
 fio.h     |  1 -
 libfio.c  |  4 ++--
 4 files changed, 33 insertions(+), 15 deletions(-)

--=20
2.53.0-Meta

