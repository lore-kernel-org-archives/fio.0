Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 2/7] zbd: Improve robustness of unit tests
Date: Wed, 14 Aug 2019 13:10:07 -0700
Message-Id: <20190814201012.253060-3-bvanassche@acm.org>
In-Reply-To: <20190814201012.253060-1-bvanassche@acm.org>
References: <20190814201012.253060-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Give up if creation of the null_blk instance fails.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 t/zbd/run-tests-against-zoned-nullb | 2 +-
 t/zbd/test-zbd-support              | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/t/zbd/run-tests-against-zoned-nullb b/t/zbd/run-tests-against-zoned-nullb
index 9336716d4762..0952011c576e 100755
--- a/t/zbd/run-tests-against-zoned-nullb
+++ b/t/zbd/run-tests-against-zoned-nullb
@@ -24,6 +24,6 @@ modprobe null_blk nr_devices=0 &&
     echo 4096 > blocksize &&
     echo 1024 > size &&
     echo 1 > memory_backed &&
-    echo 1 > power
+    echo 1 > power || exit $?
 
 "${scriptdir}"/test-zbd-support "$@" /dev/nullb0
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 6fb48ef091cf..ed54a0aa21fd 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -772,8 +772,8 @@ source "$(dirname "$0")/functions" || exit $?
 dev=$1
 realdev=$(readlink -f "$dev")
 basename=$(basename "$realdev")
-major=$((0x$(stat -L -c '%t' "$realdev")))
-minor=$((0x$(stat -L -c '%T' "$realdev")))
+major=$((0x$(stat -L -c '%t' "$realdev"))) || exit $?
+minor=$((0x$(stat -L -c '%T' "$realdev"))) || exit $?
 disk_size=$(($(<"/sys/dev/block/$major:$minor/size")*512))
 # When the target is a partition device, get basename of its holder device to
 # access sysfs path of the holder device
-- 
2.22.0.rc1


