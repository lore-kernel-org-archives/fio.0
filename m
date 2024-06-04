Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CE9143747
	for <fio@vger.kernel.org>; Tue,  4 Jun 2024 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717502410; cv=none; b=frc0WyGKsYD2vVpJovNzUWioLoA0khvqkYw4c8Kb4m+e7S4H7sIPNbFsSVjNQtn7jZJZz/W5hWGsaYIKqVzoZBBU23AaC4/K83/qAErvKOTQJFIwN3CN4Nnsx2r+7sW9SYxtcsL4wXCnRA+seE322BEXMDtmk6MIXJYr4ON77ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717502410; c=relaxed/simple;
	bh=xz7vOO3fN/AGm5wf8YMt9+MNjPizFM9nuNlooRXl2K0=;
	h=Subject:From:To:Message-Id:Date; b=ZpuvkgF1QUbAmr0uny4PglTuZ4/ReXe0XTXYIzge7QKBjOp3oXXGaJKTfPpeqLlS01KQe6S6EsL7jaMr6KXUf75KNFqMg1fCeb3Cge0mvI3zJlAxj3cMczzYlgmc4FTGB1wsovu7BT9x2pIKe1oI1Bha+pTdOTo8y1idjEsItlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XfWHukj5; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XfWHukj5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=jZRgtAw18inx9ObUzcRE6XHlUh80a8GORpbFqiTjvBU=; b=XfWHukj59AJwK1dtnxlMCbudcf
	r/Jg3HZiUdI9onwsAnK8n0JZJt8OcIK4SuokYWL8DAk9cxhrwmHPRzoX0WLqoBSduTqSbMxcv8vS9
	4Md7HqygIW+Kc4orRs0LBQO5gwYILf+G5kG8ODHBYPP/nUxSIYQUqkQzts8DAfX9pMSVzbJByFpD1
	lnHX0bw8coNU1Wj9zqy/TkmCxIi4TEhHrOvy2qzFwiWBKGtlomgWLeUIGeGlrcpx01D58pcVo/Ibw
	CKvxXWLwCFT2Nq2oBhwxPsMnAZTvbHFusgckicRDmij+KTXnDjgsJP463J87sNinobbCBjHlvYt07
	xzFf1icA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sESpg-0000000Eo16-1vHX
	for fio@vger.kernel.org;
	Tue, 04 Jun 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 4A9441BC015E; Tue,  4 Jun 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240604120001.4A9441BC015E@kernel.dk>
Date: Tue,  4 Jun 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 93dc85482a998440f8e40814014da8cbfe9cf5e8:

  Merge branch 'fix-coverity-scan-defect' of https://github.com/parkvibes/fio (2024-05-31 09:46:59 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1757469a81cac5bd662b9cde26f1e5d4f0402181:

  Merge branch 'io_uring_cmd/support-write-family' of https://github.com/samsungds/fio (2024-06-03 10:17:38 -0400)

----------------------------------------------------------------
Minwoo Im (1):
      io_uring: Add 'write_mode' option for optional cmds

Vincent Fu (1):
      Merge branch 'io_uring_cmd/support-write-family' of https://github.com/samsungds/fio

 HOWTO.rst          | 16 ++++++++++++++
 engines/io_uring.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 engines/nvme.c     |  4 ++--
 engines/nvme.h     |  5 ++++-
 fio.1              | 20 +++++++++++++++++
 5 files changed, 105 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 0b39a892..33a6ad93 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2857,6 +2857,22 @@ with the caveat that when used on the command line, they must come after the
 	With writefua option set to 1, write operations include
 	the force unit access (fua) flag. Default is 0.
 
+.. option:: write_mode=str : [io_uring_cmd]
+
+        Specifies the type of write operation.  Defaults to 'write'.
+
+                **write**
+                        Use Write commands for write operations
+
+                **uncor**
+                        Use Write Uncorrectable commands for write opreations
+
+                **zeroes**
+                        Use Write Zeroes commands for write operations
+
+                **verify**
+                        Use Verify commands for write operations
+
 .. option:: sg_write_mode=str : [sg]
 
 	Specify the type of write commands to issue. This option can take ten values:
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 05ce27eb..cf8cf289 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -34,6 +34,13 @@ enum uring_cmd_type {
 	FIO_URING_CMD_NVME = 1,
 };
 
