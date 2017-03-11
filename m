Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54446 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751817AbdCKNAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 11 Mar 2017 08:00:09 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cmgcx-0000ug-6e
        for fio@vger.kernel.org; Sat, 11 Mar 2017 13:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170311130002.9DF7F2C1C4C@kernel.dk>
Date: Sat, 11 Mar 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ae3a5accfdbe1fbfde6ba4ab583887a7d3d779ac:

  verify: add support for the sha3 variants (2017-03-08 09:13:14 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ca205a752c3d6ebe7de74a3dfe81808e48a502e3:

  configure: Make Cygwin take regular configure path (2017-03-10 14:43:37 -0700)

----------------------------------------------------------------
Tomohiro Kusumi (17):
      Add runtime handlers for 97900ebf for FreeBSD/DragonFlyBSD
      HOWTO: Add platforms without fdatasync(2)
      configure: Align help messages
      Avoid irrelevant "offset extend ends" error message for chrdev
      Fix debug print format of file ->file_name
      Fixup for a minor 0 byte file size case
      Explicitly check td_trim(td) to detect open(2) flag
      Drop redundant td_rw(td) tests
      Remove unassigned fio_unused variable
      Drop fio_unused attribute from used variable
      Fix a function name typo in debug print
      Don't set FIO_FILE_extend when create_on_open= option is set
      Minor fixup for "Layint out IO file..." message
      HOWTO: Add some details for invalidate=
      Define struct file_name as a file local structure
      Use union for per file engine private data storage
      configure: Make Cygwin take regular configure path

 HOWTO                    |   8 +-
 backend.c                |   2 +-
 configure                | 320 +++++++++++++++++++++++++++++++++--------------
 engines/glusterfs_sync.c |   2 +-
 engines/pmemblk.c        |  16 +--
 engines/sync.c           |   2 +-
 file.h                   |  17 ++-
 filesetup.c              |  76 ++++++++---
 fio.h                    |   2 +-
 init.c                   |  13 +-
 io_u.c                   |   4 +-
 os/os-dragonfly.h        |  14 ++-
 os/os-freebsd.h          |  15 ++-
 os/os-linux.h            |   5 +
 os/os-openbsd.h          |  12 +-
 os/os.h                  |   7 ++
 rate-submit.c            |   1 -
 verify.c                 |   2 +-
 18 files changed, 359 insertions(+), 159 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 15ed425..c2c6509 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1104,7 +1104,7 @@ I/O type
 .. option:: fdatasync=int
 
 	Like :option:`fsync` but uses :manpage:`fdatasync(2)` to only sync data and
-	not metadata blocks.  In FreeBSD and Windows there is no
+	not metadata blocks.  In Windows, FreeBSD, and DragonFlyBSD there is no
 	:manpage:`fdatasync(2)`, this falls back to using :manpage:`fsync(2)`.
 
 .. option:: write_barrier=int
@@ -1426,7 +1426,9 @@ Buffers and memory
 .. option:: invalidate=bool
 
 	Invalidate the buffer/page cache parts for this file prior to starting
-	I/O. Defaults to true.
+	I/O if the platform and file type support it. Defaults to true.
+	This will be ignored if :option:`pre_read` is also specified for the
+	same job.
 
 .. option:: sync=bool
 
@@ -1513,7 +1515,7 @@ I/O size
 	Fio will divide this size between the available files determined by options
 	such as :option:`nrfiles`, :option:`filename`, unless :option:`filesize` is
 	specified by the job. If the result of division happens to be 0, the size is
-	set to the physical size of the given files or devices.
+	set to the physical size of the given files or devices if they exist.
 	If this option is not specified, fio will use the full size of the given
 	files or devices.  If the files do not exist, size must be given. It is also
 	possible to give size as a percentage between 1 and 100. If ``size=20%`` is
diff --git a/backend.c b/backend.c
index 4bc00e6..2e8a994 100644
--- a/backend.c
+++ b/backend.c
@@ -1693,7 +1693,7 @@ static void *thread_main(void *data)
 
 		prune_io_piece_log(td);
 
-		if (td->o.verify_only && (td_write(td) || td_rw(td)))
+		if (td->o.verify_only && td_write(td))
 			verify_bytes = do_dry_run(td);
 		else {
 			uint64_t bytes_done[DDIR_RWDIR_CNT];
diff --git a/configure b/configure
index 15b87fa..7b55711 100755
--- a/configure
+++ b/configure
@@ -195,21 +195,21 @@ for opt do
 done
 
 if test "$show_help" = "yes" ; then
-  echo "--prefix=              Use this directory as installation prefix"
-  echo "--cpu=                 Specify target CPU if auto-detect fails"
-  echo "--cc=                  Specify compiler to use"
-  echo "--extra-cflags=        Specify extra CFLAGS to pass to compiler"
-  echo "--build-32bit-win      Enable 32-bit build on Windows"
-  echo "--build-static         Build a static fio"
-  echo "--esx                  Configure build options for esx"
-  echo "--enable-gfio          Enable building of gtk gfio"
-  echo "--disable-numa         Disable libnuma even if found"
-  echo "--disable-gfapi        Disable gfapi"
-  echo "--enable-libhdfs       Enable hdfs support"
-  echo "--disable-lex          Disable use of lex/yacc for math"
-  echo "--disable-pmem         Disable pmem based engines even if found"
-  echo "--enable-lex           Enable use of lex/yacc for math"
-  echo "--disable-shm          Disable SHM support"
+  echo "--prefix=               Use this directory as installation prefix"
+  echo "--cpu=                  Specify target CPU if auto-detect fails"
+  echo "--cc=                   Specify compiler to use"
+  echo "--extra-cflags=         Specify extra CFLAGS to pass to compiler"
+  echo "--build-32bit-win       Enable 32-bit build on Windows"
+  echo "--build-static          Build a static fio"
+  echo "--esx                   Configure build options for esx"
+  echo "--enable-gfio           Enable building of gtk gfio"
+  echo "--disable-numa          Disable libnuma even if found"
+  echo "--disable-gfapi         Disable gfapi"
+  echo "--enable-libhdfs        Enable hdfs support"
+  echo "--disable-lex           Disable use of lex/yacc for math"
+  echo "--disable-pmem          Disable pmem based engines even if found"
+  echo "--enable-lex            Enable use of lex/yacc for math"
+  echo "--disable-shm           Disable SHM support"
   echo "--disable-optimizations Don't enable compiler optimizations"
   exit $exit_val
 fi
@@ -288,7 +288,8 @@ SunOS)
   LIBS="-lnsl -lsocket"
   ;;
 CYGWIN*)
