Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDF02EFD91
	for <fio@vger.kernel.org>; Fri, 25 Jul 2025 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753466337; cv=none; b=ceKQdNrGRpm/F4K14incmWyO3W1frv+fQaF+bZtd+DZpBY4sNK06jut6KRqz5kbimYClVgoD0J6VODKR2IT6/h/xmWX02MWlegJnOkH3wz4z9RBP7ULVSbJfk1GBW6ZqqZqP5uvdhTD/Zh+tjeOY+vzHzcrO/vURuLQGLSMheyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753466337; c=relaxed/simple;
	bh=3k11z75eLQGT1cPuGMOrdF0chy9Ty8/xX2kVYmmn3p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDsyfVTAiVr4yqrR5/JBA+/tchxiNJmXsnKdSv6Ce+vxKVC1ezUlOzJZkKjEah78+ynoc3LKKQW+EDcbsK9uroadOe83ceQ2wA2QxVOmlDFVgWmt2McIa8MTGp/m8kkzdyIZz03IoAg5TJ3kA365zSX6nq1gFPOQw3D8mSoyt2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dLYBenZ6; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dLYBenZ6"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6fad3400ea3so17597496d6.0
        for <fio@vger.kernel.org>; Fri, 25 Jul 2025 10:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753466333; x=1754071133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=23EjLI7aTqfnbicMJvpW6IaViTd/yg370nmRVxyQBaU=;
        b=dLYBenZ6Y3V7FS+Ut5/w29J1yKTDYPVy2uiuB1FWNn5p571+6M4UfN/GTt2ytQJN2D
         8bK0bxo6UCq9BWCZEHUvtJJYn9K1akYGTEwvJ/sbplZtSbphFogRW284OcUtdDyx437h
         g3OnpNDwftlKG/0roLpvpIcMjzkOS4ljNqQtO8nEYGIH1yOSz3vthyXWMVmnH+gO2dyu
         TodN7NWZkSnoIz4rMz11NbW3eH3/owrf4msGfn0e2dMyMz5cSuf5dgykMuQ1XcRPqCdd
         /PR9BemAJbwe8uMxQtYGW+lirWrwFDE8DRDqeH7sokECbMJ6MjPpIDJng+2OKv487Llc
         idHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753466333; x=1754071133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=23EjLI7aTqfnbicMJvpW6IaViTd/yg370nmRVxyQBaU=;
        b=SOmPwxaaqOp+84h6cB31BXkwH8W3fzDgrG5jyBr3f3J48IxC+mEaomPpj9/XEebxxT
         0Bu2IoVNj3S536ACItmxRy/o2iT7C3yqhalt4QIPmL5nh7qIaq3JyA9FuGl4R4cge5kS
         PjQ+xxK94unuTQ9ZqiJVqlyLbNodFEVUnQmPiTBawnYnmc2ipak5Wi13zfKglg6ayNV9
         +fh4Xkriq9UyscMNCbMVmkvDVfyLPs9oIdymUAd4z5zhUk2fc38LIJ8RC8IU6KJCWKea
         sFYOb1nwNVlUcfsXxkTasgHc3o/2a8QOI4QRCzgeq39m7O9SnefPrQD0TmjXQ4lIxNgA
         YHhw==
X-Forwarded-Encrypted: i=1; AJvYcCVk0chHT3/8sAORdpvJlVvwWkY5JN7j1S57fB8Hz3z558Hjp0UI55fquPZ23aBnFvqAiC4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHGSiUBd8wCRiLwCQjmkWI6r3Uv1t9NQfaaK2kZXPS+UZqFw2k
	e67t/aGuj+ojplUmx3X+7ggBPgOuGxrB3OjvBkvG08L3KbjCGr2BR0hh
