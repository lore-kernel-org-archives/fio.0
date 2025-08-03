Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115C3258CFF
	for <fio@vger.kernel.org>; Sun,  3 Aug 2025 12:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754222415; cv=none; b=ZR6VJCHAgu7UFOix4Ea/I0fDZWHkakm3ULdPa0ZAQVcyzPny0uPCdXckvJcKF5oCrKmmu0Xw35t94wRxno54b4ihqJyI8qZMxvRigc85II2W6YXmLKD1uSmgAyyZrxoyxJCIbHmF3XGrGdCOYfDK2K8K/sNhbppiipFCCDE7MbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754222415; c=relaxed/simple;
	bh=W3gbDseagbx3B/tIkFkpJKo1HZQhhv9ctj0xb5TQJ64=;
	h=Subject:From:To:Message-Id:Date; b=nUJ8Cf1P1aEM92EsEGrS2A6FhesK6kXXSrOPHI2Y6PEuAwhzAh3HC8qPe/CZUosl19RYGF++ZxsMusdeeehIq+nzkfffXxETGUrnr+vxhe+qcQVdLwlnCPjQfeAXBaAWHjwezeW1Va4uAaUSZm7mTLEP0IzUr3jgFbnUIeP2evM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i9+AuMxH; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i9+AuMxH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=uxAWOSMlQ9XHPUz4QJ2fiWRk8A7nugPmeLfeu/foUbc=; b=i9+AuMxHbb7qcpFwLG5p2GBCyv
	ArnMn9Hyh5m/V92qo/+GwS4Dn/IsttuqsbCotMJvZHMS+wSfr/biS3zvUg7fy4yDTUfFc67J34y64
	5oFGURlhYBVWaLBRaEtlUQZWkapmU3qQpj1bpnl6ToWbp/VXlHLansT7fO6oMtNsV1QQ4SQigBL/c
	v/zhQeiBZ++mMpW5LG2+U1oLroDB0i53JAwgXKYQoBpoXVGr7W06+3hsCddA7VUTyzBsWNJX1XWwj
	E3GEpLo2l6L04ee414X9uNrl9q6smJX22ks2o/BNO8BW64m1KbO6P+Jn1sZO2c0A0q3NyqQcgUOq2
	keNhan1w==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uiXNn-0000000DgON-0b7y
	for fio@vger.kernel.org;
	Sun, 03 Aug 2025 12:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id E11A21BC0163; Sun,  3 Aug 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250803120001.E11A21BC0163@kernel.dk>
