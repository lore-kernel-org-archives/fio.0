Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 02/11] configure: Add compile_exec_prog() to compile and execute the binary
Date: Mon,  1 May 2017 21:48:11 +0300
Message-Id: <20170501184820.31025-2-tkusumi@tuxera.com>
In-Reply-To: <20170501184820.31025-1-tkusumi@tuxera.com>
References: <20170501184820.31025-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This commit directly applies on top of the previous one which added
a NetBSD specific conditional after running compile_prog() for
posix_fallocate(3), and partly reverts it to replace with alternative
generic solution.

The new shell function compile_exec_prog() runs the executable binary
$TMPE after generating it with arguments if needed. This enables
the script to drop the NetBSD specific code added by the previous
commit, and possibly replace other compile_prog() calls that require
runtime tests in the future. The test code for posix_fallocate(3)
is also modified to use a valid fd and random tmp path.

Note that compile_exec_prog() can be used only if $TMPE returns 0 on
success and non 0 on failure, because if otherwise do_cc() result
may wrongly be intepreted. This is still generic enough though, as
most of the $TMPE binaries use 0 to indicate success while the return
values have mostly been unused.

Confirmed this doesn't change the CONFIG_POSIX_FALLOCATE result on
several platforms.

-- with this commit, no for posix_fallocate(3)
 # uname
 NetBSD
 # gmake clean >/dev/null 2>&1
 # ./configure | grep "POSIX fallocate"
 POSIX fallocate               no
 # grep -A3 posix_fallocate ./config.log
 Compiling and executing test case posix_fallocate
 gcc -D_GNU_SOURCE -include config-host.h -o /tmp/fio-conf--27794-.exe /tmp/fio-conf--27794-.c -lrt -lz
 /tmp/fio-conf--27794-.exe /tmp/fio-conf--27794-.file
 ... result 45
 # gmake -j8 >/dev/null 2>&1
 # ./fio --name=xxxxx --ioengine=sync --rw=read --bs=2k --size=1m --unlink=1 | grep posix_fallocate
 #

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure   | 41 +++++++++++++++++++++++++++++++++--------
 filesetup.c |  1 -
 2 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/configure b/configure
index c3e06cd..9bcdb63 100755
--- a/configure
+++ b/configure
@@ -17,9 +17,13 @@ TMPC="${TMPDIR1}/fio-conf-${RANDOM}-$$-${RANDOM}.c"
 TMPO="${TMPDIR1}/fio-conf-${RANDOM}-$$-${RANDOM}.o"
 TMPE="${TMPDIR1}/fio-conf-${RANDOM}-$$-${RANDOM}.exe"
 
+# This path can be used for anything, but currently only used for
+# compile_exec_prog() argument.
+TMPF="${TMPDIR1}/fio-conf-${RANDOM}-$$-${RANDOM}.file"
+
 # NB: do not call "exit" in the trap handler; this is buggy with some shells;
 # see <1285349658-3122-1-git-send-email-loic.minier@linaro.org>
-trap "rm -f $TMPC $TMPO $TMPE" EXIT INT QUIT TERM
+trap "rm -f $TMPC $TMPO $TMPE $TMPF" EXIT INT QUIT TERM
 
 rm -rf config.log
 
@@ -92,6 +96,21 @@ compile_prog() {
   do_cc $CFLAGS $local_cflags -o $TMPE $TMPC $LDFLAGS $local_ldflags
 }
 
+# Success if $TMPC gets compiled, and then $TMPE returns 0
+compile_exec_prog() {
+  local_cflags="$1"
+  local_ldflags="$2 $LIBS"
+  echo "Compiling and executing test case $3" >> config.log
+  do_cc $CFLAGS $local_cflags -o $TMPE $TMPC $LDFLAGS $local_ldflags || return $?
+  shift; shift; shift
+  argv="$@"
+  $TMPE $argv # >/dev/null 2>&1
+  result=$?
+  echo "$TMPE $argv" >> config.log
+  echo "... result $result" >> config.log
+  return $result
+}
+
 feature_not_found() {
   feature=$1
   packages=$2
@@ -766,26 +785,32 @@ echo "POSIX fadvise                 $posix_fadvise"
 
 ##########################################
 # POSIX fallocate probe
+# Test runtime as well since some OS/filesystem, for e.g. UFS on NetBSD
+# doesn't support posix_fallocate(3) even if it compiles.
 if test "$posix_fallocate" != "yes" ; then
   posix_fallocate="no"
 fi
 cat > $TMPC << EOF
 #include <stdio.h>
+#include <unistd.h>
 #include <fcntl.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
 int main(int argc, char **argv)
 {
-  int r = posix_fallocate(0, 0, 1024);
+  int r, fd;
+  fd = open(argv[1], O_WRONLY | O_CREAT, 0644);
+  if (fd < 0)
+	  return errno;
+  r = posix_fallocate(fd, 0, 1024);
+  close(fd);
   return r;
 }
 EOF
-if compile_prog "" "" "posix_fallocate"; then
+if compile_exec_prog "" "" "posix_fallocate" "$TMPF"; then
     posix_fallocate="yes"
 fi
-# Ignore the result for NetBSD since it's not supported at least on UFS,
-# which is what people basically use on NetBSD.
-if test "$targetos" = "NetBSD"; then
-    posix_fallocate="no"
-fi
 echo "POSIX fallocate               $posix_fallocate"
 
 ##########################################
diff --git a/filesetup.c b/filesetup.c
index 23fd537..611a656 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -112,7 +112,6 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 			/*
 			 * Note that some OS/filesystem, for e.g. UFS on NetBSD
 			 * doesn't support posix_fallocate(3) even if it compiles.
-			 * Try to avoid it on ./configure if it's a known issue.
 			 */
 			r = posix_fallocate(f->fd, 0, f->real_file_size);
 			if (r > 0) {
-- 
2.9.3


