Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/2] Don't malloc ioengine_ops for cpp_null
Date: Fri,  6 Jan 2017 02:32:17 +0900
Message-Id: <1483637537-14347-2-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1483637537-14347-1-git-send-email-tkusumi@tuxera.com>
References: <1483637537-14347-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

fio assumes opses aren't dynamically allocated which means malloc'd
engine here never gets freed.

According to 46a67478 and a8075704, the point of get_ioengine() is
how non-static ops gets initialized by g++, but not how space for ops
gets allocated, thus it should just define a static global variable
within "C" scope and pass the address of ops to a caller via **.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/null.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/engines/null.c b/engines/null.c
index 4378f5e..812cadf 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -135,23 +135,21 @@ static void fio_exit fio_null_unregister(void)
 
 #ifdef FIO_EXTERNAL_ENGINE
 extern "C" {
+static struct ioengine_ops ioengine;
 void get_ioengine(struct ioengine_ops **ioengine_ptr)
 {
-	struct ioengine_ops *ioengine;
-
-	*ioengine_ptr = (struct ioengine_ops *) malloc(sizeof(struct ioengine_ops));
-	ioengine = *ioengine_ptr;
-
-	ioengine->name           = "cpp_null";
-	ioengine->version        = FIO_IOOPS_VERSION;
-	ioengine->queue          = fio_null_queue;
-	ioengine->commit         = fio_null_commit;
-	ioengine->getevents      = fio_null_getevents;
-	ioengine->event          = fio_null_event;
-	ioengine->init           = fio_null_init;
-	ioengine->cleanup        = fio_null_cleanup;
-	ioengine->open_file      = fio_null_open;
-	ioengine->flags	         = FIO_DISKLESSIO | FIO_FAKEIO;
+	*ioengine_ptr = &ioengine;
+
+	ioengine.name           = "cpp_null";
+	ioengine.version        = FIO_IOOPS_VERSION;
+	ioengine.queue          = fio_null_queue;
+	ioengine.commit         = fio_null_commit;
+	ioengine.getevents      = fio_null_getevents;
+	ioengine.event          = fio_null_event;
+	ioengine.init           = fio_null_init;
+	ioengine.cleanup        = fio_null_cleanup;
+	ioengine.open_file      = fio_null_open;
+	ioengine.flags          = FIO_DISKLESSIO | FIO_FAKEIO;
 }
 }
 #endif /* FIO_EXTERNAL_ENGINE */
-- 
2.5.5


