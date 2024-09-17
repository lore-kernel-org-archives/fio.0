Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDDF175D2A
	for <fio@vger.kernel.org>; Tue, 17 Sep 2024 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726574417; cv=none; b=Qf0XuZj+omN6sb4IiAHEtStzpGMqbzA4IcthGfBYkcEU1X00IgFtW4vV/8YrE3QPEOxgh8MWBy5vnRRwbxlC3/jGmp2Y1chH3DZ3KdsbXSjFUc2uq849IpNOJiJXzhRyxO0CD5coOKQ4dRzO3W9fXiv4ikPdrFG93XqqdABjYM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726574417; c=relaxed/simple;
	bh=WcKRHkJkkG4wm3YOdaTxXB5gWxTvV0VDSJ/BwT0PJ5c=;
	h=Subject:From:To:Message-Id:Date; b=aspzymmoVwcwk3up5u9OsiRrupXYrq2eSDJwEwflaL0WpXBSzBoSy+ctpS4wHhQPV11mOX96M5b/Y0uSz5DBYquzwf8+Jtw3ADVBlgXt6SVEx/SXGt3CP14qHefNdJSu/DFT8YclFyI86hieWMKS43Izo/wYcEZG/5Z4lWsB/Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YxSvwDOO; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YxSvwDOO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=eaui9WvkonvlklTPgNg5bUI7n72okb4iAXYe0/LRHeA=; b=YxSvwDOOgFjknLXTVJAGvq6Tgj
	kZQGmp8iuySYOyrfmGgGFRmejB3rAcWbw1S3h1GwUpuEfsgxjNVLF2ziITQm25R91XGAyNDLs127l
	f1S4sfFwKQXAnKfl2/EnyHYyv+k7byMXawkAqrFH4BTzg2QWWRDARg2MTfnVFOQ14ESIExVhWj8+o
	ThDZ1lCTMAR2Iu0QRs0KPg2zf302m3vFkT//7S/RSpKtU86MPoXhRfbnzOjrBLDkaxrVG86l7ACN6
	fFs5xpm9uYuDpu+GdB9SnDnWL7vvS2v0H9aztAHWXZkc/++9CPwGYTBSQHFoHzIvJ/OQwnfyV2xPD
	MLg0QhgA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1sqWsJ-000000036eK-3H8l
	for fio@vger.kernel.org;
	Tue, 17 Sep 2024 12:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 4372E1BC014E; Tue, 17 Sep 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240917120001.4372E1BC014E@kernel.dk>
