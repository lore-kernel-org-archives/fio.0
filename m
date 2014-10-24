Return-Path: <gwendal@google.com>
Return-Path: <gwendal@google.com>
From: Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH v3] fio: Fix padding properly
Date: Fri, 24 Oct 2014 14:32:59 -0700
Message-Id: <1414186379-24282-1-git-send-email-gwendal@chromium.org>
In-Reply-To: <544ABB51.1040107@kernel.dk>
References: <544ABB51.1040107@kernel.dk>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, vapier@chromium.org, puthik@chromium.org, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

Completely fix padding:
- use anonymous union for padding
- remove remaining padding in thread_stat.

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
 stat.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/stat.h b/stat.h
index 16b3d1a..c2c30b2 100644
--- a/stat.h
+++ b/stat.h
@@ -171,8 +171,10 @@ struct thread_stat {
 	/*
 	 * IO Error related stats
 	 */
-	uint16_t continue_on_error;
-	uint16_t filler[3];
+	union {
+		uint16_t continue_on_error;
+		uint64_t pad;
+	};
 	uint64_t total_err_count;
 	uint32_t first_error;
 
@@ -181,7 +183,6 @@ struct thread_stat {
 
 	uint32_t latency_depth;
 	uint64_t latency_target;
-	uint32_t pad;
 	fio_fp64_t latency_percentile;
 	uint64_t latency_window;
 } __attribute__((packed));
-- 
2.1.0.rc2.206.gedb03e5


