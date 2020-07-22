Return-Path: <prvs=46505dd82=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] t/zbd: Improve pass condition of test case #49
Date: Wed, 22 Jul 2020 18:26:33 +0900
Message-Id: <20200722092633.350291-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Hans Holmberg <hans.holmberg@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The test case #49 runs write workloads with verify option. It checks read
bytes for verify, but it does not check written bytes. To make test pass
condition more accurate, add check of the written bytes.

Fixes: 4844bb4716ab ("t/zbd: Add test case to check zonecapacity option")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 1 +
 1 file changed, 1 insertion(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index e53a20c5..471a3487 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -856,6 +856,7 @@ test49() {
 		    --zonecapacity=${capacity} \
 		    --verify=md5  --size=${size} >>"${logfile}.${test_number}" 2>&1 ||
 	return $?
+    check_written $((capacity * 2)) || return $?
     check_read $((capacity * 2)) || return $?
 }
 
-- 
2.26.2


