Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/8] option/Makefile fix and void* fixups
Date: Sat, 24 Jun 2017 01:07:53 +0300
Message-Id: <20170623220801.38178-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

3/8 to 8/8 are the continuation of void* fixups from below,
but this time in non-ioengine code.
This is it and no more of this void* patches...

http://www.spinics.net/lists/fio/msg05912.html
>   sg: don't use void* for pointer arithmetic (gcc)
>   splice: don't use void* for pointer arithmetic (gcc)
>   binject: don't use void* for pointer arithmetic (gcc)

Tomohiro Kusumi (8):
  ignore directory= if the given path is absolute
  Makefile: use fmt(1) rather than tr(1) on NetBSD/etc
  server: don't use void* for pointer arithmetic (gcc)
  io_u: don't use void* for pointer arithmetic (gcc)
  init: don't use void* for pointer arithmetic (gcc)
  client: don't use void* for pointer arithmetic (gcc)
  verify: don't use void* for pointer arithmetic (gcc)
  smalloc: don't use void* for pointer arithmetic (gcc)

 HOWTO            |  3 ++-
 Makefile         | 10 ++++++++++
 client.c         | 12 ++++++------
 filesetup.c      | 10 +++++++---
 init.c           |  2 +-
 io_u.c           |  2 +-
 server.c         |  5 +++--
 smalloc.c        |  2 +-
 t/verify-state.c |  3 ++-
 verify-state.h   |  2 +-
 verify.c         |  7 ++++---
 11 files changed, 38 insertions(+), 20 deletions(-)

-- 
2.9.4


