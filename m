Return-Path: <prvs=657d5fab4=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH] zbd: relocate Coverity annotation
Date: Sat, 30 Jan 2021 12:35:24 +0900
Message-Id: <20210130033524.9142-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

The Coverity annotation added earlier to suppress a false positive
about missing unlock in zbd_adjust_block() didn't work because it
was placed not before the return statement, but earlier in the code.

Move the annotation to the right place to avoid the warning.

Reported-by: Bart Van Assche <bvanassche@acm.org>
Fixes: 8e4b2e55512f("zbd: don't unlock zone mutex after verify replay")
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/zbd.c b/zbd.c
index 4710645d..6a26fe10 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1620,12 +1620,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	case DDIR_READ:
 		if (td->runstate == TD_VERIFYING && td_write(td)) {
 			zb = zbd_replay_write_order(td, io_u, zb);
-			/*
-			 * Since we return with the zone lock still held,
-			 * add an annotation to let Coverity know that it
-			 * is intentional.
-			 */
-			/* coverity[missing_unlock] */
 			goto accept;
 		}
 		/*
@@ -1786,6 +1780,12 @@ accept:
 	assert(!io_u->zbd_put_io);
 	io_u->zbd_queue_io = zbd_queue_io;
 	io_u->zbd_put_io = zbd_put_io;
+	/*
+	 * Since we return with the zone lock still held,
+	 * add an annotation to let Coverity know that it
+	 * is intentional.
+	 */
+	/* coverity[missing_unlock] */
 	return io_u_accept;
 
 eof:
-- 
2.28.0


