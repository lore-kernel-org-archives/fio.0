Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33821 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934554AbdEXMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 24 May 2017 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dDUxP-00076E-6l
        for fio@vger.kernel.org; Wed, 24 May 2017 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170524120002.5B7C22C246B@kernel.dk>
Date: Wed, 24 May 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit af13d1e88158d3e37940648be139d7a46fe00431:

  Merge branch 'bugfix' of https://github.com/YukiKita/fio (2017-05-22 10:23:25 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c78e8496d438982157657711fbff8bedb621c1c9:

  log: ensure we don't truncate the final '\0' in the log (2017-05-23 21:51:59 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      Revert "Fixed json_print_value so that ending double quote of JSON string value will not disappear"
      log: make log_buf() return how much it wrote
      log: make the logging functions handle > 1024 bytes correctly
      log: ensure we don't truncate the final '\0' in the log

Tomohiro Kusumi (7):
      configure: Use single square brackets (POSIX)
      configure: Add print_config() for "<config>... <yes|no>" outputs
      Move {is,load}_blktrace() to a new header blktrace.h
      Drop struct thread_data dependency from os headers
      Drop circular dependency in log.c and lib/output_buffer.c
      Include sg headers in os/os-linux.h
      Move Linux/ppc64 specific cpu_online() to os/os-linux.h

 blktrace.c          |   1 +
 blktrace.h          |  23 ++++++++
 configure           | 159 +++++++++++++++++++++++++++-------------------------
 fio.h               |   8 ---
 init.c              |  10 +++-
 iolog.c             |   1 +
 json.c              |  10 +---
 lib/output_buffer.c |   8 +--
 lib/output_buffer.h |   2 +-
 log.c               | 117 ++++++++++++++++++++++++++++----------
 log.h               |  16 +++---
 os/os-linux.h       |  10 ++++
 os/os-windows.h     |   4 +-
 os/os.h             |  34 +----------
 stat.c              |   6 +-
 15 files changed, 231 insertions(+), 178 deletions(-)
 create mode 100644 blktrace.h

---

Diff of recent changes:

diff --git a/blktrace.c b/blktrace.c
index a3474cb..65b600f 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -10,6 +10,7 @@
 
 #include "flist.h"
 #include "fio.h"
+#include "blktrace.h"
 #include "blktrace_api.h"
 #include "oslib/linux-dev-lookup.h"
 
