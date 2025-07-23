Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24A3170A26
	for <fio@vger.kernel.org>; Wed, 23 Jul 2025 17:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753290356; cv=none; b=H7ws4bIDTlymWFaEmPCBnu7+XfQ2RhZpf6oPQLvugPzHD8EbKu4bVFFYF9+ZllyWwHljYmKP6EidVRnjJPLY1/vV8z53o4bJqhjR6uwoxTXdMcRilrUEf/sAqQtJ/f1oJ+gDR832jzPGekSFMmG6xn94KxCw9/yyhzKLszU7uME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753290356; c=relaxed/simple;
	bh=O+KFKDrPUIF2UbCV1mUBLUnUsDlSPejmSaUkoslRqnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxU2UKb3Pwzc6vYBOesT/LEbJiExg7wzWV8Ml4Wfge5G7+4soUYvsE582XCsHzj5tpiTkrW8skD7U/JKIlYJR+zNGm2rFlF+E8j3M5in2YuYrv1Hvsnbx5mrvlyU6BNgHvabvYCwwssmLw99HwKQ8B5CrMpwrJ14mBBz1Rn82D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f4U6rqXT; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f4U6rqXT"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7d5d1feca18so12349285a.2
        for <fio@vger.kernel.org>; Wed, 23 Jul 2025 10:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753290352; x=1753895152; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YW7RIdHUGUV5KaHtNNcsoT4BCGaTH96o4Rnu6LnR6gE=;
        b=f4U6rqXTMRKyGfH7A91h4keNcYZx5xUBzrSNryazBD/HEeyIwo3USTFqaYiaUj7lNp
         6UyFYdhVMLTyEM4fpZ17HICppqgSgMLmbZ0mnB9iTq0wjMldhPwUphh9DpdCyBgVyHqR
         62sgw5nbXBaSGw9KNTbiQVA3uH1Q46FK5YQDWbJju53azOMSMv0vsIutVcTgIN3fLfD1
         g+jIoA4cnfmKXk0PSKnW8IkIxkGJGAyD5kcDjhQq8VoDgvFlIUoIgff8GIvDcAXKQwc/
         y7Nnda3hbFXtLs9KL6B8OaZF/1ZbvF2AfEH2P9q1sxSd442wnjRvwdY8pQaegW559CL1
         fj2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753290352; x=1753895152;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YW7RIdHUGUV5KaHtNNcsoT4BCGaTH96o4Rnu6LnR6gE=;
        b=BdfWMCl8zJs4JDQ/yFmr/gBOCRgF+wik9h2U8Iu4kMbzAaE9W4+Nescmvh8MYAY0ZL
         JHCtxVd4tKj22iXh8LolOgM8vpZVr3V5a+aMxuJjfc9Lh/6W0yic7a4bxMvR1a1UPuxp
         WsA0VIjZLiDAIT0yT3wnVnLMGyZ8TX8RfEEQiXlMBgtU7B/8DQ68hE6UY7yyQZkgyizA
         mmgMeYGaUDBsHjHmFaRWkqgXcAUownFt8UOO8syOau73Mrk+CC4Vru/v0MT54xCWRszS
         ZWJaMxosthe5YqNXrMwTCpihcAolpSTQh6lNMJpoNTfNqd+FujoQaZaWq56huILRw6/n
         eT/w==
X-Forwarded-Encrypted: i=1; AJvYcCXK5FzA3LRA+aSY0FlSIvZsUBXOi2FftiBPouTLjsWiB+Pj7GiZzulSMWRcQ+rjk9I8zmA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFnvw6RURHMx5hIxjUP3yapJjQgKpeTzsCU6n1Ao0iaQ+VDY+X
	odqAdoSZwz4hzpe569LNKJC9GPZMWv0U6PUbuKc4BfpDJuzmFvxgN7gL
X-Gm-Gg: ASbGncudmPm9pni/Iokspx/kuIxIe8cZkNeQYZ+Kn2hIZ4SMXZr8A5RvtvVT4uKLJtc
	Mklbb0D//HoZB9XdB82BoUhneLYYYO0p55hsjGb6JXioQROOuLZecNYUfi5sWoVCjbg41zAKn3A
	2DISx/QNSJ3P/Kj7JPGoM3w/fGV2KqIVKK414HNsdDwayo8zOWucuELP8/tzlXEquz5lEfUtmUn
	sIpXhcdYm+Htswp2GsXNJc+X6lMFcttKZjcD7igdfihtb+64xX6bNQvOO6YfItWqEFyHOFWz3Ee
	UG9KG5a5XwrzrNE40l2pbyV1zZRH7B88wnD43A3XTZckGgdhaOXWEkp32qsolk4PRYe8ZrUPCJK
	r5EGZ5OmB4fMw5IvTGN2gCP8FKFkH/BtcjsAhCml3zgGiHgpRrot1O79EavsROqYDiW9QnnSNNb
	wolriCKtW9
