Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/7] Minor fixup for page cache invalidation debug prints
Date: Mon, 13 Mar 2017 20:14:59 +0200
Message-Id: <20170313181503.33322-3-tkusumi@tuxera.com>
In-Reply-To: <20170313181503.33322-1-tkusumi@tuxera.com>
References: <20170313181503.33322-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

offset/length is used only for posix_fadvise(2), and each invalidation
method has its own meaning, so use different messages for them.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index 4d0b127..085d0c8 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -442,20 +442,22 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 	if (len == -1ULL || off == -1ULL)
 		return 0;
 
-	dprint(FD_IO, "invalidate cache %s: %llu/%llu\n", f->file_name, off,
-								len);
-
 	if (td->io_ops->invalidate) {
+		dprint(FD_IO, "invalidate %s cache %s\n", td->io_ops->name,
+			f->file_name);
 		ret = td->io_ops->invalidate(td, f);
 		if (ret < 0)
 			errval = ret;
 	} else if (f->filetype == FIO_TYPE_FILE) {
+		dprint(FD_IO, "declare unneeded cache %s: %llu/%llu\n",
+			f->file_name, off, len);
 		ret = posix_fadvise(f->fd, off, len, POSIX_FADV_DONTNEED);
 		if (ret)
 			errval = ret;
 	} else if (f->filetype == FIO_TYPE_BLOCK) {
 		int retry_count = 0;
 
+		dprint(FD_IO, "drop page cache %s\n", f->file_name);
 		ret = blockdev_invalidate_cache(f);
 		while (ret < 0 && errno == EAGAIN && retry_count++ < 25) {
 			/*
@@ -477,8 +479,11 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 		}
 		if (ret < 0)
 			errval = errno;
-	} else if (f->filetype == FIO_TYPE_CHAR || f->filetype == FIO_TYPE_PIPE)
+	} else if (f->filetype == FIO_TYPE_CHAR ||
+		   f->filetype == FIO_TYPE_PIPE) {
+		dprint(FD_IO, "invalidate not supported %s\n", f->file_name);
 		ret = 0;
+	}
 
 	/*
 	 * Cache flushing isn't a fatal condition, and we know it will
-- 
2.9.3


