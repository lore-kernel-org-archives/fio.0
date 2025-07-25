Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7CD2EFDBE
	for <fio@vger.kernel.org>; Fri, 25 Jul 2025 17:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753466338; cv=none; b=PWcXQDHH95H/ElMbSOM19Jfpg0XLtV/OailtdHtEAKH1A7QtyK2w8WJZAkZmJ0Q1Vjlf79EzL4Hg1/yTPu/F0Iv15KxhJCqkCgPwntxjnOjnMM8gOspyiwPJxdYs6HJt29TLRgpT5PkzzGAvmYrghNlwHHRCktOJKWPNCbhjc78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753466338; c=relaxed/simple;
	bh=+y/MUh23BvD1oI5AROWXK7GiDQwFNjGy9pXl/LlYNJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kvg2p+gr1FHMrTupkqBBVD/YZO2QhXZqe1wr/G81RIHWIrBQZkA2yFTm4nI9z2FdB42vUsL54rwUxlYqKsano5DEU2Wcm595vOqZviPE47pFa+S33JUTg7p2ndaBzneq/+v8L9wfvk9pV+ULJI2xZhgx9AtNZ5rUuFmNU4KPsoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P1X44ZFW; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P1X44ZFW"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7e182e4171bso237687385a.3
        for <fio@vger.kernel.org>; Fri, 25 Jul 2025 10:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753466336; x=1754071136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YI/ac5y/m8sCFIcfyiN88j747pRMaRTvNwzf7UUaAtI=;
        b=P1X44ZFWeW5m3SAc14ZkXiOhR6zGQ9wFeWGcu0UYV1boPTKLthi2RPTVTofkQeleLT
         R+pNWLL3d1MAjUARZR5gTr3jLg8jBOFVvwtUkHImSIpwd56mVGRRdPtWsud2PiGagquH
         N0HMughSqbiOaRrYm5AzdSoPyCbvwhp2OVvhZdhH8of33n7QlFz0FGoBHVRgQlYc1Y5m
         K1fbOs3V6D4iLipyfAcjJ9JIDq8/AdavGqCoXDHRoSXv/TlYwhr58i6qQeR7c8hST47l
         EMk+xXUkP85HJW2OmDGuzC3YToBgZwR5UFSMS9wMVs2xf+OmhbAZ2a8rg0BXrY5F8v5b
         blig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753466336; x=1754071136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YI/ac5y/m8sCFIcfyiN88j747pRMaRTvNwzf7UUaAtI=;
        b=Ttt8ahdADNSGRmt3fgidFjYcr0gLrl+CUHnKZbkrcij242T/HQATrS1JUN5/FwzDfM
         XlCJonGPSJ3RFwInISmdpBcwCfWKdmGxQ8L4NCEen007iieb/84gkw40/Cq6lCJJmUnC
         RQ5mLpHpeyIR3ZxbAtDj4b0Tl7ms5gQIj81q+FAanRiYiOqmv07sGjDD8LDfE2XLrPGM
         OcCsBwrwGNQsCJ8sNbtx+pG0LHyF5X082MenfdyCyQKGcnXlJlQAkmd4Qd32mTLRQyPO
         /x/7elQNZDz6DPFxdYvZ8zOcKFkRMgh8h+aOeiowaZvpoWM45pPX3usLZXg2/RMYkR/q
         la/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXdX9X2SyOujA7fbaZ4sv8cKjGu+WshWW8F/BOGeR3+VO9RWvos4g/Z4NmvrzAoZ8Eev9M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEnCaPEiiI3wFhDRHwsAC6BEVuAldqQS3xAg3oP1kDTOqOqU9J
	RuK6VL8qPN5bD2YCvQqEEXTZEhWnkO0kh1ulKG0+O9NMhAnetavIGto/
X-Gm-Gg: ASbGncumce51oRmMAhTopmGD/yZHjIfMX1jMVPHTgemkuUuIOdRibZH0LreqaasD+D6
	qid9Tw0q9IDH8dAGsExxwkTUNkngG56RFiw/HjlC78ggYtbul/Y/qG/rekr9esTW5UZgmoC7BTz
	UDlshMCVxJ0v/phTjkpeS3vC8hsLUv9JJLHMrZAMID6eyZw3OUmt4UUPFVk7aJiMPRgXaQtIjIM
	vt/qbjiULKx/MjN28CtFOuZsSWMrMMYirVRfwaGgOjUj9b5mphl+nHf2IebFAZNfQCO1JN31Gxg
	K2YxSTFFDB47h25mrkO/2veOV1jdCv+Ibf/ImxQGT09iEyOcJQe3i/wUFph/gCCEyplaV0msrAA
	QEZEf2Fala6dqoM6zCaCb85UAYPTx6Ec70lf70+5BEsHjlMaU7/0WYnzbwbiVIuHbbnIJeT1WpE
	YNv+9Q2jlF
X-Google-Smtp-Source: AGHT+IGxSHG/dNBWUdYTHX808rvdN+s5hXeHpohSQpjzX/RonVtAm2O4ddxxIFVC6vp7BdGJ5W0Iqw==
X-Received: by 2002:a05:6214:252f:b0:6fb:6775:4fb8 with SMTP id 6a1803df08f44-7072053f19fmr37425146d6.13.1753466335469;
        Fri, 25 Jul 2025 10:58:55 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-70729c8ab8asm2839186d6.94.2025.07.25.10.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 10:58:54 -0700 (PDT)
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
Subject: [PATCH 4/7] engines/io_uring: simplify io_u_free
Date: Fri, 25 Jul 2025 13:58:00 -0400
Message-ID: <20250725175808.2632-5-vincent.fu@samsung.com>
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

Just free the buffer unconditionally. If the pointer is null nothing
will happen, so no harm is done.

This lets us also use this function for the io_uring ioengine when it
gains the ability to handle metadata which will happen in a subsequent
patch.

No functional change intended.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 engines/io_uring.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 231c47df..c054a98f 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1468,14 +1468,10 @@ static int fio_ioring_io_u_cmd_init(struct thread_data *td, struct io_u *io_u)
 
 static void fio_ioring_io_u_free(struct thread_data *td, struct io_u *io_u)
 {
-	struct ioring_options *o = td->eo;
-
-	if (o->cmd_type == FIO_URING_CMD_NVME) {
-		struct nvme_pi *pi = io_u->engine_data;
+	struct nvme_pi *pi = io_u->engine_data;
 
-		free(pi);
-		io_u->engine_data = NULL;
-	}
+	free(pi);
+	io_u->engine_data = NULL;
 }
 
 static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
-- 
2.47.2

