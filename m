Return-Path: <prvs=6334d1505=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v3 21/38] zbd: avoid failing assertion in zbd_convert_to_open_zone()
Date: Thu,  7 Jan 2021 06:57:22 +0900
Message-Id: <20210106215739.264524-22-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

The test run against null_blk with the following command line -

t/zbd/run-tests-against-nullb -l -q -s 12 -t 51 -n 100

stops with a failure and the message below can be seen in the test log:

fio: zbd.c:1110: zbd_convert_to_open_zone: Assertion `open_zone_idx < f->zbd_info->num_open_zones' failed.

This assertion fails because pick_random_zone_idx() function returns
index 0 if no zones are currently open. In this case, open_zone_idx and
f->zbd_info->num_open_zones are both zero. Since this situation is
normal, simply modify the assert statement to avoid failing.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 2656f3ea..f51db783 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1107,7 +1107,8 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		 * Ignore zones which don't belong to thread's offset/size area.
 		 */
 		open_zone_idx = pick_random_zone_idx(f, io_u);
-		assert(open_zone_idx < f->zbd_info->num_open_zones);
+		assert(!open_zone_idx ||
+		       open_zone_idx < f->zbd_info->num_open_zones);
 		tmp_idx = open_zone_idx;
 		for (i = 0; i < f->zbd_info->num_open_zones; i++) {
 			uint32_t tmpz;
-- 
2.28.0


