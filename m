Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37942 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756834AbdJLMA1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 Oct 2017 08:00:27 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e2cA6-0004rc-BZ
        for fio@vger.kernel.org; Thu, 12 Oct 2017 12:00:26 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171012120002.340082C0111@kernel.dk>
Date: Thu, 12 Oct 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8847ae4cd2e3d0d73dd7d7c93c5d6da96b71d174:

  backend: don't dereference ->io_ops in reap_threads() (2017-10-10 11:54:54 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 447b94e10bddab8078f35c423ca1e3c3f0b1be38:

  Fix overflow in percentile calculation for Windows (2017-10-11 16:26:00 -0600)

----------------------------------------------------------------
Andrzej Jakowski (1):
      Fix overflow in percentile calculation for Windows

Jens Axboe (10):
      Merge branch 'ci_and_configure' of https://github.com/sitsofe/fio
      Merge branch 'windowaio_invalidate' of https://github.com/sitsofe/fio
      engines/windowsaio: style
      Merge branch 'fgp_fixes' of https://github.com/sitsofe/fio
      fio: kill unused TD_F_ flag
      fio: rearrange TD_F_ flag logic
      Error if td flags overlap with engine flags
      Fix broken path separator definition on Windows
      Windows mkdir() fix
      fio: kill td_ioengine_flags()

Josef Bacik (4):
      convert FIO_OS_PATH_SEPARATOR to a character
      create subdirs if specified in the filename_format
      use mkdir instead of mkdirat
      add documentation about filename_format directory behavior

Sitsofe Wheeler (4):
      appveyor: install zlib and minor clean ups
      configure: update compiler probing
      fio_generate_plots: cope with per_job_logs filenames
      windowsaio: add best effort cache invalidation

 HOWTO                    |  7 +++++
 appveyor.yml             | 11 +++++---
 configure                | 68 ++++++++++++++++++++++++++++++++++++------------
 engines/windowsaio.c     | 43 ++++++++++++++++++++++++++++++
 filesetup.c              | 43 +++++++++++++++++++++++++++++-
 fio.1                    |  6 +++++
 fio.h                    | 58 +++++++++++++++++++++++++----------------
 libfio.c                 |  2 ++
 os/os-windows.h          |  2 +-
 os/os.h                  |  2 +-
 stat.c                   |  2 +-
 tools/fio_generate_plots | 26 +++++++++++-------
 verify.c                 |  4 +--
 13 files changed, 216 insertions(+), 58 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index d3f957b..a1513e1 100644
--- a/HOWTO
+++ b/HOWTO
@@ -795,6 +795,13 @@ Target file/device
 	named :file:`testfiles.4`. The default of :file:`$jobname.$jobnum.$filenum`
 	will be used if no other format specifier is given.
 
+	If you specify a path then the directories will be created up to the
+	main directory for the file.  So for example if you specify
+	``filename_format=a/b/c/$jobnum`` then the directories a/b/c will be
+	created before the file setup part of the job.  If you specify
+	:option:`directory` then the path will be relative that directory,
+	otherwise it is treated as the absolute path.
+
 .. option:: unique_filename=bool
 
 	To avoid collisions between networked clients, fio defaults to prefixing any
diff --git a/appveyor.yml b/appveyor.yml
index 39f50a8..844afa5 100644
--- a/appveyor.yml
+++ b/appveyor.yml
@@ -1,16 +1,21 @@
-clone_depth: 50
+clone_depth: 1
 environment:
+  CYG_MIRROR: http://cygwin.mirror.constant.com
+  CYG_ROOT: C:\cygwin64
   MAKEFLAGS: -j 2
   matrix:
     - platform: x86_64
       BUILD_ARCH: x64
-      CYG_ROOT: C:\cygwin64
+      PACKAGE_ARCH: x86_64
       CONFIGURE_OPTIONS:
     - platform: x86
       BUILD_ARCH: x86
-      CYG_ROOT: C:\cygwin
+      PACKAGE_ARCH: i686
       CONFIGURE_OPTIONS: --build-32bit-win
 
