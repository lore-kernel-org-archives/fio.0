Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A902A1292F0
	for <fio@vger.kernel.org>; Fri, 16 Feb 2024 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708088414; cv=none; b=m8bB6budxiBVEGy/iIys4EjXFkFYVjkabq9+mA0CNNWpaJhsB6LunfYsP7j4JXpxRKnNDDCOuwQBIcM2VJq2tdpdMAfLGlkN2JhFAY6mzZDTkUIe6/GSkC1N+1KU7oSNxq13vC4E9lldZX8NsbqE7kFF7VGO8FD6WQsidoECrKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708088414; c=relaxed/simple;
	bh=D8GKDf23ze5c4aD29C6yZW0YyQhS2c6lI5ASFJWd/RE=;
	h=Subject:From:To:Message-Id:Date; b=KM6m6j+b/z13U7A81dj2uX88C2o7WLM6RZXkugFJ5sxFjvTzZChEiwFBhPo3EMpB4/3vOp3fM+WhqvYzzX6FllwyMbRzqG1p9uBxgWaIvv42FRZOxNOwZuirkNLXNsnd5L28TdhP8QppyWxY6yR8dFFnjCYFZMx8mpT94aeYZwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UuKt6ejz; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UuKt6ejz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=yVx9XG10xeqCbkZpD4M/F9trjTatWJ5iFPtdc3dUhHI=; b=UuKt6ejzNgAXeoBuv0btqJ6swt
	LTekLhWVErGIerJjAuy4fBxvULOrAxpUL9tTLpLmv0AmnN+E/ThcTrAcXNwzMEUcZv3goQy5xdC3I
	79BxyxN9sIkDL6vOlD0LcmrOQkithaTuymzDOj0gWfXJYutY/eTwWu9L6pJ7xZFFzarFbmYSBPb0r
	CVqSqa0fy/Qe0o8o6JzrQS1E/PK6YUrAaZG+j5TiPLIUvB03DlFzrOn+KFeHuxm+GKtHP3LYMkBMH
	CHcDsynVFwXTgHgaZ9Ekjv0LWCIQKu4CCZC4iGnASY9g4huAoy0o3SRcrEUr9qbRQn1CNArmzp/8C
	tNb7o1rw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raxoy-0000000HUK9-18Y7
	for fio@vger.kernel.org;
	Fri, 16 Feb 2024 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 54A221BC0164; Fri, 16 Feb 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240216130001.54A221BC0164@kernel.dk>
Date: Fri, 16 Feb 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 7aec5ac0bdd1adcaeba707f26d5bc583de6ab6c9:

  test: add the test for loops option and read-verify workloads (2024-02-14 07:39:48 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2d0debb3fca7ddc4374624acb8c70fc8292d860d:

  t/run-fio-tests: add t/nvmept_trim.py (2024-02-15 14:05:12 -0500)

----------------------------------------------------------------
Ankit Kumar (3):
      trim: add support for multiple ranges
      engines/nvme: pass offset and len instead of io_u
      engines/io_uring: add multi range dsm support

Jens Axboe (3):
      t/io_uring: account and ignore IO errors
      t/io_uring: pre-calculate per-file depth
      io_u: move number_trim to reclaim 8 bytes in struct io_u

Vincent Fu (2):
      t/nvmept_trim.py: test multi-range trim
      t/run-fio-tests: add t/nvmept_trim.py

 HOWTO.rst                               |   9 +
 backend.c                               |  20 +-
 cconv.c                                 |   2 +
 engines/io_uring.c                      |  34 +-
 engines/nvme.c                          |  72 ++--
 engines/nvme.h                          |   7 +-
 examples/uring-cmd-trim-multi-range.fio |  21 ++
 fio.1                                   |   7 +
 fio.h                                   |  18 +
 init.c                                  |  13 +
 io_u.c                                  |  97 +++++-
 io_u.h                                  |   5 +
 ioengines.h                             |   2 +
 options.c                               |  11 +
 server.h                                |   2 +-
 t/io_uring.c                            |  62 ++--
 t/nvmept_trim.py                        | 586 ++++++++++++++++++++++++++++++++
 t/run-fio-tests.py                      |   8 +
 thread_options.h                        |   3 +
 19 files changed, 899 insertions(+), 80 deletions(-)
 create mode 100644 examples/uring-cmd-trim-multi-range.fio
 create mode 100755 t/nvmept_trim.py

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 5bc1713c..4b02100c 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2534,6 +2534,15 @@ with the caveat that when used on the command line, they must come after the
 	Specifies logical block application tag mask value, if namespace is
 	formatted to use end to end protection information. Default: 0xffff.
 
+.. option:: num_range=int : [io_uring_cmd]
+
+	For trim command this will be the number of ranges to trim per I/O
+	request. The number of logical blocks per range is determined by the
+	:option:`bs` option which should be a multiple of logical block size.
+	This cannot be used with read or write. Note that setting this
+	option > 1, :option:`log_offset` will not be able to log all the
+	offsets. Default: 1.
+
 .. option:: cpuload=int : [cpuio]
 
 	Attempt to use the specified percentage of CPU cycles. This is a mandatory
diff --git a/backend.c b/backend.c
index 1fab467a..2f2221bf 100644
--- a/backend.c
+++ b/backend.c
@@ -1333,7 +1333,7 @@ static int init_io_u(struct thread_data *td)
 int init_io_u_buffers(struct thread_data *td)
 {
 	struct io_u *io_u;
-	unsigned long long max_bs, min_write;
+	unsigned long long max_bs, min_write, trim_bs = 0;
 	int i, max_units;
 	int data_xfer = 1;
 	char *p;
@@ -1344,7 +1344,18 @@ int init_io_u_buffers(struct thread_data *td)
 	td->orig_buffer_size = (unsigned long long) max_bs
 					* (unsigned long long) max_units;
 
-	if (td_ioengine_flagged(td, FIO_NOIO) || !(td_read(td) || td_write(td)))
+	if (td_trim(td) && td->o.num_range > 1) {
+		trim_bs = td->o.num_range * sizeof(struct trim_range);
+		td->orig_buffer_size = trim_bs
+					* (unsigned long long) max_units;
+	}
+
+	/*
+	 * For reads, writes, and multi-range trim operations we need a
+	 * data buffer
+	 */
+	if (td_ioengine_flagged(td, FIO_NOIO) ||
+	    !(td_read(td) || td_write(td) || (td_trim(td) && td->o.num_range > 1)))
 		data_xfer = 0;
 
 	/*
@@ -1396,7 +1407,10 @@ int init_io_u_buffers(struct thread_data *td)
 				fill_verify_pattern(td, io_u->buf, max_bs, io_u, 0, 0);
 			}
 		}
-		p += max_bs;
+		if (td_trim(td) && td->o.num_range > 1)
+			p += trim_bs;
+		else
+			p += max_bs;
 	}
 
 	return 0;
diff --git a/cconv.c b/cconv.c
index c9298408..ead47248 100644
--- a/cconv.c
+++ b/cconv.c
@@ -111,6 +111,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->serialize_overlap = le32_to_cpu(top->serialize_overlap);
 	o->size = le64_to_cpu(top->size);
 	o->io_size = le64_to_cpu(top->io_size);
+	o->num_range = le32_to_cpu(top->num_range);
 	o->size_percent = le32_to_cpu(top->size_percent);
 	o->io_size_percent = le32_to_cpu(top->io_size_percent);
 	o->fill_device = le32_to_cpu(top->fill_device);
@@ -609,6 +610,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 
 	top->size = __cpu_to_le64(o->size);
 	top->io_size = __cpu_to_le64(o->io_size);
+	top->num_range = __cpu_to_le32(o->num_range);
 	top->verify_backlog = __cpu_to_le64(o->verify_backlog);
 	top->start_delay = __cpu_to_le64(o->start_delay);
 	top->start_delay_high = __cpu_to_le64(o->start_delay_high);
diff --git a/engines/io_uring.c b/engines/io_uring.c
index c0cb5a78..9069fa3e 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -81,7 +81,7 @@ struct ioring_data {
 
 	struct cmdprio cmdprio;
 
-	struct nvme_dsm_range *dsm;
+	struct nvme_dsm *dsm;
 };
 
 struct ioring_options {
@@ -385,6 +385,9 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 	struct fio_file *f = io_u->file;
 	struct nvme_uring_cmd *cmd;
 	struct io_uring_sqe *sqe;
+	struct nvme_dsm *dsm;
+	void *ptr = ld->dsm;
+	unsigned int dsm_size;
 
 	/* only supports nvme_uring_cmd */
 	if (o->cmd_type != FIO_URING_CMD_NVME)
@@ -423,9 +426,13 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 	}
 
 	cmd = (struct nvme_uring_cmd *)sqe->cmd;
+	dsm_size = sizeof(*ld->dsm) + td->o.num_range * sizeof(struct nvme_dsm_range);
+	ptr += io_u->index * dsm_size;
+	dsm = (struct nvme_dsm *)ptr;
+
 	return fio_nvme_uring_cmd_prep(cmd, io_u,
 			o->nonvectored ? NULL : &ld->iovecs[io_u->index],
-			&ld->dsm[io_u->index]);
+			dsm);
 }
 
 static struct io_u *fio_ioring_event(struct thread_data *td, int event)
