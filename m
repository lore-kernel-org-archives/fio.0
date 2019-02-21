Return-Path: <prvs=94868c4cd=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 8/9] zbd: Avoid async I/O multi-job workload deadlock
Date: Thu, 21 Feb 2019 13:11:06 +0900
Message-Id: <20190221041107.8576-9-damien.lemoal@wdc.com>
In-Reply-To: <20190221041107.8576-1-damien.lemoal@wdc.com>
References: <20190221041107.8576-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Matias Bjorling <matias.bjorling@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

With zonemode=zbd, for a multi-job workload using asynchronous I/O
engines with a deep I/O queue depth setting, a job that is building a
batch of asynchronous I/Os to submit may end up waiting for an I/O
target zone lock held by another job that is also preparing a batch.
For small devices with few zones and/or a large number of jobs, such
prepare phase zone lock contention can be frequent enough to end up in a
situation where all jobs are waiting for zone locks held by other jobs
and no I/O being executed (so no zone being unlocked).

Avoid this situation by using pthread_mutex_trylock() instead of
pthread_mutex_lock() and by calling io_u_quiesce() to execute queued
I/O units if locking fails. pthread_mutex_lock() is then called to
lock the desired target zone. The execution of io_u_quiesce() forces
I/O execution progress and so zones to be unlocked, avoiding job
deadlock.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 310b1732..2da742b7 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1255,7 +1255,21 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 	zbd_check_swd(f);
 
-	pthread_mutex_lock(&zb->mutex);
+	/*
+	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
+	 * is changed or when io_u completes and zbd_put_io() executed.
+	 * To avoid multiple jobs doing asynchronous I/Os from deadlocking each
+	 * other waiting for zone locks when building an io_u batch, first
+	 * only trylock the zone. If the zone is already locked by another job,
+	 * process the currently queued I/Os so that I/O progress is made and
+	 * zones unlocked.
+	 */
+	if (pthread_mutex_trylock(&zb->mutex) != 0) {
+		if (!td_ioengine_flagged(td, FIO_SYNCIO))
+			io_u_quiesce(td);
+		pthread_mutex_lock(&zb->mutex);
+	}
+
 	switch (io_u->ddir) {
 	case DDIR_READ:
 		if (td->runstate == TD_VERIFYING) {
-- 
2.20.1