Date: Sun,  3 Aug 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 6e8c646c310219bf4026d74f02ce4652d27866ff:

  eta: convert skip_eta() to ANSI C declaration (2025-07-31 11:19:21 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ef740f7cbe47d5552677fb018b15b4ab1f1de4f4:

  t/io_uring_pi: test script for io_uring PI (2025-08-02 09:40:12 -0600)

----------------------------------------------------------------
Vincent Fu (7):
      engines/io_uring: store ioengine id in ioengine data
      engines/nvme: move inline functions from .c to .h file
      engines/nvme: refactor filling protection information
      engines/io_uring: simplify io_u_free
      engines/io_uring: fill in guard generation options at init time
      engines/io_uring: support r/w with metadata
      t/io_uring_pi: test script for io_uring PI

 engines/io_uring.c  | 315 +++++++++++++++++++++++++++++++++++-----
 engines/nvme.c      |  35 ++---
 engines/nvme.h      |  18 +++
 io_u.h              |   1 +
 os/linux/io_uring.h |  15 ++
 t/io_uring_pi.py    | 408 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 731 insertions(+), 61 deletions(-)
 create mode 100644 t/io_uring_pi.py

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 5bbcc97a..5d05f5c0 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -30,6 +30,71 @@
 
 #include <sys/stat.h>
 
+#ifndef IO_INTEGRITY_CHK_GUARD
+/* flags for integrity meta */
+#define IO_INTEGRITY_CHK_GUARD		(1U << 0) /* enforce guard check */
+#define IO_INTEGRITY_CHK_REFTAG		(1U << 1) /* enforce ref check */
+#define IO_INTEGRITY_CHK_APPTAG		(1U << 2) /* enforce app check */
+#endif /* IO_INTEGRITY_CHK_GUARD */
+
+#ifndef FS_IOC_GETLBMD_CAP
+/* Protection info capability flags */
+#define	LBMD_PI_CAP_INTEGRITY		(1 << 0)
+#define	LBMD_PI_CAP_REFTAG		(1 << 1)
+
+/* Checksum types for Protection Information */
+#define LBMD_PI_CSUM_NONE		0
+#define LBMD_PI_CSUM_IP			1
+#define LBMD_PI_CSUM_CRC16_T10DIF	2
+#define LBMD_PI_CSUM_CRC64_NVME		4
+
+/*
+ * Logical block metadata capability descriptor
+ * If the device does not support metadata, all the fields will be zero.
+ * Applications must check lbmd_flags to determine whether metadata is
+ * supported or not.
+ */
+struct logical_block_metadata_cap {
+	/* Bitmask of logical block metadata capability flags */
+	__u32	lbmd_flags;
+	/*
+	 * The amount of data described by each unit of logical block
+	 * metadata
+	 */
+	__u16	lbmd_interval;
+	/*
+	 * Size in bytes of the logical block metadata associated with each
+	 * interval
+	 */
+	__u8	lbmd_size;
+	/*
+	 * Size in bytes of the opaque block tag associated with each
+	 * interval
+	 */
+	__u8	lbmd_opaque_size;
+	/*
+	 * Offset in bytes of the opaque block tag within the logical block
+	 * metadata
+	 */
+	__u8	lbmd_opaque_offset;
+	/* Size in bytes of the T10 PI tuple associated with each interval */
+	__u8	lbmd_pi_size;
+	/* Offset in bytes of T10 PI tuple within the logical block metadata */
+	__u8	lbmd_pi_offset;
+	/* T10 PI guard tag type */
+	__u8	lbmd_guard_tag_type;
+	/* Size in bytes of the T10 PI application tag */
+	__u8	lbmd_app_tag_size;
+	/* Size in bytes of the T10 PI reference tag */
+	__u8	lbmd_ref_tag_size;
+	/* Size in bytes of the T10 PI storage tag */
+	__u8	lbmd_storage_tag_size;
+	__u8	pad;
+};
+
+#define FS_IOC_GETLBMD_CAP			_IOWR(0x15, 2, struct logical_block_metadata_cap)
+#endif /* FS_IOC_GETLBMD_CAP */
+
 enum uring_cmd_type {
 	FIO_URING_CMD_NVME = 1,
 };
@@ -73,6 +138,7 @@ struct ioring_data {
 
 	struct io_u **io_u_index;
 	char *md_buf;
+	char *pi_attr;
 
 	int *fds;
 
@@ -97,6 +163,10 @@ struct ioring_data {
 	struct nvme_dsm *dsm;
 	uint32_t cdw12_flags[DDIR_RWDIR_CNT];
 	uint8_t write_opcode;
+
+	bool is_uring_cmd_eng;
+
+	struct nvme_cmd_ext_io_opts ext_opts;
 };
 
 struct ioring_options {
@@ -136,12 +206,6 @@ static const int fixed_ddir_to_op[2] = {
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
@@ -400,6 +464,25 @@ static int io_uring_enter(struct ioring_data *ld, unsigned int to_submit,
 #define BLOCK_URING_CMD_DISCARD	_IO(0x12, 0)
 #endif
 
+static void fio_ioring_prep_md(struct thread_data *td, struct io_u *io_u)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct io_uring_attr_pi *pi_attr = io_u->pi_attr;
+	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
+	struct io_uring_sqe *sqe;
+
+	sqe = &ld->sqes[io_u->index];
+
+	sqe->attr_type_mask = IORING_RW_ATTR_FLAG_PI;
+	sqe->attr_ptr = (__u64)(uintptr_t)pi_attr;
+	pi_attr->addr = (__u64)(uintptr_t)io_u->mmap_data;
+
+	if (pi_attr->flags & IO_INTEGRITY_CHK_REFTAG) {
+		__u64 slba = get_slba(data, io_u->offset);
+		pi_attr->seed = (__u32)slba;
+	}
+}
+
 static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -442,6 +525,8 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 				sqe->len = 1;
 			}
 		}
+		if (o->md_per_io_size)
+			fio_ioring_prep_md(td, io_u);
 		sqe->rw_flags = 0;
 		if (!td->o.odirect && o->uncached)
 			sqe->rw_flags |= RWF_DONTCACHE;
@@ -568,9 +653,26 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 			ld->cdw12_flags[io_u->ddir]);
 }
 
