Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Fri, 27 Mar 2020 22:11:51 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH v2] fio: add NVMe engine
Message-ID: <20200327191151.GA7688@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Damien.LeMoal@wdc.com, Keith.Busch@wdc.com
List-ID: <fio@vger.kernel.org>

Add simple synchronous NVMe engine:

	ioengine=nvme

It works via standard Linux NVMe ioctls.

It can be used for testing/stress testing upcoming ZNS stuff.

Currently Linux doesn't recognize NVMe ZNS devices as zoned block
devices so zone ioctls (BLKRESETZONE et al) can't be used.

Passthrough ioctls allow Zone Append and whatever commands new specs
bring.

Support read, write, fsync, fdatasync.

Don't support sync_file_range obviously.

Don't support trim for now, until I figure all qemu options and
the story behind broken qemu trim support.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---

	v2) man page, delete debugging

 Makefile       |    3 
 configure      |   20 +++++
 engines/nvme.c |  217 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 file.h         |    1 
 fio.1          |    3 
 5 files changed, 244 insertions(+)

--- a/Makefile
+++ b/Makefile
@@ -163,6 +163,9 @@ endif
 ifdef CONFIG_LINUX_BLKZONED
   SOURCE += zbd.c
 endif
+ifdef CONFIG_NVME
+  SOURCE += engines/nvme.c
+endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
--- a/configure
+++ b/configure
@@ -2397,6 +2397,22 @@ if compile_prog "" "" "linux_blkzoned"; then
 fi
 print_config "Zoned block device support" "$linux_blkzoned"
 
+##########################################
+if test "$linux_nvme" != "yes" ; then
+  linux_nvme="no"
+fi
+cat >$TMPC <<EOF
+#include <linux/nvme_ioctl.h>
+int main(void)
+{
+	return 0;
+}
+EOF
+if compile_prog "" "" "linux_nvme"; then
+  linux_nvme="yes"
+fi
+print_config "NVMe engine" "$linux_nvme"
+
 ##########################################
 # check march=armv8-a+crc+crypto
 if test "$march_armv8_a_crc_crypto" != "yes" ; then
@@ -2912,6 +2928,10 @@ if test "$libnbd" = "yes" ; then
   echo "LIBNBD_CFLAGS=$libnbd_cflags" >> $config_host_mak
   echo "LIBNBD_LIBS=$libnbd_libs" >> $config_host_mak
 fi
