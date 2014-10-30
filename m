Return-Path: <fio-owner@vger.kernel.org>
Received: from server506i.appriver.com ([50.56.144.147]:60725 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751426AbaJ3PuV convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 30 Oct 2014 11:50:21 -0400
Received: from [10.242.229.139] (HELO smtp.exg6.exghost.com)
  by server506.appriver.com (CommuniGate Pro SMTP 6.0.2)
  with ESMTPS id 121391061 for fio@vger.kernel.org; Thu, 30 Oct 2014 10:40:19 -0500
From: "Robin P. Blanchard" <robin@coraid.com>
Subject: yacc/flex/bison (?) regression since 2.1.13 (solaris 11 x86_64) -
 ../exp/*
Date: Thu, 30 Oct 2014 15:40:18 +0000
Message-ID: <9BFC2684-B327-440D-8051-5528AEDFA530@coraid.com>
Content-Language: en-US
Content-Type: text/plain; charset="windows-1252"
Content-ID: <7AF61B2AF60B804FA0A449D9B192BA0C@fwd6.exghost.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi there.

The introduction of ../exp/* seems to have broken compilation on Solaris 11=
. Please let me know how I can help work through this.

Thanks in advance!


# pkg info entire |egrep 'Version|FMRI'
       Version: 0.5.11 (Oracle Solaris 11.2.3.5.0)
          FMRI: pkg://solaris/entire@0.5.11,5.11-0.175.2.3.0.5.0:20141019T1=
81440Z


** GIT

# make
Makefile:14: config-host.mak: No such file or directory
FIO_VERSION =3D fio-2.1.13-109-ga1f8
Running configure for you...
Operating system              SunOS
CPU                           x86_64
Big endian                    no
Compiler                      gcc
Cross compile                 no

Wordsize                      32
zlib                          yes
Linux AIO support             no
POSIX AIO support             yes
POSIX AIO support needs -lrt  no
POSIX AIO fsync               yes
Solaris AIO support           yes
__sync_fetch_and_add          yes
libverbs                      yes
rdmacm                        yes
Linux fallocate               no
POSIX fadvise                 yes
POSIX fallocate               yes
sched_setaffinity(3 arg)      no
sched_setaffinity(2 arg)      no
clock_gettime                 yes
CLOCK_MONOTONIC               yes
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
strcasestr                    yes
getopt_long_only()            yes
inet_aton                     yes
socklen_t                     yes
__thread                      yes
RUSAGE_THREAD                 no
SCHED_IDLE                    no
TCP_NODELAY                   yes
Net engine window_size        yes
TCP_MAXSEG                    yes
RLIMIT_MEMLOCK                no
pwritev/preadv                no
IPv6 helpers                  yes
Rados Block Device engine     no
setvbuf                       yes
Gluster API engine            no
s390_z196_facilities          no
HDFS engine                   no
lex/yacc for arithmetic       yes
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
"exp/expression-parser.l":line 166: Warning: Non-portable Character Class
  YACC y.tab.c
    CC lex.yy.o
exp/expression-parser.l:43:37: error: conflicting types for =EF=BF=BDyyunpu=
t=EF=BF=BD
lex.yy.c:31:7: note: previous declaration of =EF=BF=BDyyunput=EF=BF=BD was =
here
exp/expression-parser.l:44:46: error: macro "input" passed 1 arguments, but=
 takes just 0
exp/expression-parser.l: In function =EF=BF=BDyylex=EF=BF=BD:
exp/expression-parser.l:61:1: warning: label =EF=BF=BDyyfussy=EF=BF=BD defi=
ned but not used
exp/expression-parser.l:54:22: warning: unused variable =EF=BF=BDyyprevious=
=EF=BF=BD
exp/expression-parser.l: At top level:
exp/expression-parser.l:297:1: warning: missing braces around initializer
exp/expression-parser.l:297:1: warning: (near initialization for =EF=BF=BDy=
ycrank[0]=EF=BF=BD)
exp/expression-parser.l:376:1: warning: missing braces around initializer
exp/expression-parser.l:376:1: warning: (near initialization for =EF=BF=BDy=
ysvec[0]=EF=BF=BD)
exp/expression-parser.l:714:6: error: conflicting types for =EF=BF=BDyyunpu=
t=EF=BF=BD
exp/expression-parser.l:43:37: note: previous declaration of =EF=BF=BDyyunp=
ut=EF=BF=BD was here
make: *** [lex.yy.o] Error 1


** 2.1.13

# make
Makefile:14: config-host.mak: No such file or directory
FIO_VERSION =3D fio-2.1.13
Running configure for you...
Operating system              SunOS
CPU                           x86_64
Big endian                    no
Compiler                      gcc
Cross compile                 no

Wordsize                      32
zlib                          yes
Linux AIO support             no
POSIX AIO support             yes
POSIX AIO support needs -lrt  no
POSIX AIO fsync               yes
Solaris AIO support           yes
__sync_fetch_and_add          yes
libverbs                      yes
rdmacm                        yes
Linux fallocate               no
POSIX fadvise                 yes
POSIX fallocate               yes
sched_setaffinity(3 arg)      no
sched_setaffinity(2 arg)      no
clock_gettime                 yes
CLOCK_MONOTONIC               yes
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
strcasestr                    yes
getopt_long_only()            yes
inet_aton                     yes
socklen_t                     yes
__thread                      yes
gtk 2.18 or higher            no
RUSAGE_THREAD                 no
SCHED_IDLE                    no
TCP_NODELAY                   yes
RLIMIT_MEMLOCK                no
pwritev/preadv                no
IPv6 helpers                  yes
Rados Block Device engine     no
setvbuf                       yes
Gluster API engine            no
Gluster API use fadvise       no
s390_z196_facilities          no
HDFS engine                   no
lex/yacc for arithmetic       yes
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
"exp/expression-parser.l":line 160: Warning: Non-portable Character Class
  YACC y.tab.c
/usr/bin/yacc: illegal option -- no-lines
Usage: yacc [-vVdltY] [-Q(y/n)] [-b file_prefix] [-p sym_prefix] [-P parser=
] file
make: *** [y.tab.c] Error 1



** 2.1.13 Makefile edited to reflect change from commit de06a46881e1a8876b5=
fd1de5e002d6189a90a30:

-	$(QUIET_YACC)$(YACC) --no-lines -d -b y exp/expression-parser.y
+	$(QUIET_YACC)$(YACC) -l -d -b y exp/expression-parser.y


# make
Makefile:14: config-host.mak: No such file or directory
FIO_VERSION =3D fio-2.1.13
Running configure for you...
Operating system              SunOS
CPU                           x86_64
Big endian                    no
Compiler                      gcc
Cross compile                 no

Wordsize                      32
zlib                          yes
Linux AIO support             no
POSIX AIO support             yes
POSIX AIO support needs -lrt  no
POSIX AIO fsync               yes
Solaris AIO support           yes
__sync_fetch_and_add          yes
libverbs                      yes
rdmacm                        yes
Linux fallocate               no
POSIX fadvise                 yes
POSIX fallocate               yes
sched_setaffinity(3 arg)      no
sched_setaffinity(2 arg)      no
clock_gettime                 yes
CLOCK_MONOTONIC               yes
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
strcasestr                    yes
getopt_long_only()            yes
inet_aton                     yes
socklen_t                     yes
__thread                      yes
GUASI                         no
Fusion-io atomic engine       no
libnuma                       no
strsep                        yes
strcasestr                    yes
getopt_long_only()            yes
inet_aton                     yes
socklen_t                     yes
__thread                      yes
gtk 2.18 or higher            no
RUSAGE_THREAD                 no
SCHED_IDLE                    no
TCP_NODELAY                   yes
RLIMIT_MEMLOCK                no
pwritev/preadv                no
IPv6 helpers                  yes
Rados Block Device engine     no
setvbuf                       yes
Gluster API engine            no
Gluster API use fadvise       no
s390_z196_facilities          no
HDFS engine                   no
lex/yacc for arithmetic       yes
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
"exp/expression-parser.l":line 160: Warning: Non-portable Character Class
  YACC y.tab.c
"exp/expression-parser.y", line 66: fatal: invalid escape, or illegal reser=
ved word: parse
make: *** [y.tab.c] Error 1


