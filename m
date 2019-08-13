Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/5] Verify the size of struct jobs_eta at compile time
Date: Mon, 12 Aug 2019 19:01:33 -0700
Message-Id: <20190813020136.15798-3-bvanassche@acm.org>
In-Reply-To: <20190813020136.15798-1-bvanassche@acm.org>
References: <20190813020136.15798-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

This helps to verify the correctness of a later patch that will modify
this structure.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 eta.c | 2 ++
 fio.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/eta.c b/eta.c
index 647a1bdd8eed..99c537d189a3 100644
--- a/eta.c
+++ b/eta.c
@@ -736,6 +736,8 @@ void print_thread_status(void)
 
 void print_status_init(int thr_number)
 {
+	BUILD_BUG_ON(sizeof(struct jobs_eta) != 160);
+
 	DRD_IGNORE_VAR(__run_str);
 	__run_str[thr_number] = 'P';
 	update_condensed_str(__run_str, run_str);
diff --git a/fio.h b/fio.h
index 2094d30b863e..4bf96fc1cd62 100644
--- a/fio.h
+++ b/fio.h
@@ -66,6 +66,8 @@
 #include <cuda.h>
 #endif
 
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+
 struct fio_sem;
 
 /*
-- 
2.22.0


