Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 11/11] configure: Add print_config() for "<config>... <yes|no>" outputs
Date: Mon,  1 May 2017 21:48:20 +0300
Message-Id: <20170501184820.31025-11-tkusumi@tuxera.com>
In-Reply-To: <20170501184820.31025-1-tkusumi@tuxera.com>
References: <20170501184820.31025-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Hide alignment (30 spaces between two columns) from callers.

This may not be applied depending on adoption of previous series
of diffs, but in case this one is good but doesn't apply, I'll
resubmit this.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 157 ++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 81 insertions(+), 76 deletions(-)

diff --git a/configure b/configure
index ce46996..3bb8b40 100755
--- a/configure
+++ b/configure
@@ -41,6 +41,11 @@ fatal() {
   exit 1
 }
 
+# Print result for each configuration test
+print_config() {
+  printf "%-30s%s\n" "$1" "$2"
+}
+
 # Default CFLAGS
 CFLAGS="-D_GNU_SOURCE -include config-host.h"
 BUILD_CFLAGS=""
@@ -494,11 +499,11 @@ EOF
 fi
 
 
-echo "Operating system              $targetos"
-echo "CPU                           $cpu"
-echo "Big endian                    $bigendian"
-echo "Compiler                      $cc"
-echo "Cross compile                 $cross_compile"
+print_config "Operating system" "$targetos"
+print_config "CPU" "$cpu"
+print_config "Big endian" "$bigendian"
+print_config "Compiler" "$cc"
+print_config "Cross compile" "$cross_compile"
 echo
 
 ##########################################
@@ -509,7 +514,7 @@ if test "$build_static" = "yes" ; then
 else
   build_static="no"
 fi
-echo "Static build                  $build_static"
+print_config "Static build" "$build_static"
 
 ##########################################
 # check for wordsize
@@ -530,7 +535,7 @@ elif compile_prog "-DWORDSIZE=64" "" "wordsize"; then
 else
   fatal "Unknown wordsize"
 fi
-echo "Wordsize                      $wordsize"
+print_config "Wordsize" "$wordsize"
 
 ##########################################
 # zlib probe
@@ -551,7 +556,7 @@ if compile_prog "" "-lz" "zlib" ; then
   zlib=yes
   LIBS="-lz $LIBS"
 fi
-echo "zlib                          $zlib"
+print_config "zlib" "$zlib"
 
 ##########################################
 # linux-aio probe
@@ -578,7 +583,7 @@ EOF
     libaio=no
   fi
 fi
-echo "Linux AIO support             $libaio"
+print_config "Linux AIO support" "$libaio"
 
 ##########################################
 # posix aio probe
@@ -604,8 +609,8 @@ elif compile_prog "" "-lrt" "posixaio"; then
   posix_aio_lrt="yes"
   LIBS="-lrt $LIBS"
 fi
-echo "POSIX AIO support             $posix_aio"
-echo "POSIX AIO support needs -lrt  $posix_aio_lrt"
+print_config "POSIX AIO support" "$posix_aio"
+print_config "POSIX AIO support needs -lrt" "$posix_aio_lrt"
 
 ##########################################
 # posix aio fsync probe
@@ -627,7 +632,7 @@ EOF
     posix_aio_fsync=yes
   fi
 fi
-echo "POSIX AIO fsync               $posix_aio_fsync"
+print_config "POSIX AIO fsync" "$posix_aio_fsync"
 
 ##########################################
 # POSIX pshared attribute probe
@@ -657,7 +662,7 @@ EOF
 if compile_prog "" "$LIBS" "posix_pshared" ; then
   posix_pshared=yes
 fi
-echo "POSIX pshared support         $posix_pshared"
+print_config "POSIX pshared support" "$posix_pshared"
 
 ##########################################
 # solaris aio probe
@@ -679,7 +684,7 @@ if compile_prog "" "-laio" "solarisaio" ; then
   solaris_aio=yes
   LIBS="-laio $LIBS"
 fi
-echo "Solaris AIO support           $solaris_aio"
+print_config "Solaris AIO support" "$solaris_aio"
 
 ##########################################
 # __sync_fetch_and_add test