Date: Tue, 17 Sep 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit f0af0812543d3d9a4019e2979c6e32f479ee70c4:

  Update mailing list details in README.rst (2024-09-06 15:22:48 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bcd46be2adaa4afc32b836ad6137798544a3d80a:

  Merge branch 'atomic-writes' (2024-09-16 20:23:06 -0600)

----------------------------------------------------------------
Alan Adamson (1):
      pvsync2: Support RWF_ATOMIC

Jens Axboe (1):
      Merge branch 'atomic-writes'

John Garry (8):
      os-linux: Define RWF_ATOMIC
      os: Reintroduce atomic write support
      libaio: Support RWF_ATOMIC
      io_uring: Support RWF_ATOMIC
      tools/fiograph: Update for atomic support
      doc: Document atomic command
      fio: Support verify_write_sequence
      examples: Add example for atomic write verify

 HOWTO.rst                    | 25 +++++++++++++++++++++++++
 engines/io_uring.c           |  5 ++++-
 engines/libaio.c             |  7 ++++++-
 engines/sync.c               |  9 ++++++---
 examples/atomic-verify.fio   | 36 ++++++++++++++++++++++++++++++++++++
 fio.1                        | 21 +++++++++++++++++++++
 init.c                       | 14 ++++++++++++++
 ioengines.h                  |  2 ++
 options.c                    | 13 +++++++++++++
 os/os-linux.h                |  5 +++++
 thread_options.h             |  1 +
 tools/fiograph/fiograph.conf |  6 +++---
 verify.c                     |  7 ++++---
 13 files changed, 140 insertions(+), 11 deletions(-)
 create mode 100644 examples/atomic-verify.fio

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index a363206d..4f071484 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2501,6 +2501,20 @@ with the caveat that when used on the command line, they must come after the
 	For direct I/O, requests will only succeed if cache invalidation isn't required,
 	file blocks are fully allocated and the disk request could be issued immediately.
 
+.. option:: atomic=bool : [pvsync2] [libaio] [io_uring]
+
+	This option means that writes are issued with torn-write protection, meaning
+	that for a power fail or kernel crash, all or none of the data from the write
+	will be stored, but never a mix of old and new data. Torn-write protection is
+	also known as atomic writes.
+
+	This option sets the RWF_ATOMIC flag (supported from the 6.11 Linux kernel) on
+	a per-IO basis.
+
+	Writes with RWF_ATOMIC set will be rejected by the kernel when the file does
+	not support torn-write protection. To learn a file's torn-write limits, issue
+	statx with STATX_WRITE_ATOMIC.
+
 .. option:: fdp=bool : [io_uring_cmd] [xnvme]
 
 	Enable Flexible Data Placement mode for write commands.
@@ -3988,6 +4002,17 @@ Verification
         instead resets the file after the write phase and then replays I/Os for
         the verification phase.
 
+.. option:: verify_write_sequence=bool
+
+        Verify the header write sequence number. In a scenario with multiple jobs,
+        verification of the write sequence number may fail. Disabling this option
+        will mean that write sequence number checking is skipped. Doing that can be
+        useful for testing atomic writes, as it means that checksum verification can
+        still be attempted. For when :option:`atomic` is enabled, checksum
+        verification is expected to succeed (while write sequence checking can still
+        fail).
+        Defaults to true.
+
 .. option:: trim_percentage=int
 
 	Number of verify blocks to discard/trim.
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 1d4a6118..96a042a8 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -392,6 +392,8 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 		sqe->rw_flags = 0;
 		if (o->nowait)
 			sqe->rw_flags |= RWF_NOWAIT;
+		if (td->o.oatomic && io_u->ddir == DDIR_WRITE)
+			sqe->rw_flags |= RWF_ATOMIC;
 
 		/*
 		 * Since io_uring can have a submission context (sqthread_poll)
@@ -1582,7 +1584,8 @@ static struct ioengine_ops ioengine_uring = {
 	.name			= "io_uring",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD |
-					FIO_ASYNCIO_SETS_ISSUE_TIME,
+					FIO_ASYNCIO_SETS_ISSUE_TIME |
+					FIO_ATOMICWRITES,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
diff --git a/engines/libaio.c b/engines/libaio.c
index aaccc7ce..c2d43793 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -110,6 +110,10 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
 		io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
 		if (o->nowait)
 			iocb->aio_rw_flags |= RWF_NOWAIT;
+#ifdef FIO_HAVE_RWF_ATOMIC
+		if (td->o.oatomic)
+			iocb->aio_rw_flags |= RWF_ATOMIC;
+#endif
 	} else if (ddir_sync(io_u->ddir))
 		io_prep_fsync(iocb, f->fd);
 
@@ -440,7 +444,8 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.name			= "libaio",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_ASYNCIO_SYNC_TRIM |
-					FIO_ASYNCIO_SETS_ISSUE_TIME,
+					FIO_ASYNCIO_SETS_ISSUE_TIME |
+					FIO_ATOMICWRITES,
 	.init			= fio_libaio_init,
 	.post_init		= fio_libaio_post_init,
 	.prep			= fio_libaio_prep,
diff --git a/engines/sync.c b/engines/sync.c
index b8be4eb3..729d8a71 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -175,9 +175,11 @@ static enum fio_q_status fio_pvsyncio2_queue(struct thread_data *td,
 
 	if (io_u->ddir == DDIR_READ)
 		ret = preadv2(f->fd, iov, 1, io_u->offset, flags);
-	else if (io_u->ddir == DDIR_WRITE)
+	else if (io_u->ddir == DDIR_WRITE) {
+		if (td->o.oatomic)
+			flags |= RWF_ATOMIC;
 		ret = pwritev2(f->fd, iov, 1, io_u->offset, flags);
-	else if (io_u->ddir == DDIR_TRIM) {
+	} else if (io_u->ddir == DDIR_TRIM) {
 		do_io_u_trim(td, io_u);
 		return FIO_Q_COMPLETED;
 	} else
@@ -476,7 +478,8 @@ static struct ioengine_ops ioengine_pvrw2 = {
 	.open_file	= generic_open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO,
+	.flags		= FIO_SYNCIO |
+			  FIO_ATOMICWRITES,
 	.options	= options,
 	.option_struct_size	= sizeof(struct psyncv2_options),
 };
diff --git a/examples/atomic-verify.fio b/examples/atomic-verify.fio
new file mode 100644
index 00000000..17bcd89f
--- /dev/null
+++ b/examples/atomic-verify.fio
@@ -0,0 +1,36 @@
+# Data verification with atomic writes
+#
+# Some background on atomic writes:
+#
+# The main selling point of atomic writes is that it is guaranteed writes
+# to storage will not be torn for a power failure or kernel crash.
+
+# Another aspect of atomic writes is that they handle racing writes and
+# reads, such that a read racing with a write will see all the data from
+# the write or none. Well, SCSI and NVMe guarantee this if using
+# RWF_ATOMIC, but it is not formally stated as a feature of RWF_ATOMIC.
+#
+# Fio verify mode can be used to prove that atomic writes can make "safe"
+# racing reads and writes. This done by having many jobs in a xsum verify
+# mode. In this way, xsums should be correct, although a job may be
+# reading a data block written by another job; however
+# verify_write_sequence must be disabled, as it cannot be helped that data
+# blocks will be out of sequence between with many jobs.
+#
+# Atomic write limits:
+# For a block device, the max block size for atomic=1 is in
+# /sys/block/sdXXX/queue/atomic_write_unit_max_bytes
+# or this value can also be read with a statx syscall on the bdev file.
+
+[write-and-verify]
+rw=randwrite
+bs=4k
+direct=1
+ioengine=libaio
+iodepth=16
+verify=crc64
+atomic=1
+verify_write_sequence=0
+numjobs=10
+# Use /dev/XXX or filename
+filename=/dev/XXX
diff --git a/fio.1 b/fio.1
index a4ab07ed..0fd0fb25 100644
--- a/fio.1
+++ b/fio.1
@@ -2266,6 +2266,19 @@ cached data. Currently the RWF_NOWAIT flag does not supported for cached write.
 For direct I/O, requests will only succeed if cache invalidation isn't required,
 file blocks are fully allocated and the disk request could be issued immediately.
 .TP
+.BI (pvsync2,libaio,io_uring)atomic \fR=\fPbool
+This option means that writes are issued with torn-write protection, meaning
+that for a power fail or kernel crash, all or none of the data from the write
+will be stored, but never a mix of old and new data. Torn-write protection is
+also known as atomic writes.
+
+This option sets the RWF_ATOMIC flag (supported from the 6.11 Linux kernel) on
+a per-IO basis.
+
+Writes with RWF_ATOMIC set will be rejected by the kernel when the file does
+not support torn-write protection. To learn a file's torn-write limits, issue
+statx with STATX_WRITE_ATOMIC.
+.TP
 .BI (io_uring_cmd,xnvme)fdp \fR=\fPbool
 Enable Flexible Data Placement mode for write commands.
 .TP
@@ -3713,6 +3726,14 @@ Enable experimental verification. Standard verify records I/O metadata for
 later use during the verification phase. Experimental verify instead resets the
 file after the write phase and then replays I/Os for the verification phase.
 .TP
+.BI verify_write_sequence \fR=\fPbool
+Verify the header write sequence number. In a scenario with multiple jobs,
+verification of the write sequence number may fail. Disabling this option
+will mean that write sequence number checking is skipped. Doing that can be
+useful for testing atomic writes, as it means that checksum verification can
+still be attempted. For when \fBatomic\fR is enabled, checksum verification
+is expected to succeed (while write sequence checking can still fail).
+.TP
 .BI trim_percentage \fR=\fPint
 Number of verify blocks to discard/trim.
 .TP
diff --git a/init.c b/init.c
index 414535cc..96a03d98 100644
--- a/init.c
+++ b/init.c
@@ -853,6 +853,20 @@ static int fixup_options(struct thread_data *td)
 		    (o->max_bs[DDIR_WRITE] % o->verify_interval))
 			o->verify_interval = gcd(o->min_bs[DDIR_WRITE],
 							o->max_bs[DDIR_WRITE]);
+
+		if (td->o.verify_only)
+			o->verify_write_sequence = 0;
+	}
+
+	if (td->o.oatomic) {
+		if (!td_ioengine_flagged(td, FIO_ATOMICWRITES)) {
+			log_err("fio: engine does not support atomic writes\n");
+			td->o.oatomic = 0;
+			ret |= 1;
+		}
+
+		if (!td_write(td))
+			td->o.oatomic = 0;
 	}
 
 	if (o->pre_read) {
diff --git a/ioengines.h b/ioengines.h
index b9834fec..1531cd89 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -96,6 +96,7 @@ enum {
 	__FIO_RO_NEEDS_RW_OPEN,		/* open files in rw mode even if we have a read job; only
 					   affects ioengines using generic_open_file */
 	__FIO_MULTI_RANGE_TRIM,		/* ioengine supports trim with more than one range */
+	__FIO_ATOMICWRITES,		/* ioengine supports atomic writes */
 	__FIO_IOENGINE_F_LAST,		/* not a real bit; used to count number of bits */
 };
 
