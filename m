Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 0/3] zonemode=strided fixes
Date: Tue, 15 Oct 2019 10:29:55 -0400
Message-Id: <20191015142958.14559-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Jens, please consider this series of patches.

The patches fix two different zonemode=strided issues and also include a
test script.

Vincent

Vincent Fu (3):
  io_u: skip to the next zone when zoneskip is set to zero
  filesetup: use zonerange for map and LFSR with zonemode=strided
  testing: add test script for zonemode=strided

 filesetup.c  |   3 +
 io_u.c       |   3 +-
 t/strided.py | 350 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 355 insertions(+), 1 deletion(-)
 create mode 100755 t/strided.py

-- 
2.17.1


