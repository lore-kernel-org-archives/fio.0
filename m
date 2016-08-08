Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 5/6] Use a pointer to const char* for I/O engine name (in response to aa2b823c)
Date: Tue,  9 Aug 2016 02:27:30 +0900
Message-Id: <1470677251-8292-5-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1470677251-8292-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1470677251-8292-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

aa2b823c also needed to change ioengine_ops::name size to 64,
or make it a pointer to a readonly string which seems to be better
in this case as no one is to (or should be able to) modify it.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 ioengine.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ioengine.h b/ioengine.h
index 0effade..ceed329 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -138,7 +138,7 @@ enum {
 
 struct ioengine_ops {
 	struct flist_head list;
-	char name[16];
+	const char *name;
 	int version;
 	int flags;
 	int (*setup)(struct thread_data *);
-- 
2.5.5


