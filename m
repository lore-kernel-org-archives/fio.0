Return-Path: <prvs=76726b587=bart.vanassche@wdc.com>
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 00/11] Zoned block device support for fio
Date: Fri, 24 Aug 2018 11:31:20 -0700
Message-Id: <20180824183131.13278-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bart.vanassche@wdc.com>
List-ID: <fio@vger.kernel.org>

Hello Jens,

This patch series that adds zoned block device support to fio. The pull
request on github is in sync with this patch series. Please consider these
patches for the upstream fio repository.

Thanks,

Bart.

Changes compared to the version posted earlier this morning:
- zbd_init() is only called for zonemode=zbd.
- If the first I/O fails with EIO (null_blk in zoned mode) or EREMOTEIO
  (SCSI zoned block device) then fio suggests to use zonemode=zbd.
- A new test (test45) has been added that verifies that this message is
  reported if applicable.

Bart Van Assche (11):
  configure: Add <linux/blkzoned.h> test
  Add the 'zbd' debug level
  Add the zonemode job option
  Introduce the io_u.post_submit callback function pointer
  Pass offset and buffer length explicitly to mark_random_map()
  Add two assert statements in mark_random_map()
  Add support for zoned block devices
  Collect and show zone reset statistics
  Make it possible to limit the number of open zones
  Add support for resetting zones periodically
  Add scripts for testing the fio zoned block device support code

 HOWTO                                 |   88 +-
 Makefile                              |    3 +
 cconv.c                               |    2 +
 configure                             |   21 +
 debug.h                               |    1 +
 file.h                                |    8 +
 filesetup.c                           |   15 +-
 fio.1                                 |   76 +-
 fio.h                                 |    2 +
 init.c                                |   29 +-
 io_u.c                                |   55 +-
 io_u.h                                |    6 +
 ioengines.c                           |   12 +
 options.c                             |   70 ++
 stat.c                                |   13 +-
 stat.h                                |    3 +
 t/zbd/functions                       |  106 ++
 t/zbd/run-tests-against-regular-nullb |   25 +
 t/zbd/run-tests-against-zoned-nullb   |   27 +
 t/zbd/test-zbd-support                |  817 ++++++++++++++++
 thread_options.h                      |   17 +
 zbd.c                                 | 1288 +++++++++++++++++++++++++
 zbd.h                                 |  142 +++
 23 files changed, 2783 insertions(+), 43 deletions(-)
 create mode 100644 t/zbd/functions
 create mode 100755 t/zbd/run-tests-against-regular-nullb
 create mode 100755 t/zbd/run-tests-against-zoned-nullb
 create mode 100755 t/zbd/test-zbd-support
 create mode 100644 zbd.c
 create mode 100644 zbd.h

-- 
2.18.0


