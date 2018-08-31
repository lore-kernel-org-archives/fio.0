Return-Path: <prvs=774163301=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v3 0/3] ZBD support improvements and cleanup
Date: Fri, 31 Aug 2018 13:46:35 +0900
Message-Id: <20180831044638.22476-1-damien.lemoal@wdc.com>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

The first patch of this series improves read randomness to avoid excessive
device read cache hit under a random read pattern for a device with very few
written zones. With this patch applied, on a 14TB SMR disk with only 100 zones
written, random read performance results change from several thousands IOPS
down to a more realistic disk-like 100 IOPS or so.

The second patch cleans up zbd related declarations.
The third patch fixes a small bug.

Changes from v2:
* Reworked first patch to simplify the I/O adjustement algorithm
* Fixed typo in second patch title (forgotten in v2)
* Dropped patch 4 (now fixed by changes in the first patch)
* Dropped patch 5

Changes from v1:
* Reworked first patch according to Bart's comments.
* Fixed typo in second patch title
* Added patches 3 to 5

Damien Le Moal (3):
  zbd: Improve read randomness
  zbd: Remove inexistent functions declaration
  zbd: Fix zbd_zone_idx()

 zbd.c | 61 +++++++++++++++++++++++++++++++++++++++--------------------
 zbd.h | 12 ------------
 2 files changed, 40 insertions(+), 33 deletions(-)

-- 
2.17.1