diff --git a/blktrace.h b/blktrace.h
new file mode 100644
index 0000000..8656a95
--- /dev/null
+++ b/blktrace.h
@@ -0,0 +1,23 @@
+#ifndef FIO_BLKTRACE_H
+#define FIO_BLKTRACE_H
+
+#ifdef FIO_HAVE_BLKTRACE
+
+int is_blktrace(const char *, int *);
+int load_blktrace(struct thread_data *, const char *, int);
+
+#else
+
+static inline int is_blktrace(const char *fname, int *need_swap)
+{
+	return 0;
+}
+
+static inline int load_blktrace(struct thread_data *td, const char *fname,
+				int need_swap)
+{
+	return 1;
+}
+
+#endif
+#endif
diff --git a/configure b/configure
index 0327578..2c6bfc8 100755
--- a/configure
+++ b/configure
@@ -37,6 +37,11 @@ fatal() {
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
@@ -475,11 +480,11 @@ EOF
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
@@ -490,7 +495,7 @@ if test "$build_static" = "yes" ; then
 else
   build_static="no"
 fi
-echo "Static build                  $build_static"
+print_config "Static build" "$build_static"
 
 ##########################################
 # check for wordsize
@@ -511,7 +516,7 @@ elif compile_prog "-DWORDSIZE=64" "" "wordsize"; then
 else
   fatal "Unknown wordsize"
 fi
-echo "Wordsize                      $wordsize"
+print_config "Wordsize" "$wordsize"
 
 ##########################################
 # zlib probe
@@ -532,7 +537,7 @@ if compile_prog "" "-lz" "zlib" ; then
   zlib=yes
   LIBS="-lz $LIBS"
 fi
-echo "zlib                          $zlib"
+print_config "zlib" "$zlib"
 
 ##########################################
 # linux-aio probe
@@ -559,7 +564,7 @@ EOF
     libaio=no
   fi
 fi
-echo "Linux AIO support             $libaio"
+print_config "Linux AIO support" "$libaio"
 
 ##########################################
 # posix aio probe
@@ -585,8 +590,8 @@ elif compile_prog "" "-lrt" "posixaio"; then
   posix_aio_lrt="yes"
   LIBS="-lrt $LIBS"
 fi
-echo "POSIX AIO support             $posix_aio"
-echo "POSIX AIO support needs -lrt  $posix_aio_lrt"
+print_config "POSIX AIO support" "$posix_aio"
+print_config "POSIX AIO support needs -lrt" "$posix_aio_lrt"
 
 ##########################################
 # posix aio fsync probe
@@ -608,7 +613,7 @@ EOF
     posix_aio_fsync=yes
   fi
 fi
-echo "POSIX AIO fsync               $posix_aio_fsync"
+print_config "POSIX AIO fsync" "$posix_aio_fsync"
 
 ##########################################
 # POSIX pshared attribute probe
@@ -638,7 +643,7 @@ EOF
 if compile_prog "" "$LIBS" "posix_pshared" ; then
   posix_pshared=yes
 fi
-echo "POSIX pshared support         $posix_pshared"
+print_config "POSIX pshared support" "$posix_pshared"
 
 ##########################################
 # solaris aio probe
@@ -660,7 +665,7 @@ if compile_prog "" "-laio" "solarisaio" ; then
   solaris_aio=yes
   LIBS="-laio $LIBS"
 fi
-echo "Solaris AIO support           $solaris_aio"
+print_config "Solaris AIO support" "$solaris_aio"
 
 ##########################################
 # __sync_fetch_and_add test
@@ -684,7 +689,7 @@ EOF
 if compile_prog "" "" "__sync_fetch_and_add()" ; then
     sfaa="yes"
 fi
-echo "__sync_fetch_and_add          $sfaa"
+print_config "__sync_fetch_and_add" "$sfaa"
 
 ##########################################
 # libverbs probe
@@ -704,7 +709,7 @@ if test "$disable_rdma" != "yes" && compile_prog "" "-libverbs" "libverbs" ; the
     libverbs="yes"
     LIBS="-libverbs $LIBS"
 fi
-echo "libverbs                      $libverbs"
+print_config "libverbs" "$libverbs"
 
 ##########################################
 # rdmacm probe
@@ -724,7 +729,7 @@ if test "$disable_rdma" != "yes" && compile_prog "" "-lrdmacm" "rdma"; then
     rdmacm="yes"
     LIBS="-lrdmacm $LIBS"
 fi
-echo "rdmacm                        $rdmacm"
+print_config "rdmacm" "$rdmacm"
 
 ##########################################
 # Linux fallocate probe
@@ -744,7 +749,7 @@ EOF
 if compile_prog "" "" "linux_fallocate"; then
     linux_fallocate="yes"
 fi
-echo "Linux fallocate               $linux_fallocate"
+print_config "Linux fallocate" "$linux_fallocate"
 
 ##########################################
 # POSIX fadvise probe
@@ -763,7 +768,7 @@ EOF
 if compile_prog "" "" "posix_fadvise"; then
     posix_fadvise="yes"
 fi
-echo "POSIX fadvise                 $posix_fadvise"
+print_config "POSIX fadvise" "$posix_fadvise"
 
 ##########################################
 # POSIX fallocate probe
@@ -782,7 +787,7 @@ EOF
 if compile_prog "" "" "posix_fallocate"; then
     posix_fallocate="yes"
 fi
-echo "POSIX fallocate               $posix_fallocate"
+print_config "POSIX fallocate" "$posix_fallocate"
 
 ##########################################
 # sched_set/getaffinity 2 or 3 argument test
@@ -815,8 +820,8 @@ EOF
     linux_2arg_affinity="yes"
   fi
 fi
-echo "sched_setaffinity(3 arg)      $linux_3arg_affinity"
-echo "sched_setaffinity(2 arg)      $linux_2arg_affinity"
+print_config "sched_setaffinity(3 arg)" "$linux_3arg_affinity"
+print_config "sched_setaffinity(2 arg)" "$linux_2arg_affinity"
 
 ##########################################
 # clock_gettime probe
@@ -837,7 +842,7 @@ elif compile_prog "" "-lrt" "clock_gettime"; then
     clock_gettime="yes"
     LIBS="-lrt $LIBS"
 fi
-echo "clock_gettime                 $clock_gettime"
+print_config "clock_gettime" "$clock_gettime"
 
 ##########################################
 # CLOCK_MONOTONIC probe
@@ -857,7 +862,7 @@ EOF
       clock_monotonic="yes"
   fi
 fi
-echo "CLOCK_MONOTONIC               $clock_monotonic"
+print_config "CLOCK_MONOTONIC" "$clock_monotonic"
 
 ##########################################
 # CLOCK_MONOTONIC_RAW probe
@@ -877,7 +882,7 @@ EOF
       clock_monotonic_raw="yes"
   fi
 fi
-echo "CLOCK_MONOTONIC_RAW           $clock_monotonic_raw"
+print_config "CLOCK_MONOTONIC_RAW" "$clock_monotonic_raw"
 
 ##########################################
 # CLOCK_MONOTONIC_PRECISE probe
@@ -897,7 +902,7 @@ EOF
       clock_monotonic_precise="yes"
   fi
 fi
-echo "CLOCK_MONOTONIC_PRECISE       $clock_monotonic_precise"
+print_config "CLOCK_MONOTONIC_PRECISE" "$clock_monotonic_precise"
 
 ##########################################
 # clockid_t probe
@@ -917,7 +922,7 @@ EOF
 if compile_prog "" "$LIBS" "clockid_t"; then
   clockid_t="yes"
 fi
-echo "clockid_t                     $clockid_t"
+print_config "clockid_t" "$clockid_t"
 
 ##########################################
 # gettimeofday() probe
@@ -936,7 +941,7 @@ EOF
 if compile_prog "" "" "gettimeofday"; then
     gettimeofday="yes"
 fi
-echo "gettimeofday                  $gettimeofday"
+print_config "gettimeofday" "$gettimeofday"
 
 ##########################################
 # fdatasync() probe
@@ -954,7 +959,7 @@ EOF
 if compile_prog "" "" "fdatasync"; then
   fdatasync="yes"
 fi
-echo "fdatasync                     $fdatasync"
+print_config "fdatasync" "$fdatasync"
 
 ##########################################
 # sync_file_range() probe
@@ -976,7 +981,7 @@ EOF
 if compile_prog "" "" "sync_file_range"; then
   sync_file_range="yes"
 fi
-echo "sync_file_range               $sync_file_range"
+print_config "sync_file_range" "$sync_file_range"
 
 ##########################################
 # ext4 move extent probe
@@ -1000,7 +1005,7 @@ elif test $targetos = "Linux" ; then
   # work. Takes a while to bubble back.
   ext4_me="yes"
 fi
-echo "EXT4 move extent              $ext4_me"
+print_config "EXT4 move extent" "$ext4_me"
 
 ##########################################
 # splice probe
@@ -1018,7 +1023,7 @@ EOF
 if compile_prog "" "" "linux splice"; then
   linux_splice="yes"
 fi
-echo "Linux splice(2)               $linux_splice"
+print_config "Linux splice(2)" "$linux_splice"
 
 ##########################################
 # GUASI probe
@@ -1037,7 +1042,7 @@ EOF
 if compile_prog "" "" "guasi"; then
   guasi="yes"
 fi
-echo "GUASI                         $guasi"
+print_config "GUASI" "$guasi"
 
 ##########################################
 # fusion-aw probe
@@ -1059,7 +1064,7 @@ if compile_prog "" "-L/usr/lib/fio -L/usr/lib/nvm -lnvm-primitives -ldl -lpthrea
   LIBS="-L/usr/lib/fio -L/usr/lib/nvm -lnvm-primitives -ldl -lpthread $LIBS"
   fusion_aw="yes"
 fi
-echo "Fusion-io atomic engine       $fusion_aw"
+print_config "Fusion-io atomic engine" "$fusion_aw"
 
 ##########################################
 # libnuma probe
@@ -1077,7 +1082,7 @@ if test "$disable_numa" != "yes"  && compile_prog "" "-lnuma" "libnuma"; then
   libnuma="yes"
   LIBS="-lnuma $LIBS"
 fi
-echo "libnuma                       $libnuma"
+print_config "libnuma" "$libnuma"
 
 ##########################################
 # libnuma 2.x version API, initialize with "no" only if $libnuma is set to "yes"
@@ -1094,7 +1099,7 @@ EOF
 if compile_prog "" "" "libnuma api"; then
   libnuma_v2="yes"
 fi
-echo "libnuma v2                    $libnuma_v2"
+print_config "libnuma v2" "$libnuma_v2"
 fi
 
 ##########################################
@@ -1114,7 +1119,7 @@ EOF
 if compile_prog "" "" "strsep"; then
   strsep="yes"
 fi
-echo "strsep                        $strsep"
+print_config "strsep" "$strsep"
 
 ##########################################
 # strcasestr() probe
@@ -1131,7 +1136,7 @@ EOF
 if compile_prog "" "" "strcasestr"; then
   strcasestr="yes"
 fi
-echo "strcasestr                    $strcasestr"
+print_config "strcasestr" "$strcasestr"
 
 ##########################################
 # strlcat() probe
@@ -1152,7 +1157,7 @@ EOF
 if compile_prog "" "" "strlcat"; then
   strlcat="yes"
 fi
-echo "strlcat                       $strlcat"
+print_config "strlcat" "$strlcat"
 
 ##########################################
 # getopt_long_only() probe
@@ -1172,7 +1177,7 @@ EOF
 if compile_prog "" "" "getopt_long_only"; then
   getopt_long_only="yes"
 fi
-echo "getopt_long_only()            $getopt_long_only"
+print_config "getopt_long_only()" "$getopt_long_only"
 
 ##########################################
 # inet_aton() probe
@@ -1192,7 +1197,7 @@ EOF
 if compile_prog "" "" "inet_aton"; then
   inet_aton="yes"
 fi
-echo "inet_aton                     $inet_aton"
+print_config "inet_aton" "$inet_aton"
 
 ##########################################
 # socklen_t probe
@@ -1210,7 +1215,7 @@ EOF
 if compile_prog "" "" "socklen_t"; then
   socklen_t="yes"
 fi
-echo "socklen_t                     $socklen_t"
+print_config "socklen_t" "$socklen_t"
 
 ##########################################
 # Whether or not __thread is supported for TLS
@@ -1228,7 +1233,7 @@ EOF
 if compile_prog "" "" "__thread"; then
   tls_thread="yes"
 fi
-echo "__thread                      $tls_thread"
+print_config "__thread" "$tls_thread"
 
 ##########################################
 # Check if we have required gtk/glib support for gfio
@@ -1278,7 +1283,7 @@ LDFLAGS=$ORG_LDFLAGS
 fi
 
 if test "$gfio_check" = "yes" ; then
-  echo "gtk 2.18 or higher            $gfio"
+  print_config "gtk 2.18 or higher" "$gfio"
 fi
 
 ##########################################
@@ -1299,7 +1304,7 @@ EOF
 if compile_prog "" "" "RUSAGE_THREAD"; then
   rusage_thread="yes"
 fi
-echo "RUSAGE_THREAD                 $rusage_thread"
+print_config "RUSAGE_THREAD" "$rusage_thread"
 
 ##########################################
 # Check whether we have SCHED_IDLE
@@ -1317,7 +1322,7 @@ EOF
 if compile_prog "" "" "SCHED_IDLE"; then
   sched_idle="yes"
 fi
-echo "SCHED_IDLE                    $sched_idle"
+print_config "SCHED_IDLE" "$sched_idle"
 
 ##########################################
 # Check whether we have TCP_NODELAY
@@ -1337,7 +1342,7 @@ EOF
 if compile_prog "" "" "TCP_NODELAY"; then
   tcp_nodelay="yes"
 fi
-echo "TCP_NODELAY                   $tcp_nodelay"
+print_config "TCP_NODELAY" "$tcp_nodelay"
 
 ##########################################
 # Check whether we have SO_SNDBUF
@@ -1358,7 +1363,7 @@ EOF
 if compile_prog "" "" "SO_SNDBUF"; then
   window_size="yes"
 fi
-echo "Net engine window_size        $window_size"
+print_config "Net engine window_size" "$window_size"
 
 ##########################################
 # Check whether we have TCP_MAXSEG
@@ -1380,7 +1385,7 @@ EOF
 if compile_prog "" "" "TCP_MAXSEG"; then
   mss="yes"
 fi
-echo "TCP_MAXSEG                    $mss"
+print_config "TCP_MAXSEG" "$mss"
 
 ##########################################
 # Check whether we have RLIMIT_MEMLOCK
@@ -1399,7 +1404,7 @@ EOF
 if compile_prog "" "" "RLIMIT_MEMLOCK"; then
   rlimit_memlock="yes"
 fi
-echo "RLIMIT_MEMLOCK                $rlimit_memlock"
+print_config "RLIMIT_MEMLOCK" "$rlimit_memlock"
 
 ##########################################
 # Check whether we have pwritev/preadv
@@ -1417,7 +1422,7 @@ EOF
 if compile_prog "" "" "pwritev"; then
   pwritev="yes"
 fi
-echo "pwritev/preadv                $pwritev"
+print_config "pwritev/preadv" "$pwritev"
 
 ##########################################
 # Check whether we have pwritev2/preadv2
@@ -1435,7 +1440,7 @@ EOF
 if compile_prog "" "" "pwritev2"; then
   pwritev2="yes"
 fi
-echo "pwritev2/preadv2              $pwritev2"
+print_config "pwritev2/preadv2" "$pwritev2"
 
 ##########################################
 # Check whether we have the required functions for ipv6
@@ -1464,7 +1469,7 @@ EOF
 if compile_prog "" "" "ipv6"; then
   ipv6="yes"
 fi
-echo "IPv6 helpers                  $ipv6"
+print_config "IPv6 helpers" "$ipv6"
 
 ##########################################
 # check for rbd
@@ -1491,7 +1496,7 @@ if test "$disable_rbd" != "yes"  && compile_prog "" "-lrbd -lrados" "rbd"; then
   LIBS="-lrbd -lrados $LIBS"
   rbd="yes"
 fi
-echo "Rados Block Device engine     $rbd"
+print_config "Rados Block Device engine" "$rbd"
 
 ##########################################
 # check for rbd_poll
@@ -1518,7 +1523,7 @@ EOF
 if compile_prog "" "-lrbd -lrados" "rbd"; then
   rbd_poll="yes"
 fi
-echo "rbd_poll                      $rbd_poll"
+print_config "rbd_poll" "$rbd_poll"
 fi
 
 ##########################################
@@ -1540,7 +1545,7 @@ EOF
 if compile_prog "" "-lrbd -lrados" "rbd"; then
   rbd_inval="yes"
 fi
-echo "rbd_invalidate_cache          $rbd_inval"
+print_config "rbd_invalidate_cache" "$rbd_inval"
 fi
 
 ##########################################
@@ -1571,7 +1576,7 @@ if test "$disable_rbd" != "yes" && test "$disable_rbd_blkin" != "yes" \
   LIBS="-lblkin $LIBS"
   rbd_blkin="yes"
 fi
-echo "rbd blkin tracing             $rbd_blkin"
+print_config "rbd blkin tracing" "$rbd_blkin"
 
 ##########################################
 # Check whether we have setvbuf
@@ -1591,7 +1596,7 @@ EOF
 if compile_prog "" "" "setvbuf"; then
   setvbuf="yes"
 fi
-echo "setvbuf                       $setvbuf"
+print_config "setvbuf" "$setvbuf"
 
 ##########################################
 # check for gfapi
@@ -1612,7 +1617,7 @@ if test "$disable_gfapi" != "yes"  && compile_prog "" "-lgfapi -lglusterfs" "gfa
   LIBS="-lgfapi -lglusterfs $LIBS"
   gfapi="yes"
 fi
- echo "Gluster API engine            $gfapi"
+print_config "Gluster API engine" "$gfapi"
 
 ##########################################
 # check for gfapi fadvise support, initialize with "no" only if $gfapi is set to "yes"
@@ -1632,7 +1637,7 @@ EOF
 if compile_prog "" "-lgfapi -lglusterfs" "gfapi"; then
   gf_fadvise="yes"
 fi
-echo "Gluster API use fadvise       $gf_fadvise"
+print_config "Gluster API use fadvise" "$gf_fadvise"
 fi
 
 ##########################################
@@ -1652,7 +1657,7 @@ EOF
 if compile_prog "" "-lgfapi -lglusterfs" "gf trim"; then
   gf_trim="yes"
 fi
-echo "Gluster API trim support      $gf_trim"
+print_config "Gluster API trim support" "$gf_trim"
 fi
 
 ##########################################
@@ -1682,11 +1687,11 @@ int main(int argc, char **argv)
 EOF
 if compile_prog "" "" "s390_z196_facilities"; then
   $TMPE
-  if [[ $? -eq 0 ]]; then
+  if [ $? -eq 0 ]; then
   	s390_z196_facilities="yes"
   fi
 fi
-echo "s390_z196_facilities          $s390_z196_facilities"
+print_config "s390_z196_facilities" "$s390_z196_facilities"
 
 ##########################################
 # Check if we have required environment variables configured for libhdfs
@@ -1712,7 +1717,7 @@ if test "$libhdfs" = "yes" ; then
     FIO_HDFS_CPU="amd64"
   fi
 fi
-echo "HDFS engine                   $libhdfs"
+print_config "HDFS engine" "$libhdfs"
 
 ##########################################
 # Check whether we have MTD
@@ -1735,7 +1740,7 @@ EOF
 if compile_prog "" "" "mtd"; then
   mtd="yes"
 fi
-echo "MTD                           $mtd"
+print_config "MTD" "$mtd"
 
 ##########################################
 # Check whether we have libpmem
@@ -1755,7 +1760,7 @@ if compile_prog "" "-lpmem" "libpmem"; then
   libpmem="yes"
   LIBS="-lpmem $LIBS"
 fi
-echo "libpmem                       $libpmem"
+print_config "libpmem" "$libpmem"
 
 ##########################################
 # Check whether we have libpmemblk
@@ -1778,7 +1783,7 @@ EOF
     LIBS="-lpmemblk $LIBS"
   fi
 fi
-echo "libpmemblk                    $libpmemblk"
+print_config "libpmemblk" "$libpmemblk"
 
 # Choose the ioengines
 if test "$libpmem" = "yes" && test "$disable_pmem" = "no"; then
@@ -1790,11 +1795,11 @@ fi
 
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
@@ -1855,7 +1860,7 @@ fi
 fi
 fi
 
-echo "lex/yacc for arithmetic       $arith"
+print_config "lex/yacc for arithmetic" "$arith"
 
 ##########################################
 # Check whether we have setmntent/getmntent
@@ -1876,7 +1881,7 @@ EOF
 if compile_prog "" "" "getmntent"; then
   getmntent="yes"
 fi
-echo "getmntent                     $getmntent"
+print_config "getmntent" "$getmntent"
 
 ##########################################
 # Check whether we have getmntinfo
@@ -1901,7 +1906,7 @@ EOF
 if compile_prog "-Werror" "" "getmntinfo"; then
   getmntinfo="yes"
 fi
-echo "getmntinfo                    $getmntinfo"
+print_config "getmntinfo" "$getmntinfo"
 
 # getmntinfo(3) for NetBSD.
 if test "$getmntinfo_statvfs" != "yes" ; then
@@ -1919,7 +1924,7 @@ EOF
 # Skip the test if the one with statfs arg is detected.
 if test "$getmntinfo" != "yes" && compile_prog "-Werror" "" "getmntinfo_statvfs"; then
   getmntinfo_statvfs="yes"
-  echo "getmntinfo_statvfs            $getmntinfo_statvfs"
+  print_config "getmntinfo_statvfs" "$getmntinfo_statvfs"
 fi
 
 ##########################################
@@ -1945,7 +1950,7 @@ EOF
 if compile_prog "" "" "static_assert"; then
     static_assert="yes"
 fi
-echo "Static Assert                 $static_assert"
+print_config "Static Assert" "$static_assert"
 
 ##########################################
 # Check whether we have bool / stdbool.h
@@ -1963,7 +1968,7 @@ EOF
 if compile_prog "" "" "bool"; then
   have_bool="yes"
 fi
-echo "bool                          $have_bool"
+print_config "bool" "$have_bool"
 
 ##########################################
 # check march=armv8-a+crc+crypto
@@ -1986,7 +1991,7 @@ EOF
     CFLAGS="$CFLAGS -march=armv8-a+crc+crypto -DARCH_HAVE_CRC_CRYPTO"
   fi
 fi
-echo "march_armv8_a_crc_crypto      $march_armv8_a_crc_crypto"
+print_config "march_armv8_a_crc_crypto" "$march_armv8_a_crc_crypto"
 
 ##########################################
 # cuda probe
@@ -2004,7 +2009,7 @@ if test "$enable_cuda" = "yes" && compile_prog "" "-lcuda" "cuda"; then
   cuda="yes"
   LIBS="-lcuda $LIBS"
 fi
-echo "cuda                          $cuda"
+print_config "cuda" "$cuda"
 
 #############################################################################
 
diff --git a/fio.h b/fio.h
index ed631bc..963cf03 100644
--- a/fio.h
+++ b/fio.h
@@ -640,14 +640,6 @@ extern void free_threads_shm(void);
  */
 extern void reset_all_stats(struct thread_data *);
 
-/*
- * blktrace support
- */
-#ifdef FIO_HAVE_BLKTRACE
-extern int is_blktrace(const char *, int *);
-extern int load_blktrace(struct thread_data *, const char *, int);
-#endif
-
 extern int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 		   enum fio_ddir ddir, uint64_t *bytes_issued, int from_verify,
 		   struct timeval *comp_time);
