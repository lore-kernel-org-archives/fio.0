Return-Path: <tbertaud@conforama.fr>
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: fio-f1480f9: AIX 6.1 build KO against gcc function overlap
Date: Wed, 30 Dec 2015 17:59:39 +0000
Message-ID: <VI1PR05MB13431A3381B0D79ED7118494B1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
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
 <56834ED5.40506@kernel.dk> <568356A8.1040904@kernel.dk>
 <VI1PR05MB13431E57B67F7322189A74E2B1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5684089C.7000201@kernel.dk>
 <56840B48.4040301@kernel.dk>,<56840B75.5070002@kernel.dk>
In-Reply-To: <56840B75.5070002@kernel.dk>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hello Jens;

I use fio-5f3bd0f.
No trace of USE_O if config-host.mak so is use your patch.
That's OK for the confgure with --enable-lex with the patch but have some i=
ssue with the make against yacc.
Seems an '-o' option again but for yacc this time.

I did the following step:
Dod configure:
   # grep USE_O config-host.mak
   grep: 0652-033 Cannot open config-host.mak.
   # ./configure --enable-lex
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
   #=20

No option USE_O  and file lex.yy.c generated.
   # grep USE_O config-host.mak
   #
   # ls -l lex.yy.c
   ls: 0653-341 The file lex.yy.c does not exist.
   #
   # rm config-host.mak
   #

Apply your patch:
   # /usr/linux/bin/patch < no-lex-o-v2.patch
   (Stripping trailing CRs from patch; use --binary to disable.)
   patching file configure
   #

Do configure:
   # ./configure --enable-lex
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
   lex/yacc for arithmetic       yes
   getmntent                     yes
   getmntinfo                    no
   Static Assert                 yes
   bool                          yes
   #

Follow your previous steps:
   # grep USE_O config-host.mak
   # ls -l  lex.yy.c
   ls: 0653-341 The file lex.yy.c does not exist.
   # gmake V=3D1 lex.yy.c
   FIO_VERSION =3D fio-2.3
   lex exp/expression-parser.l
   # ls -al lex.yy.c
   -rw-r--r--    1 root     staff         48081 Dec 30 18:48 lex.yy.c
   #

Try to do a full make:
   # gmake CC=3Dgcc
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
     YACC y.tab.c
   yacc: 1285-770 The -o flag is now the default in yacc.

    yacc: 1285-725 Reached end of file before %% Line 1
   Makefile:313: recipe for target 'y.tab.c' failed
   gmake: *** [y.tab.c] Error 1
   #

Regards,
Thierry

