Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45268 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgCCNAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 3 Mar 2020 08:00:14 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j979g-0006zj-Im
        for fio@vger.kernel.org; Tue, 03 Mar 2020 13:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200303130001.A3DAA1BC0169@kernel.dk>
Date: Tue,  3 Mar 2020 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 941e3356a7edde556ffd81c9767ded218de20a50:

  Merge branch 'genfio-bash' of https://github.com/sitsofe/fio (2020-03-01 15:43:14 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 41ee2319ffef9a38fff09d9c80dd997929fb51e4:

  Merge branch 'filestat3' of https://github.com/kusumi/fio (2020-03-02 09:34:38 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'filestat3' of https://github.com/kusumi/fio

Tomohiro Kusumi (1):
      engines/filestat: add statx(2) syscall support

 Makefile           |  3 +++
 configure          | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 engines/filestat.c | 24 ++++++++++++++++++++----
 oslib/statx.c      | 23 +++++++++++++++++++++++
 oslib/statx.h      | 14 ++++++++++++++
 5 files changed, 110 insertions(+), 4 deletions(-)
 create mode 100644 oslib/statx.c
 create mode 100644 oslib/statx.h

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 72ab39e9..9a5dea7f 100644
--- a/Makefile
+++ b/Makefile
@@ -132,6 +132,9 @@ endif
 ifndef CONFIG_INET_ATON
   SOURCE += oslib/inet_aton.c
 endif
+ifndef CONFIG_HAVE_STATX
+  SOURCE += oslib/statx.c
+endif
 ifdef CONFIG_GFAPI
   SOURCE += engines/glusterfs.c
   SOURCE += engines/glusterfs_sync.c
diff --git a/configure b/configure
index a1217700..5de86ca2 100755
--- a/configure
+++ b/configure
@@ -2551,6 +2551,50 @@ if compile_prog "" "" "gettid"; then
 fi
 print_config "gettid" "$gettid"
 
+##########################################
+# check for statx(2) support by libc
+statx="no"
+cat > $TMPC << EOF
+#include <unistd.h>
+#include <sys/stat.h>
+
+int main(int argc, char **argv)
+{
+	struct statx st;
+	return statx(-1, *argv, 0, 0, &st);
+}
+EOF
+if compile_prog "" "" "statx"; then
+  statx="yes"
+fi
+print_config "statx(2)/libc" "$statx"
+
+##########################################
+# check for statx(2) support by kernel
+statx_syscall="no"
+cat > $TMPC << EOF
+#include <unistd.h>
+#include <linux/stat.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+
+static int _statx(int dfd, const char *pathname, int flags, unsigned int mask,
+		  struct statx *buffer)
+{
+	return syscall(__NR_statx, dfd, pathname, flags, mask, buffer);
+}
+
+int main(int argc, char **argv)
+{
+	struct statx st;
+	return _statx(-1, *argv, 0, 0, &st);
+}
+EOF
+if compile_prog "" "" "statx_syscall"; then
+  statx_syscall="yes"
+fi
+print_config "statx(2)/syscall" "$statx_syscall"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -2843,6 +2887,12 @@ fi
 if test "$gettid" = "yes"; then
   output_sym "CONFIG_HAVE_GETTID"
 fi
+if test "$statx" = "yes"; then
+  output_sym "CONFIG_HAVE_STATX"
+fi
+if test "$statx_syscall" = "yes"; then
+  output_sym "CONFIG_HAVE_STATX_SYSCALL"
+fi
 if test "$fallthrough" = "yes"; then
   CFLAGS="$CFLAGS -Wimplicit-fallthrough"
 fi
diff --git a/engines/filestat.c b/engines/filestat.c
index 68a340bd..405f028d 100644
--- a/engines/filestat.c
+++ b/engines/filestat.c
@@ -5,6 +5,7 @@
  * of the file stat.
  */
 #include <stdio.h>
+#include <stdlib.h>
 #include <fcntl.h>
 #include <errno.h>
 #include <sys/types.h>
@@ -12,6 +13,7 @@
 #include <unistd.h>
 #include "../fio.h"
 #include "../optgroup.h"
+#include "../oslib/statx.h"
 
 struct fc_data {
 	enum fio_ddir stat_ddir;
@@ -25,7 +27,7 @@ struct filestat_options {
 enum {
 	FIO_FILESTAT_STAT	= 1,
 	FIO_FILESTAT_LSTAT	= 2,
-	/*FIO_FILESTAT_STATX	= 3,*/
+	FIO_FILESTAT_STATX	= 3,
 };
 
 static struct fio_option options[] = {
@@ -45,12 +47,10 @@ static struct fio_option options[] = {
 			    .oval = FIO_FILESTAT_LSTAT,
 			    .help = "Use lstat(2)",
 			  },
-			  /*
 			  { .ival = "statx",
 			    .oval = FIO_FILESTAT_STATX,
-			    .help = "Use statx(2)",
+			    .help = "Use statx(2) if exists",
 			  },
-			  */
 		},
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_FILESTAT,
@@ -66,6 +66,10 @@ static int stat_file(struct thread_data *td, struct fio_file *f)
 	struct timespec start;
 	int do_lat = !td->o.disable_lat;
 	struct stat statbuf;
+#ifndef WIN32
+	struct statx statxbuf;
+	char *abspath;
+#endif
 	int ret;
 
 	dprint(FD_FILE, "fd stat %s\n", f->file_name);
@@ -89,6 +93,18 @@ static int stat_file(struct thread_data *td, struct fio_file *f)
 	case FIO_FILESTAT_LSTAT:
 		ret = lstat(f->file_name, &statbuf);
 		break;
+	case FIO_FILESTAT_STATX:
+#ifndef WIN32
+		abspath = realpath(f->file_name, NULL);
+		if (abspath) {
+			ret = statx(-1, abspath, 0, STATX_ALL, &statxbuf);
+			free(abspath);
+		} else
+			ret = -1;
+#else
+		ret = -1;
+#endif
+		break;
 	default:
 		ret = -1;
 		break;
diff --git a/oslib/statx.c b/oslib/statx.c
new file mode 100644
index 00000000..1ca81ada
--- /dev/null
+++ b/oslib/statx.c
@@ -0,0 +1,23 @@
+#ifndef CONFIG_HAVE_STATX
+#include "statx.h"
+
+#ifdef CONFIG_HAVE_STATX_SYSCALL
+#include <unistd.h>
+#include <sys/syscall.h>
+
+int statx(int dfd, const char *pathname, int flags, unsigned int mask,
+	  struct statx *buffer)
+{
+	return syscall(__NR_statx, dfd, pathname, flags, mask, buffer);
+}
+#else
+#include <errno.h>
+
+int statx(int dfd, const char *pathname, int flags, unsigned int mask,
+	  struct statx *buffer)
+{
+	errno = EINVAL;
+	return -1;
+}
+#endif
+#endif
diff --git a/oslib/statx.h b/oslib/statx.h
new file mode 100644
index 00000000..d9758f73
--- /dev/null
+++ b/oslib/statx.h
@@ -0,0 +1,14 @@
+#ifndef CONFIG_HAVE_STATX
+#ifdef CONFIG_HAVE_STATX_SYSCALL
+#include <linux/stat.h>
+#include <sys/stat.h>
+#else
+#define STATX_ALL 0
+#undef statx
+struct statx
+{
+};
+#endif
+int statx(int dfd, const char *pathname, int flags, unsigned int mask,
+	  struct statx *buffer);
+#endif

