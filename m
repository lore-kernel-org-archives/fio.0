Return-Path: <axboe@kernel.dk>
Message-ID: <545263A6.1010705@kernel.dk>
Date: Thu, 30 Oct 2014 10:13:26 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: yacc/flex/bison (?) regression since 2.1.13 (solaris 11 x86_64)
 - ../exp/*
References: <9BFC2684-B327-440D-8051-5528AEDFA530@coraid.com>
In-Reply-To: <9BFC2684-B327-440D-8051-5528AEDFA530@coraid.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: "Robin P. Blanchard" <robin@coraid.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, stephen Cameron <stephenmcameron@gmail.com>
List-ID: <fio@vger.kernel.org>

On 10/30/2014 09:40 AM, Robin P. Blanchard wrote:
> Hi there.
>=20
> The introduction of ../exp/* seems to have broken compilation on Solaris =
11. Please let me know how I can help work through this.
>=20
> Thanks in advance!
>=20
>=20
> # pkg info entire |egrep 'Version|FMRI'
>        Version: 0.5.11 (Oracle Solaris 11.2.3.5.0)
>           FMRI: pkg://solaris/entire@0.5.11,5.11-0.175.2.3.0.5.0:20141019=
T181440Z
>=20
>=20
> ** GIT
>=20
> # make
> Makefile:14: config-host.mak: No such file or directory
> FIO_VERSION =3D fio-2.1.13-109-ga1f8
> Running configure for you...
> Operating system              SunOS
> CPU                           x86_64
> Big endian                    no
> Compiler                      gcc
> Cross compile                 no
>=20
> Wordsize                      32
> zlib                          yes
> Linux AIO support             no
> POSIX AIO support             yes
> POSIX AIO support needs -lrt  no
> POSIX AIO fsync               yes
> Solaris AIO support           yes
> __sync_fetch_and_add          yes
> libverbs                      yes
> rdmacm                        yes
> Linux fallocate               no
> POSIX fadvise                 yes
> POSIX fallocate               yes
> sched_setaffinity(3 arg)      no
> sched_setaffinity(2 arg)      no
> clock_gettime                 yes
> CLOCK_MONOTONIC               yes
> CLOCK_MONOTONIC_PRECISE       no
> gettimeofday                  yes
> fdatasync                     yes
> sync_file_range               no
> EXT4 move extent              no
> Linux splice(2)               no
> GUASI                         no
> Fusion-io atomic engine       no
> libnuma                       no
> strsep                        yes
> strcasestr                    yes
> getopt_long_only()            yes
> inet_aton                     yes
> socklen_t                     yes
> __thread                      yes
> RUSAGE_THREAD                 no
> SCHED_IDLE                    no
> TCP_NODELAY                   yes
> Net engine window_size        yes
> TCP_MAXSEG                    yes
> RLIMIT_MEMLOCK                no
> pwritev/preadv                no
> IPv6 helpers                  yes
> Rados Block Device engine     no
> setvbuf                       yes
> Gluster API engine            no
> s390_z196_facilities          no
> HDFS engine                   no
> lex/yacc for arithmetic       yes
>     CC gettime.o
>     CC ioengines.o
>     CC init.o
>     CC stat.o
>     CC log.o
>     CC time.o
>     CC filesetup.o
>     CC eta.o
>     CC verify.o
>     CC memory.o
>     CC io_u.o
>    LEX lex.yy.c
> "exp/expression-parser.l":line 166: Warning: Non-portable Character Class
>   YACC y.tab.c
>     CC lex.yy.o
> exp/expression-parser.l:43:37: error: conflicting types for =EF=BF=BDyyun=
put=EF=BF=BD
> lex.yy.c:31:7: note: previous declaration of =EF=BF=BDyyunput=EF=BF=BD wa=
s here
> exp/expression-parser.l:44:46: error: macro "input" passed 1 arguments, b=
ut takes just 0
> exp/expression-parser.l: In function =EF=BF=BDyylex=EF=BF=BD:
> exp/expression-parser.l:61:1: warning: label =EF=BF=BDyyfussy=EF=BF=BD de=
fined but not used
> exp/expression-parser.l:54:22: warning: unused variable =EF=BF=BDyyprevio=
us=EF=BF=BD
> exp/expression-parser.l: At top level:
> exp/expression-parser.l:297:1: warning: missing braces around initializer
> exp/expression-parser.l:297:1: warning: (near initialization for =EF=BF=
=BDyycrank[0]=EF=BF=BD)
> exp/expression-parser.l:376:1: warning: missing braces around initializer
> exp/expression-parser.l:376:1: warning: (near initialization for =EF=BF=
=BDyysvec[0]=EF=BF=BD)
> exp/expression-parser.l:714:6: error: conflicting types for =EF=BF=BDyyun=
put=EF=BF=BD
> exp/expression-parser.l:43:37: note: previous declaration of =EF=BF=BDyyu=
nput=EF=BF=BD was here
> make: *** [lex.yy.o] Error 1

Try -git again and see if that works, I just disabled it (for now) on
Solaris.


--=20
Jens Axboe


