Return-Path: <prvs=36522ed81=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/3] zbd: Fix issues found with test script
Date: Mon, 13 Apr 2020 17:32:57 +0900
Message-Id: <20200413083300.256784-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

This series addresses issues found with t/zbd/test-zbd-support script runs with
various conditions. The three patches fix issues about maximum open zone check,
reset all zones and random read/write on empty zones, respectively.

Please consider this series for the fio upstream.

Shin'ichiro Kawasaki (3):
  t/zbd: Fix a bug in max_open_zones()
  t/zbd: Fix a bug in reset_zone() for all zones reset
  zbd: Ensure first I/O is write for random read/write to sequential
    zones

 t/zbd/functions |  6 +++---
 zbd.c           | 10 ++++++++++
 2 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.25.1


