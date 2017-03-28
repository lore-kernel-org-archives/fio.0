Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 10/13] Drop prototype of unused function td_io_sync()
Date: Tue, 28 Mar 2017 23:02:58 +0300
Message-Id: <20170328200301.8622-10-tkusumi@tuxera.com>
In-Reply-To: <20170328200301.8622-1-tkusumi@tuxera.com>
References: <20170328200301.8622-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

858a3d47 in 2006 has removed (actually renamed) this function,
so this prototype hasn't been used since then.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 ioengine.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/ioengine.h b/ioengine.h
index 7249df6..dc2c269 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -190,7 +190,6 @@ typedef void (*get_ioengine_t)(struct ioengine_ops **);
 extern int __must_check td_io_init(struct thread_data *);
 extern int __must_check td_io_prep(struct thread_data *, struct io_u *);
 extern int __must_check td_io_queue(struct thread_data *, struct io_u *);
-extern int __must_check td_io_sync(struct thread_data *, struct fio_file *);
 extern int __must_check td_io_getevents(struct thread_data *, unsigned int, unsigned int, const struct timespec *);
 extern int __must_check td_io_commit(struct thread_data *);
 extern int __must_check td_io_open_file(struct thread_data *, struct fio_file *);
-- 
2.9.3


