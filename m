Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4536E3E5A3D
	for <fio@vger.kernel.org>; Fri, 26 Jun 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782475211; cv=none; b=Vxcft+PtRMPHww8JnWiRW//H3+q7+Mwy+esL1dP6ItTtDFfJWHbNH3TwYhlB6QdgZVaG9KuUD0T4jKZ6cijGRBmbXdjESvC+bioSmYuVOYbv00UPoB9YjHeD5RTwf4gcUXC+DJ7D8N5JsNGOfwqhuXlIly4aNr0ESi+XToCARw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782475211; c=relaxed/simple;
	bh=Bkn/WSr7END0OJa3a+Ni+yahIB9QMkQGeamXYqbxjRQ=;
	h=Subject:From:To:Date:Message-Id; b=DxDan65BtpjMUnLAHb0EpAIPFKXpx0RCzEzqyD6ngcwephj2HDWZxmXOgFvubhTp1/oGiKQX7P7E1qm+chOy+tnXkGQlLzpnZG1AHiqIAL03sF7x3fT7ZwsRWszB7nSuVJR+3eam9YugOd2SGx6xVyYtmZIkEYUd/YY6Bm9gUcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mlOmqw2r; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mlOmqw2r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ocyXMNG5HG9U/IEByEpRvgrzNiWwk7YojQyd6CkjriQ=; b=mlOmqw2rvBJrQrnSQh/NwmbTmr
	aycwllioVAv3w/oEMKRFGX2UHoMPzqEX0bAFByTE1N+1lyEhmFigEfqK2cMRVjR39S43nDT3oDzj0
	gl3QpXSNDQ5roEtnXr0aI9D6WP31aQ0nZkaTzidtb2N+5u2CZPZP6/BGyDj/WkaQWNrBKzNg9zoc4
	VjKJXdr5Pltc4meyprHPGCyjGNjI+wWPx5vi0NzH6AlyTRkjrH1xoL2QVOai1luvMPCcjU2PrEXDy
	nnSVDRvIELGJ2grBAYLoNiu89zK4iWxMT9i74bL0T0gwGpXTX47nwu9+NhkPpzyaC8KSdySTv+fU7
	+T31nt2g==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wd5E5-00000004oMf-0YO1
	for fio@vger.kernel.org;
	Fri, 26 Jun 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id A83BD1BC0177; Fri, 26 Jun 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri, 26 Jun 2026 06:00:01 -0600
