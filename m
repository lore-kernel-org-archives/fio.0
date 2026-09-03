Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6774CA773
	for <fio@vger.kernel.org>; Thu,  3 Sep 2026 17:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788456074; cv=none; b=GLnq1nqLwf39BgOjyiXFztMPeNVdENaCZbNQd+JGLqxIQ+CZvLoaBOHmJHcek/BAQhgUYQzHR0xJgLfyCJBJeVoP01pgTpdgB6YlKHVGunnJ0CUuDNTi2V0sK3Ngvid6C74+DVlqcbHZvGa7JMZrT/J/ClU1/renB+SEJ0mXeOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788456074; c=relaxed/simple;
	bh=MXaVnghNm5X1rFxGkbOLHfe+XW4yTEQUU5ZEhImg3Jk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cvbI6/3/AVErLjoJjtEsd3fQFNmyJ5BjOAILLICc/F/mSnMIKq5WTh0U6CzUpDngXiOupi4g0jePnMBkCuAz6le2fThxem3ZVMpRCpdEZMUJDqA12si/NqeVtGQjEvpzFwmWvHS/Jn498NCFc0qZ33FgAT/3kTxIcaR2tfyzy8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=KFmcMYvq; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="KFmcMYvq"
Received: from pps.filterd (m0528006.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683G3IvJ197574
	for <fio@vger.kernel.org>; Thu, 3 Sep 2026 10:21:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=O1s298zPicbU7wzLkR//gKt5Jr5uph2euvcCf
	GQm9cA=; b=KFmcMYvq5zs2ea/yIchWiU4yMC5sAkGavmATQ3VDFaUIs0/4NuhHP
	NZGqSbGhFrT4rZ0NQSusi3an8qz4lYTEo8LBPEJp87hnqRPOiWkc9ZfRrOvTrf4n
	/Fxgrl8VlgO8Oo4udJ809f7W5Hs7qp3mc+MSd46WgnyF19Iaw5Vps/J4qaX8Rj6y
	TRnzSWOrms02BDNc5T+lN7AZZwnsXHP5bNbBW2bCZvg7VWMZPwpIz2TeA256rsax
	qIYEP4MwqbXj0YvYTKb8aswjgj9X6gSSfD/jmCNi1z/sQuZE45fhawjrvqnNIJrj
	c8hZ83TfD3lnb6UkYUol4WgtTrNE2EVkA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gf47v3dud-11
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Thu, 03 Sep 2026 10:21:11 -0700 (PDT)
Received: from twshared15102.02.snb2.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Thu, 3 Sep 2026 17:21:08 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id C178229E8B142; Thu,  3 Sep 2026 10:21:02 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <fio@vger.kernel.org>
CC: <axboe@kernel.dk>, <vincentfu@gmail.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 2/3] eta: cap the ETA at the job's own remaining runtime
Date: Thu, 3 Sep 2026 10:21:00 -0700
Message-ID: <20260903172101.1886315-3-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260903172101.1886315-1-kbusch@meta.com>
References: <20260903172101.1886315-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE1MiBTYWx0ZWRfX8OWYBOVKSa8d
 6JUx7tqKaG0K3FEyvGPYphpJMJlKRWaq6oZypboG8IDIkhA4H0aEG+lMZkqZ3EpsyJZJw18Sngf
 xHatPDnci94VYPS8bsazXaxTA+HM9LjVosUzeuYXO98AS/79lDyXHSnMRs5FgTLPHZS0k6gidc6
 N9cYwivZi0aITrSeDBOQ+4et3nAVU6AClHdrl7UrRezFPZ2C5jvdt0Ahdycb/pt4SeN1aNvAvsR
 i2deBrEmBcmIAKzxiGDOecjIfUO5JvBRF3mvU6wXkasyoxzQ4/tmFIsKyxHmTqjMe31CApZD3Lh
 chhlB/+U0ab2uqFznUztKXeg+wKo99uwMCOp/4sXJCKwcCF8y9iHgspNnF6VLi029bSDwpe9kK/
 Ooyuqk1TfNcQQPS0g5cgoxhuLGx+RMJP1e5Csop+tmhoS+AoMxIuAMUeemwHkx4naog4wyQEkkK
 DP/3bk2ADGU9tSAEcow==
