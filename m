Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18004383320
	for <fio@vger.kernel.org>; Thu,  3 Sep 2026 17:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788456073; cv=none; b=hHBMSvjHY8P9IsKaTjgyqHOKkrEYCAOjcHjO+xx99qSl3o6GvPOYGFfSllivyL0fsmMj/MGjgsgwH3QBrt68f/qbVgpVQjq9FibM4jrCffskpJCByD9ku0W6GC7+tqsBvYg5wfzWVZQwk0rW2XGxOC7JEahgO+qQHrCpmTEfOH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788456073; c=relaxed/simple;
	bh=5nPlbuHsc6YDR5weR0k5nJpZs5pEGL8997w4TaLy86A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PKMy1k63b5MqFMiDw3WyZCwFPCfD3THuqXd21KhyElVqSCc2jQ5Wh/SrE2BlACHspeDwvuYki5SsNrARQClewZNIFAk3XVvDJBprY7rdR5uUzf7IroMWbzZSQz4pdTy9GwZj4rdVYQ3KWbx3HiHR2UnHgh1MT8vKk22o1oZVkB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ewoEydqJ; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ewoEydqJ"
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683G53pg708743
	for <fio@vger.kernel.org>; Thu, 3 Sep 2026 10:21:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=15dt7QR/Or3YpPcMV21gvahBkGzrBcBcJxTh0
	rP3GU4=; b=ewoEydqJ87k1Oj7dXSkuIPi5DhFiVYOvfhhaUITGbfr/MJGxZl1eo
	7uoT6fEZoQoeZVOt9lpbrLcK4Yt9Ewyupwcg1IlCiSPpN8zIBPnyw1XDbwBtTK1F
	d8FfFwn1Fn64iHlGvt2ic0090qs32D723lff5ZlgRcQkiA5O8BnSQyrQXfVWsaQX
	5A1vA5tgYI1qlntF+kHjgARobkNCgTiV2yC3mddu2yYiR3yInLucMkuEb8peA6mS
	rNW2pW/M2yqJdoBOWm83f0mI3uc+xA1bDXH35v1ObvtRXP4UYz6nWkJNQz0bIAFT
	EkJ4fkxKg+ss2Wx9fZedwbFQC6iOukG2g==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4ge3gufspf-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Thu, 03 Sep 2026 10:21:10 -0700 (PDT)
Received: from twshared15405.03.snb2.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Thu, 3 Sep 2026 17:21:08 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 7C7A229E8B140; Thu,  3 Sep 2026 10:21:02 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <fio@vger.kernel.org>
CC: <axboe@kernel.dk>, <vincentfu@gmail.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 1/3] eta: don't estimate runtime from an unset job epoch
Date: Thu, 3 Sep 2026 10:20:59 -0700
Message-ID: <20260903172101.1886315-2-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE1MiBTYWx0ZWRfX4BPdwHFi0R0z
 z7F3VNa+BbUmf7bBZ/PxCP3a8GNdksDDBWHwqpfpCCmRnqax3aBdRQGxcD7g803bnDmhjXKrS3a
 pdbI/+nR/0IAFpLKLYSjrvWXDX5LFCeDLTaO3cNKiJuf4mVFre7092beZ5HSstO5YW2Yy/KXuud
 nmFkmHVSLJBglSyz0Pk107HgS/vCntz1aiaMqHKjwvxEiF7z5HgJUBC6QX8/vEkN8qNO9WAmiGF
 LjlvQ1EOvvGjSgRey0J3B/g0+q1gtGV7v6hzIqvty0PTCUrWXnmFJ8m+MIsuUaD1KokuT7QMR6y
 vlwZr+RHYyesKnCFizY9ILE1wUMU9NQ/GSTyKL2C2PFWW8QhGa4udbCukQYiYIP/1qUYUNbum1g
 EeaCHc6dOG4z5TeQMTjBwWuxB5gXRyBxov6mgf0x14Aj1vR49/RTFoGsQITyZ2vRtZRfoIZwlBB
 QAE51S7XuiZyRGDb8xA==
