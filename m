Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347B03DC4D5
	for <fio@vger.kernel.org>; Thu, 25 Jun 2026 12:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782388818; cv=none; b=qezcIEnvHSvbVpn1hTudg5f0nDmXBjiRQXSbKT6dWDVg2zP7ojq+O6g76WV44cFqzaGz3yp/+0PhpA92bR1XaPfnBCRMUU0B7BLqLuiipqoZjcHguGJu5skq2KmqK8r6pijJsxmtRW1qHx+qIZ6Rf1U0n8dvOPOZaPe93PUUlLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782388818; c=relaxed/simple;
	bh=5o8csDjXhAo8h0itE7muDPHdvZbrxpDyf/MRvzKN8gE=;
	h=Subject:From:To:Date:Message-Id; b=bO/zdnEC484LHaI+f0plvd+cC2/nsye75W7hbcVEjf4XjS+knxNSIUnFzhIjemja8jhKWN3GtTJAPpQr/8hViS2QTlGdiSXIeQADr9sxAmij0LsJHWkeu2ZQkodImHp4RMYoytUhGfQkd2XbL0G1AUlD+UJke65s7lATxnXhPpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NFkXnb8M; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NFkXnb8M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=rNjG5S2a9HBmKBB5q1yFv8b544R+FMaZFoENmSa89s8=; b=NFkXnb8MlHVwmYfs3Imq6jJL4F
	B/PPnpUxwJ2WRa729hUaiUhmS6e1OLYew8e9lqr5nk/e0WsQNeiX8IM4UVjAH/NS43NIDXOX02ILh
	osgJQ9N5TZM59S8mNumpg2PgrLe0F0+GniR2tItyMdVRBtsNBYXSsQab+DLCZqV4yJWSkPdj56VbK
	iihRzUEEGg1aQqpM5IgFYVbCRi2c9wafi/oaSL0w3yO/kmh+FTWPoeus3G2Cfaipu6gkftxg/ErDL
	v/ml/uMwSPQYq/VVj6Osyt9VghSVcxtyUGB4xoUI2OWNmFLY634RHo5kitmva6q3UP2B/5RkCicsW
	YBrg4oyQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wcikW-00000003ZeX-14RC
	for fio@vger.kernel.org;
	Thu, 25 Jun 2026 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 5E2C71BC0156; Thu, 25 Jun 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 25 Jun 2026 06:00:01 -0600
