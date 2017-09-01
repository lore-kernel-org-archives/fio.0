Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH] fix regression by 8c43ba62('filesetup: align layout buffer')
Date: Fri,  1 Sep 2017 15:24:23 +0300
Message-Id: <20170901122423.94484-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

8c43ba62('filesetup: align layout buffer') needs to use the same size
for fio_memalign() and fio_memfree().

If the size `bs' gets decreased while in the write(2) loop, the size
for freeing is smaller than it should be, and results in segfault
by dereferencing ->offset of the footer via irrelevant address somewhere
in user data.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index c4240d2..5e8ea35 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -110,7 +110,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 {
 	int new_layout = 0, unlink_file = 0, flags;
 	unsigned long long left;
-	unsigned int bs;
+	unsigned int bs, alloc_size = 0;
 	char *b = NULL;
 
 	if (read_only) {
@@ -204,7 +204,8 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 	if (bs > left)
 		bs = left;
 
-	b = fio_memalign(page_size, bs);
+	alloc_size = bs;
+	b = fio_memalign(page_size, alloc_size);
 	if (!b) {
 		td_verror(td, errno, "fio_memalign");
 		goto err;
@@ -259,14 +260,14 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 			f->io_size = f->real_file_size;
 	}
 
-	fio_memfree(b, bs);
+	fio_memfree(b, alloc_size);
 done:
 	return 0;
 err:
 	close(f->fd);
 	f->fd = -1;
 	if (b)
-		fio_memfree(b, bs);
+		fio_memfree(b, alloc_size);
 	return 1;
 }
 
-- 
2.9.5


