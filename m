Return-Path: <prvs=137559805=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/6] zbd cleanup, small fixes and zoneskip support
Date: Thu, 29 Aug 2019 16:21:29 +0900
Message-Id: <20190829072135.2872-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

The first 5 patches of this series are small cleanups and fixes to the
zone block device code (zbd.c) and man page documentation.

The last patch of this series implements zoneskip option support for
zonemode=zbd in response to field customers request wanting to
test/qualify very large capacity SMR disks without having to do
full-pack read/write of the entire disk capacity, while retaining the
convenience of the auomatic handling of zone write pointer alignment and
zone reset of this mode (as opposed to the zonemode=strided mode).

The zoneskip option support for zonemode=zbd applies only to sequential
read/write workloads, allowing to skip zoneskip bytes once the current
zone of a job has been fully written or read. The zoneskip value must be
zone aligned.

Damien Le Moal (6):
  zbd: Cleanup zbd_init()
  zbd: Fix initialization error message
  zbd: Fix error message
  man page: Fix read_beyond_wp description
  man: Improve zonemode=zbd information
  zbd: Add support for zoneskip option

 fio.1                  |  29 ++++++++----
 io_u.c                 |   2 +
 t/zbd/test-zbd-support |  15 +++++-
 zbd.c                  | 103 ++++++++++++++++++++++++++++++++++-------
 zbd.h                  |   1 +
 5 files changed, 123 insertions(+), 27 deletions(-)

-- 
2.21.0


