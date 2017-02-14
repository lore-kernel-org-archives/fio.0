Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH v2 0/7]
Date: Tue, 14 Feb 2017 17:19:41 +0200
Message-Id: <20170214151948.16460-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

configure: Use x86 instead of i386 for $cpu for IA32
  Added "This change should have been a part of e12f4ede in 2016.".

Acquire file ->lock while the lock itself is being copied
  Rewrote the locking using (un)lock_file().

Tomohiro Kusumi (7):
  configure: Drop default CONFIG_LITTLE_ENDIAN for Cygwin
  configure: Use x86 instead of i386 for $cpu for IA32
  Drop conditional declaration of disk_list
  Always set ->real_file_size to -1 when failed to get file size
  Add missing "rand"/"trimwrite" strings to corresponding ddir slots
  Acquire file ->lock while the lock itself is being copied
  Use 0 instead of DDIR_READ to iterate from 0 to DDIR_RWDIR_CNT

 configure        |  3 +--
 diskutil.c       |  2 --
 engines/falloc.c |  2 +-
 eta.c            |  6 +++---
 file.h           |  2 +-
 filesetup.c      | 18 +++++++++++-------
 io_ddir.h        |  4 ++--
 io_u.c           |  6 +++---
 libfio.c         |  5 -----
 stat.c           |  4 ++--
 steadystate.c    |  2 +-
 11 files changed, 25 insertions(+), 29 deletions(-)

-- 
2.9.3


