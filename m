Return-Path: <slpratt@austin.ibm.com>
MIME-Version: 1.0
From: Steven Pratt <slpratt@austin.ibm.com>
Date: Thu, 27 Jan 2011 14:08:58 -0700
Subject: Re: Recent changes
Message-ID: <4D41DEEA.8040608@austin.ibm.com>
References: <20110125050003.F378B37A302@kernel.dk>
In-Reply-To: <20110125050003.F378B37A302@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 01/24/2011 11:00 PM, Jens Axboe wrote:
> The following changes since commit b8d42b234f70ce2927e9ef1279aff42d62779c=
fd:
>
>   Fio 1.50-rc4 (2011-01-20 10:17:35 -0700)
>
> are available in the git repository at:
>   git://git.kernel.dk/fio.git master
>
> Bruce Cran (1):
>       Unify makefiles
>
> Jens Axboe (3):
>       Ensure that we exit with non-zero status on IO engine load failure
>       mmap: catch invalid msync() errors early
>       Remove flist_sort(), it's no longer used
>
>  Makefile         |   53 ++++++++++++++++----

Jens, the nested else ifeq statements in the main Makfile blow up on make v=
ersions prior to 3.81.  SLES10 still has 3.80.  Not a big deal for me, but =
I work with some folks for which this is over their heads.  Any chance we c=
ould revert back to a more compatible syntax?

Steve