-  echo "Forcing known good options on Windows"
+  # We still force some options, so keep this message here.
+  echo "Forcing some known good options on Windows"
   if test -z "$CC" ; then
     if test ! -z "$build_32bit_win" && test "$build_32bit_win" = "yes"; then
       CC="i686-w64-mingw32-gcc"
@@ -306,29 +307,30 @@ CYGWIN*)
       fi
     fi
   fi
-  output_sym "CONFIG_LITTLE_ENDIAN"
   if test ! -z "$build_32bit_win" && test "$build_32bit_win" = "yes"; then
     output_sym "CONFIG_32BIT"
   else
     output_sym "CONFIG_64BIT_LLP64"
   fi
-  output_sym "CONFIG_SOCKLEN_T"
-  output_sym "CONFIG_SFAA"
-  output_sym "CONFIG_RUSAGE_THREAD"
+  # We need this to be output_sym'd here because this is Windows specific.
+  # The regular configure path never sets this config.
   output_sym "CONFIG_WINDOWSAIO"
-  output_sym "CONFIG_FDATASYNC"
-  output_sym "CONFIG_CLOCK_MONOTONIC"
-  output_sym "CONFIG_GETTIMEOFDAY"
-  output_sym "CONFIG_CLOCK_GETTIME"
-  output_sym "CONFIG_SCHED_IDLE"
-  output_sym "CONFIG_TCP_NODELAY"
-  output_sym "CONFIG_TLS_THREAD"
-  output_sym "CONFIG_STATIC_ASSERT"
-  output_sym "CONFIG_IPV6"
+  # We now take the regular configuration path without having exit 0 here.
+  # Flags below are still necessary mostly for MinGW.
+  socklen_t="yes"
+  sfaa="yes"
+  rusage_thread="yes"
+  fdatasync="yes"
+  clock_gettime="yes" # clock_monotonic probe has dependency on this
+  clock_monotonic="yes"
+  gettimeofday="yes"
+  sched_idle="yes"
+  tcp_nodelay="yes"
+  tls_thread="yes"
+  static_assert="yes"
+  ipv6="yes"
   echo "CC=$CC" >> $config_host_mak
   echo "BUILD_CFLAGS=$CFLAGS -I../zlib -include config-host.h -D_GNU_SOURCE" >> $config_host_mak
-
-  exit 0
   ;;
 esac
 
@@ -417,7 +419,9 @@ cc="${CC-${cross_prefix}gcc}"
 ##########################################
 # check cross compile
 
