Return-Path: <martin.steigerwald@teamix.de>
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: hardening fio build with PIE for Address Space Layout Randomization and bindnow linking
Date: Wed, 25 May 2016 10:47:12 +0200
Message-ID: <1559516.2vDHzyQDOD@merkaba>
In-Reply-To: <57446277.2010705@kernel.dk>
References: <6243211.bqPIL7RjHY@merkaba> <57446277.2010705@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

=EF=BB=BFOn Dienstag, 24. Mai 2016 08:17:27 CEST Jens Axboe wrote:
> On 05/24/2016 04:10 AM, Martin Steigerwald wrote:
> > Hello Jens!
> >=20
> > In my attempt to harden the fio build as recommended within Debian, I
> > tried to build it with PIE by using Debian=C2=B4s own mechanism via
> > dpkg-buildflags. And I>=20
> > got:
> >      CC diskutil.o
> >      CC fifo.o
> >      CC blktrace.o
> >      CC cgroup.o
> >      CC trim.o
> >      CC engines/sg.o
> >      CC engines/binject.o
> >      CC oslib/linux-dev-lookup.o
> >      CC fio.o
> >   =20
> >    LINK fio
> >=20
> > /usr/bin/ld: crc/crc16.o: relocation R_X86_64_32S against `crc16_table'
> > can
> > not be used when making a shared object; recompile with -fPIC
> > crc/crc16.o: error adding symbols: Bad value
> > collect2: error: ld returned 1 exit status
> > Makefile:399: recipe for target 'fio' failed
> > make[1]: *** [fio] Error 1
> > make[1]: Leaving directory '/home/ms/Debian/fio/pkg-fio'
> > dh_auto_build: make -j1 returned exit code 2
> > debian/rules:17: recipe for target 'build' failed
> > make: *** [build] Error 2
> > dpkg-buildpackage: error: debian/rules build gave error exit status 2
> >=20
> >=20
> > Yet, building fio 2.10 from upstream does doesn=C2=B4t produce a shared=
 object
> > file.
> >=20
> > Any idea?
> >=20
> >=20
> >=20
> >=20
> > I: fio: hardening-no-pie usr/bin/fio
> > N:
> > N:    This package provides an ELF executable that was not compiled as =
a
> > N:    position independent executable (PIE).
> > N:
> > N:    PIE is required for fully enabling Address Space Layout
> > Randomization
> > N:    (ASLR), which makes "Return-oriented" attacks more difficult.
> > N:
> > N:    Historically, PIE has been associated with noticeable performance
> > N:    overhead on i386. However, GCC-5 has implemented an optimization
> > that
> > N:    can reduce the overhead significantly.
> > N:
> > N:    If you use dpkg-buildflags, you may have to add hardening=3D+pie =
or
> > N:    hardening=3D+all to DEB_BUILD_MAINT_OPTIONS.
> > N:
> > N:    The relevant compiler flags must be passed both to the compiler a=
nd
> > the N:    linker (e.g. for C that would be commonly be CFLAGS and
> > LDFLAGS). N:
> > N:    CAVEAT: Please keep in mind that the PIE flag (-fPIE) is not
> > suitable
> > N:    for all cases:
> > N:
> > N:     * It is <not> compatible with -fPIC which required for
> > N:       compiling shared libraries.
> > N:     * It is unlikely to work when compiling static libraries or
> > N:       executables (gcc -static).
> > N:
> > N:    If your upstream build compiles either of the above, you may have=
 to
> > N:    patch the build to ensure that only ELF executables are compiled
> > with
> > N:    PIE.
> > N:
> > N:    Refer to https://wiki.debian.org/Hardening,
> > N:    https://gcc.gnu.org/gcc-5/changes.html, and
> > N:  =20
> > https://software.intel.com/en-us/blogs/2014/12/26/new-optimizations-for=
-x
> > 86-in-upcoming-gcc-50-32bit-pic-mode N:    for details.
> > N:
> > N:    Severity: wishlist, Certainty: certain
> > N:
> > N:    Check: binaries, Type: binary, udeb
> > N:
> > I: fio: hardening-no-pie usr/bin/fio-btrace2fio
> > I: fio: hardening-no-pie usr/bin/fio-dedupe
> > I: fio: hardening-no-pie usr/bin/fio-genzipf
> >=20
> >=20
> > Another option to harden fio works find and that is:
> >=20
> > I: fio: hardening-no-bindnow usr/bin/fio
> > N:
> > N:    This package provides an ELF binary that lacks the "bindnow" link=
er
> > N:    flag.
> > N:
> > N:    If the ELF binary does not rely on late binding of symbols (e.g.
> > weak
> > N:    symbols), then please consider enabling this feature. Otherwise,
> > please N:    consider overriding the tag (possibly with a comment about
> > why). N:
> > N:    If you use dpkg-buildflags, you may have to add hardening=3D+bind=
now
> > or
> > N:    hardening=3D+all to DEB_BUILD_MAINT_OPTIONS.
> > N:
> > N:    The relevant compiler flags are set in LDFLAGS.
> > N:
> > N:    Refer to https://wiki.debian.org/Hardening for details.
> > N:
> > N:    Severity: wishlist, Certainty: certain
> > N:
> > N:    Check: binaries, Type: binary, udeb
> > N:
> > I: fio: hardening-no-pie usr/bin/fio-btrace2fio
> > I: fio: hardening-no-bindnow usr/bin/fio-btrace2fio
> > I: fio: hardening-no-pie usr/bin/fio-dedupe
> > I: fio: hardening-no-bindnow usr/bin/fio-dedupe
> > I: fio: hardening-no-pie usr/bin/fio-genzipf
> > I: fio: hardening-no-bindnow usr/bin/fio-genzipf
> >=20
> >=20
> > Maybe it would be nice to have some of these in upstream build? PIE may
> > not
> > yet be advisable as for GCC 5 requirement.
>=20
> What extra compiler/linker flags are being set? I tried with just -fPIE
> here, and it builds and links fine.
>=20
> axboe@xps13:/home/axboe/git/fio $ gcc --version
> gcc (Ubuntu 6.1.1-3ubuntu11~14.04.1) 6.1.1 20160511
>=20
> I have gcc 5.3 installed as well, works for that too. So I'm guessing
> -fPIE isn't all that's being set?

Hmmm, according to

DEB_BUILD_HARDENING_PIE (gcc/g++ -fPIE -pie)

https://wiki.debian.org/Hardening#DEB_BUILD_HARDENING_PIE_.28gcc.2Fg.2B-.2B=
-_-fPIE_-pie.29

Its not all. It also does "-pie".

Yes, if I try this as in:

diff --git a/Makefile b/Makefile
index 108e6ee..a559971 100644
--- a/Makefile
+++ b/Makefile
@@ -23,7 +23,7 @@ endif
 DEBUGFLAGS =3D -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG
 CPPFLAGS=3D -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -DFIO_INTERNAL $(=
DEBUGFLAGS)
 OPTFLAGS=3D -g -ffast-math
-CFLAGS =3D -std=3Dgnu99 -Wwrite-strings -Wall -Wdeclaration-after-statemen=
t $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
+CFLAGS =3D -std=3Dgnu99 -Wwrite-strings -Wall -Wdeclaration-after-statemen=
t -fPIE -pie $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCD
IR)
 LIBS   +=3D -lm $(EXTLIBS)
 PROGS  =3D fio
 SCRIPTS =3D $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio=
2gnuplot tools/genfio tools/fiologparser.py)


I get a working build:

# hardening-check fio
fio:
 Position Independent Executable: yes
 Stack protected: no, not found!
 Fortify Source functions: yes (some protected functions found)
 Read-only relocations: no, not found!
 Immediate binding: no, not found!

Well, I wonder about:

You set CFLAGS hard without +=3D, maybe thats the issue, unless dpkg stuffe=
s
the build flags into BUILD_CFLAGS or so.


Yes, that is it:

A patch as simple as

=E2=80=A6 pkg-fio> cat debian/patches/makefile-hardening=20
--- a/Makefile
+++ b/Makefile
@@ -23,7 +23,7 @@
 DEBUGFLAGS =3D -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG
 CPPFLAGS=3D -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -DFIO_INTERNAL $(=
DEBUGFLAGS)
 OPTFLAGS=3D -g -ffast-math
-CFLAGS =3D -std=3Dgnu99 -Wwrite-strings -Wall -Wdeclaration-after-statemen=
t $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
+CFLAGS +=3D -std=3Dgnu99 -Wwrite-strings -Wall -Wdeclaration-after-stateme=
nt $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
 LIBS   +=3D -lm $(EXTLIBS)
 PROGS  =3D fio
 SCRIPTS =3D $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio=
2gnuplot tools/genfio tools/fiologparser.py)


Does the trick. Seems that Debian set some linker flag and the compiler fla=
g
was not set, leading to:

> > /usr/bin/ld: crc/crc16.o: relocation R_X86_64_32S against `crc16_table'
> > can
> > not be used when making a shared object; recompile with -fPIC


Will create a patch to merge for you.

Thanks,

--=20
Martin Steigerwald  | Trainer

teamix GmbH
S=C3=BCdwestpark 43
90449 N=C3=BCrnberg

Tel.:  +49 911 30999 55 | Fax: +49 911 30999 99
mail: martin.steigerwald@teamix.de | web:  http://www.teamix.de | blog: htt=
p://blog.teamix.de

Amtsgericht N=C3=BCrnberg, HRB 18320 | Gesch=C3=A4ftsf=C3=BChrer: Oliver K=
=C3=BCgow, Richard M=C3=BCller

teamix Support Hotline: +49 911 30999-112
=20
 Flexibilit=C3=A4t im Haus =E2=80=93 Sicherheit im Kopf, testen Sie jetzt 3=
0 Tage kostenfrei unsere Cloud Backup L=C3=B6sung FlexVault: www.teamix.de/=
cloud-backup=20


