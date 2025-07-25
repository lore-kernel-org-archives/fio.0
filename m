Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C372F0036
	for <fio@vger.kernel.org>; Fri, 25 Jul 2025 17:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753466343; cv=none; b=lssoHUkMeyshdiEpUjPi8LlBdoE36kAqDdDXpvsydGD/E4lV55H9WP+6KEGDS57GfJCjvloTPhoJMVJN3t+CzBx1BhQ6ZHV+JFJOj+kAS5wESd610VLVf0mxlvHQbVabVv1sYXIlRM4X9zOAgQXSo57AZVq+ra3qKMM2HPoo4gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753466343; c=relaxed/simple;
	bh=uCotDpgi8cwi0nY722SLz0h8ag0J8w75aN54Xc71AnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7HyvwCB9GhYuY5ASepDjWOe7u8ewRfLbzuionjZ+XSbmYcgH25GrL96NYR1OiIUiLYg7/zO5yv2IYKcbG9rcWPlyCNzCPGJkSPRZpXQivFZU82aJkzf/kcWzjaLC7GusXWtFkSAt3XIUfVKn+wo66AKtSMmSA15MExA3URTM1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LMtXlxwu; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LMtXlxwu"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6fad3400ea3so17598206d6.0
        for <fio@vger.kernel.org>; Fri, 25 Jul 2025 10:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753466341; x=1754071141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6r3pwUiHA9AdzsC4e+Ojkp1I2QJGuNriTuKTkjK17b0=;
        b=LMtXlxwuUVZWAT7aRA35VGQr9DbmOWXeUmFCAFQ/JC60ORsSRrRcS6EEsb/4or3yvS
         PDc2XeGZEM5e1sIVEXeKyN5kzS+wD024XzjWjj3PovIu35AVZfDMoeCMHEBZvkU5aHHw
         0400QNXgziGQ+eNsHk1ZrzU7IBBvqtsfW6cVsfir3wcBa9vJ5YjP24wyJL5Gfgq7oQqb
         44NOtUOwSyPXTXt7HaS7AVW2//kQZlFzyfAdbSWDHAY2Zrg/JEuVqmGBoByw7ulmQLRP
         KmibbqzD+7fHWRGrath+fZ6P7RSdwCa/AmwEZq6HbstIkqs1uZx+4Bz/qlEXDUb7i3U9
         lcOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753466341; x=1754071141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6r3pwUiHA9AdzsC4e+Ojkp1I2QJGuNriTuKTkjK17b0=;
        b=E4SjA4QB1EkPqHoFxmbPR2UHek+zNOCgHY/1X5V4yDm4MdPGL3srHcLbROzv4uLUiU
         l5F+xXk8XfNQQ4SqY8y8ARr5+/e3Td35M3dDNWMnwgG+GF+ZHKV368AKUAcETN4XE5WU
         nPX24unVZvO6OTJ/dzXzSFrbpsNuRTqw+XlIXN8v4CGBXJbBTdjvfj4Kc6lyxTUXinYf
         EPk+QXkLRwt0VTVFazFpHj08JETlb/B9JstPET8TWCWQ+faGPHZ7gH0cI2tsTjxmLDf1
         1Mq9IGNgrsb/gTJyR12MMT0D9rB3PXelj2v9sY+bir46KRvIW7Vj+b0fS9WlldBzKz5P
         dnHw==
X-Forwarded-Encrypted: i=1; AJvYcCXRWBlJWkSbiYlt60hhUPuJ3t42PSKrrC/uhwUYF/7gSH306+/FRpr3G96qsI2Ga45AkVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzV817updSmDtUrc3veyBU+ioxXI4ORg56U4uEM/gog6JXZI+Qm
	6sDfEEhaOMyUkVY5NiUkzinXPOFBhCdxGLErtR9L61hOmL5GBJE/HVhD
X-Gm-Gg: ASbGncvNgO9tQZ6e3tvhOV5YE1zchBqzrGa2o49nceD9oLgtfq8rWARR/7svWJYRfKC
	h2MTnbiuxnT60pJdTCahMejt2yvj0N7EqZn59FXYtxkBzm+aY7HOFUi1TuoNWnLJP8eculS2QNB
	XyV1qD+3Fmgs4davEHgzGpKqt7zrJ1g9pcPmRRULX92V49BY5UFHflp68JgmXmlledAhA/xJ6W1
	lbuHT51OlhJPqzskKV0RPIKzXU+eNcrzrpnjjYHYwRW+NTylDHfnBAoj0PrbW8/KD0N35B8JMqb
	SiXNHD0xSM0Qr53qU8m7F127MQeIKMLA25VHYqvR9CaemHvB2f2rCpiuIDdNKJf0y5q0+LqW2cE
	ttVjdExOFx0z9fSJVF8wG+J7EI0j+71YckS8l3qfxIQL2SqzIWIgTugUOMWRAVrX43Y16AptCYU
	xzlSaWbK6yyh9xYp9iicI=
