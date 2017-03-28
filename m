Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 06/13] Drop redundant "ignore invalidate option" message from 21c1b29e
Date: Tue, 28 Mar 2017 23:02:54 +0300
Message-Id: <20170328200301.8622-6-tkusumi@tuxera.com>
In-Reply-To: <20170328200301.8622-1-tkusumi@tuxera.com>
References: <20170328200301.8622-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

The message added by 21c1b29e ("fio: ignore invalidate option...")
is correct in the sense that it resets invalidate= option, however
since invalidation is enabled by default, this message appears whenever
pre_read=1 is set (unless invalidate=0 is also explicitly set at the
same time, which is unliekly).

This is annoying and shouldn't have been added. 21c1b29e updating
HOWTO was enough, sorry.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 init.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/init.c b/init.c
index eef5150..c29a1b4 100644
--- a/init.c
+++ b/init.c
@@ -766,11 +766,8 @@ static int fixup_options(struct thread_data *td)
 	}
 
 	if (o->pre_read) {
-		if (o->invalidate_cache) {
-			log_info("fio: ignore invalidate option for %s\n",
-				 o->name);
+		if (o->invalidate_cache)
 			o->invalidate_cache = 0;
-		}
 		if (td_ioengine_flagged(td, FIO_PIPEIO)) {
 			log_info("fio: cannot pre-read files with an IO engine"
 				 " that isn't seekable. Pre-read disabled.\n");
-- 
2.9.3


