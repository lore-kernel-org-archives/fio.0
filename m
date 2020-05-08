Return-Path: <prvs=390c41bd8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 0/7] Assorted bug fixes and improvements
Date: Fri,  8 May 2020 16:56:38 +0900
Message-Id: <20200508075645.543890-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

The first 3 patches of this series fix bugs with write_iolog option
initialization (crash on initialization failure) and with zonemode=zbd
(one possible deadlock for read workloads and an assert trigerring with
verify option enabled).

The following 4 patches are cleanups and improvements of zbd_xxx()
functions to reduce unnecessary overhead when zonemode=zbd is not used.

Comments are welcome !

* Changes from v1:
  - Dropped the patches introducing file and thread zbd function
    pointers. Further reducing the overhead on fio core due to the
    presence of zbd_xxx() functions will require major code surgery.
    Until then, the new patches 4, 5 and 6 provide smaller improvements.
  - Added patch 7 to improve tests execution time.

Damien Le Moal (7):
  iolog: Fix write_iolog_close()
  zbd: Fix potential deadlock on read operations
  zbd: Fix read with verify
  zbd: Optimize zbd_file_reset()
  zbd: Rename zbd_init()
  io_u: Optimize set_rw_ddir()
  t/zbd: Use max-jobs=16 option

 filesetup.c            |  4 ++--
 io_u.c                 |  3 ++-
 iolog.c                |  3 +++
 t/zbd/test-zbd-support |  4 ++--
 zbd.c                  | 22 +++++++++-------------
 zbd.h                  |  8 +++++++-
 6 files changed, 25 insertions(+), 19 deletions(-)

-- 
2.25.4