-cross_compile="no"
+if test "$cross_compile" != "yes" ; then
+  cross_compile="no"
+fi
 cat > $TMPC <<EOF
 int main(void)
 {
@@ -432,7 +436,9 @@ fi
 
 ##########################################
 # check endianness
-bigendian="no"
+if test "$bigendian" != "yes" ; then
+  bigendian="no"
+fi
 if test "$cross_compile" = "no" ; then
   cat > $TMPC <<EOF
 #include <inttypes.h>
@@ -503,7 +509,9 @@ echo "Wordsize                      $wordsize"
 
 ##########################################
 # zlib probe
-zlib="no"
+if test "$zlib" != "yes" ; then
+  zlib="no"
+fi
 cat > $TMPC <<EOF
 #include <zlib.h>
 int main(void)
@@ -522,7 +530,9 @@ echo "zlib                          $zlib"
 
 ##########################################
 # linux-aio probe
-libaio="no"
+if test "$libaio" != "yes" ; then
+  libaio="no"
+fi
 if test "$esx" != "yes" ; then
   cat > $TMPC <<EOF
 #include <libaio.h>
@@ -547,8 +557,12 @@ echo "Linux AIO support             $libaio"
 
 ##########################################
 # posix aio probe
-posix_aio="no"
-posix_aio_lrt="no"
+if test "$posix_aio" != "yes" ; then
+  posix_aio="no"
+fi
+if test "$posix_aio_lrt" != "yes" ; then
+  posix_aio_lrt="no"
+fi
 cat > $TMPC <<EOF
 #include <aio.h>
 int main(void)
@@ -570,7 +584,9 @@ echo "POSIX AIO support needs -lrt  $posix_aio_lrt"
 
 ##########################################
 # posix aio fsync probe
-posix_aio_fsync="no"
+if test "$posix_aio_fsync" != "yes" ; then
+  posix_aio_fsync="no"
+fi
 if test "$posix_aio" = "yes" ; then
   cat > $TMPC <<EOF
 #include <fcntl.h>
@@ -590,7 +606,9 @@ echo "POSIX AIO fsync               $posix_aio_fsync"
 
 ##########################################
 # solaris aio probe
-solaris_aio="no"
+if test "$solaris_aio" != "yes" ; then
+  solaris_aio="no"
+fi
 cat > $TMPC <<EOF
 #include <sys/types.h>
 #include <sys/asynch.h>
@@ -610,7 +628,9 @@ echo "Solaris AIO support           $solaris_aio"
 
 ##########################################
 # __sync_fetch_and_add test
-sfaa="no"
+if test "$sfaa" != "yes" ; then
+  sfaa="no"
+fi
 cat > $TMPC << EOF
 #include <inttypes.h>
 static int sfaa(uint64_t *ptr)
@@ -632,7 +652,9 @@ echo "__sync_fetch_and_add          $sfaa"
 
 ##########################################
 # libverbs probe
-libverbs="no"
+if test "$libverbs" != "yes" ; then
+  libverbs="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <infiniband/arch.h>
@@ -650,7 +672,9 @@ echo "libverbs                      $libverbs"
 
 ##########################################
 # rdmacm probe
-rdmacm="no"
+if test "$rdmacm" != "yes" ; then
+  rdmacm="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <rdma/rdma_cma.h>
@@ -668,7 +692,9 @@ echo "rdmacm                        $rdmacm"
 
 ##########################################
 # Linux fallocate probe
-linux_fallocate="no"
+if test "$linux_fallocate" != "yes" ; then
+  linux_fallocate="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <fcntl.h>
@@ -686,7 +712,9 @@ echo "Linux fallocate               $linux_fallocate"
 
 ##########################################
 # POSIX fadvise probe
-posix_fadvise="no"
+if test "$posix_fadvise" != "yes" ; then
+  posix_fadvise="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <fcntl.h>
@@ -703,7 +731,9 @@ echo "POSIX fadvise                 $posix_fadvise"
 
 ##########################################
 # POSIX fallocate probe
-posix_fallocate="no"
+if test "$posix_fallocate" != "yes" ; then
+  posix_fallocate="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <fcntl.h>
@@ -720,8 +750,12 @@ echo "POSIX fallocate               $posix_fallocate"
 
 ##########################################
 # sched_set/getaffinity 2 or 3 argument test
-linux_2arg_affinity="no"
-linux_3arg_affinity="no"
+if test "$linux_2arg_affinity" != "yes" ; then
+  linux_2arg_affinity="no"
+fi
+if test "$linux_3arg_affinity" != "yes" ; then
+  linux_3arg_affinity="no"
+fi
 cat > $TMPC << EOF
 #include <sched.h>
 int main(int argc, char **argv)
@@ -750,7 +784,9 @@ echo "sched_setaffinity(2 arg)      $linux_2arg_affinity"
 
 ##########################################
 # clock_gettime probe
-clock_gettime="no"
+if test "$clock_gettime" != "yes" ; then
+  clock_gettime="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <time.h>
@@ -769,7 +805,9 @@ echo "clock_gettime                 $clock_gettime"
 
 ##########################################
 # CLOCK_MONOTONIC probe
-clock_monotonic="no"
+if test "$clock_monotonic" != "yes" ; then
+  clock_monotonic="no"
+fi
 if test "$clock_gettime" = "yes" ; then
   cat > $TMPC << EOF
 #include <stdio.h>
@@ -787,7 +825,9 @@ echo "CLOCK_MONOTONIC               $clock_monotonic"
 
 ##########################################
 # CLOCK_MONOTONIC_RAW probe
-clock_monotonic_raw="no"
+if test "$clock_monotonic_raw" != "yes" ; then
+  clock_monotonic_raw="no"
+fi
 if test "$clock_gettime" = "yes" ; then
   cat > $TMPC << EOF
 #include <stdio.h>
@@ -805,7 +845,9 @@ echo "CLOCK_MONOTONIC_RAW           $clock_monotonic_raw"
 
 ##########################################
 # CLOCK_MONOTONIC_PRECISE probe
-clock_monotonic_precise="no"
+if test "$clock_monotonic_precise" != "yes" ; then
+  clock_monotonic_precise="no"
+fi
 if test "$clock_gettime" = "yes" ; then
   cat > $TMPC << EOF
 #include <stdio.h>
@@ -823,7 +865,9 @@ echo "CLOCK_MONOTONIC_PRECISE       $clock_monotonic_precise"
 
 ##########################################
 # clockid_t probe
-clockid_t="no"
+if test "$clockid_t" != "yes" ; then
+  clockid_t="no"
+fi
 cat > $TMPC << EOF
 #include <time.h>
 int main(int argc, char **argv)
@@ -840,7 +884,9 @@ echo "clockid_t                     $clockid_t"
 
 ##########################################
 # gettimeofday() probe
-gettimeofday="no"
+if test "$gettimeofday" != "yes" ; then
+  gettimeofday="no"
+fi
 cat > $TMPC << EOF
 #include <sys/time.h>
 #include <stdio.h>
@@ -857,7 +903,9 @@ echo "gettimeofday                  $gettimeofday"
 
 ##########################################
 # fdatasync() probe
-fdatasync="no"
+if test "$fdatasync" != "yes" ; then
+  fdatasync="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <unistd.h>
@@ -873,7 +921,9 @@ echo "fdatasync                     $fdatasync"
 
 ##########################################
 # sync_file_range() probe
-sync_file_range="no"
+if test "$sync_file_range" != "yes" ; then
+  sync_file_range="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <unistd.h>
@@ -893,7 +943,9 @@ echo "sync_file_range               $sync_file_range"
 
 ##########################################
 # ext4 move extent probe
-ext4_me="no"
+if test "$ext4_me" != "yes" ; then
+  ext4_me="no"
+fi
 cat > $TMPC << EOF
 #include <fcntl.h>
 #include <sys/ioctl.h>
@@ -915,7 +967,9 @@ echo "EXT4 move extent              $ext4_me"
 
 ##########################################
 # splice probe
-linux_splice="no"
+if test "$linux_splice" != "yes" ; then
+  linux_splice="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <fcntl.h>
@@ -931,7 +985,9 @@ echo "Linux splice(2)               $linux_splice"
 
 ##########################################
 # GUASI probe
-guasi="no"
+if test "$guasi" != "yes" ; then
+  guasi="no"
+fi
 cat > $TMPC << EOF
 #include <guasi.h>
 #include <guasi_syscalls.h>
@@ -948,7 +1004,9 @@ echo "GUASI                         $guasi"
 
 ##########################################
 # fusion-aw probe
-fusion_aw="no"
+if test "$fusion_aw" != "yes" ; then
+  fusion_aw="no"
+fi
 cat > $TMPC << EOF
 #include <nvm/nvm_primitives.h>
 int main(int argc, char **argv)
@@ -968,7 +1026,9 @@ echo "Fusion-io atomic engine       $fusion_aw"
 
 ##########################################
 # libnuma probe
-libnuma="no"
+if test "$libnuma" != "yes" ; then
+  libnuma="no"
+fi
 cat > $TMPC << EOF
 #include <numa.h>
 int main(int argc, char **argv)
@@ -983,7 +1043,7 @@ fi
 echo "libnuma                       $libnuma"
 
 ##########################################
-# libnuma 2.x version API
+# libnuma 2.x version API, initialize with "no" only if $libnuma is set to "yes"
 if test "$libnuma" = "yes" ; then
 libnuma_v2="no"
 cat > $TMPC << EOF
@@ -1002,7 +1062,9 @@ fi
 
 ##########################################
 # strsep() probe
-strsep="no"
+if test "$strsep" != "yes" ; then
+  strsep="no"
+fi
 cat > $TMPC << EOF
 #include <string.h>
 int main(int argc, char **argv)
@@ -1019,7 +1081,9 @@ echo "strsep                        $strsep"
 
 ##########################################
 # strcasestr() probe
-strcasestr="no"
+if test "$strcasestr" != "yes" ; then
+  strcasestr="no"
+fi
 cat > $TMPC << EOF
 #include <string.h>
 int main(int argc, char **argv)
@@ -1034,7 +1098,9 @@ echo "strcasestr                    $strcasestr"
 
 ##########################################
 # strlcat() probe
-strlcat="no"
+if test "$strlcat" != "yes" ; then
+  strlcat="no"
+fi
 cat > $TMPC << EOF
 #include <string.h>
 int main(int argc, char **argv)
@@ -1053,7 +1119,9 @@ echo "strlcat                       $strlcat"
 
 ##########################################
 # getopt_long_only() probe
-getopt_long_only="no"
+if test "$getopt_long_only" != "yes" ; then
+  getopt_long_only="no"
+fi
 cat > $TMPC << EOF
 #include <unistd.h>
 #include <stdio.h>
@@ -1071,7 +1139,9 @@ echo "getopt_long_only()            $getopt_long_only"
 
 ##########################################
 # inet_aton() probe
-inet_aton="no"
+if test "$inet_aton" != "yes" ; then
+  inet_aton="no"
+fi
 cat > $TMPC << EOF
 #include <sys/socket.h>
 #include <arpa/inet.h>
@@ -1089,7 +1159,9 @@ echo "inet_aton                     $inet_aton"
 
 ##########################################
 # socklen_t probe
-socklen_t="no"
+if test "$socklen_t" != "yes" ; then
+  socklen_t="no"
+fi
 cat > $TMPC << EOF
 #include <sys/socket.h>
 int main(int argc, char **argv)
@@ -1105,7 +1177,9 @@ echo "socklen_t                     $socklen_t"
 
 ##########################################
 # Whether or not __thread is supported for TLS
-tls_thread="no"
+if test "$tls_thread" != "yes" ; then
+  tls_thread="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 static __thread int ret;
@@ -1121,7 +1195,9 @@ echo "__thread                      $tls_thread"
 
 ##########################################
 # Check if we have required gtk/glib support for gfio
-gfio="no"
+if test "$gfio" != "yes" ; then
+  gfio="no"
+fi
 if test "$gfio_check" = "yes" ; then
   cat > $TMPC << EOF
 #include <glib.h>
@@ -1169,7 +1245,9 @@ if test "$gfio_check" = "yes" ; then
 fi
 
 # Check whether we have getrusage(RUSAGE_THREAD)
-rusage_thread="no"
+if test "$rusage_thread" != "yes" ; then
+  rusage_thread="no"
+fi
 cat > $TMPC << EOF
 #include <sys/time.h>
 #include <sys/resource.h>
@@ -1187,7 +1265,9 @@ echo "RUSAGE_THREAD                 $rusage_thread"
 
 ##########################################
 # Check whether we have SCHED_IDLE
-sched_idle="no"
+if test "$sched_idle" != "yes" ; then
+  sched_idle="no"
+fi
 cat > $TMPC << EOF
 #include <sched.h>
 int main(int argc, char **argv)
@@ -1203,7 +1283,9 @@ echo "SCHED_IDLE                    $sched_idle"
 
 ##########################################
 # Check whether we have TCP_NODELAY
-tcp_nodelay="no"
+if test "$tcp_nodelay" != "yes" ; then
+  tcp_nodelay="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <sys/types.h>
@@ -1221,7 +1303,9 @@ echo "TCP_NODELAY                   $tcp_nodelay"
 
 ##########################################
 # Check whether we have SO_SNDBUF
-window_size="no"
+if test "$window_size" != "yes" ; then
+  window_size="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <sys/types.h>
@@ -1240,7 +1324,9 @@ echo "Net engine window_size        $window_size"
 
 ##########################################
 # Check whether we have TCP_MAXSEG
-mss="no"
+if test "$mss" != "yes" ; then
+  mss="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <sys/types.h>
@@ -1260,7 +1346,9 @@ echo "TCP_MAXSEG                    $mss"
 
 ##########################################
 # Check whether we have RLIMIT_MEMLOCK
-rlimit_memlock="no"
+if test "$rlimit_memlock" != "yes" ; then
+  rlimit_memlock="no"
+fi
 cat > $TMPC << EOF
 #include <sys/time.h>
 #include <sys/resource.h>
@@ -1277,7 +1365,9 @@ echo "RLIMIT_MEMLOCK                $rlimit_memlock"
 
 ##########################################
 # Check whether we have pwritev/preadv
-pwritev="no"
+if test "$pwritev" != "yes" ; then
+  pwritev="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <sys/uio.h>
@@ -1293,7 +1383,9 @@ echo "pwritev/preadv                $pwritev"
 
 ##########################################
 # Check whether we have pwritev2/preadv2
-pwritev2="no"
+if test "$pwritev2" != "yes" ; then
+  pwritev2="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <sys/uio.h>
@@ -1309,7 +1401,9 @@ echo "pwritev2/preadv2              $pwritev2"
 
 ##########################################
 # Check whether we have the required functions for ipv6
-ipv6="no"
+if test "$ipv6" != "yes" ; then
+  ipv6="no"
+fi
 cat > $TMPC << EOF
 #include <sys/types.h>
 #include <sys/socket.h>
@@ -1336,7 +1430,9 @@ echo "IPv6 helpers                  $ipv6"
 
 ##########################################
 # check for rbd
-rbd="no"
+if test "$rbd" != "yes" ; then
+  rbd="no"
+fi
 cat > $TMPC << EOF
 #include <rbd/librbd.h>
 
@@ -1362,7 +1458,9 @@ echo "Rados Block Device engine     $rbd"
 
 ##########################################
 # check for rbd_poll
-rbd_poll="no"
+if test "$rbd_poll" != "yes" ; then
+  rbd_poll="no"
+fi
 if test "$rbd" = "yes"; then
 cat > $TMPC << EOF
 #include <rbd/librbd.h>
@@ -1388,7 +1486,9 @@ fi
 
 ##########################################
 # check for rbd_invaidate_cache()
-rbd_inval="no"
+if test "$rbd_inval" != "yes" ; then
+  rbd_inval="no"
+fi
 if test "$rbd" = "yes"; then
 cat > $TMPC << EOF
 #include <rbd/librbd.h>
@@ -1408,7 +1508,9 @@ fi
 
 ##########################################
 # check for blkin
-rbd_blkin="no"
+if test "$rbd_blkin" != "yes" ; then
+  rbd_blkin="no"
+fi
 cat > $TMPC << EOF
 #include <rbd/librbd.h>
 #include <zipkin_c.h>
@@ -1436,7 +1538,9 @@ echo "rbd blkin tracing             $rbd_blkin"
 
 ##########################################
 # Check whether we have setvbuf
-setvbuf="no"
+if test "$setvbuf" != "yes" ; then
+  setvbuf="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 int main(int argc, char **argv)
@@ -1453,7 +1557,9 @@ fi
 echo "setvbuf                       $setvbuf"
 
 # check for gfapi
-gfapi="no"
+if test "$gfapi" != "yes" ; then
+  gfapi="no"
+fi
 cat > $TMPC << EOF
 #include <glusterfs/api/glfs.h>
 
@@ -1472,7 +1578,7 @@ fi
  echo "Gluster API engine            $gfapi"
 
 ##########################################
-# check for gfapi fadvise support
+# check for gfapi fadvise support, initialize with "no" only if $gfapi is set to "yes"
 if test "$gfapi" = "yes" ; then
 gf_fadvise="no"
 cat > $TMPC << EOF
@@ -1494,7 +1600,9 @@ fi
 
 ##########################################
 # check for gfapi trim support
-gf_trim="no"
+if test "$gf_trim" != "yes" ; then
+  gf_trim="no"
+fi
 if test "$gfapi" = "yes" ; then
 cat > $TMPC << EOF
 #include <glusterfs/api/glfs.h>
@@ -1512,7 +1620,9 @@ fi
 
 ##########################################
 # Check if we support stckf on s390
-s390_z196_facilities="no"
+if test "$s390_z196_facilities" != "yes" ; then
+  s390_z196_facilities="no"
+fi
 cat > $TMPC << EOF
 #define STFLE_BITS_Z196 45 /* various z196 facilities ... */
 int main(int argc, char **argv)
@@ -1569,7 +1679,9 @@ echo "HDFS engine                   $libhdfs"
 
 ##########################################
 # Check whether we have MTD
-mtd="no"
+if test "$mtd" != "yes" ; then
+  mtd="no"
+fi
 cat > $TMPC << EOF
 #include <string.h>
 #include <mtd/mtd-user.h>
@@ -1590,7 +1702,9 @@ echo "MTD                           $mtd"
 
 ##########################################
 # Check whether we have libpmem
-libpmem="no"
+if test "$libpmem" != "yes" ; then
+  libpmem="no"
+fi
 cat > $TMPC << EOF
 #include <libpmem.h>
 int main(int argc, char **argv)
@@ -1609,7 +1723,9 @@ echo "libpmem                       $libpmem"
 ##########################################
 # Check whether we have libpmemblk
 # libpmem is a prerequisite
-libpmemblk="no"
+if test "$libpmemblk" != "yes" ; then
+  libpmemblk="no"
+fi
 if test "$libpmem" = "yes"; then
   cat > $TMPC << EOF
 #include <libpmemblk.h>
@@ -1705,7 +1821,9 @@ echo "lex/yacc for arithmetic       $arith"
 
 ##########################################
 # Check whether we have setmntent/getmntent
-getmntent="no"
+if test "$getmntent" != "yes" ; then
+  getmntent="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <mntent.h>
@@ -1729,7 +1847,9 @@ echo "getmntent                     $getmntent"
 
 # getmntinfo(3) for FreeBSD/DragonFlyBSD/OpenBSD.
 # Note that NetBSD needs -Werror to catch warning as error.
-getmntinfo="no"
+if test "$getmntinfo" != "yes" ; then
+  getmntinfo="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <sys/param.h>
@@ -1746,7 +1866,9 @@ fi
 echo "getmntinfo                    $getmntinfo"
 
 # getmntinfo(3) for NetBSD.
-getmntinfo_statvfs="no"
+if test "$getmntinfo_statvfs" != "yes" ; then
+  getmntinfo_statvfs="no"
+fi
 cat > $TMPC << EOF
 #include <stdio.h>
 #include <sys/statvfs.h>
@@ -1764,7 +1886,9 @@ fi
 
 ##########################################
 # Check whether we have _Static_assert
-static_assert="no"
+if test "$static_assert" != "yes" ; then
+  static_assert="no"
+fi
 cat > $TMPC << EOF
 #include <assert.h>
 #include <stdlib.h>
@@ -1796,7 +1920,9 @@ echo "Static Assert                 $static_assert"
 
 ##########################################
 # Check whether we have bool / stdbool.h
-have_bool="no"
+if test "$have_bool" != "yes" ; then
+  have_bool="no"
+fi
 cat > $TMPC << EOF
 #include <stdbool.h>
 int main(int argc, char **argv)
@@ -1812,7 +1938,9 @@ echo "bool                          $have_bool"
 
 ##########################################
 # check march=armv8-a+crc+crypto
-march_armv8_a_crc_crypto="no"
+if test "$march_armv8_a_crc_crypto" != "yes" ; then
+  march_armv8_a_crc_crypto="no"
+fi
 if test "$cpu" = "arm64" ; then
   cat > $TMPC <<EOF
 int main(void)
diff --git a/engines/glusterfs_sync.c b/engines/glusterfs_sync.c
index 05e184c..25d05b2 100644
--- a/engines/glusterfs_sync.c
+++ b/engines/glusterfs_sync.c
@@ -7,7 +7,7 @@
 
 #include "gfapi.h"
 
-#define LAST_POS(f)	((f)->engine_data)
+#define LAST_POS(f)	((f)->engine_pos)
 static int fio_gf_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index e8476f9..52af9ed 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -86,10 +86,6 @@ struct fio_pmemblk_file {
 	size_t pmb_bsize;
 	size_t pmb_nblocks;
 };
-#define FIOFILEPMBSET(_f, _v)  do {                 \
-	(_f)->engine_data = (uint64_t)(uintptr_t)(_v);  \
-} while(0)
-#define FIOFILEPMBGET(_f)  ((fio_pmemblk_file_t)((_f)->engine_data))
 
 static fio_pmemblk_file_t Cache;
 