+static void fio_ioring_validate_md(struct thread_data *td, struct io_u *io_u)
+{
+	struct nvme_data *data;
+	struct ioring_options *o = td->eo;
+	int ret;
+
+	data = FILE_ENG_DATA(io_u->file);
+	if (data->pi_type && (io_u->ddir == DDIR_READ) && !o->pi_act) {
+		ret = fio_nvme_pi_verify(data, io_u);
+		if (ret)
+			io_u->error = ret;
+	}
+
+	return;
+}
+
 static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 {
 	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
 	struct io_uring_cqe *cqe;
 	struct io_u *io_u;
 	unsigned index;
@@ -596,8 +698,13 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 			io_u->error = -cqe->res;
 		else
 			io_u->resid = io_u->xfer_buflen - cqe->res;
+
+		return io_u;
 	}
 
+	if (o->md_per_io_size)
+		fio_ioring_validate_md(td, io_u);
+
 	return io_u;
 }
 
@@ -742,11 +849,8 @@ static inline void fio_ioring_cmd_nvme_pi(struct thread_data *td,
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
@@ -754,15 +858,18 @@ static inline void fio_ioring_cmd_nvme_pi(struct thread_data *td,
 	sqe = &ld->sqes[(io_u->index) << 1];
 	cmd = (struct nvme_uring_cmd *)sqe->cmd;
 
-	if (data->pi_type) {
-		if (o->pi_act)
-			ext_opts.io_flags |= NVME_IO_PRINFO_PRACT;
-		ext_opts.io_flags |= o->prchk;
-		ext_opts.apptag = o->apptag;
-		ext_opts.apptag_mask = o->apptag_mask;
-	}
+	fio_nvme_pi_fill(cmd, io_u, &ld->ext_opts);
+}
+
+static inline void fio_ioring_setup_pi(struct thread_data *td,
+				      struct io_u *io_u)
+{
+	struct ioring_data *ld = td->io_ops_data;
+
+	if (io_u->ddir == DDIR_TRIM)
+		return;
 
-	fio_nvme_pi_fill(cmd, io_u, &ext_opts);
+	fio_nvme_generate_guard(io_u, &ld->ext_opts);
 }
 
 static inline void fio_ioring_cmdprio_prep(struct thread_data *td,
@@ -804,8 +911,10 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (ld->cmdprio.mode != CMDPRIO_MODE_NONE)
 		fio_ioring_cmdprio_prep(td, io_u);
 
-	if (o->cmd_type == FIO_URING_CMD_NVME && is_uring_cmd_eng(td))
+	if (o->cmd_type == FIO_URING_CMD_NVME && ld->is_uring_cmd_eng)
 		fio_ioring_cmd_nvme_pi(td, io_u);
+	else if (o->md_per_io_size)
+		fio_ioring_setup_pi(td, io_u);
 
 	tail = *ring->tail;
 	ring->array[tail & ld->sq_ring_mask] = io_u->index;
@@ -925,6 +1034,7 @@ static void fio_ioring_cleanup(struct thread_data *td)
 		fio_cmdprio_cleanup(&ld->cmdprio);
 		free(ld->io_u_index);
 		free(ld->md_buf);
+		free(ld->pi_attr);
 		free(ld->iovecs);
 		free(ld->fds);
 		free(ld->dsm);
@@ -1359,6 +1469,7 @@ static int fio_ioring_init(struct thread_data *td)
 	unsigned int dsm_size;
 	unsigned long long md_size;
 	int ret, i;
+	struct nvme_cmd_ext_io_opts *ext_opts;
 
 	/* sqthread submission requires registered files */
 	if (o->sqpoll_thread)
@@ -1372,6 +1483,8 @@ static int fio_ioring_init(struct thread_data *td)
 
 	ld = calloc(1, sizeof(*ld));
 
+	ld->is_uring_cmd_eng = (td->io_ops->prep == fio_ioring_cmd_prep);
+
 	/*
 	 * The internal io_uring queue depth must be a power-of-2, as that's
 	 * how the ring interface works. So round that up, in case the user
@@ -1383,12 +1496,20 @@ static int fio_ioring_init(struct thread_data *td)
 	/* io_u index */
 	ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
 
+	if (!ld->is_uring_cmd_eng && o->md_per_io_size) {
+		if (o->apptag_mask != 0xffff) {
+			log_err("fio: io_uring with metadata requires an apptag_mask of 0xffff\n");
+			free(ld);
+			return 1;
+		}
+	}
+
 	/*
-	 * metadata buffer for nvme command.
+	 * metadata buffer
 	 * We are only supporting iomem=malloc / mem=malloc as of now.
 	 */
-	if (o->cmd_type == FIO_URING_CMD_NVME && o->md_per_io_size &&
-	    is_uring_cmd_eng(td)) {
+	if (o->md_per_io_size && (!ld->is_uring_cmd_eng ||
+	    (ld->is_uring_cmd_eng && o->cmd_type == FIO_URING_CMD_NVME))) {
 		md_size = (unsigned long long) o->md_per_io_size
 				* (unsigned long long) td->o.iodepth;
 		md_size += page_mask + td->o.mem_align;
@@ -1399,8 +1520,24 @@ static int fio_ioring_init(struct thread_data *td)
 			free(ld);
 			return 1;
 		}
+
+		if (!ld->is_uring_cmd_eng) {
+			ld->pi_attr = calloc(ld->iodepth, sizeof(struct io_uring_attr_pi));
+			if (!ld->pi_attr) {
+				free(ld->md_buf);
+				free(ld);
+				return 1;
+			}
+		}
+
 	}
 	parse_prchk_flags(o);
+	ext_opts = &ld->ext_opts;
+	if (o->pi_act)
+		ext_opts->io_flags |= NVME_IO_PRINFO_PRACT;
+	ext_opts->io_flags |= o->prchk;
+	ext_opts->apptag = o->apptag;
+	ext_opts->apptag_mask = o->apptag_mask;
 
 	ld->iovecs = calloc(ld->iodepth, sizeof(struct iovec));
 
@@ -1417,7 +1554,7 @@ static int fio_ioring_init(struct thread_data *td)
 	 * in zbd mode where trim means zone reset.
 	 */
 	if (td_trim(td) && td->o.zone_mode == ZONE_MODE_ZBD &&
-	    is_uring_cmd_eng(td)) {
+	    ld->is_uring_cmd_eng) {
 		td->io_ops->flags |= FIO_ASYNCIO_SYNC_TRIM;
 	} else {
 		dsm_size = sizeof(*ld->dsm);
@@ -1431,32 +1568,43 @@ static int fio_ioring_init(struct thread_data *td)
 		}
 	}
 
-	if (is_uring_cmd_eng(td))
+	if (ld->is_uring_cmd_eng)
 		return fio_ioring_cmd_init(td, ld);
 	return 0;
 }
 
 static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
