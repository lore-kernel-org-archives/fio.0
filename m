Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300E04BE42B
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 16:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789056806; cv=none; b=TST+sUaDZrdxMBoxaMd6JuS0I9+A92Jz6Dlr7j6Q0p7avEGp7Zuydc/VlYsXa1BqIOZ/xMpYxM44gO3Ay4J5cjIbuI8dTgjcCCaoptgRGSjN+UzWVYwtOsOxOMAxVfXbW79GL6ymA7fRsxQcHraLlTBdxDWGILlREOmRAlKHbLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789056806; c=relaxed/simple;
	bh=km3530lQ85xW7cmck1z0zKEDR3hdtfRl/L5B+lY2h34=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lt7EPjx5c00CbBvFijxeoU5Xm8PydsT1403IIuVWQ4UXdJuTINvrFZvhptNk4S/4zyCjAVpq3vXqTNZsoqPc85SGNJrK2e+QBGAOyaB/tBxVaVaOzvYUVadtPUSvz+JU6MjU8ij7pgLXZf3xBAhfzQzFV3w6c6gI1vmM1dq54Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=IJkdQxpi; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="IJkdQxpi"
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AF7rQZ3396900
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 09:13:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=BDr7G6w1RvWUUMMYNQs2PgupYsvT3/heDrDUu
	zm7roY=; b=IJkdQxpijmhxO6y82oYurOrHZRhQS12KSD1qMhFSzNkL87poZdVn/
	Sm4e39jOwfZ1N5eCoEoM83+OO8px86XppJrmvIMAikyeoWXNQHP9DQWUn+3Veiem
	ERduCtzJmAwYOsXaL4DjIk22bDP0SWUd9+0TH9/Sap1yGO1sgkLicICcNas40X0D
	v/kpxvUMj0uGLEkSM0WZggwEvkWiAFBKtg8bh9HInNu799nvE+437JjnZOrtrvwT
	TBvATRUZvypmHMLgyATJMyEqaII+NfR7ELFc9ECluwAclYiDXRWCUqqXgEzrwuj3
	q8TNlq+A6uDIkj4Q9OVfnfa875l0jdhIA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gkcyffb95-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 09:13:24 -0700 (PDT)
Received: from twshared120513.16.frc2.facebook.com (2620:10d:c085:208::7cb7)
 by mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Thu, 10 Sep 2026 16:13:19 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 6B7F82BB6CA01; Thu, 10 Sep 2026 09:13:11 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <fio@vger.kernel.org>
CC: <axboe@kernel.dk>, <vincentfu@gmail.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 3/4] eta: cap the ETA at the job's own remaining runtime
Date: Thu, 10 Sep 2026 09:13:09 -0700
Message-ID: <20260910161310.1478081-4-kbusch@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910161310.1478081-1-kbusch@meta.com>
References: <20260910161310.1478081-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: XjgU8HTBod2L_sSZkPlf4Eyy69oma1L7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE5NyBTYWx0ZWRfX/pn+Ao/HHwwS
 Qb5vfgbjcJZ6KdQ/CuWYbSZ8Nv/yBcfQSBsJipWlkLfuTFcrdFuXMkOUvy5gcyVIg2jUZis7dXu
 IholCso9nxINrrHEmJorlU2dIycJO/pebcN7JB0cM1/11A2R2Z3mTG3jZwkL//m1Oh0YpEas35d
 sIdK5KGs8BD7tP6Jmb9IvgOnGouNuVvUs5lHvvU0SpJQ76/A/DDuoZB2A20Vd/AO/Rk/HmJBUwp
 b9RSceCPxznlMOIr4boDNx52aM8Czb6aUnB6DZl03yxfAjclcyYNdyKtFEtlvK/TOCjGE73YmQ+
 pjMU4v9vhIbb86WxYVEx5QW2V4cWr57U2Bl8ma8/NuXY6y74GsBC8kbHEkD0LfDpHJ5+KYXoLNH
 9NDCMcDv0eZ8/H56BrIhVmMT/ZNXdk4L10waSGP6iLJZrVlRPVLM6O5SYiuiy4gqTDy7RvPK5wr
 q2bmNsPLWdJpstv3kaQ==
X-Authority-Analysis: v=2.4 cv=NJRAaE6g c=1 sm=1 tr=0 ts=6aa2d724 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=U_y8lYiYyhHBU5rMqhb2:22 a=VwQbUJbxAAAA:8 a=ud-SU7DF2gFTjWnKbvIA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE5NyBTYWx0ZWRfX8Q2+FBFj50iY
 mrUhjRfYbuzCwgTjlqIpxx6TUDqQaiMWfKxB6ws87z66mMyNlRHEnZB0B0V0swd50RAXvUYBMH7
 j+QO5eaJ24MJHFn6VlBhTsetgNuAxOQ=
X-Proofpoint-GUID: XjgU8HTBod2L_sSZkPlf4Eyy69oma1L7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01

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

It is most visible with stonewalled jobs, where the ETA climbs back to
the full run time at every batch boundary instead of counting down:

  fio --name=3Dglobal --filename=3D/dev/zero --runtime=3D5 --size=3D10T \
      --stonewall --name=3Da --name=3Db --name=3Dc --name=3Dd --name=3De

  before: 22 21 20  24 23 22 21 20  24 23 22 21 20  24 ...
  after:  22 21 20 19 18 17 16 15 14 13 ... 02 01 00

Shrinking size until the jobs complete it within the runtime makes the
symptom disappear, which is a good way to confirm the cap is what is
being reported.

It is not specific to stonewall. Two concurrent jobs with runtime=3D5 and
runtime=3D20 show the same jump when the short one is reaped at t=3D5.

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
index 70efc208..d17b8c3f 100644
--- a/eta.c
+++ b/eta.c
@@ -253,9 +253,18 @@ static unsigned long thread_eta(struct thread_data *=
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
 	} else if (td->runstate =3D=3D TD_NOT_CREATED || td->runstate =3D=3D TD=
_CREATED
 			|| td->runstate =3D=3D TD_INITIALIZED
 			|| td->runstate =3D=3D TD_SETTING_UP
--=20
2.53.0-Meta