@@ -703,7 +708,7 @@ EOF
 if compile_prog "" "" "__sync_fetch_and_add()" ; then
     sfaa="yes"
 fi
-echo "__sync_fetch_and_add          $sfaa"
+print_config "__sync_fetch_and_add" "$sfaa"
 
 ##########################################
 # libverbs probe
@@ -723,7 +728,7 @@ if test "$disable_rdma" != "yes" && compile_prog "" "-libverbs" "libverbs" ; the
     libverbs="yes"
     LIBS="-libverbs $LIBS"
 fi
-echo "libverbs                      $libverbs"
+print_config "libverbs" "$libverbs"
 
 ##########################################
 # rdmacm probe
@@ -743,7 +748,7 @@ if test "$disable_rdma" != "yes" && compile_prog "" "-lrdmacm" "rdma"; then
     rdmacm="yes"
     LIBS="-lrdmacm $LIBS"
 fi
-echo "rdmacm                        $rdmacm"
+print_config "rdmacm" "$rdmacm"
 
 ##########################################
 # Linux fallocate probe
@@ -763,7 +768,7 @@ EOF
 if compile_prog "" "" "linux_fallocate"; then
     linux_fallocate="yes"
 fi
-echo "Linux fallocate               $linux_fallocate"
+print_config "Linux fallocate" "$linux_fallocate"
 
 ##########################################
 # POSIX fadvise probe
@@ -782,7 +787,7 @@ EOF
 if compile_prog "" "" "posix_fadvise"; then
     posix_fadvise="yes"
 fi
-echo "POSIX fadvise                 $posix_fadvise"
+print_config "POSIX fadvise" "$posix_fadvise"
 
 ##########################################
 # POSIX fallocate probe
@@ -812,7 +817,7 @@ EOF
 if compile_exec_prog "" "" "posix_fallocate" "$TMPF"; then
     posix_fallocate="yes"
 fi
-echo "POSIX fallocate               $posix_fallocate"
+print_config "POSIX fallocate" "$posix_fallocate"
 
 ##########################################
 # sched_set/getaffinity 2 or 3 argument test
@@ -845,8 +850,8 @@ EOF
     linux_2arg_affinity="yes"
   fi
 fi
-echo "sched_setaffinity(3 arg)      $linux_3arg_affinity"
-echo "sched_setaffinity(2 arg)      $linux_2arg_affinity"
+print_config "sched_setaffinity(3 arg)" "$linux_3arg_affinity"
+print_config "sched_setaffinity(2 arg)" "$linux_2arg_affinity"
 
 ##########################################
 # clock_gettime probe
@@ -867,7 +872,7 @@ elif compile_prog "" "-lrt" "clock_gettime"; then
     clock_gettime="yes"
     LIBS="-lrt $LIBS"
 fi
-echo "clock_gettime                 $clock_gettime"
+print_config "clock_gettime" "$clock_gettime"
 
 ##########################################
 # CLOCK_MONOTONIC probe
@@ -887,7 +892,7 @@ EOF
       clock_monotonic="yes"
   fi
 fi
-echo "CLOCK_MONOTONIC               $clock_monotonic"
+print_config "CLOCK_MONOTONIC" "$clock_monotonic"
 
 ##########################################
 # CLOCK_MONOTONIC_RAW probe
@@ -907,7 +912,7 @@ EOF
       clock_monotonic_raw="yes"
   fi
 fi
-echo "CLOCK_MONOTONIC_RAW           $clock_monotonic_raw"
+print_config "CLOCK_MONOTONIC_RAW" "$clock_monotonic_raw"
 
 ##########################################
 # CLOCK_MONOTONIC_PRECISE probe
@@ -927,7 +932,7 @@ EOF
       clock_monotonic_precise="yes"
   fi
 fi
-echo "CLOCK_MONOTONIC_PRECISE       $clock_monotonic_precise"
+print_config "CLOCK_MONOTONIC_PRECISE" "$clock_monotonic_precise"
 
 ##########################################
 # clockid_t probe
@@ -947,7 +952,7 @@ EOF
 if compile_prog "" "$LIBS" "clockid_t"; then
   clockid_t="yes"
 fi
