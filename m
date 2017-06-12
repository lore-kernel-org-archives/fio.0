Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/6] splice: don't use void* for pointer arithmetic (gcc)
Date: Mon, 12 Jun 2017 23:02:10 +0300
Message-Id: <20170612200211.17022-6-tkusumi@tuxera.com>
In-Reply-To: <20170612200211.17022-1-tkusumi@tuxera.com>
References: <20170612200211.17022-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

I think gcc extension should be avoided when it can be done by
just changing a pointer type.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/splice.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/engines/splice.c b/engines/splice.c
index eba093e..d5d8ab0 100644
--- a/engines/splice.c
+++ b/engines/splice.c
@@ -32,7 +32,7 @@ static int fio_splice_read_old(struct thread_data *td, struct io_u *io_u)
 	struct fio_file *f = io_u->file;
 	int ret, ret2, buflen;
 	off_t offset;
-	void *p;
+	char *p;
 
 	offset = io_u->offset;
 	buflen = io_u->xfer_buflen;
@@ -77,7 +77,8 @@ static int fio_splice_read(struct thread_data *td, struct io_u *io_u)
 	struct iovec iov;
 	int ret , buflen, mmap_len;
 	off_t offset;
-	void *p, *map;
+	void *map;
+	char *p;
 
 	ret = 0;
 	offset = io_u->offset;
-- 
2.9.4