diff --git a/init.c b/init.c
index 52a5f03..d224bd6 100644
--- a/init.c
+++ b/init.c
@@ -1080,8 +1080,12 @@ static int setup_random_seeds(struct thread_data *td)
 	unsigned long seed;
 	unsigned int i;
 
-	if (!td->o.rand_repeatable && !fio_option_is_set(&td->o, rand_seed))
-		return init_random_state(td, td->rand_seeds, sizeof(td->rand_seeds));
+	if (!td->o.rand_repeatable && !fio_option_is_set(&td->o, rand_seed)) {
+		int ret = init_random_seeds(td->rand_seeds, sizeof(td->rand_seeds));
+		if (!ret)
+			td_fill_rand_seeds(td);
+		return ret;
+	}
 
 	seed = td->o.rand_seed;
 	for (i = 0; i < 4; i++)
@@ -1376,7 +1380,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	prev_group_jobs++;
 
 	if (setup_random_seeds(td)) {
-		td_verror(td, errno, "init_random_state");
+		td_verror(td, errno, "setup_random_seeds");
 		goto err;
 	}
 
diff --git a/iolog.c b/iolog.c
index 31d674c..01b82e8 100644
--- a/iolog.c
+++ b/iolog.c
@@ -19,6 +19,7 @@
 #include "trim.h"
 #include "filelock.h"
 #include "smalloc.h"
