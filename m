Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370644BB5BD
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 16:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789056808; cv=none; b=rAw8Q3phNrArx5jvd+C9ccmOOS0dr+cjRkWHYEIxpEaUzJY1ujF1LUIZlX0NCwn6bdt+bwzkS+ohYC/kGe1Ce7ZTXomPzO0h+g6xRCYfY4IPAEklPCvDOMnL7KVd1a480P3NbQd1VBO0y7C2f3jWYswXc3B3z8XmHo582xqFRQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789056808; c=relaxed/simple;
	bh=hewgNnZVsD5LRKpANQQVGwrQlWwDU5aNFEFpGf3trPc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TDD/oEKuKMndP9QdqUbBkDUjSSNywLRzqAXjdrGXicp84KTLdoEp7MOjtgIA1oMIMWki0hc1H52t1L7xV9Zz1531nw2lh7XsIiaVxtmo/d6/3QfQ7mEz60N9gMxH++GuYkapSiiRATXezZZkxD3HF9Pl3uFA52tk5nltuddh57M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=EHi0wl0W; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="EHi0wl0W"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AF60GS3425245
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 09:13:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=kPndOZkvBygIU5L22W5+QJ487BVL5ggRM+J36
	SytnM0=; b=EHi0wl0WxbGxnqgX+qxqtohaDRgSIT16aQVsY9eEV4r5ib3MYjuAe
	vOgpMl2Qe/xq/iykRTQP2KIH1eVKevLIuhQKFLJOH002U/913zIQz+i1ogPVwxM1
	UfACENausbAAewEUq2QYrWKGtbuUe7cRlAzHanOofapY4k4L4z8sfK4y9GboHsQQ
	nYnWAnAEm4sS5Yf2VhWUUynS/qqgfxykDY4+9ZMVyOe7Lg2YUrj1B5FORP0EHyLq
	MGZJ0T/vW4KI057CFTmhKxZxncQvRRGlV5BbdioZz16C7Y1yLIQUSGuVJuydWv+3
	EUdaCBS04toCaM/vsjrBG+ldz9Po5ADww==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gkcycfe2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 09:13:26 -0700 (PDT)
Received: from twshared22253.02.snb2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Thu, 10 Sep 2026 16:13:25 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 6416C2BB6CA00; Thu, 10 Sep 2026 09:13:11 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <fio@vger.kernel.org>
CC: <axboe@kernel.dk>, <vincentfu@gmail.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 2/4] backend: don't mark a job as running before it has set up
Date: Thu, 10 Sep 2026 09:13:08 -0700
Message-ID: <20260910161310.1478081-3-kbusch@meta.com>
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
X-Authority-Analysis: v=2.4 cv=KZlHIgYD c=1 sm=1 tr=0 ts=6aa2d726 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=lXOJE_9kCttGot3g:21 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=crHB47gyY4rKiduisYu9:22 a=VwQbUJbxAAAA:8
 a=XcTtRpExG9rSsvE4vFUA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE5NyBTYWx0ZWRfX/7MUhEOTHYZM
 NJjHp0zyVgzxh33OY5OzWSalfccoNXMyQxRUdkAlDLS30VHIxvM7ceOo2HWREYMEOyr3AUbTqmp
 vAe2RjuhMsUl4XHNuSsFLkoFU9/3twE=
X-Proofpoint-ORIG-GUID: wRC7ERT1bjPJikrwU67A7aTKXYukMRsM
X-Proofpoint-GUID: wRC7ERT1bjPJikrwU67A7aTKXYukMRsM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE5NyBTYWx0ZWRfX8ENPI6eQEQop
 A6SRmUG78Ub6XuK8kkgJtvj9huDT9dL2kKoyGzytpumWu8mz/caC02CXEzA57Gy+zjJrkEQC5zM
 t/axYk01zbFjxBSQ0nnL7lwyKZqHt7gxC2JHOweuCJUvJd7kiHTNrQ0VgY2HkDjB7Ygt9hxSC/O
 jqjGYzkKIjqNUmWY5pnjCvW8Zv4GyEUKketdFSVn8IIC2qnXktZlr77gU93NbN6za7MDzVNv69+
 1WOXt7C6mbRIS7ZcGbMBPAgSRfPDICYE4z7YvkWs1QxRUIXiLE3T6Lg48faP5gx6Vd9XuKz3Fwi
 ARbdzqszSlI6E/Q7yog+XQveum0R7Bam6hQTndfNeN5v3edEL6yPVTQUoYpA1NtaQttrjFzeF8j
 WmYrJv63hMlaFWHGWjZoZ4HlDIWyIf4LQYBtlQO13FbguUTS6rMd5hH5CfVogRgXEtUjQCSruMX
 BxOpX1Ckq8Jyje2EbHg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

