Return-Path: <prvs=844bea82a=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 0/5] zbd: Support zone reset by trim
Date: Thu,  5 Aug 2021 12:28:30 +0900
Message-Id: <20210805032835.1119908-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

Trim workload is currently not supported for zonemode=zbd. This patch series
enables it by resetting zones for trim I/Os. This allows fio to measure
performance of zoned block devices using more realistic workloads which mixes
write and trim.

The first patch prepares for trim support by modifying the helper function
zbd_find_zone(). The second patch adds zone reset for trim. The third patch
enables trim workload for libzbc I/O engine. The fourth patch adds a test
case that exercises trim operation with zonemode=zbd.

Changes from v1:
* Separated HOWTO/man changes from 2nd patch as 4th patch
* Reflected various comments on the list

Shin'ichiro Kawasaki (5):
  zbd: Add min_bytes argument to zbd_find_zone()
  zbd: Support zone reset by trim
  engines/libzbc: Enable trim for libzbc I/O engine
  HOWTO/man: Describe trim support by zone reset for zoned devices
  t/zbd: Add test #58 to test zone reset by trim workload

 HOWTO                  |  9 +++++
 engines/libzbc.c       | 13 ++++---
 fio.1                  |  4 +-
 io_u.c                 |  9 +++++
 t/zbd/test-zbd-support | 26 +++++++++++++
 zbd.c                  | 85 +++++++++++++++++++++++++++++++++++-------
 zbd.h                  |  2 +
 7 files changed, 127 insertions(+), 21 deletions(-)

-- 
2.31.1


