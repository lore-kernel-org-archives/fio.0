Return-Path: <prvs=4589743b3=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 2/8] t/zbd: Fix pass condition of test case #3
Date: Wed, 15 Jul 2020 13:13:16 +0900
Message-Id: <20200715041322.114929-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200715041322.114929-1-shinichiro.kawasaki@wdc.com>
References: <20200715041322.114929-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The test case #3 checks that the read workload for empty zones ends
without reading any data. When zonemode=zbd, it is expected for both
regular block devices and zoned block devices. However, the test case
allowed for regular block devices to read data from empty zones. Remove
this special pass condition for regular block devices.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 4001be3b..1178afd4 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -170,13 +170,7 @@ test3() {
 	opts+=("--zonesize=${zone_size}")
     fi
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
-    grep -q 'READ:' "${logfile}.${test_number}"
-    rc=$?
-    if [ -n "$is_zbd" ]; then
-	[ $rc != 0 ]
-    else
-	[ $rc = 0 ]
-    fi
+    ! grep -q 'READ:' "${logfile}.${test_number}"
 }
 
 # Run fio with --read_beyond_wp=1 against an empty zone.
-- 
2.26.2


