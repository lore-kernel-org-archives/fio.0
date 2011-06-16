Return-Path: <egouriou@google.com>
From: Eric Gouriou <egouriou@google.com>
Subject: [PATCH v2] Add ability to invoke fallocate() FALLOC_FL_KEEP_SIZE.
Date: Thu, 16 Jun 2011 13:57:06 -0700
Message-Id: <1308257826-3342-1-git-send-email-egouriou@google.com>
In-Reply-To: <1308080427-31011-1-git-send-email-egouriou@google.com>
References: <1308080427-31011-1-git-send-email-egouriou@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Nauman Rafique <nauman@google.com>, Daniel Ehrenberg <dehrenberg@google.com>, Eric Gouriou <egouriou@google.com>
List-ID: <fio@vger.kernel.org>

Linux offers fallocate() and the FALLOC_FL_KEEP_SIZE option as
an alternative to posix_fallocate(). When FALLOC_FL_KEEP_SIZE is
specified for an falloc request going beyond the end of the file,
the requested blocks get preallocated without changing the apparent
size of the file. This is is a commonly recommended use of fallocate()
for workloads performing append writes.

This patch modifies the fallocate option from a boolean option
to a string option accepting none/posix/keep/0/1. 'keep' is only
made available on systems where FALLOC_FL_KEEP_SIZE is available
(i.e., Linux at this time). If specified, fallocate() is used
with FALLOC_FL_KEEP_SIZE set. 'none' disables pre-allocation while
'posix' uses posix_fallocate(). The default behavior remains unchaned,
i.e., invoking posix_fallocate. The settings '0'/'1' are there to
provide backward compatibility for users who had explicitly set the
boolean option.
---
Hi Jens, all,

This is version 2 of the patch submitted earlier this week. Compared
to the initial version I removed the "fallocate_keep_size" option and,
as suggested, changed "fallocate" to be a string option. I elected
to provide both descriptive and numeric compatibility values for the
old boolean values. Let me know if you disagree with that choice.

I removed the weak version of fallocate(). It is not required at this
point and not having it removed the problem of figuring what semantics
it should have if invoked.

As always, feedback is appreciated.

 Regards - Eric
---
 HOWTO         |   18 +++++++++++++-----
 file.h        |   10 ++++++++++
 filesetup.c   |   44 ++++++++++++++++++++++++++++++++++++--------
 fio.1         |   30 ++++++++++++++++++++++++++----
 fio.h         |    2 +-
 options.c     |   35 ++++++++++++++++++++++++++++++-----
 os/os-linux.h |    1 +
 7 files changed, 117 insertions(+), 23 deletions(-)

diff --git a/HOWTO b/HOWTO
index 69b8cc6..ee899b8 100644
--- a/HOWTO
+++ b/HOWTO
@@ -354,11 +354,19 @@ use_os_rand=bool Fio can either use the random generator supplied by the OS
 		internal generator, which is often of better quality and
 		faster.
 
-fallocate=bool	By default, fio will use fallocate() to advise the system
-		of the size of the file we are going to write. This can be
-		turned off with fallocate=0. May not be available on all
-		supported platforms.  If using ZFS on Solaris this must be
-		set to 0 because ZFS doesn't support it.
+fallocate=str	Whether pre-allocation is performed when laying down files.
+		Accepted values are:
+
+			none		Do not pre-allocate space
+			posix		Pre-allocate via posix_fallocate()
+			keep		Pre-allocate via fallocate() with
+					FALLOC_FL_KEEP_SIZE set
+			0		Backward-compatible alias for 'none'
+			1		Backward-compatible alias for 'posix'
+
+		May not be available on all supported platforms. 'keep' is only
+		available on Linux.If using ZFS on Solaris this must be set to
+		'none' because ZFS doesn't support it. Default: 'posix'.
 
 fadvise_hint=bool By default, fio will use fadvise() to advise the kernel
 		on what IO patterns it is likely to issue. Sometimes you
diff --git a/file.h b/file.h
index 04c0d45..b3ff051 100644
--- a/file.h
+++ b/file.h
@@ -43,6 +43,16 @@ enum {
 };
 
 /*
+ * No pre-allocation when laying down files, or call posix_fallocate(), or
+ * call fallocate() with FALLOC_FL_KEEP_SIZE set.
+ */
+enum fio_fallocate_mode {
+	FIO_FALLOCATE_NONE	= 1,
+	FIO_FALLOCATE_POSIX	= 2,
+	FIO_FALLOCATE_KEEP_SIZE	= 3,
+};
+
+/*
  * Each thread_data structure has a number of files associated with it,
  * this structure holds state information for a single file.
  */
diff --git a/filesetup.c b/filesetup.c
index 799202f..6d8aa7a 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -13,6 +13,10 @@
 #include "filehash.h"
 #include "os/os.h"
 
+#ifdef FIO_HAVE_LINUX_FALLOCATE
+#include <linux/falloc.h>
+#endif
+
 static int root_warn;
 
 static inline void clear_error(struct thread_data *td)
@@ -67,17 +71,41 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 	}
 
 #ifdef FIO_HAVE_FALLOCATE
