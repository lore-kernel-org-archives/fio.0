Return-Path: <prvs=782ebe97f=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 1/3] t/zbd: Use max_open_zones that fio fetched from device
Date: Fri,  4 Jun 2021 14:33:49 +0900
Message-Id: <20210604053351.763028-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210604053351.763028-1-shinichiro.kawasaki@wdc.com>
References: <20210604053351.763028-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

Recent commit d2f442bc0bd5 ("ioengines: add get_max_open_zones zoned
block device operation") modified fio to compare --max_open_zones option
value and max_open_zones reported by the device. The device limit is
fetched through sysfs or through an ioengine specific implementation.

The test script currently try to fetch the max open zones limit using
libzbc tools or sg_inq. If either of these fail, default value 128 is
supplied. This default value can be too high when the test script is
run for certain zoned block devices, and can therefore result in fio
error and test case failure.

To avoid the failure, modify the default value used in the test script
from 128 to 0. With this, --max_open_zones=0 is passed to fio, and it
makes fio use the max_open_zones reported by the device. Also add
comments to describe why the test script gets max_open_zones with tools.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index 40ffe1de..06973f79 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -173,15 +173,24 @@ last_online_zone() {
     fi
 }
 
+# Get max_open_zones of SMR drives using sg_inq or libzbc tools. Two test cases
+# 31 and 32 use this max_open_zones value. The test case 31 uses max_open_zones
+# to decide number of write target zones. The test case 32 passes max_open_zones
+# value to fio with --max_open_zones option. Of note is that fio itself as the
+# feature to get max_open_zones from the device through sysfs or ioengine
+# specific implementation. This max_open_zones fetch by test script is required
+# in case 1) ioengine lacks max_open_zones fetch feature, 2) Linux kernel lacks
+# zoned block device support, or 3) Linux kernel supports zoned block devices
+# but lacks max_open_zones in sysfs.
 max_open_zones() {
     local dev=$1
 
     if [ -n "${sg_inq}" ] && [ ! -n "${use_libzbc}" ]; then
 	if ! ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" \
 		 > /dev/null 2>&1; then
-	    # Non scsi device such as null_blk can not return max open zones.
-	    # Use default value.
-	    echo 128
+	    # When sg_inq can not get max open zones, specify 0 which indicates
+	    # fio to get max open zones limit from the device.
+	    echo 0
 	else
 	    ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" | tail -1 |
 		{
-- 
2.31.1


