Return-Path: <tbertaud@conforama.fr>
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: fio-f1480f9: AIX 6.1 build KO against gcc function overlap
Date: Tue, 29 Dec 2015 00:30:40 +0000
Message-ID: <VI1PR05MB1343AD6DF9BD33ED9A3C0C88B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB1343197BD54DC24EA6A2AF65B1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681C3ED.2000708@kernel.dk>
 <VI1PR05MB1343C677E9AD2577F510184DB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681C9E2.3040006@kernel.dk>
 <VI1PR05MB13430153F93BD34C56DFB4CAB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>,<5681D0A8.8030507@kernel.dk>
In-Reply-To: <5681D0A8.8030507@kernel.dk>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens,

>Looks like I screwed up that part in the lib/oslib move. Committed a
>fix, hopefully that should resolve all of them.
I tested against fio-f87cc56 but i have now this issue:
------
ld: 0711-317 ERROR: Undefined symbol: .strcasestr
ld: 0711-345 Use the -bloadmap or -bnoquiet option to obtain more informati=
on.
collect2: error: ld returned 8 exit status
Makefile:373: recipe for target 't/fio-genzipf' failed
gmake: *** [t/fio-genzipf] Error 1
-----

Below the full output:


# ./configure --disable-lex
Operating system              AIX
CPU                           ppc
Big endian                    yes
Compiler                      gcc
Cross compile                 no

Static build                  no
Wordsize                      32
zlib                          yes
Linux AIO support             no
POSIX AIO support             yes
POSIX AIO support needs -lrt  no
POSIX AIO fsync               yes
Solaris AIO support           no
__sync_fetch_and_add          no
libverbs                      no
rdmacm                        yes
Linux fallocate               no
POSIX fadvise                 yes
POSIX fallocate               yes
sched_setaffinity(3 arg)      no
sched_setaffinity(2 arg)      no
clock_gettime                 yes
CLOCK_MONOTONIC               yes
CLOCK_MONOTONIC_RAW           no
CLOCK_MONOTONIC_PRECISE       no
gettimeofday                  yes
fdatasync                     yes
sync_file_range               no
EXT4 move extent              no
Linux splice(2)               no
GUASI                         no
Fusion-io atomic engine       no
libnuma                       no
strsep                        yes
strcasestr                    no
strlcat                       no
getopt_long_only()            no
inet_aton                     yes
socklen_t                     yes
__thread                      yes
RUSAGE_THREAD                 yes
SCHED_IDLE                    no
TCP_NODELAY                   yes
Net engine window_size        yes
TCP_MAXSEG                    yes
RLIMIT_MEMLOCK                no
pwritev/preadv                yes
IPv6 helpers                  yes
Rados Block Device engine     no
setvbuf                       yes
Gluster API engine            no
s390_z196_facilities          no
HDFS engine                   no
MTD                           no
lex/yacc for arithmetic       no
getmntent                     yes
getmntinfo                    no
Static Assert                 yes
bool                          yes
# gmake CC=3Dgcc
FIO_VERSION =3D fio-2.3
    CC crc/crc64.o
    CC crc/md5.o
    CC crc/fnv.o
    CC crc/sha256.o
    CC crc/test.o
    CC crc/xxhash.o
    CC crc/crc32c-intel.o
    CC crc/murmur3.o
    CC crc/crc32.o
    CC crc/crc32c.o
    CC crc/sha1.o
    CC crc/crc7.o
    CC crc/sha512.o
    CC crc/crc16.o
    CC lib/gauss.o
    CC lib/prio_tree.o
    CC lib/axmap.o
    CC lib/flist_sort.o
    CC lib/hweight.o
    CC lib/zipf.o
    CC lib/getrusage.o
    CC lib/output_buffer.o
    CC lib/memalign.o
    CC lib/lfsr.o
    CC lib/bloom.o
    CC lib/strntol.o
    CC lib/num2str.o
    CC lib/mountcheck.o
    CC lib/pattern.o
    CC lib/ieee754.o
    CC lib/rbtree.o
    CC lib/rand.o
    CC gettime.o
    CC ioengines.o
    CC init.o
    CC stat.o
    CC log.o
    CC time.o
    CC filesetup.o
    CC eta.o
    CC verify.o
    CC memory.o
    CC io_u.o
    CC parse.o
    CC mutex.o
    CC options.o
    CC smalloc.o
    CC filehash.o
    CC profile.o
    CC debug.o
    CC engines/cpu.o
    CC engines/mmap.o
    CC engines/sync.o
    CC engines/null.o
    CC engines/net.o
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
    CC engines/posixaio.o
    CC oslib/strcasestr.o
    CC oslib/strlcat.o
    CC oslib/getopt_long.o
    CC fio.o
  LINK fio
    CC t/log.o
    CC t/genzipf.o
  LINK t/fio-genzipf
ld: 0711-317 ERROR: Undefined symbol: .strcasestr
ld: 0711-345 Use the -bloadmap or -bnoquiet option to obtain more informati=
on.
collect2: error: ld returned 8 exit status
Makefile:373: recipe for target 't/fio-genzipf' failed
gmake: *** [t/fio-genzipf] Error 1
#


Regards,
Thierry=

