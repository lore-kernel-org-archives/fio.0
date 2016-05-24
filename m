Return-Path: <axboe@kernel.dk>
Subject: Re: hardening fio build with PIE for Address Space Layout
 Randomization and bindnow linking
References: <6243211.bqPIL7RjHY@merkaba>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <57446277.2010705@kernel.dk>
Date: Tue, 24 May 2016 08:17:27 -0600
MIME-Version: 1.0
In-Reply-To: <6243211.bqPIL7RjHY@merkaba>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: Martin Steigerwald <ms@teamix.de>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/24/2016 04:10 AM, Martin Steigerwald wrote:
> Hello Jens!
>
> In my attempt to harden the fio build as recommended within Debian, I tri=
ed to
> build it with PIE by using Debian=EF=BF=BDs own mechanism via dpkg-buildf=
lags. And I
> got:
>
>      CC diskutil.o
>      CC fifo.o
>      CC blktrace.o
>      CC cgroup.o
>      CC trim.o
>      CC engines/sg.o
>      CC engines/binject.o
>      CC oslib/linux-dev-lookup.o
>      CC fio.o
>    LINK fio
> /usr/bin/ld: crc/crc16.o: relocation R_X86_64_32S against `crc16_table' c=
an
> not be used when making a shared object; recompile with -fPIC
> crc/crc16.o: error adding symbols: Bad value
> collect2: error: ld returned 1 exit status
> Makefile:399: recipe for target 'fio' failed
> make[1]: *** [fio] Error 1
> make[1]: Leaving directory '/home/ms/Debian/fio/pkg-fio'
> dh_auto_build: make -j1 returned exit code 2
> debian/rules:17: recipe for target 'build' failed
> make: *** [build] Error 2
> dpkg-buildpackage: error: debian/rules build gave error exit status 2
>
>
> Yet, building fio 2.10 from upstream does doesn=EF=BF=BDt produce a share=
d object
> file.
>
> Any idea?
>
>
>
>
> I: fio: hardening-no-pie usr/bin/fio
> N:
> N:    This package provides an ELF executable that was not compiled as a
> N:    position independent executable (PIE).
> N:
> N:    PIE is required for fully enabling Address Space Layout Randomizati=
on
> N:    (ASLR), which makes "Return-oriented" attacks more difficult.
> N:
> N:    Historically, PIE has been associated with noticeable performance
> N:    overhead on i386. However, GCC-5 has implemented an optimization th=
at
> N:    can reduce the overhead significantly.
> N:
> N:    If you use dpkg-buildflags, you may have to add hardening=3D+pie or
> N:    hardening=3D+all to DEB_BUILD_MAINT_OPTIONS.
> N:
> N:    The relevant compiler flags must be passed both to the compiler and=
 the
> N:    linker (e.g. for C that would be commonly be CFLAGS and LDFLAGS).
> N:
> N:    CAVEAT: Please keep in mind that the PIE flag (-fPIE) is not suitab=
le
> N:    for all cases:
> N:
> N:     * It is <not> compatible with -fPIC which required for
> N:       compiling shared libraries.
> N:     * It is unlikely to work when compiling static libraries or
> N:       executables (gcc -static).
> N:
> N:    If your upstream build compiles either of the above, you may have to
> N:    patch the build to ensure that only ELF executables are compiled wi=
th
> N:    PIE.
> N:
> N:    Refer to https://wiki.debian.org/Hardening,
> N:    https://gcc.gnu.org/gcc-5/changes.html, and
> N:    https://software.intel.com/en-us/blogs/2014/12/26/new-optimizations=
-for-x86-in-upcoming-gcc-50-32bit-pic-mode
> N:    for details.
> N:
> N:    Severity: wishlist, Certainty: certain
> N:
> N:    Check: binaries, Type: binary, udeb
> N:
> I: fio: hardening-no-pie usr/bin/fio-btrace2fio
> I: fio: hardening-no-pie usr/bin/fio-dedupe
> I: fio: hardening-no-pie usr/bin/fio-genzipf
>
>
> Another option to harden fio works find and that is:
>
> I: fio: hardening-no-bindnow usr/bin/fio
> N:
> N:    This package provides an ELF binary that lacks the "bindnow" linker
> N:    flag.
> N:
> N:    If the ELF binary does not rely on late binding of symbols (e.g. we=
ak
> N:    symbols), then please consider enabling this feature. Otherwise, pl=
ease
> N:    consider overriding the tag (possibly with a comment about why).
> N:
> N:    If you use dpkg-buildflags, you may have to add hardening=3D+bindno=
w or
> N:    hardening=3D+all to DEB_BUILD_MAINT_OPTIONS.
> N:
> N:    The relevant compiler flags are set in LDFLAGS.
> N:
> N:    Refer to https://wiki.debian.org/Hardening for details.
> N:
> N:    Severity: wishlist, Certainty: certain
> N:
> N:    Check: binaries, Type: binary, udeb
> N:
> I: fio: hardening-no-pie usr/bin/fio-btrace2fio
> I: fio: hardening-no-bindnow usr/bin/fio-btrace2fio
> I: fio: hardening-no-pie usr/bin/fio-dedupe
> I: fio: hardening-no-bindnow usr/bin/fio-dedupe
> I: fio: hardening-no-pie usr/bin/fio-genzipf
> I: fio: hardening-no-bindnow usr/bin/fio-genzipf
>
>
> Maybe it would be nice to have some of these in upstream build? PIE may n=
ot
> yet be advisable as for GCC 5 requirement.

What extra compiler/linker flags are being set? I tried with just -fPIE=20
here, and it builds and links fine.

axboe@xps13:/home/axboe/git/fio $ gcc --version
gcc (Ubuntu 6.1.1-3ubuntu11~14.04.1) 6.1.1 20160511

I have gcc 5.3 installed as well, works for that too. So I'm guessing=20
-fPIE isn't all that's being set?

--=20
Jens Axboe


