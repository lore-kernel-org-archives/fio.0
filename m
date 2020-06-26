Return-Path: <prvs=439ee04d1=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 7/8] t/zbd: Remove write before random read/write from test case #17
Date: Fri, 26 Jun 2020 18:43:30 +0900
Message-Id: <20200626094331.418309-8-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200626094331.418309-1-shinichiro.kawasaki@wdc.com>
References: <20200626094331.418309-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The test case #17 writes data to the last zone before random read/write.
This avoided read failure when read is chosen for the first operation of
the random read and write. Such failure case was prevented by the commit
fb0259fb276a ("zbd: Ensure first I/O is write for random read/write to
sequential zones"). Then the write is no longer required. Remove it.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index a3ecec1f..8934e32b 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -397,15 +397,9 @@ test17() {
 
     off=$(((disk_size / zone_size - 1) * zone_size))
     size=$((disk_size - off))
-    # Overwrite the last zone to avoid that reading from that zone fails.
     if [ -n "$is_zbd" ]; then
 	reset_zone "$dev" $((off / 512)) || return $?
     fi
-    run_one_fio_job "$(ioengine "psync")" --rw=write --offset="$off"	\
-		    --zonemode=zbd --zonesize="${zone_size}"		\
-		    --bs="$zone_size" --size="$zone_size"		\
-		    >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written "$zone_size" || return $?
     run_one_fio_job "$(ioengine "libaio")" --iodepth=8 --rw=randrw --bs=4K \
 		    --zonemode=zbd --zonesize="${zone_size}"		\
 		    --offset=$off --loops=2 --norandommap=1\
-- 
2.26.2


