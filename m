Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57877207A34
	for <fio@vger.kernel.org>; Wed, 11 Dec 2024 18:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733942698; cv=none; b=Tjum4iy8NJa38mpyfiCilGr9qqRExm8711jLpFzVLJ4D/psgdR1FmgSSHU3rYG5E/41am1eSAmJFvugt6oaAeDVnj18HvMKyzwN3tH1YrXS3NFzwk/DBJr9F5p9MbnAiY0NU92u/1FIjefxTVOeHcFxUOhcMYgCKzZSMv9NZP5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733942698; c=relaxed/simple;
	bh=Ta9IUDxW4h+m2fBxDW6noY9uFehIT5XrL1u4U5I9rN4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ShAfdNzHPKJHmCbGXpGjDq/d6IeONNwBTaMfvnxGSalfPSX8vv5xPUN4+s3L2eXsdG2p4YR5yPi7GiyF5lBy3kvwrniVMSTjxCRZBV8gmtkGLlSKvzTmRP2mTI13YY7eFNVQ0SJouXAB/7jP4IwTi7BhD43PXpgeN2uCvF7Iaho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=n0uj7lab; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="n0uj7lab"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BBFI4YT023504
	for <fio@vger.kernel.org>; Wed, 11 Dec 2024 10:44:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=ZvOIaYAK0BmtO7A0Wk
	vXOn88BfbPs/I3PKG18d6k12w=; b=n0uj7labfcNM4NoSxvPPzYQChxSAL5GdSV
	dRdp2dQ7Qh0e4Sx7RqLp368bXn1+RR/xTlUAz5NlFm5gFluz8oQz6ePWQLY8QfMs
	2nZqBH2XMQIQrLJ1xybPDPaOj/ahut+4Q1hEQOj/Zd/BnoqI3IcLch2LaGiDdxus
	ORT5uUMKxfk2WMMGBmmKQwSfPE4SJxCpPYgW5aYDVWeS6s8hTKSvoLeLYULwqj9r
	FLsnHFk7EoJpb2bapYjiTVm4STv0L+bpelEy9/kZTCkWda+6kq48V9wNww+QtGCX
	2PxaYTROZ5kwhzW03jVdyLzUKWPJJXVUrAVcUboMGsDoNbgbMb+g==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43fcs9hyvk-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Wed, 11 Dec 2024 10:44:55 -0800 (PST)
Received: from twshared60378.16.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 11 Dec 2024 18:44:54 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id E28A515DE879D; Wed, 11 Dec 2024 10:44:38 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <fio@vger.kernel.org>, <vincent.fu@samsung.com>, <axboe@kernel.dk>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCH] engine/io_uring: add write stream support
Date: Wed, 11 Dec 2024 10:44:38 -0800
Message-ID: <20241211184438.106449-1-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: blqKhBJPFEOWdMnePGOPHQt_Pb757nwZ
X-Proofpoint-ORIG-GUID: blqKhBJPFEOWdMnePGOPHQt_Pb757nwZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

Let a user specify a write stream specific to each job. You can check
the block device's max_write_streams sysfs queue attribute for the valid
range of stream values.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
This depends on the kernel side supporting this feature. The latest is
here, which I *think* appears to have stablized on the API.

  https://lore.kernel.org/io-uring/20241210194722.1905732-1-kbusch@meta.c=
om/T/#u

 engines/io_uring.c  | 18 ++++++++++++++++--
 os/linux/io_uring.h |  4 ++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index facc967f..edb6af37 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -104,6 +104,7 @@ struct ioring_options {
 	unsigned int hipri;
 	unsigned int readfua;
 	unsigned int writefua;
+	unsigned int write_stream;
 	unsigned int deac;
 	unsigned int write_mode;
 	unsigned int verify_mode;
@@ -174,6 +175,16 @@ static struct fio_option options[] =3D {
 		.category =3D FIO_OPT_C_ENGINE,
 		.group	=3D FIO_OPT_G_IOURING,
 	},
+	{
+		.name	=3D "write_stream",
+		.lname	=3D "Tag write commands with this write stream index",
+		.type	=3D FIO_OPT_INT,
+		.off1	=3D offsetof(struct ioring_options, write_stream),
+		.def	=3D "0",
+		.help	=3D "Tag this job's write commands with the requested write stre=
am (Default: 0)",
+		.category =3D FIO_OPT_C_ENGINE,
+		.group	=3D FIO_OPT_G_IOURING,
+	},
 	{
 		.name	=3D "write_mode",
 		.lname	=3D "Additional Write commands support (Write Uncorrectable, Wr=
ite Zeores)",
@@ -434,8 +445,11 @@ static int fio_ioring_prep(struct thread_data *td, s=
truct io_u *io_u)
 		sqe->rw_flags =3D 0;
 		if (o->nowait)
 			sqe->rw_flags |=3D RWF_NOWAIT;
-		if (td->o.oatomic && io_u->ddir =3D=3D DDIR_WRITE)
-			sqe->rw_flags |=3D RWF_ATOMIC;
+		if (io_u->ddir =3D=3D DDIR_WRITE) {
+			if (td->o.oatomic)
+				sqe->rw_flags |=3D RWF_ATOMIC;
+			sqe->write_stream =3D o->write_stream;
+		}
=20
 		/*
 		 * Since io_uring can have a submission context (sqthread_poll)
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index b3876381..8fa3d080 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -64,6 +64,10 @@ struct io_uring_sqe {
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
+		struct {
+			__u8   write_stream;
+			__u8   __pad4[3];
+		};
 	};
 	union {
 		struct {
--=20
2.43.5

