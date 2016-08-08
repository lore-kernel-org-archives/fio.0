Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 3/6] Make local const string array static
Date: Tue,  9 Aug 2016 02:27:28 +0900
Message-Id: <1470677251-8292-3-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1470677251-8292-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1470677251-8292-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

like it is in io_ddir_name().

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 io_ddir.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_ddir.h b/io_ddir.h
index 763e826..2141119 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -61,7 +61,7 @@ static inline int ddir_rw(enum fio_ddir ddir)
 
 static inline const char *ddir_str(enum td_ddir ddir)
 {
-	const char *__str[] = { NULL, "read", "write", "rw", NULL,
+	static const char *__str[] = { NULL, "read", "write", "rw", NULL,
 				"randread", "randwrite", "randrw",
 				"trim", NULL, NULL, NULL, "randtrim" };
 
-- 
2.5.5


