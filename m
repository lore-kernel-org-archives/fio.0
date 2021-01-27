Return-Path: <prvs=6542a1e1f=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v4 09/38] zbd: don't unlock zone mutex after verify replay
Date: Wed, 27 Jan 2021 13:19:16 +0900
Message-Id: <20210127041945.36909-10-dmitry.fomichev@wdc.com>
In-Reply-To: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

zbd_adjust_block() always returns with the zone locked if the i/o is
accepted. The corresponding unlock happens in zbd_put_io(). The
function description says -

 * Locking strategy: returns with z->mutex locked if and only if z refers
 * to a sequential zone and if io_u_accept is returned. z is the zone that
 * corresponds to io_u->offset at the end of this function.

Remove the recently added unlock after zbd_replay_write_order() call.
Add a Coverity annotation to mark the absence of unlock as intentional.

Fixes: b2726d53bb5d ("zbd: Add a missing pthread_mutex_unlock() call")
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index a3c1ff9a..1ac1357b 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1561,7 +1561,12 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	case DDIR_READ:
 		if (td->runstate == TD_VERIFYING && td_write(td)) {
 			zb = zbd_replay_write_order(td, io_u, zb);
-			zone_unlock(zb);
+			/*
+			 * Since we return with the zone lock still held,
+			 * add an annotation to let Coverity know that it
+			 * is intentional.
+			 */
+			/* coverity[missing_unlock] */
 			goto accept;
 		}
 		/*
-- 
2.28.0