X-Proofpoint-ORIG-GUID: S7cmr7QQWqKyNYhj7DTbsT-Ba0v18wCy
X-Authority-Analysis: v=2.4 cv=DLe/JSNb c=1 sm=1 tr=0 ts=6a99ac86 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=xtH7KyWI9dI7BmFOsl-x:22 a=VwQbUJbxAAAA:8 a=WL9Mey4J0-dQdQc1l1AA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE1MiBTYWx0ZWRfXwcPdl/Tv2uzB
 Mw8fIB9GvZKGwVgkloPZmNAUTYDdZcyvE4xwTQqjURxeYHhj7Lu7GvZCrIHOw0BSVvuDYjk8cfU
 se0rLhj4ZK7LQ0whG9t/ttoxvepPIEY=
X-Proofpoint-GUID: S7cmr7QQWqKyNYhj7DTbsT-Ba0v18wCy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

run_threads() moves a job from TD_INITIALIZED to TD_RUNNING and only
then releases it. The job itself doesn't call set_epoch_time() until
well into thread_main(), after exec_prerun, pre_read_files(),
fio_verify_init() and rate_submit_init() have run. Until that point
td->epoch is still zeroed, so the "elapsed" that thread_eta() derives
from it is the time since the unix epoch rather than the time this job
has been running.

Nothing currently notices, because the one consumer of elapsed that
could care wraps around on the unsigned subtraction, but it is a trap
for anyone using elapsed as a real number of seconds.

Take a local copy of the runstate and demote a TD_RUNNING or
TD_VERIFYING job whose epoch is not set yet to TD_CREATED, so it gets
estimated as a job that is still starting up.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 eta.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/eta.c b/eta.c
index c6e3cffb..5dbf4d75 100644
--- a/eta.c
+++ b/eta.c
@@ -162,6 +162,16 @@ static unsigned long thread_eta(struct thread_data *=
td)
 	unsigned long eta_sec =3D 0;
 	unsigned long elapsed;
 	uint64_t timeout;
+	int runstate =3D td->runstate;
+
+	/*
+	 * run_threads() moves a job to TD_RUNNING before the job itself has
+	 * recorded its epoch, so elapsed is meaningless until then. Estimate
+	 * such a job as if it were still starting up.
+	 */
+	if (!td->epoch.tv_sec && !td->epoch.tv_nsec &&
+	    (runstate =3D=3D TD_RUNNING || runstate =3D=3D TD_VERIFYING))
+		runstate =3D TD_CREATED;
=20
 	elapsed =3D (mtime_since_now(&td->epoch) + 999) / 1000;
 	timeout =3D td->o.timeout / 1000000UL;
@@ -220,7 +230,7 @@ static unsigned long thread_eta(struct thread_data *t=
d)
 		}
 	}
=20
-	if (td->runstate =3D=3D TD_RUNNING || td->runstate =3D=3D TD_VERIFYING)=
 {
+	if (runstate =3D=3D TD_RUNNING || runstate =3D=3D TD_VERIFYING) {
 		double perc, perc_t;
=20
 		bytes_done =3D ddir_rw_sum(td->io_bytes);
@@ -256,11 +266,11 @@ static unsigned long thread_eta(struct thread_data =
*td)
 		if (td->o.timeout &&
 		    eta_sec > (timeout + done_secs - elapsed))
 			eta_sec =3D timeout + done_secs - elapsed;
-	} else if (td->runstate =3D=3D TD_NOT_CREATED || td->runstate =3D=3D TD=
_CREATED
-			|| td->runstate =3D=3D TD_INITIALIZED
-			|| td->runstate =3D=3D TD_SETTING_UP
-			|| td->runstate =3D=3D TD_RAMP
-			|| td->runstate =3D=3D TD_PRE_READING) {
+	} else if (runstate =3D=3D TD_NOT_CREATED || runstate =3D=3D TD_CREATED
+			|| runstate =3D=3D TD_INITIALIZED
+			|| runstate =3D=3D TD_SETTING_UP
+			|| runstate =3D=3D TD_RAMP
+			|| runstate =3D=3D TD_PRE_READING) {
 		int64_t t_eta =3D 0, r_eta =3D 0;
 		unsigned long long rate_bytes;
=20
@@ -278,7 +288,7 @@ static unsigned long thread_eta(struct thread_data *t=
d)
 				t_eta +=3D ramp_time;
 			t_eta /=3D 1000000ULL;
=20
-			if ((td->runstate =3D=3D TD_RAMP) && in_ramp_period(td)) {
+			if ((runstate =3D=3D TD_RAMP) && in_ramp_period(td)) {
 				unsigned long ramp_left;
=20
 				ramp_left =3D mtime_since_now(&td->epoch);
--=20
2.52.0

