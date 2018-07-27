Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50222 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729541AbeG0NWI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 Jul 2018 09:22:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fj1Q6-0003UE-4o
        for fio@vger.kernel.org; Fri, 27 Jul 2018 12:00:30 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180727120002.1D3992C0311@kernel.dk>
Date: Fri, 27 Jul 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 40e8d8314f10a578765e20a4eb574b2603d292df:

  Merge branch 'fio-histo-log-pctiles' of https://github.com/parallel-fs-utils/fio (2018-07-25 14:42:57 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a871240086ca6bdc52f79d7459ed283c5a359299:

  Merge branch 'sgunmap2' of https://github.com/vincentkfu/fio (2018-07-26 11:47:28 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'sgunmap2' of https://github.com/vincentkfu/fio

Vincent Fu (7):
      ioengines: have ioengines with commit do own io accounting for trims
      stat: add IO submit and complete depths to JSON output
      engines/sg: support trim operations via the UNMAP command
      engines/sg: add cmdp and dxferp for trims to sg error string
      engines/sg: move asserts and debug statements behind a debug flag
      testing: add test scripts for sg ioengine
      docs: update HOWTO and manpage for sg trim support

 HOWTO             |   9 +-
 engines/libaio.c  |   2 +
 engines/sg.c      | 421 ++++++++++++++++++++++++++++++++++++++++++++++--------
 fio.1             |   7 +-
 ioengines.c       |   2 +-
 stat.c            |  45 +++++-
 t/sgunmap-perf.py | 115 +++++++++++++++
 t/sgunmap-test.py | 173 ++++++++++++++++++++++
 8 files changed, 701 insertions(+), 73 deletions(-)
 create mode 100755 t/sgunmap-perf.py
 create mode 100755 t/sgunmap-test.py

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 70eed28..804d93e 100644
--- a/HOWTO
+++ b/HOWTO
@@ -991,13 +991,15 @@ I/O type
 		**write**
 				Sequential writes.
 		**trim**
-				Sequential trims (Linux block devices only).
+				Sequential trims (Linux block devices and SCSI
+				character devices only).
 		**randread**
 				Random reads.
 		**randwrite**
 				Random writes.
 		**randtrim**
-				Random trims (Linux block devices only).
+				Random trims (Linux block devices and SCSI
+				character devices only).
 		**rw,readwrite**
 				Sequential mixed reads and writes.
 		**randrw**
@@ -1748,7 +1750,7 @@ I/O engine
 			ioctl, or if the target is an sg character device we use
 			:manpage:`read(2)` and :manpage:`write(2)` for asynchronous
 			I/O. Requires :option:`filename` option to specify either block or
-			character devices.
+			character devices. This engine supports trim operations.
 			The sg engine includes engine specific options.
 
 		**null**
@@ -2082,6 +2084,7 @@ with the caveat that when used on the command line, they must come after the
 	the force unit access (fua) flag. Default is 0.
 
 .. option:: sg_write_mode=str : [sg]
+
 	Specify the type of write commands to issue. This option can take three values:
 
 	**write**
diff --git a/engines/libaio.c b/engines/libaio.c
index dae2a70..7ac36b2 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -207,6 +207,8 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 			return FIO_Q_BUSY;
 
 		do_io_u_trim(td, io_u);
+		io_u_mark_submit(td, 1);
+		io_u_mark_complete(td, 1);
 		return FIO_Q_COMPLETED;
 	}
 
diff --git a/engines/sg.c b/engines/sg.c
index 06cd194..7741f83 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -3,6 +3,51 @@
  *
  * IO engine that uses the Linux SG v3 interface to talk to SCSI devices
  *
+ * This ioengine can operate in two modes:
+ *	sync	with block devices (/dev/sdX) or
+ *		with character devices (/dev/sgY) with direct=1 or sync=1
+ *	async	with character devices with direct=0 and sync=0
+ *
+ * What value does queue() return for the different cases?
+ *				queue() return value
+ * In sync mode:
+ *  /dev/sdX		RWT	FIO_Q_COMPLETED
+ *  /dev/sgY		RWT	FIO_Q_COMPLETED
+ *   with direct=1 or sync=1
+ *
+ * In async mode:
+ *  /dev/sgY		RWT	FIO_Q_QUEUED
+ *   direct=0 and sync=0
+ *
+ * Because FIO_SYNCIO is set for this ioengine td_io_queue() will fill in
+ * issue_time *before* each IO is sent to queue()
+ *
+ * Where are the IO counting functions called for the different cases?
+ *
+ * In sync mode:
+ *  /dev/sdX (commit==NULL)
+ *   RWT
+ *    io_u_mark_depth()			called in td_io_queue()
+ *    io_u_mark_submit/complete()	called in td_io_queue()
+ *    issue_time			set in td_io_queue()
+ *
+ *  /dev/sgY with direct=1 or sync=1 (commit does nothing)
+ *   RWT
+ *    io_u_mark_depth()			called in td_io_queue()
+ *    io_u_mark_submit/complete()	called in queue()
+ *    issue_time			set in td_io_queue()
+ *  
+ * In async mode:
+ *  /dev/sgY with direct=0 and sync=0
+ *   RW: read and write operations are submitted in queue()
+ *    io_u_mark_depth()			called in td_io_commit()
+ *    io_u_mark_submit()		called in queue()
+ *    issue_time			set in td_io_queue()
+ *   T: trim operations are queued in queue() and submitted in commit()
+ *    io_u_mark_depth()			called in td_io_commit()
+ *    io_u_mark_submit()		called in commit()
+ *    issue_time			set in commit()
+ *
  */
 #include <stdio.h>
 #include <stdlib.h>
