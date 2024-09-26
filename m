Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF1A139B
	for <fio@vger.kernel.org>; Thu, 26 Sep 2024 01:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727312898; cv=none; b=KKf6H+L3rS5b3bptz2aYh5YE0PLYRMMAxcf1zl7gEyAbiUh9Q4FZSJI5wgPYrezoDprnePUGfJMd+Gg2uffItCQxm3kDJcmXPXlG2L4fHLyHkOzmW928MetFOhRRnIiq7kwpbEDdyxhvx+xtk6w0dIJcP9IeNYGASWwTrDpQ/3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727312898; c=relaxed/simple;
	bh=7RhNvkqaJ41GMMN9RNCQnJMMyYHUbKyl+9BXMTC02lY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mG3NRATHrWrq0Aiyuxsx5YKJ2/UQA5D8BmvBec3pPpR7t+h9qAgJKPB1+LTFa2E+JJxcogxSYi3kxgHDlfokB9YiqNOLc65SfgqljIYnJWPPQMzlh0V3zE2en6awSuy8S36qvq5cwIwjKyTBPIzsuzXcG2sYjPgzEieiek42mE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OKUhtaOk; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OKUhtaOk"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2d8a9a15a7fso93793a91.0
        for <fio@vger.kernel.org>; Wed, 25 Sep 2024 18:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727312896; x=1727917696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JZRSdioGouLv0YR14wjo281fZGucUQJhr0JmHEmYxfs=;
        b=OKUhtaOkiwWYkvDYvg7xKhbE3m4z/CpRTmDN/Nekv6Dt4WoHrhkls21oeYx7e3LZiH
         u0vKpEAEhjIUfCwBMIJNoxfg0SBQCq0jUmWavACId0iIgO/XKK63dxtP0V9hkB1Ozw4P
         H/DLDM3xqB5Yf9sdxUf+vPyGrS+8MzQ8eKruD46PGuw9IO9fXu1PsqDF9eiOeFTUUGFH
         3LabowR7j1Zcoby4RM5MCEddvFiHFVql38x2ALVSZ0T+2jkMem3UZ4Oipz/Lxt6f0JQJ
         CTQgbJBgflbEyDVJoehwaJGwqoBOmAtIE6Uq90uQv5pt95Ka/VWGRbHHo7KzdAJvlxqG
         k1Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727312896; x=1727917696;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JZRSdioGouLv0YR14wjo281fZGucUQJhr0JmHEmYxfs=;
        b=amOqFJ1/U4+nXEFUGVaT9Aeh9uu5yvm2m8BLloXirKFdeox2C+ilh9VnN9bwulbW9u
         sKmkxZa1M3N0xDyjBp4IYdzMRFPlL9nkTFS1U53Lnu5eaEfApRlyeu2TsmHBzactA7nz
         ib2utISvATgxE+t7LL7g60hAO7ptpAz55cy3y3BYKb5NEbFnjf8evkV3k4Q55u7iLfyh
         a8oj6NZrxbBnBenJ/c9QO4+d4N6YlohV2z1wS2lnCfDHBdsJSRAabqdzrl0DIkpFb/dr
         Lwy5Pcv/+jeRXfmi/kMDISeVnPiY/SD5kF5dxFoQItCr34wDewianKY3Y7AxFVvZDdqw
         sF/A==
X-Gm-Message-State: AOJu0YzutE5bZWZoOmqgx/wGR05wvJqr9vlvXH0M3kUKsI3atTQrT/fb
	LHRGwZO6cKmH6VCVlzkuwyybnP/bYbVYl+Hd2Imn0+HcEMw9dbOgFgWT2Q==
X-Google-Smtp-Source: AGHT+IGsvJfhoRkC/5ugX3Oa84dA0aOySPJa+4YrghoHNgkrIZSc4lh1KDzzbQvIdPmNQxIPYJsGnQ==
X-Received: by 2002:a05:6a20:258a:b0:1cf:2be2:6525 with SMTP id adf61e73a8af0-1d4e0bafe84mr2840603637.11.1727312895858;
        Wed, 25 Sep 2024 18:08:15 -0700 (PDT)
