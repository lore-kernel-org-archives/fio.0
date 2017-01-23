Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/8] Fix wrong comment on exit condition of threads/processes
Date: Tue, 24 Jan 2017 00:13:06 +0900
Message-Id: <1485184391-11036-3-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
References: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

74f4b020 in 2013 has changed the exit condition from min to max,
so sync the comment with 74f4b020.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 backend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/backend.c b/backend.c
index fc64709..27e36bb 100644
--- a/backend.c
+++ b/backend.c
@@ -1359,7 +1359,7 @@ static bool keep_running(struct thread_data *td)
 		uint64_t diff;
 
 		/*
-		 * If the difference is less than the minimum IO size, we
+		 * If the difference is less than the maximum IO size, we
 		 * are done.
 		 */
 		diff = limit - ddir_rw_sum(td->io_bytes);
-- 
2.5.5


