Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F9B4F6477
	for <fio@vger.kernel.org>; Thu,  3 Sep 2026 17:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788456082; cv=none; b=Mokc/K+YZPMWi2zME9YSPZDENhTFjsc5kple18l4g4j+eJ4K9e83mIvC11V2UygfUHTnWRd1pg6VskqrlqcT1JJI0N5MrHkWTV0KeCRYqmwMJnsFJyKu7k4QGozGU2/o4WZpovsL4x3noaVf/moLPszye7Kp6TPpNmLCeXD6JQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788456082; c=relaxed/simple;
	bh=cwEOHTiU517hxhFVjgXYx3BVPHQIc3GSkJ7oIyFTx2E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SFwZQx6H1IQD5kEqkOlD/zzQ+8FSYR9eKVxscx7gUtv0OEVA4qJMf9ZgIpdTvgjK7J2UrMlVMIGLGTDstq2U6nKDxLyBE7/PNNqFAU6TRaMffsza00YEv9Jt0r+9z7RTIgeH5JV81W2qu04cxGq0qBK4mA2215/tnj3+Fk+k9W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=JIFv4Fin; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="JIFv4Fin"
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683G3BcH3435916
	for <fio@vger.kernel.org>; Thu, 3 Sep 2026 10:21:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=+bSTGTZOwlnhYYJ9bx94hU7vnowNu2gnqLZsk
	fzs+S0=; b=JIFv4FinptRp3QOiv8fol3JAYimTAQh5IhdA64oxRB1EpATMVFE3m
	sp96qXqfj0CqTvAmrVb3d5uYcEStzjxp/uFfcEm+MGfl5nP2zMu1o60Qlqei7F1B
	BMGEmzp/BvjOqDoofcgzb5f+rvkE9ABejzlzJ1zrQf3NcXnt2kaXr9VSkwDnj32b
	m2izqbNRLnruoW647AezBSZ8ZAJ2fBJ7EFbqSLxSSHUdAXkSy2q48luqSA+c8YS9
	L85539mE7AYLtKbMQms33BUOsCsAZMEdBIFUERiVImMH0AEwTzVVcMoK4d/wXebF
	TemCGEdJxKIy8aQBk5WnKcE0uaIUyeOXQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gf9n29p6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Thu, 03 Sep 2026 10:21:20 -0700 (PDT)
Received: from twshared45020.31.frc3.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Thu, 3 Sep 2026 17:21:19 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 1E45329E8B145; Thu,  3 Sep 2026 10:21:02 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <fio@vger.kernel.org>
CC: <axboe@kernel.dk>, <vincentfu@gmail.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 3/3] eta: remove now unused done_secs
Date: Thu, 3 Sep 2026 10:21:01 -0700
Message-ID: <20260903172101.1886315-4-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE1MiBTYWx0ZWRfXyl84SQe/lt7q
 Q+elv60/9w0Qdy/UIyrOzmcBSxLC8TuNODolCaI7RYHQU7OfKBMGIaCA5QsYnF8qCcS19okcGOd
 xLvA72C46C2CcsTr+5DM6bvas6AqaiZ9rzUDCaR5S6v+mGo8wT8WccTk43sTlOvjm9OmHfjrMv3
 mbt/D0mT9GGdXfB/TL2MQhkk19Z+c6JBgeKNLObjTNrbam1tg0FyrpP9fwUu7FiXxjQVUWhXy42
 e+oaG1Yg2htuEcKWiNPlIlMq2IvDeTllRi7mVf9xhs385psKW2ehHCKpxGO+oSnlZQEdNwAOnzC
 YaNE54pysCstudYpzpS28eeETdmu5lBoFI9SxKH7jpmYY1YE+VdylVfuOEJpFC58W1vBe2dT06z
 v95CNU4Mq2cde6ls7rV8144MvdzXARrTjSAP4GLWRjxDZGjnKTCuipXxdm8/DLbkcpXBDzQo9HV
 3i2z/KJjoQwbXZ2gsDw==
X-Authority-Analysis: v=2.4 cv=EeL4hvmC c=1 sm=1 tr=0 ts=6a99ac90 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=8elwO82fXORLTBIkMd32:22 a=VwQbUJbxAAAA:8 a=zjoqPvJC1Td6ux_bBhoA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE1MiBTYWx0ZWRfX/AEX7y4HTPg4
 4yCyhllu7919qzS38p3pnwHZykMv9fihKWRNeslCtZzx8hQw35hTtuUZofk6b9y+idytrZimh72
 UZ0ZTL+GGAOLsCj+JjHBm2G29tEGXZs=
X-Proofpoint-ORIG-GUID: NFRNgDa_lzfXUD9LM6bM5Tel5xNTxNEF
X-Proofpoint-GUID: NFRNgDa_lzfXUD9LM6bM5Tel5xNTxNEF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Capping the ETA at the job's own remaining runtime removed the last
reader of done_secs. Drop the variable, along with the gettime call
that maintained it on every reap.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 backend.c | 2 --
 fio.h     | 1 -
 libfio.c  | 1 -
 3 files changed, 4 deletions(-)

diff --git a/backend.c b/backend.c
index 7f41bdfa..50d4394a 100644
--- a/backend.c
+++ b/backend.c
@@ -71,7 +71,6 @@ unsigned int nr_segments =3D 0;
 unsigned int cur_segment =3D 0;
 unsigned int stat_number =3D 0;
 int temp_stall_ts;
-unsigned long done_secs =3D 0;
 #ifdef PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP
 pthread_mutex_t overlap_check =3D PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_N=
P;
 #else
@@ -2494,7 +2493,6 @@ reaped:
 		if (td->error)
 			exit_value++;
=20
-		done_secs +=3D mtime_since_now(&td->epoch) / 1000;
 		profile_td_exit(td);
 		flow_exit_job(td);
 	} end_for_each();
diff --git a/fio.h b/fio.h
index 494959a6..11a0d59d 100644
--- a/fio.h
+++ b/fio.h
@@ -597,7 +597,6 @@ extern bool read_only;
 extern int eta_print;
 extern int eta_new_line;
 extern unsigned int eta_interval_msec;
-extern unsigned long done_secs;
 extern int fio_gtod_offload;
 extern int fio_gtod_cpu;
 extern enum fio_cs fio_clock_source;
diff --git a/libfio.c b/libfio.c
index a57ede4f..c3c17edd 100644
--- a/libfio.c
+++ b/libfio.c
@@ -187,7 +187,6 @@ void reset_fio_state(void)
 	for (i =3D 0; i < nr_segments; i++)
 		segments[i].nr_threads =3D 0;
 	stat_number =3D 0;
-	done_secs =3D 0;
 }
=20
 const char *fio_get_os_string(int nr)
--=20
2.52.0