@@ -1133,8 +1140,11 @@ static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o = td->eo;
 	struct ioring_data *ld;
+	struct nvme_dsm *dsm;
+	void *ptr;
+	unsigned int dsm_size;
 	unsigned long long md_size;
-	int ret;
+	int ret, i;
 
 	/* sqthread submission requires registered files */
 	if (o->sqpoll_thread)
@@ -1195,10 +1205,19 @@ static int fio_ioring_init(struct thread_data *td)
 	 * in zbd mode where trim means zone reset.
 	 */
 	if (!strcmp(td->io_ops->name, "io_uring_cmd") && td_trim(td) &&
-	    td->o.zone_mode == ZONE_MODE_ZBD)
+	    td->o.zone_mode == ZONE_MODE_ZBD) {
 		td->io_ops->flags |= FIO_ASYNCIO_SYNC_TRIM;
-	else
-		ld->dsm = calloc(td->o.iodepth, sizeof(*ld->dsm));
+	} else {
+		dsm_size = sizeof(*ld->dsm) +
+			td->o.num_range * sizeof(struct nvme_dsm_range);
+		ld->dsm = calloc(td->o.iodepth, dsm_size);
+		ptr = ld->dsm;
+		for (i = 0; i < td->o.iodepth; i++) {
+			dsm = (struct nvme_dsm *)ptr;
+			dsm->nr_ranges = td->o.num_range;
+			ptr += dsm_size;
+		}
+	}
 
 	return 0;
 }