-	if (td->o.fallocate && !td->o.fill_device) {
-		dprint(FD_FILE, "fallocate file %s size %llu\n", f->file_name,
-							f->real_file_size);
-
-		r = posix_fallocate(f->fd, 0, f->real_file_size);
-		if (r > 0) {
-			log_err("fio: posix_fallocate fails: %s\n",
-					strerror(r));
+	if (!td->o.fill_device) {
+		switch (td->o.fallocate_mode) {
+		case FIO_FALLOCATE_NONE:
+			break;
+		case FIO_FALLOCATE_POSIX:
+			dprint(FD_FILE, "posix_fallocate file %s size %llu\n",
+				 f->file_name, f->real_file_size);
+
+			r = posix_fallocate(f->fd, 0, f->real_file_size);
+			if (r > 0) {
+				log_err("fio: posix_fallocate fails: %s\n",
+						strerror(r));
+			}
+			break;
+#ifdef FIO_HAVE_LINUX_FALLOCATE
+		case FIO_FALLOCATE_KEEP_SIZE:
+			dprint(FD_FILE,
+				"fallocate(FALLOC_FL_KEEP_SIZE) "
+				"file %s size %llu\n",
+				f->file_name, f->real_file_size);
+
+			r = fallocate(f->fd, FALLOC_FL_KEEP_SIZE, 0,
+					f->real_file_size);
+			if (r != 0) {
+				td_verror(td, errno, "fallocate");
+			}
+			break;
+#endif /* FIO_HAVE_LINUX_FALLOCATE */
+		default:
+			log_err("fio: unknown fallocate mode: %d\n",
+				td->o.fallocate_mode);
+			assert(0);
 		}
 	}
-#endif
+#endif /* FIO_HAVE_FALLOCATE */
 
 	if (!new_layout)
 		goto done;
diff --git a/fio.1 b/fio.1
index 0ced604..ad5040b 100644
--- a/fio.1
+++ b/fio.1
@@ -220,10 +220,32 @@ offsets, or it can use it's own internal generator (based on Tausworthe).
 Default is to use the internal generator, which is often of better quality and
 faster. Default: false.
 .TP
-.BI fallocate \fR=\fPbool
-By default, fio will use fallocate() to advise the system of the size of the
-file we are going to write. This can be turned off with fallocate=0. May not
-be available on all supported platforms.
+.BI fallocate \fR=\fPstr
+Whether pre-allocation is performed when laying down files. Accepted values
+are:
+.RS
+.RS
+.TP
+.B none
+Do not pre-allocate space.
+.TP
+.B posix
+Pre-allocate via posix_fallocate().
+.TP
+.B keep
+Pre-allocate via fallocate() with FALLOC_FL_KEEP_SIZE set.
+.TP
+.B 0
+Backward-compatible alias for 'none'.
+.TP
+.B 1
+Backward-compatible alias for 'posix'.
+.RE
+.P
+May not be available on all supported platforms. 'keep' is only
+available on Linux. If using ZFS on Solaris this must be set to 'none'
+because ZFS doesn't support it. Default: 'posix'.
+.RE
 .TP
 .BI fadvise_hint \fR=\fPbool
 Disable use of \fIposix_fadvise\fR\|(2) to advise the kernel what I/O patterns
diff --git a/fio.h b/fio.h
index 6ad186f..16866dd 100644
--- a/fio.h
+++ b/fio.h
@@ -248,7 +248,7 @@ struct thread_options {
 	unsigned int file_service_type;
 	unsigned int group_reporting;
 	unsigned int fadvise_hint;
-	unsigned int fallocate;
+	enum fio_fallocate_mode fallocate_mode;
 	unsigned int zero_buffers;
 	unsigned int refill_buffers;
 	unsigned int time_based;
diff --git a/options.c b/options.c
index a9b0534..bd7dc99 100644
--- a/options.c
+++ b/options.c
@@ -1178,12 +1178,37 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 #ifdef FIO_HAVE_FALLOCATE
 	{
 		.name	= "fallocate",
-		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(fallocate),
-		.help	= "Use fallocate() when laying out files",
-		.def	= "1",
-	},
+		.type	= FIO_OPT_STR,
+		.off1	= td_var_offset(fallocate_mode),
+		.help	= "Whether pre-allocation is performed when laying out files",
+		.def	= "posix",
+		.posval	= {
+			  { .ival = "none",
+			    .oval = FIO_FALLOCATE_NONE,
+			    .help = "Do not pre-allocate space",
+			  },
+			  { .ival = "posix",
+			    .oval = FIO_FALLOCATE_POSIX,
+			    .help = "Use posix_fallocate()",
+			  },
+#ifdef FIO_HAVE_LINUX_FALLOCATE
+			  { .ival = "keep",
+			    .oval = FIO_FALLOCATE_KEEP_SIZE,
+			    .help = "Use fallocate(..., FALLOC_FL_KEEP_SIZE, ...)",
+			  },
 #endif
+			  /* Compatibility with former boolean values */
+			  { .ival = "0",
+			    .oval = FIO_FALLOCATE_NONE,
+			    .help = "Alias for 'none'",
+			  },
+			  { .ival = "1",
+			    .oval = FIO_FALLOCATE_POSIX,
+			    .help = "Alias for 'posix'",
+			  },
+		},
+	},
+#endif	/* FIO_HAVE_FALLOCATE */
 	{
 		.name	= "fadvise_hint",
 		.type	= FIO_OPT_BOOL,
diff --git a/os/os-linux.h b/os/os-linux.h
index 70c993b..024ef89 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -32,6 +32,7 @@
 #define FIO_HAVE_BLKTRACE
 #define FIO_HAVE_STRSEP
 #define FIO_HAVE_FALLOCATE
+#define FIO_HAVE_LINUX_FALLOCATE
 #define FIO_HAVE_POSIXAIO_FSYNC
 #define FIO_HAVE_PSHARED_MUTEX
 #define FIO_HAVE_CL_SIZE
-- 
1.7.3.1