-{
-	struct ioring_data *ld = td->io_ops_data;
-
-	ld->io_u_index[io_u->index] = io_u;
-	return 0;
-}
-
-static int fio_ioring_io_u_cmd_init(struct thread_data *td, struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
 	struct nvme_pi_data *pi_data;
-	char *p;
+	char *p, *q;
 
-	fio_ioring_io_u_init(td, io_u);
+	ld->io_u_index[io_u->index] = io_u;
 
 	p = PTR_ALIGN(ld->md_buf, page_mask) + td->o.mem_align;
 	p += o->md_per_io_size * io_u->index;
 	io_u->mmap_data = p;
 
+	if (ld->pi_attr) {
+		struct io_uring_attr_pi *pi_attr;
+
+		q = ld->pi_attr;
+		q += (sizeof(struct io_uring_attr_pi) * io_u->index);
+		io_u->pi_attr = q;
+
+		pi_attr = io_u->pi_attr;
+		pi_attr->len = o->md_per_io_size;
+		pi_attr->app_tag = o->apptag;
+		pi_attr->flags = 0;
+		if (strstr(o->pi_chk, "GUARD") != NULL)
+			pi_attr->flags |= IO_INTEGRITY_CHK_GUARD;
+		if (strstr(o->pi_chk, "REFTAG") != NULL)
+			pi_attr->flags |= IO_INTEGRITY_CHK_REFTAG;
+		if (strstr(o->pi_chk, "APPTAG") != NULL)
+			pi_attr->flags |= IO_INTEGRITY_CHK_APPTAG;
+	}
+
 	if (!o->pi_act) {
 		pi_data = calloc(1, sizeof(*pi_data));
 		pi_data->io_flags |= o->prchk;
@@ -1470,14 +1618,91 @@ static int fio_ioring_io_u_cmd_init(struct thread_data *td, struct io_u *io_u)
 
 static void fio_ioring_io_u_free(struct thread_data *td, struct io_u *io_u)
 {
-	struct ioring_options *o = td->eo;
+	struct nvme_pi *pi = io_u->engine_data;
 
-	if (o->cmd_type == FIO_URING_CMD_NVME) {
-		struct nvme_pi *pi = io_u->engine_data;
+	free(pi);
+	io_u->engine_data = NULL;
+}
+
+static int fio_get_pi_info(struct fio_file *f, struct nvme_data *data)
+{
+	struct logical_block_metadata_cap md_cap;
+	int ret;
+	int fd, err = 0;
+
+	fd = open(f->file_name, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	ret = ioctl(fd, FS_IOC_GETLBMD_CAP, &md_cap);
+	if (ret < 0) {
+		err = -errno;
+		log_err("%s: failed to query protection information capabilities; error %d\n", f->file_name, errno);
+		goto out;
+	}
+
+	if (!(md_cap.lbmd_flags & LBMD_PI_CAP_INTEGRITY)) {
+		log_err("%s: Protection information not supported\n", f->file_name);
+		err = -ENOTSUP;
+		goto out;
+	}
+
+	/* Currently we don't support storage tags */
+	if (md_cap.lbmd_storage_tag_size) {
+		log_err("%s: Storage tag not supported\n", f->file_name);
+		err = -ENOTSUP;
+		goto out;
+	}
 
-		free(pi);
-		io_u->engine_data = NULL;
+	data->lba_size = md_cap.lbmd_interval;
+	data->lba_shift = ilog2(data->lba_size);
+	data->ms = md_cap.lbmd_size;
+	data->pi_size = md_cap.lbmd_pi_size;
+	data->pi_loc = !(md_cap.lbmd_pi_offset);
+
+	/* Assume Type 1 PI if reference tags supported */
+	if (md_cap.lbmd_flags & LBMD_PI_CAP_REFTAG)
+		data->pi_type = NVME_NS_DPS_PI_TYPE1;
+	else
+		data->pi_type = NVME_NS_DPS_PI_TYPE3;
+
+	switch (md_cap.lbmd_guard_tag_type) {
+	case LBMD_PI_CSUM_CRC16_T10DIF:
+		data->guard_type = NVME_NVM_NS_16B_GUARD;
+		break;
+	case LBMD_PI_CSUM_CRC64_NVME:
+		data->guard_type = NVME_NVM_NS_64B_GUARD;
+		break;
+	default:
+		log_err("%s: unsupported checksum type %d\n", f->file_name,
+				md_cap.lbmd_guard_tag_type);
+		err = -ENOTSUP;
+		goto out;
+	}
+
+out:
+	close(fd);
+	return err;
+}
+
+static inline int fio_ioring_open_file_md(struct thread_data *td, struct fio_file *f)
+{
+	int ret = 0;
+	struct nvme_data *data = NULL;
+
+	data = FILE_ENG_DATA(f);
+	if (data == NULL) {
+		data = calloc(1, sizeof(struct nvme_data));
+		ret = fio_get_pi_info(f, data);
+		if (ret) {
+			free(data);
+			return ret;
+		}
+
+		FILE_SET_ENG_DATA(f, data);
 	}
+
+	return ret;
 }
 
 static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
@@ -1485,6 +1710,17 @@ static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
 
+	if (o->md_per_io_size) {
+		/*
+		 * This will be a no-op when called by the io_uring_cmd
+		 * ioengine because engine data has already been collected by
+		 * the time this call is made
+		 */
+		int ret = fio_ioring_open_file_md(td, f);
+		if (ret)
+			return ret;
+	}
+
 	if (!ld || !o->registerfiles)
 		return generic_open_file(td, f);
 
@@ -1712,6 +1948,7 @@ static struct ioengine_ops ioengine_uring = {
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
+	.io_u_free		= fio_ioring_io_u_free,
 	.prep			= fio_ioring_prep,
 	.queue			= fio_ioring_queue,
 	.commit			= fio_ioring_commit,
@@ -1733,7 +1970,7 @@ static struct ioengine_ops ioengine_uring_cmd = {
 					FIO_MULTI_RANGE_TRIM,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_cmd_post_init,
-	.io_u_init		= fio_ioring_io_u_cmd_init,
+	.io_u_init		= fio_ioring_io_u_init,
 	.io_u_free		= fio_ioring_io_u_free,
 	.prep			= fio_ioring_cmd_prep,
 	.queue			= fio_ioring_queue,
diff --git a/engines/nvme.c b/engines/nvme.c
index 37a31e2f..4b3d3860 100644
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
@@ -421,14 +405,9 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
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
@@ -436,6 +415,18 @@ void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
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
index 60b38d7f..4371eb5b 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -438,6 +438,8 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		      struct nvme_cmd_ext_io_opts *opts);
 
+void fio_nvme_generate_guard(struct io_u *io_u, struct nvme_cmd_ext_io_opts *opts);
+
 int fio_nvme_pi_verify(struct nvme_data *data, struct io_u *io_u);
 
 int fio_nvme_get_zoned_model(struct thread_data *td, struct fio_file *f,
@@ -476,4 +478,20 @@ static inline bool fio_nvme_pi_ref_escape(__u8 *reftag)
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
diff --git a/io_u.h b/io_u.h
index 178c1229..2d20a2b2 100644
--- a/io_u.h
+++ b/io_u.h
@@ -145,6 +145,7 @@ struct io_u {
 #endif
 		void *mmap_data;
 	};
+	void *pi_attr;
 };
 
 /*
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index b3876381..7b099902 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -70,6 +70,10 @@ struct io_uring_sqe {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		struct {
+			__u64	attr_ptr; /* pointer to attribute information */
+			__u64	attr_type_mask; /* bit mask of attributes */
+		};
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
 		 * this field is used for 80 bytes of arbitrary command data
@@ -78,6 +82,17 @@ struct io_uring_sqe {
 	};
 };
 
+/* sqe->attr_type_mask flags */
+#define IORING_RW_ATTR_FLAG_PI	(1U << 0)
+/* PI attribute information */
+struct io_uring_attr_pi {
+		__u16	flags;
+		__u16	app_tag;
+		__u32	len;
+		__u64	addr;
+		__u64	seed;
+		__u64	rsvd;
+};
 enum {
 	IOSQE_FIXED_FILE_BIT,
 	IOSQE_IO_DRAIN_BIT,
diff --git a/t/io_uring_pi.py b/t/io_uring_pi.py
new file mode 100644
index 00000000..bd92edfd
--- /dev/null
+++ b/t/io_uring_pi.py
@@ -0,0 +1,408 @@
+#!/usr/bin/env python3
+
+"""
+# io_uring_pi.py
+#
+# Test metadata support using the io_uring ioengine.
+#
+# USAGE
+# See python3 io_uring_pi.py --help
+#
+# EXAMPLES (THIS IS A DESTRUCTIVE TEST!!)
+# python3 t/io_uring_pi.py --dut /dev/nvme1n1 -f ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+#
+"""
+
+import os
+import sys
+import json
+import time
+import locale
+import logging
+import argparse
+import itertools
+import subprocess
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_NONZERO
+
+
+NUMBER_IOS = 8192
+BS_LOW = 1
+BS_HIGH = 16
+
+class DifDixTest(FioJobCmdTest):
+    """
+    NVMe DIF/DIX test class.
+    """
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        fio_args = [
+            "--name=io_uring_pi",
+            "--ioengine=io_uring",
+            "--direct=1",
+            f"--filename={self.fio_opts['filename']}",
+            f"--rw={self.fio_opts['rw']}",
+            f"--bsrange={self.fio_opts['bsrange']}",
+            f"--output={os.path.basename(self.filenames['output'])}",
+            f"--md_per_io_size={self.fio_opts['md_per_io_size']}",
+            "--pi_act=0",
+            f"--pi_chk={self.fio_opts['pi_chk']}",
+            f"--apptag={self.fio_opts['apptag']}",
+            f"--apptag_mask={self.fio_opts['apptag_mask']}",
+        ]
+        for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
+                    'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
+                    'time_based', 'runtime', 'verify', 'io_size', 'offset', 'number_ios',
+                    'output-format']:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+
+        super().setup(fio_args)
+
+
+TEST_LIST = [
+#
+# Write data with pi_act=0 and then read the data back
+#
+    {
+        # Write workload with variable IO sizes
+        # pi_act=0
+        "test_id": 101,
+        "fio_opts": {
+            "rw": 'write',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            "pi_act": 0,
+            },
+        "pi_chk": "GUARD,REFTAG,APPTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with fixed small IO size
+        # pi_act=0
+        "test_id": 102,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            "pi_act": 0,
+            },
+        "pi_chk": "GUARD,REFTAG,APPTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_LOW,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO size
+        # pi_act=0
+        "test_id": 103,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            "pi_act": 0,
+            },
+        "pi_chk": "GUARD,REFTAG,APPTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO size
+        # trigger apptag mismatch error
+        # pi_act=0
+        "test_id": 104,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "apptag": "0xA888",
+            "apptag_mask": "0xFFFF",
+            "pi_act": 0,
+            },
+        "pi_chk": "GUARD,REFTAG,APPTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "success": SUCCESS_NONZERO,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO size
+        # fails because apptag mask must be 0xFFFF
+        # pi_act=0
+        "test_id": 105,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "apptag": "0xF888",
+            "apptag_mask": "0x0FFF",
+            "pi_act": 0,
+            },
+        "pi_chk": "GUARD,REFTAG,APPTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "success": SUCCESS_NONZERO,
+        "test_class": DifDixTest,
+    },
+]
+
+
+def get_lbafs(args):
+    """
+    Determine which LBA formats to use. Use either the ones specified on the
+    command line or if none are specified query the device and use all lba
+    formats with metadata.
+    """
+    lbaf_list = []
+    id_ns_cmd = f"sudo nvme id-ns --output-format=json {args.dut}".split(' ')
+    id_ns_output = subprocess.check_output(id_ns_cmd)
+    lbafs = json.loads(id_ns_output)['lbafs']
+    if args.lbaf:
+        for lbaf in args.lbaf:
+            lbaf_list.append({'lbaf': lbaf, 'ds': 2 ** lbafs[lbaf]['ds'],
+                              'ms': lbafs[lbaf]['ms'], })
+            if lbafs[lbaf]['ms'] == 0:
+                print(f'Error: lbaf {lbaf} has metadata size zero')
+                sys.exit(1)
+    else:
+        for lbaf_num, lbaf in enumerate(lbafs):
+            if lbaf['ms'] != 0:
+                lbaf_list.append({'lbaf': lbaf_num, 'ds': 2 ** lbaf['ds'],
+                                  'ms': lbaf['ms'], })
+
+    return lbaf_list
+
+
+def get_guard_pi(lbaf_list, args):
+    """
+    Find out how many bits of guard protection information are associated with
+    each lbaf to be used. If this is not available assume 16-bit guard pi.
+    Also record the bytes of protection information associated with the number
+    of guard PI bits.
+    """
+    nvm_id_ns_cmd = f"sudo nvme nvm-id-ns --output-format=json {args.dut}".split(' ')
+    try:
+        nvm_id_ns_output = subprocess.check_output(nvm_id_ns_cmd)
+    except subprocess.CalledProcessError:
+        print(f"Non-zero return code from {' '.join(nvm_id_ns_cmd)}; " \
+                "assuming all lbafs use 16b Guard Protection Information")
+        for lbaf in lbaf_list:
+            lbaf['guard_pi_bits'] = 16
+    else:
+        elbafs = json.loads(nvm_id_ns_output)['elbafs']
+        for elbaf_num, elbaf in enumerate(elbafs):
+            for lbaf in lbaf_list:
+                if lbaf['lbaf'] == elbaf_num:
+                    lbaf['guard_pi_bits'] = 16 << elbaf['pif']
+
+    # For 16b Guard Protection Information, the PI requires 8 bytes
+    # For 32b and 64b Guard PI, the PI requires 16 bytes
+    for lbaf in lbaf_list:
+        if lbaf['guard_pi_bits'] == 16:
+            lbaf['pi_bytes'] = 8
+        else:
+            lbaf['pi_bytes'] = 16
+
+
+def get_capabilities(args):
+    """
+    Determine what end-to-end data protection features the device supports.
+    """
+    caps = { 'pil': [], 'pitype': [], 'elba': [] }
+    id_ns_cmd = f"sudo nvme id-ns --output-format=json {args.dut}".split(' ')
+    id_ns_output = subprocess.check_output(id_ns_cmd)
+    id_ns_json = json.loads(id_ns_output)
+
+    mc = id_ns_json['mc']
+    if mc & 1:
+        caps['elba'].append(1)
+    if mc & 2:
+        caps['elba'].append(0)
+
+    dpc = id_ns_json['dpc']
+    if dpc & 1:
+        caps['pitype'].append(1)
+    if dpc & 2:
+        caps['pitype'].append(2)
+    if dpc & 4:
+        caps['pitype'].append(3)
+    if dpc & 8:
+        caps['pil'].append(1)
+    if dpc & 16:
+        caps['pil'].append(0)
+
+    for _, value in caps.items():
+        if len(value) == 0:
+            logging.error("One or more end-to-end data protection features unsupported: %s", caps)
+            sys.exit(-1)
+
+    return caps
+
+
+def format_device(args, lbaf, pitype, pil, elba):
+    """
+    Format device using specified lba format with specified pitype, pil, and
+    elba values.
+    """
+
+    format_cmd = f"sudo nvme format {args.dut} --lbaf={lbaf['lbaf']} " \
+                 f"--pi={pitype} --pil={pil} --ms={elba} --force"
+    logging.debug("Format command: %s", format_cmd)
+    format_cmd = format_cmd.split(' ')
+    format_cmd_result = subprocess.run(format_cmd, capture_output=True, check=False,
+                                       encoding=locale.getpreferredencoding())
+
+    # Sometimes nvme-cli may format the device successfully but fail to
+    # rescan the namespaces after the format. Continue if this happens but
+    # abort if some other error occurs.
+    if format_cmd_result.returncode != 0:
+        if 'failed to rescan namespaces' not in format_cmd_result.stderr \
+                or 'Success formatting namespace' not in format_cmd_result.stdout:
+            logging.error(format_cmd_result.stdout)
+            logging.error(format_cmd_result.stderr)
+            print("Unable to format device; skipping this configuration")
+            return False
+
+    logging.debug(format_cmd_result.stdout)
+    return True
+
+
+def parse_args():
+    """Parse command-line arguments."""
+
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-d', '--debug', help='Enable debug messages', action='store_true')
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    parser.add_argument('--dut', help='target device to test '
+                        '(e.g., /dev/nvme1n1). WARNING: THIS IS A DESTRUCTIVE TEST', required=True)
+    parser.add_argument('-l', '--lbaf', nargs='+', type=int,
+                        help='list of lba formats to test')
+    args = parser.parse_args()
+
+    return args
+
+
+def difdix_test(test_env, args, lbaf, pitype):
+    """
+    Adjust test arguments based on values of lbaf, and pitype.  Then run
+    the tests.
+    """
+    for test in TEST_LIST:
+        test['force_skip'] = False
+
+        blocksize = lbaf['ds']
+        # Set fio blocksize parameter at runtime
+        test['fio_opts']['md_per_io_size'] = lbaf['ms'] * test['bs_high']
+
+        test['fio_opts']['bsrange'] = f"{blocksize * test['bs_low']}-{blocksize * test['bs_high']}"
+
+        # Set fio pi_chk parameter at runtime. If the device is formatted
+        # with Type 3 protection information, this means that the reference
+        # tag is not checked and I/O commands may throw an error if they
+        # are submitted with the REFTAG bit set in pi_chk. Make sure fio
+        # does not set pi_chk's REFTAG bit if the device is formatted with
+        # Type 3 PI.
+        if 'pi_chk' in test:
+            if pitype == 3 and 'REFTAG' in test['pi_chk']:
+                test['fio_opts']['pi_chk'] = test['pi_chk'].replace('REFTAG','')
+                logging.debug("Type 3 PI: dropping REFTAG bit")
+            else:
+                test['fio_opts']['pi_chk'] = test['pi_chk']
+
+        logging.debug("Test %d: pi_act=%d, bsrange=%s, md_per_io_size=%d", test['test_id'],
+                      test['fio_opts']['pi_act'], test['fio_opts']['bsrange'],
+                      test['fio_opts']['md_per_io_size'])
+
+    return run_fio_tests(TEST_LIST, test_env, args)
+
+
+def main():
+    args = parse_args()
+
+    if args.debug:
+        logging.basicConfig(level=logging.DEBUG)
+    else:
+        logging.basicConfig(level=logging.INFO)
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"io_uring_pi-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = os.path.join(os.path.dirname(__file__), '../fio')
+    print(f"fio path is {fio_path}")
+
+    lbaf_list = get_lbafs(args)
+    get_guard_pi(lbaf_list, args)
+    caps = get_capabilities(args)
+    print("Device capabilities:", caps)
+
+    for test in TEST_LIST:
+        test['fio_opts']['filename'] = args.dut
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'io_uring_pi',
+              }
+
+    total = { 'passed':  0, 'failed': 0, 'skipped': 0 }
+
+    try:
+        for lbaf, pil, pitype in itertools.product(lbaf_list, caps['pil'], caps['pitype']):
+            if lbaf['ms'] == 0:
+                continue
+
+            print("\n")
+            print("-" * 120)
+            print(f"lbaf: {lbaf}, pil: {pil}, pitype: {pitype}")
+            print("-" * 120)
+
+            if not format_device(args, lbaf, pitype, pil, 0):
+                print("Formatting failed")
+                continue
+
+            test_env['artifact_root'] = \
+                os.path.join(artifact_root, f"lbaf{lbaf['lbaf']}pil{pil}pitype{pitype}")
+            os.mkdir(test_env['artifact_root'])
+
+            passed, failed, skipped = difdix_test(test_env, args, lbaf, pitype)
+
+            total['passed'] += passed
+            total['failed'] += failed
+            total['skipped'] += skipped
+
+    except KeyboardInterrupt:
+        pass
+
+    print(f"\n\n{total['passed']} test(s) passed, {total['failed']} failed, " \
+            f"{total['skipped']} skipped")
+    sys.exit(total['failed'])
+
+
+if __name__ == '__main__':
+    main()
