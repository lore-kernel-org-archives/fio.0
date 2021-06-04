Return-Path: <prvs=782ebe97f=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 2/3] t/zbd: Add ignore_zone_limit option to test with special max_open_zones
Date: Fri,  4 Jun 2021 20:32:51 +0900
Message-Id: <20210604113252.765970-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210604113252.765970-1-shinichiro.kawasaki@wdc.com>
References: <20210604113252.765970-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

Recent commit d2f442bc0bd5 ("ioengines: add get_max_open_zones zoned
block device operation") modified fio to compare --max_open_zones option
value and max_open_zones reported by the device. When the option
--max_open_zones is larger than the device limit, fio exits with an
error. However, sometimes it is useful to run fio with --max_open_zones
larger than the device limit to check performance impact of implicit
zone open and close by the zoned block devices. The test script
t/zbd/test-zbd-support has an option -o so that users can specify such
larger max_open_zones value. After the commit, such test runs fail with
the fio error.

To avoid the failure, modify the test script to specify another option
--ignore_zone_limits to fio command, which was added by the commit
575686bb85fa (zbd: add a new --ignore_zone_limits option). This option
is added to fio command only when users specify -o option and special
max_open_zones value to the test script. This change does not affect
default test conditions.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 t/zbd/test-zbd-support | 1 +
 1 file changed, 1 insertion(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 26aff373..015fa1dc 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1348,6 +1348,7 @@ fi
 if [[ -n ${max_open_zones_opt} ]]; then
 	# Override max_open_zones with the script option value
 	max_open_zones="${max_open_zones_opt}"
+	global_var_opts+=("--ignore_zone_limits=1")
 	job_var_opts+=("--max_open_zones=${max_open_zones_opt}")
 fi
 
-- 
2.31.1


