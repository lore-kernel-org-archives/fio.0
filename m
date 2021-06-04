Return-Path: <prvs=782ebe97f=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 0/3] t/zbd: Fix max_open_zones related failures
Date: Fri,  4 Jun 2021 14:33:48 +0900
Message-Id: <20210604053351.763028-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

Recent changes in fio [1] triggered three failures in the test script
t/zbd/test-zoned-support. This series address the failures.

The first failure was caused by difference between max_open_zones value that fio
refers and that test script refers. The first patch modifies the test script to
use the value fio refers.

The second failure was observed when users specify special max_open_zones values
larger than the max_open_zones limit of the test target device. The second patch
adds --ignore_zone_limits option to the fio command only when users specify such
special conditions.

The third failure was caused by write target zone count bug in the test case 31.
Data write to more zones than max_open_zones limit resulted in exceeding
max_open_zones limit. The third patch fixes the write target zone count logic.

[1] https://www.spinics.net/lists/fio/msg09502.html

Changes from v1:
* Added comment to explain why the test script gets max_open_zones
* Reflected other comments and added Reviewed-by tags

Shin'ichiro Kawasaki (3):
  t/zbd: Use max_open_zones that fio fetched from device
  t/zbd: Add ignore_zone_limit option to test with special
    max_open_zones
  t/zbd: Fix write target zones counting in test case #31

 t/zbd/functions        | 15 ++++++++++++---
 t/zbd/test-zbd-support | 37 +++++++++++++++++--------------------
 2 files changed, 29 insertions(+), 23 deletions(-)

-- 
2.31.1


