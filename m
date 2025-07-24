Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AB42BE7DC
	for <fio@vger.kernel.org>; Thu, 24 Jul 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753358410; cv=none; b=UEPgF5sX3+QLs9ysQEjC1RrpgpRPCM0GUTzjyLgTISULmWcUgdUn4Hz3EuURdYy43vgsk1+T40mfsQR1g6yh9WKt8Khp7plbc+g79cCBiQxhMsK7WSSBf1jb54QReEbq4pvwQTKjFPposzeN7tvuHFSrPMNejYBmqwJ52OBRUk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753358410; c=relaxed/simple;
	bh=5lw7bbMKYtAuxUYt55nEmbXKbayAbby6IINEtrg4qe4=;
	h=Subject:From:To:Message-Id:Date; b=oZo8QCPtEYLrSiAfQDwUaj30iiyEgMvDEqeo63xHMUrzhbR5vcXcG78WpmBEUXjd9qasmBrhK2LkrPhQ8wUaDV2re28o6i+Qawbhvr/QkN3O56xTpiwlH9vIJdj4ADKyaSGL6sjzDz3wl/LUCFgd8sBpJrX25ncSDbf5NMaboWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n0XVw03z; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n0XVw03z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=vrt4AtkYXN71bl0XnOL0DIHPkMpACzA5s7ugWO3jfPs=; b=n0XVw03zx6eAuymA5guy6jeqyc
	R7cS3t/8YPWzwAW+bXNs2mrAPV3AEav3DkfeKAnzFpPhh9FvZpzRl+B7spk2hpYS3inpVxfrjh4ds
	NDNmD7brMMW8CFn8s7V3Ox9j4sUzue9zAkMyMpU0UIbfKV5yd/8rOPV9qut4qALbfcxUIaseQP9qR
	lOnCHpjpiWXczExJ+bOIikopNWjZeD3V3+HWOTSHN8FvrZw+xXt6swqbj+P8WXXuXX1wtCFtUh4Hk
	5rWzbizFQM9D9dHEzHKXjWkMW5TJvWesDGEN9fn0WgUgwXXBRQZJp7OAnJb0ko7wt4x77FQQP/Tfs
	0fkvRSXQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ueucF-0000000Cneo-2ZOX
	for fio@vger.kernel.org;
	Thu, 24 Jul 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 4F16C1BC013F; Thu, 24 Jul 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250724120001.4F16C1BC013F@kernel.dk>
Date: Thu, 24 Jul 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 258e96aa863a48c86439a1dac54da7703252ee70:

  Merge branch 'filetype-option' of https://github.com/struschev/fio (2025-07-22 09:47:31 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 306d89868d07b98d1683585468d232703007e0da:

  engines/io_uring: don't duplicate open/close file code (2025-07-23 14:22:36 -0600)

----------------------------------------------------------------
Jens Axboe (5):
      engines/io_uring: get rid of silly strcmp() calls for io_ops->name
      engines/io_uring: io_uring engine type cleanups
      engines/io_uring: cleanup fio_ioring_cmd_open_file()
      engines/io_uring: code cleanup
      engines/io_uring: don't duplicate open/close file code

 engines/io_uring.c | 281 +++++++++++++++++++++++++++++------------------------
 1 file changed, 155 insertions(+), 126 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 87018f84..5bbcc97a 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -136,6 +136,12 @@ static const int fixed_ddir_to_op[2] = {
 	IORING_OP_WRITE_FIXED
 };
 
+static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u);
+static inline bool is_uring_cmd_eng(struct thread_data *td)
+{
+	return td->io_ops->prep == fio_ioring_cmd_prep;
+}
+
 static int fio_ioring_sqpoll_cb(void *data, unsigned long long *val)
 {
 	struct ioring_options *o = data;
@@ -798,8 +804,7 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (ld->cmdprio.mode != CMDPRIO_MODE_NONE)
 		fio_ioring_cmdprio_prep(td, io_u);
 
-	if (!strcmp(td->io_ops->name, "io_uring_cmd") &&
-		o->cmd_type == FIO_URING_CMD_NVME)
+	if (o->cmd_type == FIO_URING_CMD_NVME && is_uring_cmd_eng(td))
 		fio_ioring_cmd_nvme_pi(td, io_u);
 
 	tail = *ring->tail;
@@ -1314,6 +1319,37 @@ static void parse_prchk_flags(struct ioring_options *o)
 		o->prchk |= NVME_IO_PRINFO_PRCHK_APP;
 }
 
