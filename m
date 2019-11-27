Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48182 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfK0NAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 27 Nov 2019 08:00:10 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iZwvR-0005UM-8k
        for fio@vger.kernel.org; Wed, 27 Nov 2019 13:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191127130002.153BE1BC0156@kernel.dk>
Date: Wed, 27 Nov 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5a9d5c4ab5f7cea83dc94e7cd23ecceb45b68134:

  Merge branch 'rados-now-use-completion-callbacks' of https://github.com/aclamk/fio (2019-11-25 21:40:38 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b4d867339d3e89ca54104df104f830aa374e31c0:

  Merge branch 'fallocate-truncate' of https://github.com/tripped/fio (2019-11-26 11:57:52 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fallocate-truncate' of https://github.com/tripped/fio

Trip Volpe (1):
      filesetup: add fallocate=truncate option.

 HOWTO       | 14 +++++++++++++-
 file.h      |  1 +
 filesetup.c | 12 ++++++++++++
 fio.1       | 14 +++++++++++++-
 init.c      |  5 -----
 options.c   | 17 ++++++++---------
 os/os.h     |  2 +-
 7 files changed, 48 insertions(+), 17 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 64c6a033..88dbb03f 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1173,6 +1173,10 @@ I/O type
 			Pre-allocate via :manpage:`fallocate(2)` with
 			FALLOC_FL_KEEP_SIZE set.
 
+		**truncate**
+			Extend file to final size via :manpage:`ftruncate(2)`
+			instead of allocating.
+
 		**0**
 			Backward-compatible alias for **none**.
 
@@ -1182,7 +1186,15 @@ I/O type
 	May not be available on all supported platforms. **keep** is only available
 	on Linux. If using ZFS on Solaris this cannot be set to **posix**
 	because ZFS doesn't support pre-allocation. Default: **native** if any
-	pre-allocation methods are available, **none** if not.
+	pre-allocation methods except **truncate** are available, **none** if not.
+
+	Note that using **truncate** on Windows will interact surprisingly
+	with non-sequential write patterns. When writing to a file that has
+	been extended by setting the end-of-file information, Windows will
+	backfill the unwritten portion of the file up to that offset with
+	zeroes before issuing the new write. This means that a single small
+	write to the end of an extended file will stall until the entire
+	file has been filled with zeroes.
 
 .. option:: fadvise_hint=str
 
diff --git a/file.h b/file.h
index e50c0f9c..ae0e6fc8 100644
--- a/file.h
+++ b/file.h
@@ -67,6 +67,7 @@ enum fio_fallocate_mode {
 	FIO_FALLOCATE_POSIX	= 2,
 	FIO_FALLOCATE_KEEP_SIZE	= 3,
 	FIO_FALLOCATE_NATIVE	= 4,
+	FIO_FALLOCATE_TRUNCATE	= 5,
 };
 
 /*
diff --git a/filesetup.c b/filesetup.c
index 7d54c9f1..7fe2ebd4 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -95,6 +95,18 @@ static void fallocate_file(struct thread_data *td, struct fio_file *f)
 		break;
 		}
 #endif /* CONFIG_LINUX_FALLOCATE */
+	case FIO_FALLOCATE_TRUNCATE: {
+		int r;
+
+		dprint(FD_FILE, "ftruncate file %s size %llu\n",
+				f->file_name,
+				(unsigned long long) f->real_file_size);
+		r = ftruncate(f->fd, f->real_file_size);
+		if (r != 0)
+			td_verror(td, errno, "ftruncate");
+
+		break;
+	}
 	default:
 		log_err("fio: unknown fallocate mode: %d\n", td->o.fallocate_mode);
 		assert(0);
diff --git a/fio.1 b/fio.1
index 087d3778..14569e9f 100644
--- a/fio.1
+++ b/fio.1
@@ -943,6 +943,10 @@ Pre-allocate via \fBposix_fallocate\fR\|(3).
 Pre-allocate via \fBfallocate\fR\|(2) with
 FALLOC_FL_KEEP_SIZE set.
 .TP
