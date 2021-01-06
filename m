Return-Path: <prvs=6334d1505=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v3 00/38] ZBD fixes and improvements
Date: Thu,  7 Jan 2021 06:57:01 +0900
Message-Id: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

v2 -> v3:

 - fix two libzbc-related bugs in test scripts (found by Shinichiro).
 - modify libzbc ioengine code to allow fio to operate successfully
   against null_blk devices while using this ioengine.
 - add -l option to run-tests-against-nullb script to allow running
   the tests while using libzbc ioengine.
 - add -n option to run-tests-against-nullb to allow running the
   specified tests multiple times. This option is the most useful
   in combination with the existing -s and -t options.
 - fix sporadic failed assertion in test #51 that is easily triggered
   by running run-tests-against-nullb script with -l and -n options.
 - make minor coding style improvements in run-tests-against-nullb.

v1 -> v2:

 - replace both run-tests-against-conventional-nullb and 
   run-tests-against-conventional-nullb with a single script,
   run-tests-against-nullb, that runs test-zbd-support unit tests
   over a variety on different zoned configurations.
 - add five new test cases to test-zbd-support to cover the code
   changes made in zbd.c as a part of this series.
 - mark all test cases in test-zbd-support script that are not
   applicable for the device configuration as SKIP instead of
   reporting them as passed.
 - properly handle writes to conventional zones that cross over
   to sequential zones.
 - make additional improvements in zone locking parts of zbd.c.
 - implement miscellaneous test script enhancements.

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

Dmitry Fomichev (25):
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
  zbd: don't log "zone nnnn is not open" message
  zbd: handle conventional start zone in zbd_convert_to_open_zone()
  zbd: improve replay range validation
  engines/libzbc: enable block backend
  zbd: avoid failing assertion in zbd_convert_to_open_zone()
  zbd: set thread errors in zbd_adjust_block()
  t/zbd: check for error in test #2
  t/zbd: add run-tests-against-nullb script
  t/zbd: add an option to bail on a failed test
  t/zbd: prevent test #31 from looping
  t/zbd: add checks for offline zone condition
  t/zbd: add test #54 to exercise ZBD verification
  t/zbd: show elapsed time in test-zbd-support
  t/zbd: increase timeout in test #48
  t/zbd: avoid looping on invalid command line options

Shin'ichiro Kawasaki (12):
  zbd: do not lock conventional zones on I/O adjustment
  zbd: do not set zbd handlers for conventional zones
  zbd: count sectors with data for write pointer zones
  zbd: initialize min_zone and max_zone for all zone types
  zbd: disable crossing from conventional to sequential zones
  t/zbd: add -t option to run-tests-against-nullb
  t/zbd: skip tests when test prerequisites are not met
  t/zbd: skip tests that need too many sequential zones
  t/zbd: test that conventional zones are not locked during random i/o
  t/zbd: test that zone_reset_threshold calculation is correct
  t/zbd: test random I/O direction in all-conventional case
  t/zbd: fix wrong units in test case #37

 Makefile                              |   5 +-
 engines/libzbc.c                      |   5 +-
 oslib/linux-blkzoned.c                |   2 +-
 t/run-fio-tests.py                    |   8 +-
 t/zbd/functions                       |  56 +++-
 t/zbd/run-tests-against-nullb         | 354 +++++++++++++++++++++++++
 t/zbd/run-tests-against-regular-nullb |  27 --
 t/zbd/run-tests-against-zoned-nullb   |  53 ----
 t/zbd/test-zbd-support                | 301 +++++++++++++++++++---
 zbd.c                                 | 357 ++++++++++++++++----------
 zbd.h                                 |   5 +
 11 files changed, 912 insertions(+), 261 deletions(-)
 create mode 100755 t/zbd/run-tests-against-nullb
 delete mode 100755 t/zbd/run-tests-against-regular-nullb
 delete mode 100755 t/zbd/run-tests-against-zoned-nullb

-- 
2.28.0


