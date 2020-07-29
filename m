Return-Path: <prvs=47212d7a9=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 0/4] miscellaneous ZBD improvements
Date: Thu, 30 Jul 2020 06:04:11 +0900
Message-Id: <20200729210415.4166-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

This series contains four patches related to zoned block devices.

v1 -> v2:
  - removed recursive zone locking in zbd_reset_zone()
  - added --disable-libzbc configure option
  - moved pkg-config version check to a separate function
  - added a patch to verify that pkg-config is available to check
    the minimum supported version in all libraries that need that

Dmitry Fomichev (4):
  configure: improve libzbc version check
  configure: check if pkg-config is installed
  zbd: simplify zone reset code
  t/zbd: check log file for failed assertions

 configure              | 61 ++++++++++++++++++---------------
 t/zbd/test-zbd-support |  9 ++++-
 zbd.c                  | 76 +++++++++++++++---------------------------
 3 files changed, 69 insertions(+), 77 deletions(-)

-- 
2.21.0


