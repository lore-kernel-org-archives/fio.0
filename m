Return-Path: <prvs=6542a1e1f=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v4 33/38] t/zbd: prevent test #31 from looping
Date: Wed, 27 Jan 2021 13:19:40 +0900
Message-Id: <20210127041945.36909-34-dmitry.fomichev@wdc.com>
In-Reply-To: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

The test 31 starts i/o to 128 zones in parallel.
There are two corner cases that are not properly handled in the
existing implementation -
1) If the total number of zones on the device is < 128, the test
will loop indefinitely because the loop increment is calculated as
zero by the script.
2) If the number of max_open_zones of the device is < 128, the
test will fail due to exceeding max_open_zones limit as the code
expects it to be >= 128.

Limit the number of open zones to the reported maximum
and skip the test if there is not enough zones on the device.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 93456ec6..033c2ebc 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -718,12 +718,18 @@ test31() {
     local bs inc nz off opts size
 
     prep_write
-    # Start with writing 128 KB to 128 sequential zones.
+    # Start with writing 128 KB to max_open_zones sequential zones.
     bs=128K
-    nz=128
+    nz=$((max_open_zones))
+    if [[ $nz -eq 0 ]]; then
+	nz=128
+    fi
     # shellcheck disable=SC2017
     inc=$(((disk_size - (first_sequential_zone_sector * 512)) / (nz * zone_size)
 	   * zone_size))
+    if [ "$inc" -eq 0 ]; then
+	require_seq_zones $nz || return $SKIP_TESTCASE
+    fi
     opts=()
     for ((off = first_sequential_zone_sector * 512; off < disk_size;
 	  off += inc)); do
-- 
2.28.0


