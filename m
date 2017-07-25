Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/4] drop logging when blkdev invalidation failed on unsupported platforms
Date: Tue, 25 Jul 2017 22:05:44 +0300
Message-Id: <20170725190544.66919-5-tkusumi@tuxera.com>
In-Reply-To: <20170725190544.66919-1-tkusumi@tuxera.com>
References: <20170725190544.66919-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

22de5d77('Use ENOTSUP if OS doesn't support blkdev page cache invalidation')
changed errno values being used on supported platforms to ENOTSUP,
and also log_info'd it via strerror(), but strerror() isn't working
on some platform and instead prints irrelevant string.

Re: fio Windows Invalidate
http://www.spinics.net/lists/fio/msg06084.html

The logging of ENOTSUP could just be dropped since this isn't a real
failure, as many platforms either don't have the idea of invalidating
blkdev's page cache mapping, or use chrdev for block devices.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index 38ad9ed..3b2ebd9 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -528,8 +528,6 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 		}
 		if (ret < 0)
 			errval = errno;
-		else if (ret) /* probably not supported */
-			errval = ret;
 	} else if (f->filetype == FIO_TYPE_CHAR ||
 		   f->filetype == FIO_TYPE_PIPE) {
 		dprint(FD_IO, "invalidate not supported %s\n", f->file_name);
-- 
2.9.4