X-Proofpoint-GUID: mXnCD2z_zv9OnDa0CKrVWbi6jfyZxHE0
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE1MiBTYWx0ZWRfX42GYQOLVuHWV
 74z8ahfLKkAUfHGZvxCXqhtwtGxAbTdeY9BzbP+GZ1q9530GONNB78NLUFKrf//n5uwVn9wyw96
 LKvCf/jEXnrgAO49xddrPknDCb8UScs=
X-Authority-Analysis: v=2.4 cv=RI2D2Yi+ c=1 sm=1 tr=0 ts=6a99ac87 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=kkcUborcUVj0H7zxAXTl:22 a=VwQbUJbxAAAA:8 a=ud-SU7DF2gFTjWnKbvIA:9
X-Proofpoint-ORIG-GUID: mXnCD2z_zv9OnDa0CKrVWbi6jfyZxHE0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

The ETA of a running job is capped at "timeout + done_secs - elapsed".
done_secs is a global accumulator of the runtime of every job reaped so
far, so the cap grows every time a job finishes. Whenever the cap is
what actually gets reported, the ETA jumps back up by the runtime of
everything that has already completed.

The cap is what gets reported when the progress based estimate exceeds
the remaining runtime, that is when perc is below elapsed/timeout. Any
job that is behind on bytes relative to its runtime is in that state,
so this covers the common "size the job to the whole device, bound it
with runtime" pattern. A job that would complete its size early stays
at or above elapsed/timeout and never reaches the cap.

time_based makes no difference either way. It only lowers perc to
min(perc, elapsed/timeout), so a time_based job that cannot finish its
size within the runtime is affected exactly like a size based one.

The problem is most visible with stonewalled jobs, where the ETA climbs
back to the full run time at every batch boundary instead of counting
down. Start stonewalled io_uring jobs, size=3D10T runtime=3D5 time_based,
report:

  22 21 20  24 23 22 21 20  24 23 22 21 20  24 23 22 21 20  24 ...

instead of counting down to 0.

It is not specific to stonewall. Two concurrent jobs with runtime=3D5 and
runtime=3D20 show the same jump when the short one is reaped at t=3D5:

  19 18 17 16 15  19 18 17 16 15 14 ...

done_secs made sense when it was introduced: thread_eta() was handed
the global elapsed time back then, so "timeout + done_secs" was this
job's projected finish time relative to the start of the whole run.
b29ee5b3 switched elapsed to be per job, measured from td->epoch, but
left the done_secs term behind.

A job is terminated once utime_since(&td->epoch, now) reaches
td->o.timeout, so with a per job elapsed the cap is simply
"timeout - elapsed". Use that, and clamp at zero instead of relying on
the unsigned subtraction wrapping.

Fixes: b29ee5b3dee4 ("Update ramp_time")
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 eta.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/eta.c b/eta.c
index 5dbf4d75..29e1bf41 100644
--- a/eta.c
+++ b/eta.c
@@ -263,9 +263,18 @@ static unsigned long thread_eta(struct thread_data *=
td)
 			eta_sec =3D (unsigned long) (elapsed * (1.0 / perc)) - elapsed;
 		}
=20
-		if (td->o.timeout &&
-		    eta_sec > (timeout + done_secs - elapsed))
-			eta_sec =3D timeout + done_secs - elapsed;
+		/*
+		 * A job never runs for longer than its own timeout, which is
+		 * measured from its own epoch. Cap the estimate at whatever
+		 * time this job has left.
+		 */
+		if (td->o.timeout) {
+			unsigned long timeout_left;
+
+			timeout_left =3D timeout > elapsed ? timeout - elapsed : 0;
+			if (eta_sec > timeout_left)
+				eta_sec =3D timeout_left;
+		}
 	} else if (runstate =3D=3D TD_NOT_CREATED || runstate =3D=3D TD_CREATED
 			|| runstate =3D=3D TD_INITIALIZED
 			|| runstate =3D=3D TD_SETTING_UP
--=20
2.52.0