X-Google-Smtp-Source: AGHT+IFOTF3bGaQ5iPXKAkIB0zA46fHKkFCbZGudsjgnAcUPiyeMZhDtOvCpAbFr7kckwIw4RWpSew==
X-Received: by 2002:a05:6214:485:b0:702:c4d8:ec02 with SMTP id 6a1803df08f44-707205ea833mr40436666d6.40.1753466340342;
        Fri, 25 Jul 2025 10:59:00 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-70729c8ab8asm2839186d6.94.2025.07.25.10.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 10:58:59 -0700 (PDT)
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
Subject: [PATCH 6/7] engines/io_uring: support r/w with metadata
Date: Fri, 25 Jul 2025 13:58:02 -0400
Message-ID: <20250725175808.2632-7-vincent.fu@samsung.com>
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

Use the new IOCTL to query block devices for metadata support. Then use
the new io_uring capability to send read and write commands with
metadata.

This reuses much of the existing infrastructure for io_uring_cmd
protection information support.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 engines/io_uring.c  | 273 +++++++++++++++++++++++++++++++++++++++++---
 io_u.h              |   1 +
 os/linux/io_uring.h |  15 +++
 3 files changed, 275 insertions(+), 14 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 4c72298d..e51e2ff3 100644
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
 
@@ -398,6 +464,25 @@ static int io_uring_enter(struct ioring_data *ld, unsigned int to_submit,
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
@@ -440,6 +525,8 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 				sqe->len = 1;
 			}
 		}
+		if (o->md_per_io_size)
+			fio_ioring_prep_md(td, io_u);
 		sqe->rw_flags = 0;
 		if (!td->o.odirect && o->uncached)
 			sqe->rw_flags |= RWF_DONTCACHE;
@@ -566,9 +653,26 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
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
@@ -594,8 +698,13 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
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
 
@@ -752,6 +861,17 @@ static inline void fio_ioring_cmd_nvme_pi(struct thread_data *td,
 	fio_nvme_pi_fill(cmd, io_u, &ld->ext_opts);
 }
 
+static inline void fio_ioring_setup_pi(struct thread_data *td,
+				      struct io_u *io_u)
+{
+	struct ioring_data *ld = td->io_ops_data;
+
+	if (io_u->ddir == DDIR_TRIM)
+		return;
+
+	fio_nvme_generate_guard(io_u, &ld->ext_opts);
+}
+
 static inline void fio_ioring_cmdprio_prep(struct thread_data *td,
 					   struct io_u *io_u)
 {
@@ -793,6 +913,8 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 
 	if (o->cmd_type == FIO_URING_CMD_NVME && ld->is_uring_cmd_eng)
 		fio_ioring_cmd_nvme_pi(td, io_u);
+	else if (o->md_per_io_size)
+		fio_ioring_setup_pi(td, io_u);
 
 	tail = *ring->tail;
 	ring->array[tail & ld->sq_ring_mask] = io_u->index;
@@ -912,6 +1034,7 @@ static void fio_ioring_cleanup(struct thread_data *td)
 		fio_cmdprio_cleanup(&ld->cmdprio);
 		free(ld->io_u_index);
 		free(ld->md_buf);
+		free(ld->pi_attr);
 		free(ld->iovecs);
 		free(ld->fds);
 		free(ld->dsm);
@@ -1373,12 +1496,20 @@ static int fio_ioring_init(struct thread_data *td)
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
-	    ld->is_uring_cmd_eng) {
+	if (o->md_per_io_size && (!ld->is_uring_cmd_eng ||
+	    (ld->is_uring_cmd_eng && o->cmd_type == FIO_URING_CMD_NVME))) {
 		md_size = (unsigned long long) o->md_per_io_size
 				* (unsigned long long) td->o.iodepth;
 		md_size += page_mask + td->o.mem_align;
@@ -1389,6 +1520,16 @@ static int fio_ioring_init(struct thread_data *td)
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
 	ext_opts = &ld->ext_opts;
@@ -1433,26 +1574,37 @@ static int fio_ioring_init(struct thread_data *td)
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
@@ -1472,11 +1624,103 @@ static void fio_ioring_io_u_free(struct thread_data *td, struct io_u *io_u)
 	io_u->engine_data = NULL;
 }
 
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
+
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
+	}
+
+	return ret;
+}
+
 static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
 {
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
 
@@ -1704,6 +1948,7 @@ static struct ioengine_ops ioengine_uring = {
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
+	.io_u_free		= fio_ioring_io_u_free,
 	.prep			= fio_ioring_prep,
 	.queue			= fio_ioring_queue,
 	.commit			= fio_ioring_commit,
@@ -1725,7 +1970,7 @@ static struct ioengine_ops ioengine_uring_cmd = {
 					FIO_MULTI_RANGE_TRIM,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_cmd_post_init,
-	.io_u_init		= fio_ioring_io_u_cmd_init,
+	.io_u_init		= fio_ioring_io_u_init,
 	.io_u_free		= fio_ioring_io_u_free,
 	.prep			= fio_ioring_cmd_prep,
 	.queue			= fio_ioring_queue,
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
-- 
2.47.2

