Return-Path: <prvs=6334d1505=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v3 31/38] t/zbd: fix wrong units in test case #37
Date: Thu,  7 Jan 2021 06:57:32 +0900
Message-Id: <20210106215739.264524-32-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

The second argument of the function total_zone_capacity is expected to
be in bytes. However, the call in test case #37 provides this argument
in sectors and this results in a wrong capacity calculation. Make sure
that the value that is passed to this function is converted to bytes.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 80763561..4d8e905d 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -828,7 +828,7 @@ test37() {
     local bs off size capacity
 
     prep_write
-    capacity=$(total_zone_capacity 1 $first_sequential_zone_sector $dev)
+    capacity=$(total_zone_capacity 1 $((first_sequential_zone_sector*512)) $dev)
     if [ "$first_sequential_zone_sector" = 0 ]; then
 	off=0
     else
-- 
2.28.0


