Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58220 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbbJAIdj (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 Oct 2015 04:33:39 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZhZJ3-0002RO-Of
	for fio@vger.kernel.org; Thu, 01 Oct 2015 08:33:38 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151001083335.226032C2DAD@kernel.dk>
Date: Thu,  1 Oct 2015 02:33:35 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 194fffd042d374d5e13af61a14fe16734c396d8c:

  Fix integer overflow in rate_iops (2015-09-24 20:35:44 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2099539d0f49098148b101d2e3d3f533777c700e:

  server: bump protocol version (2015-10-01 08:55:18 +0200)

----------------------------------------------------------------
Jens Axboe (2):
      sg: fix short reads
      server: bump protocol version

Kris Davis (2):
      sg: 16-byte cdb support and lots of fixes
      Use line buffering on stdout

Roman Pen (2):
      fio.1,HOWTO: keep 'iodepth_batch' option in sync
      Introduce new option: iodepth_batch_complete_max

 HOWTO            |  29 +++-
 Makefile         |   3 +
 backend.c        |  14 +-
 cconv.c          |   6 +-
 configure        |  22 +++
 engines/libaio.c |   2 +-
 engines/sg.c     | 493 +++++++++++++++++++++++++++++++++++++++++++++++++------
 fio.1            |  41 ++++-
 fio.c            |   6 +
 init.c           |   7 +
 io_u.c           |  11 +-
 ioengine.h       |   3 +-
 lib/strlcat.c    |  23 +++
 lib/strlcat.h    |   6 +
 options.c        |  22 ++-
 os/os.h          |   4 +
 server.h         |   2 +-
 thread_options.h |   7 +-
 18 files changed, 629 insertions(+), 72 deletions(-)
 create mode 100644 lib/strlcat.c
 create mode 100644 lib/strlcat.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index d3ead19..40233bd 100644
--- a/HOWTO
+++ b/HOWTO
@@ -812,8 +812,10 @@ iodepth_batch_submit=int
 iodepth_batch=int This defines how many pieces of IO to submit at once.
 		It defaults to 1 which means that we submit each IO
 		as soon as it is available, but can be raised to submit
-		bigger batches of IO at the time.
+		bigger batches of IO at the time. If it is set to 0 the iodepth
+		value will be used.
 
+iodepth_batch_complete_min=int
 iodepth_batch_complete=int This defines how many pieces of IO to retrieve
 		at once. It defaults to 1 which means that we'll ask
 		for a minimum of 1 IO in the retrieval process from
@@ -823,6 +825,31 @@ iodepth_batch_complete=int This defines how many pieces of IO to retrieve
 		events before queuing more IO. This helps reduce
 		IO latency, at the cost of more retrieval system calls.
 
+iodepth_batch_complete_max=int This defines maximum pieces of IO to
+		retrieve at once. This variable should be used along with
+		iodepth_batch_complete_min=int variable, specifying the range
+		of min and max amount of IO which should be retrieved. By default
+		it is equal to iodepth_batch_complete_min value.
+
+		Example #1:
+
+		iodepth_batch_complete_min=1
+		iodepth_batch_complete_max=<iodepth>
+
+		which means that we will retrieve at leat 1 IO and up to the
+		whole submitted queue depth. If none of IO has been completed
+		yet, we will wait.
+
+		Example #2:
+
+		iodepth_batch_complete_min=0
+		iodepth_batch_complete_max=<iodepth>
+
+		which means that we can retrieve up to the whole submitted
+		queue depth, but if none of IO has been completed yet, we will
+		NOT wait and immediately exit the system call. In this example
+		we simply do polling.
+
 iodepth_low=int	The low water mark indicating when to start filling
 		the queue again. Defaults to the same as iodepth, meaning
 		that fio will attempt to keep the queue full at all times.
diff --git a/Makefile b/Makefile
index 296655b..d287126 100644
--- a/Makefile
+++ b/Makefile
@@ -104,6 +104,9 @@ endif
 ifndef CONFIG_STRCASESTR
   SOURCE += lib/strcasestr.c
 endif
+ifndef CONFIG_STRLCAT
+  SOURCE += lib/strlcat.c
+endif
 ifndef CONFIG_GETOPT_LONG_ONLY
   SOURCE += lib/getopt_long.c
 endif
diff --git a/backend.c b/backend.c
index dec0d55..b1477df 100644
--- a/backend.c
+++ b/backend.c
@@ -446,8 +446,8 @@ static int wait_for_completions(struct thread_data *td, struct timeval *time)
 	/*
 	 * if the queue is full, we MUST reap at least 1 event
 	 */
-	min_evts = min(td->o.iodepth_batch_complete, td->cur_depth);
-    if ((full && !min_evts) || !td->o.iodepth_batch_complete)
+	min_evts = min(td->o.iodepth_batch_complete_min, td->cur_depth);
+    if ((full && !min_evts) || !td->o.iodepth_batch_complete_min)
 		min_evts = 1;
 
 	if (time && (__should_check_rate(td, DDIR_READ) ||
@@ -551,6 +551,12 @@ sync_done:
 	return 0;
 }
 
+static inline int io_in_polling(struct thread_data *td)
+{
+	return !td->o.iodepth_batch_complete_min &&
+		   !td->o.iodepth_batch_complete_max;
+}
+
 /*
  * The main verify engine. Runs over the writes we previously submitted,
  * reads the blocks back in, and checks the crc/md5 of the data.
@@ -684,7 +690,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 		 */
 reap:
 		full = queue_full(td) || (ret == FIO_Q_BUSY && td->cur_depth);
-		if (full || !td->o.iodepth_batch_complete)
+		if (full || io_in_polling(td))
 			ret = wait_for_completions(td, NULL);
 
 		if (ret < 0)
@@ -932,7 +938,7 @@ static uint64_t do_io(struct thread_data *td)
 reap:
 			full = queue_full(td) ||
 				(ret == FIO_Q_BUSY && td->cur_depth);
-			if (full || !td->o.iodepth_batch_complete)
+			if (full || io_in_polling(td))
 				ret = wait_for_completions(td, &comp_time);
 		}
 		if (ret < 0)
diff --git a/cconv.c b/cconv.c
index 44f17da..fde8c6d 100644
--- a/cconv.c
+++ b/cconv.c
@@ -83,7 +83,8 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->iodepth = le32_to_cpu(top->iodepth);
 	o->iodepth_low = le32_to_cpu(top->iodepth_low);
 	o->iodepth_batch = le32_to_cpu(top->iodepth_batch);
-	o->iodepth_batch_complete = le32_to_cpu(top->iodepth_batch_complete);
+	o->iodepth_batch_complete_min = le32_to_cpu(top->iodepth_batch_complete_min);
+	o->iodepth_batch_complete_max = le32_to_cpu(top->iodepth_batch_complete_max);
 	o->size = le64_to_cpu(top->size);
 	o->io_limit = le64_to_cpu(top->io_limit);
 	o->size_percent = le32_to_cpu(top->size_percent);
@@ -300,7 +301,8 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->iodepth = cpu_to_le32(o->iodepth);
 	top->iodepth_low = cpu_to_le32(o->iodepth_low);
 	top->iodepth_batch = cpu_to_le32(o->iodepth_batch);
-	top->iodepth_batch_complete = cpu_to_le32(o->iodepth_batch_complete);
+	top->iodepth_batch_complete_min = cpu_to_le32(o->iodepth_batch_complete_min);
+	top->iodepth_batch_complete_max = cpu_to_le32(o->iodepth_batch_complete_max);
 	top->size_percent = cpu_to_le32(o->size_percent);
 	top->fill_device = cpu_to_le32(o->fill_device);
 	top->file_append = cpu_to_le32(o->file_append);
diff --git a/configure b/configure
index ee096b3..7489775 100755
--- a/configure
+++ b/configure
@@ -965,6 +965,25 @@ fi
 echo "strcasestr                    $strcasestr"
 
 ##########################################
+# strlcat() probe
+strlcat="no"
+cat > $TMPC << EOF
+#include <string.h>
+int main(int argc, char **argv)
+{
+  static char dst[64];
+  static char *string = "This is a string";
+  memset(dst, 0, sizeof(dst));
+  strlcat(dst, string, sizeof(dst));
+  return 0;
+}
+EOF
+if compile_prog "" "" "strlcat"; then
+  strlcat="yes"
+fi
+echo "strlcat                       $strlcat"
+
+##########################################
 # getopt_long_only() probe
 getopt_long_only="no"
 cat > $TMPC << EOF
@@ -1612,6 +1631,9 @@ fi
 if test "$strcasestr" = "yes" ; then
   output_sym "CONFIG_STRCASESTR"
 fi
+if test "$strlcat" = "yes" ; then
+  output_sym "CONFIG_STRLCAT"
+fi
 if test "$getopt_long_only" = "yes" ; then
   output_sym "CONFIG_GETOPT_LONG_ONLY"
 fi
diff --git a/engines/libaio.c b/engines/libaio.c
index 9685c99..60dc49d 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -146,7 +146,7 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 {
 	struct libaio_data *ld = td->io_ops->data;
 	struct libaio_options *o = td->eo;
-	unsigned actual_min = td->o.iodepth_batch_complete == 0 ? 0 : min;
+	unsigned actual_min = td->o.iodepth_batch_complete_min == 0 ? 0 : min;
 	struct timespec __lt, *lt = NULL;
 	int r, events = 0;
 
diff --git a/engines/sg.c b/engines/sg.c
index 8acbd50..360775f 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -15,8 +15,13 @@
 
 #ifdef FIO_HAVE_SGIO
 
+#define MAX_10B_LBA  0xFFFFFFFFULL
+#define SCSI_TIMEOUT_MS 30000   // 30 second timeout; currently no method to override
+#define MAX_SB 64               // sense block maximum return size
+
 struct sgio_cmd {
-	unsigned char cdb[10];
+	unsigned char cdb[16];  	// increase to support 16 byte commands
+	unsigned char sb[MAX_SB];   // add sense block to commands
 	int nr;
 };
 
@@ -27,6 +32,7 @@ struct sgio_data {
 	int *fd_flags;
 	void *sgbuf;
 	unsigned int bs;
+	long long max_lba;
 	int type_checked;
 };
 
@@ -41,6 +47,8 @@ static void sgio_hdr_init(struct sgio_data *sd, struct sg_io_hdr *hdr,
 	hdr->interface_id = 'S';
 	hdr->cmdp = sc->cdb;
 	hdr->cmd_len = sizeof(sc->cdb);
+	hdr->sbp = sc->sb;
+	hdr->mx_sb_len = sizeof(sc->sb);
 	hdr->pack_id = io_u->index;
 	hdr->usr_ptr = io_u;
 
@@ -61,12 +69,41 @@ static int pollin_events(struct pollfd *pfds, int fds)
 	return 0;
 }
 
+static int sg_fd_read(int fd, void *data, size_t size)
+{
+	int err = 0;
+
+	while (size) {
+		ssize_t ret;
+
+		ret = read(fd, data, size);
+		if (ret < 0) {
+			if (errno == EAGAIN || errno == EINTR)
+				continue;
+			err = errno;
+			break;
+		} else if (!ret)
+			break;
+		else {
+			data += ret;
+			size -= ret;
+		}
+	}
+
+	if (err)
+		return err;
+	if (size)
+		return EAGAIN;
+
+	return 0;
+}
+
 static int fio_sgio_getevents(struct thread_data *td, unsigned int min,
 			      unsigned int max,
 			      const struct timespec fio_unused *t)
 {
 	struct sgio_data *sd = td->io_ops->data;
-	int left = max, ret, r = 0;
+	int left = max, eventNum, ret, r = 0;
 	void *buf = sd->sgbuf;
 	unsigned int i, events;
 	struct fio_file *f;
@@ -90,6 +127,8 @@ static int fio_sgio_getevents(struct thread_data *td, unsigned int min,
 	while (left) {
 		void *p;
 
+		dprint(FD_IO, "sgio_getevents: sd %p: left=%d\n", sd, left);
+
 		do {
 			if (!min)
 				break;
@@ -114,20 +153,21 @@ re_read:
 		p = buf;
 		events = 0;
 		for_each_file(td, f, i) {
-			ret = read(f->fd, p, left * sizeof(struct sg_io_hdr));
-			if (ret < 0) {
-				if (errno == EAGAIN)
-					continue;
-				r = -errno;
-				td_verror(td, errno, "read");
-				break;
-			} else if (ret) {
-				p += ret;
-				events += ret / sizeof(struct sg_io_hdr);
+			for (eventNum = 0; eventNum < left; eventNum++) {
+				ret = sg_fd_read(f->fd, p, sizeof(struct sg_io_hdr));
+				dprint(FD_IO, "sgio_getevents: ret: %d\n", ret);
+				if (ret) {
+					r = -ret;
+					td_verror(td, r, "sg_read");
+					break;
+				}
+				p += sizeof(struct sg_io_hdr);
+				events++;
+				dprint(FD_IO, "sgio_getevents: events: %d\n", events);
 			}
 		}
 
-		if (r < 0)
+		if (r < 0 && !events)
 			break;
 		if (!events) {
 			usleep(1000);
@@ -139,8 +179,15 @@ re_read:
 
 		for (i = 0; i < events; i++) {
 			struct sg_io_hdr *hdr = (struct sg_io_hdr *) buf + i;
-
 			sd->events[i] = hdr->usr_ptr;
+
+			/* record if an io error occurred, ignore resid */
+			if (hdr->info & SG_INFO_CHECK) {
+				struct io_u *io_u;
+				io_u = (struct io_u *)(hdr->usr_ptr);
+				memcpy((void*)&(io_u->hdr), (void*)hdr, sizeof(struct sg_io_hdr));
+				sd->events[i]->error = EIO;
+			}
 		}
 	}
 
@@ -170,6 +217,10 @@ static int fio_sgio_ioctl_doio(struct thread_data *td,
 	if (ret < 0)
 		return ret;
 
+	/* record if an io error occurred */
+	if (hdr->info & SG_INFO_CHECK)
+		io_u->error = EIO;
+
 	return FIO_Q_COMPLETED;
 }
 
@@ -186,6 +237,11 @@ static int fio_sgio_rw_doio(struct fio_file *f, struct io_u *io_u, int do_sync)
 		ret = read(f->fd, hdr, sizeof(*hdr));
 		if (ret < 0)
 			return ret;
+
+		/* record if an io error occurred */
+		if (hdr->info & SG_INFO_CHECK)
+			io_u->error = EIO;
+
 		return FIO_Q_COMPLETED;
 	}
 
@@ -195,52 +251,89 @@ static int fio_sgio_rw_doio(struct fio_file *f, struct io_u *io_u, int do_sync)
 static int fio_sgio_doio(struct thread_data *td, struct io_u *io_u, int do_sync)
 {
 	struct fio_file *f = io_u->file;
+	int ret;
 
-	if (f->filetype == FIO_TYPE_BD)
-		return fio_sgio_ioctl_doio(td, f, io_u);
+	if (f->filetype == FIO_TYPE_BD) {
+		ret = fio_sgio_ioctl_doio(td, f, io_u);
+		td->error = io_u->error;
+	} else {
+		ret = fio_sgio_rw_doio(f, io_u, do_sync);
+		if (do_sync)
+			td->error = io_u->error;
+	}
 
-	return fio_sgio_rw_doio(f, io_u, do_sync);
+	return ret;
 }
 
 static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct sg_io_hdr *hdr = &io_u->hdr;
 	struct sgio_data *sd = td->io_ops->data;
-	int nr_blocks, lba;
+	long long nr_blocks, lba;
 
 	if (io_u->xfer_buflen & (sd->bs - 1)) {
 		log_err("read/write not sector aligned\n");
 		return EINVAL;
 	}
 
+	nr_blocks = io_u->xfer_buflen / sd->bs;
+	lba = io_u->offset / sd->bs;
+
 	if (io_u->ddir == DDIR_READ) {
 		sgio_hdr_init(sd, hdr, io_u, 1);
 
 		hdr->dxfer_direction = SG_DXFER_FROM_DEV;
-		hdr->cmdp[0] = 0x28;
+		if (lba < MAX_10B_LBA)
+			hdr->cmdp[0] = 0x28; // read(10)
+		else
+			hdr->cmdp[0] = 0x88; // read(16)
 	} else if (io_u->ddir == DDIR_WRITE) {
 		sgio_hdr_init(sd, hdr, io_u, 1);
 
 		hdr->dxfer_direction = SG_DXFER_TO_DEV;
-		hdr->cmdp[0] = 0x2a;
+		if (lba < MAX_10B_LBA)
+			hdr->cmdp[0] = 0x2a; // write(10)
+		else
+			hdr->cmdp[0] = 0x8a; // write(16)
 	} else {
 		sgio_hdr_init(sd, hdr, io_u, 0);
-
 		hdr->dxfer_direction = SG_DXFER_NONE;
-		hdr->cmdp[0] = 0x35;
+		if (lba < MAX_10B_LBA)
+			hdr->cmdp[0] = 0x35; // synccache(10)
+		else
+			hdr->cmdp[0] = 0x91; // synccache(16)
 	}
 
+	/*
+	 * for synccache, we leave lba and length to 0 to sync all
+	 * blocks on medium.
+	 */
 	if (hdr->dxfer_direction != SG_DXFER_NONE) {
-		nr_blocks = io_u->xfer_buflen / sd->bs;
-		lba = io_u->offset / sd->bs;
-		hdr->cmdp[2] = (unsigned char) ((lba >> 24) & 0xff);
-		hdr->cmdp[3] = (unsigned char) ((lba >> 16) & 0xff);
-		hdr->cmdp[4] = (unsigned char) ((lba >>  8) & 0xff);
-		hdr->cmdp[5] = (unsigned char) (lba & 0xff);
-		hdr->cmdp[7] = (unsigned char) ((nr_blocks >> 8) & 0xff);
-		hdr->cmdp[8] = (unsigned char) (nr_blocks & 0xff);
+
+		if (lba < MAX_10B_LBA) {
+			hdr->cmdp[2] = (unsigned char) ((lba >> 24) & 0xff);
+			hdr->cmdp[3] = (unsigned char) ((lba >> 16) & 0xff);
+			hdr->cmdp[4] = (unsigned char) ((lba >>  8) & 0xff);
+			hdr->cmdp[5] = (unsigned char) (lba & 0xff);
+			hdr->cmdp[7] = (unsigned char) ((nr_blocks >> 8) & 0xff);
+			hdr->cmdp[8] = (unsigned char) (nr_blocks & 0xff);
+		} else {
+			hdr->cmdp[2] = (unsigned char) ((lba >> 56) & 0xff);
+			hdr->cmdp[3] = (unsigned char) ((lba >> 48) & 0xff);
+			hdr->cmdp[4] = (unsigned char) ((lba >> 40) & 0xff);
+			hdr->cmdp[5] = (unsigned char) ((lba >> 32) & 0xff);
+			hdr->cmdp[6] = (unsigned char) ((lba >> 24) & 0xff);
+			hdr->cmdp[7] = (unsigned char) ((lba >> 16) & 0xff);
+			hdr->cmdp[8] = (unsigned char) ((lba >>  8) & 0xff);
+			hdr->cmdp[9] = (unsigned char) (lba & 0xff);
+			hdr->cmdp[10] = (unsigned char) ((nr_blocks >> 32) & 0xff);
+			hdr->cmdp[11] = (unsigned char) ((nr_blocks >> 16) & 0xff);
+			hdr->cmdp[12] = (unsigned char) ((nr_blocks >> 8) & 0xff);
+			hdr->cmdp[13] = (unsigned char) (nr_blocks & 0xff);
+		}
 	}
 
+	hdr->timeout = SCSI_TIMEOUT_MS;
 	return 0;
 }
 
@@ -278,31 +371,93 @@ static struct io_u *fio_sgio_event(struct thread_data *td, int event)
 	return sd->events[event];
 }
 
-static int fio_sgio_get_bs(struct thread_data *td, unsigned int *bs)
+static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
+				  unsigned long long *max_lba)
 {
-	struct sgio_data *sd = td->io_ops->data;
-	struct io_u io_u;
-	struct sg_io_hdr *hdr;
-	unsigned char buf[8];
+	/*
+	 * need to do read capacity operation w/o benefit of sd or
+	 * io_u structures, which are not initialized until later.
+	 */
+	struct sg_io_hdr hdr;
+	unsigned char cmd[16];
+	unsigned char sb[64];
+	unsigned char buf[32];  // read capacity return
 	int ret;
+	int fd = -1;
 
-	memset(&io_u, 0, sizeof(io_u));
-	io_u.file = td->files[0];
+	struct fio_file *f = td->files[0];
 
-	hdr = &io_u.hdr;
-	sgio_hdr_init(sd, hdr, &io_u, 0);
-	memset(buf, 0, sizeof(buf));
+	/* open file independent of rest of application */
+	fd = open(f->file_name, O_RDONLY);
+	if (fd < 0)
+		return -errno;
 
-	hdr->cmdp[0] = 0x25;
-	hdr->dxfer_direction = SG_DXFER_FROM_DEV;
-	hdr->dxferp = buf;
-	hdr->dxfer_len = sizeof(buf);
+	memset(&hdr, 0, sizeof(hdr));
+	memset(cmd, 0, sizeof(cmd));
+	memset(sb, 0, sizeof(sb));
+	memset(buf, 0, sizeof(buf));
 
-	ret = fio_sgio_doio(td, &io_u, 1);
-	if (ret)
+	/* First let's try a 10 byte read capacity. */
+	hdr.interface_id = 'S';
+	hdr.cmdp = cmd;
+	hdr.cmd_len = 10;
+	hdr.sbp = sb;
+	hdr.mx_sb_len = sizeof(sb);
+	hdr.timeout = SCSI_TIMEOUT_MS;
+	hdr.cmdp[0] = 0x25;  // Read Capacity(10)
+	hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+	hdr.dxferp = buf;
+	hdr.dxfer_len = sizeof(buf);
+
+	ret = ioctl(fd, SG_IO, &hdr);
+	if (ret < 0) {
+		close(fd);
 		return ret;
+	}
+
+	*bs	 = (buf[4] << 24) | (buf[5] << 16) | (buf[6] << 8) | buf[7];
+	*max_lba = ((buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3]) & 0x00000000FFFFFFFFULL;  // for some reason max_lba is being sign extended even though unsigned.
+
 
-	*bs = (buf[4] << 24) | (buf[5] << 16) | (buf[6] << 8) | buf[7];
+	/*
+	 * If max lba is 0xFFFFFFFF, then need to retry with
+	 * 16 byteread capacity
+	 */
+	if (*max_lba == MAX_10B_LBA) {
+		hdr.cmd_len = 16;
+		hdr.cmdp[0] = 0x9e; // Read Capacity(16)
+		hdr.cmdp[1] = 0x10; // service action
+		hdr.cmdp[10] = (unsigned char) ((sizeof(buf) >> 24) & 0xff);
+		hdr.cmdp[11] = (unsigned char) ((sizeof(buf) >> 16) & 0xff);
+		hdr.cmdp[12] = (unsigned char) ((sizeof(buf) >> 8) & 0xff);
+		hdr.cmdp[13] = (unsigned char) (sizeof(buf) & 0xff);
+
+		hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+		hdr.dxferp = buf;
+		hdr.dxfer_len = sizeof(buf);
+
+		ret = ioctl(fd, SG_IO, &hdr);
+		if (ret < 0) {
+			close(fd);
+			return ret;
+		}
+
+		/* record if an io error occurred */
+		if (hdr.info & SG_INFO_CHECK)
+			td_verror(td, EIO, "fio_sgio_read_capacity");
+
+		*bs = (buf[8] << 24) | (buf[9] << 16) | (buf[10] << 8) | buf[11];
+		*max_lba = ((unsigned long long)buf[0] << 56) |
+				((unsigned long long)buf[1] << 48) |
+				((unsigned long long)buf[2] << 40) |
+				((unsigned long long)buf[3] << 32) |
+				((unsigned long long)buf[4] << 24) |
+				((unsigned long long)buf[5] << 16) |
+				((unsigned long long)buf[6] << 8) |
+				(unsigned long long)buf[7];
+	}
+
+	close(fd);
 	return 0;
 }
 
@@ -336,7 +491,7 @@ static int fio_sgio_init(struct thread_data *td)
 	memset(sd->fd_flags, 0, sizeof(int) * td->o.nr_files);
 	sd->sgbuf = malloc(sizeof(struct sg_io_hdr) * td->o.iodepth);
 	memset(sd->sgbuf, 0, sizeof(struct sg_io_hdr) * td->o.iodepth);
-
+	sd->type_checked = 0;
 	td->io_ops->data = sd;
 
 	/*
@@ -349,7 +504,9 @@ static int fio_sgio_init(struct thread_data *td)
 static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 {
 	struct sgio_data *sd = td->io_ops->data;
-	unsigned int bs;
+	unsigned int bs = 0;
+	unsigned long long max_lba = 0;
+
 
 	if (f->filetype == FIO_TYPE_BD) {
 		if (ioctl(f->fd, BLKSSZGET, &bs) < 0) {
@@ -364,9 +521,12 @@ static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 			return 1;
 		}
 
-		ret = fio_sgio_get_bs(td, &bs);
-		if (ret)
+		ret = fio_sgio_read_capacity(td, &bs, &max_lba);
+		if (ret) {
+			td_verror(td, td->error, "fio_sgio_read_capacity");
+			log_err("ioengine sg unable to read capacity successfully\n");
 			return 1;
+		}
 	} else {
 		td_verror(td, EINVAL, "wrong file type");
 		log_err("ioengine sg only works on block devices\n");
@@ -374,11 +534,18 @@ static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 	}
 
 	sd->bs = bs;
+	// Determine size of commands needed based on max_lba
+	sd->max_lba = max_lba;
+	if (max_lba > MAX_10B_LBA) {
+		dprint(FD_IO, "sgio_type_check: using 16 byte operations: max_lba = 0x%016llx\n", max_lba);
+	}
+
 
 	if (f->filetype == FIO_TYPE_BD) {
 		td->io_ops->getevents = NULL;
 		td->io_ops->event = NULL;
 	}
+	sd->type_checked = 1;
 
 	return 0;
 }
@@ -400,6 +567,227 @@ static int fio_sgio_open(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
+/*
+ * Build an error string with details about the driver, host or scsi
+ * error contained in the sg header Caller will use as necessary.
+ */
+static char *fio_sgio_errdetails(struct io_u *io_u)
+{
+	struct sg_io_hdr *hdr = &io_u->hdr;
+#define MAXERRDETAIL 1024
+#define MAXMSGCHUNK  128
+	char *msg, msgchunk[MAXMSGCHUNK], *ret = NULL;
+	int i;
+
+	msg = calloc(MAXERRDETAIL, 1);
+
+	/*
+	 * can't seem to find sg_err.h, so I'll just echo the define values
+	 * so others can search on internet to find clearer clues of meaning.
+	 */
+	if (hdr->info & SG_INFO_CHECK) {
+		ret = msg;
+		if (hdr->host_status) {
+			snprintf(msgchunk, MAXMSGCHUNK, "SG Host Status: 0x%02x; ", hdr->host_status);
+			strlcat(msg, msgchunk, MAXERRDETAIL);
+			switch (hdr->host_status) {
+			case 0x01:
+				strlcat(msg, "SG_ERR_DID_NO_CONNECT", MAXERRDETAIL);
+				break;
+			case 0x02:
+				strlcat(msg, "SG_ERR_DID_BUS_BUSY", MAXERRDETAIL);
+				break;
+			case 0x03:
+				strlcat(msg, "SG_ERR_DID_TIME_OUT", MAXERRDETAIL);
+				break;
+			case 0x04:
+				strlcat(msg, "SG_ERR_DID_BAD_TARGET", MAXERRDETAIL);
+				break;
+			case 0x05:
+				strlcat(msg, "SG_ERR_DID_ABORT", MAXERRDETAIL);
+				break;
+			case 0x06:
+				strlcat(msg, "SG_ERR_DID_PARITY", MAXERRDETAIL);
+				break;
+			case 0x07:
+				strlcat(msg, "SG_ERR_DID_ERROR (internal error)", MAXERRDETAIL);
+				break;
+			case 0x08:
+				strlcat(msg, "SG_ERR_DID_RESET", MAXERRDETAIL);
+				break;
+			case 0x09:
+				strlcat(msg, "SG_ERR_DID_BAD_INTR (unexpected)", MAXERRDETAIL);
+				break;
+			case 0x0a:
+				strlcat(msg, "SG_ERR_DID_PASSTHROUGH", MAXERRDETAIL);
+				break;
+			case 0x0b:
+				strlcat(msg, "SG_ERR_DID_SOFT_ERROR (driver retry?)", MAXERRDETAIL);
+				break;
+			case 0x0c:
+				strlcat(msg, "SG_ERR_DID_IMM_RETRY", MAXERRDETAIL);
+				break;
+			case 0x0d:
+				strlcat(msg, "SG_ERR_DID_REQUEUE", MAXERRDETAIL);
+				break;
+			default:
+				strlcat(msg, "Unknown", MAXERRDETAIL);
+				break;
+			}
+			strlcat(msg, ". ", MAXERRDETAIL);
+		}
+		if (hdr->driver_status) {
+			snprintf(msgchunk, MAXMSGCHUNK, "SG Driver Status: 0x%02x; ", hdr->driver_status);
+			strlcat(msg, msgchunk, MAXERRDETAIL);
+			switch (hdr->driver_status & 0x0F) {
+			case 0x01:
+				strlcat(msg, "SG_ERR_DRIVER_BUSY", MAXERRDETAIL);
+				break;
+			case 0x02:
+				strlcat(msg, "SG_ERR_DRIVER_SOFT", MAXERRDETAIL);
+				break;
+			case 0x03:
+				strlcat(msg, "SG_ERR_DRIVER_MEDIA", MAXERRDETAIL);
+				break;
+			case 0x04:
+				strlcat(msg, "SG_ERR_DRIVER_ERROR", MAXERRDETAIL);
+				break;
+			case 0x05:
+				strlcat(msg, "SG_ERR_DRIVER_INVALID", MAXERRDETAIL);
+				break;
+			case 0x06:
+				strlcat(msg, "SG_ERR_DRIVER_TIMEOUT", MAXERRDETAIL);
+				break;
+			case 0x07:
+				strlcat(msg, "SG_ERR_DRIVER_HARD", MAXERRDETAIL);
+				break;
+			case 0x08:
+				strlcat(msg, "SG_ERR_DRIVER_SENSE", MAXERRDETAIL);
+				break;
+			default:
+				strlcat(msg, "Unknown", MAXERRDETAIL);
+				break;
+			}
+			strlcat(msg, "; ", MAXERRDETAIL);
+			switch (hdr->driver_status & 0xF0) {
+			case 0x10:
+				strlcat(msg, "SG_ERR_SUGGEST_RETRY", MAXERRDETAIL);
+				break;
+			case 0x20:
+				strlcat(msg, "SG_ERR_SUGGEST_ABORT", MAXERRDETAIL);
+				break;
+			case 0x30:
+				strlcat(msg, "SG_ERR_SUGGEST_REMAP", MAXERRDETAIL);
+				break;
+			case 0x40:
+				strlcat(msg, "SG_ERR_SUGGEST_DIE", MAXERRDETAIL);
+				break;
+			case 0x80:
+				strlcat(msg, "SG_ERR_SUGGEST_SENSE", MAXERRDETAIL);
+				break;
+			}
+			strlcat(msg, ". ", MAXERRDETAIL);
+		}
+		if (hdr->status) {
+			snprintf(msgchunk, MAXMSGCHUNK, "SG SCSI Status: 0x%02x; ", hdr->status);
+			strlcat(msg, msgchunk, MAXERRDETAIL);
+			// SCSI 3 status codes
+			switch (hdr->status) {
+			case 0x02:
+				strlcat(msg, "CHECK_CONDITION", MAXERRDETAIL);
+				break;
+			case 0x04:
+				strlcat(msg, "CONDITION_MET", MAXERRDETAIL);
+				break;
+			case 0x08:
+				strlcat(msg, "BUSY", MAXERRDETAIL);
+				break;
+			case 0x10:
+				strlcat(msg, "INTERMEDIATE", MAXERRDETAIL);
+				break;
+			case 0x14:
+				strlcat(msg, "INTERMEDIATE_CONDITION_MET", MAXERRDETAIL);
+				break;
+			case 0x18:
+				strlcat(msg, "RESERVATION_CONFLICT", MAXERRDETAIL);
+				break;
+			case 0x22:
+				strlcat(msg, "COMMAND_TERMINATED", MAXERRDETAIL);
+				break;
+			case 0x28:
+				strlcat(msg, "TASK_SET_FULL", MAXERRDETAIL);
+				break;
+			case 0x30:
+				strlcat(msg, "ACA_ACTIVE", MAXERRDETAIL);
+				break;
+			case 0x40:
+				strlcat(msg, "TASK_ABORTED", MAXERRDETAIL);
+				break;
+			default:
+				strlcat(msg, "Unknown", MAXERRDETAIL);
+				break;
+			}
+			strlcat(msg, ". ", MAXERRDETAIL);
+		}
+		if (hdr->sb_len_wr) {
+			snprintf(msgchunk, MAXMSGCHUNK, "Sense Data (%d bytes):", hdr->sb_len_wr);
+			strlcat(msg, msgchunk, MAXERRDETAIL);
+			for (i = 0; i < hdr->sb_len_wr; i++) {
+				snprintf(msgchunk, MAXMSGCHUNK, " %02x", hdr->sbp[i]);
+				strlcat(msg, msgchunk, MAXERRDETAIL);
+			}
+			strlcat(msg, ". ", MAXERRDETAIL);
+		}
+		if (hdr->resid != 0) {
+			snprintf(msgchunk, MAXMSGCHUNK, "SG Driver: %d bytes out of %d not transferred. ", hdr->resid, hdr->dxfer_len);
+			strlcat(msg, msgchunk, MAXERRDETAIL);
+			ret = msg;
+		}
+	}
+
+	if (!ret)
+		ret = strdup("SG Driver did not report a Host, Driver or Device check");
+
+	return ret;
+}
+
+/*
+ * get max file size from read capacity.
+ */
+static int fio_sgio_get_file_size(struct thread_data *td, struct fio_file *f)
+{
+	/*
+	 * get_file_size is being called even before sgio_init is
+	 * called, so none of the sg_io structures are
+	 * initialized in the thread_data yet.  So we need to do the
+	 * ReadCapacity without any of those helpers.  One of the effects
+	 * is that ReadCapacity may get called 4 times on each open:
+	 * readcap(10) followed by readcap(16) if needed - just to get
+	 * the file size after the init occurs - it will be called
+	 * again when "type_check" is called during structure
+	 * initialization I'm not sure how to prevent this little
+	 * inefficiency.
+	 */
+	unsigned int bs = 0;
+	unsigned long long max_lba = 0;
+	int ret;
+
+	if (fio_file_size_known(f))
+		return 0;
+
+	ret = fio_sgio_read_capacity(td, &bs, &max_lba);
+	if (ret ) {
+		td_verror(td, td->error, "fio_sgio_read_capacity");
+		log_err("ioengine sg unable to successfully execute read capacity to get block size and maximum lba\n");
+		return 1;
+	}
+
+	f->real_file_size = (max_lba + 1) * bs;
+	fio_file_set_size_known(f);
+	return 0;
+}
+
+
 static struct ioengine_ops ioengine = {
 	.name		= "sg",
 	.version	= FIO_IOOPS_VERSION,
@@ -407,11 +795,12 @@ static struct ioengine_ops ioengine = {
 	.prep		= fio_sgio_prep,
 	.queue		= fio_sgio_queue,
 	.getevents	= fio_sgio_getevents,
+	.errdetails	= fio_sgio_errdetails,
 	.event		= fio_sgio_event,
 	.cleanup	= fio_sgio_cleanup,
 	.open_file	= fio_sgio_open,
 	.close_file	= generic_close_file,
-	.get_file_size	= generic_get_file_size,
+	.get_file_size	= fio_sgio_get_file_size, // generic_get_file_size
 	.flags		= FIO_SYNCIO | FIO_RAWIO,
 };
 
diff --git a/fio.1 b/fio.1
index c1cb2a5..b049790 100644
--- a/fio.1
+++ b/fio.1
@@ -698,10 +698,13 @@ Linux when using libaio and not setting \fBdirect\fR=1, since buffered IO is
 not async on that OS. Keep an eye on the IO depth distribution in the
 fio output to verify that the achieved depth is as expected. Default: 1.
 .TP
-.BI iodepth_batch \fR=\fPint
-Number of I/Os to submit at once.  Default: \fBiodepth\fR.
+.BI iodepth_batch \fR=\fPint "\fR,\fP iodepth_batch_submit" \fR=\fPint
+This defines how many pieces of IO to submit at once. It defaults to 1
+which means that we submit each IO as soon as it is available, but can
+be raised to submit bigger batches of IO at the time. If it is set to 0
+the \fBiodepth\fR value will be used.
 .TP
-.BI iodepth_batch_complete \fR=\fPint
+.BI iodepth_batch_complete_min \fR=\fPint "\fR,\fP iodepth_batch_complete" \fR=\fPint
 This defines how many pieces of IO to retrieve at once. It defaults to 1 which
  means that we'll ask for a minimum of 1 IO in the retrieval process from the
 kernel. The IO retrieval will go on until we hit the limit set by
@@ -709,6 +712,38 @@ kernel. The IO retrieval will go on until we hit the limit set by
 completed events before queuing more IO. This helps reduce IO latency, at the
 cost of more retrieval system calls.
 .TP
+.BI iodepth_batch_complete_max \fR=\fPint
+This defines maximum pieces of IO to
+retrieve at once. This variable should be used along with
+\fBiodepth_batch_complete_min\fR=int variable, specifying the range
+of min and max amount of IO which should be retrieved. By default
+it is equal to \fBiodepth_batch_complete_min\fR value.
+
+Example #1:
+.RS
+.RS
+\fBiodepth_batch_complete_min\fR=1
+.LP
+\fBiodepth_batch_complete_max\fR=<iodepth>
+.RE
+
+which means that we will retrieve at leat 1 IO and up to the
+whole submitted queue depth. If none of IO has been completed
+yet, we will wait.
+
+Example #2:
+.RS
+\fBiodepth_batch_complete_min\fR=0
+.LP
+\fBiodepth_batch_complete_max\fR=<iodepth>
+.RE
+
+which means that we can retrieve up to the whole submitted
+queue depth, but if none of IO has been completed yet, we will
+NOT wait and immediately exit the system call. In this example
+we simply do polling.
+.RE
+.TP
 .BI iodepth_low \fR=\fPint
 Low watermark indicating when to start filling the queue again.  Default:
 \fBiodepth\fR. 
diff --git a/fio.c b/fio.c
index ee6eae2..bafbd48 100644
--- a/fio.c
+++ b/fio.c
@@ -42,6 +42,12 @@ int main(int argc, char *argv[], char *envp[])
 	if (parse_options(argc, argv))
 		goto done;
 
+	/*
+	 * line buffer stdout to avoid output lines from multiple
+	 * threads getting mixed
+	 */
+	setvbuf(stdout, NULL, _IOLBF, 0);
+
 	fio_time_init();
 
 	if (nr_clients) {
diff --git a/init.c b/init.c
index 684cd60..3f72b36 100644
--- a/init.c
+++ b/init.c
@@ -630,6 +630,13 @@ static int fixup_options(struct thread_data *td)
 	if (o->iodepth_batch > o->iodepth || !o->iodepth_batch)
 		o->iodepth_batch = o->iodepth;
 
+	/*
+	 * If max batch complete number isn't set or set incorrectly,
+	 * default to the same as iodepth_batch_complete_min
+	 */
+	if (o->iodepth_batch_complete_min > o->iodepth_batch_complete_max)
+		o->iodepth_batch_complete_max = o->iodepth_batch_complete_min;
+
 	if (o->nr_files > td->files_index)
 		o->nr_files = td->files_index;
 
diff --git a/io_u.c b/io_u.c
index 9f10206..6dda579 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1578,6 +1578,13 @@ static void __io_u_log_error(struct thread_data *td, struct io_u *io_u)
 		io_ddir_name(io_u->ddir),
 		io_u->offset, io_u->xfer_buflen);
 
+	if (td->io_ops->errdetails) {
+		char *err = td->io_ops->errdetails(io_u);
+
+		log_err("fio: %s\n", err);
+		free(err);
+	}
+
 	if (!td->error)
 		td_verror(td, io_u->error, "io_u error");
 }
@@ -1829,7 +1836,9 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
 	else if (min_evts > td->cur_depth)
 		min_evts = td->cur_depth;
 
-	ret = td_io_getevents(td, min_evts, td->o.iodepth_batch_complete, tvp);
+	/* No worries, td_io_getevents fixes min and max if they are
+	 * set incorrectly */
+	ret = td_io_getevents(td, min_evts, td->o.iodepth_batch_complete_max, tvp);
 	if (ret < 0) {
 		td_verror(td, -ret, "td_io_getevents");
 		return ret;
diff --git a/ioengine.h b/ioengine.h
index 3d49993..f7f3ec3 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -15,7 +15,7 @@
 #include <guasi.h>
 #endif
 
-#define FIO_IOOPS_VERSION	21
+#define FIO_IOOPS_VERSION	22
 
 enum {
 	IO_U_F_FREE		= 1 << 0,
@@ -144,6 +144,7 @@ struct ioengine_ops {
 	int (*commit)(struct thread_data *);
 	int (*getevents)(struct thread_data *, unsigned int, unsigned int, const struct timespec *);
 	struct io_u *(*event)(struct thread_data *, int);
+	char *(*errdetails)(struct io_u *);
 	int (*cancel)(struct thread_data *, struct io_u *);
 	void (*cleanup)(struct thread_data *);
 	int (*open_file)(struct thread_data *, struct fio_file *);
diff --git a/lib/strlcat.c b/lib/strlcat.c
new file mode 100644
index 0000000..643d496
--- /dev/null
+++ b/lib/strlcat.c
@@ -0,0 +1,23 @@
+#include <string.h>
+
+size_t strlcat(char *dst, const char *src, size_t size)
+{
+	size_t dstlen;
+	size_t srclen;
+
+	dstlen = strlen(dst);
+	size -= dstlen + 1;
+
+	/* return if no room */
+	if (!size)
+		return dstlen;
+
+	srclen = strlen(src);
+	if (srclen > size)
+		srclen = size;
+
+	memcpy(dst + dstlen, src, srclen);
+	dst[dstlen + srclen] = '\0';
+
+	return dstlen + srclen;
+}
diff --git a/lib/strlcat.h b/lib/strlcat.h
new file mode 100644
index 0000000..34b668e
--- /dev/null
+++ b/lib/strlcat.h
@@ -0,0 +1,6 @@
+#ifndef FIO_STRLCAT_H
+#define FIO_STRLCAT_h
+
+size_t strlcat(char *dst, const char *src, size_t size);
+
+#endif
diff --git a/options.c b/options.c
index 1868dfd..0169ca2 100644
--- a/options.c
+++ b/options.c
@@ -1504,11 +1504,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_IO_BASIC,
 	},
 	{
-		.name	= "iodepth_batch_complete",
-		.lname	= "IO Depth batch complete",
+		.name	= "iodepth_batch_complete_min",
+		.lname	= "Min IO depth batch complete",
+		.alias	= "iodepth_batch_complete",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(iodepth_batch_complete),
-		.help	= "Number of IO buffers to retrieve in one go",
+		.off1	= td_var_offset(iodepth_batch_complete_min),
+		.help	= "Min number of IO buffers to retrieve in one go",
 		.parent	= "iodepth",
 		.hide	= 1,
 		.minval	= 0,
@@ -1518,6 +1519,19 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_IO_BASIC,
 	},
 	{
+		.name	= "iodepth_batch_complete_max",
+		.lname	= "Max IO depth batch complete",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(iodepth_batch_complete_max),
+		.help	= "Max number of IO buffers to retrieve in one go",
+		.parent	= "iodepth",
+		.hide	= 1,
+		.minval	= 0,
+		.interval = 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IO_BASIC,
+	},
+	{
 		.name	= "iodepth_low",
 		.lname	= "IO Depth batch low",
 		.type	= FIO_OPT_INT,
diff --git a/os/os.h b/os/os.h
index f809a36..8e0b8e8 100644
--- a/os/os.h
+++ b/os/os.h
@@ -68,6 +68,10 @@ typedef struct aiocb os_aiocb_t;
 #include "../lib/strsep.h"
 #endif
 
+#ifndef CONFIG_STRLCAT
+#include "../lib/strlcat.h"
+#endif
+
 #ifdef MSG_DONTWAIT
 #define OS_MSG_DONTWAIT	MSG_DONTWAIT
 #endif
diff --git a/server.h b/server.h
index e4da882..18a689c 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 46,
+	FIO_SERVER_VER			= 47,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 38936e9..5ef560e 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -54,7 +54,8 @@ struct thread_options {
 	unsigned int iodepth;
 	unsigned int iodepth_low;
 	unsigned int iodepth_batch;
-	unsigned int iodepth_batch_complete;
+	unsigned int iodepth_batch_complete_min;
+	unsigned int iodepth_batch_complete_max;
 
 	unsigned long long size;
 	unsigned long long io_limit;
@@ -299,7 +300,9 @@ struct thread_options_pack {
 	uint32_t iodepth;
 	uint32_t iodepth_low;
 	uint32_t iodepth_batch;
-	uint32_t iodepth_batch_complete;
+	uint32_t iodepth_batch_complete_min;
+	uint32_t iodepth_batch_complete_max;
+	uint32_t __proper_alignment_for_64b;
 
 	uint64_t size;
 	uint64_t io_limit;
