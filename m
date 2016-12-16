Return-Path: <contactme@olausson.de>
MIME-Version: 1.0
In-Reply-To: <20161215202937.GD29056@kernel.dk>
References: <20161215202937.GD29056@kernel.dk>
From: contactme@olausson.de
Date: Fri, 16 Dec 2016 09:09:36 -0500
Message-ID: <CAE7O3TeXoojLZey-pskumfEx_6zh3D+NSnvVO+wyKju4K__bUA@mail.gmail.com>
Subject: "fio --server" on Windows -> "fio: waitpid: Function not implemented"
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hello Jens,

bad news, but good to know.

Is there any way to run "fio --server" on Windows? Maybe "native" cygwin?
If that would be possible, how would I compile it?

When I run "configure" it automatically detects Windows and tries to
use mingw32 (which I don't want to use)

root@WIN-OJQRIHLM3VR ~/fio/fio-fio-2.15
$ make
FIO_VERSION = fio-2.15
    CC crc/crc64.o
/bin/sh: x86_64-w64-mingw32-gcc: command not found
make: *** [Makefile:314: crc/crc64.o] Error 127

root@WIN-OJQRIHLM3VR ~/fio/fio-fio-2.15
$

Cheers,
Bjoern

