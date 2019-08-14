Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/7] Seven fio patches
Date: Tue, 13 Aug 2019 19:20:31 -0700
Message-Id: <20190814022038.30941-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

The following changes are included in this patch series:
- Declare local functions 'static' in zbd.c.
- Make the zbd test scripts more robust.
- Use snprintf() instead of strncpy() + explicit null termination.
- Rework the approach for suppressing gcc 9 address of packed member warnings.
- Add a 'fulltest' target that runs the zbd tests.

Compared to v1, two new patches have been added and the patch for making
Travis run the ZBD tests has been left out. That patch had been prepared
considerable time ago and I have not yet figured out how to load the null_blk
kernel module today in a Travis environment.

Please consider these patches for the official fio git repository.

Thanks,

Bart.

Bart Van Assche (7):
  zbd: Declare local functions 'static'
  zbd: Improve robustness of unit tests
  Optimize the code that copies strings
  Refine packed annotations in stat.h
  Verify the absence of holes in struct jobs_eta at compile time
  Revert "eta: Fix compiler warning"
  Makefile: Add 'fulltest' target

 Makefile                            | 17 +++++++++
 cconv.c                             |  7 ++--
 client.c                            |  5 +--
 diskutil.c                          |  9 +++--
 engines/net.c                       |  6 ++--
 engines/sg.c                        |  4 +--
 eta.c                               | 11 +++---
 filesetup.c                         |  6 ++--
 fio.h                               |  2 ++
 gclient.c                           |  4 +--
 init.c                              | 19 +++-------
 ioengines.c                         |  3 +-
 options.c                           |  3 +-
 parse.c                             |  6 ++--
 server.c                            | 26 ++++++--------
 stat.c                              | 15 ++++----
 stat.h                              | 54 ++++++++++++++++-------------
 t/zbd/run-tests-against-zoned-nullb |  2 +-
 t/zbd/test-zbd-support              |  4 +--
 verify.c                            |  3 +-
 zbd.c                               |  6 ++--
 21 files changed, 106 insertions(+), 106 deletions(-)

-- 
2.22.0


