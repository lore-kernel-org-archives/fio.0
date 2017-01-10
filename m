Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/4] Partly revert 8172fe97 in 2008 (A few debug debug log fixes)
Date: Wed, 11 Jan 2017 02:39:44 +0900
Message-Id: <1484069987-13105-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Not sure what the point of 8172fe97 was, but shouldn't all the
prints within a single line be dprint() (or all be log_info()) ?

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 ioengine.h | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/ioengine.h b/ioengine.h
index 08e8fab..89873e7 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -238,12 +238,9 @@ static inline void dprint_io_u(struct io_u *io_u, const char *p)
 	dprint(FD_IO, "%s: io_u %p: off=%llu/len=%lu/ddir=%d", p, io_u,
 					(unsigned long long) io_u->offset,
 					io_u->buflen, io_u->ddir);
-	if (fio_debug & (1 << FD_IO)) {
-		if (f)
-			log_info("/%s", f->file_name);
-
-		log_info("\n");
-	}
+	if (f)
+		dprint(FD_IO, "/%s", f->file_name);
+	dprint(FD_IO, "\n");
 }
 #else
 #define dprint_io_u(io_u, p)
-- 
2.5.5