X-Google-Smtp-Source: AGHT+IFJ5ZTmd7AaM3jUBCRUjK4a9hVWs14IvFgT1kJ4lVC347SqCkBDdLCdkmPd0YkxErUfUHdnmg==
X-Received: by 2002:a05:620a:a488:b0:7e3:380a:b8b2 with SMTP id af79cd13be357-7e62a0fff15mr488219385a.23.1753290351458;
        Wed, 23 Jul 2025 10:05:51 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7e356cbfad9sm675482785a.110.2025.07.23.10.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 10:05:50 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: anuj1072538@gmail.com,
	axboe@kernel.dk,
	hch@infradead.org,
	joshi.k@samsung.com,
	anuj20.g@samsung.com,
	fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 1/2] engines/io_uring: support r/w with metadata
Date: Wed, 23 Jul 2025 13:04:56 -0400
Message-ID: <67829b031f25595387d7dce10fa0355d85fbebae.1753282479.git.vincent.fu@samsung.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1753282479.git.vincent.fu@samsung.com>
References: <cover.1753282479.git.vincent.fu@samsung.com>
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

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 engines/io_uring.c  | 241 +++++++++++++++++++++++++++++++++++++++++---
 engines/nvme.c      |  35 +++----
 engines/nvme.h      |  18 ++++
 io_u.h              |   1 +
 os/linux/io_uring.h |  15 +++
 5 files changed, 273 insertions(+), 37 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 87018f84..180db5b5 100644
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
 
@@ -436,6 +502,27 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 				sqe->len = 1;
 			}
 		}
+		if (o->md_per_io_size) {
+			struct io_uring_attr_pi *pi_attr = io_u->pi_attr;
+			struct nvme_data *data = FILE_ENG_DATA(io_u->file);
+
+			sqe->attr_type_mask = IORING_RW_ATTR_FLAG_PI;
+			sqe->attr_ptr = (__u64)(uintptr_t)pi_attr;
+			pi_attr->addr = (__u64)(uintptr_t)io_u->mmap_data;
+			pi_attr->len = o->md_per_io_size;
+			pi_attr->app_tag = o->apptag;
+			pi_attr->flags = 0;
+			if (strstr(o->pi_chk, "GUARD") != NULL)
+				pi_attr->flags |= IO_INTEGRITY_CHK_GUARD;
+			if (strstr(o->pi_chk, "REFTAG") != NULL) {
+				__u64 slba = get_slba(data, io_u->offset);
+
+				pi_attr->flags |= IO_INTEGRITY_CHK_REFTAG;
+				pi_attr->seed = (__u32)slba;
+			}
+			if (strstr(o->pi_chk, "APPTAG") != NULL)
+				pi_attr->flags |= IO_INTEGRITY_CHK_APPTAG;
+		}
 		sqe->rw_flags = 0;
 		if (!td->o.odirect && o->uncached)
 			sqe->rw_flags |= RWF_DONTCACHE;
@@ -565,6 +652,7 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 {
 	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
 	struct io_uring_cqe *cqe;
 	struct io_u *io_u;
 	unsigned index;
@@ -590,6 +678,19 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 			io_u->error = -cqe->res;
 		else
 			io_u->resid = io_u->xfer_buflen - cqe->res;
+		return io_u;
+	}
+
+	if (o->md_per_io_size) {
+		struct nvme_data *data;
+		int ret;
+
+		data = FILE_ENG_DATA(io_u->file);
+		if (data->pi_type && (io_u->ddir == DDIR_READ) && !o->pi_act) {
+			ret = fio_nvme_pi_verify(data, io_u);
+			if (ret)
+				io_u->error = ret;
+		}
 	}
 
 	return io_u;
@@ -802,6 +903,21 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 		o->cmd_type == FIO_URING_CMD_NVME)
 		fio_ioring_cmd_nvme_pi(td, io_u);
 
