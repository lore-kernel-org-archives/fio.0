Return-Path: <grundler@chromium.org>
From: Grant Grundler <grundler@chromium.org>
Subject: [PATCH] fio: consolidate rand_seed to uint64_t
Date: Tue, 28 Jan 2014 13:02:20 -0800
Message-Id: <1390942940-6886-1-git-send-email-grundler@chromium.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: FIO List <fio@vger.kernel.org>, Puthikorn Voravootivat <puthik@chromium.org>, Gwendal Grignou <gwendal@chromium.org>, Grant Grundler <grundler@chromium.org>
List-ID: <fio@vger.kernel.org>

csscope showed rand_seed was defined 4 times - each a different type.
While they are used differently, the places where they overlap
should reference the same type. This patch makes three of them the same
as suggested by Jens Axboe.

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 ioengine.h       | 2 +-
 thread_options.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ioengine.h b/ioengine.h
index 949af91..0756bc7 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -56,7 +56,7 @@ struct io_u {
 	/*
 	 * Initial seed for generating the buffer contents
 	 */
-	unsigned long rand_seed;
+	uint64_t rand_seed;
 
 	/*
 	 * IO engine state, may be different from above when we get
diff --git a/thread_options.h b/thread_options.h
index 2f807cd..59ddd7e 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -324,7 +324,7 @@ struct thread_options_pack {
 	uint32_t do_disk_util;
 	uint32_t override_sync;
 	uint32_t rand_repeatable;
-	uint32_t rand_seed;
+	uint64_t rand_seed;
 	uint32_t use_os_rand;
 	uint32_t log_avg_msec;
 	uint32_t norandommap;
-- 
1.8.5.3


