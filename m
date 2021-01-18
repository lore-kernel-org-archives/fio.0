Return-Path: <glqinhongwei@gmail.com>
Return-Path: <glqinhongwei@gmail.com>
From: Hongwei Qin <glqinhongwei@gmail.com>
Subject: [PATCH v3 2/2] Calculate min_rate with the consideration of thinktime
Date: Mon, 18 Jan 2021 13:19:55 +0800
Message-Id: <a6128298258fd7a76e0c3bc9c91d003f3cf7b4c4.1610946213.git.glqinhongwei@gmail.com>
In-Reply-To: <cover.1610946213.git.glqinhongwei@gmail.com>
References: <cover.1610946213.git.glqinhongwei@gmail.com>
In-Reply-To: <cover.1610946213.git.glqinhongwei@gmail.com>
References: <cover.1610946213.git.glqinhongwei@gmail.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, sitsofe@gmail.com, Hongwei Qin <glqinhongwei@gmail.com>
List-ID: <fio@vger.kernel.org>

This patch updates the compare time if handle_thinktime
sleeps or spin.

Signed-off-by: Hongwei Qin <glqinhongwei@gmail.com>
---
 backend.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/backend.c b/backend.c
index 874e193..f2efddd 100644
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
@@ -1078,7 +1082,7 @@ reap:
 			break;
 
 		if (ddir_rw(ddir) && td->o.thinktime)
-			handle_thinktime(td, ddir);
+			handle_thinktime(td, ddir, &comp_time);
 
 		if (!ddir_rw_sum(td->bytes_done) &&
 		    !td_ioengine_flagged(td, FIO_NOIO))
-- 
1.8.3.1


