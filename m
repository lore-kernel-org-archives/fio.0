Return-Path: <prvs=8148fed87=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/4] zbd: Support zone reset by trim
Date: Tue,  6 Jul 2021 09:59:22 +0900
Message-Id: <20210706005926.303890-1-shinichiro.kawasaki@wdc.com>
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

Shin'ichiro Kawasaki (4):
  zbd: Add min_bytes argument to zbd_find_zone()
  zbd: Support zone reset by trim
  engines/libzbc: Enable trim for libzbc I/O engine
  t/zbd: Add test #58 to test zone reset by trim workload

 HOWTO                  |  3 ++
 engines/libzbc.c       | 16 +++++---
 fio.1                  |  2 +
 io_u.c                 |  9 +++++
 t/zbd/test-zbd-support | 26 ++++++++++++
 zbd.c                  | 89 +++++++++++++++++++++++++++++++++++-------
 zbd.h                  |  2 +
 7 files changed, 127 insertions(+), 20 deletions(-)

-- 
2.31.1


