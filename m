Return-Path: <prvs=565f703da=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 2/2] t/zbd: Fix test target size of test case #48
Date: Fri, 30 Oct 2020 15:57:40 +0900
Message-Id: <20201030065740.2039936-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20201030065740.2039936-1-shinichiro.kawasaki@wdc.com>
References: <20201030065740.2039936-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

Option --size was not specified to the fio command of test case #48. It
resulted in write operations to all available sequential write required
zones and relaxed zone locking test condition. Specify the option to
limit test target to 16 zones so that zone locking is tested with
expected condition.

Fixes: 3bd2078bdd1c ("zbd: add test for stressing zone locking")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 248423bb..acde3b3a 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -913,7 +913,7 @@ test48() {
     for ((i=0;i<jobs;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
 	opts+=("--io_size=$zone_size" "--iodepth=256" "--thread=1")
-	opts+=("--group_reporting=1")
+	opts+=("--size=$size" "--group_reporting=1")
 	# max_open_zones is already specified
 	opts+=($(job_var_opts_exclude "--max_open_zones"))
     done
-- 
2.26.2


