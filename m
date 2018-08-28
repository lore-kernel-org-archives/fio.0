Return-Path: <prvs=771502ab2=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] ZBD support improvment and cleanup
Date: Tue, 28 Aug 2018 14:34:26 +0900
Message-Id: <20180828053428.10143-1-damien.lemoal@wdc.com>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Two small patches: the first one improves read randomness to avoid excessive
device read cache hit for a device with very few written zones. With this patch
applied, on a 14TB SMR disk with only 100 zones written, random read performance
result change from several thousands IOPS down to a more disk-like 100 IOPS or
so.

The second patch cleans up zbd related declarations.

Damien Le Moal (2):
  zbd: Improve read randomness
  zbd: Remove inexitent function declaration

 zbd.c | 10 +++++++++-
 zbd.h | 12 ------------
 2 files changed, 9 insertions(+), 13 deletions(-)

-- 
2.17.1