@@ -1466,7 +1485,8 @@ static struct ioengine_ops ioengine_uring_cmd = {
 	.name			= "io_uring_cmd",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_NO_OFFLOAD | FIO_MEMALIGN | FIO_RAWIO |
-					FIO_ASYNCIO_SETS_ISSUE_TIME,
+					FIO_ASYNCIO_SETS_ISSUE_TIME |
+					FIO_MULTI_RANGE_TRIM,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_cmd_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
diff --git a/engines/nvme.c b/engines/nvme.c
index 75a5e0c1..c6629e86 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -8,20 +8,20 @@
 #include "../crc/crc-t10dif.h"
 #include "../crc/crc64.h"
 
-static inline __u64 get_slba(struct nvme_data *data, struct io_u *io_u)
+static inline __u64 get_slba(struct nvme_data *data, __u64 offset)
 {
 	if (data->lba_ext)
-		return io_u->offset / data->lba_ext;
-	else
-		return io_u->offset >> data->lba_shift;
+		return offset / data->lba_ext;
+
+	return offset >> data->lba_shift;
 }
 
-static inline __u32 get_nlb(struct nvme_data *data, struct io_u *io_u)
+static inline __u32 get_nlb(struct nvme_data *data, __u64 len)
 {
 	if (data->lba_ext)
-		return io_u->xfer_buflen / data->lba_ext - 1;
-	else
-		return (io_u->xfer_buflen >> data->lba_shift) - 1;
+		return len / data->lba_ext - 1;
+
+	return (len >> data->lba_shift) - 1;
 }
 
 static void fio_nvme_generate_pi_16b_guard(struct nvme_data *data,
@@ -32,8 +32,8 @@ static void fio_nvme_generate_pi_16b_guard(struct nvme_data *data,
 	struct nvme_16b_guard_pif *pi;
 	unsigned char *buf = io_u->xfer_buf;
 	unsigned char *md_buf = io_u->mmap_data;
-	__u64 slba = get_slba(data, io_u);
-	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u64 slba = get_slba(data, io_u->offset);
+	__u32 nlb = get_nlb(data, io_u->xfer_buflen) + 1;
 	__u32 lba_num = 0;
 	__u16 guard = 0;
 
@@ -99,8 +99,8 @@ static int fio_nvme_verify_pi_16b_guard(struct nvme_data *data,
 	struct fio_file *f = io_u->file;
 	unsigned char *buf = io_u->xfer_buf;
 	unsigned char *md_buf = io_u->mmap_data;
-	__u64 slba = get_slba(data, io_u);
-	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u64 slba = get_slba(data, io_u->offset);
+	__u32 nlb = get_nlb(data, io_u->xfer_buflen) + 1;
 	__u32 lba_num = 0;
 	__u16 unmask_app, unmask_app_exp, guard = 0;
 
@@ -185,8 +185,8 @@ static void fio_nvme_generate_pi_64b_guard(struct nvme_data *data,
 	unsigned char *buf = io_u->xfer_buf;
 	unsigned char *md_buf = io_u->mmap_data;
 	uint64_t guard = 0;
-	__u64 slba = get_slba(data, io_u);
-	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u64 slba = get_slba(data, io_u->offset);
+	__u32 nlb = get_nlb(data, io_u->xfer_buflen) + 1;
 	__u32 lba_num = 0;
 
 	if (data->pi_loc) {
@@ -251,9 +251,9 @@ static int fio_nvme_verify_pi_64b_guard(struct nvme_data *data,
 	struct fio_file *f = io_u->file;
 	unsigned char *buf = io_u->xfer_buf;
 	unsigned char *md_buf = io_u->mmap_data;
-	__u64 slba = get_slba(data, io_u);
+	__u64 slba = get_slba(data, io_u->offset);
 	__u64 ref, ref_exp, guard = 0;
-	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u32 nlb = get_nlb(data, io_u->xfer_buflen) + 1;
 	__u32 lba_num = 0;
 	__u16 unmask_app, unmask_app_exp;
 
@@ -329,24 +329,40 @@ next:
 	return 0;
 }
 void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
-				  struct nvme_dsm_range *dsm)
+				  struct nvme_dsm *dsm)
 {
 	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
+	struct trim_range *range;
+	uint8_t *buf_point;
+	int i;
 
 	cmd->opcode = nvme_cmd_dsm;
 	cmd->nsid = data->nsid;
-	cmd->cdw10 = 0;
 	cmd->cdw11 = NVME_ATTRIBUTE_DEALLOCATE;
-	cmd->addr = (__u64) (uintptr_t) dsm;
-	cmd->data_len = sizeof(*dsm);
-
-	dsm->slba = get_slba(data, io_u);
-	/* nlb is a 1-based value for deallocate */
-	dsm->nlb = get_nlb(data, io_u) + 1;
+	cmd->addr = (__u64) (uintptr_t) (&dsm->range[0]);
+
+	if (dsm->nr_ranges == 1) {
+		dsm->range[0].slba = get_slba(data, io_u->offset);
+		/* nlb is a 1-based value for deallocate */
+		dsm->range[0].nlb = get_nlb(data, io_u->xfer_buflen) + 1;
+		cmd->cdw10 = 0;
+		cmd->data_len = sizeof(struct nvme_dsm_range);
+	} else {
+		buf_point = io_u->xfer_buf;
+		for (i = 0; i < io_u->number_trim; i++) {
+			range = (struct trim_range *)buf_point;
+			dsm->range[i].slba = get_slba(data, range->start);
+			/* nlb is a 1-based value for deallocate */
+			dsm->range[i].nlb = get_nlb(data, range->len) + 1;
+			buf_point += sizeof(struct trim_range);
+		}
+		cmd->cdw10 = io_u->number_trim - 1;
+		cmd->data_len = io_u->number_trim * sizeof(struct nvme_dsm_range);
+	}
 }
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
-			    struct iovec *iov, struct nvme_dsm_range *dsm)
+			    struct iovec *iov, struct nvme_dsm *dsm)
 {
 	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
 	__u64 slba;
@@ -368,8 +384,8 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		return -ENOTSUP;
 	}
 
-	slba = get_slba(data, io_u);
-	nlb = get_nlb(data, io_u);
+	slba = get_slba(data, io_u->offset);
+	nlb = get_nlb(data, io_u->xfer_buflen);
 
 	/* cdw10 and cdw11 represent starting lba */
 	cmd->cdw10 = slba & 0xffffffff;
@@ -400,7 +416,7 @@ void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
 	__u64 slba;
 
-	slba = get_slba(data, io_u);
+	slba = get_slba(data, io_u->offset);
 	cmd->cdw12 |= opts->io_flags;
 
 	if (data->pi_type && !(opts->io_flags & NVME_IO_PRINFO_PRACT)) {
diff --git a/engines/nvme.h b/engines/nvme.h
index 792b35d8..2d5204fc 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -408,6 +408,11 @@ struct nvme_dsm_range {
 	__le64	slba;
 };
 
+struct nvme_dsm {
+	__u32 nr_ranges;
+	struct nvme_dsm_range range[];
+};
+
 struct nvme_cmd_ext_io_opts {
 	__u32 io_flags;
 	__u16 apptag;
@@ -421,7 +426,7 @@ int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, __u32 pi_act,
 		      struct nvme_data *data);
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
-			    struct iovec *iov, struct nvme_dsm_range *dsm);
+			    struct iovec *iov, struct nvme_dsm *dsm);
 
 void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		      struct nvme_cmd_ext_io_opts *opts);
diff --git a/examples/uring-cmd-trim-multi-range.fio b/examples/uring-cmd-trim-multi-range.fio
new file mode 100644
index 00000000..b376481b
--- /dev/null
+++ b/examples/uring-cmd-trim-multi-range.fio
@@ -0,0 +1,21 @@
+# Multi-range trim command test with io_uring_cmd I/O engine for nvme-ns
+# generic character device.
+#
+[global]
+filename=/dev/ng0n1
+ioengine=io_uring_cmd
+cmd_type=nvme
+size=10M
+iodepth=32
+thread=1
+stonewall=1
+
+[write_bs]
+bs=4096
+rw=randtrim
+num_range=8
+
+[write_bssplit]
+bssplit=4k/10:64k/50:32k/40
+rw=trim
+num_range=8
diff --git a/fio.1 b/fio.1
index 7ec5c745..e6b291a7 100644
--- a/fio.1
+++ b/fio.1
@@ -2293,6 +2293,13 @@ end to end protection information. Default: 0x1234.
 Specifies logical block application tag mask value, if namespace is formatted
 to use end to end protection information. Default: 0xffff.
 .TP
+.BI (io_uring_cmd)num_range \fR=\fPint
+For trim command this will be the number of ranges to trim per I/O request.
+The number of logical blocks per range is determined by the \fBbs\fR option
+which should be a multiple of logical block size. This cannot be used with
+read or write. Note that setting this option > 1, \fBlog_offset\fR will not be
+able to log all the offsets. Default: 1.
+.TP
 .BI (cpuio)cpuload \fR=\fPint
 Attempt to use the specified percentage of CPU cycles. This is a mandatory
 option when using cpuio I/O engine.
diff --git a/fio.h b/fio.h
index 1322656f..fc3e3ece 100644
--- a/fio.h
+++ b/fio.h
@@ -71,6 +71,16 @@
 
 struct fio_sem;
 
