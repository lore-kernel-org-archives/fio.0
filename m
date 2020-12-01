Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 0/9] v1 Patchset : Simple Copy Command support
Date: Tue,  1 Dec 2020 17:10:25 +0530
Message-Id: <20201201114034.8307-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20201201114048epcas5p3e12de26128ce442bbe8406082eaccde9@epcas5p3.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

This patchset adds support for TP4065a ("Simple Copy Command") v2020.05.04 ("Ratified")

The Specification can be found in following link.
https://nvmexpress.org/wp-content/uploads/NVM-Express-1.4-Ratified-TPs-1.zip

Simple copy command is a copy offloading operation and is used to copy
multiple contiguous ranges (source_ranges) of LBA's to a single destination
LBA within the device, reducing traffic between host and device.

In this implementation we introduce a new copy operation.
The copy operation can be enabled by passing
rw=copy (Generates sequential source ranges)
rw=randcopy (Generates random source ranges)

copy operation requires two new options to be passed
num_range - Number of ranges per copy operation.
dest_offset - Start of the destination offset.

The existing FIO options will be used as
offset - Starting offset of the source range.
blocksize - Number of logical blocks per source range.

Introduced a new synchronous ioengine "sctl".
This is a basic ioengine which supports only copy command.

Added a basic sequential copy support for Zoned block devices.

This is a RFC and the Linux Kernel interface is under submission and review.
https://lore.kernel.org/linux-nvme/20201201053949.143175-1-selvakuma.s1@samsung.com/

Feedback / Comments will help in improving this further.

Ankit Kumar (9):
  Adding the necessary ddir changes to introduce copy operation.
  Introducing new offsets for the copy operation.
  Added support for printing of stats and estimate time for copy
    operation.
  Adding a new copy operation.
  Added the changes for copy operation support in FIO.
  New ioctl based synchronous IO engine. Only supports copy command
  Example configuration for simple copy command
  Support copy operation for zoned block devices.
  Add a new test case to test the copy operation.

 HOWTO                  |  28 +++++-
 Makefile               |   2 +-
 backend.c              |  25 ++++-
 cconv.c                |   6 ++
 engines/sctl.c         | 215 +++++++++++++++++++++++++++++++++++++++++
 eta.c                  |  31 ++++--
 examples/fio-copy.fio  |  32 ++++++
 file.h                 |   7 ++
 filesetup.c            |  79 +++++++++++++++
 fio.1                  |  25 ++++-
 fio.h                  |  12 +++
 init.c                 |  44 ++++++---
 io_ddir.h              |  22 +++--
 io_u.c                 | 105 ++++++++++++++++----
 io_u.h                 |   3 +
 options.c              |  64 +++++++++++-
 os/os-linux.h          |   1 +
 parse.c                |  28 ++++++
 parse.h                |   2 +
 rate-submit.c          |   2 +
 stat.c                 |  20 +++-
 stat.h                 |   1 -
 t/zbd/functions        |   9 ++
 t/zbd/test-zbd-support |  54 +++++++++++
 thread_options.h       |   9 +-
 zbd.c                  |  90 +++++++++++++++--
 26 files changed, 842 insertions(+), 74 deletions(-)
 create mode 100644 engines/sctl.c
 create mode 100644 examples/fio-copy.fio

-- 
2.17.1