+enum uring_cmd_write_mode {
+	FIO_URING_CMD_WMODE_WRITE = 1,
+	FIO_URING_CMD_WMODE_UNCOR,
+	FIO_URING_CMD_WMODE_ZEROES,
+	FIO_URING_CMD_WMODE_VERIFY,
+};
+
 struct io_sq_ring {
 	unsigned *head;
 	unsigned *tail;
@@ -83,6 +90,7 @@ struct ioring_data {
 
 	struct nvme_dsm *dsm;
 	uint32_t cdw12_flags[DDIR_RWDIR_CNT];
+	uint8_t write_opcode;
 };
 
 struct ioring_options {
@@ -90,6 +98,7 @@ struct ioring_options {
 	unsigned int hipri;
 	unsigned int readfua;
 	unsigned int writefua;
+	unsigned int write_mode;
 	struct cmdprio_options cmdprio_options;
 	unsigned int fixedbufs;
 	unsigned int registerfiles;
@@ -158,6 +167,34 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "write_mode",
+		.lname	= "Additional Write commands support (Write Uncorrectable, Write Zeores)",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct ioring_options, write_mode),
+		.help	= "Issue Write Uncorrectable or Zeroes command instaed of Write command",
+		.def	= "write",
+		.posval = {
+			  { .ival = "write",
+			    .oval = FIO_URING_CMD_WMODE_WRITE,
+			    .help = "Issue Write commands for write operations"
+			  },
+			  { .ival = "uncor",
+			    .oval = FIO_URING_CMD_WMODE_UNCOR,
+			    .help = "Issue Write Uncorrectable commands for write operations"
+			  },
+			  { .ival = "zeroes",
+			    .oval = FIO_URING_CMD_WMODE_ZEROES,
+			    .help = "Issue Write Zeroes commands for write operations"
+			  },
+			  { .ival = "verify",
+			    .oval = FIO_URING_CMD_WMODE_VERIFY,
+			    .help = "Issue Verify commands for write operations"
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= "fixedbufs",
 		.lname	= "Fixed (pre-mapped) IO buffers",
@@ -455,7 +492,7 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 
 	return fio_nvme_uring_cmd_prep(cmd, io_u,
 			o->nonvectored ? NULL : &ld->iovecs[io_u->index],
-			dsm, ld->cdw12_flags[io_u->ddir]);
+			dsm, ld->write_opcode, ld->cdw12_flags[io_u->ddir]);
 }
 
 static struct io_u *fio_ioring_event(struct thread_data *td, int event)
@@ -1243,6 +1280,23 @@ static int fio_ioring_init(struct thread_data *td)
 	}
 
 	if (!strcmp(td->io_ops->name, "io_uring_cmd")) {
+		if (td_write(td)) {
+			switch (o->write_mode) {
+			case FIO_URING_CMD_WMODE_UNCOR:
+				ld->write_opcode = nvme_cmd_write_uncor;
+				break;
+			case FIO_URING_CMD_WMODE_ZEROES:
+				ld->write_opcode = nvme_cmd_write_zeroes;
+				break;
+			case FIO_URING_CMD_WMODE_VERIFY:
+				ld->write_opcode = nvme_cmd_verify;
+				break;
+			default:
+				ld->write_opcode = nvme_cmd_write;
+				break;
+			}
+		}
+
 		if (o->readfua)
 			ld->cdw12_flags[DDIR_READ] = 1 << 30;
 		if (o->writefua)
@@ -1371,6 +1425,14 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 			td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
 			return 1;
 		}
+
+		if (o->write_mode != FIO_URING_CMD_WMODE_WRITE &&
+		    !td_write(td)) {
+			log_err("%s: 'readwrite=|rw=' has no write\n",
+					f->file_name);
+			td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
+			return 1;
+		}
 	}
 	if (!ld || !o->registerfiles)
 		return generic_open_file(td, f);
diff --git a/engines/nvme.c b/engines/nvme.c
index 7b73c806..72934c8b 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -363,7 +363,7 @@ void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 			    struct iovec *iov, struct nvme_dsm *dsm,
-			    unsigned int cdw12_flags)
+			    uint8_t write_opcode, unsigned int cdw12_flags)
 {
 	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
 	__u64 slba;
@@ -376,7 +376,7 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		cmd->opcode = nvme_cmd_read;
 		break;
 	case DDIR_WRITE:
-		cmd->opcode = nvme_cmd_write;
+		cmd->opcode = write_opcode;
 		break;
 	case DDIR_TRIM:
 		fio_nvme_uring_cmd_trim_prep(cmd, io_u, dsm);
diff --git a/engines/nvme.h b/engines/nvme.h
index 2db9eb86..bc2370b8 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -75,7 +75,10 @@ enum nvme_admin_opcode {
 enum nvme_io_opcode {
 	nvme_cmd_write			= 0x01,
 	nvme_cmd_read			= 0x02,
+	nvme_cmd_write_uncor		= 0x04,
+	nvme_cmd_write_zeroes		= 0x08,
 	nvme_cmd_dsm			= 0x09,
+	nvme_cmd_verify			= 0x0c,
 	nvme_cmd_io_mgmt_recv		= 0x12,
 	nvme_zns_cmd_mgmt_send		= 0x79,
 	nvme_zns_cmd_mgmt_recv		= 0x7a,
@@ -427,7 +430,7 @@ int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, __u32 pi_act,
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 			    struct iovec *iov, struct nvme_dsm *dsm,
-			    unsigned int cdw12_flags);
+			    uint8_t write_opcode, unsigned int cdw12_flags);
 
 void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		      struct nvme_cmd_ext_io_opts *opts);
diff --git a/fio.1 b/fio.1
index 9a965cb0..2649529b 100644
--- a/fio.1
+++ b/fio.1
@@ -2640,6 +2640,26 @@ unit access (fua) flag. Default: 0.
 With writefua option set to 1, write operations include the force
 unit access (fua) flag. Default: 0.
 .TP
+.BI (io_uring_cmd)write_mode \fR=\fPstr
+Specifies the type of write operation.  Defaults to 'write'.
+.RS
+.RS
+.TP
+.B write
+Use Write commands for write operations
+.TP
+.B uncor
+Use Write Uncorrectable commands for write opreations
+.TP
+.B zeroes
+Use Write Zeroes commands for write operations
+.TP
+.B verify
+Use Verify commands for write operations
+.TP
+.RE
+.RE
+.TP
 .BI (sg)sg_write_mode \fR=\fPstr
 Specify the type of write commands to issue. This option can take multiple
 values:
