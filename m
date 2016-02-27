Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38631 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbcB0NAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 27 Feb 2016 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aZeTa-0007Qq-C4
	for fio@vger.kernel.org; Sat, 27 Feb 2016 13:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160227130001.BEB0D2C1369@kernel.dk>
Date: Sat, 27 Feb 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e6727cbdd34a6ec30b437311724a6aa60e6b06fd:

  ioengines: account any queued IO on the engine side (2016-02-25 12:24:47 -0800)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2cafffbea5d2ed2f20d73efa0d82baa9046e0b12:

  Add support for preadv2/pwritev2 (2016-02-26 11:02:54 -0800)

----------------------------------------------------------------
Jens Axboe (1):
      Add support for preadv2/pwritev2

 HOWTO          |  3 +++
 configure      | 19 ++++++++++++++++
 engines/sync.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fio.1          |  7 ++++++
 options.c      |  5 +++++
 5 files changed, 105 insertions(+)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 5e765d4..c37a9e0 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1784,6 +1784,9 @@ that defines them is selected.
 		enabled when polling for a minimum of 0 events (eg when
 		iodepth_batch_complete=0).
 
+[psyncv2] hipri		Set RWF_HIPRI on IO, indicating to the kernel that
+			it's of higher priority than normal.
+
 [cpu] cpuload=int Attempt to use the specified percentage of CPU cycles.
 
 [cpu] cpuchunks=int Split the load into cycles of the given time. In
diff --git a/configure b/configure
index cbd4d30..6e2488c 100755
--- a/configure
+++ b/configure
@@ -1241,6 +1241,22 @@ fi
 echo "pwritev/preadv                $pwritev"
 
 ##########################################
+# Check whether we have pwritev2/preadv2
+pwritev2="no"
+cat > $TMPC << EOF
+#include <stdio.h>
+#include <sys/uio.h>
+int main(int argc, char **argv)
+{
+  return pwritev2(0, NULL, 1, 0, 0) + preadv2(0, NULL, 1, 0, 0);
+}
+EOF
+if compile_prog "" "" "pwritev2"; then
+  pwritev2="yes"
+fi
+echo "pwritev2/preadv2              $pwritev2"
+
+##########################################
 # Check whether we have the required functions for ipv6
 ipv6="no"
 cat > $TMPC << EOF
@@ -1742,6 +1758,9 @@ fi
 if test "$pwritev" = "yes" ; then
   output_sym "CONFIG_PWRITEV"
 fi
+if test "$pwritev2" = "yes" ; then
+  output_sym "CONFIG_PWRITEV2"
+fi
 if test "$ipv6" = "yes" ; then
   output_sym "CONFIG_IPV6"
 fi
diff --git a/engines/sync.c b/engines/sync.c
index f5801fe..0b0d1a7 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -13,6 +13,7 @@
 #include <assert.h>
 
 #include "../fio.h"
+#include "../optgroup.h"
 
 /*
  * Sync engine uses engine_data to store last offset
@@ -31,6 +32,28 @@ struct syncio_data {
 	enum fio_ddir last_ddir;
 };
 
+#ifdef CONFIG_PWRITEV2
+struct psyncv2_options {
+	void *pad;
+	unsigned int hipri;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	= "hipri",
+		.lname	= "RWF_HIPRI",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct psyncv2_options, hipri),
+		.help	= "Set RWF_HIPRI for pwritev2/preadv2",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
+		.name	= NULL,
+	},
+};
+#endif
+
 static int fio_syncio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
@@ -98,6 +121,38 @@ static int fio_pvsyncio_queue(struct thread_data *td, struct io_u *io_u)
 }
 #endif
 
+#ifdef CONFIG_PWRITEV2
+static int fio_pvsyncio2_queue(struct thread_data *td, struct io_u *io_u)
+{
+	struct syncio_data *sd = td->io_ops->data;
+	struct psyncv2_options *o = td->eo;
+	struct iovec *iov = &sd->iovecs[0];
+	struct fio_file *f = io_u->file;
+	int ret, flags = 0;
+
+	fio_ro_check(td, io_u);
+
+	if (o->hipri)
+		flags |= RWF_HIPRI;
+
+	iov->iov_base = io_u->xfer_buf;
+	iov->iov_len = io_u->xfer_buflen;
+
+	if (io_u->ddir == DDIR_READ)
+		ret = preadv2(f->fd, iov, 1, io_u->offset, flags);
+	else if (io_u->ddir == DDIR_WRITE)
+		ret = pwritev2(f->fd, iov, 1, io_u->offset, flags);
+	else if (io_u->ddir == DDIR_TRIM) {
+		do_io_u_trim(td, io_u);
+		return FIO_Q_COMPLETED;
+	} else
+		ret = do_io_u_sync(td, io_u);
+
+	return fio_io_end(td, io_u, ret);
+}
+#endif
+
+
 static int fio_psyncio_queue(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
@@ -374,6 +429,22 @@ static struct ioengine_ops ioengine_pvrw = {
 };
 #endif
 
+#ifdef CONFIG_PWRITEV2
+static struct ioengine_ops ioengine_pvrw2 = {
+	.name		= "pvsync2",
+	.version	= FIO_IOOPS_VERSION,
+	.init		= fio_vsyncio_init,
+	.cleanup	= fio_vsyncio_cleanup,
+	.queue		= fio_pvsyncio2_queue,
+	.open_file	= generic_open_file,
+	.close_file	= generic_close_file,
+	.get_file_size	= generic_get_file_size,
+	.flags		= FIO_SYNCIO,
+	.options	= options,
+	.option_struct_size	= sizeof(struct psyncv2_options),
+};
+#endif
+
 static void fio_init fio_syncio_register(void)
 {
 	register_ioengine(&ioengine_rw);
diff --git a/fio.1 b/fio.1
index 690c8f4..f98802a 100644
--- a/fio.1
+++ b/fio.1
@@ -591,6 +591,9 @@ coalescing adjacent IOs into a single submission.
 .B pvsync
 Basic \fBpreadv\fR\|(2) or \fBpwritev\fR\|(2) I/O.
 .TP
+.B pvsync2
+Basic \fBpreadv2\fR\|(2) or \fBpwritev2\fR\|(2) I/O.
+.TP
 .B libaio
 Linux native asynchronous I/O. This ioengine defines engine specific options.
 .TP
@@ -1647,6 +1650,10 @@ from user-space to reap events. The reaping mode is only
 enabled when polling for a minimum of 0 events (eg when
 iodepth_batch_complete=0).
 .TP
+.BI (psyncv2)hipri
+Set RWF_HIPRI on IO, indicating to the kernel that it's of
+higher priority than normal.
+.TP
 .BI (net,netsplice)hostname \fR=\fPstr
 The host name or IP address to use for TCP or UDP based IO.
 If the job is a TCP listener or UDP reader, the hostname is not
diff --git a/options.c b/options.c
index 3902087..ac2da71 100644
--- a/options.c
+++ b/options.c
@@ -1240,6 +1240,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "Use preadv/pwritev",
 			  },
 #endif
+#ifdef CONFIG_PWRITEV
+			  { .ival = "pvsync2",
+			    .help = "Use preadv2/pwritev2",
+			  },
+#endif
 #ifdef CONFIG_LIBAIO
 			  { .ival = "libaio",
 			    .help = "Linux native asynchronous IO",
