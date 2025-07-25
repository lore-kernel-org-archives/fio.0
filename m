Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112962F002B
	for <fio@vger.kernel.org>; Fri, 25 Jul 2025 17:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753466328; cv=none; b=gsGYAeHTKr0IRjw4eIuLmfrKJxZm9Pe8r5DGeLI1YgAtla7BIre9/3Ch/ntZJOQLK5CN/gIOoqfcy6H8IUcHP6EEwGzOtqe39/XolJ+nOaO/l/2Vw5MTI7gQQnJ89nhaz3l0rlcyPO689m+OfH3nKHu0vx0W8oWIwbTH9Yd6iVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753466328; c=relaxed/simple;
	bh=pEnWMI/13i+rOWARL8ahAH5koTMWDmfBlrzbFNmOeGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvqTo9qPGjnSSzeoOwvg/Hmj2hnmOSD6/hntecoMCFoFYFI1pFx1lg7+1HPe6x9N8KHzPqefWeflHhQwyGOLhaAq6Fl4BhLBIVXW9qfNPba/05VHJjh9VoaYmSuSDwPtrMWOApzwi48UCza3J6mxtvosb3oU8zBIL3SKXzBGDQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WCeGfNAU; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WCeGfNAU"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ab92d06ddeso33289581cf.3
        for <fio@vger.kernel.org>; Fri, 25 Jul 2025 10:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753466325; x=1754071125; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CFmkRtioacTBxIXA0sH+B5y01DTdzGqyCSZ4lfWo8+Q=;
        b=WCeGfNAUmpqxiJMOZj1J/697spKnOODwtRFE7s3R6A6fqZJCpLBvEiFSSZwXSHkLjC
         78/3DN0+GrqC/Rx7aGWSKqs0xH8nmmb6j6VHB+ARSi96I4Y+Wy13bjr2xU3p4LrDIcs1
         FjXBxytaFTRcqXOmnjBeq9OYTcS6IeVWtyW1kvXKTOXwdV8mw7ugVdywVREi0CDCVv9N
         fTMnZMSmW9cNVn0fm2Y6y3TsFWBniKD+V58Bzuz2E3cXr1a8spdNfaaYqwbX77NcwwV1
         O+cOeXuTx3wQRsWdrnrWE6ajPG/P19iRitLr0NY/1HjWOBg/Iju0SdEUPC1N+WDIi8TE
         93bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753466325; x=1754071125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CFmkRtioacTBxIXA0sH+B5y01DTdzGqyCSZ4lfWo8+Q=;
        b=LqvwzG3rCHVZhTWxMZSChVDSNru8rkoBgVf8w4l1m28ah3xUi23N/M3wPbS5IBl0DC
         SWdVlpTSoyUXJNP9JMAecNCedL8Vz3via/VYtH25vbwOx/BuutBRh+/A+1sTMkOcD8yn
         gKUeJV+hTaKaqBzOAFRKgXZDi/tkmvPpdzy4zxpjv87eo0cACaiPOKXNPL5iLHA2b/Wc
         NZEYAYmewS7/wsQd2sPgtnnYXbV0ijBVSwi/lG/gBRWBWEsdUxWKOQtOYtwLdETqf7yK
         vT4v1JsThJLTTetA113k7mp3XBnrDF3eSmDiCRlajsnb1+Vrks43CBQW2B7GrrHkRCIg
         ACJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGcEK3po4xTtZRHMf98MiMWkyxNB58LYFnv0sG7Tte8AO1EI0aZNSmVlzU1jH90lIBURc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0+AAC1D4ivkezQZLoRLRqBKC9EOeTYFxAFphWiqoD+OjPL+3w
	o5J5YqZVkre7tTgNVOBdQ4YDKBKKUjQnQUSnec1g9li4BUtWm33/z8t0
X-Gm-Gg: ASbGncuDpWxeArSocJ5G5OMwmwvntBsbO00ycbafeRATUwcNLJ7A0rBXmVrcXCFsLKf
	+onHREBm/lHV7QrvpUa0A7fiw8E8XcOwRS0bZrgThp0wisfNK7iT2X2hEgmyHps4h+OKwCjOcdL
	4y6aEwURMNk4gmN8aEjwNgOhUv1O4Yh1gAuHZfSbpZ09vAaLAdMo+6ymW2b8/RtJrDIFsNUv9mG
	rixPSNFhZrSPgztIHAZOdS5iu5+v5rnyznG2tehAhARUOiw2Muw69R1wFbll08AwVjLyFPYAIjH
	8JYf57Bp2EoTlreY/GmiWANPmllLtAe6ElRj84BYqoGiyObIYzQhRfcIDk2CVl6005KZmGSLS8H
	gCo2gHQ0q/l/9pOISHHPgdkPy2elImXaTiUEW73NHJdq/0MglzOHc3kbws//C5d0CvZWkKDw9Oe
	HRgARHMEPt
