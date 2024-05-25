Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FDB3E462
	for <fio@vger.kernel.org>; Sat, 25 May 2024 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716638412; cv=none; b=RE7QipUEer5mFH7vgxkc0oz1z40FSDw2FhBnVwK2VfB5du3e1YcRIB6FOrkUD+HrpHUb428+0aF4ddBy/FGvbsETUcsfx8YLdEGL7+XPU3qJb7ZNwkkRVjPi/op9n86ZZxReHo+XAnpvGuJQZo0hkUfapS4MNYTAz/TqVQ12LTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716638412; c=relaxed/simple;
	bh=DQS2b87i+kli8Mb4X2fNP7jx+RC3msJT9jcYeTOCIrM=;
	h=Subject:From:To:Message-Id:Date; b=HDc08NpDg4frvNnGZYfOFpReSJpKeY14XzkOmR7l0nDb1w3Y9nwywP6bR+l3I2IQrycEW62VZW4mEJodGZcDQr05H3TsluiSknh623Ix4idwVWFveb7NJjXOlcfSebwgsNai8SLf/kv8ICL26xs3h+6CkpQ57FXkjoZxxK+SVVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DTNdO/Ht; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DTNdO/Ht"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=K8syKqHXq9mzIK0r1cwkNEyYUmR204ETrFksm8lJWdA=; b=DTNdO/HtLaeZlfH4ayvemuMp+N
	9d0qc97zwrgkKSB4wz7ysblO8wET70Wcq60Zl4dTJ3ZnfeKi3ZeOMRvPHeEFkZw0G8lQx9N74eKv0
	GkoyupIuFd7W1fjI8nH1hup8Nq1Ul7z5mnVKWtN/tzdlHh6RTRxYK2goUBMPFeTMQcKSWn6yXjXAt
	LusPuMzN9TXQxMMZXqYo+T30I1TzrIVUZCXACGTSWtRk/tiyM/uld8M4fXw2djyMpNsrajxABE2UB
	XedbyRZRvQxv6x+0eZmvacUCbVhqOeGa9Zd//5FXy7j+x90WEq/G6/3Js2Nsat6X83a39OTmBL7V8
	unk5YAkg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sAq4C-0000000AIMx-2fd2
	for fio@vger.kernel.org;
	Sat, 25 May 2024 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id CDCE51BC0139; Sat, 25 May 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240525120001.CDCE51BC0139@kernel.dk>
Date: Sat, 25 May 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit d3bcdd30da4ad2d6f845e65d6a358c080e120b5e:

  Merge branch 'enable-dataplacement-scheme' of https://github.com/parkvibes/fio (2024-05-21 14:06:32 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 85b5eb32dba009e82d8c1b368ce7d8170d59eb8a:

  Merge branch 'nvme/support-sync-fua-for-iouring-v2' of https://github.com/minwooim/fio (2024-05-24 12:44:44 -0400)

----------------------------------------------------------------
Minwoo Im (1):
      io_uring: Add 'readfua' and 'writefua' options

Vincent Fu (1):
      Merge branch 'nvme/support-sync-fua-for-iouring-v2' of https://github.com/minwooim/fio

 HOWTO.rst          |  4 ++--
 engines/io_uring.c | 32 +++++++++++++++++++++++++++++++-
 engines/nvme.c     |  5 +++--
 engines/nvme.h     |  3 ++-
 fio.1              |  4 ++--
 5 files changed, 40 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 3b262fae..0b39a892 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2847,12 +2847,12 @@ with the caveat that when used on the command line, they must come after the
 	Specify stat system call type to measure lookup/getattr performance.
 	Default is **stat** for :manpage:`stat(2)`.
 
-.. option:: readfua=bool : [sg]
+.. option:: readfua=bool : [sg] [io_uring_cmd]
 
 	With readfua option set to 1, read operations include
 	the force unit access (fua) flag. Default is 0.
 
