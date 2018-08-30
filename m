Return-Path: <prvs=7737e5e80=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 0/5] ZBD support improvements and cleanup
Date: Thu, 30 Aug 2018 13:15:26 +0900
Message-Id: <20180830041531.20963-1-damien.lemoal@wdc.com>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

The first patch of this series improves read randomness to avoid excessive
device read cache hit under a random read pattern for a device with very few
written zones. With this patch applied, on a 14TB SMR disk with only 100 zones
written, random read performance results change from several thousands IOPS
down to a more realistic disk-like 100 IOPS or so.

The second patch cleans up zbd related declarations. The third and fourth
patches fix small bugs.

Finally, the last patch cleans up the code by switching to using bytes unit for
all zone information (start, length and write pointer position).

Changes from v1:
* Reworked first patch according to Bart's comments.
* Fixed typo in second patch title
* Added patches 3 to 5

Damien Le Moal (5):
  zbd: Improve read randomness
  zbd: Remove inexitent function declaration
  zbd: Do not read offline zones
  zbd: Fix zbd_zone_idx()
  zbd: Use bytes unit

 zbd.c | 137 +++++++++++++++++++++++++++++++++++-----------------------
 zbd.h |  12 -----
 2 files changed, 83 insertions(+), 66 deletions(-)

-- 
2.17.1


