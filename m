Return-Path: <prvs=379927889=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/5] Assorted bug fixes and improvements
Date: Mon, 27 Apr 2020 14:51:09 +0900
Message-Id: <20200427055115.107909-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

The first 3 patches of this series fix bugs with write_iolog option
initialization (crash on initialization failure) and with zonemode=zbd
(one possible deadlock for read workloads and an assert trigerring with
verify option enabled).

The last 2 patches cleanup the use of zbd_xxx() functions from fio core
code to reduce the overhead when zonemode=zbd is not used.

Comments are welcome !

Damien Le Moal (5):
  iolog: Fix write_iolog_close()
  zbd: Fix potential deadlock on read operations
  zbd: Fix read with verify
  zbd: Introduce file zbd operations
  zbd: Introduce thread zbd operations

 file.h      |  5 ++-
 filesetup.c |  2 +-
 fio.h       |  8 +++++
 io_u.c      |  8 ++---
 iolog.c     |  3 ++
 zbd.c       | 87 +++++++++++++++++++++++++++++------------------------
 zbd.h       | 33 +++++++++++++++++---
 7 files changed, 94 insertions(+), 52 deletions(-)

-- 
2.25.4


