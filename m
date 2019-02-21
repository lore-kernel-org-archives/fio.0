Return-Path: <prvs=94868c4cd=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 0/9] ZBD support fixes
Date: Thu, 21 Feb 2019 13:10:58 +0900
Message-Id: <20190221041107.8576-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Matias Bjorling <matias.bjorling@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

This patch series fixes various problems with fio zbd support discovered
with extensive testing on various test targets (null_blk, iscsi/tcmu
device, SMR disk, partition devices, etc).

In more details:
* Patch 1 fixes the discovery of a block device zone model to correctly
  handle block devices that are partitions.
* Patch 2 addresses a problem with the SG engine and devices not
  supporting the READ CAPACITY(10) command.
* Patch 3 cleans up the SG engine code with helper functions to handle
  big-endian SCSI cdb fields.
* Patch 4 to 6 fix the zbd support tests to avoid incorrect failures
  reports.
* Patch 7 and 8 fix zone locking handling to avoid write command
  reordering with multi-jobs workloads with asynchronous I/O engines.
  These changes do have a significant impact on the performance reported
  for very small (test) devices with a high number of jobs. The worst
  degradation observed result in libaio performance being equal to that
  of the synchronous psync engine. There is however no noticeable
  performance degradation with real disks as the large number of zones
  with these drives do not cause excessive zone lock contention.
* Patch 9 introduces a new zbd test case 46 to test asynchronous
  muli-job writes.

All these fixes are necessary for correctly running blktests with
different target devices, and to also implement further blktests
zbd test group to improve test coverage.

As always, comments are very welcome.

Changes from v1:
* Addressed Bart's comments for SG engine changes (added patch 3)
* Fixed patch 5 as suggested by Bart

Damien Le Moal (4):
  t/zbd: Fix test 2 and 3 result handling
  zbd: Fix zone locking for async I/O engines
  zbd: Avoid async I/O multi-job workload deadlock
  t/zbd: Add multi-job libaio test

Dmitry Fomichev (2):
  sg: Avoid READ CAPACITY failures
  sg: Clean up handling of big endian data fields

Shin'ichiro Kawasaki (3):
  zbd: Fix partition block device handling
  t/zbd: Fix handling of partition devices
  t/zbd: Default to using blkzone tool

 engines/sg.c           | 127 ++++++++++++++++++++++------------------
 io_u.c                 |  10 +---
 io_u.h                 |  17 +++++-
 ioengines.c            |   6 +-
 os/os.h                |  24 ++++++++
 t/zbd/functions        |  25 ++++++--
 t/zbd/test-zbd-support |  34 ++++++++---
 zbd.c                  | 129 +++++++++++++++++++++++++++++++++++------
 zbd.h                  |  22 +++++++
 9 files changed, 289 insertions(+), 105 deletions(-)

-- 
2.20.1