Received: from localhost ([116.121.76.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b032eb4f7sm2745394b3a.181.2024.09.25.18.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 18:08:15 -0700 (PDT)
From: Minwoo Im <minwoo.im.dev@gmail.com>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Minwoo Im <minwoo.im.dev@gmail.com>
Subject: [PATCH] io_uring: Support Compare command for verification
Date: Thu, 26 Sep 2024 10:08:02 +0900
Message-Id: <20240926010802.27131-1-minwoo.im.dev@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Added 'verify_mode' option to io_uiring_cmd with --cmd_type=nvme to
support data compare verification with Compare commands rather than Read
commands.  This patch newly added IO_U_F_VER_IN_DEV io_u flag to
represent that verification should be done in device side, not the host
side to skip the actual verification phase in verify_io_u().

Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>
---
 engines/io_uring.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 engines/nvme.c     |  5 +++--
 engines/nvme.h     |  4 +++-
 fio.1              | 14 ++++++++++++++
 io_u.h             |  1 +
 verify.c           |  7 +++++++
 6 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 96a042a88820..9ddff2d25ad3 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -41,6 +41,11 @@ enum uring_cmd_write_mode {
 	FIO_URING_CMD_WMODE_VERIFY,
 };
 
+enum uring_cmd_verify_mode {
+	FIO_URING_CMD_VMODE_READ = 1,
+	FIO_URING_CMD_VMODE_COMPARE,
+};
+
 struct io_sq_ring {
 	unsigned *head;
 	unsigned *tail;
@@ -99,6 +104,7 @@ struct ioring_options {
 	unsigned int readfua;
 	unsigned int writefua;
 	unsigned int write_mode;
+	unsigned int verify_mode;
 	struct cmdprio_options cmdprio_options;
 	unsigned int fixedbufs;
 	unsigned int registerfiles;
@@ -194,6 +200,26 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "verify_mode",
+		.lname	= "Do verify based on the configured command (e.g., Read or Compare command)",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct ioring_options, verify_mode),
+		.help	= "Issue Read or Compare command in the verification phase",
+		.def	= "read",
+		.posval = {
+			  { .ival = "read",
+			    .oval = FIO_URING_CMD_VMODE_READ,
+			    .help = "Issue Read commands in the verification phase"
+			  },
+			  { .ival = "compare",
+			    .oval = FIO_URING_CMD_VMODE_COMPARE,
+			    .help = "Issue Compare commands in the verification phase"
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= "fixedbufs",
 		.lname	= "Fixed (pre-mapped) IO buffers",
@@ -443,6 +469,7 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 	struct nvme_dsm *dsm;
 	void *ptr = ld->dsm;
 	unsigned int dsm_size;
+	uint8_t read_opcode = nvme_cmd_read;
 
 	/* only supports nvme_uring_cmd */
 	if (o->cmd_type != FIO_URING_CMD_NVME)
@@ -483,9 +510,21 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 	ptr += io_u->index * dsm_size;
 	dsm = (struct nvme_dsm *)ptr;
 
+	/*
+	 * If READ command belongs to the verification phase and the
+	 * verify_mode=compare, convert READ to COMPARE command.
+	 */
+	if (io_u->flags & IO_U_F_VER_LIST && io_u->ddir == DDIR_READ &&
+			o->verify_mode == FIO_URING_CMD_VMODE_COMPARE) {
+		populate_verify_io_u(td, io_u);
+		read_opcode = nvme_cmd_compare;
+		io_u_set(td, io_u, IO_U_F_VER_IN_DEV);
+	}
+
 	return fio_nvme_uring_cmd_prep(cmd, io_u,
 			o->nonvectored ? NULL : &ld->iovecs[io_u->index],
-			dsm, ld->write_opcode, ld->cdw12_flags[io_u->ddir]);
+			dsm, read_opcode, ld->write_opcode,
+			ld->cdw12_flags[io_u->ddir]);
 }
 
 static struct io_u *fio_ioring_event(struct thread_data *td, int event)
diff --git a/engines/nvme.c b/engines/nvme.c
index 33d874773799..18010c0b5573 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -363,7 +363,8 @@ void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 			    struct iovec *iov, struct nvme_dsm *dsm,
-			    uint8_t write_opcode, unsigned int cdw12_flags)
+			    uint8_t read_opcode, uint8_t write_opcode,
+			    unsigned int cdw12_flags)
 {
 	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
 	__u64 slba;
@@ -373,7 +374,7 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
-		cmd->opcode = nvme_cmd_read;
+		cmd->opcode = read_opcode;
 		break;
 	case DDIR_WRITE:
 		cmd->opcode = write_opcode;
diff --git a/engines/nvme.h b/engines/nvme.h
index b5fef2fb2cf8..60b38d7fd8a5 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -77,6 +77,7 @@ enum nvme_io_opcode {
 	nvme_cmd_write			= 0x01,
 	nvme_cmd_read			= 0x02,
 	nvme_cmd_write_uncor		= 0x04,
+	nvme_cmd_compare		= 0x05,
 	nvme_cmd_write_zeroes		= 0x08,
 	nvme_cmd_dsm			= 0x09,
 	nvme_cmd_verify			= 0x0c,
@@ -431,7 +432,8 @@ int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, __u32 pi_act,
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 			    struct iovec *iov, struct nvme_dsm *dsm,
-			    uint8_t write_opcode, unsigned int cdw12_flags);
+			    uint8_t read_opcode, uint8_t write_opcode,
+			    unsigned int cdw12_flags);
 
 void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		      struct nvme_cmd_ext_io_opts *opts);
