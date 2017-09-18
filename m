Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/4] add "invalid IO size" to "first direct IO errored." message
Date: Mon, 18 Sep 2017 20:53:47 +0300
Message-Id: <20170918175350.38471-2-tkusumi@tuxera.com>
In-Reply-To: <20170918175350.38471-1-tkusumi@tuxera.com>
References: <20170918175350.38471-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

It could fail due to bs not multiple of sector size.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 ioengines.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ioengines.c b/ioengines.c
index fa4acab..b8a31a8 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -342,8 +342,8 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 	    td->o.odirect) {
 
 		log_info("fio: first direct IO errored. File system may not "
-			 "support direct IO, or iomem_align= is bad. Try "
-			 "setting direct=0.\n");
+			 "support direct IO, or iomem_align= is bad, or "
+			 "invalid IO size. Try setting direct=0.\n");
 	}
 
 	if (!td->io_ops->commit || io_u->ddir == DDIR_TRIM) {
-- 
2.9.5


