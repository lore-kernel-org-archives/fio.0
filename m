Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:55907 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhFAGth (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 1 Jun 2021 02:49:37 -0400
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/3] t/zbd: Use max_open_zones that fio fetched from device
Date: Tue,  1 Jun 2021 15:47:51 +0900
Message-Id: <20210601064753.734892-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210601064753.734892-1-shinichiro.kawasaki@wdc.com>
References: <20210601064753.734892-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Recent commit d2f442bc0bd5 ("ioengines: add get_max_open_zones zoned
block device operation") modified fio to compare --max_open_zoned option
value and max_open_zones reported by the device. The device limit is
fetched through sysfs or through an ioengine specific implementation.

The test script currently try to fetch the max open zones limit using
libzbc tools or sg_inq. If either of these fail, default value 128 is
supplied. This default value can be too high when the test script is
run for certain zoned block devices, and can therefore result in fio
error and test case failure.

To avoid the failure, modify the default value used in the test script
from 128 to 0. With this, --max_open_zoned=0 is passed to fio, and it
makes fio use the max_open_zones reported by the device.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index 40ffe1de..1a7ea970 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -180,8 +180,8 @@ max_open_zones() {
 	if ! ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" \
 		 > /dev/null 2>&1; then
 	    # Non scsi device such as null_blk can not return max open zones.
-	    # Use default value.
-	    echo 128
+	    # Specify 0 to indicate fio to get max open zones from the device.
+	    echo 0
 	else
 	    ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" | tail -1 |
 		{
-- 
2.31.1


