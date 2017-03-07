Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 11/17] Fix a function name typo in debug print
Date: Tue,  7 Mar 2017 22:13:02 +0200
Message-Id: <20170307201308.66814-12-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 io_u.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_u.c b/io_u.c
index 8d520ab..39aa560 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1960,7 +1960,7 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
 	int ret, ddir;
 	struct timespec ts = { .tv_sec = 0, .tv_nsec = 0, };
 
-	dprint(FD_IO, "io_u_queued_completed: min=%d\n", min_evts);
+	dprint(FD_IO, "io_u_queued_complete: min=%d\n", min_evts);
 
 	if (!min_evts)
 		tvp = &ts;
-- 
2.9.3