+static int fio_ioring_cmd_init(struct thread_data *td, struct ioring_data *ld)
+{
+	struct ioring_options *o = td->eo;
+
+	if (td_write(td)) {
+		switch (o->write_mode) {
+		case FIO_URING_CMD_WMODE_UNCOR:
+			ld->write_opcode = nvme_cmd_write_uncor;
+			break;
+		case FIO_URING_CMD_WMODE_ZEROES:
+			ld->write_opcode = nvme_cmd_write_zeroes;
+			if (o->deac)
+				ld->cdw12_flags[DDIR_WRITE] = 1 << 25;
+			break;
+		case FIO_URING_CMD_WMODE_VERIFY:
+			ld->write_opcode = nvme_cmd_verify;
+			break;
+		default:
+			ld->write_opcode = nvme_cmd_write;
+			break;
+		}
+	}
+
+	if (o->readfua)
+		ld->cdw12_flags[DDIR_READ] = 1 << 30;
+	if (o->writefua)
+		ld->cdw12_flags[DDIR_WRITE] = 1 << 30;
+
+	return 0;
+}
+
 static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o = td->eo;
@@ -1351,8 +1387,8 @@ static int fio_ioring_init(struct thread_data *td)
 	 * metadata buffer for nvme command.
 	 * We are only supporting iomem=malloc / mem=malloc as of now.
 	 */
