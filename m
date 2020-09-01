Return-Path: <prvs=50667a661=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 0/7] Improve open zones accounting
Date: Tue,  1 Sep 2020 17:19:59 +0900
Message-Id: <20200901082006.1476720-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The max_open_zones and job_max_open_zones option control number of write target
open zones within the specified limit. Currently, this write target zone
accounting is not accurate enough. Even with these options set, the limits can
exceed during write workloads.

This patch series improves accuracy of the open zones accounting. The first
patch moves the moment to decrement number of currently open zones from write
command submit to write command completion. This avoids zone writes beyond the
limit caused by concurrent write commands at queue depths approaching the max
limits. The second and third patches fix the open zone status initialization
issue. Other following patches improve t/zbd scripts to take maximum write
target zone limit and allow to test devices with the limit.

Changes from v2:
* Improved code comment per review on the list

Changes from v1:
* Improved open zones list initialization to reset zones beyond max open zones
* Added the 2nd patch which is required for the open zones list initialization
* Reflected various comments on the list

Shin'ichiro Kawasaki (7):
  zbd: Decrement open zones count at write command completion
  oslib/linux-blkzoned: Allow reset zone before file set up
  zbd: Initialize open zones list referring zone status at fio start
  t/zbd: Improve usage message of test-zbd-support script
  t/zbd: Add -o option to t/zbd/test-zoned-support
  t/zbd: Reset all zones before test when max open zones is specified
  t/zbd: Remove unnecessary option for zbc_reset_zone

 io_u.c                 |   4 +-
 io_u.h                 |   5 +-
 ioengines.c            |   4 +-
 oslib/linux-blkzoned.c |  18 +++++-
 t/zbd/functions        |   2 +-
 t/zbd/test-zbd-support | 122 +++++++++++++++++++++++++++++++++------
 zbd.c                  | 127 +++++++++++++++++++++++++++++++++--------
 zbd.h                  |   9 +--
 8 files changed, 236 insertions(+), 55 deletions(-)

-- 
2.26.2


