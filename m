Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/4] HOWTO/man/option fix
Date: Mon,  7 Aug 2017 20:37:50 +0300
Message-Id: <20170807173754.80126-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

HOWTO bugs found while syncing the man page with HOWTO.
(The syncing of the man page will hopefully be done within another 1 week or so).

Tomohiro Kusumi (4):
  man: add proper indentation to "PARAMETER TYPES" section
  HOWTO: fix unit type suffix in "Parameter types" section
  HOWTO: use proper (or drop wrong usage of) option type =bool
  move skip_bad= option to engines/mtd.c

 HOWTO            |  26 ++++++------
 cconv.c          |   2 -
 engines/mtd.c    |  28 ++++++++++++-
 fio.1            | 118 ++++++++++++++++++++++++++++++++++++++-----------------
 options.c        |  11 ------
 thread_options.h |   2 -
 6 files changed, 122 insertions(+), 65 deletions(-)

-- 
2.9.4


