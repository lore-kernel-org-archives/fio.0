Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 5/5] stat: remove terse v2 blank lines with description not set
Date: Wed, 15 May 2019 16:05:03 -0400
Message-Id: <20190515200503.23000-6-vincentfu@gmail.com>
In-Reply-To: <20190515200503.23000-1-vincentfu@gmail.com>
References: <20190515200503.23000-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

The documentation says that the job description will appear on a second
line if this is set. If it is not set there will be an empty line.
Eliminate the empty line when the description is not set.
---
 stat.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/stat.c b/stat.c
index 2bc21dad..bf87917c 100644
--- a/stat.c
+++ b/stat.c
@@ -1244,12 +1244,13 @@ static void show_thread_status_terse_all(struct thread_stat *ts,
 	/* Additional output if continue_on_error set - default off*/
 	if (ts->continue_on_error)
 		log_buf(out, ";%llu;%d", (unsigned long long) ts->total_err_count, ts->first_error);
-	if (ver == 2)
-		log_buf(out, "\n");
 
 	/* Additional output if description is set */
-	if (strlen(ts->description))
+	if (strlen(ts->description)) {
+		if (ver == 2)
+			log_buf(out, "\n");
 		log_buf(out, ";%s", ts->description);
+	}
 
 	log_buf(out, "\n");
 }
-- 
2.17.1


