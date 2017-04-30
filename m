Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/6] make fio work on OpenBSD again
Date: Sun, 30 Apr 2017 20:35:05 +0300
Message-Id: <20170430173511.44593-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This series of patches fix compile time errors recent OpenBSD
versions have had. Now fio compiles and runs on recent versions,
at least on the latest one which is 6.1.

It still shows warnings on sprintf() and strxxx() variants,
but I didn't fix these. There are simply way too many sprintf()
calls, and strlxxx() variants which OpenBSD suggests to use have
their own problems (and that's why glibc doesn't have them,
although fio has its own strlcat() for some reason).

--
 # uname
 OpenBSD
 # uname -r
 6.1
 # gmake clean
 FIO_VERSION = fio-2.19-38-gc9f9
 # ./configure
 Operating system              OpenBSD
 CPU                           x86_64
 Big endian                    no
 Compiler                      gcc
 Cross compile                 no
 
 Static build                  no
 Wordsize                      64
 zlib                          yes
 Linux AIO support             no
 POSIX AIO support             no
 POSIX AIO support needs -lrt  no
 POSIX AIO fsync               no
 POSIX pshared support         no
 Solaris AIO support           no
 __sync_fetch_and_add          yes
 libverbs                      no
 rdmacm                        no
 Linux fallocate               no
 POSIX fadvise                 no
 POSIX fallocate               no
 sched_setaffinity(3 arg)      no
 sched_setaffinity(2 arg)      no
 clock_gettime                 yes
 CLOCK_MONOTONIC               yes
 CLOCK_MONOTONIC_RAW           no
 CLOCK_MONOTONIC_PRECISE       no
 clockid_t                     yes
 gettimeofday                  yes
 fdatasync                     yes
 sync_file_range               no
 EXT4 move extent              no
 Linux splice(2)               no
 GUASI                         no
 Fusion-io atomic engine       no
 libnuma                       no
 strsep                        yes
 strcasestr                    yes
 strlcat                       yes
 getopt_long_only()            yes
 inet_aton                     yes
 socklen_t                     yes
 __thread                      no
 RUSAGE_THREAD                 yes
 SCHED_IDLE                    no
 TCP_NODELAY                   yes
 Net engine window_size        yes
 TCP_MAXSEG                    yes
 RLIMIT_MEMLOCK                yes
 pwritev/preadv                yes
 pwritev2/preadv2              no
 IPv6 helpers                  yes
 Rados Block Device engine     no
 rbd blkin tracing             no
 setvbuf                       yes
 Gluster API engine            no
 s390_z196_facilities          no
 HDFS engine                   no
 MTD                           no
 libpmem                       no
 libpmemblk                    no
 NVML pmemblk engine           no
 NVML dev-dax engine           no
 lex/yacc for arithmetic       no
 getmntent                     no
 getmntinfo                    yes
 Static Assert                 no
 bool                          yes
 march_armv8_a_crc_crypto      no
 cuda                          no
 # gmake -j8 > /dev/null; echo $?
 FIO_VERSION = fio-2.19-38-gc9f9
 smalloc.o: In function `smalloc_strdup':
 /tmp/fio/smalloc.c:470: warning: warning: strcpy() is almost always misused, please use strlcpy()
 t/stest.o: In function `do_rand_allocs':
 t/stest.c:35: warning: warning: rand() may return deterministic values, is that what you want?
 ioengines.o: In function `load_ioengine':
 /tmp/fio/ioengines.c:140: warning: warning: strcpy() is almost always misused, please use strlcpy()
 crc/test.o: In function `fio_crctest':
 crc/test.c:420: warning: warning: sprintf() is often misused, please use snprintf()
 server.o: In function `fio_init_server_connection':
 /tmp/fio/server.c:2205: warning: warning: strcat() is almost always misused, please use strlcat()
 smalloc.o: In function `smalloc_strdup':
 /tmp/fio/smalloc.c:470: warning: warning: strcpy() is almost always misused, please use strlcpy()
 0
 # gmake test
 ./fio --minimal --thread --ioengine=null --runtime=1s --name=nulltest --rw=randrw --iodepth=2 --norandommap --random_generator=tausworthe64 --size=16T --name=verifynulltest --rw=write --verify=crc32c --verify_state_save=0 --size=100M
 3;fio-2.19-38-gc9f9;nulltest;0;0;638852;638852;159713;1000;0;0;0.000000;0.000000;0;544;0.601398;1.719636;1.000000%=0;5.000000%=0;10.000000%=0;20.000000%=0;30.000000%=0;40.000000%=0;50.000000%=1;60.000000%=1;70.000000%=1;80.000000%=1;90.000000%=1;95.000000%=1;99.000000%=1;99.500000%=2;99.900000%=17;99.950000%=19;99.990000%=26;0%=0;0%=0;0%=0;0;1013;1.193654;2.922642;0;0;0.000000%;0.000000;0.000000;641856;641856;160464;1000;0;0;0.000000;0.000000;0;85;0.596589;1.033093;1.000000%=0;5.000000%=0;10.000000%=0;20.000000%=0;30.000000%=0;40.000000%=0;50.000000%=1;60.000000%=1;70.000000%=1;80.000000%=1;90.000000%=1;95.000000%=1;99.000000%=1;99.500000%=2;99.900000%=16;99.950000%=19;99.990000%=24;0%=0;0%=0;0%=0;0;285;1.204999;1.704806;0;0;0.000000%;0.000000;0.000000;0.000000%;0.000000%;0;4;3;100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;99.41%;0.29%;0.08%;0.18%;0.03%;0.01%;0.01%;0.00%;0.01%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
 3;fio-2.19-38-gc9f9;verifynulltest;0;0;102400;1089361;272340;94;0;0;0.000000;0.000000;0;78;0.641992;1.166077;1.000000%=0;5.000000%=0;10.000000%=0;20.000000%=0;30.000000%=0;40.000000%=1;50.000000%=1;60.000000%=1;70.000000%=1;80.000000%=1;90.000000%=1;95.000000%=1;99.000000%=1;99.500000%=1;99.900000%=17;99.950000%=19;99.990000%=69;0%=0;0%=0;0%=0;1;101;1.277891;1.513550;0;0;0.000000%;0.000000;0.000000;102400;701369;175342;146;0;0;0.000000;0.000000;0;56;0.709258;1.032103;1.000000%=0;5.000000%=0;10.000000%=0;20.000000%=0;30.000000%=0;40.000000%=1;50.000000%=1;60.000000%=1;70.000000%=1;80.000000%=1;90.000000%=1;95.000000%=1;99.000000%=2;99.500000%=2;99.900000%=18;99.950000%=19;99.990000%=27;0%=0;0%=0;0%=0;1;563;2.078203;4.977238;0;0;0.000000%;0.000000;0.000000;0.000000%;0.000000%;0;6;825;100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;98.80%;0.97%;0.02%;0.15%;0.04%;0.01%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
 # ./fio --name=xxxxx --ioengine=sync --rw=rw --bs=32k --size=10m --unlink=1
 fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
 xxxxx: (g=0): rw=rw, bs=(R) 32.0KiB-32.0KiB, (W) 32.0KiB-32.0KiB, (T) 32.0KiB-32.0KiB, ioengine=sync, iodepth=1
 fio-2.19-38-gc9f9
 Starting 1 thread
 xxxxx: Laying out IO file (1 file / 10MiB)
 
 xxxxx: (groupid=0, jobs=1): err= 0: pid=949910584: Sun Apr 30 20:21:40 2017
    read: IOPS=1500, BW=46.9MiB/s (49.2MB/s)(5376KiB/112msec)
     clat (usec): min=3, max=2425, avg=179.98, stdev=385.61
      lat (usec): min=4, max=2428, avg=180.83, stdev=386.04
     clat percentiles (usec):
      |  1.00th=[    3],  5.00th=[    3], 10.00th=[    3], 20.00th=[    3],
      | 30.00th=[    4], 40.00th=[    4], 50.00th=[    4], 60.00th=[    4],
      | 70.00th=[    5], 80.00th=[  398], 90.00th=[  604], 95.00th=[ 1128],
      | 99.00th=[ 1576], 99.50th=[ 2416], 99.90th=[ 2416], 99.95th=[ 2416],
      | 99.99th=[ 2416]
   write: IOPS=1357, BW=42.4MiB/s (44.5MB/s)(4864KiB/112msec)
     clat (usec): min=3, max=64802, avg=524.16, stdev=5356.79
      lat (usec): min=4, max=64803, avg=525.77, stdev=5356.72
     clat percentiles (usec):
      |  1.00th=[    3],  5.00th=[    3], 10.00th=[    3], 20.00th=[    4],
      | 30.00th=[    4], 40.00th=[    4], 50.00th=[    4], 60.00th=[    5],
      | 70.00th=[    5], 80.00th=[   13], 90.00th=[   20], 95.00th=[   26],
      | 99.00th=[13248], 99.50th=[64768], 99.90th=[64768], 99.95th=[64768],
      | 99.99th=[64768]
     lat (usec) : 4=19.06%, 10=56.25%, 20=5.62%, 50=4.06%, 100=1.25%
     lat (usec) : 250=0.31%, 500=6.25%, 750=2.81%, 1000=0.62%
     lat (msec) : 2=2.81%, 4=0.31%, 20=0.31%, 100=0.31%
   cpu          : usr=0.00%, sys=0.00%, ctx=80, majf=0, minf=2
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      issued rwt: total=168,152,0, short=0,0,0, dropped=0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1
 
 Run status group 0 (all jobs):
    READ: bw=46.9MiB/s (49.2MB/s), 46.9MiB/s-46.9MiB/s (49.2MB/s-49.2MB/s), io=5376KiB (5505kB), run=112-112msec
   WRITE: bw=42.4MiB/s (44.5MB/s), 42.4MiB/s-42.4MiB/s (44.5MB/s-44.5MB/s), io=4864KiB (4981kB), run=112-112msec
--


Tomohiro Kusumi (6):
  Fix "cast from pointer to integer of different size" warning on
    OpenBSD
  Fix "C99 inline functions are not supported" warning on OpenBSD
  Fix "'RB_ROOT' undeclared" error on OpenBSD
  Turn off lex by default on OpenBSD
  Implement shm_attach_to_open_removed() for OpenBSD
  Drop XXX for cpu affinity for OpenBSD

 configure       |  3 ++-
 iolog.c         |  2 +-
 os/os-netbsd.h  |  2 +-
 os/os-openbsd.h | 29 ++++++++++++++++++++++++++---
 t/dedupe.c      |  2 +-
 5 files changed, 31 insertions(+), 7 deletions(-)

-- 
2.9.3