Message-Id: <20260625120001.5E2C71BC0156@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 2c69e8e9b67c0e8967cb1b9e67a74ef55ef9d027:

  test: run QEMU tests on push and pull request (2026-06-23 16:36:52 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d72bcf71534b5ac82359e3b987ff109b0de57af0:

  t/io_uring_cmd: better default for fio executable (2026-06-24 13:25:19 -0400)

----------------------------------------------------------------
Jungwon Lee (2):
      engines/io_uring: Separate NVMe-specific logic
      engines/io_uring: Add bsg support for io_uring_cmd engine

Kyoungrul Kim (1):
      engines/sg: extract BE accessor helpers into shared sg.h

Vincent Fu (6):
      Merge branch 'upstream-io_uring-bsg' of https://github.com/ljw8161/fio
      engines/io_uring: add missing curly braces
      t/io_uring_cmd: rename from t/nvmept.py
      t/io_uring_cmd: support more cmd_types
      t/io_uring_cmd: add a writefua/readfua test
      t/io_uring_cmd: better default for fio executable

 HOWTO.rst                        |   2 +-
 Makefile                         |   5 +-
 configure                        |  17 ++
 engines/bsg.c                    | 169 ++++++++++++++
 engines/bsg.h                    |  67 ++++++
 engines/io_uring.c               | 468 ++++++++++++++++++++++++++-------------
 engines/sg.c                     |  37 +---
 engines/sg.h                     |  47 ++++
 examples/uring-cmd-bsg.fio       |  31 +++
 examples/uring-cmd-bsg.png       | Bin 0 -> 146241 bytes
 fio.1                            |   2 +-
 t/{nvmept.py => io_uring_cmd.py} |  43 +++-
 t/run-fio-tests.py               |   2 +-
 13 files changed, 682 insertions(+), 208 deletions(-)
 create mode 100644 engines/bsg.c
 create mode 100644 engines/bsg.h
 create mode 100644 engines/sg.h
 create mode 100644 examples/uring-cmd-bsg.fio
 create mode 100644 examples/uring-cmd-bsg.png
 rename t/{nvmept.py => io_uring_cmd.py} (90%)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index ac570972..ef079214 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2564,7 +2564,7 @@ with the caveat that when used on the command line, they must come after the
 .. option:: cmd_type=str : [io_uring_cmd]
 
 	Specifies the type of uring passthrough command to be used. Supported
-	value is nvme. Default is nvme.
+	values are nvme and bsg. Default is nvme.
 
 .. option:: hipri
 
diff --git a/Makefile b/Makefile
index e3960ece..4f87adba 100644
--- a/Makefile
+++ b/Makefile
@@ -218,7 +218,8 @@ ifdef CONFIG_LIBBLKIO
 endif
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
-		oslib/linux-dev-lookup.c engines/io_uring.c engines/nvme.c
+		oslib/linux-dev-lookup.c engines/io_uring.c engines/nvme.c \
+		engines/bsg.c
   cmdprio_SRCS = engines/cmdprio.c
 ifdef CONFIG_HAS_BLKZONED
   SOURCE += oslib/linux-blkzoned.c
@@ -229,7 +230,7 @@ endif
 ifeq ($(CONFIG_TARGET_OS), Android)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c profiles/tiobench.c \
 		oslib/linux-dev-lookup.c engines/io_uring.c engines/nvme.c \
-		engines/sg.c
+		engines/sg.c engines/bsg.c
   cmdprio_SRCS = engines/cmdprio.c
 ifdef CONFIG_HAS_BLKZONED
   SOURCE += oslib/linux-blkzoned.c
diff --git a/configure b/configure
index 664ce299..cdfefa59 100755
--- a/configure
+++ b/configure
@@ -2707,6 +2707,23 @@ fi
 print_config "NVMe uring command support" "$nvme_uring_cmd"
 fi
 
+##########################################
+# Check BSG_URING_CMD support
+cat > $TMPC << EOF
+#include <linux/bsg.h>
+int main(void)
+{
+  return sizeof(struct bsg_uring_cmd);
+}
+EOF
+if compile_prog "" "" "bsg uring cmd"; then
+  output_sym "CONFIG_BSG_URING_CMD"
+  bsg_uring_cmd="yes"
+else
+  bsg_uring_cmd="no"
+fi
+print_config "BSG uring command support" "$bsg_uring_cmd"
+
 ##########################################
 # Check if we have xnvme
 if test "$xnvme" != "no" ; then
diff --git a/engines/bsg.c b/engines/bsg.c
new file mode 100644
index 00000000..372212ef
--- /dev/null
+++ b/engines/bsg.c
@@ -0,0 +1,169 @@
+#include "bsg.h"
+
+int fio_bsg_uring_cmd_read_capacity(struct thread_data *td, unsigned int *bs,
+				    unsigned long long *max_lba)
+{
+	struct sg_io_v4 hdr = { 0 };
+	unsigned long long hlba;
+	unsigned int blksz = 0;
+	unsigned char cmd[16];
+	unsigned char sb[64];
+	unsigned char buf[32];
+	int ret;
+	int fd = -1;
+
+	struct fio_file *f = td->files[0];
+
+	/* open file independent of rest of application */
+	fd = open(f->file_name, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	memset(cmd, 0, sizeof(cmd));
+	memset(sb, 0, sizeof(sb));
+	memset(buf, 0, sizeof(buf));
+
+	cmd[0] = bsg_cmd_read_capacity_10;
+	hdr.guard = 'Q';
+	hdr.protocol = 0;
+	hdr.subprotocol = 0;
+	hdr.response = (__u64)(uintptr_t) sb;
+	hdr.max_response_len = sizeof(sb);
+	hdr.request_len = sizeof(cmd);
+	hdr.request = (__u64)(uintptr_t) cmd;
+	hdr.din_xferp = (__u64)(uintptr_t) (buf);
+	hdr.din_xfer_len = sizeof(buf);
+
+	ret = ioctl(fd, SG_IO, &hdr);
+	if (ret < 0) {
+		close(fd);
+		return ret;
+	}
+
+	blksz = sgio_get_be32(&buf[4]);
+	hlba = sgio_get_be32(buf);
+
+	if (blksz) {
+		*bs = blksz;
+		*max_lba = hlba;
+		ret = 0;
+	} else {
+		ret = -EIO;
+	}
+
+	close(fd);
+	return ret;
+}
+
+int fio_bsg_uring_cmd_get_file_size(struct thread_data *td, struct fio_file *f)
+{
+	unsigned int bs = 0;
+	unsigned long long max_lba = 0;
+	int ret;
+
+	if (fio_file_size_known(f))
+		return 0;
+
+	if (f->filetype != FIO_TYPE_CHAR) {
+		td_verror(td, EINVAL, "wrong file type");
+		log_err("ioengine io_uring_cmd only works on character devices\n");
+		return 1;
+	}
+
+	ret = fio_bsg_uring_cmd_read_capacity(td, &bs, &max_lba);
+	if (ret) {
+		td_verror(td, td->error, "fio_bsg_uring_cmd_read_capacity");
+		log_err("ioengine io_uring_cmd unable to successfully execute "
+			"read capacity to get block size and maximum lba\n");
+		return 1;
+	}
+
+	f->real_file_size = (max_lba + 1) * bs;
+	fio_file_set_size_known(f);
+	return 0;
+}
+
+void fio_bsg_uring_cmd_init(struct bsg_uring_cmd *cmd, struct bsg_cmd *bc,
+			    struct io_u *io_u, int dxfer_dir)
+{
+	memset(cmd, 0, sizeof(*cmd));
+	memset(bc->cdb, 0, sizeof(bc->cdb));
+
+	cmd->request = (uint64_t)(uintptr_t) bc->cdb;
+	cmd->request_len = sizeof(bc->cdb);
+	cmd->response = (uint64_t)(uintptr_t) bc->sb;
+	cmd->max_response_len = sizeof(bc->sb);
+
+	if (dxfer_dir == SG_DXFER_TO_DEV) {
+		cmd->dout_xferp = (uint64_t)(uintptr_t) io_u->xfer_buf;
+		cmd->dout_xfer_len = io_u->xfer_buflen;
+	} else {
+		cmd->din_xferp = (uint64_t)(uintptr_t) io_u->xfer_buf;
+		cmd->din_xfer_len = io_u->xfer_buflen;
+	}
+}
+
+static int fio_bsg_uring_cmd_rw_lba(struct bsg_cmd *bc, unsigned long long lba,
+				    unsigned long long nlb)
+{
+	if (lba > MAX_10CDB_LBA || nlb > MAX_10CDB_NLB) {
+		log_err("offset or nlb is larger than the "
+			"maximum value of a field within CDB (10)\n");
+		return -EINVAL;
+	}
+	sgio_set_be32((uint32_t) lba, &bc->cdb[2]);
+	sgio_set_be16((uint16_t) nlb, &bc->cdb[7]);
+
+	return 0;
+}
+
+int fio_bsg_uring_cmd_prep(struct bsg_uring_cmd *cmd, struct io_u *io_u,
+			   struct bsg_cmd *bc, bool fua)
+{
+	struct bsg_data *data = FILE_ENG_DATA(io_u->file);
+	unsigned long long offset, nlb;
+	int data_len;
+
+	if (io_u->xfer_buflen & (data->bs - 1)) {
+		log_err("read/write not sector aligned\n");
+		return -EINVAL;
+	}
+
+	offset = io_u->offset / data->bs;
+	nlb = io_u->xfer_buflen / data->bs;
+
+	switch (io_u->ddir) {
+	case DDIR_READ:
+		fio_bsg_uring_cmd_init(cmd, bc, io_u, SG_DXFER_FROM_DEV);
+		bc->cdb[0] = bsg_cmd_read_10;
+		if (fua)
+			bc->cdb[1] |= 1 << 3;
+		break;
+	case DDIR_WRITE:
+		fio_bsg_uring_cmd_init(cmd, bc, io_u, SG_DXFER_TO_DEV);
+		bc->cdb[0] = bsg_cmd_write_10;
+		if (fua)
+			bc->cdb[1] |= 1 << 3;
+		break;
+	case DDIR_TRIM:
+		fio_bsg_uring_cmd_init(cmd, bc, io_u, SG_DXFER_TO_DEV);
+		bc->cdb[0] = bsg_cmd_unmap;
+		data_len = sizeof(bc->unmap_param) / sizeof(bc->unmap_param[0]);
+		sgio_set_be16((uint16_t) data_len, &bc->cdb[7]);
+		sgio_set_be16((uint16_t) data_len - 2, &bc->unmap_param[0]);
+		sgio_set_be16((uint16_t) data_len - 8, &bc->unmap_param[2]);
+		sgio_set_be64(offset, &bc->unmap_param[8]);
+		sgio_set_be32((uint32_t) nlb, &bc->unmap_param[16]);
+		cmd->dout_xferp = (uint64_t)(uintptr_t) bc->unmap_param;
+		cmd->dout_xfer_len = data_len;
+		return 0;
+	case DDIR_SYNC:
+		fio_bsg_uring_cmd_init(cmd, bc, io_u, SG_DXFER_NONE);
+		bc->cdb[0] = bsg_cmd_sync_cache_10;
+		return 0;
+	default:
+		return -ENOTSUP;
+	}
+
+	return fio_bsg_uring_cmd_rw_lba(bc, offset, nlb);
+}
diff --git a/engines/bsg.h b/engines/bsg.h
new file mode 100644
index 00000000..6a4bfd07
--- /dev/null
+++ b/engines/bsg.h
@@ -0,0 +1,67 @@
+/*
+ * bsg structure declarations and helper functions for the
+ * io_uring_cmd engine.
+ */
+
+#ifndef FIO_BSG_H
+#define FIO_BSG_H
+
+#include <linux/bsg.h>
+#include <poll.h>
+#include "../fio.h"
+#include "sg.h"
+
+/*
+ * If the uapi headers installed on the system lacks bsg uring command
+ * support, use the local version to prevent compilation issues.
+ */
+#ifndef CONFIG_BSG_URING_CMD
+struct bsg_uring_cmd {
+	__u64 request;
+	__u32 request_len;
+	__u32 protocol;
+	__u32 subprotocol;
+	__u32 max_response_len;
+	__u64 response;
+	__u64 dout_xferp;
+	__u32 dout_xfer_len;
+	__u32 dout_iovec_count;
+	__u64 din_xferp;
+	__u32 din_xfer_len;
+	__u32 din_iovec_count;
+	__u32 timeout_ms;
+	__u8  reserved[12];
+};
+#endif /* CONFIG_BSG_URING_CMD */
+
+#define MAX_SB 64
+#define MAX_10CDB_LBA  0xFFFFFFFFULL
+#define MAX_10CDB_NLB  0xFFFFU
+
+enum bsg_io_opcode {
+	bsg_cmd_read_10			= 0x28,
+	bsg_cmd_read_capacity_10	= 0x25,
+	bsg_cmd_sync_cache_10		= 0x35,
+	bsg_cmd_unmap			= 0x42,
+	bsg_cmd_write_10		= 0x2A,
+};
+
+struct bsg_cmd {
+	unsigned char cdb[16];
+	unsigned char sb[MAX_SB];
+	uint8_t unmap_param[24];
+};
+
+struct bsg_data {
+	unsigned int bs;
+};
+
+int fio_bsg_uring_cmd_read_capacity(struct thread_data *td, unsigned int *bs,
+				    unsigned long long *max_lba);
+
+int fio_bsg_uring_cmd_get_file_size(struct thread_data *td, struct fio_file *f);
+
+int fio_bsg_uring_cmd_prep(struct bsg_uring_cmd *cmd, struct io_u *io_u,
+			   struct bsg_cmd *bc, bool fua);
+
+#endif /* FIO_BSG_H */
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 0db7abd6..bd50cdca 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -25,6 +25,7 @@
 #include "cmdprio.h"
 #include "zbd.h"
 #include "nvme.h"
+#include "bsg.h"
 
 #include <sys/stat.h>
 
@@ -95,6 +96,7 @@ struct logical_block_metadata_cap {
 
 enum uring_cmd_type {
 	FIO_URING_CMD_NVME = 1,
+	FIO_URING_CMD_BSG,
 };
 
 enum uring_cmd_write_mode {
@@ -168,14 +170,19 @@ struct ioring_data {
 
 	struct cmdprio cmdprio;
 
-	struct nvme_dsm *dsm;
-	uint32_t cdw12_flags[DDIR_RWDIR_CNT];
 	uint8_t write_opcode;
 	struct frand_state wmode_state;
 
 	bool is_uring_cmd_eng;
 
+	/* NVMe */
+	struct nvme_dsm *dsm;
+	uint32_t cdw12_flags[DDIR_RWDIR_CNT];
 	struct nvme_cmd_ext_io_opts ext_opts;
+
+	/* BSG */
+	struct bsg_cmd *bc;
+	bool fua[DDIR_RWDIR_CNT];
 };
 
 struct ioring_options {
@@ -507,6 +514,10 @@ static struct fio_option options[] = {
 			    .oval = FIO_URING_CMD_NVME,
 			    .help = "Issue nvme-uring-cmd",
 			  },
+			  { .ival = "bsg",
+			    .oval = FIO_URING_CMD_BSG,
+			    .help = "Issue bsg-uring-cmd",
+			  },
 		},
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
@@ -713,20 +724,48 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
+static int fio_ioring_cmd_prep_write_split(struct thread_data *td,
+				  struct nvme_uring_cmd *cmd,
+				  struct io_u *io_u, struct iovec *iov)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	unsigned int rand = rand_between(&ld->wmode_state, 0, 99);
+	unsigned int perc = 0;
+	int i;
+
+	for (i = 0; i < (int)o->wmode_split_nr; i++) {
+		perc += o->wmode_split[i].perc;
+		if (rand < perc) {
+			uint8_t op = o->wmode_split[i].opcode;
+
+			io_u_clear(td, io_u, IO_U_F_TRIMMED | IO_U_F_ZEROED | IO_U_F_ERRORED);
+			if (op == nvme_cmd_write_zeroes) {
+				if (o->deac)
+					io_u_set(td, io_u, IO_U_F_TRIMMED);
+				else
+					io_u_set(td, io_u, IO_U_F_ZEROED);
+			} else if (op == nvme_cmd_write_uncor) {
+				io_u_set(td, io_u, IO_U_F_ERRORED);
+			}
+
+			dprint(FD_IO, "op selected %u\n", op);
+			return fio_nvme_uring_cmd_prep(cmd, io_u, iov, NULL,
+						       nvme_cmd_read, op, o->wmode_split[i].cdw12_flag);
+		}
+	}
+	return -EINVAL;
+}
+
 static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
 	struct fio_file *f = io_u->file;
-	struct nvme_uring_cmd *cmd;
 	struct io_uring_sqe *sqe;
-	struct nvme_dsm *dsm;
-	void *ptr = ld->dsm;
-	unsigned int dsm_size;
-	uint8_t read_opcode = nvme_cmd_read;
 
-	/* only supports nvme_uring_cmd */
-	if (o->cmd_type != FIO_URING_CMD_NVME)
+	/* only supports nvme_uring_cmd and bsg_uring_cmd */
+	if (o->cmd_type != FIO_URING_CMD_NVME && o->cmd_type != FIO_URING_CMD_BSG)
 		return -EINVAL;
 
 	if (io_u->ddir == DDIR_TRIM && td->io_ops->flags & FIO_ASYNCIO_SYNC_TRIM)
@@ -748,10 +787,6 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 
 	sqe->opcode = IORING_OP_URING_CMD;
 	sqe->user_data = (unsigned long) io_u;
-	if (o->nonvectored)
-		sqe->cmd_op = NVME_URING_CMD_IO;
-	else
-		sqe->cmd_op = NVME_URING_CMD_IO_VEC;
 	if (o->force_async && ++ld->prepped == o->force_async) {
 		ld->prepped = 0;
 		sqe->flags |= IOSQE_ASYNC;
@@ -761,55 +796,51 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 		sqe->buf_index = io_u->index;
 	}
 
-	cmd = (struct nvme_uring_cmd *)sqe->cmd;
-	dsm_size = sizeof(*ld->dsm) + td->o.num_range * sizeof(struct nvme_dsm_range);
-	ptr += io_u->index * dsm_size;
-	dsm = (struct nvme_dsm *)ptr;
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		struct nvme_uring_cmd *cmd;
+		struct nvme_dsm *dsm;
+		void *ptr = ld->dsm;
+		unsigned int dsm_size;
+		uint8_t read_opcode = nvme_cmd_read;
+
+		if (o->nonvectored)
+			sqe->cmd_op = NVME_URING_CMD_IO;
+		else
+			sqe->cmd_op = NVME_URING_CMD_IO_VEC;
 
-	/*
-	 * If READ command belongs to the verification phase and the
-	 * verify_mode=compare, convert READ to COMPARE command.
-	 */
-	if (io_u->flags & IO_U_F_VER_LIST && io_u->ddir == DDIR_READ &&
-			o->verify_mode == FIO_URING_CMD_VMODE_COMPARE) {
-		populate_verify_io_u(td, io_u);
-		read_opcode = nvme_cmd_compare;
-		io_u_set(td, io_u, IO_U_F_VER_IN_DEV);
-	}
+		cmd = (struct nvme_uring_cmd *)sqe->cmd;
+		dsm_size = sizeof(*ld->dsm) + td->o.num_range * sizeof(struct nvme_dsm_range);
+		ptr += io_u->index * dsm_size;
+		dsm = (struct nvme_dsm *)ptr;
 
-	if (o->wmode_split_nr > 1 && io_u->ddir == DDIR_WRITE) {
-		unsigned int rand = rand_between(&ld->wmode_state, 0, 99);
-		unsigned int perc = 0;
-		int i;
+		/*
+		 * If READ command belongs to the verification phase and the
+		 * verify_mode=compare, convert READ to COMPARE command.
+		 */
+		if (io_u->flags & IO_U_F_VER_LIST && io_u->ddir == DDIR_READ &&
+				o->verify_mode == FIO_URING_CMD_VMODE_COMPARE) {
+			populate_verify_io_u(td, io_u);
+			read_opcode = nvme_cmd_compare;
+			io_u_set(td, io_u, IO_U_F_VER_IN_DEV);
+		}
 
-		for (i = 0; i < (int)o->wmode_split_nr; i++) {
-			perc += o->wmode_split[i].perc;
-			if (rand < perc) {
-				uint8_t op = o->wmode_split[i].opcode;
+		if (o->wmode_split_nr > 1 && io_u->ddir == DDIR_WRITE) {
+			return fio_ioring_cmd_prep_write_split(td, cmd, io_u,
+					o->nonvectored ? NULL : &ld->iovecs[io_u->index]);
+		}
 
-				io_u_clear(td, io_u, IO_U_F_TRIMMED | IO_U_F_ZEROED | IO_U_F_ERRORED);
-				if (op == nvme_cmd_write_zeroes) {
-					if (o->deac)
-						io_u_set(td, io_u, IO_U_F_TRIMMED);
-					else
-						io_u_set(td, io_u, IO_U_F_ZEROED);
-				} else if (op == nvme_cmd_write_uncor) {
-					io_u_set(td, io_u, IO_U_F_ERRORED);
-				}
+		return fio_nvme_uring_cmd_prep(cmd, io_u,
+				o->nonvectored ? NULL : &ld->iovecs[io_u->index],
+				dsm, read_opcode, ld->write_opcode,
+				ld->cdw12_flags[io_u->ddir]);
+	} else {
+		struct bsg_uring_cmd *cmd;
 
-				dprint(FD_IO, "op selected %u\n", op);
-				return fio_nvme_uring_cmd_prep(cmd, io_u,
-					o->nonvectored ? NULL : &ld->iovecs[io_u->index],
-					dsm, read_opcode, op,
-					o->wmode_split[i].cdw12_flag);
-			}
-		}
-	}
+		sqe->len = io_u->xfer_buflen;
+		cmd = (struct bsg_uring_cmd *)sqe->cmd;
 
-	return fio_nvme_uring_cmd_prep(cmd, io_u,
-			o->nonvectored ? NULL : &ld->iovecs[io_u->index],
-			dsm, read_opcode, ld->write_opcode,
-			ld->cdw12_flags[io_u->ddir]);
+		return fio_bsg_uring_cmd_prep(cmd, io_u, &ld->bc[io_u->index], ld->fua[io_u->ddir]);
+	}
 }
 
 static void fio_ioring_validate_md(struct thread_data *td, struct io_u *io_u)
@@ -873,7 +904,7 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
 	int ret;
 
 	index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
-	if (o->cmd_type == FIO_URING_CMD_NVME)
+	if (o->cmd_type == FIO_URING_CMD_NVME || o->cmd_type == FIO_URING_CMD_BSG)
 		index <<= 1;
 
 	cqe = &ld->cq_ring.cqes[index];
@@ -890,6 +921,17 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
 			if (ret)
 				io_u->error = ret;
 		}
