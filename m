Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002E92EFDBE
	for <fio@vger.kernel.org>; Fri, 25 Jul 2025 17:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753466340; cv=none; b=hY9yGj652jEalJHHiTHPvlW7hX+obBY61GWsmP2vZ4b/0d1l5Osr66EFR4mz41PltkoiFPO0CFcdFTltBIyOpVMNNYsesfTDRpEAAhchbEf66a/0+93G9fiMq7Ja0yFzjFTjlG61omOI3pqdJlKOo9YcLP/KHNBcGN9hiU3KZA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753466340; c=relaxed/simple;
	bh=OytCSC9kwCWVRLZdb0e+MPm0wo2SRFkIvj0sEuErBiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjQks/WHlPh/VRlEP3/E8NaL/KER1I+libSo5NKEZfUB+2jAVuKAll0alghhfawZj1NkZYtjo8fyIdboclNPitKqicjvymL5aLhUVHYqDOOulC75L7+nm4Q/nUB4MehREsEnRwQIQsMZYSzdyrcJWwxow7hxlXz0pRNpd26YlGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TU6E9nr5; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TU6E9nr5"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6fad4e6d949so10230866d6.0
        for <fio@vger.kernel.org>; Fri, 25 Jul 2025 10:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753466338; x=1754071138; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xHTOQMo6SGYSiFiOd5zCnEnPWjp13PIsmCidWDt0a+w=;
        b=TU6E9nr5n5o15LW4wOurzdU+Zgi/6biW5MgIrEm1Rcr3jWkBhXQUQvofcZ6im216vi
         fkbEdJMqXZoeTHYTS7xoryEhfynTho6spgPrtFBKygAxaBssh4ky0f1FugGT7Mav2Dw0
         JqA26pt9Q/QCHmJCqVBPFFcLvIXl/AZd6KzVURPH4hW4m2zrlGcVdgfs5c6uVpaxRimD
         /NLW54Ei4y+tr7VJLevlu0z6y2g4LeTYpQ0CN0EV5V/VSct/d9XiWIw5DI8PYtjfBtD0
         /qKyrJkNIwX3BM/aWqDCg/edVGjxUcasZvEsLlFPjsetdQT+SH/yPP5iuwUJx3cF3dL4
         kb8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753466338; x=1754071138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xHTOQMo6SGYSiFiOd5zCnEnPWjp13PIsmCidWDt0a+w=;
        b=oIbtDMRBXGGrbeFxUA6bRtn4pYAp3Jnd2KL/sA3YT32s7tpMaIL4msZ1GFFEdne7ZW
         3SIq4mc8KaESG54/8Qka6LCT2sWAWOnZQ48P4/fghDZs1wgKvyMJ4rU2+1vb7VycZJpg
         UaIh5JEHvFPJdlozWvtgkf5LkszXsa68N5WrixlGjmztorl1TXmSK03daYDaIoL251Hw
         aztmAoy5w/iTnStH7rmVqVwUlQ7Cc8KBUZW2UawWmCEWGHrDojxGmD2yxNWZhdmn6PfP
         eNS2FO9TOqV2ENhZ14uy8FzwibELhzWeZNGSW9Og1YjL2bmkLlRnLlohGh1pQ5wa0E6B
         e6OQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGLFN91E00aCS58z2D0eKcoSTaf2TRVxbH8TQXFxSD9vi9Tg8ToJtLX3Q+dFFbuU5uXZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBFNY2mlsmikikO+5Ot4DZfODDXchWncDOrmRa2aSyb3+0ptE+
	C1qoEpTBBMK6JO6/Ycb6zBIgzZs3gDBCKgLbX8z4kt7WWNE50V2BfW2k
