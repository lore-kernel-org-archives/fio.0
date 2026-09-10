Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F864BB294
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 16:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789056804; cv=none; b=eT2Ppwkg1GR2jiMRDYQcOA805Urv1xVHph7SCwzl9/nDq2yc8sfEbn7GedhtJC2fmerMOMsAF88BQy1oU3orLm80uUR8s0N8NX3hzakuOa0d3mssX2lhxcqKdcconHQdAG5mGxaxGgghIJyHnuIQCO/tufhOI858wCadfFFt/WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789056804; c=relaxed/simple;
	bh=NxMAzBrJV5Yd9COoCdbmzdH/AfCHBUehHZyJA9u2TPQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vul/LVO3rWfZxPhUkMvkAy30cGgtfn+He+lUo1kikCwq0iRAh+tSzmNfDw4O1BkL7UyTzZtj76mnEVYk+p+05UqQK/qH+M4vmFkcWQttGrkxdaB6GuFf0RxmyTW5FnZoDw0IAqUeTQeOT0kGAkJqoctrzZYNhi4lDJytF03Ehew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=gynEjv/U; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="gynEjv/U"
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AF7rQW3396900
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 09:13:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=yi4Obay0B7N/XUIWgWI44EAb+m/dWGAdFmJQc
	XRuN38=; b=gynEjv/URY0LCIUFBsq8UbGX4+i/+D3rmmz7v6BzcRjtA7MU9y2gi
	vr/dSO6DJzwwDFqpl8YmO+6Ld/Cd7IqhpTSxyOoJPcsEbZRbPm7BhcNg0ABw3dn0
	HonRURIESeSJXL6XYCBORw6OgdQh8OIM330tpGr87M6qjm6twL6fJA2GYG9ym9Qk
	t/Mj8RTPCYPR9VyX+wrO3079bp98KhST8QiEe9euXPX/Qg2WmzjnYRB1NOgstpi3
	IUrlfuC/MvejizovZSdEW3t9WBzOvi59qwxNWcHh7PboskCuQkvh3uk5G5WDR4My
	rtiFMP0T5iHhaTfZRIHEhM5Ff+cZs5J0Q==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gkcyffb95-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 09:13:22 -0700 (PDT)
Received: from twshared120513.16.frc2.facebook.com (2620:10d:c085:208::7cb7)
 by mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Thu, 10 Sep 2026 16:13:19 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 5DDA72BB6C9FF; Thu, 10 Sep 2026 09:13:11 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <fio@vger.kernel.org>
CC: <axboe@kernel.dk>, <vincentfu@gmail.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 1/4] eta: count a job that is setting up as running
Date: Thu, 10 Sep 2026 09:13:07 -0700
Message-ID: <20260910161310.1478081-2-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: SAgIkb-M3FsUVJq6BGSsWjZJWNhFRd4N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE5NyBTYWx0ZWRfX71rbR7rP3cG/
 zVqE+sYG0uMwTURMCBNXLmN4TbJ2W+Easy00clOvpRsoYnBAzE9zUy7PV8X70ss46tttTye2XD/
 hpXiAbxr6CNLAlyJ1J+TaO0+IyTAPJe6tSud4yN1fa4xMcL9Aw5modeou16F7KPLjRradHRncdL
 XgyhCOCkfM9TOJ1tLhCvjXK031W1YKWPItDWxqUzM24AkdVFzKFp9K3EiD9y1IJKbHnAkH3JKqv
 Yb1+PoNlbcqDX7XpF9EhQgIZyp48BmYGpF1zqP7FhN5et2AGlPByZdXqvscyrJ1JEoCEr3eQpz4
 JggfvxaztR1U7qPAuNEkg4Q+LpI+T7CR+0i/3EjsWCrnjcP4nlS1EXm+d75Ht+qo37fk3hQEL+r
 ZMrrdLjFRXhrlJg0CU64FQYY+iH4Z7scMc8W5MzLnLTPSzB7u9eSaqoBSXRq/GB44yVQiBhKAmb
 23kGwEQ1R++4xOvjGSg==
X-Authority-Analysis: v=2.4 cv=NJRAaE6g c=1 sm=1 tr=0 ts=6aa2d722 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=EeWiu3Qwqy3-GwE9:21 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=U_y8lYiYyhHBU5rMqhb2:22 a=VwQbUJbxAAAA:8
 a=xjsNQY_6JWPa7d-pPsIA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE5NyBTYWx0ZWRfXwxnHzV2AlpwE
 Pc8cvvdiVEEwlrca0ssBaHrnNbxtzAMPD4sR+vjCvO8ucT4bMtgxT4W854/8Pl817+9rz0idVS0
 vfUDIs7XC0CRYIzePe+O50mXIG6QLgc=
X-Proofpoint-GUID: SAgIkb-M3FsUVJq6BGSsWjZJWNhFRd4N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

TD_RAMP increments both nr_running and nr_ramp, so nr_ramp is a subset
of nr_running and display_thread_status() can compare the two. The
TD_SETTING_UP side would increment only nr_setting_up, yet the
percentage calculation scales by nr_setting_up / nr_running, a ratio
that only means anything if setting up jobs are counted in nr_running as
well: the existing ratio can drive the multiplier negative.

A job that is setting up is started and doing work, it just has not
issued IO yet, so count it in nr_running and treat nr_setting_up as the
subset as intended. Today this only covers the brief windows where
setup_files() and pre_read_file() bump the state, but it means the
status line reports such a job instead of suppressing the whole line.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 eta.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/eta.c b/eta.c
index c6e3cffb..70efc208 100644
--- a/eta.c
+++ b/eta.c
@@ -466,9 +466,10 @@ static bool calc_thread_status(struct jobs_eta *je, =
int force)
 		} else if (td->runstate =3D=3D TD_RAMP) {
 			je->nr_running++;
 			je->nr_ramp++;
-		} else if (td->runstate =3D=3D TD_SETTING_UP)
+		} else if (td->runstate =3D=3D TD_SETTING_UP) {
+			je->nr_running++;
 			je->nr_setting_up++;
-		else if (td->runstate < TD_RUNNING)
+		} else if (td->runstate < TD_RUNNING)
 			je->nr_pending++;
=20
 		if (je->elapsed_sec >=3D 3)
--=20
2.53.0-Meta

