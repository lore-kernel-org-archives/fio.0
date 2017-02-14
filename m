Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH v2 6/7] Acquire file ->lock while the lock itself is being copied
Date: Tue, 14 Feb 2017 17:19:47 +0200
Message-Id: <20170214151948.16460-7-tkusumi@tuxera.com>
In-Reply-To: <20170214151948.16460-1-tkusumi@tuxera.com>
References: <20170214151948.16460-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

to the destination file pointer.
The ones in dup_files() doesn't seem to require locking from
the way it's been called.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/falloc.c |  2 +-
 file.h           |  2 +-
 filesetup.c      | 12 +++++++-----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/engines/falloc.c b/engines/falloc.c
index 2b00d52..9dff9bf 100644
--- a/engines/falloc.c
+++ b/engines/falloc.c
@@ -39,7 +39,7 @@ static int open_file(struct thread_data *td, struct fio_file *f)
 	}
 
 open_again:
-	from_hash = file_lookup_open(f, O_CREAT|O_RDWR);
+	from_hash = file_lookup_open(td, f, O_CREAT|O_RDWR);
 
 	if (f->fd == -1) {
 		char buf[FIO_VERROR_SIZE];
diff --git a/file.h b/file.h
index ac00ff8..b9bf75f 100644
--- a/file.h
+++ b/file.h
@@ -192,7 +192,7 @@ extern int __must_check file_invalidate_cache(struct thread_data *, struct fio_f
 extern int __must_check generic_open_file(struct thread_data *, struct fio_file *);
 extern int __must_check generic_close_file(struct thread_data *, struct fio_file *);
 extern int __must_check generic_get_file_size(struct thread_data *, struct fio_file *);
-extern int __must_check file_lookup_open(struct fio_file *f, int flags);
+extern int __must_check file_lookup_open(struct thread_data *, struct fio_file *, int flags);
 extern int __must_check pre_read_files(struct thread_data *);
 extern unsigned long long get_rand_file_size(struct thread_data *td);
 extern int add_file(struct thread_data *, const char *, int, int);
diff --git a/filesetup.c b/filesetup.c
index 3fa8b32..73fc7e6 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -492,7 +492,7 @@ int generic_close_file(struct thread_data fio_unused *td, struct fio_file *f)
 	return ret;
 }
 
-int file_lookup_open(struct fio_file *f, int flags)
+int file_lookup_open(struct thread_data *td, struct fio_file *f, int flags)
 {
 	struct fio_file *__f;
 	int from_hash;
@@ -501,9 +501,11 @@ int file_lookup_open(struct fio_file *f, int flags)
 	if (__f) {
 		dprint(FD_FILE, "found file in hash %s\n", f->file_name);
 		/*
-		 * racy, need the __f->lock locked
+		 * acquire file lock while it gets copied to f.
 		 */
+		lock_file(td, __f, td_read(td) ? DDIR_READ : DDIR_WRITE);
 		f->lock = __f->lock;
+		unlock_file(td, __f);
 		from_hash = 1;
 	} else {
 		dprint(FD_FILE, "file not found in hash %s\n", f->file_name);
@@ -588,7 +590,7 @@ open_again:
 		if (is_std)
 			f->fd = dup(STDOUT_FILENO);
 		else
-			from_hash = file_lookup_open(f, flags);
+			from_hash = file_lookup_open(td, f, flags);
 	} else if (td_read(td)) {
 		if (f->filetype == FIO_TYPE_CHAR && !read_only)
 			flags |= O_RDWR;
@@ -598,10 +600,10 @@ open_again:
 		if (is_std)
 			f->fd = dup(STDIN_FILENO);
 		else
-			from_hash = file_lookup_open(f, flags);
+			from_hash = file_lookup_open(td, f, flags);
 	} else { //td trim
 		flags |= O_RDWR;
-		from_hash = file_lookup_open(f, flags);
+		from_hash = file_lookup_open(td, f, flags);
 	}
 
 	if (f->fd == -1) {
-- 
2.9.3


