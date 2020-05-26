Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
References: <7da03194-c1b4-34cc-cf36-a7b53914d778@kernel.dk> <9d59f40e-8af1-fc54-8c00-1661f6cd15da@bsdio.com>
In-Reply-To: <9d59f40e-8af1-fc54-8c00-1661f6cd15da@bsdio.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Tue, 26 May 2020 22:29:39 +0900
Message-ID: <CAHndrBkXW16W=D9_kK08MWJwLYNhGmJoD1T3G9EV=QV-toy3qQ@mail.gmail.com>
Subject: Re: Pending 3.20 release
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Rebecca Cran <rebecca@bsdio.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, alexey Dobriyan <adobriyan@gmail.com>, Damien Le Moal <damien.lemoal@wdc.com>, Sitsofe Wheeler <sitsofe@gmail.com>
List-ID: <fio@vger.kernel.org>

2020=E5=B9=B45=E6=9C=8826=E6=97=A5(=E7=81=AB) 13:03 Rebecca Cran <rebecca@b=
sdio.com>:
>
> On 5/21/20 8:40 AM, Jens Axboe wrote:
>
> > Let me know if you have pending items that should go into 3.20,
> > or if you're happy with the current state.
>
> I've not run fio on FreeBSD for a while, and just noticed a couple of
> things - which fortunately aren't blockers since I see you've already
> tagged 3.20 :)
>
> Running "./fio --help" prints the usage information and then pauses for
> about a second. Interrupting it and looking at the backtrace shows:

I've git-bisected this.
The delay was caused by this commit which first appeared in fio-3.17.
Note that fio on NetBSD didn't show this delay.

commit 43661a66a8c3b9fb5ff28b463c9ab0aac91a0355 (refs/bisect/bad)
Date:   Tue Oct 8 16:13:02 2019 -0700
    Increase MAX_FILELOCKS for highly parallel IO test


>
>
> (gdb) bt
> #0  _umtx_op () at _umtx_op.S:4
> #1  0x00000008007260b0 in pshared_gc (curthread=3D0x801212000) at
> /usr/src/lib/libthr/thread/thr_pshared.c:110
> #2  __thr_pshared_destroy (key=3D<optimized out>) at
> /usr/src/lib/libthr/thread/thr_pshared.c:253
> #3  0x0000000800720023 in _thr_mutex_destroy (mutex=3D0x801809bd8) at
> /usr/src/lib/libthr/thread/thr_mutex.c:482
> #4  0x0000000000268d97 in __fio_sem_remove (sem=3D0x801809bd8) at fio_sem=
.c:20
> #5  0x000000000028db35 in fio_filelock_exit () at filelock.c:104
> #6  0x0000000000244ead in free_shm () at init.c:335
> #7  0x000000080091be25 in __cxa_finalize (dso=3D0x0) at
> /usr/src/lib/libc/stdlib/atexit.c:240
> #8  0x00000008008aea71 in exit (status=3D0) at
> /usr/src/lib/libc/stdlib/exit.c:74
> #9  0x000000000024495c in parse_cmd_line (argc=3D2, argv=3D0x7fffffffeaa0=
,
> client_type=3D1) at init.c:2901
> #10 0x0000000000244f02 in parse_options (argc=3D2, argv=3D0x7fffffffeaa0)=
 at
> init.c:2958
> #11 0x000000000029828a in main (argc=3D2, argv=3D0x7fffffffeaa0,
> envp=3D<optimized out>) at fio.c:42
>
>
> Also, building on FreeBSD or Linux with clang 10.0 produces lots of
> warnings. I've uploaded the build log to
> http://bex.dev/typescript-fio320-clang10-linux .
>
> An example of the warnings:
>
> crc/../arch/../lib/rand.h:109:25: warning: implicit conversion from
> 'unsigned long long' to 'double' changes value from 18446744073709551615
> to 18446744073709551616 [-Wimplicit-int-float-conversion]
>                  return (val + 1.0) / (FRAND64_MAX + 1.0);
>                                        ^~~~~~~~~~~ ~
> crc/../arch/../lib/rand.h:9:22: note: expanded from macro 'FRAND64_MAX'
> #define FRAND64_MAX     (-1ULL)
>                           ^~~~~
> crc/../arch/../lib/rand.h:136:41: warning: implicit conversion from
> 'unsigned long long' to 'double' changes value from 18446744073709551615
> to 18446744073709551616 [-Wimplicit-int-float-conversion]
>          return (uint64_t) ((double)end * (r / (FRAND64_MAX + 1.0)));
>                                                 ^~~~~~~~~~~ ~
> crc/../arch/../lib/rand.h:9:22: note: expanded from macro 'FRAND64_MAX'
> #define FRAND64_MAX     (-1ULL)
>                           ^~~~~
> 2 warnings generated.
> crc/murmur3.c:33:2: warning: unannotated fall-through between switch
> labels [-Wimplicit-fallthrough]
>          case 2:
>          ^
> crc/murmur3.c:33:2: note: insert '__attribute__((fallthrough));' to
> silence this warning
>          case 2:
>          ^
>          __attribute__((fallthrough));
> crc/murmur3.c:33:2: note: insert 'break;' to avoid fall-through
>          case 2:
>          ^
>          break;
> crc/murmur3.c:36:2: warning: unannotated fall-through between switch
> labels [-Wimplicit-fallthrough]
>          case 1:
>          ^
> crc/murmur3.c:36:2: note: insert '__attribute__((fallthrough));' to
> silence this warning
>          case 1:
>          ^
>          __attribute__((fallthrough));
> crc/murmur3.c:36:2: note: insert 'break;' to avoid fall-through
>          case 1:
>          ^
>          break;
>
> --
> Rebecca Cran
>

