Return-Path: <rjevskiy@gmail.com>
Sender: Dmitry Monakhov <rjevskiy@gmail.com>
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/4] export file_lookup_open
Date: Wed, 19 Sep 2012 23:22:53 +0400
Message-Id: <1348082576-10528-2-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1348082576-10528-1-git-send-email-dmonakhov@openvz.org>
References: <1348082576-10528-1-git-send-email-dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, fio@vger.kernel.org
Cc: axboe@kernel.dk, Dmitry Monakhov <dmonakhov@openvz.org>
List-ID: <fio@vger.kernel.org>

generic_open_file is not always appropriate method, but other modules
may want to implement similar callback and use hash optimization.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 file.h      |    1 +
 filesetup.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/file.h b/file.h
index 68f9a6e..42fd58c 100644
--- a/file.h
+++ b/file.h
@@ -153,6 +153,7 @@ extern int __must_check file_invalidate_cache(struct thread_data *, struct fio_f
 extern int __must_check generic_open_file(struct thread_data *, struct fio_file *);
 extern int __must_check generic_close_file(struct thread_data *, struct fio_file *);
 extern int __must_check generic_get_file_size(struct thread_data *, struct fio_file *);
+extern int __must_check file_lookup_open(struct fio_file *f, int flags);
 extern int __must_check pre_read_files(struct thread_data *);
 extern int add_file(struct thread_data *, const char *);
 extern int add_file_exclusive(struct thread_data *, const char *);
diff --git a/filesetup.c b/filesetup.c
index 64da8bb..06b7d7f 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -435,7 +435,7 @@ int generic_close_file(struct thread_data fio_unused *td, struct fio_file *f)
 	return ret;
 }
 
-static int file_lookup_open(struct fio_file *f, int flags)
+int file_lookup_open(struct fio_file *f, int flags)
 {
 	struct fio_file *__f;
 	int from_hash;
-- 
1.7.7.6


