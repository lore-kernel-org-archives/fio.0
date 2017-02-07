Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 7 Feb 2017 07:31:12 +0000
Message-ID: <CALjAwxjTmrDkpmDK8iTVngtL5Kd1k=AS8m0Ao+NNS1iQWKW1VQ@mail.gmail.com>
Subject: __compiler_offsetof in fio's flist.h
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

In flist.h (https://github.com/axboe/fio/blob/fio-2.17/flist.h#L6 )
there's the following:
#undef offsetof
#ifdef __compiler_offsetof
#define offsetof(TYPE,MEMBER) __compiler_offsetof(TYPE,MEMBER)
#else
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
#endif

The problem is that __compiler_offsetof usually not defined (in the
Linux kernel it gets set when you are using gcc 4+ -
http://lxr.free-electrons.com/source/include/linux/compiler-gcc4.h?v=3.8#L14
. This leads to a hand rolled offsetof being used that can trigger
undefined behaviour checks
(https://en.wikipedia.org/wiki/Offsetof#Implementation ).

While it's possible to produce a configure check that tests for
__builtin_offsetof and adds -D__compiler_offsetof=__builtin_offsetof
to the CFLAGS is there any particular reason why the offsetof from
stdlib (which will avoid undefined behaviour if possible) is replaced?

-- 
Sitsofe | http://sucs.org/~sits/