Message-Id: <20260626120001.A83BD1BC0177@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit d72bcf71534b5ac82359e3b987ff109b0de57af0:

  t/io_uring_cmd: better default for fio executable (2026-06-24 13:25:19 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 360e4d6ae2fafcb17438df45499e514406f4d746:

  Merge branch 'master' of https://github.com/Krien/fio (2026-06-25 12:54:29 -0400)

----------------------------------------------------------------
Krijn Doekemeijer (2):
      io_uring: add fio_ioring_cmd_finish_zone when using uring_cmd
      io_uring: add support for zone appends when using ZBD

Vincent Fu (3):
      ci: split 16-bit Guard PI QEMU tests
      ci: split ZBD tests across configurations
      Merge branch 'master' of https://github.com/Krien/fio

 .github/workflows/qemu.yml          |  31 ++++++++++++++++++---
 HOWTO.rst                           |   3 ++
 engines/io_uring.c                  |  33 ++++++++++++++++++++--
 engines/nvme.c                      |  54 +++++++++++++++++++++++++++++++++++-
 engines/nvme.h                      |   5 ++++
 examples/uring-cmd-zoned-append.fio |  36 ++++++++++++++++++++++++
 examples/uring-cmd-zoned-append.png | Bin 0 -> 128287 bytes
 fio.1                               |   3 ++
 8 files changed, 157 insertions(+), 8 deletions(-)
 create mode 100644 examples/uring-cmd-zoned-append.fio
 create mode 100644 examples/uring-cmd-zoned-append.png

---

Diff of recent changes:

diff --git a/.github/workflows/qemu.yml b/.github/workflows/qemu.yml
index db90b03d..e01b4061 100644
--- a/.github/workflows/qemu.yml
+++ b/.github/workflows/qemu.yml
@@ -20,12 +20,19 @@ jobs:
               -device nvme-ns,id=nvm-0,drive=nvm-0,bus=nvme0,nsid=1
             test_cmd: "python3 t/run-fio-tests.py --nvmecdev /dev/ng0n1 --run-only 1014 1015 1022 -p '1022:--skip 30 31 32 33 34 40 50 51 53 70'"
             extra_pkgs: "nvme-cli"
-          - config: 16-bit Guard PI tests (long)
+          - config: 512 16-bit Guard PI tests (long)
             device: >-
               -device nvme,id=nvme0,serial=deadbeef
               -drive id=nvm-0,file=nvme0.img,format=raw,if=none,discard=unmap,media=disk
               -device nvme-ns,id=nvm-0,drive=nvm-0,bus=nvme0,nsid=1
-            test_cmd: "python3 t/nvmept_pi.py --fio ./fio --dut /dev/ng0n1"
+            test_cmd: "python3 t/nvmept_pi.py --fio ./fio --dut /dev/ng0n1 --lbaf 1 2 3"
+            extra_pkgs: "nvme-cli"
+          - config: 4K 16-bit Guard PI tests (long)
+            device: >-
+              -device nvme,id=nvme0,serial=deadbeef
+              -drive id=nvm-0,file=nvme0.img,format=raw,if=none,discard=unmap,media=disk
+              -device nvme-ns,id=nvm-0,drive=nvm-0,bus=nvme0,nsid=1
+            test_cmd: "python3 t/nvmept_pi.py --fio ./fio --dut /dev/ng0n1 --lbaf 5 6 7"
             extra_pkgs: "nvme-cli"
           - config: 4K+16 w/64-bit Guard PI
             device: >- # 4K+16 w/64-bit Guard PI
@@ -53,9 +60,25 @@ jobs:
             device:
             test_cmd: "python3 t/verify-trim.py"
             extra_pkgs: sg3-utils
-          - config: ZBD
+          - config: ZBD1-5
+            device:
+            test_cmd: "./t/zbd/run-tests-against-nullb -s 1 -s 2 -s 3 -s 4 -s 5"
+            extra_pkgs: sg3-utils
+          - config: ZBD6-10
+            device:
+            test_cmd: "./t/zbd/run-tests-against-nullb -s 6 -s 7 -s 8 -s 9 -s 10"
+            extra_pkgs: sg3-utils
+          - config: ZBD11-15
+            device:
+            test_cmd: "./t/zbd/run-tests-against-nullb -s 11 -s 12 -s 13 -s 14 -s 15"
+            extra_pkgs: sg3-utils
+          - config: ZBD16-20
+            device:
+            test_cmd: "./t/zbd/run-tests-against-nullb -s 16 -s 17 -s 18 -s 19 -s 20"
+            extra_pkgs: sg3-utils
+          - config: ZBD21-25
             device:
-            test_cmd: "./t/zbd/run-tests-against-nullb"
+            test_cmd: "./t/zbd/run-tests-against-nullb -s 21 -s 22 -s 23 -s 24 -s 25"
             extra_pkgs: sg3-utils
 
     env:
diff --git a/HOWTO.rst b/HOWTO.rst
index ef079214..f4663003 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3049,6 +3049,9 @@ with the caveat that when used on the command line, they must come after the
                 **verify**
                         Use Verify commands for write operations
 
+                **zone_append**
+                        Use zone append commands for write operations. Requires zonemode=zbd
+
         Multiple modes with mix ratios can be specified using the format
         ``mode/pct:mode/pct:...``.  Percentages must sum to 100.  If a
         percentage is omitted, the remaining percentage is split evenly among
diff --git a/engines/io_uring.c b/engines/io_uring.c
index bd50cdca..bc7e33da 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -100,13 +100,15 @@ enum uring_cmd_type {
 };
 
 enum uring_cmd_write_mode {
-	FIO_URING_CMD_WMODE_WRITE = 1,
+	FIO_URING_CMD_WMODE_WRITE = 0,
 	FIO_URING_CMD_WMODE_UNCOR,
 	FIO_URING_CMD_WMODE_ZEROES,
 	FIO_URING_CMD_WMODE_VERIFY,
+	FIO_URING_CMD_WMODE_ZONE_APPEND,
+	FIO_URING_CMD_WMODE_LAST
 };
 
-#define WMODE_SPLIT_MAX	4
+#define WMODE_SPLIT_MAX	FIO_URING_CMD_WMODE_LAST
 
 struct wmode_split_entry {
 	uint8_t		opcode;
@@ -236,6 +238,8 @@ static uint8_t wmode_str_to_opcode(const char *mode)
 		return nvme_cmd_write_zeroes;
 	if (!strcmp(mode, "verify"))
 		return nvme_cmd_verify;
+	if (!strcmp(mode, "zone_append"))
+		return nvme_zns_cmd_append;
 	return 0xff;
 }
 
@@ -261,6 +265,8 @@ static int str_write_mode_cb(void *data, const char *str)
 			o->write_mode = FIO_URING_CMD_WMODE_ZEROES;
 		else if (op == nvme_cmd_verify)
 			o->write_mode = FIO_URING_CMD_WMODE_VERIFY;
+		else if (op == nvme_zns_cmd_append)
+			o->write_mode = FIO_URING_CMD_WMODE_ZONE_APPEND;
 		else
 			o->write_mode = FIO_URING_CMD_WMODE_WRITE;
 		o->wmode_split_nr = 0;
@@ -402,7 +408,7 @@ static struct fio_option options[] = {
 		.lname	= "Write command type(s) with optional mix ratios",
 		.type	= FIO_OPT_STR,
 		.cb	= str_write_mode_cb,
-		.help	= "Single: write|uncor|zeroes|verify. "
+		.help	= "Single: write|uncor|zeroes|verify|zone_append. "
 			  "Mixed: mode/pct:mode/pct:... (e.g. write/60:zeroes/40). "
 			  "Blank pct evenly splits the remainder (e.g. write/50:zeroes/:uncor/)",
 		.def	= "write",
@@ -1554,6 +1560,17 @@ static void parse_prchk_flags(struct ioring_options *o)
 static int fio_ioring_cmd_init(struct thread_data *td, struct ioring_data *ld)
 {
 	struct ioring_options *o = td->eo;
+	int append, i;
+
+	append = o->write_mode == FIO_URING_CMD_WMODE_ZONE_APPEND;
+	for (i = 0; i < (int)o->wmode_split_nr; i++)
+		append |= o->wmode_split[i].opcode == nvme_zns_cmd_append;
+
+	if (append && td->o.zone_mode != ZONE_MODE_ZBD) {
+		log_err("fio: io_uring_cmd with write_mode=zone_append "
+			"requires zonemode=zbd\n");
+		return 1;
+	}
 
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		if (td_write(td)) {
@@ -1585,6 +1602,9 @@ static int fio_ioring_cmd_init(struct thread_data *td, struct ioring_data *ld)
 				case FIO_URING_CMD_WMODE_VERIFY:
 					ld->write_opcode = nvme_cmd_verify;
 					break;
+				case FIO_URING_CMD_WMODE_ZONE_APPEND:
+					ld->write_opcode = nvme_zns_cmd_append;
+					break;
 				default:
 					ld->write_opcode = nvme_cmd_write;
 					break;
@@ -2192,6 +2212,12 @@ static int fio_ioring_cmd_reset_wp(struct thread_data *td, struct fio_file *f,
 	return -EINVAL;
 }
 
+static int fio_ioring_cmd_finish_zone(struct thread_data *td, struct fio_file *f,
+				      uint64_t offset, uint64_t length)
+{
+	return fio_nvme_finish_zone(td, f, offset, length);
+}
+
 static int fio_ioring_cmd_get_max_open_zones(struct thread_data *td,
 					     struct fio_file *f,
 					     unsigned int *max_open_zones)
@@ -2290,6 +2316,7 @@ static struct ioengine_ops ioengine_uring_cmd = {
 	.get_zoned_model	= fio_ioring_cmd_get_zoned_model,
 	.report_zones		= fio_ioring_cmd_report_zones,
 	.reset_wp		= fio_ioring_cmd_reset_wp,
+	.finish_zone		= fio_ioring_cmd_finish_zone,
 	.get_max_open_zones	= fio_ioring_cmd_get_max_open_zones,
 	.options		= options,
 	.option_struct_size	= sizeof(struct ioring_options),
diff --git a/engines/nvme.c b/engines/nvme.c
index e480fce0..e989306a 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -7,6 +7,7 @@
 #include "nvme.h"
 #include "../crc/crc-t10dif.h"
 #include "../crc/crc64.h"
+#include "zbd.h"
 
 static void fio_nvme_generate_pi_16b_guard(struct nvme_data *data,
 					   struct io_u *io_u,
@@ -352,6 +353,8 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 {
 	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
 	__u64 slba;
+	__u64 offset;
+	__u64 zone_size;
 	__u32 nlb;
 
 	memset(cmd, 0, sizeof(struct nvme_uring_cmd));
@@ -375,7 +378,14 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		return -ENOTSUP;
 	}
 
-	slba = get_slba(data, io_u->offset);
+	/* Zone appends must be issued to the start of the target zone */
+	if (cmd->opcode == nvme_zns_cmd_append && io_u->file->zbd_info) {
+		zone_size = io_u->file->zbd_info->zone_size;
+		offset = io_u->offset & (~(zone_size - 1));
+	} else {
+		offset = io_u->offset;
+	}
+	slba = get_slba(data, offset);
 	nlb = get_nlb(data, io_u->xfer_buflen);
 
 	/* cdw10 and cdw11 represent starting lba */
@@ -395,6 +405,7 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		case nvme_cmd_read:
 		case nvme_cmd_write:
 		case nvme_cmd_compare:
+		case nvme_zns_cmd_append:
 			cmd->addr = (__u64)(uintptr_t)io_u->xfer_buf;
 			cmd->data_len = io_u->xfer_buflen;
 			break;
@@ -852,6 +863,47 @@ int fio_nvme_reset_wp(struct thread_data *td, struct fio_file *f,
 	return -ret;
 }
 
+int fio_nvme_finish_zone(struct thread_data *td, struct fio_file *f,
+		       uint64_t offset, uint64_t length)
+{
+	struct nvme_data *data = FILE_ENG_DATA(f);
+	unsigned int nr_zones;
+	unsigned long long zslba;
+	int i, fd, ret = 0;
+
+	/* If the file is not yet opened, open it for this function. */
+	fd = f->fd;
+	if (fd < 0) {
+		fd = open(f->file_name, O_RDWR | O_LARGEFILE);
+		if (fd < 0)
+			return -errno;
+	}
+
+	zslba = offset >> data->lba_shift;
+	nr_zones = (length + td->o.zone_size - 1) / td->o.zone_size;
+
+	for (i = 0; i < nr_zones; i++, zslba += (td->o.zone_size >> data->lba_shift)) {
+		struct nvme_passthru_cmd cmd = {
+			.opcode		= nvme_zns_cmd_mgmt_send,
+			.nsid		= data->nsid,
+			.cdw10		= zslba & 0xffffffff,
+			.cdw11		= zslba >> 32,
+			.cdw13		= NVME_ZNS_ZSA_FINISH,
+			.addr		= (__u64)(uintptr_t)NULL,
+			.data_len	= 0,
+			.timeout_ms	= NVME_DEFAULT_IOCTL_TIMEOUT,
+		};
+
+		ret = ioctl(fd, NVME_IOCTL_IO_CMD, &cmd);
+		if (ret)
+			break;
+	}
+
+	if (f->fd < 0)
+		close(fd);
+	return -ret;
+}
+
 int fio_nvme_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 				unsigned int *max_open_zones)
 {
diff --git a/engines/nvme.h b/engines/nvme.h
index 4371eb5b..08f359d5 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -50,6 +50,7 @@ struct nvme_uring_cmd {
 
 #define NVME_ZNS_ZRA_REPORT_ZONES 0
 #define NVME_ZNS_ZRAS_FEAT_ERZ (1 << 16)
+#define NVME_ZNS_ZSA_FINISH 0x2
 #define NVME_ZNS_ZSA_RESET 0x4
 #define NVME_ZONE_TYPE_SEQWRITE_REQ 0x2
 
@@ -84,6 +85,7 @@ enum nvme_io_opcode {
 	nvme_cmd_io_mgmt_recv		= 0x12,
 	nvme_zns_cmd_mgmt_send		= 0x79,
 	nvme_zns_cmd_mgmt_recv		= 0x7a,
+	nvme_zns_cmd_append		= 0x7d,
 };
 
 enum nvme_zns_zs {
@@ -445,6 +447,9 @@ int fio_nvme_pi_verify(struct nvme_data *data, struct io_u *io_u);
 int fio_nvme_get_zoned_model(struct thread_data *td, struct fio_file *f,
 			     enum zbd_zoned_model *model);
 
+int fio_nvme_finish_zone(struct thread_data *td, struct fio_file *f,
+			 uint64_t offset, uint64_t length);
+
 int fio_nvme_report_zones(struct thread_data *td, struct fio_file *f,
 			  uint64_t offset, struct zbd_zone *zbdz,
 			  unsigned int nr_zones);
diff --git a/examples/uring-cmd-zoned-append.fio b/examples/uring-cmd-zoned-append.fio
new file mode 100644
index 00000000..ecba1d96
--- /dev/null
+++ b/examples/uring-cmd-zoned-append.fio
@@ -0,0 +1,36 @@
+# io_uring_cmd I/O engine for nvme-ns generic zoned character device
+# with zone appends
+#
+# NOTE:
+# Unlike regular writes, zone appends in a zone can be issued at 
+# a QD higher than 1.
+
+[global]
+filename=/dev/ng1n1
+ioengine=io_uring_cmd
+cmd_type=nvme
+zonemode=zbd
+write_mode=zone_append
+size=1z
+bs=8K
+verify=crc32c
+stonewall=1
+
+[rand-write]
+iodepth=1
+rw=randwrite
+
+[write-opts]
+iodepth=4
+rw=write
+registerfiles=1
+sqthread_poll=1
+sqthread_poll_cpu=0
+
+[randwrite-opts]
+iodepth=4
+rw=randwrite
+sqthread_poll=1
+sqthread_poll_cpu=0
+nonvectored=1
+registerfiles=1
diff --git a/examples/uring-cmd-zoned-append.png b/examples/uring-cmd-zoned-append.png
new file mode 100644
index 00000000..52e509fe
Binary files /dev/null and b/examples/uring-cmd-zoned-append.png differ
diff --git a/fio.1 b/fio.1
index bdb7662d..13bc01de 100644
--- a/fio.1
+++ b/fio.1
@@ -2834,6 +2834,9 @@ Use Write Zeroes commands for write operations
 .TP
 .B verify
 Use Verify commands for write operations
+.TP
+.B zone_append
+Use Zone Append commands for write operations. Requires zonemode=zbd
 .RE
 .P
 Multiple modes with mix ratios can be specified using the format
