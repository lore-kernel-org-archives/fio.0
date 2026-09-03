Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C134CA773
	for <fio@vger.kernel.org>; Thu,  3 Sep 2026 17:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788456078; cv=none; b=BZU7j2pE6cc0+ExbbxcVd+bYYa84b7BcWtl0OS04QDFNfrp1YQD3hfuRw5L+lkECTIdYKlElCV3We9lc+Vq7++WgmCDUvG/cuo36uR7779tyo/brRRDqNdTd9CFaszcxCpb0lvxZZq7Y/BJCVTSeiMv7EP8c7AJWS8umt7JMmBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788456078; c=relaxed/simple;
	bh=HcIPYvat6VO/Qvyy4NDFHhBVatNsK34WU4/D/SQIZDU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OF/n+q2jFFpd5XLBQXVoYJJa23J7QQTzh28py4lQKT5ZCXVNDrTJgd/52v9Txu23ldq1t9v9AP6Pb2YBnWE8vKQoh0rZwP1ClKHHXehB9DQL3dQ0WP5uJYMcG9AhURktAc0y8ES4HPlgs8WVUnnxY7+9i2IxLmG8rH+i+LKH+n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=VUJS6odO; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="VUJS6odO"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683G4GUs630904
	for <fio@vger.kernel.org>; Thu, 3 Sep 2026 10:21:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=zTsk0rcoq
	DDACLQy6pqxROpU7Ds9ek4jfpwTj7mQqhg=; b=VUJS6odOXbvY45LhRPo9VJJVQ
	CX1YhSWp721I3tJoRvG11+YnTLABVOblP9Hz2L9yjQXc4f3xH4q76WEQqHjDEF70
	7QHBVbXpQ16tIiOEde8L7DfnmAQ2dlLB/BJS7CzKeJM9wt17FPAr+NH5QRoXC9JP
	/+LET5PchvSVCP7eIq2BiqfZ8F0TfIfCJgZKhVoHzvsxgN9xxcrSjW4DvZOLQoJL
	z1fr43O9GDUic4aO0KsNegY1GV7dUDtjExYwdz2BaoKjZ6s5CQg26zOE+GoGvlxV
	zrxzwaM6XpNTmdZPPiOXXwGwE/lzKrixusO3SFP8C88lyrzgigwAVL5wPwVMA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gf47vkdu4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Thu, 03 Sep 2026 10:21:15 -0700 (PDT)
Received: from twshared23629.02.snb1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Thu, 3 Sep 2026 17:21:14 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 7A46229E8B13E; Thu,  3 Sep 2026 10:21:02 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <fio@vger.kernel.org>
CC: <axboe@kernel.dk>, <vincentfu@gmail.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 0/3] fio: fix eta
Date: Thu, 3 Sep 2026 10:20:58 -0700
Message-ID: <20260903172101.1886315-1-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=Oth/DS/t c=1 sm=1 tr=0 ts=6a99ac8b cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=crHB47gyY4rKiduisYu9:22 a=VwQbUJbxAAAA:8 a=8S_wsfY6Os2SRs4tNZ4A:9
X-Proofpoint-GUID: zR7v-Rt0B-qzWi-mY74v9xlJ8X_wQano
X-Proofpoint-ORIG-GUID: zR7v-Rt0B-qzWi-mY74v9xlJ8X_wQano
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE1MiBTYWx0ZWRfX6cwYq98opjaR
 03qrqHa2v2f6e6OJCu7WYqNHzWWfNSo1icl8YL/oeZRThiKFzzvmVvFsZNnDwn8YfaJCIWSM7hv
 n0Iyedxam4KUNxX0u581AghrEYXu61k=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE1MiBTYWx0ZWRfX0CHawlhPySPO
 ikuANrFI2QrevXyiVtQhAdROuhG0MJuoPsPc0G2nkCbZ363IHPqoC60HyMalzhj8oCCxsu4wvj3
 YK2FWH/aZgitmOHN0llqz4Fjf/u5zeEe2nFQEmUOm7U+nKTh35+7Y6WgxfYCEYhALDkF/NgfdYn
 hbec6mBD+Yp+P721sgttR9r5XA/21DyCSZXaw7r6jTzEbRGvrSJqOy4M5mIgjrF00E0TTDP18p5
 ldRzzW5v/wkoUy+ESOcKEHzi/nRsJ8JcII4H1ISBH84FQ1gKhRHV9c/0EP07P+1L31OeGww1EQB
 F2oICaLXTlBTGHYqwh46fKXDd6Fgqde6tCb4wYFMabrPhkIT2IC/YQXBcCL0nP8taABVdvord2k
 2DJfssGrqaxWE0PDvE/yeRSblrDrgyRhvMdeE3itp+sFgv37ZfMp0PdD+LQAkFiLmMG236zc1Si
 igLdCHRH21q7gz2m0JA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

When jobs are overlapping or serialized by the stonewall, the eta
calculation messes up by restarting back to the original calculated
time. Here's a simple example of running multiple 5 second jobs with the
stonewall to serialize them:

  $ fio --eta-newline=3D1 --name=3Dglobal --ioengine=3Dio_uring --rw=3Dra=
ndread \
      --filename=3D/dev/zero --time_based --runtime=3D5 --size=3D10T --st=
onewall \
      --name=3Da --name=3Db --name=3Dc --name=3Dd --name=3De
  ...
  Jobs: 1 (f=3D1): [r(1),P(4)][15.4%][r=3D837MiB/s][r=3D214k IOPS][eta 00=
m:22s]
  Jobs: 1 (f=3D1): [r(1),P(4)][19.2%][r=3D737MiB/s][r=3D189k IOPS][eta 00=
m:21s]
  Jobs: 1 (f=3D1): [_(1),r(1),P(3)][25.0%][r=3D1569MiB/s][r=3D402k IOPS][=
eta 00m:24s]
  Jobs: 1 (f=3D1): [_(1),r(1),P(3)][31.2%][r=3D2045MiB/s][r=3D523k IOPS][=
eta 00m:22s]
  Jobs: 1 (f=3D1): [_(1),r(1),P(3)][37.5%][r=3D1722MiB/s][r=3D441k IOPS][=
eta 00m:20s]
  Jobs: 1 (f=3D1): [_(2),r(1),P(2)][35.1%][r=3D374MiB/s][r=3D95.6k IOPS][=
eta 00m:24s]
  Jobs: 1 (f=3D1): [_(2),r(1),P(2)][40.5%][r=3D2193MiB/s][r=3D561k IOPS][=
eta 00m:22s]

Literally unplayable! ;)

This series gets the eta reporting the correct value.

Keith Busch (3):
  eta: don't estimate runtime from an unset job epoch
  eta: cap the ETA at the job's own remaining runtime
  eta: remove now unused done_secs

 backend.c |  2 --
 eta.c     | 39 +++++++++++++++++++++++++++++----------
 fio.h     |  1 -
 libfio.c  |  1 -
 4 files changed, 29 insertions(+), 14 deletions(-)

--=20
2.52.0