+install:
+  - '%CYG_ROOT%\setup-x86_64.exe --quiet-mode --no-shortcuts --only-site --site "%CYG_MIRROR%" --packages "mingw64-%PACKAGE_ARCH%-zlib" > NULL'
+
 build_script:
   - SET PATH=%CYG_ROOT%\bin;%PATH%
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && ./configure --extra-cflags=\"-Werror\" ${CONFIGURE_OPTIONS} && make.exe'
diff --git a/configure b/configure
index cefd610..2b46ab8 100755
--- a/configure
+++ b/configure
@@ -225,7 +225,20 @@ if test "$show_help" = "yes" ; then
 fi
 
 cross_prefix=${cross_prefix-${CROSS_COMPILE}}
-cc="${CC-${cross_prefix}gcc}"
+# Preferred compiler (can be overriden later after we know the platform):
+#  ${CC} (if set)
+#  ${cross_prefix}gcc (if cross-prefix specified)
+#  gcc if available
+#  clang if available
+if test -z "${CC}${cross_prefix}"; then
+  if has gcc; then
+    cc=gcc
+  elif has clang; then
+    cc=clang
+  fi
+else
+  cc="${CC-${cross_prefix}gcc}"
+fi
 
 if check_define __ANDROID__ ; then
   targetos="Android"
@@ -301,16 +314,16 @@ SunOS)
 CYGWIN*)
   # We still force some options, so keep this message here.
   echo "Forcing some known good options on Windows"
-  if test -z "$CC" ; then
+  if test -z "${CC}${cross_prefix}"; then
     if test ! -z "$build_32bit_win" && test "$build_32bit_win" = "yes"; then
-      CC="i686-w64-mingw32-gcc"
+      cc="i686-w64-mingw32-gcc"
       if test -e "../zlib/contrib/vstudio/vc14/x86/ZlibStatReleaseWithoutAsm/zlibstat.lib"; then
         echo "Building with zlib support"
         output_sym "CONFIG_ZLIB"
         echo "LIBS=../zlib/contrib/vstudio/vc14/x86/ZlibStatReleaseWithoutAsm/zlibstat.lib" >> $config_host_mak
       fi
     else
-      CC="x86_64-w64-mingw32-gcc"
+      cc="x86_64-w64-mingw32-gcc"
       if test -e "../zlib/contrib/vstudio/vc14/x64/ZlibStatReleaseWithoutAsm/zlibstat.lib"; then
         echo "Building with zlib support"
         output_sym "CONFIG_ZLIB"
@@ -340,11 +353,25 @@ CYGWIN*)
   tls_thread="yes"
   static_assert="yes"
   ipv6="yes"
-  echo "CC=$CC" >> $config_host_mak
+  mkdir_two="no"
   echo "BUILD_CFLAGS=$CFLAGS -I../zlib -include config-host.h -D_GNU_SOURCE" >> $config_host_mak
   ;;
 esac
 
+# Now we know the target platform we can have another guess at the preferred
+# compiler when it wasn't explictly set
+if test -z "${CC}${cross_prefix}"; then
+  if test "$targetos" = "FreeBSD" || test "$targetos" = "Darwin"; then
+    if has clang; then
+      cc=clang
+    fi
+  fi
+fi
+if test -z "$cc"; then
+    echo "configure: failed to find compiler"
+    exit 1
+fi
+
 if test ! -z "$cpu" ; then
   # command line argument
   :
@@ -415,18 +442,6 @@ case "$cpu" in
   ;;
 esac
 
-if test -z "$CC" ; then
-  if test "$targetos" = "FreeBSD"; then
-    if has clang; then
-      CC=clang
-    else
-      CC=gcc
-    fi
-  fi
-fi
-
-cc="${CC-${cross_prefix}gcc}"
-
 ##########################################
 # check cross compile
 
@@ -2033,6 +2048,22 @@ if test "$enable_cuda" = "yes" && compile_prog "" "-lcuda" "cuda"; then
 fi
 print_config "cuda" "$cuda"
 
