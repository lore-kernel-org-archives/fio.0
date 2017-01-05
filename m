Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/2] Fix invalid ioengine initialization for cpp_null
Date: Fri,  6 Jan 2017 02:32:16 +0900
Message-Id: <1483637537-14347-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

->name is a pointer now, so it can't be strcpy'd without a valid
address set to ->name.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/null.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/engines/null.c b/engines/null.c
index f7ba370..4378f5e 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -142,7 +142,7 @@ void get_ioengine(struct ioengine_ops **ioengine_ptr)
 	*ioengine_ptr = (struct ioengine_ops *) malloc(sizeof(struct ioengine_ops));
 	ioengine = *ioengine_ptr;
 
-	strcpy(ioengine->name, "cpp_null");
+	ioengine->name           = "cpp_null";
 	ioengine->version        = FIO_IOOPS_VERSION;
 	ioengine->queue          = fio_null_queue;
 	ioengine->commit         = fio_null_commit;
-- 
2.5.5