X-Gm-Gg: ASbGncvOVqYhIHh9cWl1vzg42ROKRtaa8mlmBYMwXGXFcNziCsINqG+5mvyzrEKJFtJ
	uK/99Jq/p/iVyaVKMCBEGpWeEa7dPirtvMvnd7iqshVRFIXWVXSuDuK5xGPrhRX9TfUYASkf7WX
	KK6THo8jMim5x9xQ+VrHl6mbi3bGlugtTs5TNa7x1UvJ8Wd+6ot0rRInUN0gsxHjJFpESjHkQf1
	QzD3ZAb0R8ScaI8tLglzAkgsu6nEEjugrkcls9qUbW4bCtYrcmGU2ZdyhLXAaKkKPpPDRnWEr4+
	wg3C/SrcXlB1pyHGV7wmQ+ejShbn1xuCY5vIOBQcadQjhPq+PQTUaZWC8BkxI/6U111qiOxFpH+
	fdmXVE1kAplAz0VXCsBysv8gosGcRAL1soDLZyIPeftVlnsZfBDUNPCj7LvXk15/hn5CDtQoPna
	bwLotrnfl7
X-Google-Smtp-Source: AGHT+IE3Jn73oUfDuqoW8f4F+Bxaz9uSyn076Ha31TZGQMyML6kwzB5K7CBgL0qtg8iC9F7nRrrYfg==
X-Received: by 2002:ad4:5ce5:0:b0:702:d822:9376 with SMTP id 6a1803df08f44-707204ee8efmr39470886d6.12.1753466337537;
        Fri, 25 Jul 2025 10:58:57 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-70729c8ab8asm2839186d6.94.2025.07.25.10.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 10:58:56 -0700 (PDT)
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
Subject: [PATCH 5/7] engines/io_uring: fill in guard generation options at init time
Date: Fri, 25 Jul 2025 13:58:01 -0400
Message-ID: <20250725175808.2632-6-vincent.fu@samsung.com>
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

The protection information check flags, apptag, and apptag mask are
fixed for every single operation in a job. So we should just set these
values at init time instead of populating this structure anew for every
single IO.

Any uses of this structure are guarded by the device's protection
information type, so it is not a problem to fill in this structure even
when the device is formatted with Type 0 PI (no protection).

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 engines/io_uring.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index c054a98f..4c72298d 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -99,6 +99,8 @@ struct ioring_data {
 	uint8_t write_opcode;
 
 	bool is_uring_cmd_eng;
+
+	struct nvme_cmd_ext_io_opts ext_opts;
 };
 
 struct ioring_options {
@@ -738,11 +740,8 @@ static inline void fio_ioring_cmd_nvme_pi(struct thread_data *td,
 					  struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
-	struct ioring_options *o = td->eo;
 	struct nvme_uring_cmd *cmd;
 	struct io_uring_sqe *sqe;
-	struct nvme_cmd_ext_io_opts ext_opts = {0};
-	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
 
 	if (io_u->ddir == DDIR_TRIM)
 		return;
@@ -750,15 +749,7 @@ static inline void fio_ioring_cmd_nvme_pi(struct thread_data *td,
 	sqe = &ld->sqes[(io_u->index) << 1];
 	cmd = (struct nvme_uring_cmd *)sqe->cmd;
 
-	if (data->pi_type) {
-		if (o->pi_act)
-			ext_opts.io_flags |= NVME_IO_PRINFO_PRACT;
-		ext_opts.io_flags |= o->prchk;
-		ext_opts.apptag = o->apptag;
-		ext_opts.apptag_mask = o->apptag_mask;
-	}
-
-	fio_nvme_pi_fill(cmd, io_u, &ext_opts);
+	fio_nvme_pi_fill(cmd, io_u, &ld->ext_opts);
 }
 
 static inline void fio_ioring_cmdprio_prep(struct thread_data *td,
@@ -1355,6 +1346,7 @@ static int fio_ioring_init(struct thread_data *td)
 	unsigned int dsm_size;
 	unsigned long long md_size;
 	int ret, i;
+	struct nvme_cmd_ext_io_opts *ext_opts;
 
 	/* sqthread submission requires registered files */
 	if (o->sqpoll_thread)
@@ -1399,6 +1391,12 @@ static int fio_ioring_init(struct thread_data *td)
 		}
 	}
 	parse_prchk_flags(o);
+	ext_opts = &ld->ext_opts;
+	if (o->pi_act)
+		ext_opts->io_flags |= NVME_IO_PRINFO_PRACT;
+	ext_opts->io_flags |= o->prchk;
+	ext_opts->apptag = o->apptag;
+	ext_opts->apptag_mask = o->apptag_mask;
 
 	ld->iovecs = calloc(ld->iodepth, sizeof(struct iovec));
 
-- 
2.47.2

