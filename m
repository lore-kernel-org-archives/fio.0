Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAE7O3TeXoojLZey-pskumfEx_6zh3D+NSnvVO+wyKju4K__bUA@mail.gmail.com>
References: <20161215202937.GD29056@kernel.dk> <CAE7O3TeXoojLZey-pskumfEx_6zh3D+NSnvVO+wyKju4K__bUA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 17 Dec 2016 16:34:50 +0000
Message-ID: <CALjAwxhoEp=VCM3=YqLcKGJTQmGArnATKrniQiX3HKdXrv-gBA@mail.gmail.com>
Subject: Re: "fio --server" on Windows -> "fio: waitpid: Function not implemented"
Content-Type: text/plain; charset=UTF-8
To: contactme@olausson.de
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 16 December 2016 at 14:09,  <contactme@olausson.de> wrote:
> Hello Jens,
>
> bad news, but good to know.
>
> Is there any way to run "fio --server" on Windows? Maybe "native" cygwin?
> If that would be possible, how would I compile it?
>
> When I run "configure" it automatically detects Windows and tries to
> use mingw32 (which I don't want to use)
>
> root@WIN-OJQRIHLM3VR ~/fio/fio-fio-2.15
> $ make
> FIO_VERSION = fio-2.15
>     CC crc/crc64.o
> /bin/sh: x86_64-w64-mingw32-gcc: command not found
> make: *** [Makefile:314: crc/crc64.o] Error 127

Fixing the configure script to default to a different compiler will
only be the start - you will also need to add code to teach the fio
build about the "cygwin" platform. This will involve multiple changes
such as including different headers, linking against the different
libraries and calling cygwin functions (such as fork) rather than the
current Windows stubs...

-- 
Sitsofe | http://sucs.org/~sits/

