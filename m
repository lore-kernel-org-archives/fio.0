Return-Path: <fio-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:48983 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbgGAIac (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Jul 2020 04:30:32 -0400
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/6] Support zone capacity
Date: Wed,  1 Jul 2020 17:30:23 +0900
Message-Id: <20200701083029.140741-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Hans Holmberg <hans.holmberg@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Kernel 5.9 zone descriptor interface adds the new zone capacity field defining
the range of sectors usable within a zone. This patch series adds support for
this new field.

The 1st patch adds zone capacity support to zonemode=zbd. Get zone capacity
values of each zone and adjust io_u to meet the zone capacity limit. The 2nd
patch adds a new option zonecapacity which allows to test zone capacity
handling by fio using regular block devices. Other four patches extend t/zbd
test scripts for zone capacity.

Of note is that the zone capacity is always equal to the zone size for SCSI
drives. For NVMe ZNS and nullblk zoned drives, the zone capacity can be
smaller than the zone size.

This series can be applied on top of another series 'zbd: Fix initial zone write
pointer of regular block devices' [1].

[1] https://www.spinics.net/lists/fio/msg08670.html

Hans Holmberg (3):
  options: Add zonecapacity option for zonemode=zbd
  t/zbd: Support testing zone capacity smaller than zone size
  t/zbd: Add test case to check zonecapacity option

Shin'ichiro Kawasaki (3):
  zns: Support zone capacity smaller than zone size
  t/zbd: Mandate blkzone capacity report for devices with zone capacity
  t/zbd: Support testing zone capacity smaller than zone size with
    null_blk

 HOWTO                               |  18 +++-
 cconv.c                             |   2 +
 configure                           |  19 +++++
 engines/libzbc.c                    |   1 +
 fio.1                               |  13 ++-
 options.c                           |  11 +++
 oslib/linux-blkzoned.c              |  11 +++
 t/zbd/functions                     |  82 +++++++++++++++++++
 t/zbd/run-tests-against-zoned-nullb |  30 ++++++-
 t/zbd/test-zbd-support              | 123 ++++++++++++++++++++--------
 thread_options.h                    |   2 +
 zbd.c                               |  85 +++++++++++++++----
 zbd.h                               |   2 +
 zbd_types.h                         |   1 +
 14 files changed, 342 insertions(+), 58 deletions(-)

-- 
2.26.2


