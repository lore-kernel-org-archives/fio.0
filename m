Return-Path: <prvs=478995cc1=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v3 0/4] miscellaneous ZBD improvements
Date: Tue,  4 Aug 2020 10:38:24 +0900
Message-Id: <20200804013828.1569-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Sitsofe Wheeler <sitsofe@gmail.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

This series contains four patches related to zoned block devices.

v2 -> v3:
  - initialized libzbc ioengine feature flag in configure
  - improved error output in check_min_lib_version()

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

 configure              | 62 +++++++++++++++++++---------------
 t/zbd/test-zbd-support |  9 ++++-
 zbd.c                  | 76 +++++++++++++++---------------------------
 3 files changed, 70 insertions(+), 77 deletions(-)

-- 
2.21.0


