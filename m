Return-Path: <prvs=947609abe=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 5/8] t/zbd: Default to using blkzone tool
Date: Wed, 20 Feb 2019 16:17:22 +0900
Message-Id: <20190220071725.8487-6-damien.lemoal@wdc.com>
In-Reply-To: <20190220071725.8487-1-damien.lemoal@wdc.com>
References: <20190220071725.8487-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Matias Bjorling <matias.bjorling@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

The test-zbd-support script fails to execute for partition devices with
the error message "Open /dev/sdX1 failed (No such file or directory)"
when libzbc tools are used by the script to open the specified
partition device. This is due to libzbc also opening a partition holder
block device file, which when closed causes a partition table
revalidation and the partition device files to be deleted and
recreated by udev through the RRPART ioctl.

To avoid the failure, default to using blkzone for zone report and
reset if supported by the system (util-linux v2.30 and higher) as this
tool does not open the older device and avoids the same problem.
To obtain the device maximum number of open zones, which is not
advertized by blkzone, use sg_inq for SCSI devices and use the default
maximum of 128 for other device types (i.e. null_blk devices in zone
mode).

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index 173f0ca6..d49555a8 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -1,8 +1,7 @@
 #!/bin/bash
 
-# To do: switch to blkzone once blkzone reset works correctly.
-blkzone=
-#blkzone=$(type -p blkzone 2>/dev/null)
+blkzone=$(type -p blkzone 2>/dev/null)
+sg_inq=$(type -p sg_inq 2>/dev/null)
 zbc_report_zones=$(type -p zbc_report_zones 2>/dev/null)
 zbc_reset_zone=$(type -p zbc_reset_zone 2>/dev/null)
 if [ -z "${blkzone}" ] &&
@@ -34,9 +33,23 @@ first_sequential_zone() {
 max_open_zones() {
     local dev=$1
 
-    if [ -n "${blkzone}" ]; then
-	# To do: query the maximum number of open zones using sg_raw
-	return 1
+    if [ -n "${sg_inq}" ]; then
+	if ! ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" 2> /dev/null; then
+	    # Non scsi device such as null_blk can not return max open zones.
+	    # Use default value.
+	    echo 128
+	else
+	    ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" | tail -1 |
+		{
+		    read -r offset b0 b1 b2 b3 trailer || return $?
+		    # Convert from hex to decimal
+		    max_nr_open_zones=$((0x${b0}))
+		    max_nr_open_zones=$((max_nr_open_zones * 256 + 0x${b1}))
+		    max_nr_open_zones=$((max_nr_open_zones * 256 + 0x${b2}))
+		    max_nr_open_zones=$((max_nr_open_zones * 256 + 0x${b3}))
+		    echo ${max_nr_open_zones}
+		}
+	fi
     else
 	${zbc_report_zones} "$dev" |
 	    sed -n 's/^[[:blank:]]*Maximum number of open sequential write required zones:[[:blank:]]*//p'
-- 
2.20.1