+	} else if (o->cmd_type == FIO_URING_CMD_BSG) {
+		/*
+		 * For bsg uring cmd, the big_cqe[0] in cqe contains the packed
+		 * SCSI status, where bits 0-7 hold the device status and bits 16-23
+		 * contaion the host status
+		 */
+		ret = (cqe->big_cqe[0] >> 16) & 0xff;
+		if (ret)
+			io_u->error = -ret;
+		else
+			io_u->error = cqe->big_cqe[0] & 0xff;
 	}
 
 ret:
@@ -909,8 +951,6 @@ static char *fio_ioring_cmd_errdetails(struct thread_data *td,
 				       struct io_u *io_u)
 {
 	struct ioring_options *o = td->eo;
-	unsigned int sct = (io_u->error >> 8) & 0x7;
-	unsigned int sc = io_u->error & 0xff;
 #define MAXERRDETAIL 1024
 #define MAXMSGCHUNK 128
 	char *msg, msgchunk[MAXMSGCHUNK];
@@ -925,6 +965,9 @@ static char *fio_ioring_cmd_errdetails(struct thread_data *td,
 	strlcat(msg, msgchunk, MAXERRDETAIL);
 
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		unsigned int sct = (io_u->error >> 8) & 0x7;
+		unsigned int sc = io_u->error & 0xff;
+
 		strlcat(msg, "cq entry status (", MAXERRDETAIL);
 
 		snprintf(msgchunk, MAXMSGCHUNK, "sct=0x%02x; ", sct);
@@ -932,6 +975,17 @@ static char *fio_ioring_cmd_errdetails(struct thread_data *td,
 
 		snprintf(msgchunk, MAXMSGCHUNK, "sc=0x%02x)", sc);
 		strlcat(msg, msgchunk, MAXERRDETAIL);
+	} else if (o->cmd_type == FIO_URING_CMD_BSG) {
+		unsigned int status = io_u->error & 0xff;
+		unsigned int host_status = (io_u->error >> 16) & 0xff;
+		if (status) {
+			snprintf(msgchunk, MAXMSGCHUNK, "BSG SCSI Status: 0x%02x; ", status);
+			strlcat(msg, msgchunk, MAXERRDETAIL);
+		}
+		if (host_status) {
+			snprintf(msgchunk, MAXMSGCHUNK, "BSG Host Status: 0x%02x; ", host_status);
+			strlcat(msg, msgchunk, MAXERRDETAIL);
+		}
 	} else {
 		/* Print status code in generic */
 		snprintf(msgchunk, MAXMSGCHUNK, "status=0x%x", io_u->error);
@@ -1018,11 +1072,19 @@ static inline void fio_ioring_setup_pi(struct thread_data *td,
 				      struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	struct fio_file *f = io_u->file;
 
 	if (io_u->ddir == DDIR_TRIM)
 		return;
 
-	fio_nvme_generate_guard(io_u, &ld->ext_opts);
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		fio_nvme_generate_guard(io_u, &ld->ext_opts);
+	}
+	else {
+		td_verror(td, EINVAL, "wrong cmd_type");
+		log_err("%s: This cmd_type does not support generate_guard\n", f->file_name);
+	}
 }
 
 static inline void fio_ioring_cmdprio_prep(struct thread_data *td,
@@ -1220,6 +1282,7 @@ static void fio_ioring_cleanup(struct thread_data *td)
 		free(ld->iovecs);
 		free(ld->fds);
 		free(ld->dsm);
+		free(ld->bc);
 		free(ld);
 	}
 }
@@ -1492,46 +1555,65 @@ static int fio_ioring_cmd_init(struct thread_data *td, struct ioring_data *ld)
 {
 	struct ioring_options *o = td->eo;
 
-	if (td_write(td)) {
-		if (o->wmode_split_nr > 1) {
-			int i;
-
-			init_rand_seed(&ld->wmode_state,
-				       td->rand_seeds[FIO_RAND_WMODE_OFF],
-				       false);
-			for (i = 0; i < (int)o->wmode_split_nr; i++) {
-				struct wmode_split_entry *e = &o->wmode_split[i];
-
-				e->cdw12_flag = 0;
-				if (e->opcode == nvme_cmd_write_zeroes && o->deac)
-					e->cdw12_flag = 1 << 25;
-				else if (e->opcode == nvme_cmd_write && o->writefua)
-					e->cdw12_flag = 1 << 30;
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		if (td_write(td)) {
+			if (o->wmode_split_nr > 1) {
+				int i;
+
+				init_rand_seed(&ld->wmode_state,
+					       td->rand_seeds[FIO_RAND_WMODE_OFF],
+					       false);
+				for (i = 0; i < (int)o->wmode_split_nr; i++) {
+					struct wmode_split_entry *e = &o->wmode_split[i];
+
+					e->cdw12_flag = 0;
+					if (e->opcode == nvme_cmd_write_zeroes && o->deac)
+						e->cdw12_flag = 1 << 25;
+					else if (e->opcode == nvme_cmd_write && o->writefua)
+						e->cdw12_flag = 1 << 30;
+				}
+			} else {
+				switch (o->write_mode) {
+				case FIO_URING_CMD_WMODE_UNCOR:
+					ld->write_opcode = nvme_cmd_write_uncor;
+					break;
+				case FIO_URING_CMD_WMODE_ZEROES:
+					ld->write_opcode = nvme_cmd_write_zeroes;
+					if (o->deac)
+						ld->cdw12_flags[DDIR_WRITE] = 1 << 25;
+					break;
+				case FIO_URING_CMD_WMODE_VERIFY:
+					ld->write_opcode = nvme_cmd_verify;
+					break;
+				default:
+					ld->write_opcode = nvme_cmd_write;
+					break;
+				}
 			}
-		} else {
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
+		}
+
+		if (o->readfua)
+			ld->cdw12_flags[DDIR_READ] = 1 << 30;
+		if (o->writefua && o->wmode_split_nr <= 1)
+			ld->cdw12_flags[DDIR_WRITE] = 1 << 30;
+	} else if (o->cmd_type == FIO_URING_CMD_BSG) {
+		ld->bc = calloc(td->o.iodepth, sizeof(struct bsg_cmd));
+
+		if (td_write(td)) {
+			if (o->write_mode == FIO_URING_CMD_WMODE_WRITE) {
+				ld->write_opcode = bsg_cmd_write_10;
+			} else {
+				log_err("Not Support Write mode in BSG io_uring_cmd\n");
+				td_verror(td, EINVAL, "fio_ioring_cmd_init");
+				return 1;
 			}
 		}
-	}
 
-	if (o->readfua)
-		ld->cdw12_flags[DDIR_READ] = 1 << 30;
-	if (o->writefua && o->wmode_split_nr <= 1)
-		ld->cdw12_flags[DDIR_WRITE] = 1 << 30;
+		if (o->readfua)
+			ld->fua[DDIR_READ] = 1;
+		if (o->writefua)
+			ld->fua[DDIR_WRITE] = 1;
+	}
 
 	return 0;
 }
@@ -1618,13 +1700,16 @@ static int fio_ioring_init(struct thread_data *td)
 		}
 
 	}