-echo "clockid_t                     $clockid_t"
+print_config "clockid_t" "$clockid_t"
 
 ##########################################
 # gettimeofday() probe
@@ -966,7 +971,7 @@ EOF
 if compile_prog "" "" "gettimeofday"; then
     gettimeofday="yes"
 fi
-echo "gettimeofday                  $gettimeofday"
+print_config "gettimeofday" "$gettimeofday"
 
 ##########################################
 # fdatasync() probe
@@ -984,7 +989,7 @@ EOF
 if compile_prog "" "" "fdatasync"; then
   fdatasync="yes"
 fi
-echo "fdatasync                     $fdatasync"
+print_config "fdatasync" "$fdatasync"
 
 ##########################################
 # sync_file_range() probe
@@ -1006,7 +1011,7 @@ EOF
 if compile_prog "" "" "sync_file_range"; then
   sync_file_range="yes"
 fi
-echo "sync_file_range               $sync_file_range"
+print_config "sync_file_range" "$sync_file_range"
 
 ##########################################
 # ext4 move extent probe
@@ -1030,7 +1035,7 @@ elif test $targetos = "Linux" ; then
   # work. Takes a while to bubble back.
   ext4_me="yes"
 fi
-echo "EXT4 move extent              $ext4_me"
+print_config "EXT4 move extent" "$ext4_me"
 
 ##########################################
 # splice probe
@@ -1048,7 +1053,7 @@ EOF
 if compile_prog "" "" "linux splice"; then
   linux_splice="yes"
 fi
-echo "Linux splice(2)               $linux_splice"
+print_config "Linux splice(2)" "$linux_splice"
 
 ##########################################
 # GUASI probe
@@ -1067,7 +1072,7 @@ EOF
 if compile_prog "" "" "guasi"; then
   guasi="yes"
 fi
-echo "GUASI                         $guasi"
+print_config "GUASI" "$guasi"
 
 ##########################################
 # fusion-aw probe
@@ -1089,7 +1094,7 @@ if compile_prog "" "-L/usr/lib/fio -L/usr/lib/nvm -lnvm-primitives -ldl -lpthrea
   LIBS="-L/usr/lib/fio -L/usr/lib/nvm -lnvm-primitives -ldl -lpthread $LIBS"
   fusion_aw="yes"
 fi
-echo "Fusion-io atomic engine       $fusion_aw"
+print_config "Fusion-io atomic engine" "$fusion_aw"
 
 ##########################################
 # libnuma probe
@@ -1107,7 +1112,7 @@ if test "$disable_numa" != "yes"  && compile_prog "" "-lnuma" "libnuma"; then
   libnuma="yes"
   LIBS="-lnuma $LIBS"
 fi
-echo "libnuma                       $libnuma"
+print_config "libnuma" "$libnuma"
 
 ##########################################
 # libnuma 2.x version API, initialize with "no" only if $libnuma is set to "yes"
@@ -1124,7 +1129,7 @@ EOF
 if compile_prog "" "" "libnuma api"; then
   libnuma_v2="yes"
 fi
-echo "libnuma v2                    $libnuma_v2"
+print_config "libnuma v2" "$libnuma_v2"
 fi
 
 ##########################################
@@ -1144,7 +1149,7 @@ EOF
 if compile_prog "" "" "strsep"; then
   strsep="yes"
 fi
-echo "strsep                        $strsep"
+print_config "strsep" "$strsep"
 
 ##########################################
 # strcasestr() probe
@@ -1161,7 +1166,7 @@ EOF
 if compile_prog "" "" "strcasestr"; then
   strcasestr="yes"
 fi
-echo "strcasestr                    $strcasestr"
+print_config "strcasestr" "$strcasestr"
 
 ##########################################
 # strlcat() probe
@@ -1182,7 +1187,7 @@ EOF
 if compile_prog "" "" "strlcat"; then
   strlcat="yes"
 fi
-echo "strlcat                       $strlcat"
+print_config "strlcat" "$strlcat"
 
 ##########################################
 # getopt_long_only() probe
