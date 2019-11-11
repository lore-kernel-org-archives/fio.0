Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 0/3] three patches
Date: Mon, 11 Nov 2019 11:30:52 -0500
Message-Id: <20191111163055.7358-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Jens, please consider this patch series.

The LFSR error message and test script error handling changes I believe
should be uncontroversial.

Regarding the zonemode=strided patch, it will break job files that
depend on the old buggy behavior, but that behavior is so inconsistent
with the documentation that I think this fix is warranted.

Vincent

Vincent Fu (3):
  filesetup: improve LFSR init failure error message
  io_u: move to next zone even if zoneskip is unset
  t/run-fio-tests: improve error handling

 filesetup.c        |  3 +++
 io_u.c             |  3 +--
 t/run-fio-tests.py | 10 ++++++----
 t/strided.py       |  3 +--
 4 files changed, 11 insertions(+), 8 deletions(-)

-- 
2.17.1


