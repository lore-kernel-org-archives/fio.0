Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/3] Add a comment to clarify 941bda94
Date: Sat, 11 Feb 2017 16:28:53 +0200
Message-Id: <20170211142854.23620-2-tkusumi@tuxera.com>
In-Reply-To: <20170211142854.23620-1-tkusumi@tuxera.com>
References: <20170211142854.23620-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 diskutil.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/diskutil.h b/diskutil.h
index 04fdde2..f773066 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -114,6 +114,7 @@ extern int update_io_ticks(void);
 extern void setup_disk_util(void);
 extern void disk_util_prune_entries(void);
 #else
+/* keep this as a function to avoid a warning in handle_du() */
 static inline void print_disk_util(struct disk_util_stat *du,
 				   struct disk_util_agg *agg, int terse,
 				   struct buf_output *out)
-- 
2.9.3


