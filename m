Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr720094.outbound.protection.outlook.com ([40.107.72.94]:18688
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728177AbfJQUgX (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 17 Oct 2019 16:36:23 -0400
From: Astolfo Rueda <astolfor@microsoft.com>
Subject: build issue
Date: Thu, 17 Oct 2019 20:34:41 +0000
Message-ID: <BY5PR21MB14922563C2166CDB9268784FDF6D0@BY5PR21MB1492.namprd21.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello I am trying to build FIO and I get these errors.
The server is windows 10, with latest Cygwin.

What am I doing wrong?

Thanks
Astolfo


/tmp/ccQfIUjv.s: Assembler messages:
/tmp/ccQfIUjv.s:1188: Error: invalid register for .seh_savexmm
make: *** [Makefile:376: filehash.o] Error 1
make: *** Waiting for unfinished jobs....
/tmp/ccZfFBQo.s: Assembler messages:
/tmp/ccZfFBQo.s:3812: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3814: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3816: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3818: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3820: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3822: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3824: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3826: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3828: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3830: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3832: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3834: Error: invalid register for .seh_savexmm
make: *** [Makefile:379: options.o] Error 1


full output
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
$ make clean && make -j
Running configure ...
FIO_VERSION =3D fio-3.16
Forcing some known good options on Windows
Operating system              CYGWIN_NT-10.0
CPU                           x86_64
Big endian                    no
Target Windows version        7
Compiler                      x86_64-w64-mingw32-gcc
Cross compile                 no

Static build                  yes
Wordsize                      32
zlib                          yes
Linux AIO support             no
Linux AIO over io_uring       no
POSIX AIO support             no
POSIX AIO support needs -lrt  no
POSIX AIO fsync               no
POSIX pshared support         no
Solaris AIO support           no
__sync_fetch_and_add          yes
__sync_synchronize            yes
__sync_val_compare_and_swap   yes
libverbs                      no
rdmacm                        no
asprintf()                    yes
vasprintf()                   yes
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
libnuma                       no
strsep                        no
strcasestr                    no
strlcat                       no
getopt_long_only()            yes
inet_aton                     no
socklen_t                     yes
__thread                      yes
RUSAGE_THREAD                 yes
SCHED_IDLE                    yes
TCP_NODELAY                   yes
Net engine window_size        no
TCP_MAXSEG                    no
RLIMIT_MEMLOCK                no
pwritev/preadv                no
pwritev2/preadv2              no
IPv6 helpers                  yes
http engine                   no
Rados engine                  no
Rados Block Device engine     no
setvbuf                       yes
Gluster API engine            no
s390_z196_facilities          no
HDFS engine                   no
MTD                           no
libpmem                       no
libpmemblk                    no
PMDK pmemblk engine           no
PMDK dev-dax engine           no
PMDK libpmem engine           no
DDN's Infinite Memory Engine  no
iscsi engine                  no
NBD engine                    no
lex/yacc for arithmetic       no
getmntent                     no
getmntinfo                    no
Static Assert                 yes
bool                          yes
strndup                       no
Valgrind headers              no
Zoned block device support    no
march_armv8_a_crc_crypto      no
cuda                          no
mkdir(a, b)                   no
Build march=3Dnative            yes
CUnit                         no
__kernel_rwf_t                no
-Wimplicit-fallthrough        yes
MADV_HUGEPAGE                 no
gettid                        no
TCMalloc support              no
    CC crc/crc16.o
    CC crc/crc32.o
    CC crc/crc32c-arm64.o
    CC crc/crc32c-intel.o
    CC crc/crc32c.o
    CC crc/crc64.o
    CC crc/crc7.o
    CC crc/fnv.o
    CC crc/md5.o
    CC crc/murmur3.o
    CC crc/sha1.o
    CC crc/sha256.o
    CC crc/sha3.o
    CC crc/xxhash.o
    CC crc/sha512.o
    CC crc/test.o
    CC lib/axmap.o
    CC lib/bloom.o
    CC lib/flist_sort.o
    CC lib/gauss.o
    CC lib/ieee754.o
    CC lib/memalign.o
    CC lib/getrusage.o
    CC lib/hweight.o
    CC lib/lfsr.o
    CC lib/memcpy.o
    CC lib/mountcheck.o
    CC lib/num2str.o
    CC lib/output_buffer.o
    CC lib/pattern.o
    CC lib/prio_tree.o
    CC lib/rand.o
    CC lib/strntol.o
    CC lib/rbtree.o
    CC lib/zipf.o
    CC gettime.o
    CC ioengines.o
    CC init.o
    CC log.o
    CC stat.o
    CC time.o
    CC filesetup.o
    CC verify.o
    CC eta.o
    CC parse.o
    CC io_u.o
    CC memory.o
    CC fio_sem.o
    CC rwlock.o
    CC pshared.o
    CC options.o
    CC filehash.o
    CC debug.o
    CC smalloc.o
    CC profile.o
    CC engines/cpu.o
    CC engines/mmap.o
    CC engines/sync.o
    CC engines/null.o
    CC engines/net.o
    CC engines/ftruncate.o
    CC engines/filecreate.o
    CC server.o
    CC client.o
    CC iolog.o
    CC backend.o
    CC libfio.o
    CC flow.o
    CC cconv.o
    CC gettime-thread.o
    CC helpers.o
    CC json.o
    CC idletime.o
    CC td_error.o
    CC profiles/tiobench.o
    CC profiles/act.o
    CC io_u_queue.o
    CC filelock.o
    CC workqueue.o
    CC rate-submit.o
    CC helper_thread.o
    CC steadystate.o
    CC optgroup.o
    CC zone-dist.o
    CC engines/windowsaio.o
    CC oslib/asprintf.o
    CC oslib/strsep.o
    CC oslib/strcasestr.o
    CC oslib/strlcat.o
    CC fio.o
    CC oslib/strndup.o
    CC os/windows/posix.o
    CC oslib/inet_aton.o
/tmp/ccQfIUjv.s: Assembler messages:
/tmp/ccQfIUjv.s:1188: Error: invalid register for .seh_savexmm
make: *** [Makefile:376: filehash.o] Error 1
make: *** Waiting for unfinished jobs....
/tmp/ccZfFBQo.s: Assembler messages:
/tmp/ccZfFBQo.s:3812: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3814: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3816: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3818: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3820: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3822: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3824: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3826: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3828: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3830: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3832: Error: invalid register for .seh_savexmm
/tmp/ccZfFBQo.s:3834: Error: invalid register for .seh_savexmm
make: *** [Makefile:379: options.o] Error 1