@@ -1202,7 +1207,7 @@ EOF
 if compile_prog "" "" "getopt_long_only"; then
   getopt_long_only="yes"
 fi
-echo "getopt_long_only()            $getopt_long_only"
+print_config "getopt_long_only()" "$getopt_long_only"
 
 ##########################################
 # inet_aton() probe
@@ -1222,7 +1227,7 @@ EOF
 if compile_prog "" "" "inet_aton"; then
   inet_aton="yes"
 fi
-echo "inet_aton                     $inet_aton"
+print_config "inet_aton" "$inet_aton"
 
 ##########################################
 # socklen_t probe
@@ -1240,7 +1245,7 @@ EOF
 if compile_prog "" "" "socklen_t"; then
   socklen_t="yes"
 fi
-echo "socklen_t                     $socklen_t"
+print_config "socklen_t" "$socklen_t"
 
 ##########################################
 # Whether or not __thread is supported for TLS
@@ -1258,7 +1263,7 @@ EOF
 if compile_prog "" "" "__thread"; then
   tls_thread="yes"
 fi
-echo "__thread                      $tls_thread"
+print_config "__thread" "$tls_thread"
 
 ##########################################
 # Check if we have required gtk/glib support for gfio
@@ -1308,7 +1313,7 @@ LDFLAGS=$ORG_LDFLAGS
 fi
 
 if test "$gfio_check" = "yes" ; then
-  echo "gtk 2.18 or higher            $gfio"
+  print_config "gtk 2.18 or higher" "$gfio"
 fi
 
 ##########################################
@@ -1329,7 +1334,7 @@ EOF
 if compile_prog "" "" "RUSAGE_THREAD"; then
   rusage_thread="yes"
 fi
-echo "RUSAGE_THREAD                 $rusage_thread"
+print_config "RUSAGE_THREAD" "$rusage_thread"
 
 ##########################################
 # Check whether we have SCHED_IDLE
@@ -1347,7 +1352,7 @@ EOF
 if compile_prog "" "" "SCHED_IDLE"; then
   sched_idle="yes"
 fi
-echo "SCHED_IDLE                    $sched_idle"
+print_config "SCHED_IDLE" "$sched_idle"
 
 ##########################################
 # Check whether we have TCP_NODELAY
@@ -1367,7 +1372,7 @@ EOF
 if compile_prog "" "" "TCP_NODELAY"; then
   tcp_nodelay="yes"
 fi
-echo "TCP_NODELAY                   $tcp_nodelay"
+print_config "TCP_NODELAY" "$tcp_nodelay"
 
 ##########################################
 # Check whether we have SO_SNDBUF
@@ -1388,7 +1393,7 @@ EOF
 if compile_prog "" "" "SO_SNDBUF"; then
   window_size="yes"
 fi
-echo "Net engine window_size        $window_size"
+print_config "Net engine window_size" "$window_size"
 
 ##########################################
 # Check whether we have TCP_MAXSEG
@@ -1410,7 +1415,7 @@ EOF
 if compile_prog "" "" "TCP_MAXSEG"; then
   mss="yes"
 fi
-echo "TCP_MAXSEG                    $mss"
+print_config "TCP_MAXSEG" "$mss"
 
 ##########################################
 # Check whether we have RLIMIT_MEMLOCK
@@ -1429,7 +1434,7 @@ EOF
 if compile_prog "" "" "RLIMIT_MEMLOCK"; then
   rlimit_memlock="yes"
 fi
-echo "RLIMIT_MEMLOCK                $rlimit_memlock"
+print_config "RLIMIT_MEMLOCK" "$rlimit_memlock"
 
 ##########################################
 # Check whether we have pwritev/preadv
@@ -1447,7 +1452,7 @@ EOF
 if compile_prog "" "" "pwritev"; then
   pwritev="yes"
 fi
-echo "pwritev/preadv                $pwritev"
+print_config "pwritev/preadv" "$pwritev"
 
 ##########################################
 # Check whether we have pwritev2/preadv2
@@ -1465,7 +1470,7 @@ EOF
 if compile_prog "" "" "pwritev2"; then
   pwritev2="yes"
 fi