-	if (!strcmp(td->io_ops->name, "io_uring_cmd") &&
-	    (o->cmd_type == FIO_URING_CMD_NVME) && o->md_per_io_size) {
+	if (o->cmd_type == FIO_URING_CMD_NVME && o->md_per_io_size &&
+	    is_uring_cmd_eng(td)) {
 		md_size = (unsigned long long) o->md_per_io_size
 				* (unsigned long long) td->o.iodepth;
 		md_size += page_mask + td->o.mem_align;
@@ -1380,12 +1416,12 @@ static int fio_ioring_init(struct thread_data *td)
 	 * For io_uring_cmd, trims are async operations unless we are operating
 	 * in zbd mode where trim means zone reset.
 	 */
-	if (!strcmp(td->io_ops->name, "io_uring_cmd") && td_trim(td) &&
-	    td->o.zone_mode == ZONE_MODE_ZBD) {
+	if (td_trim(td) && td->o.zone_mode == ZONE_MODE_ZBD &&
+	    is_uring_cmd_eng(td)) {
 		td->io_ops->flags |= FIO_ASYNCIO_SYNC_TRIM;
 	} else {
-		dsm_size = sizeof(*ld->dsm) +
-			td->o.num_range * sizeof(struct nvme_dsm_range);
+		dsm_size = sizeof(*ld->dsm);
+		dsm_size += td->o.num_range * sizeof(struct nvme_dsm_range);
 		ld->dsm = calloc(td->o.iodepth, dsm_size);
 		ptr = ld->dsm;
 		for (i = 0; i < td->o.iodepth; i++) {
@@ -1395,56 +1431,38 @@ static int fio_ioring_init(struct thread_data *td)
 		}
 	}
 
-	if (!strcmp(td->io_ops->name, "io_uring_cmd")) {
-		if (td_write(td)) {
-			switch (o->write_mode) {
-			case FIO_URING_CMD_WMODE_UNCOR:
-				ld->write_opcode = nvme_cmd_write_uncor;
-				break;
-			case FIO_URING_CMD_WMODE_ZEROES:
-				ld->write_opcode = nvme_cmd_write_zeroes;
-				if (o->deac)
-					ld->cdw12_flags[DDIR_WRITE] = 1 << 25;
-				break;
-			case FIO_URING_CMD_WMODE_VERIFY:
-				ld->write_opcode = nvme_cmd_verify;
-				break;
-			default:
-				ld->write_opcode = nvme_cmd_write;
-				break;
-			}
-		}
+	if (is_uring_cmd_eng(td))
+		return fio_ioring_cmd_init(td, ld);
+	return 0;
+}
 
-		if (o->readfua)
-			ld->cdw12_flags[DDIR_READ] = 1 << 30;
-		if (o->writefua)
-			ld->cdw12_flags[DDIR_WRITE] = 1 << 30;
-	}
+static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
+{
+	struct ioring_data *ld = td->io_ops_data;
 
+	ld->io_u_index[io_u->index] = io_u;
 	return 0;
 }
 
-static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
+static int fio_ioring_io_u_cmd_init(struct thread_data *td, struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
 	struct nvme_pi_data *pi_data;
 	char *p;
 
-	ld->io_u_index[io_u->index] = io_u;
+	fio_ioring_io_u_init(td, io_u);
 
-	if (!strcmp(td->io_ops->name, "io_uring_cmd")) {
-		p = PTR_ALIGN(ld->md_buf, page_mask) + td->o.mem_align;
-		p += o->md_per_io_size * io_u->index;
-		io_u->mmap_data = p;
-
-		if (!o->pi_act) {
-			pi_data = calloc(1, sizeof(*pi_data));
-			pi_data->io_flags |= o->prchk;
-			pi_data->apptag_mask = o->apptag_mask;
-			pi_data->apptag = o->apptag;
-			io_u->engine_data = pi_data;
-		}
+	p = PTR_ALIGN(ld->md_buf, page_mask) + td->o.mem_align;
+	p += o->md_per_io_size * io_u->index;
+	io_u->mmap_data = p;
+
+	if (!o->pi_act) {
+		pi_data = calloc(1, sizeof(*pi_data));
+		pi_data->io_flags |= o->prchk;
+		pi_data->apptag_mask = o->apptag_mask;
+		pi_data->apptag = o->apptag;
+		io_u->engine_data = pi_data;
 	}
 
 	return 0;
@@ -1453,11 +1471,10 @@ static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 static void fio_ioring_io_u_free(struct thread_data *td, struct io_u *io_u)
 {
 	struct ioring_options *o = td->eo;
-	struct nvme_pi *pi;
 
-	if (!strcmp(td->io_ops->name, "io_uring_cmd") &&
-	    (o->cmd_type == FIO_URING_CMD_NVME)) {
-		pi = io_u->engine_data;
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		struct nvme_pi *pi = io_u->engine_data;
+
 		free(pi);
 		io_u->engine_data = NULL;
 	}
@@ -1475,90 +1492,106 @@ static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
+static int verify_params(struct thread_data *td, struct nvme_data *data,
+			 struct fio_file *f, enum fio_ddir ddir)
 {
-	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
+	unsigned int lba_size;
+
+	lba_size = data->lba_ext ? data->lba_ext : data->lba_size;
+	if (td->o.min_bs[ddir] % lba_size || td->o.max_bs[ddir] % lba_size) {
+		if (data->lba_ext) {
+			log_err("%s: block size must be a multiple of %u "
+				"(LBA data size + Metadata size)\n", f->file_name, lba_size);
+			if (td->o.min_bs[ddir] == td->o.max_bs[ddir] &&
+			    !(td->o.min_bs[ddir] % data->lba_size)) {
+				/* fixed block size is actually a multiple of LBA data size */
+				unsigned long long suggestion = lba_size *
+					(td->o.min_bs[ddir] / data->lba_size);
+				log_err("Did you mean to use a block size of %llu?\n", suggestion);
+			}
+		} else {
+			log_err("%s: block size must be a multiple of LBA data size\n",
+				f->file_name);
+		}
+		td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
+		return 1;
+	}
+	if (data->ms && !data->lba_ext && ddir != DDIR_TRIM &&
+	    (o->md_per_io_size < ((td->o.max_bs[ddir] / data->lba_size) * data->ms))) {
+		log_err("%s: md_per_io_size should be at least %llu bytes\n",
+			f->file_name,
+			((td->o.max_bs[ddir] / data->lba_size) * data->ms));
+		td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
+		return 1;
+	}
 
-	if (o->cmd_type == FIO_URING_CMD_NVME) {
-		struct nvme_data *data = NULL;
-		unsigned int lba_size = 0;
-		__u64 nlba = 0;
-		int ret;
+	return 0;
+}
 
-		/* Store the namespace-id and lba size. */
-		data = FILE_ENG_DATA(f);
-		if (data == NULL) {
-			data = calloc(1, sizeof(struct nvme_data));
-			ret = fio_nvme_get_info(f, &nlba, o->pi_act, data);
-			if (ret) {
-				free(data);
-				return ret;
-			}
+static int fio_ioring_open_nvme(struct thread_data *td, struct fio_file *f)
+{
+	struct ioring_options *o = td->eo;
+	struct nvme_data *data = NULL;
+	__u64 nlba = 0;
+	int ret;
 
-			FILE_SET_ENG_DATA(f, data);
+	/* Store the namespace-id and lba size. */
+	data = FILE_ENG_DATA(f);
+	if (data == NULL) {
+		data = calloc(1, sizeof(struct nvme_data));
+		ret = fio_nvme_get_info(f, &nlba, o->pi_act, data);
+		if (ret) {
+			free(data);
+			return ret;
 		}
 
-		lba_size = data->lba_ext ? data->lba_ext : data->lba_size;
-
-		for_each_rw_ddir(ddir) {
-			if (td->o.min_bs[ddir] % lba_size || td->o.max_bs[ddir] % lba_size) {
-				if (data->lba_ext) {
-					log_err("%s: block size must be a multiple of %u "
-						"(LBA data size + Metadata size)\n", f->file_name, lba_size);
-					if (td->o.min_bs[ddir] == td->o.max_bs[ddir] &&
-					    !(td->o.min_bs[ddir] % data->lba_size)) {
-						/* fixed block size is actually a multiple of LBA data size */
-						unsigned long long suggestion = lba_size *
-							(td->o.min_bs[ddir] / data->lba_size);
-						log_err("Did you mean to use a block size of %llu?\n", suggestion);
-					}
-				} else {
-					log_err("%s: block size must be a multiple of LBA data size\n",
-						f->file_name);
-				}
-				td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
-				return 1;
-			}
-			if (data->ms && !data->lba_ext && ddir != DDIR_TRIM &&
-			    (o->md_per_io_size < ((td->o.max_bs[ddir] / data->lba_size) *
-						  data->ms))) {
-				log_err("%s: md_per_io_size should be at least %llu bytes\n",
-					f->file_name,
-					((td->o.max_bs[ddir] / data->lba_size) * data->ms));
-				td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
-				return 1;
-			}
-                }
+		FILE_SET_ENG_DATA(f, data);
+	}
 
-		/*
-		 * For extended logical block sizes we cannot use verify when
-		 * end to end data protection checks are enabled, as the PI
-		 * section of data buffer conflicts with verify.
-		 */
-		if (data->ms && data->pi_type && data->lba_ext &&
-		    td->o.verify != VERIFY_NONE) {
-			log_err("%s: for extended LBA, verify cannot be used when E2E data protection is enabled\n",
-				f->file_name);
-			td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
-			return 1;
-		}
+	for_each_rw_ddir(ddir) {
+		ret = verify_params(td, data, f, ddir);
+		if (ret)
+			return ret;
+	}
 
-		if (o->write_mode != FIO_URING_CMD_WMODE_WRITE &&
-		    !td_write(td)) {
-			log_err("%s: 'readwrite=|rw=' has no write\n",
-					f->file_name);
-			td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
-			return 1;
-		}
+	/*
+	 * For extended logical block sizes we cannot use verify when
+	 * end to end data protection checks are enabled, as the PI
+	 * section of data buffer conflicts with verify.
+	 */
+	if (data->ms && data->pi_type && data->lba_ext &&
+	    td->o.verify != VERIFY_NONE) {
+		log_err("%s: for extended LBA, verify cannot be used when E2E "
+			"data protection is enabled\n", f->file_name);
+		td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
+		return 1;
+	}
+
+	if (o->write_mode != FIO_URING_CMD_WMODE_WRITE && !td_write(td)) {
+		log_err("%s: 'readwrite=|rw=' has no write\n", f->file_name);
+		td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
+		return 1;
 	}
-	if (!ld || !o->registerfiles)
-		return generic_open_file(td, f);
 
-	f->fd = ld->fds[f->engine_pos];
 	return 0;
 }
 
+static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct ioring_options *o = td->eo;
+
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		int ret;
+
+		ret = fio_ioring_open_nvme(td, f);
+		if (ret)
+			return ret;
+	}
+
+	return fio_ioring_open_file(td, f);
+}
+
 static int fio_ioring_close_file(struct thread_data *td, struct fio_file *f)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -1574,7 +1607,6 @@ static int fio_ioring_close_file(struct thread_data *td, struct fio_file *f)
 static int fio_ioring_cmd_close_file(struct thread_data *td,
 				     struct fio_file *f)
 {
-	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
 
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
@@ -1583,11 +1615,8 @@ static int fio_ioring_cmd_close_file(struct thread_data *td,
 		FILE_SET_ENG_DATA(f, NULL);
 		free(data);
 	}
-	if (!ld || !o->registerfiles)
-		return generic_close_file(td, f);
 
-	f->fd = -1;
-	return 0;
+	return fio_ioring_close_file(td, f);
 }
 
 static int fio_ioring_cmd_get_file_size(struct thread_data *td,
@@ -1704,7 +1733,7 @@ static struct ioengine_ops ioengine_uring_cmd = {
 					FIO_MULTI_RANGE_TRIM,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_cmd_post_init,
-	.io_u_init		= fio_ioring_io_u_init,
+	.io_u_init		= fio_ioring_io_u_cmd_init,
 	.io_u_free		= fio_ioring_io_u_free,
 	.prep			= fio_ioring_cmd_prep,
 	.queue			= fio_ioring_queue,
