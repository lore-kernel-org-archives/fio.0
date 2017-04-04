Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/8] dump_td_info() doesn't really need to be a function
Date: Tue,  4 Apr 2017 23:22:12 +0300
Message-Id: <20170404202218.52260-2-tkusumi@tuxera.com>
In-Reply-To: <20170404202218.52260-1-tkusumi@tuxera.com>
References: <20170404202218.52260-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

since it's short enough, and too specific to be called as dump_td_info().

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 backend.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/backend.c b/backend.c
index e5be187..67b4c6b 100644
--- a/backend.c
+++ b/backend.c
@@ -1861,14 +1861,6 @@ err:
 	return (void *) (uintptr_t) td->error;
 }
 
-static void dump_td_info(struct thread_data *td)
-{
-	log_err("fio: job '%s' (state=%d) hasn't exited in %lu seconds, it "
-		"appears to be stuck. Doing forceful exit of this job.\n",
-			td->o.name, td->runstate,
-			(unsigned long) time_since_now(&td->terminate_time));
-}
-
 /*
  * Run over the job map and reap the threads that have exited, if any.
  */
@@ -1953,7 +1945,11 @@ static void reap_threads(unsigned int *nr_running, uint64_t *t_rate,
 		if (td->terminate &&
 		    td->runstate < TD_FSYNCING &&
 		    time_since_now(&td->terminate_time) >= FIO_REAP_TIMEOUT) {
-			dump_td_info(td);
+			log_err("fio: job '%s' (state=%d) hasn't exited in "
+				"%lu seconds, it appears to be stuck. Doing "
+				"forceful exit of this job.\n",
+				td->o.name, td->runstate,
+				(unsigned long) time_since_now(&td->terminate_time));
 			td_set_runstate(td, TD_REAPED);
 			goto reaped;
 		}
-- 
2.9.3