run_threads() moves a job from TD_INITIALIZED straight to TD_RUNNING and
only then releases it. The job still has all of its setup left to do:
exec_prerun, pre_read_files(), setup_files(), init_io_u(),
rate_submit_init() and finally set_epoch_time(). The job claims to be
running for that entire window when it has not issued any IO and has no
epoch to measure itself against.

Anything that reads the state during that window gets a wrong answer.
thread_eta() is the most readily observable  one: it derives elapsed
from td->epoch, which is still zeroed, so a job with a three second
exec_prerun reports

  Jobs: 1 (f=3D0): [R(1)][-.-%][eta 00m:00s]
  Jobs: 1 (f=3D0): [R(1)][50.0%][eta 00m:03s]

before doing any work at all. Running, half done and no time left, none
of which is true.

Promote to TD_SETTING_UP instead, which is what that state is for, and
let the job promote itself to TD_RAMP or TD_RUNNING once setup is over
and it has recorded its epoch. The same job now reports

  Jobs: 1 (f=3D1): [I(1)][0.0%][eta 00m:03s]

Widen the TERMINATE_STONEWALL check to match. It tests for runstate >=3D
TD_RUNNING to find jobs worth terminating, and a job in the setup window
used to satisfy that. Without this, exit_what=3Dstonewall stops reaching =
a
job that is still setting up, and a test where the short job is reaped
while a longer one sits in exec_prerun goes from 5.5s to 20.5s. Note
TD_RAMP sorts below TD_SETTING_UP, so ramping jobs remain excluded from
that check exactly as before.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 backend.c | 21 ++++++++++++++++-----
 libfio.c  |  3 ++-
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/backend.c b/backend.c
index 7f41bdfa..46bff828 100644
--- a/backend.c
+++ b/backend.c
@@ -2178,6 +2178,17 @@ static void *thread_main(void *data)
 		goto err;
=20
 	set_epoch_time(td, o->log_alternate_epoch_clock_id, o->job_start_clock_=
id);
+
+	/*
+	 * Setup is done and the job now has an epoch to measure itself
+	 * against, so it is finally safe to call it running. Everything
+	 * above this point ran as TD_SETTING_UP.
+	 */
+	if (in_ramp_period(td))
+		td_set_runstate(td, TD_RAMP);
+	else
+		td_set_runstate(td, TD_RUNNING);
+
 	fio_getrusage(&td->ru_start);
 	memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));
 	memcpy(&td->iops_sample_time, &td->epoch, sizeof(td->epoch));
@@ -2888,16 +2899,16 @@ reap:
 		}
=20
 		/*
-		 * start created threads (TD_INITIALIZED -> TD_RUNNING).
+		 * start created threads (TD_INITIALIZED -> TD_SETTING_UP).
+		 * The job has plenty of setup left to do before it issues any
+		 * IO, so it promotes itself to TD_RAMP or TD_RUNNING once that
+		 * is done and it has recorded its epoch.
 		 */
 		for_each_td(td) {
 			if (td->runstate !=3D TD_INITIALIZED)
 				continue;
=20
-			if (in_ramp_period(td))
-				td_set_runstate(td, TD_RAMP);
-			else
-				td_set_runstate(td, TD_RUNNING);
+			td_set_runstate(td, TD_SETTING_UP);
 			nr_running++;
 			nr_started--;
 			m_rate +=3D ddir_rw_sum(td->o.ratemin);
diff --git a/libfio.c b/libfio.c
index a57ede4f..322906c0 100644
--- a/libfio.c
+++ b/libfio.c
@@ -270,7 +270,8 @@ void fio_terminate_threads(unsigned int group_id, uns=
igned int terminate)
 	for_each_td(td) {
 		if ((terminate =3D=3D TERMINATE_GROUP && group_id =3D=3D TERMINATE_ALL=
) ||
 		    (terminate =3D=3D TERMINATE_GROUP && group_id =3D=3D td->groupid) =
||
-		    (terminate =3D=3D TERMINATE_STONEWALL && td->runstate >=3D TD_RUNN=
ING) ||
+		    (terminate =3D=3D TERMINATE_STONEWALL &&
+		     td->runstate >=3D TD_SETTING_UP) ||
 		    (terminate =3D=3D TERMINATE_ALL)) {
 			dprint(FD_PROCESS, "setting terminate on %s/%d\n",
 						td->o.name, (int) td->pid);
--=20
2.53.0-Meta

