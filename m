Return-Path: <glqinhongwei@gmail.com>
Return-Path: <glqinhongwei@gmail.com>
From: HongweiQin <glqinhongwei@gmail.com>
Subject: [PATCH] Fix thinktime_blocks
Date: Sun, 17 Jan 2021 14:24:16 +0800
Message-Id: <1610864656-6451-1-git-send-email-glqinhongwei@gmail.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, HongweiQin <glqinhongwei@gmail.com>
List-ID: <fio@vger.kernel.org>

According to the manual, the thinktime_blocks controls how many blocks to issue (instead of complete) before waiting.

Signed-off-by: HongweiQin <glqinhongwei@gmail.com>
---
 backend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/backend.c b/backend.c
index e20a2e0..c85669c 100644
--- a/backend.c
+++ b/backend.c
@@ -864,7 +864,7 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir)
 	uint64_t total;
 	int left;
 
-	b = ddir_rw_sum(td->io_blocks);
+	b = ddir_rw_sum(td->io_issues);
 	if (b % td->o.thinktime_blocks)
 		return;
 
-- 
1.8.3.1


