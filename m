Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/6] Acquire file ->lock while the lock itself is being copied
Date: Mon, 13 Feb 2017 18:32:38 +0200
Message-Id: <20170213163239.46188-5-tkusumi@tuxera.com>
In-Reply-To: <20170213163239.46188-1-tkusumi@tuxera.com>
References: <20170213163239.46188-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

to the destination file pointer.
The ones in dup_files() doesn't seem to require locking from
the way it's been called.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/filesetup.c b/filesetup.c
index 3fa8b32..7a67fe6 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -501,9 +501,11 @@ int file_lookup_open(struct fio_file *f, int flags)
 	if (__f) {
 		dprint(FD_FILE, "found file in hash %s\n", f->file_name);
 		/*
-		 * racy, need the __f->lock locked
+		 * get __f->lock while it gets copied to f.
 		 */
+		fio_mutex_down(__f->lock);
 		f->lock = __f->lock;
+		fio_mutex_up(__f->lock);
 		from_hash = 1;
 	} else {
 		dprint(FD_FILE, "file not found in hash %s\n", f->file_name);
-- 
2.9.3


