Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/8] Remove unused io_u's priv union field
Date: Tue, 24 Jan 2017 00:13:07 +0900
Message-Id: <1485184391-11036-4-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
References: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 ioengine.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/ioengine.h b/ioengine.h
index 89873e7..7249df6 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -123,7 +123,6 @@ struct io_u {
 		struct ibv_mr *mr;
 #endif
 		void *mmap_data;
-		uint64_t null;
 	};
 };
 
-- 
2.5.5


