Return-Path: <tkusumi@tuxera.com>
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: [PATCH 1/2] Drop obsolete comment on a race condition
Date: Wed, 15 Feb 2017 22:40:54 +0200
Message-ID: <20170215204055.50646-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

which is also mentioned in below posts.

http://www.spinics.net/lists/fio/msg05548.html
http://www.spinics.net/lists/fio/msg05552.html
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index 3fa8b32..e9976eb 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -500,9 +500,6 @@ int file_lookup_open(struct fio_file *f, int flags)
 	__f = lookup_file_hash(f->file_name);
 	if (__f) {
 		dprint(FD_FILE, "found file in hash %s\n", f->file_name);
-		/*
-		 * racy, need the __f->lock locked
-		 */
 		f->lock = __f->lock;
 		from_hash = 1;
 	} else {
-- 
2.9.3


