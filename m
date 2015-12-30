Return-Path: <tbertaud@conforama.fr>
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: fio-f1480f9: AIX 6.1 build KO against gcc function overlap
Date: Wed, 30 Dec 2015 08:36:46 +0000
Message-ID: <VI1PR05MB13431E57B67F7322189A74E2B1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB1343197BD54DC24EA6A2AF65B1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681C3ED.2000708@kernel.dk>
 <VI1PR05MB1343C677E9AD2577F510184DB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681C9E2.3040006@kernel.dk>
 <VI1PR05MB13430153F93BD34C56DFB4CAB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681D0A8.8030507@kernel.dk>
 <VI1PR05MB1343AD6DF9BD33ED9A3C0C88B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681D65A.10200@kernel.dk>
 <VI1PR05MB134330236BC82EF62F5219C0B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5682A81A.8010008@kernel.dk>
 <VI1PR05MB134366A0B6A8833617A18D4FB1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <VI1PR05MB1343AFE71D15E197D549461FB1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <56834ED5.40506@kernel.dk>,<568356A8.1040904@kernel.dk>
In-Reply-To: <568356A8.1040904@kernel.dk>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens,

>Unless I botched it, it should disable lex on AIX now, unless you
>explicitly attempt to enable with --enable-lex.

I built against fio-de26b82 and now lex its disable by default. Tha'ts OK  =
(cf full output below).

Concerning error with  --enable-lex, i think is due that option '-o' is not=
 valid so lex doon't generate the file leyx.yy.c =3D> don't find it after.
---
MTD                           no
0: Warning: 1285-300 The o flag is not valid.
0: Error: 1285-331 Cannot read input file lex.yy.c
lex/yacc for arithmetic       yes
---
If i read configure:
    +1505
    +1506  # Check if lex fails using -o
    +1507  if test "$arith" =3D "yes" ; then
    +1508  $LEX -o lex.yy.c exp/expression-parser.l 2> /dev/null
    +1509  if test "$?" =3D "0" ; then
    +1510    lex_use_o=3D"yes"
    +1511  else
    +1512    lex_use_o=3D"no"
    +1513  fi
    +1514  fi
    +1515
    +1516  echo "lex/yacc for arithmetic       $arith"

Could you update test condition, if OS is AIX to use "less exp/expression-p=
arser.l" and other case "-o lex.yy.c exp/expression-parser.l"=20
   # lex exp/expression-parser.l; echo $?;ls -l lex.yy.c
   0
   -rw-r--r--    1 root     staff         48081 Dec 30 09:34 lex.yy.c
   #

Used bash in debug mode via PS4.
+(./configure:1507): main(): test yes =3D yes
+(./configure:1508): main(): /usr/bin/lex -o lex.yy.c exp/expression-parser=
.l
0: Warning: 1285-300 The o flag is not valid.
0: Error: 1285-331 Cannot read input file lex.yy.c
+(./configure:1509): main(): test 1 =3D 0
+(./configure:1512): main(): lex_use_o=3Dno
+(./configure:1516): main(): echo 'lex/yacc for arithmetic       yes'
lex/yacc for arithmetic       yes
Output with lex disable by default:
# ./configure --help
--prefix=3D              Use this directory as installation prefix
--cpu=3D                 Specify target CPU if auto-detect fails
--cc=3D                  Specify compiler to use
--extra-cflags=3D        Specify extra CFLAGS to pass to compiler
--build-32bit-win      Enable 32-bit build on Windows
--build-static         Build a static fio
--esx                  Configure build options for esx
--enable-gfio          Enable building of gtk gfio
--disable-numa         Disable libnuma even if found
--disable-gfapi        Disable gfapi
--enable-libhdfs       Enable hdfs support
--disable-lex          Disable use of lex/yacc for math
--enable-lex           Enable use of lex/yacc for math
--disable-shm          Disable SHM support
--disable-optimizations Don't enable compiler optimizations
# ./configure
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
    CC t/dedupe.o
    CC t/debug.o
  LINK t/fio-dedupe
    CC t/stest.o
  LINK t/stest
    CC t/ieee754.o
  LINK t/ieee754
    CC t/axmap.o
  LINK t/axmap
    CC t/lfsr-test.o
  LINK t/lfsr-test
#
# ./fio -v
fio-2.3
#

Regards,
Thierry=

