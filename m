Return-Path: <prvs=4589743b3=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 8/8] t/zbd: Enable regular block devices for test case #47
Date: Wed, 15 Jul 2020 13:13:22 +0900
Message-Id: <20200715041322.114929-9-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200715041322.114929-1-shinichiro.kawasaki@wdc.com>
References: <20200715041322.114929-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The test case #47 was not able to run for regular block devices since it
missed zonesize option required for regular block devices.

Enable the test case for regular block devices by calling the
run_fio_on_seq() helper function which adds the zonesize option.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 8934e32b..80dc3f30 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -773,10 +773,8 @@ test46() {
 test47() {
     local bs
 
-    [ -z "$is_zbd" ] && return 0
     bs=$((logical_block_size))
-    run_one_fio_job "$(ioengine "psync")" --rw=write --bs=$bs \
-		    --zonemode=zbd --zoneskip=1		 \
+    run_fio_on_seq "$(ioengine "psync")" --rw=write --bs=$bs --zoneskip=1 \
 		    >> "${logfile}.${test_number}" 2>&1 && return 1
     grep -q 'zoneskip 1 is not a multiple of the device zone size' "${logfile}.${test_number}"
 }
-- 
2.26.2