+	if (!strcmp(td->io_ops->name, "io_uring") && o->md_per_io_size) {
+		struct nvme_data *data = FILE_ENG_DATA(io_u->file);
+		struct nvme_cmd_ext_io_opts ext_opts = {0};
+
+		if (data->pi_type) {
+			if (o->pi_act)
+				ext_opts.io_flags |= NVME_IO_PRINFO_PRACT;
+
+			ext_opts.io_flags |= o->prchk;
+			ext_opts.apptag = o->apptag;
+			ext_opts.apptag_mask = o->apptag_mask;
+		}
+		fio_nvme_generate_guard(io_u, &ext_opts);
+	}
+
 	tail = *ring->tail;
 	ring->array[tail & ld->sq_ring_mask] = io_u->index;
 	atomic_store_release(ring->tail, tail + 1);
@@ -920,6 +1036,7 @@ static void fio_ioring_cleanup(struct thread_data *td)
 		fio_cmdprio_cleanup(&ld->cmdprio);
 		free(ld->io_u_index);
 		free(ld->md_buf);
+		free(ld->pi_attr);
 		free(ld->iovecs);
 		free(ld->fds);
 		free(ld->dsm);
@@ -1347,12 +1464,20 @@ static int fio_ioring_init(struct thread_data *td)
 	/* io_u index */
 	ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
 
+	if (!strcmp(td->io_ops->name, "io_uring") && o->md_per_io_size) {
+		if (o->apptag_mask != 0xffff) {
+			log_err("fio: io_uring with metadata requires an apptag_mask of 0xffff\n");
+			return 1;
+		}
+	}
+
 	/*
 	 * metadata buffer for nvme command.
 	 * We are only supporting iomem=malloc / mem=malloc as of now.
 	 */
-	if (!strcmp(td->io_ops->name, "io_uring_cmd") &&
-	    (o->cmd_type == FIO_URING_CMD_NVME) && o->md_per_io_size) {
+	if ((!strcmp(td->io_ops->name, "io_uring_cmd") &&
+	    (o->cmd_type == FIO_URING_CMD_NVME) && o->md_per_io_size) ||
+	    (!strcmp(td->io_ops->name, "io_uring") && o->md_per_io_size)) {
 		md_size = (unsigned long long) o->md_per_io_size
 				* (unsigned long long) td->o.iodepth;
 		md_size += page_mask + td->o.mem_align;
@@ -1363,6 +1488,12 @@ static int fio_ioring_init(struct thread_data *td)
 			free(ld);
 			return 1;
 		}
+		ld->pi_attr = calloc(ld->iodepth, sizeof(struct io_uring_attr_pi));
+		if (!ld->pi_attr) {
+			free(ld->md_buf);
+			free(ld);
+			return 1;
+		}
 	}
 	parse_prchk_flags(o);
 
@@ -1429,22 +1560,23 @@ static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
 	struct nvme_pi_data *pi_data;
-	char *p;
+	char *p, *q;
 
 	ld->io_u_index[io_u->index] = io_u;
 
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
+	q = ld->pi_attr;
+	q += (sizeof(struct io_uring_attr_pi) * io_u->index);
+	io_u->pi_attr = q;
+
+	if (!o->pi_act) {
+		pi_data = calloc(1, sizeof(*pi_data));
+		pi_data->io_flags |= o->prchk;
+		pi_data->apptag_mask = o->apptag_mask;
+		pi_data->apptag = o->apptag;
+		io_u->engine_data = pi_data;
 	}
 
 	return 0;
@@ -1463,11 +1595,90 @@ static void fio_ioring_io_u_free(struct thread_data *td, struct io_u *io_u)
 	}
 }
 
+static int fio_get_pi_info(struct fio_file *f, __u64 *nlba, __u32 pi_act,
+			     struct nvme_data *data)
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
+		log_err("%s: unsupported checksum type %d\n", f->file_name, md_cap.lbmd_guard_tag_type);
+		err = -ENOTSUP;
+		goto out;
+	}
+
+out:
+	close(fd);
+	return err;
+}
+
 static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
 {
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
 
+	if (o->md_per_io_size) {
+		struct nvme_data *data = NULL;
+		__u64 nlba = 0;
+		int ret;
+
+		data = FILE_ENG_DATA(f);
+		if (data == NULL) {
+			data = calloc(1, sizeof(struct nvme_data));
+			ret = fio_get_pi_info(f, &nlba, o->pi_act, data);
+			if (ret) {
+				free(data);
+				return ret;
+			}
+
+			FILE_SET_ENG_DATA(f, data);
+		}
+	}
+
 	if (!ld || !o->registerfiles)
 		return generic_open_file(td, f);
 
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
-- 
2.47.2