+#define MAX_TRIM_RANGE	256
+
+/*
+ * Range for trim command
+ */
+struct trim_range {
+	unsigned long long start;
+	unsigned long long len;
+};
+
 /*
  * offset generator types
  */
@@ -609,6 +619,14 @@ static inline void fio_ro_check(const struct thread_data *td, struct io_u *io_u)
 	       !(io_u->ddir == DDIR_TRIM && !td_trim(td)));
 }
 
+static inline bool multi_range_trim(struct thread_data *td, struct io_u *io_u)
+{
+	if (io_u->ddir == DDIR_TRIM && td->o.num_range > 1)
+		return true;
+
+	return false;
+}
+
 static inline bool should_fsync(struct thread_data *td)
 {
 	if (td->last_was_sync)
diff --git a/init.c b/init.c
index 105339fa..7a0b14a3 100644
--- a/init.c
+++ b/init.c
@@ -618,6 +618,19 @@ static int fixup_options(struct thread_data *td)
 		ret |= 1;
 	}
 
+	if (td_trimwrite(td) && o->num_range > 1) {
+		log_err("fio: trimwrite cannot be used with multiple"
+			" ranges.\n");
+		ret |= 1;
+	}
+
+	if (td_trim(td) && o->num_range > 1 &&
+	    !td_ioengine_flagged(td, FIO_MULTI_RANGE_TRIM)) {
+		log_err("fio: can't use multiple ranges with IO engine %s\n",
+			td->io_ops->name);
+		ret |= 1;
+	}
+
 #ifndef CONFIG_PSHARED
 	if (!o->use_thread) {
 		log_info("fio: this platform does not support process shared"
diff --git a/io_u.c b/io_u.c
index 4254675a..2b8e17f8 100644
--- a/io_u.c
+++ b/io_u.c
@@ -940,6 +940,65 @@ static void setup_strided_zone_mode(struct thread_data *td, struct io_u *io_u)
 		fio_file_reset(td, f);
 }
 
+static int fill_multi_range_io_u(struct thread_data *td, struct io_u *io_u)
+{
+	bool is_random;
+	uint64_t buflen, i = 0;
+	struct trim_range *range;
+	struct fio_file *f = io_u->file;
+	uint8_t *buf;
+
+	buf = io_u->buf;
+	buflen = 0;
+
+	while (i < td->o.num_range) {
+		range = (struct trim_range *)buf;
+		if (get_next_offset(td, io_u, &is_random)) {
+			dprint(FD_IO, "io_u %p, failed getting offset\n",
+			       io_u);
+			break;
+		}
+
+		io_u->buflen = get_next_buflen(td, io_u, is_random);
+		if (!io_u->buflen) {
+			dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
+			break;
+		}
+
+		if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
+			dprint(FD_IO, "io_u %p, off=0x%llx + len=0x%llx exceeds file size=0x%llx\n",
+			       io_u,
+			       (unsigned long long) io_u->offset, io_u->buflen,
+			       (unsigned long long) io_u->file->real_file_size);
+			break;
+		}
+
+		range->start = io_u->offset;
+		range->len = io_u->buflen;
+		buflen += io_u->buflen;
+		f->last_start[io_u->ddir] = io_u->offset;
+		f->last_pos[io_u->ddir] = io_u->offset + range->len;
+
+		buf += sizeof(struct trim_range);
+		i++;
+
+		if (td_random(td) && file_randommap(td, io_u->file))
+			mark_random_map(td, io_u, io_u->offset, io_u->buflen);
+		dprint_io_u(io_u, "fill");
+	}
+	if (buflen) {
+		/*
+		 * Set buffer length as overall trim length for this IO, and
+		 * tell the ioengine about the number of ranges to be trimmed.
+		 */
+		io_u->buflen = buflen;
+		io_u->number_trim = i;
+		return 0;
+	}
+
+	return 1;
+}
+
 static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 {
 	bool is_random;
@@ -966,22 +1025,27 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	else if (td->o.zone_mode == ZONE_MODE_ZBD)
 		setup_zbd_zone_mode(td, io_u);
 
-	/*
-	 * No log, let the seq/rand engine retrieve the next buflen and
-	 * position.
-	 */
-	if (get_next_offset(td, io_u, &is_random)) {
-		dprint(FD_IO, "io_u %p, failed getting offset\n", io_u);
-		return 1;
-	}
+	if (multi_range_trim(td, io_u)) {
+		if (fill_multi_range_io_u(td, io_u))
+			return 1;
+	} else {
+		/*
+		 * No log, let the seq/rand engine retrieve the next buflen and
+		 * position.
+		 */
+		if (get_next_offset(td, io_u, &is_random)) {
+			dprint(FD_IO, "io_u %p, failed getting offset\n", io_u);
+			return 1;
+		}
 
-	io_u->buflen = get_next_buflen(td, io_u, is_random);
-	if (!io_u->buflen) {
-		dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
-		return 1;
+		io_u->buflen = get_next_buflen(td, io_u, is_random);
+		if (!io_u->buflen) {
+			dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
+			return 1;
+		}
 	}
-
 	offset = io_u->offset;
+
 	if (td->o.zone_mode == ZONE_MODE_ZBD) {
 		ret = zbd_adjust_block(td, io_u);
 		if (ret == io_u_eof) {
@@ -1004,11 +1068,12 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	/*
 	 * mark entry before potentially trimming io_u
 	 */
-	if (td_random(td) && file_randommap(td, io_u->file))
+	if (!multi_range_trim(td, io_u) && td_random(td) && file_randommap(td, io_u->file))
 		io_u->buflen = mark_random_map(td, io_u, offset, io_u->buflen);
 
 out:
-	dprint_io_u(io_u, "fill");
+	if (!multi_range_trim(td, io_u))
+		dprint_io_u(io_u, "fill");
 	io_u->verify_offset = io_u->offset;
 	td->zone_bytes += io_u->buflen;
 	return 0;
@@ -1814,7 +1879,7 @@ struct io_u *get_io_u(struct thread_data *td)
 
 	assert(fio_file_open(f));
 
-	if (ddir_rw(io_u->ddir)) {
+	if (ddir_rw(io_u->ddir) && !multi_range_trim(td, io_u)) {
 		if (!io_u->buflen && !td_ioengine_flagged(td, FIO_NOIO)) {
 			dprint(FD_IO, "get_io_u: zero buflen on %p\n", io_u);
 			goto err_put;
diff --git a/io_u.h b/io_u.h
index 786251d5..ab93d50f 100644
--- a/io_u.h
+++ b/io_u.h
@@ -52,6 +52,11 @@ struct io_u {
 	unsigned short ioprio;
 	unsigned short clat_prio_index;
 
+	/*
+	 * number of trim ranges for this IO.
+	 */
+	unsigned int number_trim;
+
 	/*
 	 * Allocated/set buffer and length
 	 */
diff --git a/ioengines.h b/ioengines.h
index 4391b31e..2fd7f52c 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -97,6 +97,8 @@ enum fio_ioengine_flags {
 	FIO_RO_NEEDS_RW_OPEN
 			= 1 << 18,	/* open files in rw mode even if we have a read job; only
 					   affects ioengines using generic_open_file */
+	FIO_MULTI_RANGE_TRIM
+			= 1 << 19,	/* ioengine supports trim with more than one range */
 };
 
 /*
diff --git a/options.c b/options.c
index 1da4de78..25e042d0 100644
--- a/options.c
+++ b/options.c
@@ -2395,6 +2395,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "num_range",
+		.lname	= "Number of ranges",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, num_range),
+		.maxval	= MAX_TRIM_RANGE,
+		.help	= "Number of ranges for trim command",
+		.def	= "1",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
 	{
 		.name	= "bs",
 		.lname	= "Block size",
diff --git a/server.h b/server.h
index 0eb594ce..6d2659b0 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 102,
+	FIO_SERVER_VER			= 103,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/t/io_uring.c b/t/io_uring.c
index efc50caa..46b153dc 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -94,6 +94,7 @@ struct submitter {
 	unsigned long reaps;
 	unsigned long done;
 	unsigned long calls;
+	unsigned long io_errors;
 	volatile int finish;
 
 	__s32 *fds;
@@ -109,6 +110,7 @@ struct submitter {
 #endif
 
 	int numa_node;
+	int per_file_depth;
 	const char *filename;
 
 	struct file files[MAX_FDS];
@@ -490,11 +492,6 @@ static int io_uring_enter(struct submitter *s, unsigned int to_submit,
 #endif
 }
 
-static unsigned file_depth(struct submitter *s)
-{
-	return (depth + s->nr_files - 1) / s->nr_files;
-}
-
 static unsigned long long get_offset(struct submitter *s, struct file *f)
 {
 	unsigned long long offset;
@@ -516,7 +513,7 @@ static unsigned long long get_offset(struct submitter *s, struct file *f)
 	return offset;
 }
 
-static struct file *init_new_io(struct submitter *s)
+static struct file *get_next_file(struct submitter *s)
 {
 	struct file *f;
 
@@ -524,7 +521,7 @@ static struct file *init_new_io(struct submitter *s)
 		f = &s->files[0];
 	} else {
 		f = &s->files[s->cur_file];
-		if (f->pending_ios >= file_depth(s)) {
+		if (f->pending_ios >= s->per_file_depth) {
 			s->cur_file++;
 			if (s->cur_file == s->nr_files)
 				s->cur_file = 0;
@@ -546,7 +543,7 @@ static void init_io(struct submitter *s, unsigned index)
 		return;
 	}
 
-	f = init_new_io(s);
+	f = get_next_file(s);
 
 	if (register_files) {
 		sqe->flags = IOSQE_FIXED_FILE;
@@ -587,7 +584,7 @@ static void init_io_pt(struct submitter *s, unsigned index)
 	unsigned long long slba;
 	unsigned long long nlb;
 
-	f = init_new_io(s);
+	f = get_next_file(s);
 
 	offset = get_offset(s, f);
 
@@ -717,10 +714,14 @@ static int reap_events_uring(struct submitter *s)
 			f = &s->files[fileno];
 			f->pending_ios--;
 			if (cqe->res != bs) {
-				printf("io: unexpected ret=%d\n", cqe->res);
-				if (polled && cqe->res == -EOPNOTSUPP)
-					printf("Your filesystem/driver/kernel doesn't support polled IO\n");
-				return -1;
+				if (cqe->res == -ENODATA || cqe->res == -EIO) {
+					s->io_errors++;
+				} else {
+					printf("io: unexpected ret=%d\n", cqe->res);
+					if (polled && cqe->res == -EOPNOTSUPP)
+						printf("Your filesystem/driver/kernel doesn't support polled IO\n");
+					return -1;
+				}
 			}
 		}
 		if (stats) {
@@ -867,6 +868,7 @@ static int setup_aio(struct submitter *s)
 		fixedbufs = register_files = 0;
 	}
 
+	s->per_file_depth = (depth + s->nr_files - 1) / s->nr_files;
 	return io_queue_init(roundup_pow2(depth), &s->aio_ctx);
 #else
 	fprintf(stderr, "Legacy AIO not available on this system/build\n");
@@ -971,6 +973,7 @@ static int setup_ring(struct submitter *s)
 	for (i = 0; i < p.sq_entries; i++)
 		sring->array[i] = i;
 
+	s->per_file_depth = (depth + s->nr_files - 1) / s->nr_files;
 	return 0;
 }
 
@@ -997,8 +1000,8 @@ static int submitter_init(struct submitter *s)
 	static int init_printed;
 	char buf[80];
 	s->tid = gettid();
-	printf("submitter=%d, tid=%d, file=%s, node=%d\n", s->index, s->tid,
-							s->filename, s->numa_node);
+	printf("submitter=%d, tid=%d, file=%s, nfiles=%d, node=%d\n", s->index, s->tid,
+							s->filename, s->nr_files, s->numa_node);
 
 	set_affinity(s);
 
@@ -1077,7 +1080,7 @@ static int prep_more_ios_aio(struct submitter *s, int max_ios, struct iocb *iocb
 	while (index < max_ios) {
 		struct iocb *iocb = &iocbs[index];
 
-		f = init_new_io(s);
+		f = get_next_file(s);
 
 		io_prep_pread(iocb, f->real_fd, s->iovecs[index].iov_base,
 				s->iovecs[index].iov_len, get_offset(s, f));
@@ -1102,10 +1105,14 @@ static int reap_events_aio(struct submitter *s, struct io_event *events, int evs
 
 		f->pending_ios--;
 		if (events[reaped].res != bs) {
-			printf("io: unexpected ret=%ld\n", events[reaped].res);
-			return -1;
-		}
-		if (stats) {
+			if (events[reaped].res == -ENODATA ||
+			    events[reaped].res == -EIO) {
+				s->io_errors++;
+			} else {
+				printf("io: unexpected ret=%ld\n", events[reaped].res);
+				return -1;
+			}
+		} else if (stats) {
 			int clock_index = data >> 32;
 
 			if (last_idx != clock_index) {
@@ -1379,7 +1386,7 @@ static void *submitter_sync_fn(void *data)
 		uint64_t offset;
 		struct file *f;
 
-		f = init_new_io(s);
+		f = get_next_file(s);
 
 #ifdef ARCH_HAVE_CPU_CLOCK
 		if (stats)
@@ -1550,7 +1557,7 @@ static void write_tsc_rate(void)
 int main(int argc, char *argv[])
 {
 	struct submitter *s;
-	unsigned long done, calls, reap;
+	unsigned long done, calls, reap, io_errors;
 	int i, j, flags, fd, opt, threads_per_f, threads_rem = 0, nfiles;
 	struct file f;
 	void *ret;
@@ -1661,7 +1668,7 @@ int main(int argc, char *argv[])
 		s = get_submitter(j);
 		s->numa_node = -1;
 		s->index = j;
-		s->done = s->calls = s->reaps = 0;
+		s->done = s->calls = s->reaps = s->io_errors = 0;
 	}
 
 	flags = O_RDONLY | O_NOATIME;
@@ -1746,11 +1753,12 @@ int main(int argc, char *argv[])
 #endif
 	}
 
-	reap = calls = done = 0;
+	reap = calls = done = io_errors = 0;
 	do {
 		unsigned long this_done = 0;
 		unsigned long this_reap = 0;
 		unsigned long this_call = 0;
+		unsigned long this_io_errors = 0;
 		unsigned long rpc = 0, ipc = 0;
 		unsigned long iops, bw;
 
@@ -1771,6 +1779,7 @@ int main(int argc, char *argv[])
 			this_done += s->done;
 			this_call += s->calls;
 			this_reap += s->reaps;
+			this_io_errors += s->io_errors;
 		}
 		if (this_call - calls) {
 			rpc = (this_done - done) / (this_call - calls);
@@ -1778,6 +1787,7 @@ int main(int argc, char *argv[])
 		} else
 			rpc = ipc = -1;
 		iops = this_done - done;
+		iops -= this_io_errors - io_errors;
 		if (bs > 1048576)
 			bw = iops * (bs / 1048576);
 		else
@@ -1805,6 +1815,7 @@ int main(int argc, char *argv[])
 		done = this_done;
 		calls = this_call;
 		reap = this_reap;
+		io_errors = this_io_errors;
 	} while (!finish);
 
 	for (j = 0; j < nthreads; j++) {
@@ -1812,6 +1823,9 @@ int main(int argc, char *argv[])
 		pthread_join(s->thread, &ret);
 		close(s->ring_fd);
 
+		if (s->io_errors)
+			printf("%d: %lu IO errors\n", s->tid, s->io_errors);
+
 		if (stats) {
 			unsigned long nr;
 
diff --git a/t/nvmept_trim.py b/t/nvmept_trim.py
new file mode 100755
index 00000000..57568384
--- /dev/null
+++ b/t/nvmept_trim.py
@@ -0,0 +1,586 @@
+#!/usr/bin/env python3
+#
+# Copyright 2024 Samsung Electronics Co., Ltd All Rights Reserved
+#
+# For conditions of distribution and use, see the accompanying COPYING file.
+#
+"""
+# nvmept_trim.py
+#
+# Test fio's io_uring_cmd ioengine with NVMe pass-through dataset management
+# commands that trim multiple ranges.
+#
+# USAGE
+# see python3 nvmept_trim.py --help
+#
+# EXAMPLES
+# python3 t/nvmept_trim.py --dut /dev/ng0n1
+# python3 t/nvmept_trim.py --dut /dev/ng1n1 -f ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+#
+"""
+import os
+import sys
+import time
+import logging
+import argparse
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_NONZERO
+
+
+class TrimTest(FioJobCmdTest):
+    """
+    NVMe pass-through test class. Check to make sure output for selected data
+    direction(s) is non-zero and that zero data appears for other directions.
+    """
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        fio_args = [
+            "--name=nvmept-trim",
+            "--ioengine=io_uring_cmd",
+            "--cmd_type=nvme",
+            f"--filename={self.fio_opts['filename']}",
+            f"--rw={self.fio_opts['rw']}",
+            f"--output={self.filenames['output']}",
+            f"--output-format={self.fio_opts['output-format']}",
+        ]
+        for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
+                    'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
+                    'time_based', 'runtime', 'verify', 'io_size', 'num_range',
+                    'iodepth', 'iodepth_batch', 'iodepth_batch_complete',
+                    'size', 'rate', 'bs', 'bssplit', 'bsrange', 'randrepeat',
+                    'buffer_pattern', 'verify_pattern', 'verify', 'offset']:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+
+        super().setup(fio_args)
+
+
+    def check_result(self):
+
+        super().check_result()
+
+        if 'rw' not in self.fio_opts or \
+                not self.passed or \
+                'json' not in self.fio_opts['output-format']:
+            return
+
+        job = self.json_data['jobs'][0]
+
+        if self.fio_opts['rw'] in ['read', 'randread']:
+            self.passed = self.check_all_ddirs(['read'], job)
+        elif self.fio_opts['rw'] in ['write', 'randwrite']:
+            if 'verify' not in self.fio_opts:
+                self.passed = self.check_all_ddirs(['write'], job)
+            else:
+                self.passed = self.check_all_ddirs(['read', 'write'], job)
+        elif self.fio_opts['rw'] in ['trim', 'randtrim']:
+            self.passed = self.check_all_ddirs(['trim'], job)
+        elif self.fio_opts['rw'] in ['readwrite', 'randrw']:
+            self.passed = self.check_all_ddirs(['read', 'write'], job)
+        elif self.fio_opts['rw'] in ['trimwrite', 'randtrimwrite']:
+            self.passed = self.check_all_ddirs(['trim', 'write'], job)
+        else:
+            logging.error("Unhandled rw value %s", self.fio_opts['rw'])
+            self.passed = False
+
+        if 'iodepth' in self.fio_opts:
+            # We will need to figure something out if any test uses an iodepth
+            # different from 8
+            if job['iodepth_level']['8'] < 95:
+                logging.error("Did not achieve requested iodepth")
+                self.passed = False
+            else:
+                logging.debug("iodepth 8 target met %s", job['iodepth_level']['8'])
+
+
+class RangeTrimTest(TrimTest):
+    """
+    Multi-range trim test class.
+    """
+
+    def get_bs(self):
+        """Calculate block size and determine whether bs will be an average or exact."""
+
+        if 'bs' in self.fio_opts:
+            exact_size = True
+            bs = self.fio_opts['bs']
+        elif 'bssplit' in self.fio_opts:
+            exact_size = False
+            bs = 0
+            total = 0
+            for split in self.fio_opts['bssplit'].split(':'):
+                [blocksize, share] = split.split('/')
+                total += int(share)
+                bs += int(blocksize) * int(share) / 100
+            if total != 100:
+                logging.error("bssplit '%s' total percentage is not 100", self.fio_opts['bssplit'])
+                self.passed = False
+            else:
+                logging.debug("bssplit: average block size is %d", int(bs))
+            # The only check we do here for bssplit is to calculate an average
+            # blocksize and see if the IOPS and bw are consistent
+        elif 'bsrange' in self.fio_opts:
+            exact_size = False
+            [minbs, maxbs] = self.fio_opts['bsrange'].split('-')
+            minbs = int(minbs)
+            maxbs = int(maxbs)
+            bs = int((minbs + maxbs) / 2)
+            logging.debug("bsrange: average block size is %d", int(bs))
+            # The only check we do here for bsrange is to calculate an average
+            # blocksize and see if the IOPS and bw are consistent
+        else:
+            exact_size = True
+            bs = 4096
+
+        return bs, exact_size
+
+
+    def check_result(self):
+        """
+        Make sure that the number of IO requests is consistent with the
+        blocksize and num_range values. In other words, if the blocksize is
+        4KiB and num_range is 2, we should have 128 IO requests to trim 1MiB.
+        """
+        # TODO Enable debug output to check the actual offsets
+
+        super().check_result()
+
+        if not self.passed or 'json' not in self.fio_opts['output-format']:
+            return
+
+        job = self.json_data['jobs'][0]['trim']
+        bs, exact_size = self.get_bs()
+
+        # make sure bw and IOPS are consistent
+        bw = job['bw_bytes']
+        iops = job['iops']
+        runtime = job['runtime']
+
+        calculated = int(bw*runtime/1000)
+        expected = job['io_bytes']
+        if abs(calculated - expected) / expected > 0.05:
+            logging.error("Total bytes %d from bw does not match reported total bytes %d",
+                          calculated, expected)
+            self.passed = False
+        else:
+            logging.debug("Total bytes %d from bw matches reported total bytes %d", calculated,
+                          expected)
+
+        calculated = int(iops*runtime/1000*bs*self.fio_opts['num_range'])
+        if abs(calculated - expected) / expected > 0.05:
+            logging.error("Total bytes %d from IOPS does not match reported total bytes %d",
+                          calculated, expected)
+            self.passed = False
+        else:
+            logging.debug("Total bytes %d from IOPS matches reported total bytes %d", calculated,
+                          expected)
+
+        if 'size' in self.fio_opts:
+            io_count = self.fio_opts['size'] / self.fio_opts['num_range'] / bs
+            if exact_size:
+                delta = 0.1
+            else:
+                delta = 0.05*job['total_ios']
+
+            if abs(job['total_ios'] - io_count) > delta:
+                logging.error("Expected numbers of IOs %d does not match actual value %d",
+                              io_count, job['total_ios'])
+                self.passed = False
+            else:
+                logging.debug("Expected numbers of IOs %d matches actual value %d", io_count,
+                              job['total_ios'])
+
+        if 'rate' in self.fio_opts:
+            if abs(bw - self.fio_opts['rate']) / self.fio_opts['rate'] > 0.05:
+                logging.error("Actual rate %f does not match expected rate %f", bw,
+                              self.fio_opts['rate'])
+                self.passed = False
+            else:
+                logging.debug("Actual rate %f matches expeected rate %f", bw, self.fio_opts['rate'])
+
+
+
+TEST_LIST = [
+    # The group of tests below checks existing use cases to make sure there are
+    # no regressions.
+    {
+        "test_id": 1,
+        "fio_opts": {
+            "rw": 'trim',
+            "time_based": 1,
+            "runtime": 3,
+            "output-format": "json",
+            },
+        "test_class": TrimTest,
+    },
+    {
+        "test_id": 2,
+        "fio_opts": {
+            "rw": 'randtrim',
+            "time_based": 1,
+            "runtime": 3,
+            "output-format": "json",
+            },
+        "test_class": TrimTest,
+    },
+    {
+        "test_id": 3,
+        "fio_opts": {
+            "rw": 'trim',
+            "time_based": 1,
+            "runtime": 3,
+            "iodepth": 8,
+            "iodepth_batch": 4,
+            "iodepth_batch_complete": 4,
+            "output-format": "json",
+            },
+        "test_class": TrimTest,
+    },
+    {
+        "test_id": 4,
+        "fio_opts": {
+            "rw": 'randtrim',
+            "time_based": 1,
+            "runtime": 3,
+            "iodepth": 8,
+            "iodepth_batch": 4,
+            "iodepth_batch_complete": 4,
+            "output-format": "json",
+            },
+        "test_class": TrimTest,
+    },
+    {
+        "test_id": 5,
+        "fio_opts": {
+            "rw": 'trimwrite',
+            "time_based": 1,
+            "runtime": 3,
+            "output-format": "json",
+            },
+        "test_class": TrimTest,
+    },
+    {
+        "test_id": 6,
+        "fio_opts": {
+            "rw": 'randtrimwrite',
+            "time_based": 1,
+            "runtime": 3,
+            "output-format": "json",
+            },
+        "test_class": TrimTest,
+    },
+    {
+        "test_id": 7,
+        "fio_opts": {
+            "rw": 'randtrim',
+            "time_based": 1,
+            "runtime": 3,
+            "fixedbufs": 0,
+            "nonvectored": 1,
+            "force_async": 1,
+            "registerfiles": 1,
+            "sqthread_poll": 1,
+            "fixedbuffs": 1,
+            "output-format": "json",
+            },
+        "test_class": TrimTest,
+    },
+    # The group of tests below try out the new functionality
+    {
+        "test_id": 100,
+        "fio_opts": {
+            "rw": 'trim',
+            "num_range": 2,
+            "size": 16*1024*1024,
+            "output-format": "json",
+            },
+        "test_class": RangeTrimTest,
+    },
+    {
+        "test_id": 101,
+        "fio_opts": {
+            "rw": 'randtrim',
+            "num_range": 2,
+            "size": 16*1024*1024,
+            "output-format": "json",
+            },
+        "test_class": RangeTrimTest,
+    },
+    {
+        "test_id": 102,
+        "fio_opts": {
+            "rw": 'randtrim',
+            "num_range": 256,
+            "size": 64*1024*1024,
+            "output-format": "json",
+            },
+        "test_class": RangeTrimTest,
+    },
+    {
+        "test_id": 103,
+        "fio_opts": {
+            "rw": 'trim',
+            "num_range": 2,
+            "bs": 16*1024,
+            "size": 32*1024*1024,
+            "output-format": "json",
+            },
+        "test_class": RangeTrimTest,
+    },
+    {
+        "test_id": 104,
+        "fio_opts": {
+            "rw": 'randtrim',
+            "num_range": 2,
+            "bs": 16*1024,
+            "size": 32*1024*1024,
+            "output-format": "json",
+            },
+        "test_class": RangeTrimTest,
+    },
+    {
+        "test_id": 105,
+        "fio_opts": {
+            "rw": 'randtrim',
+            "num_range": 2,
+            "bssplit": "4096/50:16384/50",
+            "size": 80*1024*1024,
+            "output-format": "json",
+            "randrepeat": 0,
+            },
+        "test_class": RangeTrimTest,
+    },
+    {
+        "test_id": 106,
+        "fio_opts": {
+            "rw": 'randtrim',
+            "num_range": 4,
+            "bssplit": "4096/25:8192/25:12288/25:16384/25",
+            "size": 80*1024*1024,
+            "output-format": "json",
+            "randrepeat": 0,
+            },
+        "test_class": RangeTrimTest,
+    },
+    {
+        "test_id": 107,
+        "fio_opts": {
+            "rw": 'randtrim',
+            "num_range": 4,
+            "bssplit": "4096/20:8192/20:12288/20:16384/20:20480/20",
+            "size": 72*1024*1024,
+            "output-format": "json",
+            "randrepeat": 0,
+            },
+        "test_class": RangeTrimTest,
+    },
+    {
+        "test_id": 108,
+        "fio_opts": {
+            "rw": 'randtrim',
+            "num_range": 2,
+            "bsrange": "4096-16384",
+            "size": 80*1024*1024,
+            "output-format": "json",
+            "randrepeat": 0,
+            },
+        "test_class": RangeTrimTest,
+    },
+    {
+        "test_id": 109,
+        "fio_opts": {
+            "rw": 'randtrim',
+            "num_range": 4,
+            "bsrange": "4096-20480",
+            "size": 72*1024*1024,
+            "output-format": "json",
+            "randrepeat": 0,
+            },
+        "test_class": RangeTrimTest,
+    },
+    {
+        "test_id": 110,
+        "fio_opts": {
+            "rw": 'randtrim',
+            "time_based": 1,
+            "runtime": 10,
+            "rate": 1024*1024,
+            "num_range": 2,
+            "output-format": "json",
+            },
+        "test_class": RangeTrimTest,
+    },
+    # All of the tests below should fail
+    # TODO check the error messages resulting from the jobs below
+    {
+        "test_id": 200,
+        "fio_opts": {
+            "rw": 'randtrimwrite',
+            "time_based": 1,
+            "runtime": 10,
+            "rate": 1024*1024,
+            "num_range": 2,
+            "output-format": "normal",
+            },
+        "test_class": RangeTrimTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        "test_id": 201,
+        "fio_opts": {
+            "rw": 'trimwrite',
+            "time_based": 1,
+            "runtime": 10,
+            "rate": 1024*1024,
+            "num_range": 2,
+            "output-format": "normal",
+            },
+        "test_class": RangeTrimTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        "test_id": 202,
+        "fio_opts": {
+            "rw": 'trim',
+            "time_based": 1,
+            "runtime": 10,
+            "num_range": 257,
+            "output-format": "normal",
+            },
+        "test_class": RangeTrimTest,
+        "success": SUCCESS_NONZERO,
+    },
+    # The sequence of jobs below constitute a single test with multiple steps
+    # - write a data pattern
+    # - verify the data pattern
+    # - trim the first half of the LBA space
+    # - verify that the trim'd LBA space no longer returns the original data pattern
+    # - verify that the remaining LBA space has the expected pattern
+    {
+        "test_id": 300,
+        "fio_opts": {
+            "rw": 'write',
+            "output-format": 'json',
+            "buffer_pattern": 0x0f,
+            "size": 256*1024*1024,
+            },
+        "test_class": TrimTest,
+    },
+    {
+        "test_id": 301,
+        "fio_opts": {
+            "rw": 'read',
+            "output-format": 'json',
+            "verify_pattern": 0x0f,
+            "verify": "pattern",
+            "size": 256*1024*1024,
+            },
+        "test_class": TrimTest,
+    },
+    {
+        "test_id": 302,
+        "fio_opts": {
+            "rw": 'randtrim',
+            "num_range": 8,
+            "output-format": 'json',
+            "size": 128*1024*1024,
+            },
+        "test_class": TrimTest,
+    },
+    # The identify namespace data structure has a DLFEAT field which specifies
+    # what happens when reading data from deallocated blocks. There are three
+    # options:
+    # - read behavior not reported
+    # - deallocated logical block returns all bytes 0x0
+    # - deallocated logical block returns all bytes 0xff
+    # The test below merely checks that the original data pattern is not returned.
+    # Source: Figure 97 from
+    # https://nvmexpress.org/wp-content/uploads/NVM-Express-NVM-Command-Set-Specification-1.0c-2022.10.03-Ratified.pdf
+    {
+        "test_id": 303,
+        "fio_opts": {
+            "rw": 'read',
+            "output-format": 'json',
+            "verify_pattern": 0x0f,
+            "verify": "pattern",
+            "size": 128*1024*1024,
+            },
+        "test_class": TrimTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        "test_id": 304,
+        "fio_opts": {
+            "rw": 'read',
+            "output-format": 'json',
+            "verify_pattern": 0x0f,
+            "verify": "pattern",
+            "offset": 128*1024*1024,
+            "size": 128*1024*1024,
+            },
+        "test_class": TrimTest,
+    },
+]
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
+    parser.add_argument('--dut', help='target NVMe character device to test '
+                        '(e.g., /dev/ng0n1). WARNING: THIS IS A DESTRUCTIVE TEST', required=True)
+    args = parser.parse_args()
+
+    return args
+
+
+def main():
+    """Run tests using fio's io_uring_cmd ioengine to send NVMe pass through commands."""
+
+    args = parse_args()
+
+    if args.debug:
+        logging.basicConfig(level=logging.DEBUG)
+    else:
+        logging.basicConfig(level=logging.INFO)
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"nvmept-trim-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = 'fio'
+    print(f"fio path is {fio_path}")
+
+    for test in TEST_LIST:
+        test['fio_opts']['filename'] = args.dut
+
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'nvmept-trim',
+              }
+
+    _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
+    sys.exit(failed)
+
+
+if __name__ == '__main__':
+    main()
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 2f76d3fc..d4742e96 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -981,6 +981,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.nvmecdev],
     },
+    {
+        'test_id':          1015,
+        'test_class':       FioExeTest,
+        'exe':              't/nvmept_trim.py',
+        'parameters':       ['-f', '{fio_path}', '--dut', '{nvmecdev}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [Requirements.linux, Requirements.nvmecdev],
+    },
 ]
 
 
diff --git a/thread_options.h b/thread_options.h
index 24f695fe..c2e71518 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -353,6 +353,8 @@ struct thread_options {
 	unsigned long long offset_increment;
 	unsigned long long number_ios;
 
+	unsigned int num_range;
+
 	unsigned int sync_file_range;
 
 	unsigned long long latency_target;
@@ -711,6 +713,7 @@ struct thread_options_pack {
 	uint32_t fdp_plis[FIO_MAX_PLIS];
 	uint32_t fdp_nrpli;
 
+	uint32_t num_range;
 	/*
 	 * verify_pattern followed by buffer_pattern from the unpacked struct
 	 */
