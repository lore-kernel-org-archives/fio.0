Return-Path: <prvs=565f703da=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 0/2] zbd: Fix test case #48 failure
Date: Fri, 30 Oct 2020 15:57:38 +0900
Message-Id: <20201030065740.2039936-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

When t/zbd/test-zoned-support is run for zoned block devices with slow zone
reset command operation, test case #48 fails. This series addresses the failure
with two fixes. First patch avoids excessive and repeated zone resets which
resulted in too long runtime and test timeout. Second patch fixes wrong test
target range of the test case which triggered unnecessary zone resets.

Changes from v1:
* Added reviewed-by tag

Shin'ichiro Kawasaki (2):
  zbd: Avoid excessive zone resets
  t/zbd: Fix test target size of test case #48

 t/zbd/test-zbd-support | 2 +-
 zbd.c                  | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
2.26.2


