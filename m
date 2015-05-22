Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59529 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339AbbEVMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 22 May 2015 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YvlcR-00062h-7Y
	for fio@vger.kernel.org; Fri, 22 May 2015 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150522120002.129E02C1078@kernel.dk>
Date: Fri, 22 May 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fcb6b3ef8c606b60511c9c72a908e45f4cbd607b:

  Merge branch 'req4' of git://github.com/kusumi/fio (2015-05-15 20:13:58 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e81ecca33755eae1118b009d0d7b4d3c740ffb5f:

  Add 'allow_mounted_write' option (2015-05-21 21:43:48 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Add start of mount check
      Add 'allow_mounted_write' option

 HOWTO            |  6 ++++++
 Makefile         |  2 +-
 backend.c        | 24 ++++++++++++++++++++++++
 configure        | 22 ++++++++++++++++++++++
 fio.1            |  6 ++++++
 lib/mountcheck.c | 39 +++++++++++++++++++++++++++++++++++++++
 lib/mountcheck.h |  6 ++++++
 options.c        | 11 +++++++++++
 thread_options.h |  2 ++
 9 files changed, 117 insertions(+), 1 deletion(-)
 create mode 100644 lib/mountcheck.c
 create mode 100644 lib/mountcheck.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 7447512..ab0250c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1204,6 +1204,12 @@ allow_file_create=bool	If true, fio is permitted to create files as part
 		option is false, then fio will error out if the files it
 		needs to use don't already exist. Default: true.
 
+allow_mounted_write=bool	If this isn't set, fio will abort jobs that
+		are destructive (eg that write) to what appears to be a
+		mounted device or partition. This should help catch creating
+		inadvertently destructive tests, not realizing that the test
+		will destroy data on the mounted file system. Default: false.
+
 pre_read=bool	If this is given, files will be pre-read into memory before
 		starting the given IO operation. This will also clear
 		the 'invalidate' flag, since it is pointless to pre-read
diff --git a/Makefile b/Makefile
index d9aedf5..b3acbcf 100644
--- a/Makefile
+++ b/Makefile
@@ -36,7 +36,7 @@ SOURCE := gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		lib/lfsr.c gettime-thread.c helpers.c lib/flist_sort.c \
 		lib/hweight.c lib/getrusage.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
-		lib/tp.c lib/bloom.c lib/gauss.c workqueue.c
+		lib/tp.c lib/bloom.c lib/gauss.c lib/mountcheck.c workqueue.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
diff --git a/backend.c b/backend.c
index c58294b..ef5003e 100644
--- a/backend.c
+++ b/backend.c
@@ -55,6 +55,7 @@
 #include "err.h"
 #include "lib/tp.h"
 #include "workqueue.h"
+#include "lib/mountcheck.h"
 
 static pthread_t helper_thread;
 static pthread_mutex_t helper_lock;
@@ -1895,6 +1896,27 @@ static void do_usleep(unsigned int usecs)
 	usleep(usecs);
 }
 
+static int check_mount_writes(struct thread_data *td)
+{
+	struct fio_file *f;
+	unsigned int i;
+
+	if (!td_write(td) || td->o.allow_mounted_write)
+		return 0;
+
+	for_each_file(td, f, i) {
+		if (f->filetype != FIO_TYPE_BD)
+			continue;
+		if (device_is_mounted(f->file_name))
+			goto mounted;
+	}
+
+	return 0;
+mounted:
+	log_err("fio: %s appears mounted, and 'allow_mounted_write' isn't set. Aborting.", f->file_name);
+	return 1;
+}
+
 /*
  * Main function for kicking off and reaping jobs, as needed.
  */
