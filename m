Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/6] ioengine fixes
Date: Mon, 12 Jun 2017 23:02:05 +0300
Message-Id: <20170612200211.17022-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>


Tomohiro Kusumi (6):
  sg: add missing free(msg); in ->errdetails() handler
  sg: drop unneeded strdup from ->errdetails() handler
  sg: drop redundant void* cast
  sg: don't use void* for pointer arithmetic (gcc)
  splice: don't use void* for pointer arithmetic (gcc)
  binject: don't use void* for pointer arithmetic (gcc)

 engines/binject.c |  3 ++-
 engines/sg.c      | 16 ++++++++--------
 engines/splice.c  |  5 +++--
 3 files changed, 13 insertions(+), 11 deletions(-)

-- 
2.9.4


