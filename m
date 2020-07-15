Return-Path: <prvs=4589743b3=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 0/8] zbd: Fix initial zone write pointer of regular block devices
Date: Wed, 15 Jul 2020 13:13:14 +0900
Message-Id: <20200715041322.114929-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

With zonemode=zbd and regular block devices, fio initializes zone status as
empty. However, write pointers are set not at zone start but at zone end. This
inconsistency between write pointer position and zone status caused different
behavior of regular block devices from zoned block devices. This patch series
fixes the inconsistency and the behavior gap.

The 1st patch fixes the zone status initialization code by setting write
pointers at zone start. Following patches fixes t/zbd test script to handle
regular block devices and zoned block devices in same manner.

Changes from v1:
* Added reviewed-by tag

Shin'ichiro Kawasaki (8):
  zbd: Fix initial zone write pointer of regular block devices
  t/zbd: Fix pass condition of test case #3
  t/zbd: Add write_and_run_one_fio_job() helper function
  t/zbd: Combine write and read fio commands for test case #6
  t/zbd: Combine write and read fio commands for test case #15
  t/zbd: Combine write and read fio commands for test case #16
  t/zbd: Remove write before random read/write from test case #17
  t/zbd: Enable regular block devices for test case #47

 t/zbd/test-zbd-support | 78 +++++++++++++++++++++++-------------------
 zbd.c                  |  2 +-
 2 files changed, 44 insertions(+), 36 deletions(-)

-- 
2.26.2


