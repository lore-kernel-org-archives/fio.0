Return-Path: <tbertaud@conforama.fr>
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: fio-f1480f9: AIX 6.1 build KO against gcc function overlap
Date: Tue, 29 Dec 2015 21:10:13 +0000
Message-ID: <VI1PR05MB1343AFE71D15E197D549461FB1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB1343197BD54DC24EA6A2AF65B1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681C3ED.2000708@kernel.dk>
 <VI1PR05MB1343C677E9AD2577F510184DB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681C9E2.3040006@kernel.dk>
 <VI1PR05MB13430153F93BD34C56DFB4CAB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681D0A8.8030507@kernel.dk>
 <VI1PR05MB1343AD6DF9BD33ED9A3C0C88B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681D65A.10200@kernel.dk>
 <VI1PR05MB134330236BC82EF62F5219C0B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>,<5682A81A.8010008@kernel.dk>,<VI1PR05MB134366A0B6A8833617A18D4FB1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
In-Reply-To: <VI1PR05MB134366A0B6A8833617A18D4FB1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hello Jens,

>>Hmm, I'll see if I can add a check in configure for whether or not lex
>>requires -o to specify an output file. For now, just use --disable-lex.
>OK, i continue to just use: --disable-yes.
>If you add a check in configure later, i'll try a ./configure to confirm y=
ou that's fine in AIX.

I build against fio-63bda37 (configure: if lex requires/fails with -o for o=
utput)
With configure, i have this:
____
MTD                           no
0: Warning: 1285-300 The o flag is not valid.
0: Error: 1285-331 Cannot read input file lex.yy.c
lex/yacc for arithmetic       yes
____

and the make fail with:
----
YACC y.tab.c
yacc: 1285-770 The -o flag is now the default in yacc.

 yacc: 1285-725 Reached end of file before %% Line 1
Makefile:313: recipe for target 'y.tab.c' failed
gmake: *** [y.tab.c] Error 1
----

Below the full output:
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
0: Warning: 1285-300 The o flag is not valid.
0: Error: 1285-331 Cannot read input file lex.yy.c
lex/yacc for arithmetic       yes
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
   LEX lex.yy.c
  YACC y.tab.c
yacc: 1285-770 The -o flag is now the default in yacc.

 yacc: 1285-725 Reached end of file before %% Line 1
Makefile:313: recipe for target 'y.tab.c' failed
gmake: *** [y.tab.c] Error 1
#


Regards,
Thierry=

