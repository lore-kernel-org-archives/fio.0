Return-Path: <prvs=587eb1fc6=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 00/15] ZBD fixes and improvements
Date: Sat, 21 Nov 2020 11:45:17 +0900
Message-Id: <20201121024532.16834-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

This patch series contains bug fixes and refactoring changes
related to support for Zoned Block Devices (ZBD) in fio.
The highlights:

 - fix several errors related to running workloads that span
   a mix of conventional zones and write pointer zones.
 - improve counting of sectors with data (SWD).
 - remove dependencies on particular zone types in the code.
 - add code to gracefully handle offline zones.

Aravind Ramesh (1):
  zbd: initialize sectors with data at start time

Dmitry Fomichev (10):
  zbd: return ENOMEM if zone buffer allocation fails
  zbd: use zbd_zone_nr() more actively in the code
  zbd: add get_zone() helper function
  zbd: introduce zone_unlock()
  zbd: engines/libzbc: don't fail on assert for offline zones
  zbd: remove dependency on zone type during i/o
  zbd: skip offline zones in zbd_convert_to_open_zone()
  zbd: avoid zone buffer overrun
  zbd: don't unlock zone mutex after verify replay
  zbd: use zone_lock() in zbd_process_swd()

Shin'ichiro Kawasaki (4):
  zbd: do not lock conventional zones on I/O adjustment
  zbd: do not set zbd handlers for conventional zones
  zbd: count sectors with data for write pointer zones
  zbd: initialize min_zone and max_zone for all zone types

 engines/libzbc.c       |   3 +-
 oslib/linux-blkzoned.c |   3 +-
 zbd.c                  | 265 ++++++++++++++++++++++++-----------------
 zbd.h                  |   5 +
 4 files changed, 164 insertions(+), 112 deletions(-)

-- 
2.21.0


