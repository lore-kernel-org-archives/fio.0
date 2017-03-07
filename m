Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 00/17]
Date: Tue,  7 Mar 2017 22:12:51 +0200
Message-Id: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

The first 3 patches are resend of what I've sent after 2.18,
except that I've modified commit messages a bit.

  Add runtime handlers for 97900ebf for FreeBSD/DragonFlyBSD
  HOWTO: Add platforms without fdatasync(2)
  configure: Align help messages

Tomohiro Kusumi (17):
  Add runtime handlers for 97900ebf for FreeBSD/DragonFlyBSD
  HOWTO: Add platforms without fdatasync(2)
  configure: Align help messages
  Avoid irrelevant "offset extend ends" error message for chrdev
  Fix debug print format of file ->file_name
  Fixup for a minor 0 byte file size case
  Explicitly check td_trim(td) to detect open(2) flag
  Drop redundant td_rw(td) tests
  Remove unassigned fio_unused variable
  Drop fio_unused attribute from used variable
  Fix a function name typo in debug print
  Don't set FIO_FILE_extend when create_on_open= option is set
  Minor fixup for "Layint out IO file..." message
  HOWTO: Add some details for invalidate=
  Define struct file_name as a file local structure
  Use union for per file engine private data storage
  configure: Make Cygwin take regular configure path

 HOWTO                    |   8 +-
 backend.c                |   2 +-
 configure                | 320 +++++++++++++++++++++++++++++++++--------------
 engines/glusterfs_sync.c |   2 +-
 engines/pmemblk.c        |  16 +--
 engines/sync.c           |   2 +-
 file.h                   |  17 ++-
 filesetup.c              |  76 ++++++++---
 fio.h                    |   2 +-
 init.c                   |  13 +-
 io_u.c                   |   4 +-
 os/os-dragonfly.h        |  14 ++-
 os/os-freebsd.h          |  15 ++-
 os/os-linux.h            |   5 +
 os/os-openbsd.h          |  12 +-
 os/os.h                  |   7 ++
 rate-submit.c            |   1 -
 verify.c                 |   2 +-
 18 files changed, 359 insertions(+), 159 deletions(-)

-- 
2.9.3