+#include "blktrace.h"
 
 static int iolog_flush(struct io_log *log);
 
diff --git a/json.c b/json.c
index 2160d29..e0227ec 100644
--- a/json.c
+++ b/json.c
@@ -340,13 +340,9 @@ static void json_print_array(struct json_array *array, struct buf_output *out)
 static void json_print_value(struct json_value *value, struct buf_output *out)
 {
 	switch (value->type) {
-	case JSON_TYPE_STRING: {
-			const char delimiter = '"';
-			buf_output_add(out, &delimiter, sizeof(delimiter));
-			buf_output_add(out, value->string, strlen(value->string));
-			buf_output_add(out, &delimiter, sizeof(delimiter));
-			break;
-		}
+	case JSON_TYPE_STRING:
+		log_buf(out, "\"%s\"", value->string);
+		break;
 	case JSON_TYPE_INTEGER:
 		log_buf(out, "%lld", value->integer_number);
 		break;
diff --git a/lib/output_buffer.c b/lib/output_buffer.c
index c1fdfc9..313536d 100644
--- a/lib/output_buffer.c
+++ b/lib/output_buffer.c
@@ -3,7 +3,6 @@
 #include <stdlib.h>
 
 #include "output_buffer.h"
-#include "../log.h"
 #include "../minmax.h"
 
 #define BUF_INC	1024
@@ -41,15 +40,10 @@ size_t buf_output_add(struct buf_output *out, const char *buf, size_t len)
 	return len;
 }
 
-size_t buf_output_flush(struct buf_output *out)
+void buf_output_clear(struct buf_output *out)
 {
-	size_t ret = 0;
-
 	if (out->buflen) {
-		ret = log_info_buf(out->buf, out->buflen);
 		memset(out->buf, 0, out->max_buflen);
 		out->buflen = 0;
 	}
-
-	return ret;
 }
diff --git a/lib/output_buffer.h b/lib/output_buffer.h
index 396002f..15ee005 100644
--- a/lib/output_buffer.h
+++ b/lib/output_buffer.h
@@ -12,6 +12,6 @@ struct buf_output {
 void buf_output_init(struct buf_output *out);
 void buf_output_free(struct buf_output *out);
 size_t buf_output_add(struct buf_output *out, const char *buf, size_t len);
-size_t buf_output_flush(struct buf_output *out);
+void buf_output_clear(struct buf_output *out);
 
 #endif
diff --git a/log.c b/log.c
index 4eb4af5..c7856eb 100644
--- a/log.c
+++ b/log.c
@@ -6,8 +6,16 @@
 
 #include "fio.h"
 
+#define LOG_START_SZ		512
+
 size_t log_info_buf(const char *buf, size_t len)
 {
+	/*
+	 * buf could be NULL (not just "").
+	 */
+	if (!buf)
+		return 0;
+
 	if (is_backend) {
 		size_t ret = fio_server_text_output(FIO_LOG_INFO, buf, len);
 		if (ret != -1)
@@ -23,38 +31,76 @@ size_t log_info_buf(const char *buf, size_t len)
 
 size_t log_valist(const char *str, va_list args)
 {
-	char buffer[1024];
-	size_t len;
+	size_t len, cur = LOG_START_SZ;
+	char *buffer;
+
+	do {
+		buffer = calloc(1, cur);
+
+		len = vsnprintf(buffer, cur, str, args);
+		if (len < cur)
+			break;
+
+		cur = len + 1;
+		free(buffer);
+	} while (1);
 
-	len = vsnprintf(buffer, sizeof(buffer), str, args);
+	cur = log_info_buf(buffer, len);
+	free(buffer);
 
-	return log_info_buf(buffer, min(len, sizeof(buffer) - 1));
+	return cur;
 }
 
 size_t log_info(const char *format, ...)
 {
-	char buffer[1024];
+	size_t len, cur = LOG_START_SZ;
+	char *buffer;
 	va_list args;
-	size_t len;
 
-	va_start(args, format);
-	len = vsnprintf(buffer, sizeof(buffer), format, args);
-	va_end(args);
+	do {
+		buffer = calloc(1, cur);
 
-	return log_info_buf(buffer, min(len, sizeof(buffer) - 1));
+		va_start(args, format);
+		len = vsnprintf(buffer, cur, format, args);
+		va_end(args);
+
+		if (len < cur)
+			break;
+
+		cur = len + 1;
+		free(buffer);
+	} while (1);
+
+	cur = log_info_buf(buffer, len);
+	free(buffer);
+
+	return cur;
 }
 
 size_t __log_buf(struct buf_output *buf, const char *format, ...)
 {
-	char buffer[1024];
+	size_t len, cur = LOG_START_SZ;
+	char *buffer;
 	va_list args;
-	size_t len;
 
-	va_start(args, format);
-	len = vsnprintf(buffer, sizeof(buffer), format, args);
-	va_end(args);
+	do {
+		buffer = calloc(1, cur);
+
+		va_start(args, format);
+		len = vsnprintf(buffer, cur, format, args);
+		va_end(args);
 
-	return buf_output_add(buf, buffer, min(len, sizeof(buffer) - 1));
+		if (len < cur)
+			break;
+
+		cur = len + 1;
+		free(buffer);
+	} while (1);
+
+	cur = buf_output_add(buf, buffer, len);
+	free(buffer);
+
+	return cur;
 }
 
 int log_info_flush(void)
@@ -67,33 +113,44 @@ int log_info_flush(void)
 
 size_t log_err(const char *format, ...)
 {
-	char buffer[1024];
+	size_t ret, len, cur = LOG_START_SZ;
+	char *buffer;
 	va_list args;
-	size_t len;
 
-	va_start(args, format);
-	len = vsnprintf(buffer, sizeof(buffer), format, args);
-	va_end(args);
-	len = min(len, sizeof(buffer) - 1);
+	do {
+		buffer = calloc(1, cur);
+
+		va_start(args, format);
+		len = vsnprintf(buffer, cur, format, args);
+		va_end(args);
+
+		if (len < cur)
+			break;
+
+		cur = len + 1;
+		free(buffer);
+	} while (1);
+
 
 	if (is_backend) {
-		size_t ret = fio_server_text_output(FIO_LOG_ERR, buffer, len);
+		ret = fio_server_text_output(FIO_LOG_ERR, buffer, len);
 		if (ret != -1)
-			return ret;
+			goto done;
 	}
 
 	if (log_syslog) {
 		syslog(LOG_INFO, "%s", buffer);
-		return len;
+		ret = len;
 	} else {
-		if (f_err != stderr) {
-			int fio_unused ret;
-
+		if (f_err != stderr)
 			ret = fwrite(buffer, len, 1, stderr);
-		}
 
-		return fwrite(buffer, len, 1, f_err);
+		ret = fwrite(buffer, len, 1, f_err);
 	}
+
+done:
+	free(buffer);
+	return ret;
 }
 
 const char *log_get_level(int level)
diff --git a/log.h b/log.h
index a39dea6..66546c4 100644
--- a/log.h
+++ b/log.h
@@ -16,13 +16,15 @@ extern size_t log_valist(const char *str, va_list);
 extern size_t log_info_buf(const char *buf, size_t len);
 extern int log_info_flush(void);
 
-#define log_buf(buf, format, args...)		\
-do {						\
-	if ((buf) != NULL)			\
-		__log_buf(buf, format, ##args);	\
-	else					\
-		log_info(format, ##args);	\
-} while (0)
+#define log_buf(buf, format, args...)			\
+({							\
+	size_t __ret;					\
+	if ((buf) != NULL)				\
+		__ret = __log_buf(buf, format, ##args);	\
+	else						\
+		__ret = log_info(format, ##args);	\
+	__ret;						\
+})
 
 enum {
 	FIO_LOG_DEBUG	= 1,
diff --git a/os/os-linux.h b/os/os-linux.h
index ba53590..008ce2d 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -16,6 +16,8 @@
 #include <linux/unistd.h>
 #include <linux/raw.h>
 #include <linux/major.h>
+#include <linux/fs.h>
+#include <scsi/sg.h>
 
 #include "./os-linux-syscall.h"
 #include "binject.h"
@@ -258,6 +260,14 @@ static inline int arch_cache_line_size(void)
 		return atoi(size);
 }
 
+#ifdef __powerpc64__
+#define FIO_HAVE_CPU_ONLINE_SYSCONF
+static inline unsigned int cpus_online(void)
+{
+        return sysconf(_SC_NPROCESSORS_CONF);
+}
+#endif
+
 static inline unsigned long long get_fs_free_size(const char *path)
 {
 	unsigned long long ret;
diff --git a/os/os-windows.h b/os/os-windows.h
index 0c8c42d..36b421e 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -116,7 +116,6 @@ int nanosleep(const struct timespec *rqtp, struct timespec *rmtp);
 ssize_t pread(int fildes, void *buf, size_t nbyte, off_t offset);
 ssize_t pwrite(int fildes, const void *buf, size_t nbyte,
 		off_t offset);
-extern void td_fill_rand_seeds(struct thread_data *);
 
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 {
@@ -239,7 +238,7 @@ static inline int fio_cpuset_exit(os_cpu_mask_t *mask)
 	return 0;
 }
 
-static inline int init_random_state(struct thread_data *td, unsigned long *rand_seeds, int size)
+static inline int init_random_seeds(unsigned long *rand_seeds, int size)
 {
 	HCRYPTPROV hCryptProv;
 
@@ -258,7 +257,6 @@ static inline int init_random_state(struct thread_data *td, unsigned long *rand_
 	}
 
 	CryptReleaseContext(hCryptProv, 0);
-	td_fill_rand_seeds(td);
 	return 0;
 }
 
diff --git a/os/os.h b/os/os.h
index 5e3c813..1d400c8 100644
--- a/os/os.h
+++ b/os/os.h
@@ -60,11 +60,6 @@ typedef struct aiocb os_aiocb_t;
 #endif
 #endif
 
-#ifdef FIO_HAVE_SGIO
-#include <linux/fs.h>
-#include <scsi/sg.h>
-#endif
-
 #ifndef CONFIG_STRSEP
 #include "../oslib/strsep.h"
 #endif
@@ -253,19 +248,6 @@ static inline uint64_t fio_swap64(uint64_t val)
 	__cpu_to_le64(val);			\
 })
 
-#ifndef FIO_HAVE_BLKTRACE
-static inline int is_blktrace(const char *fname, int *need_swap)
-{
-	return 0;
-}
-struct thread_data;
-static inline int load_blktrace(struct thread_data *td, const char *fname,
-				int need_swap)
-{
-	return 1;
-}
-#endif
-
 #define FIO_DEF_CL_SIZE		128
 
 static inline int os_cache_line_size(void)
@@ -316,12 +298,7 @@ static inline long os_random_long(os_random_state_t *rs)
 #endif
 
 #ifdef FIO_USE_GENERIC_INIT_RANDOM_STATE
-extern void td_fill_rand_seeds(struct thread_data *td);
-/*
- * Initialize the various random states we need (random io, block size ranges,
- * read/write mix, etc).
- */
-static inline int init_random_state(struct thread_data *td, unsigned long *rand_seeds, int size)
+static inline int init_random_seeds(unsigned long *rand_seeds, int size)
 {
 	int fd;
 
@@ -336,7 +313,6 @@ static inline int init_random_state(struct thread_data *td, unsigned long *rand_
 	}
 
 	close(fd);
-	td_fill_rand_seeds(td);
 	return 0;
 }
 #endif
@@ -348,14 +324,6 @@ static inline unsigned long long get_fs_free_size(const char *path)
 }
 #endif
 
-#ifdef __powerpc64__
-#define FIO_HAVE_CPU_ONLINE_SYSCONF
-static inline unsigned int cpus_online(void)
-{
-        return sysconf(_SC_NPROCESSORS_CONF);
-}
-#endif
-
 #ifndef FIO_HAVE_CPU_ONLINE_SYSCONF
 static inline unsigned int cpus_online(void)
 {
diff --git a/stat.c b/stat.c
index 5b48413..1f124a8 100644
--- a/stat.c
+++ b/stat.c
@@ -1825,8 +1825,10 @@ void __show_run_stats(void)
 	}
 
 	for (i = 0; i < FIO_OUTPUT_NR; i++) {
-		buf_output_flush(&output[i]);
-		buf_output_free(&output[i]);
+		struct buf_output *out = &output[i];
+		log_info_buf(out->buf, out->buflen);
+		buf_output_clear(out);
+		buf_output_free(out);
 	}
 
 	log_info_flush();