+.B truncate
+Extend file to final size using \fBftruncate\fR|(2)
+instead of allocating.
+.TP
 .B 0
 Backward-compatible alias for \fBnone\fR.
 .TP
@@ -953,7 +957,15 @@ Backward-compatible alias for \fBposix\fR.
 May not be available on all supported platforms. \fBkeep\fR is only available
 on Linux. If using ZFS on Solaris this cannot be set to \fBposix\fR
 because ZFS doesn't support pre-allocation. Default: \fBnative\fR if any
-pre-allocation methods are available, \fBnone\fR if not.
+pre-allocation methods except \fBtruncate\fR are available, \fBnone\fR if not.
+.P
+Note that using \fBtruncate\fR on Windows will interact surprisingly
+with non-sequential write patterns. When writing to a file that has
+been extended by setting the end-of-file information, Windows will
+backfill the unwritten portion of the file up to that offset with
+zeroes before issuing the new write. This means that a single small
+write to the end of an extended file will stall until the entire
+file has been filled with zeroes.
 .RE
 .TP
 .BI fadvise_hint \fR=\fPstr
diff --git a/init.c b/init.c
index 63f2168e..60c85761 100644
--- a/init.c
+++ b/init.c
@@ -852,11 +852,6 @@ static int fixup_options(struct thread_data *td)
 			o->unit_base = N2S_BYTEPERSEC;
 	}
 
-#ifndef FIO_HAVE_ANY_FALLOCATE
-	/* Platform doesn't support any fallocate so force it to none */
-	o->fallocate_mode = FIO_FALLOCATE_NONE;
-#endif
-
 #ifndef CONFIG_FDATASYNC
 	if (o->fdatasync_blocks) {
 		log_info("fio: this platform does not support fdatasync()"
diff --git a/options.c b/options.c
index 2c5bf5e0..fad1857e 100644
--- a/options.c
+++ b/options.c
@@ -2412,14 +2412,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.parent = "nrfiles",
 		.hide	= 1,
 	},
-#ifdef FIO_HAVE_ANY_FALLOCATE
 	{
 		.name	= "fallocate",
 		.lname	= "Fallocate",
 		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, fallocate_mode),
 		.help	= "Whether pre-allocation is performed when laying out files",
+#ifdef FIO_HAVE_DEFAULT_FALLOCATE
 		.def	= "native",
+#else
+		.def	= "none",
+#endif
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_INVALID,
 		.posval	= {
@@ -2443,6 +2446,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "Use fallocate(..., FALLOC_FL_KEEP_SIZE, ...)",
 			  },
 #endif
+			  { .ival = "truncate",
+			    .oval = FIO_FALLOCATE_TRUNCATE,
+			    .help = "Truncate file to final size instead of allocating"
+			  },
 			  /* Compatibility with former boolean values */
 			  { .ival = "0",
 			    .oval = FIO_FALLOCATE_NONE,
@@ -2456,14 +2463,6 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 #endif
 		},
 	},
-#else	/* FIO_HAVE_ANY_FALLOCATE */
-	{
-		.name	= "fallocate",
-		.lname	= "Fallocate",
-		.type	= FIO_OPT_UNSUPPORTED,
-		.help	= "Your platform does not support fallocate",
-	},
-#endif /* FIO_HAVE_ANY_FALLOCATE */
 	{
 		.name	= "fadvise_hint",
 		.lname	= "Fadvise hint",
diff --git a/os/os.h b/os/os.h
index e4729680..dadcd87b 100644
--- a/os/os.h
+++ b/os/os.h
@@ -397,7 +397,7 @@ static inline bool fio_fallocate(struct fio_file *f, uint64_t offset, uint64_t l
 #endif
 
 #if defined(CONFIG_POSIX_FALLOCATE) || defined(FIO_HAVE_NATIVE_FALLOCATE)
-# define FIO_HAVE_ANY_FALLOCATE
+# define FIO_HAVE_DEFAULT_FALLOCATE
 #endif
 
 #ifndef FIO_HAVE_CPU_HAS