+##########################################
+# mkdir() probe. mingw apparently has a one-argument mkdir :/
+mkdir_two="no"
+cat > $TMPC << EOF
+#include <sys/stat.h>
+#include <sys/types.h>
+int main(int argc, char **argv)
+{
+  return mkdir("/tmp/bla", 0600);
+}
+EOF
+if compile_prog "" "" "mkdir(a, b)"; then
+  mkdir_two="yes"
+fi
+print_config "mkdir(a, b)" "$mkdir_two"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -2261,6 +2292,9 @@ fi
 if test "$cuda" = "yes" ; then
   output_sym "CONFIG_CUDA"
 fi
+if test "$mkdir_two" = "yes" ; then
+  output_sym "CONFIG_HAVE_MKDIR_TWO"
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "GFIO_LIBS+=$GFIO_LIBS" >> $config_host_mak
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index 314eaad..a66b1df 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -142,6 +142,44 @@ static void fio_windowsaio_cleanup(struct thread_data *td)
 	}
 }
 
+static int windowsaio_invalidate_cache(struct fio_file *f)
+{
+	DWORD error;
+	DWORD isharemode = (FILE_SHARE_DELETE | FILE_SHARE_READ |
+			FILE_SHARE_WRITE);
+	HANDLE ihFile;
+	int rc = 0;
+
+	/*
+	 * Encourage Windows to drop cached parts of a file by temporarily
+	 * opening it for non-buffered access. Note: this will only work when
+	 * the following is the only thing with the file open on the whole
+	 * system.
+	 */
+	dprint(FD_IO, "windowaio: attempt invalidate cache for %s\n",
+			f->file_name);
+	ihFile = CreateFile(f->file_name, 0, isharemode, NULL, OPEN_EXISTING,
+			FILE_FLAG_NO_BUFFERING, NULL);
+
+	if (ihFile != INVALID_HANDLE_VALUE) {
+		if (!CloseHandle(ihFile)) {
+			error = GetLastError();
+			log_info("windowsaio: invalidation fd close %s "
+				 "failed: error %d\n", f->file_name, error);
+			rc = 1;
+		}
+	} else {
+		error = GetLastError();
+		if (error != ERROR_FILE_NOT_FOUND) {
+			log_info("windowsaio: cache invalidation of %s failed: "
+					"error %d\n", f->file_name, error);
+			rc = 1;
+		}
+	}
+
+	return rc;
+}
+
 static int fio_windowsaio_open_file(struct thread_data *td, struct fio_file *f)
 {
 	int rc = 0;
@@ -200,6 +238,11 @@ static int fio_windowsaio_open_file(struct thread_data *td, struct fio_file *f)
 	else
 		openmode = OPEN_EXISTING;
 
+	/* If we're going to use direct I/O, Windows will try and invalidate
+	 * its cache at that point so there's no need to do it here */
+	if (td->o.invalidate_cache && !td->o.odirect)
+		windowsaio_invalidate_cache(f);
+
 	f->hFile = CreateFile(f->file_name, access, sharemode,
 		NULL, openmode, flags, NULL);
 
diff --git a/filesetup.c b/filesetup.c
index 0631a01..7a602d4 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1523,6 +1523,42 @@ bool exists_and_not_regfile(const char *filename)
 	return true;
 }
 