+if test "$linux_nvme" = "yes" ; then
+  output_sym "CONFIG_NVME"
+fi
+
 cat > $TMPC << EOF
 int main(int argc, char **argv)
 {
new file mode 100644
--- /dev/null
+++ b/engines/nvme.c
@@ -0,0 +1,217 @@
+/* NVMe passthrough engine. */
+#include <linux/nvme_ioctl.h>
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+
+#include "../fio.h"
+
+enum {
+	nvme_admin_identify	= 6,
+};
+
+enum {
+	nvme_cmd_flush		= 0,
+	nvme_cmd_write		= 1,
+	nvme_cmd_read		= 2,
+};
+
+struct nvme_lbaf {
+	__le16	ms;
+	__u8	ds;
+	__u8	rp;
+};
+
+struct nvme_id_ns {
+	__le64	nsze;
+	__le64	ncap;
+	__le64	nuse;
+	__u8	nsfeat;
+	__u8	nlbaf;
+	__u8	flbas;
+	__u8	mc;
+	__u8	dpc;
+	__u8	dps;
+	__u8	nmic;
+	__u8	rescap;
+	__u8	fpi;
+	__u8	dlfeat;
+	__le16	nawun;
+	__le16	nawupf;
+	__le16	nacwu;
+	__le16	nabsn;
+	__le16	nabo;
+	__le16	nabspf;
+	__le16	noiob;
+	__u8	nvmcap[16];
+	__le16	npwg;
+	__le16	npwa;
+	__le16	npdg;
+	__le16	npda;
+	__le16	nows;
+	__u8	rsvd74[18];
+	__le32	anagrpid;
+	__u8	rsvd96[3];
+	__u8	nsattr;
+	__le16	nvmsetid;
+	__le16	endgid;
+	__u8	nguid[16];
+	__u8	eui64[8];
+	struct nvme_lbaf lbaf[16];
+	__u8	rsvd192[192];
+	__u8	vs[3712];
+};
+
+static inline uint32_t get_nsid(const struct fio_file *f)
+{
+	return (uintptr_t)f->engine_data;
+}
+
+static int nvme_open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct nvme_admin_cmd cmd;
+	struct nvme_id_ns id;
+	struct stat st;
+	uint32_t nsid;
+
+	/* NVMe ioctls ignore open flags, require CAP_SYS_ADMIN only. */
+	f->fd = open(f->file_name, O_RDONLY);
+	if (f->fd < 0) {
+		return -errno;
+	}
+	if (fstat(f->fd, &st) == -1) {
+		return -errno;
+	}
+	if (!S_ISBLK(st.st_mode)) {
+		log_err("%s: nvme engine requires NVMe block device\n",
+			f->file_name);
+		return 1;
+	}
+
+	nsid = ioctl(f->fd, NVME_IOCTL_ID);
+	if (nsid < 1) {
+		log_err("%s: ioctl NVME_IOCTL_ID\n", f->file_name);
+		return 1;
+	}
+
+	f->engine_data = (void *)(uintptr_t)nsid;
+
+	/* Identify Namespace */
+	memset(&cmd, 0, sizeof(struct nvme_admin_cmd));
+	cmd.opcode = nvme_admin_identify;
+	cmd.nsid = nsid;
+	cmd.addr = (uintptr_t)&id;
+	cmd.data_len = 4096;
+	if (ioctl(f->fd, NVME_IOCTL_ADMIN_CMD, &cmd) != 0)  {
+		log_err("%s: ioctl NVME_IOCTL_ADMIN_CMD\n", f->file_name);
+		return 1;
+	}
+
+	f->lba_shift = id.lbaf[id.flbas & 15].ds;
+	return 0;
+}
+
+static int fio_nvme_read(struct fio_file *f, struct io_u *io_u)
+{
+	struct nvme_user_io cmd = {};
+
+	assert((io_u->xfer_buflen & ((1ULL << f->lba_shift) - 1)) == 0);
+	assert((io_u->offset & ((1ULL << f->lba_shift) - 1)) == 0);
+
+	cmd.opcode = nvme_cmd_read;
+	cmd.nblocks = (io_u->xfer_buflen >> f->lba_shift) - 1;
+	cmd.addr = (uintptr_t)io_u->xfer_buf;
+	cmd.slba = io_u->offset >> f->lba_shift;
+	return ioctl(f->fd, NVME_IOCTL_SUBMIT_IO, &cmd);
+}
+
+static int fio_nvme_write(struct fio_file *f, struct io_u *io_u)
+{
+	struct nvme_user_io cmd = {};
+
+	assert((io_u->xfer_buflen & ((1ULL << f->lba_shift) - 1)) == 0);
+	assert((io_u->offset & ((1ULL << f->lba_shift) - 1)) == 0);
+
+	cmd.opcode = nvme_cmd_write;
+	cmd.nblocks = (io_u->xfer_buflen >> f->lba_shift) - 1;
+	cmd.addr = (uintptr_t)io_u->xfer_buf;
+	cmd.slba = io_u->offset >> f->lba_shift;
+	return ioctl(f->fd, NVME_IOCTL_SUBMIT_IO, &cmd);
+}
+
+static int fio_nvme_flush(struct fio_file *f)
+{
+	struct nvme_passthru_cmd cmd = {};
+
+	cmd.opcode = nvme_cmd_flush;
+	cmd.nsid = get_nsid(f);
+	return ioctl(f->fd, NVME_IOCTL_IO_CMD, &cmd);
+}
+
+static enum fio_q_status fio_nvme_queue(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+	int rv;
+
+	fio_ro_check(td, io_u);
+
+	if (io_u->ddir == DDIR_READ) {
+		// FIXME MDTS
+		rv = fio_nvme_read(f, io_u);
+		if (rv == 0) {
+			io_u->resid = 0;
+			io_u->error = 0;
+		} else {
+			io_u->error = rv;
+		}
+	} else if (io_u->ddir == DDIR_WRITE) {
+		// FIXME MDTS
+		rv = fio_nvme_write(f, io_u);
+		if (rv == 0) {
+			io_u->resid = 0;
+			io_u->error = 0;
+		} else {
+			io_u->error = rv;
+		}
+	} else if (io_u->ddir == DDIR_TRIM) {
+		// FIXME
+		rv = io_u->xfer_buflen;
+		io_u->error = EINVAL;
+	} else if (io_u->ddir == DDIR_SYNC || io_u->ddir == DDIR_DATASYNC) {
+		rv = fio_nvme_flush(f);
+	} else {
+		rv = io_u->xfer_buflen;
+		io_u->error = EINVAL;
+	}
+
+	if (io_u->error) {
+		io_u_log_error(td, io_u);
+		td_verror(td, io_u->error, "xfer");
+	}
+
+	return FIO_Q_COMPLETED;
+}
+
+static struct ioengine_ops ioengine = {
+	.name		= "nvme",
+	.version	= FIO_IOOPS_VERSION,
+	.flags		= FIO_SYNCIO|FIO_RAWIO|FIO_NOEXTEND,
+	.queue		= fio_nvme_queue,
+	.open_file	= nvme_open_file,
+	.close_file	= generic_close_file,
+	.get_file_size	= generic_get_file_size,
+};
+
+fio_init
+static void register_nvme_ioengine(void)
+{
+	register_ioengine(&ioengine);
+}
+
+fio_exit
+static void unregister_nvme_ioengine(void)
+{
+	unregister_ioengine(&ioengine);
+}
--- a/file.h
+++ b/file.h
@@ -99,6 +99,7 @@ struct fio_file {
 	uint64_t real_file_size;
 	uint64_t file_offset;
 	uint64_t io_size;
+	unsigned int lba_shift;
 
 	/*
 	 * Zoned block device information. See also zonemode=zbd.
--- a/fio.1
+++ b/fio.1
@@ -1789,6 +1789,9 @@ Read and write iscsi lun with libiscsi.
 .TP
 .B nbd
 Synchronous read and write a Network Block Device (NBD).
+.TP
+.B nvme
+Synchronous NVMe I/O via Linux NVME_IOCTL_* ioctls.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,