-echo "pwritev2/preadv2              $pwritev2"
+print_config "pwritev2/preadv2" "$pwritev2"
 
 ##########################################
 # Check whether we have the required functions for ipv6
@@ -1494,7 +1499,7 @@ EOF
 if compile_prog "" "" "ipv6"; then
   ipv6="yes"
 fi
-echo "IPv6 helpers                  $ipv6"
+print_config "IPv6 helpers" "$ipv6"
 
 ##########################################
 # check for rbd
@@ -1521,7 +1526,7 @@ if test "$disable_rbd" != "yes"  && compile_prog "" "-lrbd -lrados" "rbd"; then
   LIBS="-lrbd -lrados $LIBS"
   rbd="yes"
 fi
-echo "Rados Block Device engine     $rbd"
+print_config "Rados Block Device engine" "$rbd"
 
 ##########################################
 # check for rbd_poll
@@ -1548,7 +1553,7 @@ EOF
 if compile_prog "" "-lrbd -lrados" "rbd"; then
   rbd_poll="yes"
 fi
-echo "rbd_poll                      $rbd_poll"
+print_config "rbd_poll" "$rbd_poll"
 fi
 
 ##########################################
@@ -1570,7 +1575,7 @@ EOF
 if compile_prog "" "-lrbd -lrados" "rbd"; then
   rbd_inval="yes"
 fi
-echo "rbd_invalidate_cache          $rbd_inval"
+print_config "rbd_invalidate_cache" "$rbd_inval"
 fi
 
 ##########################################
@@ -1601,7 +1606,7 @@ if test "$disable_rbd" != "yes" && test "$disable_rbd_blkin" != "yes" \
   LIBS="-lblkin $LIBS"
   rbd_blkin="yes"
 fi
-echo "rbd blkin tracing             $rbd_blkin"
+print_config "rbd blkin tracing" "$rbd_blkin"
 
 ##########################################
 # Check whether we have setvbuf
@@ -1621,7 +1626,7 @@ EOF
 if compile_prog "" "" "setvbuf"; then
   setvbuf="yes"
 fi
-echo "setvbuf                       $setvbuf"
+print_config "setvbuf" "$setvbuf"
 
 ##########################################
 # check for gfapi
@@ -1642,7 +1647,7 @@ if test "$disable_gfapi" != "yes"  && compile_prog "" "-lgfapi -lglusterfs" "gfa
   LIBS="-lgfapi -lglusterfs $LIBS"
   gfapi="yes"
 fi
- echo "Gluster API engine            $gfapi"
+print_config "Gluster API engine" "$gfapi"
 
 ##########################################
 # check for gfapi fadvise support, initialize with "no" only if $gfapi is set to "yes"
@@ -1662,7 +1667,7 @@ EOF
 if compile_prog "" "-lgfapi -lglusterfs" "gfapi"; then
   gf_fadvise="yes"
 fi
-echo "Gluster API use fadvise       $gf_fadvise"
+print_config "Gluster API use fadvise" "$gf_fadvise"
 fi
 
 ##########################################
@@ -1682,7 +1687,7 @@ EOF
 if compile_prog "" "-lgfapi -lglusterfs" "gf trim"; then
   gf_trim="yes"
 fi
-echo "Gluster API trim support      $gf_trim"
+print_config "Gluster API trim support" "$gf_trim"
 fi
 
 ##########################################
@@ -1713,7 +1718,7 @@ EOF
 if compile_exec_prog "" "" "s390_z196_facilities"; then
   s390_z196_facilities="yes"
 fi
-echo "s390_z196_facilities          $s390_z196_facilities"
+print_config "s390_z196_facilities" "$s390_z196_facilities"
 
 ##########################################
 # Check if we have required environment variables configured for libhdfs
@@ -1739,7 +1744,7 @@ if test "$libhdfs" = "yes" ; then
     FIO_HDFS_CPU="amd64"
   fi
 fi
-echo "HDFS engine                   $libhdfs"
+print_config "HDFS engine" "$libhdfs"
 
 ##########################################
 # Check whether we have MTD
@@ -1762,7 +1767,7 @@ EOF
 if compile_prog "" "" "mtd"; then
   mtd="yes"
 fi
