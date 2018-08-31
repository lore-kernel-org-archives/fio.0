Return-Path: <prvs=774163301=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] zbd: Fix test scripts
Date: Fri, 31 Aug 2018 13:48:20 +0900
Message-Id: <20180831044820.22625-1-damien.lemoal@wdc.com>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Handle directories correctly using pushd and popd to avoid an error when
the tests are run directly when in fio/t/zbd using "./run-against..."
commands.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 t/zbd/run-tests-against-regular-nullb | 5 +++--
 t/zbd/run-tests-against-zoned-nullb   | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/t/zbd/run-tests-against-regular-nullb b/t/zbd/run-tests-against-regular-nullb
index 133c7c41..cc03e88f 100755
--- a/t/zbd/run-tests-against-regular-nullb
+++ b/t/zbd/run-tests-against-regular-nullb
@@ -13,13 +13,14 @@ done
 modprobe -r null_blk
 [ -e /sys/module/null_blk ] && exit $?
 modprobe null_blk nr_devices=0 &&
-    cd /sys/kernel/config/nullb &&
+    pushd /sys/kernel/config/nullb &&
     mkdir nullb0 &&
     cd nullb0 &&
     echo 0 > completion_nsec &&
     echo 4096 > blocksize &&
     echo 1024 > size &&
     echo 1 > memory_backed &&
-    echo 1 > power
+    echo 1 > power &&
+    popd
 
 "$(dirname "$0")"/test-zbd-support "$@" /dev/nullb0
diff --git a/t/zbd/run-tests-against-zoned-nullb b/t/zbd/run-tests-against-zoned-nullb
index 7d9eb439..f82529e8 100755
--- a/t/zbd/run-tests-against-zoned-nullb
+++ b/t/zbd/run-tests-against-zoned-nullb
@@ -13,7 +13,7 @@ done
 modprobe -r null_blk
 [ -e /sys/module/null_blk ] && exit $?
 modprobe null_blk nr_devices=0 &&
-    cd /sys/kernel/config/nullb &&
+    pushd /sys/kernel/config/nullb &&
     mkdir nullb0 &&
     cd nullb0 &&
     echo 1 > zoned &&
@@ -22,6 +22,7 @@ modprobe null_blk nr_devices=0 &&
     echo 4096 > blocksize &&
     echo 1024 > size &&
     echo 1 > memory_backed &&
-    echo 1 > power
+    echo 1 > power &&
+    popd
 
 "$(dirname "$0")"/test-zbd-support "$@" /dev/nullb0
-- 
2.17.1


