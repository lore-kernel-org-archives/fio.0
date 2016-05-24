Return-Path: <ms@teamix.de>
From: Martin Steigerwald <ms@teamix.de>
Subject: hardening fio build with PIE for Address Space Layout Randomization and bindnow linking
Date: Tue, 24 May 2016 12:10:27 +0200
Message-ID: <6243211.bqPIL7RjHY@merkaba>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hello Jens!

In my attempt to harden the fio build as recommended within Debian, I tried=
 to=20
build it with PIE by using Debian=B4s own mechanism via dpkg-buildflags. An=
d I=20
got:

    CC diskutil.o
    CC fifo.o
    CC blktrace.o
    CC cgroup.o
    CC trim.o
    CC engines/sg.o
    CC engines/binject.o
    CC oslib/linux-dev-lookup.o
    CC fio.o
  LINK fio
/usr/bin/ld: crc/crc16.o: relocation R_X86_64_32S against `crc16_table' can=
=20
not be used when making a shared object; recompile with -fPIC
crc/crc16.o: error adding symbols: Bad value
collect2: error: ld returned 1 exit status
Makefile:399: recipe for target 'fio' failed
make[1]: *** [fio] Error 1
make[1]: Leaving directory '/home/ms/Debian/fio/pkg-fio'
dh_auto_build: make -j1 returned exit code 2
debian/rules:17: recipe for target 'build' failed
make: *** [build] Error 2
dpkg-buildpackage: error: debian/rules build gave error exit status 2


Yet, building fio 2.10 from upstream does doesn=B4t produce a shared object=
=20
file.

Any idea?




I: fio: hardening-no-pie usr/bin/fio
N:=20
N:    This package provides an ELF executable that was not compiled as a
N:    position independent executable (PIE).
N:   =20
N:    PIE is required for fully enabling Address Space Layout Randomization
N:    (ASLR), which makes "Return-oriented" attacks more difficult.
N:   =20
N:    Historically, PIE has been associated with noticeable performance
N:    overhead on i386. However, GCC-5 has implemented an optimization that
N:    can reduce the overhead significantly.
N:   =20
N:    If you use dpkg-buildflags, you may have to add hardening=3D+pie or
N:    hardening=3D+all to DEB_BUILD_MAINT_OPTIONS.
N:   =20
N:    The relevant compiler flags must be passed both to the compiler and t=
he
N:    linker (e.g. for C that would be commonly be CFLAGS and LDFLAGS).
N:   =20
N:    CAVEAT: Please keep in mind that the PIE flag (-fPIE) is not suitable
N:    for all cases:
N:   =20
N:     * It is <not> compatible with -fPIC which required for
N:       compiling shared libraries.
N:     * It is unlikely to work when compiling static libraries or
N:       executables (gcc -static).
N:   =20
N:    If your upstream build compiles either of the above, you may have to
N:    patch the build to ensure that only ELF executables are compiled with
N:    PIE.
N:   =20
N:    Refer to https://wiki.debian.org/Hardening,
N:    https://gcc.gnu.org/gcc-5/changes.html, and
N:    https://software.intel.com/en-us/blogs/2014/12/26/new-optimizations-f=
or-x86-in-upcoming-gcc-50-32bit-pic-mode
N:    for details.
N:   =20
N:    Severity: wishlist, Certainty: certain
N:   =20
N:    Check: binaries, Type: binary, udeb
N:=20
I: fio: hardening-no-pie usr/bin/fio-btrace2fio
I: fio: hardening-no-pie usr/bin/fio-dedupe
I: fio: hardening-no-pie usr/bin/fio-genzipf


Another option to harden fio works find and that is:

I: fio: hardening-no-bindnow usr/bin/fio
N:=20
N:    This package provides an ELF binary that lacks the "bindnow" linker
N:    flag.
N:   =20
N:    If the ELF binary does not rely on late binding of symbols (e.g. weak
N:    symbols), then please consider enabling this feature. Otherwise, plea=
se
N:    consider overriding the tag (possibly with a comment about why).
N:   =20
N:    If you use dpkg-buildflags, you may have to add hardening=3D+bindnow =
or
N:    hardening=3D+all to DEB_BUILD_MAINT_OPTIONS.
N:   =20
N:    The relevant compiler flags are set in LDFLAGS.
N:   =20
N:    Refer to https://wiki.debian.org/Hardening for details.
N:   =20
N:    Severity: wishlist, Certainty: certain
N:   =20
N:    Check: binaries, Type: binary, udeb
N:=20
I: fio: hardening-no-pie usr/bin/fio-btrace2fio
I: fio: hardening-no-bindnow usr/bin/fio-btrace2fio
I: fio: hardening-no-pie usr/bin/fio-dedupe
I: fio: hardening-no-bindnow usr/bin/fio-dedupe
I: fio: hardening-no-pie usr/bin/fio-genzipf
I: fio: hardening-no-bindnow usr/bin/fio-genzipf


Maybe it would be nice to have some of these in upstream build? PIE may not=
=20
yet be advisable as for GCC 5 requirement.

Thanks,

