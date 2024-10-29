Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C83A20400B
	for <fio@vger.kernel.org>; Tue, 29 Oct 2024 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730203216; cv=none; b=llNtRX7N9WwNXGGW7DOLs3wVTH0qcoBS4lyZZCj8XD3ZNP7lQUeE3cDA9NakSZv29UKLWk0FfwmAVAEyZxAivRMWWdH0DYUIUdhLee4t2kHrrOu8q3KqNUrOgg2SIsAEp60pL33tdhUx1MvmZm8qZ/LdmFAA1Ifb7HRbyna5gEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730203216; c=relaxed/simple;
	bh=DTr6h1smHA4h1NmDRvfvuvV860N6OMKayir5spqhaz4=;
	h=Subject:From:To:Message-Id:Date; b=JvP7mcgqt0pzN4yezoMYkoOErUWrUmxZf5oklr3VliXXV51QJDcoXbz2no5DbMQGVPMLM5CuMSuf+BHYKA/dOnKYRX+Nob2uupOyt10RfXnzNeR9K1I91Rbq6r1YfspIqAbNsbHcAfE8E+11Opt+5p/Dj0463Ck5XOZWm9MeDu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VhRI/U4T; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VhRI/U4T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=GyD0sKpNIKeBzAfbyLx6eUuxB7LgCCiFIjtTJYDALEU=; b=VhRI/U4TSmMRW3pUGCYElA2nVn
	PfLssjwviYUEWLPkw9DInvJldg5Rq4OteM4fPnHMUY6IwLnQ7Wap6ZDSAyqEfS6s8o5FWJf5gtYAD
	ptRO9F3e+LMDeKRX/IReWKYSrWwD7qzqNgI5nmjN+4eVBVibr0nTQwZLQJWDFYhtA1uVueI+yhZrW
	m3mrqDC/znx7zQPxLiLc67YQPNiD4/GPVnJzpRAEUsEPVpxHk9sfpJvdt5l+1KDT6KiU1YhyvULvo
	1oDMhjx5E9RXtUcqxIvXbN/RwrmT77TdqeJu9ZxU61d8PaLLs4VkvQrjdlxPtQdZF+zk0CZgTd9MO
	26XUKbXw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t5ktL-00000009tEy-0ISi
	for fio@vger.kernel.org;
	Tue, 29 Oct 2024 12:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id DF8401BC0146; Tue, 29 Oct 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20241029120001.DF8401BC0146@kernel.dk>
Date: Tue, 29 Oct 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 86fc77aa2745882398619cf4d5b5b2d208f69ec4:

  ci: always update apt cache before installing pkgs (2024-10-15 11:29:18 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a191635ad42893a60d0a917b27e97e3fc73f7fee:

  engines/io_uring_cmd: do not send data buffer for write zeroes (2024-10-28 12:25:15 -0400)

----------------------------------------------------------------
Vincent Fu (2):
      engines/io_uring_cmd: add option to set DEAC bit for write zeroes
      engines/io_uring_cmd: do not send data buffer for write zeroes

 engines/io_uring.c | 13 +++++++++++++
 engines/nvme.c     |  6 +++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 1b6a4346..60b4f653 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -104,6 +104,7 @@ struct ioring_options {
 	unsigned int hipri;
 	unsigned int readfua;
 	unsigned int writefua;
+	unsigned int deac;
 	unsigned int write_mode;
 	unsigned int verify_mode;
 	struct cmdprio_options cmdprio_options;
@@ -357,6 +358,16 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "deac",
+		.lname	= "Deallocate bit for write zeroes command",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct ioring_options, deac),
+		.help	= "Set DEAC (deallocate) flag for write zeroes command",
+		.def	= "0",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= NULL,
 	},
@@ -1388,6 +1399,8 @@ static int fio_ioring_init(struct thread_data *td)
 				break;
 			case FIO_URING_CMD_WMODE_ZEROES:
 				ld->write_opcode = nvme_cmd_write_zeroes;
+				if (o->deac)
+					ld->cdw12_flags[DDIR_WRITE] = 1 << 25;
 				break;
 			case FIO_URING_CMD_WMODE_VERIFY:
 				ld->write_opcode = nvme_cmd_verify;
diff --git a/engines/nvme.c b/engines/nvme.c
index 18010c0b..37a31e2f 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -406,7 +406,11 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		cmd->addr = (__u64)(uintptr_t)iov;
 		cmd->data_len = 1;
 	} else {
-		cmd->addr = (__u64)(uintptr_t)io_u->xfer_buf;
+		/* no buffer for write zeroes */
+		if (cmd->opcode != nvme_cmd_write_zeroes)
+			cmd->addr = (__u64)(uintptr_t)io_u->xfer_buf;
+		else
+			cmd->addr = (__u64)(uintptr_t)NULL;
 		cmd->data_len = io_u->xfer_buflen;
 	}
 	if (data->lba_shift && data->ms) {