@@ -304,26 +300,26 @@ static int fio_pmemblk_open_file(struct thread_data *td, struct fio_file *f)
 	if (!pmb)
 		return 1;
 
-	FIOFILEPMBSET(f, pmb);
+	FILE_SET_ENG_DATA(f, pmb);
 	return 0;
 }
 
 static int fio_pmemblk_close_file(struct thread_data fio_unused *td,
 				  struct fio_file *f)
 {
-	fio_pmemblk_file_t pmb = FIOFILEPMBGET(f);
+	fio_pmemblk_file_t pmb = FILE_ENG_DATA(f);
 
 	if (pmb)
 		pmb_close(pmb, false);
 
-	FIOFILEPMBSET(f, NULL);
+	FILE_SET_ENG_DATA(f, NULL);
 	return 0;
 }
 
 static int fio_pmemblk_get_file_size(struct thread_data *td, struct fio_file *f)
 {
 	uint64_t flags = 0;
-	fio_pmemblk_file_t pmb = FIOFILEPMBGET(f);
+	fio_pmemblk_file_t pmb = FILE_ENG_DATA(f);
 
 	if (fio_file_size_known(f))
 		return 0;
@@ -340,7 +336,7 @@ static int fio_pmemblk_get_file_size(struct thread_data *td, struct fio_file *f)
 
 	fio_file_set_size_known(f);
 
-	if (!FIOFILEPMBGET(f))
+	if (!FILE_ENG_DATA(f))
 		pmb_close(pmb, true);
 
 	return 0;
@@ -349,7 +345,7 @@ static int fio_pmemblk_get_file_size(struct thread_data *td, struct fio_file *f)
 static int fio_pmemblk_queue(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
-	fio_pmemblk_file_t pmb = FIOFILEPMBGET(f);
+	fio_pmemblk_file_t pmb = FILE_ENG_DATA(f);
 
 	unsigned long long off;
 	unsigned long len;
diff --git a/engines/sync.c b/engines/sync.c
index 1726b8e..e76bbbb 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -18,7 +18,7 @@
 /*
  * Sync engine uses engine_data to store last offset
  */
-#define LAST_POS(f)	((f)->engine_data)
+#define LAST_POS(f)	((f)->engine_pos)
 
 struct syncio_data {
 	struct iovec *iovecs;
diff --git a/file.h b/file.h
index 611470c..9801bb5 100644
--- a/file.h
+++ b/file.h
@@ -113,9 +113,12 @@ struct fio_file {
 	unsigned int last_write_idx;
 
 	/*
-	 * For use by the io engine
+	 * For use by the io engine for offset or private data storage
 	 */
-	uint64_t engine_data;
+	union {
+		uint64_t engine_pos;
+		void *engine_data;
+	};
 
 	/*
 	 * if io is protected by a semaphore, this is set
@@ -147,14 +150,8 @@ struct fio_file {
 	struct disk_util *du;
 };
 
-#define FILE_ENG_DATA(f)	((void *) (uintptr_t) (f)->engine_data)
-#define FILE_SET_ENG_DATA(f, data)	\
-	((f)->engine_data = (uintptr_t) (data))
-
-struct file_name {
-	struct flist_head list;
-	char *filename;
-};
+#define FILE_ENG_DATA(f)		((f)->engine_data)
+#define FILE_SET_ENG_DATA(f, data)	((f)->engine_data = (data))
 
 #define FILE_FLAG_FNS(name)						\
 static inline void fio_file_set_##name(struct fio_file *f)		\
diff --git a/filesetup.c b/filesetup.c
index 793b08d..4d0b127 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -24,6 +24,14 @@ static int root_warn;
 
 static FLIST_HEAD(filename_list);
 
+/*
+ * List entry for filename_list
+ */
+struct file_name {
+	struct flist_head list;
+	char *filename;
+};
+
 static inline void clear_error(struct thread_data *td)
 {
 	td->error = 0;
@@ -377,12 +385,8 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 		ret = bdev_size(td, f);
 	else if (f->filetype == FIO_TYPE_CHAR)
 		ret = char_size(td, f);
-	else {
-		f->real_file_size = -1;
-		log_info("%s: failed to get file size of %s\n", td->o.name,
-					f->file_name);
-		return 1; /* avoid offset extends end error message */
-	}
+	else
+		f->real_file_size = -1ULL;
 
 	/*
 	 * Leave ->real_file_size with 0 since it could be expectation
@@ -392,10 +396,22 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 		return ret;
 
 	/*
+	 * If ->real_file_size is -1, a conditional for the message
+	 * "offset extends end" is always true, but it makes no sense,
+	 * so just return the same value here.
+	 */
+	if (f->real_file_size == -1ULL) {
+		log_info("%s: failed to get file size of %s\n", td->o.name,
+					f->file_name);
+		return 1;
+	}
+
+	if (td->o.start_offset && f->file_offset == 0)
+		dprint(FD_FILE, "offset of file %s not initialized yet\n",
+					f->file_name);
+	/*
 	 * ->file_offset normally hasn't been initialized yet, so this
-	 * is basically always false unless ->real_file_size is -1, but
-	 * if ->real_file_size is -1 this message doesn't make sense.
-	 * As a result, this message is basically useless.
+	 * is basically always false.
 	 */
 	if (f->file_offset > f->real_file_size) {
 		log_err("%s: offset extends end (%llu > %llu)\n", td->o.name,
@@ -503,7 +519,7 @@ int generic_close_file(struct thread_data fio_unused *td, struct fio_file *f)
 		f->shadow_fd = -1;
 	}
 
-	f->engine_data = 0;
+	f->engine_pos = 0;
 	return ret;
 }
 
@@ -611,7 +627,8 @@ open_again:
 			f->fd = dup(STDIN_FILENO);
 		else
 			from_hash = file_lookup_open(f, flags);
-	} else { //td trim
+	} else if (td_trim(td)) {
+		assert(!td_rw(td)); /* should have matched above */
 		flags |= O_RDWR;
 		from_hash = file_lookup_open(f, flags);
 	}
@@ -685,7 +702,7 @@ static int get_file_sizes(struct thread_data *td)
 	int err = 0;
 
 	for_each_file(td, f, i) {
-		dprint(FD_FILE, "get file size for %p/%d/%p\n", f, i,
+		dprint(FD_FILE, "get file size for %p/%d/%s\n", f, i,
 								f->file_name);
 
 		if (td_io_get_file_size(td, f)) {
@@ -896,8 +913,7 @@ int setup_files(struct thread_data *td)
 		if (!o->file_size_low) {
 			/*
 			 * no file size or range given, file size is equal to
-			 * total size divided by number of files. If that is
-			 * zero, set it to the real file size. If the size
+			 * total size divided by number of files. If the size
 			 * doesn't divide nicely with the min blocksize,
 			 * make the first files bigger.
 			 */
@@ -907,8 +923,24 @@ int setup_files(struct thread_data *td)
 				f->io_size += bs;
 			}
 
-			if (!f->io_size)
+			/*
+			 * We normally don't come here, but if the result is 0,
+			 * set it to the real file size. This could be size of
+			 * the existing one if it already exists, but otherwise
+			 * will be set to 0. A new file won't be created because
+			 * ->io_size + ->file_offset equals ->real_file_size.
+			 */
+			if (!f->io_size) {
+				if (f->file_offset > f->real_file_size)
+					goto err_offset;
 				f->io_size = f->real_file_size - f->file_offset;
+				log_info("fio: forcing file %s size to %llu\n",
+					f->file_name,
+					(unsigned long long)f->io_size);
+				if (!f->io_size)
+					log_info("fio: file %s may be ignored\n",
+						f->file_name);
+			}
 		} else if (f->real_file_size < o->file_size_low ||
 			   f->real_file_size > o->file_size_high) {
 			if (f->file_offset > o->file_size_low)
@@ -942,9 +974,9 @@ int setup_files(struct thread_data *td)
 			if (!o->create_on_open) {
 				need_extend++;
 				extend_size += (f->io_size + f->file_offset);
+				fio_file_set_extend(f);
 			} else
 				f->real_file_size = f->io_size + f->file_offset;
-			fio_file_set_extend(f);
 		}
 	}
 
@@ -984,9 +1016,15 @@ int setup_files(struct thread_data *td)
 	 */
 	if (need_extend) {
 		temp_stall_ts = 1;
-		if (output_format & FIO_OUTPUT_NORMAL)
-			log_info("%s: Laying out IO file(s) (%u file(s) / %lluMiB)\n",
-				 o->name, need_extend, extend_size >> 20);
+		if (output_format & FIO_OUTPUT_NORMAL) {
+			log_info("%s: Laying out IO file%s (%u file%s / %s%lluMiB)\n",
+				 o->name,
+				 need_extend > 1 ? "s" : "",
+				 need_extend,
+				 need_extend > 1 ? "s" : "",
+				 need_extend > 1 ? "total " : "",
+				 extend_size >> 20);
+		}
 
 		for_each_file(td, f, i) {
 			unsigned long long old_len = -1ULL, extend_len = -1ULL;
diff --git a/fio.h b/fio.h
index b2f0e2f..b573ac5 100644
--- a/fio.h
+++ b/fio.h
@@ -490,7 +490,7 @@ static inline int should_fsync(struct thread_data *td)
 {
 	if (td->last_was_sync)
 		return 0;
-	if (td_write(td) || td_rw(td) || td->o.override_sync)
+	if (td_write(td) || td->o.override_sync)
 		return 1;
 
 	return 0;
diff --git a/init.c b/init.c
index fabc887..18538de 100644
--- a/init.c
+++ b/init.c
@@ -356,9 +356,8 @@ static int setup_thread_area(void)
 		perror("shmat");
 		return 1;
 	}
-#ifdef FIO_HAVE_SHM_ATTACH_REMOVED
-	shmctl(shm_id, IPC_RMID, NULL);
-#endif
+	if (shm_attach_to_open_removed())
+		shmctl(shm_id, IPC_RMID, NULL);
 #endif
 
 	memset(threads, 0, max_jobs * sizeof(struct thread_data));
@@ -620,7 +619,7 @@ static int fixup_options(struct thread_data *td)
 	/*
 	 * Reads can do overwrites, we always need to pre-create the file
 	 */
-	if (td_read(td) || td_rw(td))
+	if (td_read(td))
 		o->overwrite = 1;
 
 	if (!o->min_bs[DDIR_READ])
@@ -765,7 +764,11 @@ static int fixup_options(struct thread_data *td)
 	}
 
 	if (o->pre_read) {
-		o->invalidate_cache = 0;
+		if (o->invalidate_cache) {
+			log_info("fio: ignore invalidate option for %s\n",
+				 o->name);
+			o->invalidate_cache = 0;
+		}
 		if (td_ioengine_flagged(td, FIO_PIPEIO)) {
 			log_info("fio: cannot pre-read files with an IO engine"
 				 " that isn't seekable. Pre-read disabled.\n");
diff --git a/io_u.c b/io_u.c
index e12382b..cb8fc4a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -643,7 +643,7 @@ int io_u_quiesce(struct thread_data *td)
 	}
 
 	while (td->io_u_in_flight) {
-		int fio_unused ret;
+		int ret;
 
 		ret = io_u_queued_complete(td, 1);
 		if (ret > 0)
@@ -1960,7 +1960,7 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
 	int ret, ddir;
 	struct timespec ts = { .tv_sec = 0, .tv_nsec = 0, };
 
-	dprint(FD_IO, "io_u_queued_completed: min=%d\n", min_evts);
+	dprint(FD_IO, "io_u_queued_complete: min=%d\n", min_evts);
 
 	if (!min_evts)
 		tvp = &ts;
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 5e94855..97452ca 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -24,8 +24,7 @@
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_CPU_AFFINITY
 #define FIO_HAVE_IOPRIO
-/* Only have attach-to-open-removed when kern.ipc.shm_allow_removed is 1 */
-#undef  FIO_HAVE_SHM_ATTACH_REMOVED
+#define FIO_HAVE_SHM_ATTACH_REMOVED
 
 #define OS_MAP_ANON		MAP_ANON
 
@@ -234,4 +233,15 @@ static inline int os_trim(int fd, unsigned long long start,
 #define FIO_MADV_FREE	MADV_FREE
 #endif
 
+static inline int shm_attach_to_open_removed(void)
+{
+	int x;
+	size_t len = sizeof(x);
+
+	if (sysctlbyname("kern.ipc.shm_allow_removed", &x, &len, NULL, 0) < 0)
+		return 0;
+
+	return x > 0 ? 1 : 0;
+}
+
 #endif
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index aa90954..9d1af3b 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -22,9 +22,7 @@
 #define FIO_HAVE_TRIM
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_CPU_AFFINITY
-/* Only have attach-to-open-removed when kern.ipc.shm_allow_removed is 1 */
-#undef  FIO_HAVE_SHM_ATTACH_REMOVED
-
+#define FIO_HAVE_SHM_ATTACH_REMOVED
 
 #define OS_MAP_ANON		MAP_ANON
 
@@ -136,4 +134,15 @@ static inline int os_trim(int fd, unsigned long long start,
 #define FIO_MADV_FREE	MADV_FREE
 #endif
 
+static inline int shm_attach_to_open_removed(void)
+{
+	int x;
+	size_t len = sizeof(x);
+
+	if (sysctlbyname("kern.ipc.shm_allow_removed", &x, &len, NULL, 0) < 0)
+		return 0;
+
+	return x > 0 ? 1 : 0;
+}
+
 #endif
diff --git a/os/os-linux.h b/os/os-linux.h
index 1829829..7be833b 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -350,4 +350,9 @@ static inline ssize_t pwritev2(int fd, const struct iovec *iov, int iovcnt,
 #endif /* __NR_preadv2 */
 #endif /* CONFIG_PWRITEV2 */
 
+static inline int shm_attach_to_open_removed(void)
+{
+	return 1;
+}
+
 #endif
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index 4700572..3b19483 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -22,12 +22,10 @@
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
+#define FIO_HAVE_SHM_ATTACH_REMOVED
 
 #undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
 
-/* Only OpenBSD 5.1 and above have attach-to-open-removed semantics */
-#undef  FIO_HAVE_SHM_ATTACH_REMOVED
-
 #define OS_MAP_ANON		MAP_ANON
 
 #ifndef PTHREAD_STACK_MIN
@@ -90,4 +88,12 @@ static inline unsigned long long get_fs_free_size(const char *path)
 #define FIO_MADV_FREE	MADV_FREE
 #endif
 
+static inline int shm_attach_to_open_removed(void)
+{
+	/*
+	 * XXX: Return 1 if >= OpenBSD 5.1 according to 97900ebf.
+	 */
+	return 0;
+}
+
 #endif
diff --git a/os/os.h b/os/os.h
index 4178e6f..5e3c813 100644
--- a/os/os.h
+++ b/os/os.h
@@ -386,4 +386,11 @@ static inline int gettid(void)
 }
 #endif
 
+#ifndef FIO_HAVE_SHM_ATTACH_REMOVED
+static inline int shm_attach_to_open_removed(void)
+{
+	return 0;
+}
+#endif
+
 #endif
diff --git a/rate-submit.c b/rate-submit.c
index 42927ff..4738dc4 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -98,7 +98,6 @@ static int io_workqueue_init_worker_fn(struct submit_worker *sw)
 {
 	struct thread_data *parent = sw->wq->td;
 	struct thread_data *td = sw->priv;
-	int fio_unused ret;
 
 	memcpy(&td->o, &parent->o, sizeof(td->o));
 	memcpy(&td->ts, &parent->ts, sizeof(td->ts));
diff --git a/verify.c b/verify.c
index f567ec1..cadfe9c 100644
--- a/verify.c
+++ b/verify.c
@@ -851,7 +851,7 @@ static int verify_header(struct io_u *io_u, struct thread_data *td,
 	 * state of numberio, that would have been written to each block
 	 * in a previous run of fio, has been reached.
 	 */
-	if ((td_write(td) || td_rw(td)) && (td_min_bs(td) == td_max_bs(td)) &&
+	if (td_write(td) && (td_min_bs(td) == td_max_bs(td)) &&
 	    !td->o.time_based)
 		if (!td->o.verify_only || td->o.loops == 0)
 			if (hdr->numberio != io_u->numberio) {
