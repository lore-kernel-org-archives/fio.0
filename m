Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:55907 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhFAGtg (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 1 Jun 2021 02:49:36 -0400
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/3] t/zbd: Fix max_open_zones related failures
Date: Tue,  1 Jun 2021 15:47:50 +0900
Message-Id: <20210601064753.734892-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>

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
Data write to more zones than max_open_zones limit resulted in exceeding the
max_open_zones limit. The third patch fixes the write target zone count logic.

[1] https://www.spinics.net/lists/fio/msg09502.html

Shin'ichiro Kawasaki (3):
  t/zbd: Use max_open_zones that fio fetched from device
  t/zbd: Add ignore_zone_limit option to test with special
    max_open_zones
  t/zbd: Fix write target zones counting in test case #31

 t/zbd/functions        |  4 ++--
 t/zbd/test-zbd-support | 37 +++++++++++++++++--------------------
 2 files changed, 19 insertions(+), 22 deletions(-)

-- 
2.31.1


