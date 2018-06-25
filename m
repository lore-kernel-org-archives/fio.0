Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
References: <4b983c90-e07f-cd1f-abcb-65e23be8a102@bluestop.org>
In-Reply-To: <4b983c90-e07f-cd1f-abcb-65e23be8a102@bluestop.org>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Mon, 25 Jun 2018 12:04:16 +0900
Message-ID: <CAHndrBndTLseKwcSfNoYZR4vspEqg5CLOGMuJoYaBpTa-EV2sw@mail.gmail.com>
Subject: Re: FIO build broken on FreeBSD 11.1
Content-Type: text/plain; charset="UTF-8"
To: Rebecca Cran <rebecca@bluestop.org>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Rebecca Cran <rebecca@bluestop.org>:
>
> The FIO build seems to be broken on FreeBSD:

It compiles on my environment.

[root@freebsd fio]# uname -r
11.1-RELEASE
[root@freebsd fio]# clang --version
FreeBSD clang version 4.0.0 (tags/RELEASE_400/final 297347) (based on
LLVM 4.0.0)
Target: x86_64-unknown-freebsd11.1
Thread model: posix
InstalledDir: /usr/bin
[root@freebsd fio]# gmake clean
FIO_VERSION = fio-3.7-43-g9caa
[root@freebsd fio]# gmake > /dev/null ; echo $?
FIO_VERSION = fio-3.7-43-g9caa
0
[root@freebsd fio]# ./fio --version
fio-3.7-43-g9caa

>
> bcran@cube:~/workspace/fio % gmake
> FIO_VERSION = fio-3.7-43-g9caa
> Running configure ...
> Forcing some known good options on Windows
> compile test failed
> Configure failed, check config.log and/or the above output
> Makefile:19: config-host.mak: No such file or directory
> gmake: *** [Makefile:10: config-host.mak] Error 1
> bcran@cube:~/workspace/fio % cat config.log
> # FIO configure log Sun Jun 24 20:30:50 MDT 2018
> # Configured with: './configure'
> #
> gcc -D_GNU_SOURCE -include config-host.h -c -o /tmp/fio-conf--92880-.o
> /tmp/fio-conf--92880-.c
> /tmp/fio-conf--92880-.c:2:2: error: #error __ANDROID__ not defined
>  #error __ANDROID__ not defined
>   ^
> gcc -D_GNU_SOURCE -include config-host.h -c -o /tmp/fio-conf--92880-.o
> /tmp/fio-conf--92880-.c
> /tmp/fio-conf--92880-.c:2:2: error: #error __linux__ not defined
>  #error __linux__ not defined
>   ^
> gcc -D_GNU_SOURCE -include config-host.h -c -o /tmp/fio-conf--92880-.o
> /tmp/fio-conf--92880-.c
> /tmp/fio-conf--92880-.c:2:2: error: #error __OpenBSD__ not defined
>  #error __OpenBSD__ not defined
>   ^
> gcc -D_GNU_SOURCE -include config-host.h -c -o /tmp/fio-conf--92880-.o
> /tmp/fio-conf--92880-.c
> /tmp/fio-conf--92880-.c:2:2: error: #error __NetBSD__ not defined
>  #error __NetBSD__ not defined
>   ^
> gcc -D_GNU_SOURCE -include config-host.h -c -o /tmp/fio-conf--92880-.o
> /tmp/fio-conf--92880-.c
> /tmp/fio-conf--92880-.c:2:2: error: #error __sun__ not defined
>  #error __sun__ not defined
>   ^
> gcc -D_GNU_SOURCE -include config-host.h -c -o /tmp/fio-conf--92880-.o
> /tmp/fio-conf--92880-.c
> x86_64-w64-mingw32-gcc -D_GNU_SOURCE -include config-host.h
> -D_WIN32_WINNT=0x0601 -c -o /tmp/fio-conf--92880-.o /tmp/fio-conf--92880-.c
> ./configure: x86_64-w64-mingw32-gcc: not found
> x86_64-w64-mingw32-gcc -D_GNU_SOURCE -include config-host.h
> -D_WIN32_WINNT=0x0601 -c -o /tmp/fio-conf--92880-.o /tmp/fio-conf--92880-.c
> ./configure: x86_64-w64-mingw32-gcc: not found
> x86_64-w64-mingw32-gcc -D_GNU_SOURCE -include config-host.h
> -D_WIN32_WINNT=0x0601 -c -o /tmp/fio-conf--92880-.o /tmp/fio-conf--92880-.c
> ./configure: x86_64-w64-mingw32-gcc: not found
> x86_64-w64-mingw32-gcc -D_GNU_SOURCE -include config-host.h
> -D_WIN32_WINNT=0x0601 -c -o /tmp/fio-conf--92880-.o /tmp/fio-conf--92880-.c
> ./configure: x86_64-w64-mingw32-gcc: not found
> x86_64-w64-mingw32-gcc -D_GNU_SOURCE -include config-host.h
> -D_WIN32_WINNT=0x0601 -c -o /tmp/fio-conf--92880-.o /tmp/fio-conf--92880-.c
> ./configure: x86_64-w64-mingw32-gcc: not found
> x86_64-w64-mingw32-gcc -D_GNU_SOURCE -include config-host.h
> -D_WIN32_WINNT=0x0601 -c -o /tmp/fio-conf--92880-.o /tmp/fio-conf--92880-.c
> ./configure: x86_64-w64-mingw32-gcc: not found
> x86_64-w64-mingw32-gcc -D_GNU_SOURCE -include config-host.h
> -D_WIN32_WINNT=0x0601 -c -o /tmp/fio-conf--92880-.o /tmp/fio-conf--92880-.c
> ./configure: x86_64-w64-mingw32-gcc: not found
> x86_64-w64-mingw32-gcc -D_GNU_SOURCE -include config-host.h
> -D_WIN32_WINNT=0x0601 -c -o /tmp/fio-conf--92880-.o /tmp/fio-conf--92880-.c
> ./configure: x86_64-w64-mingw32-gcc: not found
> x86_64-w64-mingw32-gcc -D_GNU_SOURCE -include config-host.h
> -D_WIN32_WINNT=0x0601 -c -o /tmp/fio-conf--92880-.o /tmp/fio-conf--92880-.c
> ./configure: x86_64-w64-mingw32-gcc: not found
> x86_64-w64-mingw32-gcc -D_GNU_SOURCE -include config-host.h
> -D_WIN32_WINNT=0x0601 -c -o /tmp/fio-conf--92880-.o /tmp/fio-conf--92880-.c
> ./configure: x86_64-w64-mingw32-gcc: not found
> Compiling test case cross
> x86_64-w64-mingw32-gcc -D_GNU_SOURCE -include config-host.h
> -D_WIN32_WINNT=0x0601 -o /tmp/fio-conf--92880-.exe /tmp/fio-conf--92880-.c
> ./configure: x86_64-w64-mingw32-gcc: not found
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

