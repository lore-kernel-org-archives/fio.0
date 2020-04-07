Return-Path: <prvs=35932a8d3=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/4] Generalize zonemode=zbd
Date: Tue,  7 Apr 2020 10:58:56 +0900
Message-Id: <20200407015900.1335019-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

This series extend support for zonemode=zbd beyond Linux only and as is
allows the use of this zonemode on any platform with regular block
devices. The same also applies to Linux systems that do not have zoned
block device support (e.g. enterprise distributions with kernels version
lower than 4.10). For zoned block device support, Linux implementation
is preserved. Other OS specific code can be added with automatic
configuration with the configure script to add zoned block device
support.

Additionally, ioengine operations are updated to allow an IO engine to
provide implementations for the zone operations needed to support zoned
block devices. This is convenient for cases where the system OS/kernel
does not have any support implementation available.

Finally, the libzbc IO engine is introduced to support zoned block
devices on Linux distributions without native kernel level support (E.g.
RedHat/CentOS). SImilarly to the sg ioengine, this new IO engine usesi
passthrough commands implemeted by libzbc API to directly access SMR
drives.

Comments are as always welcome.

Damien Le Moal (2):
  fio: Generalize zonemode=zbd
  ioengines: Add zoned block device operations

Dmitry Fomichev (2):
  fio: Introduce libzbc IO engine
  t/zbd: Add support for libzbc IO engine tests

 Makefile                    |   9 +-
 configure                   |  36 ++-
 engines/libzbc.c            | 422 ++++++++++++++++++++++++++++++++++++
 engines/skeleton_external.c |  43 ++++
 fio.1                       |   6 +
 fio.h                       |   2 -
 io_u.h                      |   2 -
 ioengines.h                 |   9 +-
 options.c                   |   3 +-
 oslib/blkzoned.h            |  49 +++++
 oslib/linux-blkzoned.c      | 219 +++++++++++++++++++
 t/run-fio-tests.py          |   2 +-
 t/zbd/functions             |  38 +++-
 t/zbd/test-zbd-support      | 221 ++++++++++++-------
 zbd.c                       | 396 ++++++++++++++++-----------------
 zbd.h                       |  70 +-----
 zbd_types.h                 |  57 +++++
 17 files changed, 1219 insertions(+), 365 deletions(-)
 create mode 100644 engines/libzbc.c
 create mode 100644 oslib/blkzoned.h
 create mode 100644 oslib/linux-blkzoned.c
 create mode 100644 zbd_types.h

-- 
2.25.1