@@ -81,6 +126,9 @@ static struct fio_option options[] = {
 #define MAX_10B_LBA  0xFFFFFFFFULL
 #define SCSI_TIMEOUT_MS 30000   // 30 second timeout; currently no method to override
 #define MAX_SB 64               // sense block maximum return size
+/*
+#define FIO_SGIO_DEBUG
+*/
 
 struct sgio_cmd {
 	unsigned char cdb[16];      // enhanced from 10 to support 16 byte commands
@@ -88,6 +136,12 @@ struct sgio_cmd {
 	int nr;
 };
 
+struct sgio_trim {
+	char *unmap_param;
+	unsigned int unmap_range_count;
+	struct io_u **trim_io_us;
+};
+
 struct sgio_data {
 	struct sgio_cmd *cmds;
 	struct io_u **events;
@@ -96,8 +150,18 @@ struct sgio_data {
 	void *sgbuf;
 	unsigned int bs;
 	int type_checked;
+	struct sgio_trim **trim_queues;
+	int current_queue;
+#ifdef FIO_SGIO_DEBUG
+	unsigned int *trim_queue_map;
+#endif
 };
 
+static inline bool sgio_unbuffered(struct thread_data *td)
+{
+	return (td->o.odirect || td->o.sync_io);
+}
+
 static void sgio_hdr_init(struct sgio_data *sd, struct sg_io_hdr *hdr,
 			  struct io_u *io_u, int fs)
 {
@@ -113,6 +177,7 @@ static void sgio_hdr_init(struct sgio_data *sd, struct sg_io_hdr *hdr,
 	hdr->mx_sb_len = sizeof(sc->sb);
 	hdr->pack_id = io_u->index;
 	hdr->usr_ptr = io_u;
+	hdr->timeout = SCSI_TIMEOUT_MS;
 
 	if (fs) {
 		hdr->dxferp = io_u->xfer_buf;
@@ -165,10 +230,11 @@ static int fio_sgio_getevents(struct thread_data *td, unsigned int min,
 			      const struct timespec fio_unused *t)
 {
 	struct sgio_data *sd = td->io_ops_data;
-	int left = max, eventNum, ret, r = 0;
+	int left = max, eventNum, ret, r = 0, trims = 0;
 	void *buf = sd->sgbuf;
-	unsigned int i, events;
+	unsigned int i, j, events;
 	struct fio_file *f;
+	struct io_u *io_u;
 
 	/*
 	 * Fill in the file descriptors
@@ -186,10 +252,20 @@ static int fio_sgio_getevents(struct thread_data *td, unsigned int min,
 		sd->pfds[i].events = POLLIN;
 	}
 
-	while (left) {
+	/*
+	** There are two counters here:
+	**  - number of SCSI commands completed
+	**  - number of io_us completed
+	**
+	** These are the same with reads and writes, but
+	** could differ with trim/unmap commands because
+	** a single unmap can include multiple io_us
+	*/
+
+	while (left > 0) {
 		char *p;
 
-		dprint(FD_IO, "sgio_getevents: sd %p: left=%d\n", sd, left);
+		dprint(FD_IO, "sgio_getevents: sd %p: min=%d, max=%d, left=%d\n", sd, min, max, left);
 
 		do {
 			if (!min)
@@ -217,15 +293,21 @@ re_read:
 		for_each_file(td, f, i) {
 			for (eventNum = 0; eventNum < left; eventNum++) {
 				ret = sg_fd_read(f->fd, p, sizeof(struct sg_io_hdr));
-				dprint(FD_IO, "sgio_getevents: ret: %d\n", ret);
+				dprint(FD_IO, "sgio_getevents: sg_fd_read ret: %d\n", ret);
 				if (ret) {
 					r = -ret;
 					td_verror(td, r, "sg_read");
 					break;
 				}
+				io_u = ((struct sg_io_hdr *)p)->usr_ptr;
+				if (io_u->ddir == DDIR_TRIM) {
+					events += sd->trim_queues[io_u->index]->unmap_range_count;
+					eventNum += sd->trim_queues[io_u->index]->unmap_range_count - 1;
+				} else
+					events++;
+
 				p += sizeof(struct sg_io_hdr);
-				events++;
-				dprint(FD_IO, "sgio_getevents: events: %d\n", events);
+				dprint(FD_IO, "sgio_getevents: events: %d, eventNum: %d, left: %d\n", events, eventNum, left);
 			}
 		}
 
@@ -241,14 +323,38 @@ re_read:
 
 		for (i = 0; i < events; i++) {
 			struct sg_io_hdr *hdr = (struct sg_io_hdr *) buf + i;
-			sd->events[i] = hdr->usr_ptr;
+			sd->events[i + trims] = hdr->usr_ptr;
+			io_u = (struct io_u *)(hdr->usr_ptr);
 
-			/* record if an io error occurred, ignore resid */
 			if (hdr->info & SG_INFO_CHECK) {
-				struct io_u *io_u;
-				io_u = (struct io_u *)(hdr->usr_ptr);
+				/* record if an io error occurred, ignore resid */
 				memcpy(&io_u->hdr, hdr, sizeof(struct sg_io_hdr));
-				sd->events[i]->error = EIO;
+				sd->events[i + trims]->error = EIO;
+			}
+
+			if (io_u->ddir == DDIR_TRIM) {
+				struct sgio_trim *st = sd->trim_queues[io_u->index];
+#ifdef FIO_SGIO_DEBUG
+				assert(st->trim_io_us[0] == io_u);
+				assert(sd->trim_queue_map[io_u->index] == io_u->index);
+				dprint(FD_IO, "sgio_getevents: reaping %d io_us from trim queue %d\n", st->unmap_range_count, io_u->index);
+				dprint(FD_IO, "sgio_getevents: reaped io_u %d and stored in events[%d]\n", io_u->index, i+trims);
+#endif
+				for (j = 1; j < st->unmap_range_count; j++) {
+					++trims;
+					sd->events[i + trims] = st->trim_io_us[j];
+#ifdef FIO_SGIO_DEBUG
+					dprint(FD_IO, "sgio_getevents: reaped io_u %d and stored in events[%d]\n", st->trim_io_us[j]->index, i+trims);
+					assert(sd->trim_queue_map[st->trim_io_us[j]->index] == io_u->index);
+#endif
+					if (hdr->info & SG_INFO_CHECK) {
+						/* record if an io error occurred, ignore resid */
+						memcpy(&st->trim_io_us[j]->hdr, hdr, sizeof(struct sg_io_hdr));
+						sd->events[i + trims]->error = EIO;
+					}
+				}
+				events -= st->unmap_range_count - 1;
+				st->unmap_range_count = 0;
 			}
 		}
 	}
@@ -287,7 +393,8 @@ static enum fio_q_status fio_sgio_ioctl_doio(struct thread_data *td,
 	return FIO_Q_COMPLETED;
 }
 
-static int fio_sgio_rw_doio(struct fio_file *f, struct io_u *io_u, int do_sync)
+static enum fio_q_status fio_sgio_rw_doio(struct fio_file *f,
+					  struct io_u *io_u, int do_sync)
 {
 	struct sg_io_hdr *hdr = &io_u->hdr;
 	int ret;
@@ -311,10 +418,11 @@ static int fio_sgio_rw_doio(struct fio_file *f, struct io_u *io_u, int do_sync)
 	return FIO_Q_QUEUED;
 }
 
-static int fio_sgio_doio(struct thread_data *td, struct io_u *io_u, int do_sync)
+static enum fio_q_status fio_sgio_doio(struct thread_data *td,
+				       struct io_u *io_u, int do_sync)
 {
 	struct fio_file *f = io_u->file;
-	int ret;
+	enum fio_q_status ret;
 
 	if (f->filetype == FIO_TYPE_BLOCK) {
 		ret = fio_sgio_ioctl_doio(td, f, io_u);
@@ -328,12 +436,41 @@ static int fio_sgio_doio(struct thread_data *td, struct io_u *io_u, int do_sync)
 	return ret;
 }
 
+static void fio_sgio_rw_lba(struct sg_io_hdr *hdr, unsigned long long lba,
+			    unsigned long long nr_blocks)
+{
+	if (lba < MAX_10B_LBA) {
+		hdr->cmdp[2] = (unsigned char) ((lba >> 24) & 0xff);
+		hdr->cmdp[3] = (unsigned char) ((lba >> 16) & 0xff);
+		hdr->cmdp[4] = (unsigned char) ((lba >>  8) & 0xff);
+		hdr->cmdp[5] = (unsigned char) (lba & 0xff);
+		hdr->cmdp[7] = (unsigned char) ((nr_blocks >> 8) & 0xff);
+		hdr->cmdp[8] = (unsigned char) (nr_blocks & 0xff);
+	} else {
+		hdr->cmdp[2] = (unsigned char) ((lba >> 56) & 0xff);
+		hdr->cmdp[3] = (unsigned char) ((lba >> 48) & 0xff);
+		hdr->cmdp[4] = (unsigned char) ((lba >> 40) & 0xff);
+		hdr->cmdp[5] = (unsigned char) ((lba >> 32) & 0xff);
+		hdr->cmdp[6] = (unsigned char) ((lba >> 24) & 0xff);
+		hdr->cmdp[7] = (unsigned char) ((lba >> 16) & 0xff);
+		hdr->cmdp[8] = (unsigned char) ((lba >>  8) & 0xff);
+		hdr->cmdp[9] = (unsigned char) (lba & 0xff);
+		hdr->cmdp[10] = (unsigned char) ((nr_blocks >> 32) & 0xff);
+		hdr->cmdp[11] = (unsigned char) ((nr_blocks >> 16) & 0xff);
+		hdr->cmdp[12] = (unsigned char) ((nr_blocks >> 8) & 0xff);
+		hdr->cmdp[13] = (unsigned char) (nr_blocks & 0xff);
+	}
+
+	return;
+}
+
 static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct sg_io_hdr *hdr = &io_u->hdr;
 	struct sg_options *o = td->eo;
 	struct sgio_data *sd = td->io_ops_data;
-	long long nr_blocks, lba;
+	unsigned long long nr_blocks, lba;
+	int offset;
 
 	if (io_u->xfer_buflen & (sd->bs - 1)) {
 		log_err("read/write not sector aligned\n");
@@ -355,6 +492,8 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 		if (o->readfua)
 			hdr->cmdp[1] |= 0x08;
 
+		fio_sgio_rw_lba(hdr, lba, nr_blocks);
+
 	} else if (io_u->ddir == DDIR_WRITE) {
 		sgio_hdr_init(sd, hdr, io_u, 1);
 
@@ -383,58 +522,111 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 				hdr->cmdp[0] = 0x93; // write same(16)
 			break;
 		};
-	} else {
+
+		fio_sgio_rw_lba(hdr, lba, nr_blocks);
+
+	} else if (io_u->ddir == DDIR_TRIM) {
+		struct sgio_trim *st;
+
+		if (sd->current_queue == -1) {
+			sgio_hdr_init(sd, hdr, io_u, 0);
+
+			hdr->cmd_len = 10;
+			hdr->dxfer_direction = SG_DXFER_TO_DEV;
+			hdr->cmdp[0] = 0x42; // unmap
+			sd->current_queue = io_u->index;
+			st = sd->trim_queues[sd->current_queue];
+			hdr->dxferp = st->unmap_param;
+#ifdef FIO_SGIO_DEBUG
+			assert(sd->trim_queues[io_u->index]->unmap_range_count == 0);
+			dprint(FD_IO, "sg: creating new queue based on io_u %d\n", io_u->index);
+#endif
+		}
+		else
+			st = sd->trim_queues[sd->current_queue];
+
+		dprint(FD_IO, "sg: adding io_u %d to trim queue %d\n", io_u->index, sd->current_queue);
+		st->trim_io_us[st->unmap_range_count] = io_u;
+#ifdef FIO_SGIO_DEBUG
+		sd->trim_queue_map[io_u->index] = sd->current_queue;
+#endif
+
+		offset = 8 + 16 * st->unmap_range_count;
+		st->unmap_param[offset] = (unsigned char) ((lba >> 56) & 0xff);
+		st->unmap_param[offset+1] = (unsigned char) ((lba >> 48) & 0xff);
+		st->unmap_param[offset+2] = (unsigned char) ((lba >> 40) & 0xff);
+		st->unmap_param[offset+3] = (unsigned char) ((lba >> 32) & 0xff);
+		st->unmap_param[offset+4] = (unsigned char) ((lba >> 24) & 0xff);
+		st->unmap_param[offset+5] = (unsigned char) ((lba >> 16) & 0xff);
+		st->unmap_param[offset+6] = (unsigned char) ((lba >>  8) & 0xff);
+		st->unmap_param[offset+7] = (unsigned char) (lba & 0xff);
+		st->unmap_param[offset+8] = (unsigned char) ((nr_blocks >> 32) & 0xff);
+		st->unmap_param[offset+9] = (unsigned char) ((nr_blocks >> 16) & 0xff);
+		st->unmap_param[offset+10] = (unsigned char) ((nr_blocks >> 8) & 0xff);
+		st->unmap_param[offset+11] = (unsigned char) (nr_blocks & 0xff);
+
+		st->unmap_range_count++;
+
+	} else if (ddir_sync(io_u->ddir)) {
 		sgio_hdr_init(sd, hdr, io_u, 0);
 		hdr->dxfer_direction = SG_DXFER_NONE;
 		if (lba < MAX_10B_LBA)
 			hdr->cmdp[0] = 0x35; // synccache(10)
 		else
 			hdr->cmdp[0] = 0x91; // synccache(16)
-	}
+	} else
+		assert(0);
 
-	/*
-	 * for synccache, we leave lba and length to 0 to sync all
-	 * blocks on medium.
-	 */
-	if (hdr->dxfer_direction != SG_DXFER_NONE) {
-		if (lba < MAX_10B_LBA) {
-			hdr->cmdp[2] = (unsigned char) ((lba >> 24) & 0xff);
-			hdr->cmdp[3] = (unsigned char) ((lba >> 16) & 0xff);
-			hdr->cmdp[4] = (unsigned char) ((lba >>  8) & 0xff);
-			hdr->cmdp[5] = (unsigned char) (lba & 0xff);
-			hdr->cmdp[7] = (unsigned char) ((nr_blocks >> 8) & 0xff);
-			hdr->cmdp[8] = (unsigned char) (nr_blocks & 0xff);
-		} else {
-			hdr->cmdp[2] = (unsigned char) ((lba >> 56) & 0xff);
-			hdr->cmdp[3] = (unsigned char) ((lba >> 48) & 0xff);
-			hdr->cmdp[4] = (unsigned char) ((lba >> 40) & 0xff);
-			hdr->cmdp[5] = (unsigned char) ((lba >> 32) & 0xff);
-			hdr->cmdp[6] = (unsigned char) ((lba >> 24) & 0xff);
-			hdr->cmdp[7] = (unsigned char) ((lba >> 16) & 0xff);
-			hdr->cmdp[8] = (unsigned char) ((lba >>  8) & 0xff);
-			hdr->cmdp[9] = (unsigned char) (lba & 0xff);
-			hdr->cmdp[10] = (unsigned char) ((nr_blocks >> 32) & 0xff);
-			hdr->cmdp[11] = (unsigned char) ((nr_blocks >> 16) & 0xff);
-			hdr->cmdp[12] = (unsigned char) ((nr_blocks >> 8) & 0xff);
-			hdr->cmdp[13] = (unsigned char) (nr_blocks & 0xff);
-		}
-	}
-
-	hdr->timeout = SCSI_TIMEOUT_MS;
 	return 0;
 }
 
+static void fio_sgio_unmap_setup(struct sg_io_hdr *hdr, struct sgio_trim *st)
+{
+	hdr->dxfer_len = st->unmap_range_count * 16 + 8;
+	hdr->cmdp[7] = (unsigned char) (((st->unmap_range_count * 16 + 8) >> 8) & 0xff);
+	hdr->cmdp[8] = (unsigned char) ((st->unmap_range_count * 16 + 8) & 0xff);
+
+	st->unmap_param[0] = (unsigned char) (((16 * st->unmap_range_count + 6) >> 8) & 0xff);
+	st->unmap_param[1] = (unsigned char)  ((16 * st->unmap_range_count + 6) & 0xff);
+	st->unmap_param[2] = (unsigned char) (((16 * st->unmap_range_count) >> 8) & 0xff);
+	st->unmap_param[3] = (unsigned char)  ((16 * st->unmap_range_count) & 0xff);
+
+	return;
+}
+
 static enum fio_q_status fio_sgio_queue(struct thread_data *td,
 					struct io_u *io_u)
 {
 	struct sg_io_hdr *hdr = &io_u->hdr;
+	struct sgio_data *sd = td->io_ops_data;
 	int ret, do_sync = 0;
 
 	fio_ro_check(td, io_u);
 
-	if (td->o.sync_io || td->o.odirect || ddir_sync(io_u->ddir))
+	if (sgio_unbuffered(td) || ddir_sync(io_u->ddir))
 		do_sync = 1;
 
+	if (io_u->ddir == DDIR_TRIM) {
+		if (do_sync || io_u->file->filetype == FIO_TYPE_BLOCK) {
+			struct sgio_trim *st = sd->trim_queues[sd->current_queue];
+
+			/* finish cdb setup for unmap because we are
+			** doing unmap commands synchronously */
+#ifdef FIO_SGIO_DEBUG
+			assert(st->unmap_range_count == 1);
+			assert(io_u == st->trim_io_us[0]);
+#endif
+			hdr = &io_u->hdr;
+
+			fio_sgio_unmap_setup(hdr, st);
+
+			st->unmap_range_count = 0;
+			sd->current_queue = -1;
+		} else
+			/* queue up trim ranges and submit in commit() */
+			return FIO_Q_QUEUED;
+	}
+
 	ret = fio_sgio_doio(td, io_u, do_sync);
 
 	if (ret < 0)
@@ -442,6 +634,14 @@ static enum fio_q_status fio_sgio_queue(struct thread_data *td,
 	else if (hdr->status) {
 		io_u->resid = hdr->resid;
 		io_u->error = EIO;
+	} else if (td->io_ops->commit != NULL) {
+		if (do_sync && !ddir_sync(io_u->ddir)) {
+			io_u_mark_submit(td, 1);
+			io_u_mark_complete(td, 1);
+		} else if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
+			io_u_mark_submit(td, 1);
+			io_u_queued(td, io_u);
+		}
 	}
 
 	if (io_u->error) {
@@ -452,6 +652,61 @@ static enum fio_q_status fio_sgio_queue(struct thread_data *td,
 	return ret;
 }
 
+static int fio_sgio_commit(struct thread_data *td)
+{
+	struct sgio_data *sd = td->io_ops_data;
+	struct sgio_trim *st;
+	struct io_u *io_u;
+	struct sg_io_hdr *hdr;
+	struct timespec now;
+	unsigned int i;
+	int ret;
+
+	if (sd->current_queue == -1)
+		return 0;
+
+	st = sd->trim_queues[sd->current_queue];
+	io_u = st->trim_io_us[0];
+	hdr = &io_u->hdr;
+
+	fio_sgio_unmap_setup(hdr, st);
+
+	sd->current_queue = -1;
+
+	ret = fio_sgio_rw_doio(io_u->file, io_u, 0);
+
+	if (ret < 0)
+		for (i = 0; i < st->unmap_range_count; i++)
+			st->trim_io_us[i]->error = errno;
+	else if (hdr->status)
+		for (i = 0; i < st->unmap_range_count; i++) {
+			st->trim_io_us[i]->resid = hdr->resid;
+			st->trim_io_us[i]->error = EIO;
+		}
+	else {
+		if (fio_fill_issue_time(td)) {
+			fio_gettime(&now, NULL);
+			for (i = 0; i < st->unmap_range_count; i++) {
+				struct io_u *io_u = st->trim_io_us[i];
+
+				memcpy(&io_u->issue_time, &now, sizeof(now));
+				io_u_queued(td, io_u);
+			}
+		}
+		io_u_mark_submit(td, st->unmap_range_count);
+	}
+
+	if (io_u->error) {
+		td_verror(td, io_u->error, "xfer");
+		return 0;
+	}
+
+	if (ret == FIO_Q_QUEUED)
+		return 0;
+	else
+		return ret;
+}
+
 static struct io_u *fio_sgio_event(struct thread_data *td, int event)
 {
 	struct sgio_data *sd = td->io_ops_data;
@@ -553,6 +808,7 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 static void fio_sgio_cleanup(struct thread_data *td)
 {
 	struct sgio_data *sd = td->io_ops_data;
+	int i;
 
 	if (sd) {
 		free(sd->events);
@@ -560,6 +816,17 @@ static void fio_sgio_cleanup(struct thread_data *td)
 		free(sd->fd_flags);
 		free(sd->pfds);
 		free(sd->sgbuf);
+#ifdef FIO_SGIO_DEBUG
+		free(sd->trim_queue_map);
+#endif
+
+		for (i = 0; i < td->o.iodepth; i++) {
+			free(sd->trim_queues[i]->unmap_param);
+			free(sd->trim_queues[i]->trim_io_us);
+			free(sd->trim_queues[i]);
+		}
+
+		free(sd->trim_queues);
 		free(sd);
 	}
 }
@@ -567,20 +834,30 @@ static void fio_sgio_cleanup(struct thread_data *td)
 static int fio_sgio_init(struct thread_data *td)
 {
 	struct sgio_data *sd;
+	struct sgio_trim *st;
+	int i;
 
-	sd = malloc(sizeof(*sd));
-	memset(sd, 0, sizeof(*sd));
-	sd->cmds = malloc(td->o.iodepth * sizeof(struct sgio_cmd));
-	memset(sd->cmds, 0, td->o.iodepth * sizeof(struct sgio_cmd));
-	sd->events = malloc(td->o.iodepth * sizeof(struct io_u *));
-	memset(sd->events, 0, td->o.iodepth * sizeof(struct io_u *));
-	sd->pfds = malloc(sizeof(struct pollfd) * td->o.nr_files);
-	memset(sd->pfds, 0, sizeof(struct pollfd) * td->o.nr_files);
-	sd->fd_flags = malloc(sizeof(int) * td->o.nr_files);
-	memset(sd->fd_flags, 0, sizeof(int) * td->o.nr_files);
-	sd->sgbuf = malloc(sizeof(struct sg_io_hdr) * td->o.iodepth);
-	memset(sd->sgbuf, 0, sizeof(struct sg_io_hdr) * td->o.iodepth);
+	sd = calloc(1, sizeof(*sd));
+	sd->cmds = calloc(td->o.iodepth, sizeof(struct sgio_cmd));
+	sd->sgbuf = calloc(td->o.iodepth, sizeof(struct sg_io_hdr));
+	sd->events = calloc(td->o.iodepth, sizeof(struct io_u *));
+	sd->pfds = calloc(td->o.nr_files, sizeof(struct pollfd));
+	sd->fd_flags = calloc(td->o.nr_files, sizeof(int));
 	sd->type_checked = 0;
+
+	sd->trim_queues = calloc(td->o.iodepth, sizeof(struct sgio_trim *));
+	sd->current_queue = -1;
+#ifdef FIO_SGIO_DEBUG
+	sd->trim_queue_map = calloc(td->o.iodepth, sizeof(int));
+#endif
+	for (i = 0; i < td->o.iodepth; i++) {
+		sd->trim_queues[i] = calloc(1, sizeof(struct sgio_trim));
+		st = sd->trim_queues[i];
+		st->unmap_param = calloc(td->o.iodepth + 1, sizeof(char[16]));
+		st->unmap_range_count = 0;
+		st->trim_io_us = calloc(td->o.iodepth, sizeof(struct io_u *));
+	}
+
 	td->io_ops_data = sd;
 
 	/*
@@ -632,6 +909,12 @@ static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 	if (f->filetype == FIO_TYPE_BLOCK) {
 		td->io_ops->getevents = NULL;
 		td->io_ops->event = NULL;
+		td->io_ops->commit = NULL;
+		/*
+		** Setting these functions to null may cause problems
+		** with filename=/dev/sda:/dev/sg0 since we are only
+		** considering a single file
+		*/
 	}
 	sd->type_checked = 1;
 
@@ -848,6 +1131,23 @@ static char *fio_sgio_errdetails(struct io_u *io_u)
 			snprintf(msgchunk, MAXMSGCHUNK, "SG Driver: %d bytes out of %d not transferred. ", hdr->resid, hdr->dxfer_len);
 			strlcat(msg, msgchunk, MAXERRDETAIL);
 		}
+		if (hdr->cmdp) {
+			strlcat(msg, "cdb:", MAXERRDETAIL);
+			for (i = 0; i < hdr->cmd_len; i++) {
+				snprintf(msgchunk, MAXMSGCHUNK, " %02x", hdr->cmdp[i]);
+				strlcat(msg, msgchunk, MAXERRDETAIL);
+			}
+			strlcat(msg, ". ", MAXERRDETAIL);
+			if (io_u->ddir == DDIR_TRIM) {
+				unsigned char *param_list = hdr->dxferp;
+				strlcat(msg, "dxferp:", MAXERRDETAIL);
+				for (i = 0; i < hdr->dxfer_len; i++) {
+					snprintf(msgchunk, MAXMSGCHUNK, " %02x", param_list[i]);
+					strlcat(msg, msgchunk, MAXERRDETAIL);
+				}
+				strlcat(msg, ". ", MAXERRDETAIL);
+			}
+		}
 	}
 
 	if (!(hdr->info & SG_INFO_CHECK) && !strlen(msg))
@@ -906,6 +1206,7 @@ static struct ioengine_ops ioengine = {
 	.init		= fio_sgio_init,
 	.prep		= fio_sgio_prep,
 	.queue		= fio_sgio_queue,
+	.commit		= fio_sgio_commit,
 	.getevents	= fio_sgio_getevents,
 	.errdetails	= fio_sgio_errdetails,
 	.event		= fio_sgio_event,
diff --git a/fio.1 b/fio.1
index 6d2eba6..a446aba 100644
--- a/fio.1
+++ b/fio.1
@@ -757,7 +757,7 @@ Sequential reads.
 Sequential writes.
 .TP
 .B trim
-Sequential trims (Linux block devices only).
+Sequential trims (Linux block devices and SCSI character devices only).
 .TP
 .B randread
 Random reads.
@@ -766,7 +766,7 @@ Random reads.
 Random writes.
 .TP
 .B randtrim
-Random trims (Linux block devices only).
+Random trims (Linux block devices and SCSI character devices only).
 .TP
 .B rw,readwrite
 Sequential mixed reads and writes.
@@ -1524,7 +1524,8 @@ SCSI generic sg v3 I/O. May either be synchronous using the SG_IO
 ioctl, or if the target is an sg character device we use
 \fBread\fR\|(2) and \fBwrite\fR\|(2) for asynchronous
 I/O. Requires \fBfilename\fR option to specify either block or
-character devices. The sg engine includes engine specific options.
+character devices. This engine supports trim operations. The
+sg engine includes engine specific options.
 .TP
 .B null
 Doesn't transfer any data, just pretends to. This is mainly used to
diff --git a/ioengines.c b/ioengines.c
index bce65ea..e5fbcd4 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -350,7 +350,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 			 "invalid block size. Try setting direct=0.\n");
 	}
 
-	if (!td->io_ops->commit || io_u->ddir == DDIR_TRIM) {
+	if (!td->io_ops->commit) {
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
 	}
diff --git a/stat.c b/stat.c
index 8de4835..82e79df 100644
--- a/stat.c
+++ b/stat.c
@@ -1295,13 +1295,8 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	json_object_add_value_int(root, "majf", ts->majf);
 	json_object_add_value_int(root, "minf", ts->minf);
 
-
-	/* Calc % distribution of IO depths, usecond, msecond latency */
+	/* Calc % distribution of IO depths */
 	stat_calc_dist(ts->io_u_map, ddir_rw_sum(ts->total_io_u), io_u_dist);
-	stat_calc_lat_n(ts, io_u_lat_n);
-	stat_calc_lat_u(ts, io_u_lat_u);
-	stat_calc_lat_m(ts, io_u_lat_m);
-
 	tmp = json_create_object();
 	json_object_add_value_object(root, "iodepth_level", tmp);
 	/* Only show fixed 7 I/O depth levels*/
@@ -1314,6 +1309,44 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 		json_object_add_value_float(tmp, (const char *)name, io_u_dist[i]);
 	}
 
+	/* Calc % distribution of submit IO depths */
+	stat_calc_dist(ts->io_u_submit, ts->total_submit, io_u_dist);
+	tmp = json_create_object();
+	json_object_add_value_object(root, "iodepth_submit", tmp);
+	/* Only show fixed 7 I/O depth levels*/
+	for (i = 0; i < 7; i++) {
+		char name[20];
+		if (i == 0)
+			snprintf(name, 20, "0");
+		else if (i < 6)
+			snprintf(name, 20, "%d", 1 << (i+1));
+		else
+			snprintf(name, 20, ">=%d", 1 << i);
+		json_object_add_value_float(tmp, (const char *)name, io_u_dist[i]);
+	}
+
+	/* Calc % distribution of completion IO depths */
+	stat_calc_dist(ts->io_u_complete, ts->total_complete, io_u_dist);
+	tmp = json_create_object();
+	json_object_add_value_object(root, "iodepth_complete", tmp);
+	/* Only show fixed 7 I/O depth levels*/
+	for (i = 0; i < 7; i++) {
+		char name[20];
+		if (i == 0)
+			snprintf(name, 20, "0");
+		else if (i < 6)
+			snprintf(name, 20, "%d", 1 << (i+1));
+		else
+			snprintf(name, 20, ">=%d", 1 << i);
+		json_object_add_value_float(tmp, (const char *)name, io_u_dist[i]);
+	}
+
+	/* Calc % distribution of nsecond, usecond, msecond latency */
+	stat_calc_dist(ts->io_u_map, ddir_rw_sum(ts->total_io_u), io_u_dist);
+	stat_calc_lat_n(ts, io_u_lat_n);
+	stat_calc_lat_u(ts, io_u_lat_u);
+	stat_calc_lat_m(ts, io_u_lat_m);
+
 	/* Nanosecond latency */
 	tmp = json_create_object();
 	json_object_add_value_object(root, "latency_ns", tmp);
diff --git a/t/sgunmap-perf.py b/t/sgunmap-perf.py
new file mode 100755
index 0000000..fadbb85
--- /dev/null
+++ b/t/sgunmap-perf.py
@@ -0,0 +1,115 @@
+#!/usr/bin/python2.7
+#
+# sgunmap-test.py
+#
+# Basic performance testing using fio's sg ioengine
+#
+# USAGE
+# sgunmap-perf.py char-device block-device fio-executable
+#
+# EXAMPLE
+# t/sgunmap-perf.py /dev/sg1 /dev/sdb ./fio
+#
+# REQUIREMENTS
+# Python 2.6+
+#
+#
+
+from __future__ import absolute_import
+from __future__ import print_function
+import sys
+import json
+import argparse
+import subprocess
+from six.moves import range
+
+
+def parse_args():
+    parser = argparse.ArgumentParser()
+    parser.add_argument('cdev',
+                        help='character device target (e.g., /dev/sg0)')
+    parser.add_argument('bdev',
+                        help='block device target (e.g., /dev/sda)')
+    parser.add_argument('fioc',
+                        help='path to candidate fio executable (e.g., ./fio)')
+    parser.add_argument('fior',
+                        help='path to reference fio executable (e.g., ./fio)')
+    args = parser.parse_args()
+
+    return args
+
+
+def fulldevice(fio, dev, ioengine='psync', rw='trim', bs='1M'):
+    parameters = ["--name=test",
+                  "--output-format=json",
+                  "--random_generator=lfsr",
+                  "--bs={0}".format(bs),
+                  "--rw={0}".format(rw),
+                  "--ioengine={0}".format(ioengine),
+                  "--filename={0}".format(dev)]
+
+    output = subprocess.check_output([fio] + parameters)
+    jsondata = json.loads(output)
+    jobdata = jsondata['jobs'][0]
+    return jobdata
+
+
+def runtest(fio, dev, rw, qd, batch, bs='512', runtime='30s'):
+    parameters = ["--name=test",
+                  "--random_generator=tausworthe64",
+                  "--time_based",
+                  "--runtime={0}".format(runtime),
+                  "--output-format=json",
+                  "--ioengine=sg",
+                  "--blocksize={0}".format(bs),
+                  "--rw={0}".format(rw),
+                  "--filename={0}".format(dev),
+                  "--iodepth={0}".format(qd),
+                  "--iodepth_batch={0}".format(batch)]
+
+    output = subprocess.check_output([fio] + parameters)
+    jsondata = json.loads(output)
+    jobdata = jsondata['jobs'][0]
+#    print(parameters)
+
+    return jobdata
+
+
+def runtests(fio, dev, qd, batch, rw, bs='512', trials=5):
+    iops = []
+    for x in range(trials):
+        jd = runtest(fio, dev, rw, qd, batch, bs=bs)
+        total = jd['read']['iops'] + jd['write']['iops'] + jd['trim']['iops']
+#       print(total)
+        iops.extend([total])
+    return iops, (sum(iops) / trials)
+
+if __name__ == '__main__':
+    args = parse_args()
+
+    print("Trimming full device {0}".format(args.cdev))
+    fulldevice(args.fior, args.cdev, ioengine='sg')
+
+    print("Running rand read tests on {0}"
+        " with fio candidate build {1}".format(args.cdev, args.fioc))
+    randread, rrmean = runtests(args.fioc, args.cdev, 16, 1, 'randread',
+        trials=5)
+    print("IOPS mean {0}, trials {1}".format(rrmean, randread))
+
+    print("Running rand read tests on {0}"
+        " with fio reference build {1}".format(args.cdev, args.fior))
+    randread, rrmean = runtests(args.fior, args.cdev, 16, 1, 'randread',
+        trials=5)
+    print("IOPS mean {0}, trials {1}".format(rrmean, randread))
+
+    print("Running rand write tests on {0}"
+        " with fio candidate build {1}".format(args.cdev, args.fioc))
+    randwrite, rwmean = runtests(args.fioc, args.cdev, 16, 1, 'randwrite',
+        trials=5)
+    print("IOPS mean {0}, trials {1}".format(rwmean, randwrite))
+
+    print("Running rand write tests on {0}"
+        " with fio reference build {1}".format(args.cdev, args.fior))
+    randwrite, rwmean = runtests(args.fior, args.cdev, 16, 1, 'randwrite',
+        trials=5)
+    print("IOPS mean {0}, trials {1}".format(rwmean, randwrite))
diff --git a/t/sgunmap-test.py b/t/sgunmap-test.py
new file mode 100755
index 0000000..d2caa5f
--- /dev/null
+++ b/t/sgunmap-test.py
@@ -0,0 +1,173 @@
+#!/usr/bin/python2.7
+# Note: this script is python2 and python 3 compatible.
+#
+# sgunmap-test.py
+#
+# Limited functonality test for trim workloads using fio's sg ioengine
+# This checks only the three sets of reported iodepths
+#
+# !!!WARNING!!!
+# This script carries out destructive tests. Be sure that
+# there is no data you want to keep on the supplied devices.
+#
+# USAGE
+# sgunmap-test.py char-device block-device fio-executable
+#
+# EXAMPLE
+# t/sgunmap-test.py /dev/sg1 /dev/sdb ./fio
+#
+# REQUIREMENTS
+# Python 2.6+
+#
+# TEST MATRIX
+# For both char-dev and block-dev these are the expected
+# submit/complete IO depths
+#
+#                       blockdev                chardev
+#                       iodepth                 iodepth
+# R QD1                 sub/comp: 1-4=100%      sub/comp: 1-4=100%
+# W QD1                 sub/comp: 1-4=100%      sub/comp: 1-4=100%
+# T QD1                 sub/comp: 1-4=100%      sub/comp: 1-4=100%
+#
+# R QD16, batch8        sub/comp: 1-4=100%      sub/comp: 1-4=100%
+# W QD16, batch8        sub/comp: 1-4=100%      sub/comp: 1-4=100%
+# T QD16, batch8        sub/comp: 1-4=100%      sub/comp: 5-8=100%
+#
+# R QD16, batch16       sub/comp: 1-4=100%      sub/comp: 1-4=100%
+# W QD16, batch16       sub/comp: 1-4=100%      sub/comp: 1-4=100%
+# T QD16, batch16       sub/comp: 1-4=100%      sub/comp: 9-16=100%
+#
+
+from __future__ import absolute_import
+from __future__ import print_function
+import sys
+import json
+import argparse
+import traceback
+import subprocess
+from six.moves import range
+
+
+def parse_args():
+    parser = argparse.ArgumentParser()
+    parser.add_argument('chardev',
+                        help='character device target (e.g., /dev/sg0)')
+    parser.add_argument('blockdev',
+                        help='block device target (e.g., /dev/sda)')
+    parser.add_argument('fio',
+                        help='path to fio executable (e.g., ./fio)')
+    args = parser.parse_args()
+
+    return args
+
+#
+# With block devices,
+#     iodepth = 1 always
+#     submit = complete = 1-4 always
+# With character devices,
+# RW
+#     iodepth = qd
+#     submit = 1-4
+#     complete = 1-4 except for the IOs in flight
+#                when the job is ending
+# T
+#     iodepth = qd
+#     submit = qdbatch
+#     complete = qdbatch except for the IOs in flight
+#                when the job is ending
+#
+
+
+def check(jsondata, parameters, block, qd, qdbatch, rw):
+    iodepth = jsondata['iodepth_level']
+    submit = jsondata['iodepth_submit']
+    complete = jsondata['iodepth_complete']
+
+    try:
+        if block:
+            assert iodepth['1'] == 100.0
+            assert submit['4'] == 100.0
+            assert complete['4'] == 100.0
+        elif 'read' in rw or 'write' in rw:
+            assert iodepth[str(qd)] > 99.9
+            assert submit['4'] == 100.0
+            assert complete['4'] > 99.9
+        else:
+            if qdbatch <= 4:
+                batchkey = '4'
+            elif qdbatch > 64:
+                batchkey = '>=64'
+            else:
+                batchkey = str(qdbatch)
+            if qd >= 64:
+                qdkey = ">=64"
+            else:
+                qdkey = str(qd)
+            assert iodepth[qdkey] > 99
+            assert submit[batchkey] == 100.0
+            assert complete[batchkey] > 99
+    except AssertionError:
+        print("Assertion failed")
+        traceback.print_exc()
+        print(jsondata)
+        return
+
+    print("**********passed*********")
+
+
+def runalltests(args, qd, batch):
+    block = False
+    for dev in [args.chardev, args.blockdev]:
+        for rw in ["randread", "randwrite", "randtrim"]:
+            parameters = ["--name=test",
+                           "--time_based",
+                           "--runtime=30s",
+                           "--output-format=json",
+                           "--ioengine=sg",
+                           "--rw={0}".format(rw),
+                           "--filename={0}".format(dev),
+                           "--iodepth={0}".format(qd),
+                           "--iodepth_batch={0}".format(batch)]
+
+            print(parameters)
+            output = subprocess.check_output([args.fio] + parameters)
+            jsondata = json.loads(output)
+            jobdata = jsondata['jobs'][0]
+            check(jobdata, parameters, block, qd, batch, rw)
+        block = True
+
+
+def runcdevtrimtest(args, qd, batch):
+    parameters = ["--name=test",
+                   "--time_based",
+                   "--runtime=30s",
+                   "--output-format=json",
+                   "--ioengine=sg",
+                   "--rw=randtrim",
+                   "--filename={0}".format(args.chardev),
+                   "--iodepth={0}".format(qd),
+                   "--iodepth_batch={0}".format(batch)]
+
+    print(parameters)
+    output = subprocess.check_output([args.fio] + parameters)
+    jsondata = json.loads(output)
+    jobdata = jsondata['jobs'][0]
+    check(jobdata, parameters, False, qd, batch, "randtrim")
+
+
+if __name__ == '__main__':
+    args = parse_args()
+
+    runcdevtrimtest(args, 32, 2)
+    runcdevtrimtest(args, 32, 4)
+    runcdevtrimtest(args, 32, 8)
+    runcdevtrimtest(args, 64, 4)
+    runcdevtrimtest(args, 64, 8)
+    runcdevtrimtest(args, 64, 16)
+    runcdevtrimtest(args, 128, 8)
+    runcdevtrimtest(args, 128, 16)
+    runcdevtrimtest(args, 128, 32)
+
+    runalltests(args, 1, 1)
+    runalltests(args, 16, 2)
+    runalltests(args, 16, 16)