-.. option:: writefua=bool : [sg]
+.. option:: writefua=bool : [sg] [io_uring_cmd]
 
 	With writefua option set to 1, write operations include
 	the force unit access (fua) flag. Default is 0.
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 9069fa3e..3a03ae35 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -82,11 +82,14 @@ struct ioring_data {
 	struct cmdprio cmdprio;
 
 	struct nvme_dsm *dsm;
+	uint32_t cdw12_flags[DDIR_RWDIR_CNT];
 };
 
 struct ioring_options {
 	struct thread_data *td;
 	unsigned int hipri;
+	unsigned int readfua;
+	unsigned int writefua;
 	struct cmdprio_options cmdprio_options;
 	unsigned int fixedbufs;
 	unsigned int registerfiles;
@@ -135,6 +138,26 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "readfua",
+		.lname	= "Read fua flag support",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct ioring_options, readfua),
+		.help	= "Set FUA flag (force unit access) for all Read operations",
+		.def	= "0",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
+	{
+		.name	= "writefua",
+		.lname	= "Write fua flag support",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct ioring_options, writefua),
+		.help	= "Set FUA flag (force unit access) for all Write operations",
+		.def	= "0",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= "fixedbufs",
 		.lname	= "Fixed (pre-mapped) IO buffers",
@@ -432,7 +455,7 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 
 	return fio_nvme_uring_cmd_prep(cmd, io_u,
 			o->nonvectored ? NULL : &ld->iovecs[io_u->index],
-			dsm);
+			dsm, ld->cdw12_flags[io_u->ddir]);
 }
 
 static struct io_u *fio_ioring_event(struct thread_data *td, int event)
@@ -1219,6 +1242,13 @@ static int fio_ioring_init(struct thread_data *td)
 		}
 	}
 
+	if (!strcmp(td->io_ops->name, "io_uring_cmd")) {
+		if (o->readfua)
+			ld->cdw12_flags[DDIR_READ] = 1 << 30;
+		if (o->writefua)
+			ld->cdw12_flags[DDIR_WRITE] = 1 << 30;
+	}
+
 	return 0;
 }
 
diff --git a/engines/nvme.c b/engines/nvme.c
index c6629e86..7b73c806 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -362,7 +362,8 @@ void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 }
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
-			    struct iovec *iov, struct nvme_dsm *dsm)
+			    struct iovec *iov, struct nvme_dsm *dsm,
+			    unsigned int cdw12_flags)
 {
 	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
 	__u64 slba;
@@ -391,7 +392,7 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	cmd->cdw10 = slba & 0xffffffff;
 	cmd->cdw11 = slba >> 32;
 	/* cdw12 represent number of lba's for read/write */
-	cmd->cdw12 = nlb | (io_u->dtype << 20);
+	cmd->cdw12 = nlb | (io_u->dtype << 20) | cdw12_flags;
 	cmd->cdw13 = io_u->dspec << 16;
 	if (iov) {
 		iov->iov_base = io_u->xfer_buf;
diff --git a/engines/nvme.h b/engines/nvme.h
index 2d5204fc..2db9eb86 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -426,7 +426,8 @@ int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, __u32 pi_act,
 		      struct nvme_data *data);
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
-			    struct iovec *iov, struct nvme_dsm *dsm);
+			    struct iovec *iov, struct nvme_dsm *dsm,
+			    unsigned int cdw12_flags);
 
 void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		      struct nvme_cmd_ext_io_opts *opts);
diff --git a/fio.1 b/fio.1
index 1c8e3a56..9a965cb0 100644
--- a/fio.1
+++ b/fio.1
@@ -2632,11 +2632,11 @@ that "owns" the device also needs to support hipri (also known as iopoll
 and mq_poll). The MegaRAID driver is an example of a SCSI LLD.
 Default: clear (0) which does normal (interrupted based) IO.
 .TP
-.BI (sg)readfua \fR=\fPbool
+.BI (sg, io_uring_cmd)readfua \fR=\fPbool
 With readfua option set to 1, read operations include the force
 unit access (fua) flag. Default: 0.
 .TP
-.BI (sg)writefua \fR=\fPbool
+.BI (sg, io_uring_cmd)writefua \fR=\fPbool
 With writefua option set to 1, write operations include the force
 unit access (fua) flag. Default: 0.
 .TP