-	parse_prchk_flags(o);
-	ext_opts = &ld->ext_opts;
-	if (o->pi_act)
-		ext_opts->io_flags |= NVME_IO_PRINFO_PRACT;
-	ext_opts->io_flags |= o->prchk;
-	ext_opts->apptag = o->apptag;
-	ext_opts->apptag_mask = o->apptag_mask;
+	if ((ld->is_uring_cmd_eng && o->cmd_type == FIO_URING_CMD_NVME) ||
+			!ld->is_uring_cmd_eng) {
+		parse_prchk_flags(o);
+		ext_opts = &ld->ext_opts;
+		if (o->pi_act)
+			ext_opts->io_flags |= NVME_IO_PRINFO_PRACT;
+		ext_opts->io_flags |= o->prchk;
+		ext_opts->apptag = o->apptag;
+		ext_opts->apptag_mask = o->apptag_mask;
+	}
 
 	ld->iovecs = calloc(ld->iodepth, sizeof(struct iovec));
 
@@ -1643,7 +1728,7 @@ static int fio_ioring_init(struct thread_data *td)
 	if (td_trim(td) && td->o.zone_mode == ZONE_MODE_ZBD &&
 	    ld->is_uring_cmd_eng) {
 		td->io_ops->flags |= FIO_ASYNCIO_SYNC_TRIM;
-	} else {
+	} else if (o->cmd_type == FIO_URING_CMD_NVME) {
 		dsm_size = sizeof(*ld->dsm);
 		dsm_size += td->o.num_range * sizeof(struct nvme_dsm_range);
 		ld->dsm = calloc(td->o.iodepth, dsm_size);
@@ -1664,8 +1749,7 @@ static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
-	struct nvme_pi_data *pi_data;
-	char *p, *q;
+	char *p;
 
 	ld->io_u_index[io_u->index] = io_u;
 
@@ -1673,31 +1757,37 @@ static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 	p += o->md_per_io_size * io_u->index;
 	io_u->mmap_data = p;
 
-	if (ld->pi_attr) {
-		struct io_uring_attr_pi *pi_attr;
-
-		q = ld->pi_attr;
-		q += (sizeof(struct io_uring_attr_pi) * io_u->index);
-		io_u->pi_attr = q;
-
-		pi_attr = io_u->pi_attr;
-		pi_attr->len = o->md_per_io_size;
-		pi_attr->app_tag = o->apptag;
-		pi_attr->flags = 0;
-		if (o->prchk & NVME_IO_PRINFO_PRCHK_GUARD)
-			pi_attr->flags |= IO_INTEGRITY_CHK_GUARD;
-		if (o->prchk & NVME_IO_PRINFO_PRCHK_REF)
-			pi_attr->flags |= IO_INTEGRITY_CHK_REFTAG;
-		if (o->prchk & NVME_IO_PRINFO_PRCHK_APP)
-			pi_attr->flags |= IO_INTEGRITY_CHK_APPTAG;
-	}
+	if ((ld->is_uring_cmd_eng && o->cmd_type == FIO_URING_CMD_NVME) ||
+			!ld->is_uring_cmd_eng) {
+		struct nvme_pi_data *pi_data;
+		char *q;
+
+		if (ld->pi_attr) {
+			struct io_uring_attr_pi *pi_attr;
+
+			q = ld->pi_attr;
+			q += (sizeof(struct io_uring_attr_pi) * io_u->index);
+			io_u->pi_attr = q;
+
+			pi_attr = io_u->pi_attr;
+			pi_attr->len = o->md_per_io_size;
+			pi_attr->app_tag = o->apptag;
+			pi_attr->flags = 0;
+			if (o->prchk & NVME_IO_PRINFO_PRCHK_GUARD)
+				pi_attr->flags |= IO_INTEGRITY_CHK_GUARD;
+			if (o->prchk & NVME_IO_PRINFO_PRCHK_REF)
+				pi_attr->flags |= IO_INTEGRITY_CHK_REFTAG;
+			if (o->prchk & NVME_IO_PRINFO_PRCHK_APP)
+				pi_attr->flags |= IO_INTEGRITY_CHK_APPTAG;
+		}
 
-	if (!o->pi_act) {
-		pi_data = calloc(1, sizeof(*pi_data));
-		pi_data->io_flags |= o->prchk;
-		pi_data->apptag_mask = o->apptag_mask;
-		pi_data->apptag = o->apptag;
-		io_u->engine_data = pi_data;
+		if (!o->pi_act) {
+			pi_data = calloc(1, sizeof(*pi_data));
+			pi_data->io_flags |= o->prchk;
+			pi_data->apptag_mask = o->apptag_mask;
+			pi_data->apptag = o->apptag;
+			io_u->engine_data = pi_data;
+		}
 	}
 
 	if (ld->is_uring_cmd_eng && o->wmode_split_nr <= 1) {
@@ -1716,9 +1806,7 @@ static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 
 static void fio_ioring_io_u_free(struct thread_data *td, struct io_u *io_u)
 {
-	struct nvme_pi *pi = io_u->engine_data;
-
-	free(pi);
+	free(io_u->engine_data);
 	io_u->engine_data = NULL;
 }
 
@@ -1922,6 +2010,22 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 		ret = fio_ioring_open_nvme(td, f);
 		if (ret)
 			return ret;
+	} else if (o->cmd_type == FIO_URING_CMD_BSG) {
+		struct bsg_data *data;
+		unsigned int bs = 0;
+		unsigned long long last_lba = 0;
+		int ret;
+
+		data = FILE_ENG_DATA(f);
+		if (data == NULL) {
+			ret = fio_bsg_uring_cmd_read_capacity(td, &bs, &last_lba);
+			if (ret) {
+				return ret;
+			}
+			data = calloc(1, sizeof(struct bsg_data));
+			data->bs = bs;
+			FILE_SET_ENG_DATA(f, data);
+		}
 	}
 
 	return fio_ioring_open_file(td, f);
@@ -1944,11 +2048,11 @@ static int fio_ioring_cmd_close_file(struct thread_data *td,
 {
 	struct ioring_options *o = td->eo;
 
-	if (o->cmd_type == FIO_URING_CMD_NVME) {
-		struct nvme_data *data = FILE_ENG_DATA(f);
-
+	if (o->cmd_type == FIO_URING_CMD_NVME || o->cmd_type == FIO_URING_CMD_BSG) {
+		free(FILE_ENG_DATA(f));
 		FILE_SET_ENG_DATA(f, NULL);
-		free(data);
+	} else {
+		log_err("%s: This cmd_type does not support\n", f->file_name);
 	}
 
 	return fio_ioring_close_file(td, f);
@@ -1980,6 +2084,25 @@ static int fio_ioring_cmd_get_file_size(struct thread_data *td,
 			f->real_file_size = data->lba_size * nlba;
 		fio_file_set_size_known(f);
 
+		FILE_SET_ENG_DATA(f, data);
+		return 0;
+	} else if (o->cmd_type == FIO_URING_CMD_BSG) {
+		struct bsg_data *data = NULL;
+		unsigned int bs = 0;
+		unsigned long long last_lba = 0;
+		int ret;
+
+		ret = fio_bsg_uring_cmd_read_capacity(td, &bs, &last_lba);
+		if (ret) {
+			return ret;
+		}
+
+		f->real_file_size = (last_lba + 1) * bs;
+		fio_file_set_size_known(f);
+
+		data = calloc(1, sizeof(struct bsg_data));
+		data->bs = bs;
+
 		FILE_SET_ENG_DATA(f, data);
 		return 0;
 	}
@@ -2031,7 +2154,14 @@ static int fio_ioring_cmd_get_zoned_model(struct thread_data *td,
 					  struct fio_file *f,
 					  enum zbd_zoned_model *model)
 {
-	return fio_nvme_get_zoned_model(td, f, model);
+	struct ioring_options *o = td->eo;
+
+	if (o->cmd_type == FIO_URING_CMD_NVME)
+		return fio_nvme_get_zoned_model(td, f, model);
+
+	td_verror(td, EINVAL, "wrong cmd_type");
+	log_err("%s: This cmd_type does not support get_zoned_model\n", f->file_name);
+	return -EINVAL;
 }
 
 static int fio_ioring_cmd_report_zones(struct thread_data *td,
@@ -2039,45 +2169,73 @@ static int fio_ioring_cmd_report_zones(struct thread_data *td,
 				       struct zbd_zone *zbdz,
 				       unsigned int nr_zones)
 {
-	return fio_nvme_report_zones(td, f, offset, zbdz, nr_zones);
+	struct ioring_options *o = td->eo;
+
+	if (o->cmd_type == FIO_URING_CMD_NVME)
+		return fio_nvme_report_zones(td, f, offset, zbdz, nr_zones);
+
+	td_verror(td, EINVAL, "wrong cmd_type");
+	log_err("%s: This cmd_type does not support report_zones\n", f->file_name);
+	return -EINVAL;
 }
 
 static int fio_ioring_cmd_reset_wp(struct thread_data *td, struct fio_file *f,
 				   uint64_t offset, uint64_t length)
 {
-	return fio_nvme_reset_wp(td, f, offset, length);
+	struct ioring_options *o = td->eo;
+
+	if (o->cmd_type == FIO_URING_CMD_NVME)
+		return fio_nvme_reset_wp(td, f, offset, length);
+
+	td_verror(td, EINVAL, "wrong cmd_type");
+	log_err("%s: This cmd_type does not support reset_wp\n", f->file_name);
+	return -EINVAL;
 }
 
 static int fio_ioring_cmd_get_max_open_zones(struct thread_data *td,
 					     struct fio_file *f,
 					     unsigned int *max_open_zones)
 {
-	return fio_nvme_get_max_open_zones(td, f, max_open_zones);
+	struct ioring_options *o = td->eo;
+
+	if (o->cmd_type == FIO_URING_CMD_NVME)
+		return fio_nvme_get_max_open_zones(td, f, max_open_zones);
+
+	td_verror(td, EINVAL, "wrong cmd_type");
+	log_err("%s: This cmd_type does not support get_max_open_zones\n", f->file_name);
+	return -EINVAL;
 }
 
 static int fio_ioring_cmd_fetch_ruhs(struct thread_data *td, struct fio_file *f,
 				     struct fio_ruhs_info *fruhs_info)
 {
+	struct ioring_options *o = td->eo;
 	struct nvme_fdp_ruh_status *ruhs;
 	int bytes, nr_ruhs, ret, i;
 
-	nr_ruhs = fruhs_info->nr_ruhs;
-	bytes = sizeof(*ruhs) + fruhs_info->nr_ruhs * sizeof(struct nvme_fdp_ruh_status_desc);
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		nr_ruhs = fruhs_info->nr_ruhs;
+		bytes = sizeof(*ruhs) + fruhs_info->nr_ruhs * sizeof(struct nvme_fdp_ruh_status_desc);
 
-	ruhs = calloc(1, bytes);
-	if (!ruhs)
-		return -ENOMEM;
+		ruhs = calloc(1, bytes);
+		if (!ruhs)
+			return -ENOMEM;
 
-	ret = fio_nvme_iomgmt_ruhs(td, f, ruhs, bytes);
-	if (ret)
-		goto free;
+		ret = fio_nvme_iomgmt_ruhs(td, f, ruhs, bytes);
+		if (ret)
+			goto free;
 
-	fruhs_info->nr_ruhs = le16_to_cpu(ruhs->nruhsd);
-	for (i = 0; i < nr_ruhs; i++)
-		fruhs_info->plis[i] = le16_to_cpu(ruhs->ruhss[i].pid);
-free:
-	free(ruhs);
-	return ret;
+		fruhs_info->nr_ruhs = le16_to_cpu(ruhs->nruhsd);
+		for (i = 0; i < nr_ruhs; i++)
+			fruhs_info->plis[i] = le16_to_cpu(ruhs->ruhss[i].pid);
+	free:
+		free(ruhs);
+		return ret;
+	}
+
+	td_verror(td, EINVAL, "wrong cmd_type");
+	log_err("%s: This cmd_type does not support fetch_ruhs\n", f->file_name);
+	return -EINVAL;
 }
 
 static struct ioengine_ops ioengine_uring = {
diff --git a/engines/sg.c b/engines/sg.c
index 7912e9c8..bd81af78 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -57,6 +57,7 @@
 
 #include "../fio.h"
 #include "../optgroup.h"
+#include "sg.h"
 
 #ifdef FIO_HAVE_SGIO
 
@@ -217,42 +218,6 @@ struct sgio_data {
 #endif
 };
 
-static inline uint16_t sgio_get_be16(uint8_t *buf)
-{
-	return be16_to_cpu(*((uint16_t *) buf));
-}
-
-static inline uint32_t sgio_get_be32(uint8_t *buf)
-{
-	return be32_to_cpu(*((uint32_t *) buf));
-}
-
-static inline uint64_t sgio_get_be64(uint8_t *buf)
-{
-	return be64_to_cpu(*((uint64_t *) buf));
-}
-
-static inline void sgio_set_be16(uint16_t val, uint8_t *buf)
-{
-	uint16_t t = cpu_to_be16(val);
-
-	memcpy(buf, &t, sizeof(uint16_t));
-}
-
-static inline void sgio_set_be32(uint32_t val, uint8_t *buf)
-{
-	uint32_t t = cpu_to_be32(val);
-
-	memcpy(buf, &t, sizeof(uint32_t));
-}
-
-static inline void sgio_set_be64(uint64_t val, uint8_t *buf)
-{
-	uint64_t t = cpu_to_be64(val);
-
-	memcpy(buf, &t, sizeof(uint64_t));
-}
-
 static inline bool sgio_unbuffered(struct thread_data *td)
 {
 	return (td->o.odirect || td->o.sync_io);
diff --git a/engines/sg.h b/engines/sg.h
new file mode 100644
index 00000000..957e0f26
--- /dev/null
+++ b/engines/sg.h
@@ -0,0 +1,47 @@
+/*
+ * Shared inline helpers for SCSI byte-order accessors, used by both the
+ * sg and bsg/io_uring_cmd engines.
+ */
+
+#ifndef FIO_SG_H
+#define FIO_SG_H
+
+#include "../fio.h"
+
+static inline uint16_t sgio_get_be16(uint8_t *buf)
+{
+	return be16_to_cpu(*((uint16_t *) buf));
+}
+
+static inline uint32_t sgio_get_be32(uint8_t *buf)
+{
+	return be32_to_cpu(*((uint32_t *) buf));
+}
+
+static inline uint64_t sgio_get_be64(uint8_t *buf)
+{
+	return be64_to_cpu(*((uint64_t *) buf));
+}
+
+static inline void sgio_set_be16(uint16_t val, uint8_t *buf)
+{
+	uint16_t t = cpu_to_be16(val);
+
+	memcpy(buf, &t, sizeof(uint16_t));
+}
+
+static inline void sgio_set_be32(uint32_t val, uint8_t *buf)
+{
+	uint32_t t = cpu_to_be32(val);
+
+	memcpy(buf, &t, sizeof(uint32_t));
+}
+
+static inline void sgio_set_be64(uint64_t val, uint8_t *buf)
+{
+	uint64_t t = cpu_to_be64(val);
+
+	memcpy(buf, &t, sizeof(uint64_t));
+}
+
+#endif /* FIO_SG_H */
diff --git a/examples/uring-cmd-bsg.fio b/examples/uring-cmd-bsg.fio
new file mode 100644
index 00000000..d3d5f615
--- /dev/null
+++ b/examples/uring-cmd-bsg.fio
@@ -0,0 +1,31 @@
+# io_uring_cmd I/O engine for block SCSI generic character device
+
+[global]
+filename=/dev/bsg/0\:0\:0\:0
+ioengine=io_uring_cmd
+cmd_type=bsg
+size=1G
+iodepth=32
+bs=4KB
+stonewall=1
+
+[rand-write]
+rw=randwrite
+
+[rand-read]
+rw=randread
+
+[trimwrite]
+rw=trimwrite
+
+[writefua]
+rw=write
+writefua=1
+
+[readfua]
+rw=read
+readfua=1
+
+[fsync]
+rw=write
+fsync=1
diff --git a/examples/uring-cmd-bsg.png b/examples/uring-cmd-bsg.png
new file mode 100644
index 00000000..4202d3a2
Binary files /dev/null and b/examples/uring-cmd-bsg.png differ
diff --git a/fio.1 b/fio.1
index d2933a8f..bdb7662d 100644
--- a/fio.1
+++ b/fio.1
@@ -2347,7 +2347,7 @@ should be used for the polling thread.
 .TP
 .BI (io_uring_cmd)cmd_type \fR=\fPstr
 Specifies the type of uring passthrough command to be used. Supported
-value is nvme. Default is nvme.
+values are nvme and bsg. Default is nvme.
 .TP
 .BI (libaio)userspace_reap
 Normally, with the libaio engine in use, fio will use the
diff --git a/t/nvmept.py b/t/io_uring_cmd.py
similarity index 90%
rename from t/nvmept.py
rename to t/io_uring_cmd.py
index 3d90f4bf..a53f5627 100755
--- a/t/nvmept.py
+++ b/t/io_uring_cmd.py
@@ -1,15 +1,15 @@
 #!/usr/bin/env python3
 """
-# nvmept.py
+# io_uring_cmd.py
 #
 # Test fio's io_uring_cmd ioengine with NVMe pass-through commands.
 #
 # USAGE
-# see python3 nvmept.py --help
+# see python3 io_uring_cmd.py --help
 #
 # EXAMPLES
-# python3 t/nvmept.py --dut /dev/ng0n1
-# python3 t/nvmept.py --dut /dev/ng1n1 -f ./fio
+# python3 t/io_uring_cmd.py --dut /dev/ng0n1
+# python3 t/io_uring_cmd.py --dut /dev/ng1n1 -f ./fio
 #
 # REQUIREMENTS
 # Python 3.6
@@ -33,12 +33,12 @@ class PassThruTest(FioJobCmdTest):
         """Setup a test."""
 
         fio_args = [
-            "--name=nvmept",
+            "--name=io_uring_cmd",
             "--ioengine=io_uring_cmd",
-            "--cmd_type=nvme",
             "--iodepth=8",
             "--iodepth_batch=4",
             "--iodepth_batch_complete=4",
+            f"--cmd_type={self.fio_opts['cmd_type']}",
             f"--filename={self.fio_opts['filename']}",
             f"--rw={self.fio_opts['rw']}",
             f"--output={self.filenames['output']}",
@@ -46,7 +46,8 @@ class PassThruTest(FioJobCmdTest):
         ]
         for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
                     'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
-                    'time_based', 'runtime', 'verify', 'io_size']:
+                    'time_based', 'runtime', 'verify', 'io_size', 'readfua',
+                    'writefua', ]:
             if opt in self.fio_opts:
                 option = f"--{opt}={self.fio_opts[opt]}"
                 fio_args.append(option)
@@ -90,10 +91,10 @@ class PassThruTest(FioJobCmdTest):
 class FlushTest(FioJobCmdTest):
     def setup(self, parameters):
         fio_args = [
-            "--name=nvmept-flush",
+            "--name=io_uring_cmd-flush",
             "--ioengine=io_uring_cmd",
-            "--cmd_type=nvme",
             "--randrepeat=0",
+            f"--cmd_type={self.fio_opts['cmd_type']}",
             f"--filename={self.fio_opts['filename']}",
             f"--rw={self.fio_opts['rw']}",
             f"--output={self.filenames['output']}",
@@ -346,6 +347,21 @@ TEST_LIST = [
             },
         "test_class": FlushTest,
     },
+    #
+    # Run a test with writefua and readfua
+    #
+    {
+        "test_id": 20,
+        "fio_opts": {
+            "rw": 'randrw',
+            "writefua": 1,
+            "readfua": 1,
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "json",
+            },
+        "test_class": PassThruTest,
+    },
 ]
 
 def parse_args():
@@ -360,6 +376,8 @@ def parse_args():
                         help='list of test(s) to run, skipping all others')
     parser.add_argument('--dut', help='target NVMe character device to test '
                         '(e.g., /dev/ng0n1). WARNING: THIS IS A DESTRUCTIVE TEST', required=True)
+    parser.add_argument('-c', '--cmd_type', help='cmd_type for io_uring_cmd',
+                        default='nvme')
     args = parser.parse_args()
 
     return args
@@ -371,24 +389,25 @@ def main():
     args = parse_args()
 
     artifact_root = args.artifact_root if args.artifact_root else \
-        f"nvmept-test-{time.strftime('%Y%m%d-%H%M%S')}"
+        f"io_uring_cmd-test-{time.strftime('%Y%m%d-%H%M%S')}"
     os.mkdir(artifact_root)
     print(f"Artifact directory is {artifact_root}")
 
     if args.fio:
         fio_path = str(Path(args.fio).absolute())
     else:
-        fio_path = 'fio'
+        fio_path = os.path.join(str(Path(__file__).absolute().parent.parent), "fio")
     print(f"fio path is {fio_path}")
 
     for test in TEST_LIST:
         test['fio_opts']['filename'] = args.dut
+        test['fio_opts']['cmd_type'] = args.cmd_type
 
     test_env = {
               'fio_path': fio_path,
               'fio_root': str(Path(__file__).absolute().parent.parent),
               'artifact_root': artifact_root,
-              'basename': 'nvmept',
+              'basename': 'io_uring_cmd',
               }
 
     _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 35790120..aef2d026 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1086,7 +1086,7 @@ TEST_LIST = [
     {
         'test_id':          1014,
         'test_class':       FioExeTest,
-        'exe':              't/nvmept.py',
+        'exe':              't/io_uring_cmd.py',
         'parameters':       ['-f', '{fio_path}', '--dut', '{nvmecdev}'],
         'success':          SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.nvmecdev],
