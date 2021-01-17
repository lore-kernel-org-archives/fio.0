Return-Path: <glqinhongwei@gmail.com>
Return-Path: <glqinhongwei@gmail.com>
From: HongweiQin <glqinhongwei@gmail.com>
Subject: [PATCH v2 2/2] Fix handle_thinktime
Date: Sun, 17 Jan 2021 17:54:23 +0800
Message-Id: <ddfc2f43c96e1ef14cedaf07e473b821391711db.1610876646.git.glqinhongwei@gmail.com>
In-Reply-To: <cover.1610876646.git.glqinhongwei@gmail.com>
References: <cover.1610876646.git.glqinhongwei@gmail.com>
In-Reply-To: <cover.1610876646.git.glqinhongwei@gmail.com>
References: <cover.1610876646.git.glqinhongwei@gmail.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, HongweiQin <glqinhongwei@gmail.com>
List-ID: <fio@vger.kernel.org>

This patch handles thinktime before checking td->bytes_done.
This avoids skipping the thinktime handling when the thread just starts.

Besides, the handle_thinktime also updates the comp_time so that
the rate calculation of check_min_rate() is based on the time after
the thinktime.

Signed-off-by: HongweiQin <glqinhongwei@gmail.com>
---
 backend.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/backend.c b/backend.c
index c85669c..b3e13cb 100644
--- a/backend.c
+++ b/backend.c
@@ -858,7 +858,8 @@ static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
 	return 0;
 }
 
-static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir)
+static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,
+			     struct timespec *time)
 {
 	unsigned long long b;
 	uint64_t total;
@@ -898,6 +899,9 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir)
 		/* adjust for rate_process=poisson */
 		td->last_usec[ddir] += total;
 	}
+
+	if (time && should_check_rate(td))
+		fio_gettime(time, NULL);
 }
 
 /*
@@ -1076,6 +1080,10 @@ reap:
 		}
 		if (ret < 0)
 			break;
+
+		if (ddir_rw(ddir) && td->o.thinktime)
+			handle_thinktime(td, ddir, &comp_time);
+
 		if (!ddir_rw_sum(td->bytes_done) &&
 		    !td_ioengine_flagged(td, FIO_NOIO))
 			continue;
@@ -1090,9 +1098,6 @@ reap:
 		}
 		if (!in_ramp_time(td) && td->o.latency_target)
 			lat_target_check(td);
-
-		if (ddir_rw(ddir) && td->o.thinktime)
-			handle_thinktime(td, ddir);
 	}
 
 	check_update_rusage(td);
-- 
1.8.3.1


