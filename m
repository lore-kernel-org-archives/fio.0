Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 14/17] HOWTO: Add some details for invalidate=
Date: Tue,  7 Mar 2017 22:13:05 +0200
Message-Id: <20170307201308.66814-15-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO  | 4 +++-
 init.c | 6 +++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index 018800a..af6cd71 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1426,7 +1426,9 @@ Buffers and memory
 .. option:: invalidate=bool
 
 	Invalidate the buffer/page cache parts for this file prior to starting
-	I/O. Defaults to true.
+	I/O if the platform and file type support it. Defaults to true.
+	This will be ignored if :option:`pre_read` is also specified for the
+	same job.
 
 .. option:: sync=bool
 
diff --git a/init.c b/init.c
index 5353890..18538de 100644
--- a/init.c
+++ b/init.c
@@ -764,7 +764,11 @@ static int fixup_options(struct thread_data *td)
 	}
 
 	if (o->pre_read) {
-		o->invalidate_cache = 0;
+		if (o->invalidate_cache) {
+			log_info("fio: ignore invalidate option for %s\n",
+				 o->name);
+			o->invalidate_cache = 0;
+		}
 		if (td_ioengine_flagged(td, FIO_PIPEIO)) {
 			log_info("fio: cannot pre-read files with an IO engine"
 				 " that isn't seekable. Pre-read disabled.\n");
-- 
2.9.3