+static int create_work_dirs(struct thread_data *td, const char *fname)
+{
+	char path[PATH_MAX];
+	char *start, *end;
+
+	if (td->o.directory) {
+		snprintf(path, PATH_MAX, "%s%c%s", td->o.directory,
+			 FIO_OS_PATH_SEPARATOR, fname);
+		start = strstr(path, fname);
+	} else {
+		snprintf(path, PATH_MAX, "%s", fname);
+		start = path;
+	}
+
+	end = start;
+	while ((end = strchr(end, FIO_OS_PATH_SEPARATOR)) != NULL) {
+		if (end == start)
+			break;
+		*end = '\0';
+		errno = 0;
+#ifdef CONFIG_HAVE_MKDIR_TWO
+		if (mkdir(path, 0600) && errno != EEXIST) {
+#else
+		if (mkdir(path) && errno != EEXIST) {
+#endif
+			log_err("fio: failed to create dir (%s): %d\n",
+				start, errno);
+			return 1;
+		}
+		*end = FIO_OS_PATH_SEPARATOR;
+		end++;
+	}
+	td->flags |= TD_F_DIRS_CREATED;
+	return 0;
+}
+
 int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 {
 	int cur_files = td->files_index;
@@ -1538,6 +1574,11 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 
 	sprintf(file_name + len, "%s", fname);
 
+	if (strchr(fname, FIO_OS_PATH_SEPARATOR) &&
+	    !(td->flags & TD_F_DIRS_CREATED) &&
+	    create_work_dirs(td, fname))
+		return 1;
+
 	/* clean cloned siblings using existing files */
 	if (numjob && is_already_allocated(file_name) &&
 	    !exists_and_not_regfile(fname))
@@ -1725,7 +1766,7 @@ static int recurse_dir(struct thread_data *td, const char *dirname)
 		if (!strcmp(dir->d_name, ".") || !strcmp(dir->d_name, ".."))
 			continue;
 
-		sprintf(full_path, "%s%s%s", dirname, FIO_OS_PATH_SEPARATOR, dir->d_name);
+		sprintf(full_path, "%s%c%s", dirname, FIO_OS_PATH_SEPARATOR, dir->d_name);
 
 		if (lstat(full_path, &sb) == -1) {
 			if (errno != ENOENT) {
diff --git a/fio.1 b/fio.1
index 6e7d1f8..7787ef2 100644
--- a/fio.1
+++ b/fio.1
@@ -578,6 +578,12 @@ fio generate filenames that are shared between the two. For instance, if
 `testfiles.$filenum' is specified, file number 4 for any job will be
 named `testfiles.4'. The default of `$jobname.$jobnum.$filenum'
 will be used if no other format specifier is given.
+.P
+If you specify a path then the directories will be created up to the main
+directory for the file.  So for example if you specify `a/b/c/$jobnum` then the
+directories a/b/c will be created before the file setup part of the job.  If you
+specify \fBdirectory\fR then the path will be relative that directory, otherwise
+it is treated as the absolute path.
 .RE
 .TP
 .BI unique_filename \fR=\fPbool
diff --git a/fio.h b/fio.h
index 8814d84..8ca934d 100644
--- a/fio.h
+++ b/fio.h
@@ -72,22 +72,42 @@ enum {
 };
 
 enum {
-	TD_F_VER_BACKLOG	= 1U << 0,
-	TD_F_TRIM_BACKLOG	= 1U << 1,
-	TD_F_READ_IOLOG		= 1U << 2,
-	TD_F_REFILL_BUFFERS	= 1U << 3,
-	TD_F_SCRAMBLE_BUFFERS	= 1U << 4,
-	TD_F_VER_NONE		= 1U << 5,
-	TD_F_PROFILE_OPS	= 1U << 6,
-	TD_F_COMPRESS		= 1U << 7,
-	TD_F_RESERVED		= 1U << 8, /* not used */
-	TD_F_COMPRESS_LOG	= 1U << 9,
-	TD_F_VSTATE_SAVED	= 1U << 10,
-	TD_F_NEED_LOCK		= 1U << 11,
-	TD_F_CHILD		= 1U << 12,
-	TD_F_NO_PROGRESS        = 1U << 13,
-	TD_F_REGROW_LOGS	= 1U << 14,
-	TD_F_MMAP_KEEP		= 1U << 15,
+	__TD_F_VER_BACKLOG	= 0,
+	__TD_F_TRIM_BACKLOG,
+	__TD_F_READ_IOLOG,
+	__TD_F_REFILL_BUFFERS,
+	__TD_F_SCRAMBLE_BUFFERS,
+	__TD_F_VER_NONE,
+	__TD_F_PROFILE_OPS,
+	__TD_F_COMPRESS,
+	__TD_F_COMPRESS_LOG,
+	__TD_F_VSTATE_SAVED,
+	__TD_F_NEED_LOCK,
+	__TD_F_CHILD,
+	__TD_F_NO_PROGRESS,
+	__TD_F_REGROW_LOGS,
+	__TD_F_MMAP_KEEP,
+	__TD_F_DIRS_CREATED,
+	__TD_F_LAST,		/* not a real bit, keep last */
+};
+
+enum {
+	TD_F_VER_BACKLOG	= 1U << __TD_F_VER_BACKLOG,
+	TD_F_TRIM_BACKLOG	= 1U << __TD_F_TRIM_BACKLOG,
+	TD_F_READ_IOLOG		= 1U << __TD_F_READ_IOLOG,
+	TD_F_REFILL_BUFFERS	= 1U << __TD_F_REFILL_BUFFERS,
+	TD_F_SCRAMBLE_BUFFERS	= 1U << __TD_F_SCRAMBLE_BUFFERS,
+	TD_F_VER_NONE		= 1U << __TD_F_VER_NONE,
+	TD_F_PROFILE_OPS	= 1U << __TD_F_PROFILE_OPS,
+	TD_F_COMPRESS		= 1U << __TD_F_COMPRESS,
+	TD_F_COMPRESS_LOG	= 1U << __TD_F_COMPRESS_LOG,
+	TD_F_VSTATE_SAVED	= 1U << __TD_F_VSTATE_SAVED,
+	TD_F_NEED_LOCK		= 1U << __TD_F_NEED_LOCK,
+	TD_F_CHILD		= 1U << __TD_F_CHILD,
+	TD_F_NO_PROGRESS        = 1U << __TD_F_NO_PROGRESS,
+	TD_F_REGROW_LOGS	= 1U << __TD_F_REGROW_LOGS,
+	TD_F_MMAP_KEEP		= 1U << __TD_F_MMAP_KEEP,
+	TD_F_DIRS_CREATED	= 1U << __TD_F_DIRS_CREATED,
 };
 
 enum {
@@ -591,12 +611,6 @@ enum {
 #define TD_ENG_FLAG_SHIFT	16
 #define TD_ENG_FLAG_MASK	((1U << 16) - 1)
 
-static inline enum fio_ioengine_flags td_ioengine_flags(struct thread_data *td)
-{
-	return (enum fio_ioengine_flags)
-		((td->flags >> TD_ENG_FLAG_SHIFT) & TD_ENG_FLAG_MASK);
-}
-
 static inline void td_set_ioengine_flags(struct thread_data *td)
 {
 	td->flags = (~(TD_ENG_FLAG_MASK << TD_ENG_FLAG_SHIFT) & td->flags) |
diff --git a/libfio.c b/libfio.c
index 14ddc4d..830759a 100644
--- a/libfio.c
+++ b/libfio.c
@@ -365,6 +365,8 @@ int initialize_fio(char *envp[])
 	compiletime_assert((offsetof(struct thread_options_pack, latency_percentile) % 8) == 0, "latency_percentile");
 	compiletime_assert((offsetof(struct jobs_eta, m_rate) % 8) == 0, "m_rate");
 
+	compiletime_assert(__TD_F_LAST <= TD_ENG_FLAG_SHIFT, "TD_ENG_FLAG_SHIFT");
+
 	err = endian_check();
 	if (err) {
 		log_err("fio: endianness settings appear wrong.\n");
diff --git a/os/os-windows.h b/os/os-windows.h
index 36b421e..520da19 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -37,7 +37,7 @@ int rand_r(unsigned *);
 
 #define FIO_PREFERRED_ENGINE		"windowsaio"
 #define FIO_PREFERRED_CLOCK_SOURCE	CS_CGETTIME
-#define FIO_OS_PATH_SEPARATOR		"\\"
+#define FIO_OS_PATH_SEPARATOR		'\\'
 
 #define FIO_MAX_CPUS	MAXIMUM_PROCESSORS
 
diff --git a/os/os.h b/os/os.h
index f62b427..1a4437c 100644
--- a/os/os.h
+++ b/os/os.h
@@ -155,7 +155,7 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 #endif
 
 #ifndef FIO_OS_PATH_SEPARATOR
-#define FIO_OS_PATH_SEPARATOR	"/"
+#define FIO_OS_PATH_SEPARATOR	'/'
 #endif
 
 #ifndef FIO_PREFERRED_CLOCK_SOURCE
diff --git a/stat.c b/stat.c
index c5a68ad..5c75868 100644
--- a/stat.c
+++ b/stat.c
@@ -139,7 +139,7 @@ unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 				   fio_fp64_t *plist, unsigned long long **output,
 				   unsigned long long *maxv, unsigned long long *minv)
 {
-	unsigned long sum = 0;
+	unsigned long long sum = 0;
 	unsigned int len, i, j = 0;
 	unsigned int oval_len = 0;
 	unsigned long long *ovals = NULL;
diff --git a/tools/fio_generate_plots b/tools/fio_generate_plots
index a47bfa5..8872206 100755
--- a/tools/fio_generate_plots
+++ b/tools/fio_generate_plots
@@ -93,20 +93,26 @@ plot () {
 
     i=0
     
-    for x in *_"$FILETYPE".log
+    for x in *_"$FILETYPE".log *_"$FILETYPE".*.log
     do
-        i=$((i+1))
-        PT=$(echo $x | sed s/_"$FILETYPE".log//g)
-        if [ ! -z "$PLOT_LINE" ]
-        then
-            PLOT_LINE=$PLOT_LINE", "
+        if [ -e "$x" ]; then
+            i=$((i+1))
+            PT=$(echo $x | sed 's/\(.*\)_'$FILETYPE'\(.*\).log$/\1\2/')
+            if [ ! -z "$PLOT_LINE" ]
+            then
+                PLOT_LINE=$PLOT_LINE", "
+            fi
+
+            DEPTH=$(echo $PT | cut -d "-" -f 4)
+            PLOT_LINE=$PLOT_LINE"'$x' using (\$1/1000):(\$2/$SCALE) title \"Queue depth $DEPTH\" with lines ls $i" 
         fi
-
-        DEPTH=$(echo $PT | cut -d "-" -f 4)
-	    PLOT_LINE=$PLOT_LINE"'$x' using (\$1/1000):(\$2/$SCALE) title \"Queue depth $DEPTH\" with lines ls $i" 
-        
     done
 
+    if [ $i -eq 0 ]; then
+       echo "No log files found"
+       exit 1
+    fi
+
     OUTPUT="set output \"$TITLE-$FILETYPE.svg\" "
 
     echo " $PLOT_TITLE ; $YAXIS ; $DEFAULT_OPTS ; show style lines ; $OUTPUT ; plot "  $PLOT_LINE  | $GNUPLOT -
diff --git a/verify.c b/verify.c
index 1f177d7..db6e17e 100644
--- a/verify.c
+++ b/verify.c
@@ -252,7 +252,7 @@ static void dump_buf(char *buf, unsigned int len, unsigned long long offset,
 
 	memset(fname, 0, sizeof(fname));
 	if (aux_path)
-		sprintf(fname, "%s%s", aux_path, FIO_OS_PATH_SEPARATOR);
+		sprintf(fname, "%s%c", aux_path, FIO_OS_PATH_SEPARATOR);
 
 	strncpy(fname + strlen(fname), basename(ptr), buf_left - 1);
 
@@ -1726,7 +1726,7 @@ void verify_save_state(int mask)
 		char prefix[PATH_MAX];
 
 		if (aux_path)
-			sprintf(prefix, "%s%slocal", aux_path, FIO_OS_PATH_SEPARATOR);
+			sprintf(prefix, "%s%clocal", aux_path, FIO_OS_PATH_SEPARATOR);
 		else
 			strcpy(prefix, "local");
 
