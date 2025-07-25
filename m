Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27DC2F003B
	for <fio@vger.kernel.org>; Fri, 25 Jul 2025 17:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753466331; cv=none; b=NEQTgjleD0bZm9Bh7/kyto5OxR/n0sYH6NVjoKTJveHG7PD+3xEIjf+WqDepsgZZNa7W67ulxyrKv4rY6QEII1Zx/lc98E8xvb6AzzhrCBTN0OUyKdMi/egEGnoqpXr6xCTkJza+L0r9F0sjaHDGbXrauwRswAAsL7wCIu+mKHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753466331; c=relaxed/simple;
	bh=EEPcLdVYrwZRPBDn6Q51dVZL8bjIlg26SB3BhIb75Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuVZY12MgvNO362/HZaNnvRgyhRaNPIJmYs6xEPlY04P6WE6Hs73FsZgl2HgBxmWyti4CZeP4IKbKYzi3dGfhuQcgP04EK9teM3YXK4BXcJUap+ZTm/fw3dUvZu8ctNO/NUwc6CDtLZNLIIHCS4DPWctmYTMW1vrj2ptq0jkDz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TiuMie6p; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TiuMie6p"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-7071b24ee93so13146886d6.2
        for <fio@vger.kernel.org>; Fri, 25 Jul 2025 10:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753466328; x=1754071128; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nuQxRTnvqU3fjqQVEUPY+n0wIOs7pynyXGw6/MuD+I8=;
        b=TiuMie6p6riQhSSlJJyP6j/w5KHv6DRWKf1cWyCSXLXcBxy7r+5vxBFq7Y7UucyH6c
         jH79TRB2aQxUzEeapc+PwLJ25bd5f4reEoRqLosfZTlBr5ypwZknQqlBoiQm/j/QiG7+
         uqXuERdjASmNWijXxLPfrlSvGUsvipJt/+0cAOTcZ9jXDgx63Yi2HaR/D6rQ0D3V31RQ
         kpW2wGETzg1fl6bdniF+pBrB3oF27t3eRGv2Mq64BKpqL9do+25tCphu45wgmbmndh3W
         MKS6uhAnxJ6IAErr7jI/b7nyTG1E+C+QtuBGczISyYerrk4B7+h/7ZN0e6o/Y1MA/TLn
         BpNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753466328; x=1754071128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nuQxRTnvqU3fjqQVEUPY+n0wIOs7pynyXGw6/MuD+I8=;
        b=DxrAfhhMtcwtcUKbYKNM3dz974hKyXc9Zmo0WfWFiT6PDo78JKFu2i8ZjWba3ddjGo
         Kokt85fhmnn0IpKv/BYIaBkdsBim/Ge/d1wbeVLPD3AFOybKvr+0Y+g3LxC9vtyD68SU
         b36yrWXxB78DKD2xqr7Q3bs9R1fIzOfw9yC17B+l0WZOn4lZQom4xARWcVupWuTXCA4A
         ebgykMTowVEXJAzE3wWq3x6940hd31qgX0UAeWqNF04M5UyhHUNxJPMOmArXUYKc399n
         x/cmgNwio2uI18e4XLJvRuQuSg24BHplolLqZGV4Bo9tJQPhuNvlk3hzQH558bXQsUac
         K8zA==
X-Forwarded-Encrypted: i=1; AJvYcCVH5SSOneaelEt5MaFzN13fRG32riUK+L81StRRXqMkSjujlEoOOPkvYqwRG4v+HoSC3Gk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxO1xAVY11RP6qjQeBw/ljhV/xH7sGWCg1OwGxN2QWJHAsHAw9y
	g+0EaVPXeXGb8vyOLFepsbyOsn18f3Fe8Y8XBpKWzwTzwmCmXdDkG6Ys
X-Gm-Gg: ASbGncsybqdYBRczGGygNYFjqcMgbFTvG1oQylB+9KaeM86KVNAs967+wtTsekzZqVO
	FJobaLT/+A/kFBPBgERC0lm2ZsfLIu+7vcyGr/gT6fEbhmyk7jdgrEV7ApL8dQvJ0poofeJwj5J
	PsKmOLu2DTk1NU8hyCiUoohdgkhA3nS6qLsojG+PKVg0GjZnZxxYDqA8ch+1E/eg8cKoDHJQUHW
	Blv0tQVIpitrEtpS5oZvxdQP7JmRFBYmtq4ToumI/ZHuH7H50Xy4caYBSn8Us71AoIFsrPEItNM
	j9b0tcGBho22tsMJnarRLDEPMjowI1xoe8jKjG5c8YFcBatyAMSQsjBBdLUX1KfdDKfZ2t0hXek
	WNYscJiL9hawMQ4LLWDM1VJ/fVHqisB4xqPtvrxHrtEZxtLiDesijYuhDdymjuMak3929TZBPMt
	041xK9DvTQ
X-Google-Smtp-Source: AGHT+IFWclgBJzxf9l7oXE4wxGFjW8GyJwv5BAAnHmY7JWGQO0a3jFNocaNXppS+dJ/gFLYVLBEKdw==
X-Received: by 2002:a05:6214:21e7:b0:706:c5df:e75b with SMTP id 6a1803df08f44-707205ee969mr32664826d6.43.1753466328392;
        Fri, 25 Jul 2025 10:58:48 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-70729c8ab8asm2839186d6.94.2025.07.25.10.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 10:58:47 -0700 (PDT)
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
Subject: [PATCH 2/7] engines/nvme: move inline functions from .c to .h file
Date: Fri, 25 Jul 2025 13:57:58 -0400
Message-ID: <20250725175808.2632-3-vincent.fu@samsung.com>
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

Move two inline helper functions from C source file to header file. In
later patches we will need to use these helper functions outside of
nvme.c.

No functional change intended.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 engines/nvme.c | 16 ----------------
 engines/nvme.h | 16 ++++++++++++++++
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/engines/nvme.c b/engines/nvme.c
index 37a31e2f..1e142e8d 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -8,22 +8,6 @@
 #include "../crc/crc-t10dif.h"
 #include "../crc/crc64.h"
 
-static inline __u64 get_slba(struct nvme_data *data, __u64 offset)
-{
-	if (data->lba_ext)
-		return offset / data->lba_ext;
-
-	return offset >> data->lba_shift;
-}
-
-static inline __u32 get_nlb(struct nvme_data *data, __u64 len)
-{
-	if (data->lba_ext)
-		return len / data->lba_ext - 1;
-
-	return (len >> data->lba_shift) - 1;
-}
-
 static void fio_nvme_generate_pi_16b_guard(struct nvme_data *data,
 					   struct io_u *io_u,
 					   struct nvme_cmd_ext_io_opts *opts)
diff --git a/engines/nvme.h b/engines/nvme.h
index 60b38d7f..0fef54e9 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -476,4 +476,20 @@ static inline bool fio_nvme_pi_ref_escape(__u8 *reftag)
 	return memcmp(reftag, ref_esc, sizeof(ref_esc)) == 0;
 }
 
+static inline __u64 get_slba(struct nvme_data *data, __u64 offset)
+{
+	if (data->lba_ext)
+		return offset / data->lba_ext;
+
+	return offset >> data->lba_shift;
+}
+
+static inline __u32 get_nlb(struct nvme_data *data, __u64 len)
+{
+	if (data->lba_ext)
+		return len / data->lba_ext - 1;
+
+	return (len >> data->lba_shift) - 1;
+}
+
 #endif
-- 
2.47.2

