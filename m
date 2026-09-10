Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB114A99D7
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 16:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789056804; cv=none; b=aDcSzrhY7xW08ySA5/PUky2EO7ErqPOpmFP7YbE4c8qF5FIUOdLzNX8ol4H8UlyEdTGAi2/9Fy3Eebx+2CrFOAS+5bkv2PlG6I9U8pGEr5r9RwzpeJ21k/DeAznPTQt7mrXJy5lur8z06DqyUYgjDVlaqg/4E1fuWl+cOeVuO/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789056804; c=relaxed/simple;
	bh=mW4S6TZQ0ZWoT/EF3RGSgQyjEwRI0cnd7NBKLbtfbVA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n6MImPSiNYLB0tz/MCZFDSrkwJSX1ZBG+sBntmvG5/EcHRbjg7dsgIxJIFl2m9ZWU8xa4q/vm/WoOCEa1D3ziLi35enQaOuKCWhS17nHNBdsJukgvLEFuSaT3zN6Y1WMSuvZXQxDbsLnd5nymGP1y3We4zP+UBf23fzYxf/Q2dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=U/ZsLnL0; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="U/ZsLnL0"
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AF7rQU3396900
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 09:13:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=99PFsAR2hubnY7MEY1F6UPooiIphW0RYt2LpW
	1+KQLI=; b=U/ZsLnL04d343fhXvwjWIyHI5Ls7PWf6LMvK1Ko1Tf7pWt+9c7tg9
	x16xnnT3uDaONKo50v01Mdiu2eeHEfvFm4HSU7g8xpfWA98grCI397xgHlqR+n9M
	FpZ7Et/2h/zybt/28iulOgkWbO8ZPBBxMxjJt4lIq8a30vLH+wsIU77t42GsDnfQ
	q0GXeY3KkVleDBgA5jRfrVj0Q75K3prXcZVJlZfKtX/d2nm+A8zFdARtoNFXX3e1
	K0vihe5ICKPyd5QWXu31KtiGgknpBCY7l6TSXCgk8+IvWcPgr8Axgzq3dalaFCnP
	MK9toZdsTdiIilRyKrHHtu4Si0h+OWNjg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gkcyffb95-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 09:13:21 -0700 (PDT)
Received: from twshared120513.16.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Thu, 10 Sep 2026 16:13:19 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 74E292BB6CA02; Thu, 10 Sep 2026 09:13:11 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <fio@vger.kernel.org>
CC: <axboe@kernel.dk>, <vincentfu@gmail.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 4/4] eta: remove now unused done_secs
Date: Thu, 10 Sep 2026 09:13:10 -0700
Message-ID: <20260910161310.1478081-5-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: 9L8Ley-fTdWbqDFaOcTxAeG6nAIUDJvH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE5NyBTYWx0ZWRfXw5z0DyrU9uiC
 zYzKS/tt1MXkaM5ydmei/UISOAqd18K+ecykyS9zAih64ZvJvBJrptviTNSOk3feONKlWO+/Wf9
 HLjLyUBH/J9/qnBZxmJGNf3Ii1pvx7s8qYeOtqHLl94RUjmAHyeZPCkUBOZkD5YsOqlIeQ6evkv
 Q08+edztjzkrh23xaZU2yB8aVQ2uL5CbwF1wewAH8gOjvbedOQT7nIWagFXZNvQEq1R1QOQKaVk
 MpnajQlYD1ijvDHRHA3UIeD91rupg4cvwTKInJJrF+d2CxxYWO4YVbBo8StrlgvDEwqw9EzHe24
 mPfLBoQZHuTC2KqKfP4rCWcK0Lt8oY425peeQMHabNV606iQW3REDIzp4UUH4XdniN8Rjkxh8v/
 5+Xp2Fj2OO16szqhpqNGlnYgRXN4k8uv8gTI/kalVfO6ei1svu25AFiD3LYBMmxckQj3gbn9sw1
 RsZo7d1nnz5Mb3kWIFQ==
X-Authority-Analysis: v=2.4 cv=NJRAaE6g c=1 sm=1 tr=0 ts=6aa2d721 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=U_y8lYiYyhHBU5rMqhb2:22 a=VwQbUJbxAAAA:8 a=zjoqPvJC1Td6ux_bBhoA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE5NyBTYWx0ZWRfX4k8TtvxE/jsq
 3Ltt8lzDPexdVHJX/llIUHE8jgNBWwgTCap/lJTHVVXEVct+xnpnYUi2+soDvP6yhaakDNC4ZiS
 ZUlarM3LKFttHafugT3n/4fYER0mrFQ=
X-Proofpoint-GUID: 9L8Ley-fTdWbqDFaOcTxAeG6nAIUDJvH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01

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
index 46bff828..131cda01 100644
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
@@ -2505,7 +2504,6 @@ reaped:
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
index 322906c0..5fc48a1d 100644
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
2.53.0-Meta

