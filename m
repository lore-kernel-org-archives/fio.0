Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/5]
Date: Tue, 23 May 2017 21:44:44 +0300
Message-Id: <20170523184449.48134-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

These are another cleanup patches to make it less OS dependent
(less Linux dependent).

Tomohiro Kusumi (5):
  Move {is,load}_blktrace() to a new header blktrace.h
  Drop struct thread_data dependency from os headers
  Drop circular dependency in log.c and lib/output_buffer.c
  Move Linux/ppc64 specific cpu_online() to os/os-linux.h
  Include sg headers in os/os-linux.h

 blktrace.c          |  1 +
 blktrace.h          | 23 +++++++++++++++++++++++
 fio.h               |  8 --------
 init.c              | 10 +++++++---
 iolog.c             |  1 +
 lib/output_buffer.c |  8 +-------
 lib/output_buffer.h |  2 +-
 log.c               |  6 ++++++
 os/os-linux.h       | 10 ++++++++++
 os/os-windows.h     |  4 +---
 os/os.h             | 34 +---------------------------------
 stat.c              |  6 ++++--
 12 files changed, 56 insertions(+), 57 deletions(-)
 create mode 100644 blktrace.h

-- 
2.9.4


