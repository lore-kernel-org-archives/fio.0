Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/4] external ioengine fixes
Date: Tue, 22 Aug 2017 21:00:25 +0300
Message-Id: <20170822180029.17084-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Tomohiro Kusumi (4):
  skeleton: add option example
  fix broken external ioengine option
  fix/cleanup load_ioengine() [1/2]
  fix/cleanup load_ioengine() [2/2]

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