@@ -120,6 +121,7 @@ enum fio_ioengine_flags {
 	FIO_SKIPPABLE_IOMEM_ALLOC	= 1 << __FIO_SKIPPABLE_IOMEM_ALLOC,
 	FIO_RO_NEEDS_RW_OPEN		= 1 << __FIO_RO_NEEDS_RW_OPEN,
 	FIO_MULTI_RANGE_TRIM		= 1 << __FIO_MULTI_RANGE_TRIM,
+	FIO_ATOMICWRITES		= 1 << __FIO_ATOMICWRITES,
 };
 
 /*
diff --git a/options.c b/options.c
index 5a6b0a06..c35878f7 100644
--- a/options.c
+++ b/options.c
@@ -2926,6 +2926,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_TYPE,
 	},
+#ifdef FIO_HAVE_RWF_ATOMIC
 	{
 		.name	= "atomic",
 		.lname	= "Atomic I/O",
@@ -2936,6 +2937,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_TYPE,
 	},
+#endif
 	{
 		.name	= "buffered",
 		.lname	= "Buffered I/O",
@@ -3395,6 +3397,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_VERIFY,
 	},
+	{
+		.name	= "verify_write_sequence",
+		.lname	= "Verify write sequence number",
+		.off1	= offsetof(struct thread_options, verify_write_sequence),
+		.type	= FIO_OPT_BOOL,
+		.def	= "1",
+		.help	= "Verify header write sequence number",
+		.parent	= "verify",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_VERIFY,
+	},
 #ifdef FIO_HAVE_TRIM
 	{
 		.name	= "trim_percentage",
diff --git a/os/os-linux.h b/os/os-linux.h
index 4d150311..ead8295c 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -62,6 +62,7 @@
 #define FIO_HAVE_BYTEORDER_FUNCS
 #define FIO_HAVE_PWRITEV2
 #define FIO_HAVE_SHM_ATTACH_REMOVED
+#define FIO_HAVE_RWF_ATOMIC
 
 #ifdef MAP_HUGETLB
 #define FIO_HAVE_MMAP_HUGE
@@ -328,6 +329,10 @@ static inline int fio_set_sched_idle(void)
 #define RWF_NOWAIT	0x00000008
 #endif
 
+#ifndef RWF_ATOMIC
+#define RWF_ATOMIC	0x00000040
+#endif
+
 #ifndef RWF_WRITE_LIFE_SHIFT
 #define RWF_WRITE_LIFE_SHIFT		4
 #define RWF_WRITE_LIFE_SHORT		(1 << RWF_WRITE_LIFE_SHIFT)
diff --git a/thread_options.h b/thread_options.h
index ee1e5b31..d0e0a4ae 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -156,6 +156,7 @@ struct thread_options {
 	unsigned int experimental_verify;
 	unsigned int verify_state;
 	unsigned int verify_state_save;
+	unsigned int verify_write_sequence;
 	unsigned int use_thread;
 	unsigned int unlink;
 	unsigned int unlink_each_loop;
diff --git a/tools/fiograph/fiograph.conf b/tools/fiograph/fiograph.conf
index 122f2baf..75712180 100644
--- a/tools/fiograph/fiograph.conf
+++ b/tools/fiograph/fiograph.conf
@@ -51,13 +51,13 @@ specific_options=https  http_host  http_user  http_pass  http_s3_key  http_s3_ke
 specific_options=ime_psync  ime_psyncv
 
 [ioengine_io_uring]
-specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  nowait  force_async
+specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  nowait  force_async atomic
 
 [ioengine_io_uring_cmd]
 specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  nowait  force_async  cmd_type  md_per_io_size  pi_act  pi_chk  apptag  apptag_mask
 
 [ioengine_libaio]
-specific_options=userspace_reap  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  nowait
+specific_options=userspace_reap  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  nowait atomic
 
 [ioengine_libblkio]
 specific_options=libblkio_driver  libblkio_path  libblkio_pre_connect_props  libblkio_num_entries  libblkio_queue_size  libblkio_pre_start_props  hipri  libblkio_vectored  libblkio_write_zeroes_on_trim  libblkio_wait_mode  libblkio_force_enable_completion_eventfd
@@ -99,7 +99,7 @@ specific_options=hostname  bindname  port  verb
 specific_options=hipri  readfua  writefua  sg_write_mode  stream_id
 
 [ioengine_pvsync2]
-specific_options=hipri  hipri_percentage  nowait  sync  psync  vsync  pvsync
+specific_options=hipri  hipri_percentage  nowait  sync  psync  vsync  pvsync atomic
 
 [ioengine_xnvme]
 specific_options=hipri  sqthread_poll  xnvme_be  xnvme_async  xnvme_sync  xnvme_admin  xnvme_dev_nsid  xnvme_iovec
diff --git a/verify.c b/verify.c
index b2fede24..f3d228ba 100644
--- a/verify.c
+++ b/verify.c
@@ -848,12 +848,13 @@ static int verify_header(struct io_u *io_u, struct thread_data *td,
 	/*
 	 * For read-only workloads, the program cannot be certain of the
 	 * last numberio written to a block. Checking of numberio will be
-	 * done only for workloads that write data.  For verify_only,
-	 * numberio check is skipped.
+	 * done only for workloads that write data.  For verify_only or
+	 * any mode de-selecting verify_write_sequence, numberio check is
+	 * skipped.
 	 */
 	if (td_write(td) && (td_min_bs(td) == td_max_bs(td)) &&
 	    !td->o.time_based)
-		if (!td->o.verify_only)
+		if (td->o.verify_write_sequence)
 			if (hdr->numberio != io_u->numberio) {
 				log_err("verify: bad header numberio %"PRIu16
 					", wanted %"PRIu16,