X-Gm-Gg: ASbGncsOFjtreCviTfBfp6afiC0ctassBjU+8RtTzt/DsbTLwSkOQTFXHOw3JfhfrtE
	PqXFZHoy05ce3xfSzypDdfINI4xFhO1c69/w1pMfDjl+jX8ZyIMuEbIroootglrdbh7RyVGJEDL
	YmlfFzXXlJAvjm4GQEDmovv7gX0XVOnVrqc4R/MdzFjLFqY03EhkeXrLFIgQ57S1TaSNLoT26fk
	xXS4Yotbtdl0DiQtDAQ7s2Yv0y33C78gyzM9uxQ4NL1ejgJrcyjlpYFR0Qu96eryUZQ2IyFAkJB
	6zG4ry+mi+fyzzR3VbcPt7k0egSIXXVyxB5TgyktfIplOeUC23reFPozrDa579GAgDYev6KQFs7
	G1L6dnRYM8h/QyfWBYiTimVPU6vyrl+rbpd7jydwhRyjbdF6YFXk7GrGRXCUL3KQkz3Ja150FPx
	TD4XLPYExB
X-Google-Smtp-Source: AGHT+IF0MirVhd+6ZOaiyI4qbugrxcM5C3vWI7g2FqqLgJ/E5kaZpw394YctwOvhhNI+FxP/XbRJxA==
X-Received: by 2002:a05:6214:2688:b0:6fa:8c15:75c1 with SMTP id 6a1803df08f44-7072051a1f7mr39526596d6.2.1753466332964;
        Fri, 25 Jul 2025 10:58:52 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-70729c8ab8asm2839186d6.94.2025.07.25.10.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 10:58:52 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: axboe@kernel.dk,
	anuj1072538@gmail.com,
	hch@infradead.org,
	joshi.k@samsung.com,
	anuj20.g@samsung.com,
	fio@vger.kernel.org,
	gost.dev@samsung.com,
	ankit.kumar@samsung.com,
	martin.petersen@oracle.com
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 3/7] engines/nvme: refactor filling protection information
Date: Fri, 25 Jul 2025 13:57:59 -0400
Message-ID: <20250725175808.2632-4-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250725175808.2632-1-vincent.fu@samsung.com>
References: <20250725175808.2632-1-vincent.fu@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Factor out of fio_nvme_pi_fill() the code that generates and fills in
the Guard Protection Information field. This is so that later patches
can use this code without filling in the fields in the NVMe command.

No functional change intended.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 engines/nvme.c | 19 +++++++++++++------
 engines/nvme.h |  2 ++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/engines/nvme.c b/engines/nvme.c
index 1e142e8d..4b3d3860 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -405,14 +405,9 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	return 0;
 }
 
-void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
-		      struct nvme_cmd_ext_io_opts *opts)
+void fio_nvme_generate_guard(struct io_u *io_u, struct nvme_cmd_ext_io_opts *opts)
 {
 	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
-	__u64 slba;
-
-	slba = get_slba(data, io_u->offset);
-	cmd->cdw12 |= opts->io_flags;
 
 	if (data->pi_type && !(opts->io_flags & NVME_IO_PRINFO_PRACT)) {
 		if (data->guard_type == NVME_NVM_NS_16B_GUARD)
@@ -420,6 +415,18 @@ void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		else if (data->guard_type == NVME_NVM_NS_64B_GUARD)
 			fio_nvme_generate_pi_64b_guard(data, io_u, opts);
 	}
+}
+
+void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
+		      struct nvme_cmd_ext_io_opts *opts)
+{
+	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
+	__u64 slba;
+
+	slba = get_slba(data, io_u->offset);
+	cmd->cdw12 |= opts->io_flags;
+
+	fio_nvme_generate_guard(io_u, opts);
 
 	switch (data->pi_type) {
 	case NVME_NS_DPS_PI_TYPE1:
diff --git a/engines/nvme.h b/engines/nvme.h
index 0fef54e9..4371eb5b 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -438,6 +438,8 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		      struct nvme_cmd_ext_io_opts *opts);
 
+void fio_nvme_generate_guard(struct io_u *io_u, struct nvme_cmd_ext_io_opts *opts);
+
 int fio_nvme_pi_verify(struct nvme_data *data, struct io_u *io_u);
 
 int fio_nvme_get_zoned_model(struct thread_data *td, struct fio_file *f,
-- 
2.47.2

