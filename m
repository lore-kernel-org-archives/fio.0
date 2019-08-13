Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/5] Five fio patches
Date: Mon, 12 Aug 2019 19:01:31 -0700
Message-Id: <20190813020136.15798-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

The following changes are included in this patch series:
- Use snprintf() instead of strncpy() + explicit null termination.
- Rework the approach for suppressing gcc 9 address of packed member warnings.
- Make Travis run the zbd tests.

Please consider these patches for the official fio git repository.

Thanks,

Bart.

Bart Van Assche (5):
  Optimize the code that copies strings
  Verify the size of struct jobs_eta at compile time
  Refine packed annotations in stat.h
  Revert "eta: Fix compiler warning"
  make test: Also run zbd tests

 .travis.yml   |  3 +++
 Makefile      | 14 ++++++++++++++
 cconv.c       |  7 +++----
 client.c      |  5 +++--
 diskutil.c    |  9 ++++-----
 engines/net.c |  6 ++----
 engines/sg.c  |  4 ++--
 eta.c         | 11 +++++------
 filesetup.c   |  6 ++----
 fio.h         |  2 ++
 gclient.c     |  4 ++--
 init.c        | 19 +++++--------------
 ioengines.c   |  3 +--
 options.c     |  3 +--
 parse.c       |  6 ++----
 server.c      | 26 +++++++++++---------------
 stat.c        | 15 ++++++++-------
 stat.h        | 11 ++++++-----
 verify.c      |  3 +--
 19 files changed, 77 insertions(+), 80 deletions(-)

-- 
2.22.0


