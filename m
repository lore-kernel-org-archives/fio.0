Return-Path: <prvs=587eb1fc6=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 14/15] zbd: initialize sectors with data at start time
Date: Sat, 21 Nov 2020 11:45:31 +0900
Message-Id: <20201121024532.16834-15-dmitry.fomichev@wdc.com>
In-Reply-To: <20201121024532.16834-1-dmitry.fomichev@wdc.com>
References: <20201121024532.16834-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Aravind Ramesh <aravind.ramesh@wdc.com>

Based on the flag enable_check_swd, which is false by default, fio
does not initialize the swd value at startup, initializing the swd
value to be zero, even if some zones have sectors with data. This can
result in fio reflecting less than actual swd after a few writes are
completed. In workloads where verify is enabled, fio resets all the
zones and while resetting, it decrements the swd counter with the
actual number of swds in that zone(swd-count - swd-in-zone),
since swd-count is initialized to 0, it results in overflow of the
variable causing unpredictable issues.

So, initialize the swd to the correct value.

Fixes: 409a4f291e7f ("zbd: avoid initializing swd when unnecessary")
Signed-off-by: Aravind Ramesh <aravind.ramesh@wdc.com>
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/zbd.c b/zbd.c
index c364e87c..6a58115d 100644
--- a/zbd.c
+++ b/zbd.c
@@ -946,9 +946,6 @@ static void zbd_init_swd(struct fio_file *f)
 {
 	uint64_t swd;
 
-	if (!enable_check_swd)
-		return;
-
 	swd = zbd_process_swd(f, SET_SWD);
 	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n", __func__, f->file_name,
 	       swd);
-- 
2.21.0


