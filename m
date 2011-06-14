Return-Path: <egouriou@google.com>
From: Eric Gouriou <egouriou@google.com>
Subject: [PATCH] Add fallocate_keep_size option and functionality
Date: Tue, 14 Jun 2011 12:40:27 -0700
Message-Id: <1308080427-31011-1-git-send-email-egouriou@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Nauman Rafique <nauman@google.com>, Daniel Ehrenberg <dehrenberg@google.com>, Eric Gouriou <egouriou@google.com>
List-ID: <fio@vger.kernel.org>

Linux offers fallocate() and the FALLOC_FL_KEEP_SIZE option as
an alternative to posix_fallocate(). When FALLOC_FL_KEEP_SIZE is
specified for an falloc request going beyond the end of the file,
the requested blocks get preallocated without changing the apparent
size of the file. This is is a commonly recommended use of fallocate()
for workloads performing append writes.

On systems where FALLOC_FL_KEEP_SIZE is available (i.e., Linux at this
time), this patch add a fallocate_keep_size option, which is off by
default. When *both* the options fallocate and fallocate_keep_size are
set, then fallocate() will be used with FALLOC_FL_KEEP_SIZE set,
instead of the default posix_fallocate().

Signed-off-by: Eric Gouriou <egouriou@google.com>
---
I tried to follow the existing style and practices. I am wondering
whether introducing 'fallocate_keep_size' is the best way, or whether
I should have changed the existing 'fallocate' option from a boolean
option to a string option. Let me know what you think.

Regards - Eric
---
 HOWTO         |   12 +++++++++---
 filesetup.c   |   36 +++++++++++++++++++++++++++++-------
 fio.1         |   14 +++++++++++---
 fio.h         |    1 +
 helpers.c     |    5 +++++
 options.c     |   11 ++++++++++-
 os/os-linux.h |    1 +
 7 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/HOWTO b/HOWTO
index 69b8cc6..eb3bb9c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -354,12 +354,18 @@ use_os_rand=bool Fio can either use the random generator supplied by the OS
 		internal generator, which is often of better quality and
 		faster.
 
-fallocate=bool	By default, fio will use fallocate() to advise the system
-		of the size of the file we are going to write. This can be
-		turned off with fallocate=0. May not be available on all
+fallocate=bool	By default, fio will use posix_fallocate() to advise the
+		system of the size of the file we are going to write. This can
+		be turned off with fallocate=0. May not be available on all
 		supported platforms.  If using ZFS on Solaris this must be
 		set to 0 because ZFS doesn't support it.
 
+fallocate_keep_size=bool	If this option and the fallocate option are
+		both set, fio will invoke the Linux-specific fallocate()
+		system call with the option FALLOC_FL_KEEP_SIZE, rather than
+		posix_fallocate(). This is only available on Linux.
+		Default: false.
+
 fadvise_hint=bool By default, fio will use fadvise() to advise the kernel
 		on what IO patterns it is likely to issue. Sometimes you
 		want to test specific IO patterns without telling the
diff --git a/filesetup.c b/filesetup.c
index 799202f..ac49237 100644
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
@@ -68,16 +72,34 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 
 #ifdef FIO_HAVE_FALLOCATE
 	if (td->o.fallocate && !td->o.fill_device) {
-		dprint(FD_FILE, "fallocate file %s size %llu\n", f->file_name,
-							f->real_file_size);
-
-		r = posix_fallocate(f->fd, 0, f->real_file_size);
-		if (r > 0) {
-			log_err("fio: posix_fallocate fails: %s\n",
-					strerror(r));
+		int use_posix_fallocate = 1;
+#ifdef FIO_HAVE_LINUX_FALLOCATE
+		if (td->o.fallocate_keep_size) {
+			use_posix_fallocate = 0;
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
+		}
+#endif /* FIO_HAVE_LINUX_FALLOCATE */
+		if (use_posix_fallocate) {
+			dprint(FD_FILE, "fallocate file %s size %llu\n",
+				 f->file_name, f->real_file_size);
+
+			r = posix_fallocate(f->fd, 0, f->real_file_size);
+			if (r > 0) {
+				log_err("fio: posix_fallocate fails: %s\n",
+						strerror(r));
+			}
 		}
 	}
-#endif
+#endif /* FIO_HAVE_FALLOCATE */
 
 	if (!new_layout)
 		goto done;
diff --git a/fio.1 b/fio.1
index 0ced604..5d55e05 100644
--- a/fio.1
+++ b/fio.1
@@ -221,9 +221,17 @@ Default is to use the internal generator, which is often of better quality and
 faster. Default: false.
 .TP
 .BI fallocate \fR=\fPbool
-By default, fio will use fallocate() to advise the system of the size of the
-file we are going to write. This can be turned off with fallocate=0. May not
-be available on all supported platforms.
+By default, fio will use posix_fallocate() to advise the
+system of the size of the file we are going to write. This can
+be turned off with fallocate=0. May not be available on all
+supported platforms.  If using ZFS on Solaris this must be
+set to 0 because ZFS doesn't support it.
+.TP
+.BI fallocate_keep_size \fR=\fPbool
+If this option and the fallocate option are
+both set, fio will invoke the Linux-specific fallocate()
+system call with the option FALLOC_FL_KEEP_SIZE, rather than
+posix_fallocate(). This is only available on Linux. Default: false.
 .TP
 .BI fadvise_hint \fR=\fPbool
 Disable use of \fIposix_fadvise\fR\|(2) to advise the kernel what I/O patterns
diff --git a/fio.h b/fio.h
index 6ad186f..5ee3961 100644
--- a/fio.h
+++ b/fio.h
@@ -249,6 +249,7 @@ struct thread_options {
 	unsigned int group_reporting;
 	unsigned int fadvise_hint;
 	unsigned int fallocate;
+	unsigned int fallocate_keep_size;
 	unsigned int zero_buffers;
 	unsigned int refill_buffers;
 	unsigned int time_based;
diff --git a/helpers.c b/helpers.c
index 377dd02..0da2fd7 100644
--- a/helpers.c
+++ b/helpers.c
@@ -14,6 +14,11 @@ int __weak posix_fallocate(int fd, off_t offset, off_t len)
 {
 	return 0;
 }
+
+int __weak fallocate(int fd, int mode, off_t offset, off_t len)
+{
+	return 0;
+}
 #endif
 
 int __weak inet_aton(const char *cp, struct in_addr *inp)
diff --git a/options.c b/options.c
index a9b0534..b340477 100644
--- a/options.c
+++ b/options.c
@@ -1180,10 +1180,19 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		.name	= "fallocate",
 		.type	= FIO_OPT_BOOL,
 		.off1	= td_var_offset(fallocate),
-		.help	= "Use fallocate() when laying out files",
+		.help	= "Use posix_fallocate() or fallocate() when laying out files",
 		.def	= "1",
 	},
 #endif
+#ifdef FIO_HAVE_LINUX_FALLOCATE
+	{
+		.name	= "fallocate_keep_size",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(fallocate_keep_size),
+		.help	= "Use the FALLOC_FL_KEEP_SIZE mode if fallocate() is invoked",
+		.def	= "0",
+	},
+#endif
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