@@ -1913,6 +1935,8 @@ static void run_threads(void)
 
 	nr_thread = nr_process = 0;
 	for_each_td(td, i) {
+		if (check_mount_writes(td))
+			return;
 		if (td->o.use_thread)
 			nr_thread++;
 		else
diff --git a/configure b/configure
index 3b871ef..5c6129d 100755
--- a/configure
+++ b/configure
@@ -1453,6 +1453,25 @@ fi
 
 echo "lex/yacc for arithmetic       $arith"
 
+##########################################
+# Check whether we have setmntent/getmntent
+getmntent="no"
+cat > $TMPC << EOF
+#include <stdio.h>
+#include <mntent.h>
+int main(int argc, char **argv)
+{
+  FILE *mtab = setmntent(NULL, "r");
+  struct mntent *mnt = getmntent(mtab);
+  endmntent(mnt);
+  return 0;
+}
+EOF
+if compile_prog "" "" "getmntent"; then
+  getmntent="yes"
+fi
+echo "getmntent                     $getmntent"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -1626,6 +1645,9 @@ if test "$arith" = "yes" ; then
     echo "YACC=$YACC" >> $config_host_mak
   fi
 fi
+if test "$getmntent" = "yes" ; then
+  output_sym "CONFIG_GETMNTENT"
+fi
 
 if test "$zlib" = "no" ; then
   echo "Consider installing zlib-dev (zlib-devel), some fio features depend on it."
diff --git a/fio.1 b/fio.1
index d5e5536..36f80d6 100644
--- a/fio.1
+++ b/fio.1
@@ -1080,6 +1080,12 @@ If true, fio is permitted to create files as part of its workload. This is
 the default behavior. If this option is false, then fio will error out if the
 files it needs to use don't already exist. Default: true.
 .TP
+.BI allow_mounted_write \fR=\fPbool
+If this isn't set, fio will abort jobs that are destructive (eg that write)
+to what appears to be a mounted device or partition. This should help catch
+creating inadvertently destructive tests, not realizing that the test will
+destroy data on the mounted file system. Default: false.
+.TP
 .BI pre_read \fR=\fPbool
 If this is given, files will be pre-read into memory before starting the given
 IO operation. This will also clear the \fR \fBinvalidate\fR flag, since it is
diff --git a/lib/mountcheck.c b/lib/mountcheck.c
new file mode 100644
index 0000000..dea2746
--- /dev/null
+++ b/lib/mountcheck.c
@@ -0,0 +1,39 @@
+#include <stdio.h>
+#include <string.h>
+#include <mntent.h>
+
+#ifdef CONFIG_GETMNTENT
+
+#define MTAB	"/etc/mtab"
+
+int device_is_mounted(const char *dev)
+{
+	FILE *mtab;
+	struct mntent *mnt;
+	int ret = 0;
+
+	mtab = setmntent(MTAB, "r");
+	if (!mtab)
+		return 0;
+
+	while ((mnt = getmntent(mtab)) != NULL) {
+		if (!mnt->mnt_fsname)
+			continue;
+		if (!strcmp(mnt->mnt_fsname, dev)) {
+			ret = 1;
+			break;
+		}
+	}
+
+	endmntent(mtab);
+	return ret;
+}
+
+#else
+
+int device_is_mounted(const char *dev)
+{
+	return 0;
+}
+
+#endif
diff --git a/lib/mountcheck.h b/lib/mountcheck.h
new file mode 100644
index 0000000..14ec45a
--- /dev/null
+++ b/lib/mountcheck.h
@@ -0,0 +1,6 @@
+#ifndef FIO_MOUNT_CHECK_H
+#define FIO_MOUNT_CHECK_H
+
+extern int device_is_mounted(const char *);
+
+#endif
diff --git a/options.c b/options.c
index ce1d11e..7f9075b 100644
--- a/options.c
+++ b/options.c
@@ -3041,6 +3041,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "allow_file_create",
+		.lname	= "Allow file create",
 		.type	= FIO_OPT_BOOL,
 		.off1	= td_var_offset(allow_create),
 		.help	= "Permit fio to create files, if they don't exist",
@@ -3049,6 +3050,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_FILENAME,
 	},
 	{
+		.name	= "allow_mounted_write",
+		.lname	= "Allow mounted write",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(allow_mounted_write),
+		.help	= "Allow writes to a mounted partition",
+		.def	= "0",
+		.category = FIO_OPT_C_FILE,
+		.group	= FIO_OPT_G_FILENAME,
+	},
+	{
 		.name	= "pre_read",
 		.lname	= "Pre-read files",
 		.type	= FIO_OPT_BOOL,
diff --git a/thread_options.h b/thread_options.h
index aed39c8..6604a37 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -272,6 +272,7 @@ struct thread_options {
 	unsigned int per_job_logs;
 
 	unsigned int allow_create;
+	unsigned int allow_mounted_write;
 };
 
 #define FIO_TOP_STR_MAX		256
@@ -509,6 +510,7 @@ struct thread_options_pack {
 	uint32_t per_job_logs;
 
 	uint32_t allow_create;
+	uint32_t allow_mounted_write;
 } __attribute__((packed));
 
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
