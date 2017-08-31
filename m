Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/5] external ioengine fixes
Date: Thu, 31 Aug 2017 23:13:03 +0300
Message-Id: <20170831201308.47933-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This is resend of below which I believe hasn't been reviewed/commented yet.

The entire diff is the exact same as the original one, but [PATCH 3/4]
has been splitted into two ([PATCH 3/5] and [PATCH 4/5] in this series),
to make diffs more clear and obvious.

[PATCH 0/4] external ioengine fixes
http://www.spinics.net/lists/fio/msg06204.html

--
Tomohiro Kusumi (5):
  skeleton: add option example
  fix broken external ioengine option
  cleanup ioengine_load() (for the next commit)
  fix load_ioengine() not to support no "external:" prefix
  add __load_ioengine() to separate ioengine loading from td context

 HOWTO                       |  4 +++-
 engines/skeleton_external.c | 32 +++++++++++++++++++++++++++++++-
 fio.1                       |  4 +++-
 init.c                      | 21 ++-------------------
 ioengines.c                 | 30 ++++++++++++++++++------------
 ioengines.h                 |  2 +-
 options.c                   | 34 ++++++++++++++++++++++++++++++++++
 thread_options.h            |  1 +
 8 files changed, 93 insertions(+), 35 deletions(-)

-- 
2.9.5


