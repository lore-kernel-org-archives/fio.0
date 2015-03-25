Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:42166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbCYMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 25 Mar 2015 08:00:09 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Yajyi-00072a-2V
	for fio@vger.kernel.org; Wed, 25 Mar 2015 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150325120002.E437840162@lyth.info>
Date: Wed, 25 Mar 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 40c666c87c2d7751abea8fc2f866404d1efbdee2:

  Always update rusage before grabbing stat_mutex (2015-03-23 10:19:44 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 37659335ac616d7c13bf8bfbb76366424b50ea67:

  Add support for POSIX_FADV_STREAMID (2015-03-24 10:20:22 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Add support for POSIX_FADV_STREAMID

 HOWTO            |    4 ++++
 fio.1            |    5 +++++
 ioengines.c      |   11 +++++++++++
 options.c        |   11 +++++++++++
 os/os-linux.h    |    6 ++++++
 server.h         |    2 +-
 thread_options.h |    3 ++-
 7 files changed, 40 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index f43f3ec..3f258db 100644
--- a/HOWTO
+++ b/HOWTO
@@ -460,6 +460,10 @@ fadvise_hint=bool By default, fio will use fadvise() to advise the kernel
 		If set, fio will use POSIX_FADV_SEQUENTIAL for sequential
 		IO and POSIX_FADV_RANDOM for random IO.
 
+fadvise_stream=int Notify the kernel what write stream ID to place these
+		writes under. Only supported on Linux. Note, this option
+		may change going forward.
+
 size=int	The total size of file io for this job. Fio will run until
 		this many bytes has been transferred, unless runtime is
 		limited by other options (such as 'runtime', for instance,
diff --git a/fio.1 b/fio.1
index 3859753..0164f42 100644
--- a/fio.1
+++ b/fio.1
@@ -378,6 +378,11 @@ because ZFS doesn't support it. Default: 'posix'.
 Use \fBposix_fadvise\fR\|(2) to advise the kernel what I/O patterns
 are likely to be issued. Default: true.
 .TP
+.BI fadvise_stream \fR=\fPint
+Use \fBposix_fadvise\fR\|(2) to advise the kernel what stream ID the
+writes issued belong to. Only supported on Linux. Note, this option
+may change going forward.
+.TP
 .BI size \fR=\fPint
 Total size of I/O for this job.  \fBfio\fR will run until this many bytes have
 been transferred, unless limited by other options (\fBruntime\fR, for instance,
diff --git a/ioengines.c b/ioengines.c
index 00098d6..b42e2c4 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -468,6 +468,17 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 			goto err;
 		}
 	}
+#ifdef FIO_HAVE_STREAMID
+	if (td->o.fadvise_stream &&
+	    (f->filetype == FIO_TYPE_BD || f->filetype == FIO_TYPE_FILE)) {
+		off_t stream = td->o.fadvise_stream;
+
+		if (posix_fadvise(f->fd, stream, f->io_size, POSIX_FADV_STREAMID) < 0) {
+			td_verror(td, errno, "fadvise streamid");
+			goto err;
+		}
+	}
+#endif
 
 #ifdef FIO_OS_DIRECTIO
 	/*
diff --git a/options.c b/options.c
index ab6e399..337fecd 100644
--- a/options.c
+++ b/options.c
@@ -2005,6 +2005,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_INVALID,
 	},
+#ifdef FIO_HAVE_STREAMID
+	{
+		.name	= "fadvise_stream",
+		.lname	= "Fadvise stream",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(fadvise_stream),
+		.help	= "Use fadvise() to set stream ID",
+		.category = FIO_OPT_C_FILE,
+		.group	= FIO_OPT_G_INVALID,
+	},
+#endif
 	{
 		.name	= "fsync",
 		.lname	= "Fsync",
diff --git a/os/os-linux.h b/os/os-linux.h
index e193634..b786393 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -282,4 +282,10 @@ static inline int fio_set_sched_idle(void)
 }
 #endif
 
+#ifndef POSIX_FADV_STREAMID
+#define POSIX_FADV_STREAMID	8
+#endif
+
+#define FIO_HAVE_STREAMID
+
 #endif
diff --git a/server.h b/server.h
index dc5a69e..da12ae0 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 42,
+	FIO_SERVER_VER			= 43,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 611f8e7..5a2428a 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -178,6 +178,7 @@ struct thread_options {
 	unsigned int file_service_type;
 	unsigned int group_reporting;
 	unsigned int fadvise_hint;
+	unsigned int fadvise_stream;
 	enum fio_fallocate_mode fallocate_mode;
 	unsigned int zero_buffers;
 	unsigned int refill_buffers;
@@ -401,6 +402,7 @@ struct thread_options_pack {
 	uint32_t file_service_type;
 	uint32_t group_reporting;
 	uint32_t fadvise_hint;
+	uint32_t fadvise_stream;
 	uint32_t fallocate_mode;
 	uint32_t zero_buffers;
 	uint32_t refill_buffers;
@@ -426,7 +428,6 @@ struct thread_options_pack {
 	uint64_t trim_backlog;
 	uint32_t clat_percentiles;
 	uint32_t percentile_precision;
-	uint32_t pad2;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
