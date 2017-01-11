Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37390 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933649AbdAKNAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 Jan 2017 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cRIVX-0002Bw-VE
        for fio@vger.kernel.org; Wed, 11 Jan 2017 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170111130002.743782C1D77@kernel.dk>
Date: Wed, 11 Jan 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 28c43a89ae13b648dd37269d288fbbea2550faa8:

  Fix comment on SCSI commands (2017-01-06 11:26:04 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9bae252254d0ce37a144cb4c8d2cb4222d539a9e:

  Python style/portability fix (2017-01-10 13:20:30 -0700)

----------------------------------------------------------------
Tomohiro Kusumi (10):
      Bring in additional sg error cases from Linux kernel (and sg3) header
      Staticize pmemblk ioengine_ops
      Fix conditional/message for max lba for sg ioengine
      Non functional fixup for 16 bytes read capacity for sg ioengine
      Mention sg ioengine requires filename option
      Fix compile time errors for skeleton_external ioengine
      Partly revert 8172fe97 in 2008 (A few debug debug log fixes)
      Add missing trailing \n in dprint()
      Fix README regarding fio snapshots
      Python style/portability fix

 HOWTO                       |  3 ++-
 README                      |  5 +++--
 engines/pmemblk.c           |  2 +-
 engines/sg.c                | 48 ++++++++++++++++++++++++++++++++-------------
 engines/skeleton_external.c |  8 ++++----
 ioengine.h                  |  9 +++------
 iolog.c                     |  2 +-
 tools/fiologparser.py       | 14 ++++++-------
 8 files changed, 55 insertions(+), 36 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 4cc733f..33f8718 100644
--- a/HOWTO
+++ b/HOWTO
@@ -819,7 +819,8 @@ ioengine=str	Defines how the job issues io to the file. The following
 				synchronous using the SG_IO ioctl, or if
 				the target is an sg character device
 				we use read(2) and write(2) for asynchronous
-				io.
+				io. Requires filename option to specify either
+				block or character devices.
 
 			null	Doesn't transfer any data, just pretends
 				to. This is mainly used to exercise fio
diff --git a/README b/README
index 875d2be..31d53fe 100644
--- a/README
+++ b/README
@@ -21,7 +21,8 @@ If git:// does not work, use the http protocol instead:
 
 	http://git.kernel.dk/fio.git
 
-Snapshots are frequently generated and include the git meta data as well.
+Snapshots are frequently generated and fio-git-*.tar.gz include the git
+meta data as well. Other tarballs are archives of official fio releases.
 Snapshots can download from:
 
 	http://brick.kernel.dk/snaps/
@@ -262,7 +263,7 @@ the copyright and license requirements currently apply to examples/ files.
 
 
 Client/server
-------------
+-------------
 
 Normally fio is invoked as a stand-alone application on the machine
 where the IO workload should be generated. However, the frontend and
diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index ca72697..5439da0 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -482,7 +482,7 @@ static int fio_pmemblk_unlink_file(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-struct ioengine_ops ioengine = {
+static struct ioengine_ops ioengine = {
 	.name = "pmemblk",
 	.version = FIO_IOOPS_VERSION,
 	.queue = fio_pmemblk_queue,
diff --git a/engines/sg.c b/engines/sg.c
index 2ad3394..3f7d911 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -20,7 +20,7 @@
 #define MAX_SB 64               // sense block maximum return size
 
 struct sgio_cmd {
-	unsigned char cdb[16];  	// increase to support 16 byte commands
+	unsigned char cdb[16];      // enhanced from 10 to support 16 byte commands
 	unsigned char sb[MAX_SB];   // add sense block to commands
 	int nr;
 };
@@ -32,7 +32,6 @@ struct sgio_data {
 	int *fd_flags;
 	void *sgbuf;
 	unsigned int bs;
-	long long max_lba;
 	int type_checked;
 };
 
@@ -309,7 +308,6 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 	 * blocks on medium.
 	 */
 	if (hdr->dxfer_direction != SG_DXFER_NONE) {
-
 		if (lba < MAX_10B_LBA) {
 			hdr->cmdp[2] = (unsigned char) ((lba >> 24) & 0xff);
 			hdr->cmdp[3] = (unsigned char) ((lba >> 16) & 0xff);
@@ -416,12 +414,11 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 	}
 
 	*bs	 = (buf[4] << 24) | (buf[5] << 16) | (buf[6] << 8) | buf[7];
-	*max_lba = ((buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3]) & 0x00000000FFFFFFFFULL;  // for some reason max_lba is being sign extended even though unsigned.
-
+	*max_lba = ((buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3]) & MAX_10B_LBA;  // for some reason max_lba is being sign extended even though unsigned.
 
 	/*
-	 * If max lba is 0xFFFFFFFF, then need to retry with
-	 * 16 byteread capacity
+	 * If max lba masked by MAX_10B_LBA equals MAX_10B_LBA,
+	 * then need to retry with 16 byte Read Capacity command.
 	 */
 	if (*max_lba == MAX_10B_LBA) {
 		hdr.cmd_len = 16;
@@ -507,7 +504,6 @@ static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 	unsigned int bs = 0;
 	unsigned long long max_lba = 0;
 
-
 	if (f->filetype == FIO_TYPE_BD) {
 		if (ioctl(f->fd, BLKSSZGET, &bs) < 0) {
 			td_verror(td, errno, "ioctl");
@@ -529,18 +525,18 @@ static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 		}
 	} else {
 		td_verror(td, EINVAL, "wrong file type");
-		log_err("ioengine sg only works on block devices\n");
+		log_err("ioengine sg only works on block or character devices\n");
 		return 1;
 	}
 
 	sd->bs = bs;
 	// Determine size of commands needed based on max_lba
-	sd->max_lba = max_lba;
-	if (max_lba > MAX_10B_LBA) {
-		dprint(FD_IO, "sgio_type_check: using 16 byte operations: max_lba = 0x%016llx\n", max_lba);
+	if (max_lba >= MAX_10B_LBA) {
+		dprint(FD_IO, "sgio_type_check: using 16 byte read/write "
+			"commands for lba above 0x%016llx/0x%016llx\n",
+			MAX_10B_LBA, max_lba);
 	}
 
-
 	if (f->filetype == FIO_TYPE_BD) {
 		td->io_ops->getevents = NULL;
 		td->io_ops->event = NULL;
@@ -630,6 +626,24 @@ static char *fio_sgio_errdetails(struct io_u *io_u)
 			case 0x0d:
 				strlcat(msg, "SG_ERR_DID_REQUEUE", MAXERRDETAIL);
 				break;
+			case 0x0e:
+				strlcat(msg, "SG_ERR_DID_TRANSPORT_DISRUPTED", MAXERRDETAIL);
+				break;
+			case 0x0f:
+				strlcat(msg, "SG_ERR_DID_TRANSPORT_FAILFAST", MAXERRDETAIL);
+				break;
+			case 0x10:
+				strlcat(msg, "SG_ERR_DID_TARGET_FAILURE", MAXERRDETAIL);
+				break;
+			case 0x11:
+				strlcat(msg, "SG_ERR_DID_NEXUS_FAILURE", MAXERRDETAIL);
+				break;
+			case 0x12:
+				strlcat(msg, "SG_ERR_DID_ALLOC_FAILURE", MAXERRDETAIL);
+				break;
+			case 0x13:
+				strlcat(msg, "SG_ERR_DID_MEDIUM_ERROR", MAXERRDETAIL);
+				break;
 			default:
 				strlcat(msg, "Unknown", MAXERRDETAIL);
 				break;
@@ -775,6 +789,12 @@ static int fio_sgio_get_file_size(struct thread_data *td, struct fio_file *f)
 	if (fio_file_size_known(f))
 		return 0;
 
+	if (f->filetype != FIO_TYPE_BD && f->filetype != FIO_TYPE_CHAR) {
+		td_verror(td, EINVAL, "wrong file type");
+		log_err("ioengine sg only works on block or character devices\n");
+		return 1;
+	}
+
 	ret = fio_sgio_read_capacity(td, &bs, &max_lba);
 	if (ret ) {
 		td_verror(td, td->error, "fio_sgio_read_capacity");
@@ -800,7 +820,7 @@ static struct ioengine_ops ioengine = {
 	.cleanup	= fio_sgio_cleanup,
 	.open_file	= fio_sgio_open,
 	.close_file	= generic_close_file,
-	.get_file_size	= fio_sgio_get_file_size, // generic_get_file_size
+	.get_file_size	= fio_sgio_get_file_size,
 	.flags		= FIO_SYNCIO | FIO_RAWIO,
 };
 
diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
index 63a6f8d..4bebcc4 100644
--- a/engines/skeleton_external.c
+++ b/engines/skeleton_external.c
@@ -109,11 +109,11 @@ static void fio_skeleton_cleanup(struct thread_data *td)
 
 /*
  * Hook for opening the given file. Unless the engine has special
- * needs, it usually just provides generic_file_open() as the handler.
+ * needs, it usually just provides generic_open_file() as the handler.
  */
 static int fio_skeleton_open(struct thread_data *td, struct fio_file *f)
 {
-	return generic_file_open(td, f);
+	return generic_open_file(td, f);
 }
 
 /*
@@ -121,12 +121,12 @@ static int fio_skeleton_open(struct thread_data *td, struct fio_file *f)
  */
 static int fio_skeleton_close(struct thread_data *td, struct fio_file *f)
 {
-	generic_file_close(td, f);
+	return generic_close_file(td, f);
 }
 
 /*
  * Note that the structure is exported, so that fio can get it via
- * dlsym(..., "ioengine");
+ * dlsym(..., "ioengine"); for (and only for) external engines.
  */
 struct ioengine_ops ioengine = {
 	.name		= "engine_name",
diff --git a/ioengine.h b/ioengine.h
index 08e8fab..89873e7 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -238,12 +238,9 @@ static inline void dprint_io_u(struct io_u *io_u, const char *p)
 	dprint(FD_IO, "%s: io_u %p: off=%llu/len=%lu/ddir=%d", p, io_u,
 					(unsigned long long) io_u->offset,
 					io_u->buflen, io_u->ddir);
-	if (fio_debug & (1 << FD_IO)) {
-		if (f)
-			log_info("/%s", f->file_name);
-
-		log_info("\n");
-	}
+	if (f)
+		dprint(FD_IO, "/%s", f->file_name);
+	dprint(FD_IO, "\n");
 }
 #else
 #define dprint_io_u(io_u, p)
diff --git a/iolog.c b/iolog.c
index 25d8dd0..2e8da13 100644
--- a/iolog.c
+++ b/iolog.c
@@ -277,7 +277,7 @@ restart:
 			overlap = 1;
 
 		if (overlap) {
-			dprint(FD_IO, "iolog: overlap %llu/%lu, %llu/%lu",
+			dprint(FD_IO, "iolog: overlap %llu/%lu, %llu/%lu\n",
 				__ipo->offset, __ipo->len,
 				ipo->offset, ipo->len);
 			td->io_hist_len--;
diff --git a/tools/fiologparser.py b/tools/fiologparser.py
index 685f419..5a95009 100755
--- a/tools/fiologparser.py
+++ b/tools/fiologparser.py
@@ -45,7 +45,7 @@ def print_full(ctx, series):
     while (start < ftime):
         end = ftime if ftime < end else end
         results = [ts.get_value(start, end) for ts in series]
-        print "%s, %s" % (end, ', '.join(["%0.3f" % i for i in results]))
+        print("%s, %s" % (end, ', '.join(["%0.3f" % i for i in results])))
         start += ctx.interval
         end += ctx.interval
 
@@ -57,7 +57,7 @@ def print_sums(ctx, series):
     while (start < ftime):
         end = ftime if ftime < end else end
         results = [ts.get_value(start, end) for ts in series]
-        print "%s, %0.3f" % (end, sum(results))
+        print("%s, %0.3f" % (end, sum(results)))
         start += ctx.interval
         end += ctx.interval
 
@@ -69,7 +69,7 @@ def print_averages(ctx, series):
     while (start < ftime):
         end = ftime if ftime < end else end
         results = [ts.get_value(start, end) for ts in series]
-        print "%s, %0.3f" % (end, float(sum(results))/len(results))
+        print("%s, %0.3f" % (end, float(sum(results))/len(results)))
         start += ctx.interval
         end += ctx.interval
 
@@ -147,11 +147,11 @@ def print_default(ctx, series):
         end += ctx.interval
 
     total = 0
-    for i in xrange(0, len(averages)):
+    for i in range(0, len(averages)):
         total += averages[i]*weights[i]
-    print '%0.3f' % (total/sum(weights))
+    print('%0.3f' % (total/sum(weights)))
  
-class TimeSeries():
+class TimeSeries(object):
     def __init__(self, ctx, fn):
         self.ctx = ctx
         self.last = None 
@@ -185,7 +185,7 @@ class TimeSeries():
             value += sample.get_contribution(start, end)
         return value
 
-class Sample():
+class Sample(object):
     def __init__(self, ctx, start, end, value):
        self.ctx = ctx
        self.start = start
