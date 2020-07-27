Return-Path: <prvs=470d1383e=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 0/3] miscellaneous ZBD improvements
Date: Mon, 27 Jul 2020 12:16:35 +0900
Message-Id: <20200727031638.28264-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

This series contains three patches related to zoned block devices.

Dmitry Fomichev (3):
  configure: improve libzbc version check
  zbd: simplify zone reset code
  t/zbd: check log file for failed assertions

 configure              |  9 +++--
 t/zbd/test-zbd-support |  9 ++++-
 zbd.c                  | 76 +++++++++++++++---------------------------
 3 files changed, 41 insertions(+), 53 deletions(-)

-- 
2.21.0


