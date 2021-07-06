Return-Path: <prvs=81407a9e8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 00/11] Improve libaio IO priority support
Date: Tue,  6 Jul 2021 09:17:32 +0900
Message-Id: <20210706001743.10818-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

This series improves libaio engine support for IO priority, adding
options to allow for mixed priority workloads to be specified more
easily and to match the kernel supported IO priority features.

The first 3 patches are small cleanup and fixes in the manpage and
fiograph tool.

Patch 4 and 5 introduce some helper functions to simplify the code in
the followup patches.

Patch 6 changes the cmdprio_percentage option to allow specifying
different percentages for reads and writes.

Patch 7 and 8 introduce the aioprioclass, aioprio and aioprio_bssplit.
These together allow a script to specify different IO priorities for
reads and writes of different sizes with different percentages.

Patch 9 relaxes restrictions on the cmdprio_percentage option to allow
jobs to execute AIOs using a default priority as set with ioprio_set()
(as the kernel supports this).

Patch 10 introduces the log_prio option to log each IO priority value,
allowing users to do per-priority level performance analysis with
complex workloads using many jobs.

Finally, patch 11 adds a couple of example scripts to illustrate the use
of the new options introduced.

Comments are as always most welcome.

Damien Le Moal (11):
  manpage: fix formatting
  manpage: fix definition of prio and prioclass options
  tools: fiograph: do not overwrite input script file
  os: introduce ioprio_value() helper
  options: make parsing functions available to ioengines
  libaio,io_uring: improve cmdprio_percentage option
  libaio: introduce aioprio and aioprioclass options
  libaio: introduce aioprio_bssplit
  libaio: relax cdmprio_percentage constraints
  fio: Introduce the log_prio option
  examples: add libaio priority use examples

 HOWTO                            |  57 +++++++--
 backend.c                        |   1 +
 cconv.c                          |   2 +
 client.c                         |   2 +
 engines/filecreate.c             |   2 +-
 engines/filedelete.c             |   2 +-
 engines/filestat.c               |   2 +-
 engines/io_uring.c               |  33 +++--
 engines/libaio.c                 | 210 ++++++++++++++++++++++++++++---
 eta.c                            |   2 +-
 examples/aio-prio-bssplit.fio    |  17 +++
 examples/aio-prio-bssplit.png    | Bin 0 -> 48709 bytes
 examples/aio-prio-percentage.fio |  17 +++
 examples/aio-prio-percentage.png | Bin 0 -> 48752 bytes
 fio.1                            |  76 ++++++++---
 fio.h                            |   5 +
 init.c                           |   4 +
 io_u.c                           |  14 ++-
 io_u.h                           |  10 +-
 iolog.c                          |  45 +++++--
 iolog.h                          |  16 ++-
 options.c                        |  50 ++++----
 os/os-android.h                  |  24 ++--
 os/os-dragonfly.h                |   1 +
 os/os-linux.h                    |  24 ++--
 os/os.h                          |   4 +
 server.h                         |   3 +-
 stat.c                           |  75 +++++------
 stat.h                           |   9 +-
 thread_options.h                 |  20 +++
 tools/fiograph/fiograph.conf     |   4 +-
 tools/fiograph/fiograph.py       |   4 +-
 32 files changed, 574 insertions(+), 161 deletions(-)
 create mode 100644 examples/aio-prio-bssplit.fio
 create mode 100644 examples/aio-prio-bssplit.png
 create mode 100644 examples/aio-prio-percentage.fio
 create mode 100644 examples/aio-prio-percentage.png

-- 
2.31.1


