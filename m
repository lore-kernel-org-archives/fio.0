Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 17/17] configure: Make Cygwin take regular configure path
Date: Tue,  7 Mar 2017 22:13:08 +0200
Message-Id: <20170307201308.66814-18-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Cygwin (and only Cygwin) has been using customized configure process
by forcing hard-coded "known good options" without going through
regular compile_prog() based configure path. This was necessary due
to difference from other Unix likes, but it could be changed so that
Cygwin at least takes the regular configure path while continue to
use hard-coded configurations. This makes the configure script less
platform specific.

This commit basically gets rid of "exit 0" part from Cygwin case,
which enables Cygwin to go through the regular compile_prog() based
configure path. Removing "exit 0" requires some other small fixes
explained below so that Cygwin outputs consistent results (i.e. don't
ignore hard-coded configurations and lie on outputs).

Also note that this commit does nothing to Linux or other platforms.
It only affects Cygwin or any other platform that wants to override
or ignore regular configure path (i.e. compile_prog() results) in
the future. If there's any specific reason Cygwin has to workaround
the regular configure path, this shouldn't be applied, but there
seems to be no reason not to do so as it compiles and runs on Cygwin.

--
0. Remove "exit 0" in Cygwin case which is the main objective.

1. Change hard-coded output_sym() calls in Cygwin case to use shell
variables that have been used and initialized with "no" in the regular
compile_prog() based configure path.

2. Change the regular compile_prog() based configure path to check
if shell variables have already been initialized with "yes", and
initialize them with "no" only if they haven't been set to "yes",
so that shell variables statically initialized with "yes" in Cygwin
case don't get reset. This does nothing to Linux/etc because they
never preconfigure variables with "yes".

3. Get rid of output_sym "CONFIG_LITTLE_ENDIAN" call in Cygwin case.
This doesn't need to be here as endianness detection isn't anything
specific to Cygwin. Although x86 is the only supported arch, the regular
compile_prog() based configure path can detect it, and if it doesn't
then a compiler is probably broken.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 290 ++++++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 209 insertions(+), 81 deletions(-)

diff --git a/configure b/configure
index 8124467..7b55711 100755
--- a/configure
+++ b/configure
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
-- 
2.9.3


