Return-Path: <bvanassche@acm.org>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/6] Restore the check_swd() function in the ZBD code
Date: Fri, 28 Sep 2018 14:51:27 -0700
Message-Id: <20180928215133.35222-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

The fio changes included in this patch series are as follows:
- The check_swd() function has been restored in such a way that the compiler
  can verify the syntactical correctness of the code.
- A new function zbd_process_swd() has been introduced to avoid duplicated
  code.
- The robustness of the ZBD test scripts has been improved.

Please consider these patches for the upstream fio repository.

Thanks,

Bart.

Bart Van Assche (6):
  t/zbd/functions: Make fio_reset_count() return 0 if no resets occurred
  t/zbd/test-zbd-support: Ensure that an assertion failure causes this
    test to fail
  t/zbd/test-zbd-support: Set fio aux path and forbid file creation
  t/zbd/test-zbd-support: Report a test summary when finished
  zbd: Restore zbd_check_swd()
  zbd: Avoid duplicating the code for calculating the number of sectors
    with data

 t/zbd/functions        |  5 ++-
 t/zbd/test-zbd-support | 17 +++++++---
 zbd.c                  | 75 +++++++++++++++++++++++++++++++++++-------
 3 files changed, 80 insertions(+), 17 deletions(-)

-- 
2.19.0.605.g01d371f741-goog


