Return-Path: <prvs=947609abe=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 3/8] t/zbd: Fix handling of partition devices
Date: Wed, 20 Feb 2019 16:17:20 +0900
Message-Id: <20190220071725.8487-4-damien.lemoal@wdc.com>
In-Reply-To: <20190220071725.8487-1-damien.lemoal@wdc.com>
References: <20190220071725.8487-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Matias Bjorling <matias.bjorling@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

To allow t/zbd/tests-zbd-support test script to run correctly on
partitions of zoned block devices, fix access to the device properties
through sysfs by referencing the sysfs directory of the holder block
device. Doing so, the "zoned", "logical_block_size" and "mq" attributes
can be correctly accessed.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 2d727910..d316d880 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -761,7 +761,15 @@ source "$(dirname "$0")/functions" || exit $?
 dev=$1
 realdev=$(readlink -f "$dev")
 basename=$(basename "$realdev")
-disk_size=$(($(<"/sys/block/$basename/size")*512))
+major=$((0x$(stat -L -c '%t' "$realdev")))
+minor=$((0x$(stat -L -c '%T' "$realdev")))
+disk_size=$(($(<"/sys/dev/block/$major:$minor/size")*512))
+# When the target is a partition device, get basename of its holder device to
+# access sysfs path of the holder device
+if [[ -r "/sys/dev/block/$major:$minor/partition" ]]; then
+	realsysfs=$(readlink "/sys/dev/block/$major:$minor")
+	basename=$(basename "${realsysfs%/*}")
+fi
 logical_block_size=$(<"/sys/block/$basename/queue/logical_block_size")
 case "$(<"/sys/class/block/$basename/queue/zoned")" in
     host-managed|host-aware)
-- 
2.20.1


