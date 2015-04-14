Return-Path: <dehrenberg@google.com>
Return-Path: <dehrenberg@google.com>
Sender: Daniel Ehrenberg <dehrenberg@google.com>
From: Dan Ehrenberg <dehrenberg@chromium.org>
Subject: [PATCH 0/7] Framework for NAND lifetime testing
Date: Tue, 14 Apr 2015 15:58:13 -0700
Message-Id: <1429052300-9822-1-git-send-email-dehrenberg@chromium.org>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: gwendal@chromium.org, Dan Ehrenberg <dehrenberg@chromium.org>
List-ID: <fio@vger.kernel.org>

My goal here is to be able to qualify and characterize NAND flash
by running fio job files on it. The major problem with NAND is that
it wears out. The most basic thing to test is how long it takes
blocks to wear out with repeated program/erase cycles.

Linux exposes NAND devices, among other things, with the MTD
subsystem. That system allows the proper read, write and erase block
sizes which vary in ways unlike normal block devices. For many MTD
devices, blocks must be erased before writing them, and some have
to be written in sequential order.

This patch series adds
- an MTD ioengine, interpreting trim as erase.
- a new writetrim workload to alternate between writes and
  trims in a way that makes sense for devices which need to be
  erased before sequential writes.
- a histogram counting the first trim block where an error
  occurred, which corresponds to block lifetime in the case of
  NAND.

Dan Ehrenberg (7):
  Allow trim on any file type
  Add new writetrim rw= mode for trims preceding writes
  Collect a block-wise histogram of trim and write errors
  mtd: Add CONFIG_MTD to ./configure script
  mtd: Import libmtd with modifications to make it compile
  mtd: ioengine
  mtd: example job file

 HOWTO               |   29 +-
 Makefile            |    5 +
 backend.c           |    5 +
 client.c            |    4 +
 configure           |   20 +
 engines/mtd.c       |  209 ++++++++
 examples/mtd.fio    |   21 +
 filesetup.c         |   26 +-
 fio.1               |   21 +-
 init.c              |    7 +
 io_ddir.h           |    3 +
 io_u.c              |   25 +-
 iolog.c             |   12 +
 lib/libmtd.c        | 1424 +++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/libmtd.h        |  354 +++++++++++++
 lib/libmtd_common.h |  223 ++++++++
 lib/libmtd_int.h    |  109 ++++
 lib/libmtd_legacy.c |  384 ++++++++++++++
 lib/libmtd_xalloc.h |  106 ++++
 options.c           |   34 +-
 options.h           |    2 +
 server.c            |    4 +
 stat.c              |  199 +++++++
 stat.h              |   27 +
 thread_options.h    |    6 +
 25 files changed, 3241 insertions(+), 18 deletions(-)
 create mode 100644 engines/mtd.c
 create mode 100644 examples/mtd.fio
 create mode 100644 lib/libmtd.c
 create mode 100644 lib/libmtd.h
 create mode 100644 lib/libmtd_common.h
 create mode 100644 lib/libmtd_int.h
 create mode 100644 lib/libmtd_legacy.c
 create mode 100644 lib/libmtd_xalloc.h

-- 
2.2.0.rc0.207.ga3a616c


