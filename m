Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/7] Fix errval variable to be positive errno value
Date: Mon, 13 Mar 2017 20:15:01 +0200
Message-Id: <20170313181503.33322-5-tkusumi@tuxera.com>
In-Reply-To: <20170313181503.33322-1-tkusumi@tuxera.com>
References: <20170313181503.33322-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

The local variable errval is used for strerror(3) which only works
with positive values (i.e. -EXXX doesn't return an expected string).

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/filesetup.c b/filesetup.c
index b04fb3e..f2e47b1 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -447,7 +447,7 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 			f->file_name);
 		ret = td->io_ops->invalidate(td, f);
 		if (ret < 0)
-			errval = ret;
+			errval = -ret;
 	} else if (f->filetype == FIO_TYPE_FILE) {
 		dprint(FD_IO, "declare unneeded cache %s: %llu/%llu\n",
 			f->file_name, off, len);
-- 
2.9.3


