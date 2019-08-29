Return-Path: <prvs=137559805=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 4/6] man page: Fix read_beyond_wp description
Date: Thu, 29 Aug 2019 16:21:33 +0900
Message-Id: <20190829072135.2872-5-damien.lemoal@wdc.com>
In-Reply-To: <20190829072135.2872-1-damien.lemoal@wdc.com>
References: <20190829072135.2872-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Stricjktly speaking, drive managed disks are not zoned block devices as
they do not provide zone information nor zone commands. So remove
mention of this type of disk in the zoned block device description.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 fio.1 | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fio.1 b/fio.1
index a06a12da..d7421eee 100644
--- a/fio.1
+++ b/fio.1
@@ -778,10 +778,10 @@ Zoned block devices are block devices that consist of multiple zones. Each
 zone has a type, e.g. conventional or sequential. A conventional zone can be
 written at any offset that is a multiple of the block size. Sequential zones
 must be written sequentially. The position at which a write must occur is
-called the write pointer. A zoned block device can be either drive
-managed, host managed or host aware. For host managed devices the host must
-ensure that writes happen sequentially. Fio recognizes host managed devices
-and serializes writes to sequential zones for these devices.
+called the write pointer. A zoned block device can be either host managed or
+host aware. For host managed devices the host must ensure that writes happen
+sequentially. Fio recognizes host managed devices and serializes writes to
+sequential zones for these devices.
 
 If a read occurs in a sequential zone beyond the write pointer then the zoned
 block device will complete the read without reading any data from the storage
-- 
2.21.0


