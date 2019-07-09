Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH] engines/http: set FIO_SYNCIO flag
Date: Tue,  9 Jul 2019 10:54:40 -0400
Message-Id: <20190709145440.18297-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

This ioengine carries out synchronous operations. So the FIO_SYNCIO flag
needs to be set in order for latencies to be calculated correctly.

Fixes: https://github.com/axboe/fio/issues/797
---
 engines/http.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/engines/http.c b/engines/http.c
index a35c0332..275fcab5 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -642,7 +642,7 @@ static int fio_http_invalidate(struct thread_data *td, struct fio_file *f)
 static struct ioengine_ops ioengine = {
 	.name = "http",
 	.version		= FIO_IOOPS_VERSION,
-	.flags			= FIO_DISKLESSIO,
+	.flags			= FIO_DISKLESSIO | FIO_SYNCIO,
 	.setup			= fio_http_setup,
 	.queue			= fio_http_queue,
 	.getevents		= fio_http_getevents,
-- 
2.17.1