-echo "MTD                           $mtd"
+print_config "MTD" "$mtd"
 
 ##########################################
 # Check whether we have libpmem
@@ -1782,7 +1787,7 @@ if compile_prog "" "-lpmem" "libpmem"; then
   libpmem="yes"
   LIBS="-lpmem $LIBS"
 fi
-echo "libpmem                       $libpmem"
+print_config "libpmem" "$libpmem"
 
 ##########################################
 # Check whether we have libpmemblk
@@ -1805,7 +1810,7 @@ EOF
     LIBS="-lpmemblk $LIBS"
   fi
 fi
-echo "libpmemblk                    $libpmemblk"
+print_config "libpmemblk" "$libpmemblk"
 
 # Choose the ioengines
 if test "$libpmem" = "yes" && test "$disable_pmem" = "no"; then
@@ -1817,11 +1822,11 @@ fi
 
 ##########################################
 # Report whether pmemblk engine is enabled
-echo "NVML pmemblk engine           $pmemblk"
+print_config "NVML pmemblk engine" "$pmemblk"
 
 ##########################################
 # Report whether dev-dax engine is enabled
-echo "NVML dev-dax engine           $devdax"
+print_config "NVML dev-dax engine" "$devdax"
 
 ##########################################
 # Check if we have lex/yacc available
@@ -1882,7 +1887,7 @@ fi
 fi
 fi
 
-echo "lex/yacc for arithmetic       $arith"
+print_config "lex/yacc for arithmetic" "$arith"
 
 ##########################################
 # Check whether we have setmntent/getmntent
@@ -1903,7 +1908,7 @@ EOF
 if compile_prog "" "" "getmntent"; then
   getmntent="yes"
 fi
-echo "getmntent                     $getmntent"
+print_config "getmntent" "$getmntent"
 
 ##########################################
 # Check whether we have getmntinfo
@@ -1928,7 +1933,7 @@ EOF
 if compile_prog "-Werror" "" "getmntinfo"; then
   getmntinfo="yes"
 fi
-echo "getmntinfo                    $getmntinfo"
+print_config "getmntinfo" "$getmntinfo"
 
 # getmntinfo(3) for NetBSD.
 if test "$getmntinfo_statvfs" != "yes" ; then
@@ -1946,7 +1951,7 @@ EOF
 # Skip the test if the one with statfs arg is detected.
 if test "$getmntinfo" != "yes" && compile_prog "-Werror" "" "getmntinfo_statvfs"; then
   getmntinfo_statvfs="yes"
-  echo "getmntinfo_statvfs            $getmntinfo_statvfs"
+  print_config "getmntinfo_statvfs" "$getmntinfo_statvfs"
 fi
 
 ##########################################
@@ -1981,7 +1986,7 @@ EOF
 if compile_prog "" "" "static_assert"; then
     static_assert="yes"
 fi
-echo "Static Assert                 $static_assert"
+print_config "Static Assert" "$static_assert"
 
 ##########################################
 # Check whether we have bool / stdbool.h
@@ -1999,7 +2004,7 @@ EOF
 if compile_prog "" "" "bool"; then
   have_bool="yes"
 fi
-echo "bool                          $have_bool"
+print_config "bool" "$have_bool"
 
 ##########################################
 # check march=armv8-a+crc+crypto
@@ -2022,7 +2027,7 @@ EOF
     CFLAGS="$CFLAGS -march=armv8-a+crc+crypto -DARCH_HAVE_CRC_CRYPTO"
   fi
 fi
-echo "march_armv8_a_crc_crypto      $march_armv8_a_crc_crypto"
+print_config "march_armv8_a_crc_crypto" "$march_armv8_a_crc_crypto"
 
 ##########################################
 # cuda probe
@@ -2040,7 +2045,7 @@ if test "$enable_cuda" = "yes" && compile_prog "" "-lcuda" "cuda"; then
   cuda="yes"
   LIBS="-lcuda $LIBS"
 fi
-echo "cuda                          $cuda"
+print_config "cuda" "$cuda"
 
 #############################################################################
 
-- 
2.9.3


