Return-Path: <gwendal@google.com>
Return-Path: <gwendal@google.com>
From: Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH] fio: fix alignement to prevent bus error on ARM
Date: Fri, 24 Oct 2014 13:42:37 -0700
Message-Id: <1414183357-31504-1-git-send-email-gwendal@chromium.org>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, vapier@chromium.org, puthik@chromium.org, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

Add a filler field to be ensure 64bit alignment.
Otherwise, we would trigger SIGBUS error in sum_stat()

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
 stat.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/stat.h b/stat.h
index 32ea226..9595e59 100644
--- a/stat.h
+++ b/stat.h
@@ -172,6 +172,7 @@ struct thread_stat {
 	 * IO Error related stats
 	 */
 	uint16_t continue_on_error;
+	uint16_t filler[3];
 	uint64_t total_err_count;
 	uint32_t first_error;
 
-- 
2.1.0.rc2.206.gedb03e5