>  Makefile.FreeBSD |   60 -----------------------
>  Makefile.NetBSD  |   59 -----------------------
>  Makefile.Windows |   61 -----------------------
>  Makefile.aix     |   59 -----------------------
>  Makefile.mac     |   60 -----------------------
>  Makefile.solaris |   60 -----------------------
>  README           |   15 ++----
>  engines/mmap.c   |    8 +++
>  flist_sort.h     |    9 ----
>  ioengines.c      |    2 +
>  lib/flist_sort.c |  140 ------------------------------------------------=
------
>  12 files changed, 56 insertions(+), 530 deletions(-)
>  delete mode 100644 Makefile.FreeBSD
>  delete mode 100644 Makefile.NetBSD
>  delete mode 100644 Makefile.Windows
>  delete mode 100644 Makefile.aix
>  delete mode 100644 Makefile.mac
>  delete mode 100644 Makefile.solaris
>  delete mode 100644 flist_sort.h
>  delete mode 100644 lib/flist_sort.c
>
> ---
>
> Diff of recent changes:
>
> diff --git a/Makefile b/Makefile
> index 19943db..df58489 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -3,20 +3,51 @@ DEBUGFLAGS =3D -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG
>  CPPFLAGS=3D -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 \
>       $(DEBUGFLAGS)
>  OPTFLAGS=3D -O2 -fno-omit-frame-pointer -g $(EXTFLAGS)
> -CFLAGS       =3D -std=3Dgnu99 -Wwrite-strings -Wall $(OPTFLAGS) -rdynami=
c
> -LIBS =3D -lpthread -lm -ldl -lrt -laio
> +CFLAGS       =3D -std=3Dgnu99 -Wwrite-strings -Wall $(OPTFLAGS)
> +LIBS =3D -lm
>  PROGS        =3D fio
>  SCRIPTS =3D fio_generate_plots
> -
> +UNAME  :=3D $(shell uname)
> +
>  SOURCE =3D gettime.c fio.c ioengines.c init.c stat.c log.c time.c filese=
tup.c \
> -     eta.c verify.c memory.c io_u.c parse.c mutex.c options.c rbtree.c \
> -     diskutil.c fifo.c blktrace.c smalloc.c filehash.c helpers.c \
> -     cgroup.c profile.c debug.c trim.c lib/rand.c lib/flist_sort.c \
> -     lib/num2str.c $(wildcard crc/*.c) engines/cpu.c engines/libaio.c \
> -     engines/mmap.c engines/posixaio.c engines/sg.c engines/splice.c \
> -     engines/sync.c engines/null.c engines/net.c engines/syslet-rw.c \
> -     engines/guasi.c engines/binject.c profiles/tiobench.c
> -
> +             eta.c verify.c memory.c io_u.c parse.c mutex.c options.c \
> +             rbtree.c smalloc.c filehash.c profile.c debug.c lib/rand.c =
\
> +             lib/num2str.c $(wildcard crc/*.c) engines/cpu.c \
> +             engines/mmap.c engines/sync.c engines/null.c engines/net.c
> +
> +ifeq ($(UNAME), Linux)
> +  SOURCE +=3D diskutil.c fifo.c blktrace.c helpers.c cgroup.c trim.c \
> +             engines/libaio.c engines/posixaio.c engines/sg.c \
> +             engines/splice.c engines/syslet-rw.c engines/guasi.c \
> +             engines/binject.c profiles/tiobench.c
> +  LIBS +=3D -lpthread -ldl -lrt -laio
> +  CFLAGS +=3D -rdynamic
> +else ifeq ($(UNAME), SunOS)
> +  SOURCE +=3D fifo.c lib/strsep.c helpers.c solaris.c engines/posixaio.c=
 \
> +             engines/solarisaio.c
> +  LIBS        +=3D -lpthread -ldl -laio -lrt -lnsl -lsocket
> +  CPPFLAGS +=3D -D__EXTENSIONS__
> +else ifeq ($(UNAME), FreeBSD)
> +  SOURCE +=3D helpers.c engines/posixaio.c
> +  LIBS        +=3D -lpthread -lrt
> +  CFLAGS +=3D -rdynamic
> +else ifeq ($(UNAME), NetBSD)
> +  SOURCE +=3D helpers.c engines/posixaio.c
> +  LIBS        +=3D -lpthread -lrt
> +  CFLAGS +=3D -rdynamic
> +else ifeq ($(UNAME), AIX)
> +  SOURCE +=3D fifo.c helpers.c lib/getopt_long.c engines/posixaio.c
> +  LIBS        +=3D -lpthread -ldl -lrt
> +  CFLAGS +=3D -rdynamic
> +  CPPFLAGS +=3D -D_LARGE_FILES -D__ppc__
> +else ifeq ($(UNAME), Darwin)
> +  SOURCE +=3D helpers.c engines/posixaio.c
> +  LIBS        +=3D -lpthread -ldl
> +else ifneq (,$(findstring CYGWIN,$(UNAME)))
> +  SOURCE +=3D engines/windowsaio.c
> +  LIBS        +=3D -lpthread -lrt
> +endif
> +
>  OBJS =3D $(SOURCE:.c=3D.o)
>
>  ifneq ($(findstring $(MAKEFLAGS),s),s)
> diff --git a/Makefile.FreeBSD b/Makefile.FreeBSD
> deleted file mode 100644
> index 537f770..0000000
> --- a/Makefile.FreeBSD
> +++ /dev/null
> @@ -1,60 +0,0 @@
> -CC   =3D gcc
> -DEBUGFLAGS =3D -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG
> -CPPFLAGS=3D -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 \
> -     $(DEBUGFLAGS)
> -OPTFLAGS=3D -O2 -fno-omit-frame-pointer -g $(EXTFLAGS)
> -CFLAGS       =3D -std=3Dgnu99 -Wwrite-strings -Wall $(OPTFLAGS) -rdynami=
c
> -LIBS =3D -lpthread -lm -lrt
> -PROGS        =3D fio
> -SCRIPTS =3D fio_generate_plots
> -
> -SOURCE =3D gettime.c fio.c ioengines.c init.c stat.c log.c time.c filese=
tup.c \
> -     eta.c verify.c memory.c io_u.c parse.c mutex.c options.c rbtree.c \
> -     smalloc.c filehash.c helpers.c profile.c debug.c lib/rand.c \
> -     lib/flist_sort.c lib/num2str.c $(wildcard crc/*.c) engines/cpu.c \
> -     engines/mmap.c engines/posixaio.c engines/sync.c engines/null.c \
> -     engines/net.c
> -
> -OBJS =3D $(SOURCE:.c=3D.o)
> -
> -ifneq ($(findstring $(MAKEFLAGS),s),s)
> -ifndef V
> -     QUIET_CC        =3D @echo '   ' CC $@;
> -     QUIET_DEP       =3D @echo '   ' DEP $@;
> -endif
> -endif
> -
> -INSTALL =3D install
> -prefix =3D /usr/local
> -bindir =3D $(prefix)/bin
> -mandir =3D $(prefix)/man
> -
> -.c.o:
> -     $(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(CPPFLAGS) $<
> -
> -fio: $(OBJS)
> -     $(QUIET_CC)$(CC) $(CFLAGS) -o $@ $(LIBS) $(OBJS)
> -
> -depend:
> -     $(QUIET_DEP)$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SOURCE) 1> .depend
> -
> -$(PROGS): depend
> -
> -all: depend $(PROGS) $(SCRIPTS)
> -
> -clean:
> -     -rm -f .depend cscope.out $(OBJS) $(PROGS) core.* core
> -
> -cscope:
> -     @cscope -b
> -
> -install: $(PROGS) $(SCRIPTS)
> -     $(INSTALL) -m755 -d $(DESTDIR)$(bindir)
> -     $(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
> -     $(INSTALL) -m 755 -d $(DESTDIR)$(mandir)/man1
> -     $(INSTALL) -m 644 fio.1 $(DESTDIR)$(mandir)/man1
> -     $(INSTALL) -m 644 fio_generate_plots.1 $(DESTDIR)$(mandir)/man1
> -
> -ifneq ($(wildcard .depend),)
> -include .depend
> -endif
> diff --git a/Makefile.NetBSD b/Makefile.NetBSD
> deleted file mode 100644
> index cefc34e..0000000
> --- a/Makefile.NetBSD
> +++ /dev/null
> @@ -1,59 +0,0 @@
> -CC   =3D gcc
> -DEBUGFLAGS =3D -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG
> -CPPFLAGS=3D -D_GNU_SOURCE $(DEBUGFLAGS)
> -OPTFLAGS=3D -O2 -fno-omit-frame-pointer -g $(EXTFLAGS)
> -CFLAGS       =3D -std=3Dgnu99 -Wwrite-strings -Wall $(OPTFLAGS) -rdynami=
c
> -LIBS =3D -lpthread -lm -lrt
> -PROGS        =3D fio
> -SCRIPTS =3D fio_generate_plots
> -
> -SOURCE =3D gettime.c fio.c ioengines.c init.c stat.c log.c time.c filese=
tup.c \
> -     eta.c verify.c memory.c io_u.c parse.c mutex.c options.c rbtree.c \
> -     smalloc.c filehash.c helpers.c profile.c debug.c lib/rand.c \
> -     lib/flist_sort.c lib/num2str.c $(wildcard crc/*.c) engines/cpu.c \
> -     engines/mmap.c engines/posixaio.c engines/sync.c engines/null.c \
> -     engines/net.c
> -
> -OBJS =3D $(SOURCE:.c=3D.o)
> -
> -ifneq ($(findstring $(MAKEFLAGS),s),s)
> -ifndef V
> -     QUIET_CC        =3D @echo '   ' CC $@;
> -     QUIET_DEP       =3D @echo '   ' DEP $@;
> -endif
> -endif
> -
> -INSTALL =3D install
> -prefix =3D /usr/local
> -bindir =3D $(prefix)/bin
> -mandir =3D $(prefix)/man
> -
> -.c.o:
> -     $(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(CPPFLAGS) $<
> -
> -fio: $(OBJS)
> -     $(QUIET_CC)$(CC) $(CFLAGS) -o $@ $(LIBS) $(OBJS)
> -
> -depend:
> -     $(QUIET_DEP)$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SOURCE) 1> .depend
> -
> -$(PROGS): depend
> -
> -all: depend $(PROGS) $(SCRIPTS)
> -
> -clean:
> -     -rm -f .depend cscope.out $(OBJS) $(PROGS) core.* core
> -
> -cscope:
> -     @cscope -b
> -
> -install: $(PROGS) $(SCRIPTS)
> -     $(INSTALL) -m755 -d $(DESTDIR)$(bindir)
> -     $(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
> -     $(INSTALL) -m 755 -d $(DESTDIR)$(mandir)/man1
> -     $(INSTALL) -m 644 fio.1 $(DESTDIR)$(mandir)/man1
> -     $(INSTALL) -m 644 fio_generate_plots.1 $(DESTDIR)$(mandir)/man1
> -
> -ifneq ($(wildcard .depend),)
> -include .depend
> -endif
> diff --git a/Makefile.Windows b/Makefile.Windows
> deleted file mode 100644
> index 3313c04..0000000
> --- a/Makefile.Windows
> +++ /dev/null
> @@ -1,61 +0,0 @@
> -CC   =3D gcc
> -DEBUGFLAGS =3D -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG
> -CPPFLAGS=3D -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 \
> -     $(DEBUGFLAGS)
> -OPTFLAGS=3D -O2 -fno-omit-frame-pointer -gstabs+ $(EXTFLAGS)
> -CFLAGS       =3D -std=3Dgnu99 -Wwrite-strings -Wall $(OPTFLAGS)
> -LIBS =3D -lpthread -lm -lrt
> -PROGS        =3D fio
> -SCRIPTS =3D fio_generate_plots
> -
> -SOURCE =3D gettime.c fio.c ioengines.c init.c stat.c log.c time.c filese=
tup.c \
> -     eta.c verify.c memory.c io_u.c parse.c mutex.c options.c rbtree.c \
> -     smalloc.c filehash.c profile.c debug.c lib/rand.c \
> -     lib/flist_sort.c lib/num2str.c $(wildcard crc/*.c) engines/cpu.c \
> -     engines/mmap.c engines/sync.c engines/null.c engines/net.c \
> -     engines/net.c engines/windowsaio.c
> -
> -OBJS =3D $(SOURCE:.c=3D.o)
> -
> -ifneq ($(findstring $(MAKEFLAGS),s),s)
> -ifndef V
> -     QUIET_CC        =3D @echo '   ' CC $@;
> -     QUIET_DEP       =3D @echo '   ' DEP $@;
> -endif
> -endif
> -
> -INSTALL =3D install
> -prefix =3D /usr/local
> -bindir =3D $(prefix)/bin
> -mandir =3D $(prefix)/man
> -
> -.c.o:
> -     $(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(CPPFLAGS) $<
> -
> -fio: $(OBJS)
> -     $(QUIET_CC)windres os/windows/version.rc -O coff -o version.o
> -     $(QUIET_CC)$(CC) $(CFLAGS) -o $@ $(LIBS) $(OBJS) version.o
> -
> -depend:
> -     $(QUIET_DEP)$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SOURCE) 1> .depend
> -
> -$(PROGS): depend
> -
> -all: depend $(PROGS) $(SCRIPTS)
> -
> -clean:
> -     -rm -f .depend cscope.out $(OBJS) $(PROGS) version.o core.* core
> -
> -cscope:
> -     @cscope -b
> -
> -install: $(PROGS) $(SCRIPTS)
> -     $(INSTALL) -m755 -d $(DESTDIR)$(bindir)
> -     $(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
> -     $(INSTALL) -m 755 -d $(DESTDIR)$(mandir)/man1
> -     $(INSTALL) -m 644 fio.1 $(DESTDIR)$(mandir)/man1
> -     $(INSTALL) -m 644 fio_generate_plots.1 $(DESTDIR)$(mandir)/man1
> -
> -ifneq ($(wildcard .depend),)
> -include .depend
> -endif
> diff --git a/Makefile.aix b/Makefile.aix
> deleted file mode 100644
> index 174ffee..0000000
> --- a/Makefile.aix
> +++ /dev/null
> @@ -1,59 +0,0 @@
> -CC   =3D gcc
> -DEBUGFLAGS =3D -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG
> -CPPFLAGS=3D -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 \
> -     -D_LARGE_FILES -D__ppc__ $(DEBUGFLAGS)
> -OPTFLAGS=3D -O2 -fno-omit-frame-pointer -g $(EXTFLAGS)
> -CFLAGS       =3D -std=3Dgnu99 -Wwrite-strings -Wall $(OPTFLAGS) -rdynami=
c
> -LIBS =3D -lpthread -lm -ldl -lrt
> -PROGS        =3D fio
> -SCRIPTS =3D fio_generate_plots
> -
> -SOURCE =3D gettime.c fio.c ioengines.c init.c stat.c log.c time.c filese=
tup.c \
> -     eta.c verify.c memory.c io_u.c parse.c mutex.c options.c rbtree.c \
> -     fifo.c smalloc.c filehash.c helpers.c profile.c debug.c lib/rand.c =
\
> -     lib/getopt_long.c lib/num2str.c $(wildcard crc/*.c) engines/cpu.c \
> -     engines/mmap.c engines/posixaio.c engines/sync.c engines/null.c \
> -     engines/net.c profiles/tiobench.c
> -
> -OBJS =3D $(SOURCE:.c=3D.o)
> -
> -ifneq ($(findstring $(MAKEFLAGS),s),s)
> -ifndef V
> -     QUIET_CC        =3D @echo '   ' CC $@;
> -     QUIET_DEP       =3D @echo '   ' DEP $@;
> -endif
> -endif
> -
> -INSTALL =3D installbsd -c
> -prefix =3D /usr/local
> -bindir =3D $(prefix)/bin
> -mandir =3D $(prefix)/man
> -
> -.c.o:
> -     $(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(CPPFLAGS) $<
> -
> -fio: $(OBJS)
> -     $(QUIET_CC)$(CC) $(CFLAGS) -o $@ $(LIBS) $(OBJS)
> -
> -depend:
> -     $(QUIET_DEP)$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SOURCE) 1> .depend
> -
> -$(PROGS): depend
> -
> -all: depend $(PROGS) $(SCRIPTS)
> -
> -clean:
> -     -rm -f .depend cscope.out $(OBJS) $(PROGS) core.* core
> -
> -cscope:
> -     @cscope -b
> -
> -install: $(PROGS) $(SCRIPTS)
> -     mkdir -p -m 755 $(DESTDIR)$(bindir) $(DESTDIR)$(mandir)/man1
> -     $(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
> -     $(INSTALL) -m 644 fio.1 $(DESTDIR)$(mandir)/man1
> -     $(INSTALL) -m 644 fio_generate_plots.1 $(DESTDIR)$(mandir)/man1
> -
> -ifneq ($(wildcard .depend),)
> -include .depend
> -endif
> diff --git a/Makefile.mac b/Makefile.mac
> deleted file mode 100644
> index 6efce20..0000000
> --- a/Makefile.mac
> +++ /dev/null
> @@ -1,60 +0,0 @@
> -CC   =3D gcc
> -DEBUGFLAGS =3D -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG
> -CPPFLAGS=3D -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 \
> -     $(DEBUGFLAGS)
> -OPTFLAGS=3D -O2 -fno-omit-frame-pointer -g $(EXTFLAGS)
> -CFLAGS       =3D -std=3Dgnu99 -Wwrite-strings -Wall $(OPTFLAGS) -rdynami=
c
> -LIBS =3D -lpthread -lm -ldl
> -PROGS        =3D fio
> -SCRIPTS =3D fio_generate_plots
> -
> -SOURCE =3D gettime.c fio.c ioengines.c init.c stat.c log.c time.c filese=
tup.c \
> -     eta.c verify.c memory.c io_u.c parse.c mutex.c options.c rbtree.c \
> -     smalloc.c filehash.c helpers.c profile.c debug.c lib/rand.c \
> -     lib/flist_sort.c lib/num2str.c $(wildcard crc/*.c) engines/cpu.c \
> -     engines/mmap.c engines/posixaio.c engines/sync.c engines/null.c \
> -     engines/net.c
> -
> -OBJS =3D $(SOURCE:.c=3D.o)
> -
> -ifneq ($(findstring $(MAKEFLAGS),s),s)
> -ifndef V
> -     QUIET_CC        =3D @echo '   ' CC $@;
> -     QUIET_DEP       =3D @echo '   ' DEP $@;
> -endif
> -endif
> -
> -INSTALL =3D install
> -prefix =3D /usr/local
> -bindir =3D $(prefix)/bin
> -mandir =3D $(prefix)/man
> -
> -.c.o:
> -     $(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(CPPFLAGS) $<
> -
> -fio: $(OBJS)
> -     $(QUIET_CC)$(CC) $(CFLAGS) -o $@ $(LIBS) $(OBJS)
> -
> -depend:
> -     $(QUIET_DEP)$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SOURCE) 1> .depend
> -
> -$(PROGS): depend
> -
> -all: depend $(PROGS) $(SCRIPTS)
> -
> -clean:
> -     -rm -f .depend cscope.out $(OBJS) $(PROGS) core.* core
> -
> -cscope:
> -     @cscope -b
> -
> -install: $(PROGS) $(SCRIPTS)
> -     $(INSTALL) -m755 -d $(DESTDIR)$(bindir)
> -     $(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
> -     $(INSTALL) -m 755 -d $(DESTDIR)$(mandir)/man1
> -     $(INSTALL) -m 644 fio.1 $(DESTDIR)$(mandir)/man1
> -     $(INSTALL) -m 644 fio_generate_plots.1 $(DESTDIR)$(mandir)/man1
> -
> -ifneq ($(wildcard .depend),)
> -include .depend
> -endif
> diff --git a/Makefile.solaris b/Makefile.solaris
> deleted file mode 100644
> index 97a3ae5..0000000
> --- a/Makefile.solaris
> +++ /dev/null
> @@ -1,60 +0,0 @@
> -CC   =3D gcc
> -DEBUGFLAGS =3D -DFIO_INC_DEBUG
> -CPPFLAGS=3D -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 \
> -     -D__EXTENSIONS__ $(DEBUGFLAGS)
> -OPTFLAGS=3D -O2 -fno-omit-frame-pointer -g $(EXTFLAGS)
> -CFLAGS       =3D -std=3Dgnu99 -Wall $(OPTFLAGS)
> -LIBS =3D -lpthread -lm -ldl -laio -lrt -lnsl -lsocket
> -PROGS        =3D fio
> -SCRIPTS =3D fio_generate_plots
> -
> -SOURCE =3D gettime.c fio.c ioengines.c init.c stat.c log.c time.c filese=
tup.c \
> -     eta.c verify.c memory.c io_u.c parse.c mutex.c options.c rbtree.c \
> -     fifo.c smalloc.c filehash.c lib/strsep.c helpers.c solaris.c \
> -     profile.c debug.c lib/rand.c lib/flist_sort.c lib/num2str.c \
> -     $(wildcard crc/*.c) engines/cpu.c engines/mmap.c engines/posixaio.c=
 \
> -     engines/sync.c engines/null.c engines/net.c engines/solarisaio.c
> -
> -OBJS =3D $(SOURCE:.c=3D.o)
> -
> -ifneq ($(findstring $(MAKEFLAGS),s),s)
> -ifndef V
> -     QUIET_CC        =3D @echo '   ' CC $@;
> -     QUIET_DEP       =3D @echo '   ' DEP $@;
> -endif
> -endif
> -
> -INSTALL =3D install
> -prefix =3D /usr/local
> -bindir =3D $(prefix)/bin
> -mandir =3D $(prefix)/man
> -
> -.c.o:
> -     $(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(CPPFLAGS) $<
> -
> -fio: $(OBJS)
> -     $(QUIET_CC)$(CC) $(CFLAGS) -o $@ $(LIBS) $(OBJS)
> -
> -depend:
> -     $(QUIET_DEP)$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SOURCE) 1> .depend
> -
> -$(PROGS): depend
> -
> -all: depend $(PROGS) $(SCRIPTS)
> -
> -clean:
> -     -rm -f .depend cscope.out $(OBJS) $(PROGS) core.* core
> -
> -cscope:
> -     @cscope -b
> -
> -install: $(PROGS) $(SCRIPTS)
> -     $(INSTALL) -m755 -d $(DESTDIR)$(bindir)
> -     $(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
> -     $(INSTALL) -m 755 -d $(DESTDIR)$(mandir)/man1
> -     $(INSTALL) -m 644 fio.1 $(DESTDIR)$(mandir)/man1
> -     $(INSTALL) -m 644 fio_generate_plots.1 $(DESTDIR)$(mandir)/man1
> -
> -ifneq ($(wildcard .depend),)
> -include .depend
> -endif
> diff --git a/README b/README
> index adcced6..cc84fed 100644
> --- a/README
> +++ b/README
> @@ -83,18 +83,11 @@ http://maillist.kernel.dk/fio-devel/
>  Building
>  --------
>
> -Just type 'make' and 'make install'. If on BSD, for now you have to
> -specify the BSD Makefile with -f and use gmake (not make), eg:
> +Just type 'make' and 'make install'.
>
> -$ gmake -f Makefile.FreeBSD && gmake -f Makefile.FreeBSD install
> -
> -Same goes for AIX:
> -
> -$ gmake -f Makefile.aix && gmake -f Makefile.aix install
> -
> -Likewise with OpenSolaris, use the Makefile.solaris to compile there.
> -The OpenSolaris make should work fine. This might change in the
> -future if I opt for an autoconf type setup.
> +Note that GNU make is required. On BSD it's available from devel/gmake;
> +on Solaris it's in the SUNWgmake package. On platforms where GNU make
> +isn't the default, type 'gmake' instead of 'make'.
>
>  If your compile fails with an error like this:
>
> diff --git a/engines/mmap.c b/engines/mmap.c
> index 059bfcf..79238b1 100644
> --- a/engines/mmap.c
> +++ b/engines/mmap.c
> @@ -181,8 +181,16 @@ static int fio_mmapio_queue(struct thread_data *td, =
struct io_u *io_u)
>
>  static int fio_mmapio_init(struct thread_data *td)
>  {
> +     struct thread_options *o =3D &td->o;
>       unsigned long shift, mask;
>
> +     if ((td->o.rw_min_bs & page_mask) &&
> +         (o->odirect || o->fsync_blocks || o->fdatasync_blocks)) {
> +             log_err("fio: mmap options dictate a minimum block size of =
"
> +                     "%lu bytes\n", page_size);
> +             return 1;
> +     }
> +
>       mmap_map_size =3D MMAP_TOTAL_SZ / td->o.nr_files;
>       mask =3D mmap_map_size;
>       shift =3D 0;
> diff --git a/flist_sort.h b/flist_sort.h
> deleted file mode 100644
> index 686b7a5..0000000
> --- a/flist_sort.h
> +++ /dev/null
> @@ -1,9 +0,0 @@
> -#ifndef FIO_FLIST_SORT_H
> -#define FIO_FLIST_SORT_H
> -
> -struct flist_head;
> -
> -void flist_sort(void *priv, struct flist_head *head,
> -            int (*cmp)(void *priv, struct flist_head *a,
> -                       struct flist_head *b));
> -#endif
> diff --git a/ioengines.c b/ioengines.c
> index 6b677cb..7f4e104 100644
> --- a/ioengines.c
> +++ b/ioengines.c
> @@ -312,6 +312,8 @@ int td_io_init(struct thread_data *td)
>                       log_err("fio: io engine init failed. Perhaps try"
>                               " reducing io depth?\n");
>               }
> +             if (!td->error)
> +                     td->error =3D ret;
>       }
>
>       return ret;
> diff --git a/lib/flist_sort.c b/lib/flist_sort.c
> deleted file mode 100644
> index 9a2da84..0000000
> --- a/lib/flist_sort.c
> +++ /dev/null
> @@ -1,140 +0,0 @@
> -#include <string.h>
> -#include <assert.h>
> -
> -#include "../flist.h"
> -#include "../flist_sort.h"
> -
> -#ifndef ARRAY_SIZE
> -#define      ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
> -#endif
> -
> -#define MAX_LIST_LENGTH_BITS 65
> -
> -/*
> - * Returns a list organized in an intermediate format suited
> - * to chaining of merge() calls: null-terminated, no reserved or
> - * sentinel head node, "prev" links not maintained.
> - */
> -static struct flist_head *merge(void *priv,
> -                             int (*cmp)(void *priv, struct flist_head *a=
,
> -                                     struct flist_head *b),
> -                             struct flist_head *a, struct flist_head *b)
> -{
> -     struct flist_head head, *tail =3D &head;
> -
> -     while (a && b) {
> -             /* if equal, take 'a' -- important for sort stability */
> -             if ((*cmp)(priv, a, b) <=3D 0) {
> -                     tail->next =3D a;
> -                     a =3D a->next;
> -             } else {
> -                     tail->next =3D b;
> -                     b =3D b->next;
> -             }
> -             tail =3D tail->next;
> -     }
> -     tail->next =3D a?:b;
> -     return head.next;
> -}
> -
> -/*
> - * Combine final list merge with restoration of standard doubly-linked
> - * list structure.  This approach duplicates code from merge(), but
> - * runs faster than the tidier alternatives of either a separate final
> - * prev-link restoration pass, or maintaining the prev links
> - * throughout.
> - */
> -static void merge_and_restore_back_links(void *priv,
> -                             int (*cmp)(void *priv, struct flist_head *a=
,
> -                                     struct flist_head *b),
> -                             struct flist_head *head,
> -                             struct flist_head *a, struct flist_head *b)
> -{
> -     struct flist_head *tail =3D head;
> -
> -     while (a && b) {
> -             /* if equal, take 'a' -- important for sort stability */
> -             if ((*cmp)(priv, a, b) <=3D 0) {
> -                     tail->next =3D a;
> -                     a->prev =3D tail;
> -                     a =3D a->next;
> -             } else {
> -                     tail->next =3D b;
> -                     b->prev =3D tail;
> -                     b =3D b->next;
> -             }
> -             tail =3D tail->next;
> -     }
> -     tail->next =3D a ? : b;
> -
> -     do {
> -             /*
> -              * In worst cases this loop may run many iterations.
> -              * Continue callbacks to the client even though no
> -              * element comparison is needed, so the client's cmp()
> -              * routine can invoke cond_resched() periodically.
> -              */
> -             cmp(priv, tail, tail);
> -
> -             tail->next->prev =3D tail;
> -             tail =3D tail->next;
> -     } while (tail->next);
> -
> -     tail->next =3D head;
> -     head->prev =3D tail;
> -}
> -
> -/**
> - * flist_sort - sort a list
> - * @priv: private data, opaque to flist_sort(), passed to @cmp
> - * @head: the list to sort
> - * @cmp: the elements comparison function
> - *
> - * This function implements "merge sort", which has O(nlog(n))
> - * complexity.
> - *
> - * The comparison function @cmp must return a negative value if @a
> - * should sort before @b, and a positive value if @a should sort after
> - * @b. If @a and @b are equivalent, and their original relative
> - * ordering is to be preserved, @cmp must return 0.
> - */
> -void flist_sort(void *priv, struct flist_head *head,
> -             int (*cmp)(void *priv, struct flist_head *a,
> -                     struct flist_head *b))
> -{
> -     struct flist_head *part[MAX_LIST_LENGTH_BITS+1]; /* sorted partial =
lists
> -                                             -- last slot is a sentinel =
*/
> -     int lev;  /* index into part[] */
> -     int max_lev =3D 0;
> -     struct flist_head *list;
> -
> -     if (flist_empty(head))
> -             return;
> -
> -     memset(part, 0, sizeof(part));
> -
> -     head->prev->next =3D NULL;
> -     list =3D head->next;
> -
> -     while (list) {
> -             struct flist_head *cur =3D list;
> -             list =3D list->next;
> -             cur->next =3D NULL;
> -
> -             for (lev =3D 0; part[lev]; lev++) {
> -                     cur =3D merge(priv, cmp, part[lev], cur);
> -                     part[lev] =3D NULL;
> -             }
> -             if (lev > max_lev) {
> -                     assert(lev < ARRAY_SIZE(part) - 1);
> -                     max_lev =3D lev;
> -             }
> -             part[lev] =3D cur;
> -     }
> -
> -     for (lev =3D 0; lev < max_lev; lev++)
> -             if (part[lev])
> -                     list =3D merge(priv, cmp, part[lev], list);
> -
> -     merge_and_restore_back_links(priv, cmp, head, part[max_lev], list);
> -}
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


