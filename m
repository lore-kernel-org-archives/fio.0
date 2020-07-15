Return-Path: <prvs=4589743b3=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 5/6] t/zbd: Support testing zone capacity smaller than zone size with null_blk
Date: Wed, 15 Jul 2020 15:41:40 +0900
Message-Id: <20200715064141.116415-6-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200715064141.116415-1-shinichiro.kawasaki@wdc.com>
References: <20200715064141.116415-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Hans Holmberg <hans.holmberg@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

To test zone capacity support by fio using null_blk, add -zone-cap option
to run-tests-against-zoned-nullb. With this option, the script creates a
null_blk device which has zone capacity smaller than zone size and run
test-zbd-support script for the device.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/run-tests-against-zoned-nullb | 30 ++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/t/zbd/run-tests-against-zoned-nullb b/t/zbd/run-tests-against-zoned-nullb
index 53aee3e8..9a5d5409 100755
--- a/t/zbd/run-tests-against-zoned-nullb
+++ b/t/zbd/run-tests-against-zoned-nullb
@@ -6,6 +6,21 @@
 
 scriptdir="$(cd "$(dirname "$0")" && pwd)"
 
+zone_size=1
+zone_capacity=1
+if [[ ${1} == "-h" ]]; then
+    echo "Usage: ${0} [OPTIONS]"
+    echo "Options:"
+    echo -e "\t-h Show this message."
+    echo -e "\t-zone-cap Use null blk with zone capacity less than zone size."
+    echo -e "\tany option supported by test-zbd-support script"
+    exit 1
+elif [[ ${1} == "-zone-cap" ]]; then
+    zone_size=4
+    zone_capacity=3
+    shift
+fi
+
 for d in /sys/kernel/config/nullb/*; do [ -d "$d" ] && rmdir "$d"; done
 modprobe -r null_blk
 modprobe null_blk nr_devices=0 || exit $?
@@ -17,9 +32,18 @@ modprobe -r null_blk
 modprobe null_blk nr_devices=0 &&
     cd /sys/kernel/config/nullb &&
     mkdir nullb0 &&
-    cd nullb0 &&
-    echo 1 > zoned &&
-    echo 1 > zone_size &&
+    cd nullb0 || exit $?
+
+if ((zone_capacity < zone_size)); then
+    if [[ ! -w zone_capacity ]]; then
+        echo "null blk does not support zone capacity"
+        exit 1
+    fi
+    echo "${zone_capacity}" > zone_capacity
+fi
+
+echo 1 > zoned &&
+    echo "${zone_size}" > zone_size &&
     echo 0 > completion_nsec &&
     echo 4096 > blocksize &&
     echo 1024 > size &&
-- 
2.26.2