X-Google-Smtp-Source: AGHT+IHCvLSeDQIA9MOlP1n41PPChqLhxOD50t7afbRZUxv4IJe6jotEWt9ehluHciDm3atzGKvu9w==
X-Received: by 2002:a05:6214:404:b0:6fd:a382:f86f with SMTP id 6a1803df08f44-707205c1e57mr40984496d6.34.1753466324775;
        Fri, 25 Jul 2025 10:58:44 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-70729c8ab8asm2839186d6.94.2025.07.25.10.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 10:58:44 -0700 (PDT)
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
Subject: [PATCH 1/7] engines/io_uring: store ioengine id in ioengine data
Date: Fri, 25 Jul 2025 13:57:57 -0400
Message-ID: <20250725175808.2632-2-vincent.fu@samsung.com>
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

To reduce pointer chasing in the hot path just store whether we are
using the io_uring or io_uring_cmd ioengine in the ioengine data.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 engines/io_uring.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 5bbcc97a..231c47df 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -97,6 +97,8 @@ struct ioring_data {
 	struct nvme_dsm *dsm;
 	uint32_t cdw12_flags[DDIR_RWDIR_CNT];
 	uint8_t write_opcode;
+
+	bool is_uring_cmd_eng;
 };
 
 struct ioring_options {
@@ -136,12 +138,6 @@ static const int fixed_ddir_to_op[2] = {
 	IORING_OP_WRITE_FIXED
 };
 
-static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u);
-static inline bool is_uring_cmd_eng(struct thread_data *td)
-{
-	return td->io_ops->prep == fio_ioring_cmd_prep;
-}
-
 static int fio_ioring_sqpoll_cb(void *data, unsigned long long *val)
 {
 	struct ioring_options *o = data;
@@ -804,7 +800,7 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (ld->cmdprio.mode != CMDPRIO_MODE_NONE)
 		fio_ioring_cmdprio_prep(td, io_u);
 
-	if (o->cmd_type == FIO_URING_CMD_NVME && is_uring_cmd_eng(td))
+	if (o->cmd_type == FIO_URING_CMD_NVME && ld->is_uring_cmd_eng)
 		fio_ioring_cmd_nvme_pi(td, io_u);
 
 	tail = *ring->tail;
@@ -1372,6 +1368,8 @@ static int fio_ioring_init(struct thread_data *td)
 
 	ld = calloc(1, sizeof(*ld));
 
+	ld->is_uring_cmd_eng = (td->io_ops->prep == fio_ioring_cmd_prep);
+
 	/*
 	 * The internal io_uring queue depth must be a power-of-2, as that's
 	 * how the ring interface works. So round that up, in case the user
@@ -1388,7 +1386,7 @@ static int fio_ioring_init(struct thread_data *td)
 	 * We are only supporting iomem=malloc / mem=malloc as of now.
 	 */
 	if (o->cmd_type == FIO_URING_CMD_NVME && o->md_per_io_size &&
-	    is_uring_cmd_eng(td)) {
+	    ld->is_uring_cmd_eng) {
 		md_size = (unsigned long long) o->md_per_io_size
 				* (unsigned long long) td->o.iodepth;
 		md_size += page_mask + td->o.mem_align;
@@ -1417,7 +1415,7 @@ static int fio_ioring_init(struct thread_data *td)
 	 * in zbd mode where trim means zone reset.
 	 */
 	if (td_trim(td) && td->o.zone_mode == ZONE_MODE_ZBD &&
-	    is_uring_cmd_eng(td)) {
+	    ld->is_uring_cmd_eng) {
 		td->io_ops->flags |= FIO_ASYNCIO_SYNC_TRIM;
 	} else {
 		dsm_size = sizeof(*ld->dsm);
@@ -1431,7 +1429,7 @@ static int fio_ioring_init(struct thread_data *td)
 		}
 	}
 
-	if (is_uring_cmd_eng(td))
+	if (ld->is_uring_cmd_eng)
 		return fio_ioring_cmd_init(td, ld);
 	return 0;
 }
-- 
2.47.2

