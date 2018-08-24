Return-Path: <prvs=76726b587=bart.vanassche@wdc.com>
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 00/11] Add zoned block device support to fio
Date: Fri, 24 Aug 2018 09:30:35 -0700
Message-Id: <20180824163046.12304-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bart.vanassche@wdc.com>
List-ID: <fio@vger.kernel.org>

Hello Jens,

As you requested earlier today, I'm sending you the patch series that adds
zoned block device support to fio by e-mail. The pull request on github is
in sync with this patch series. Please consider these patches for the upstream
fio repository.

Thanks,

Bart.

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
 filesetup.c                           |   12 +-
 fio.1                                 |   76 +-
 fio.h                                 |    2 +
 init.c                                |   24 +-
 io_u.c                                |   55 +-
 io_u.h                                |    6 +
 ioengines.c                           |    4 +
 options.c                             |   70 ++
 stat.c                                |   13 +-
 stat.h                                |    3 +
 t/zbd/functions                       |  106 ++
 t/zbd/run-tests-against-regular-nullb |   25 +
 t/zbd/run-tests-against-zoned-nullb   |   27 +
 t/zbd/test-zbd-support                |  799 +++++++++++++++
 thread_options.h                      |   17 +
 zbd.c                                 | 1288 +++++++++++++++++++++++++
 zbd.h                                 |  136 +++
 23 files changed, 2742 insertions(+), 44 deletions(-)
 create mode 100644 t/zbd/functions
 create mode 100755 t/zbd/run-tests-against-regular-nullb
 create mode 100755 t/zbd/run-tests-against-zoned-nullb
 create mode 100755 t/zbd/test-zbd-support
 create mode 100644 zbd.c
 create mode 100644 zbd.h

-- 
2.18.0


