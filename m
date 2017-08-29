Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/6] OS specific fixes
Date: Wed, 30 Aug 2017 00:12:10 +0300
Message-Id: <20170829211216.42347-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>


Tomohiro Kusumi (6):
  cleanup NetBSD/OpenBSD header
  HOWTO: add OpenBSD to direct I/O unsupported platform
  add ifdef __sun__ for Solaris specific code
  filesetup: add non O_DIRECT direct I/O support for initial layout
    setup
  change fio_set_odirect() prototype not to use int fd
  change os_trim() prototype not to use int fd

 HOWTO             |  2 +-
 file.h            |  1 +
 filesetup.c       | 31 +++++++++++++++++++++++++++++++
 fio.1             |  2 +-
 io_u.c            |  2 +-
 ioengines.c       | 22 ++--------------------
 os/os-android.h   |  4 ++--
 os/os-dragonfly.h |  4 ++--
 os/os-freebsd.h   |  4 ++--
 os/os-linux.h     |  4 ++--
 os/os-mac.h       |  4 ++--
 os/os-netbsd.h    |  6 ++----
 os/os-openbsd.h   |  6 ++----
 os/os-solaris.h   |  4 ++--
 14 files changed, 53 insertions(+), 43 deletions(-)

-- 
2.9.5