diff --git a/fio.1 b/fio.1
index 0fd0fb25f288..356980b5e0b4 100644
--- a/fio.1
+++ b/fio.1
@@ -2675,6 +2675,20 @@ Use Verify commands for write operations
 .RE
 .RE
 .TP
+.BI (io_uring_cmd)verify_mode \fR=\fPstr
+Specifies the type of command to be used in the verification phase. Defaults to 'read'.
+.RS
+.RS
+.TP
+.B read
+Use Read commands for data verification
+.TP
+.B compare
+Use Compare commands for data verification
+.TP
+.RE
+.RE
+.TP
 .BI (sg)sg_write_mode \fR=\fPstr
 Specify the type of write commands to issue. This option can take multiple
 values:
diff --git a/io_u.h b/io_u.h
index ab93d50f967e..3eb60eb346e8 100644
--- a/io_u.h
+++ b/io_u.h
@@ -22,6 +22,7 @@ enum {
 	IO_U_F_BARRIER		= 1 << 6,
 	IO_U_F_VER_LIST		= 1 << 7,
 	IO_U_F_PATTERN_DONE	= 1 << 8,
+	IO_U_F_VER_IN_DEV	= 1 << 9, /* Verify data in device */
 };
 
 /*
diff --git a/verify.c b/verify.c
index f3d228ba7df8..2e113862f2a9 100644
--- a/verify.c
+++ b/verify.c
@@ -901,6 +901,13 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 	if (td_ioengine_flagged(td, FIO_FAKEIO))
 		return 0;
 
+	/*
+	 * If data has already been verified from the device, we can skip
+	 * the actual verification phase here.
+	 */
+	if (io_u->flags & IO_U_F_VER_IN_DEV)
+		return 0;
+
 	if (io_u->flags & IO_U_F_TRIMMED) {
 		ret = verify_trimmed_io_u(td, io_u);
 		goto done;
-- 
2.34.1

