Return-Path: <dehrenberg@google.com>
From: Dan Ehrenberg <dehrenberg@google.com>
Subject: [PATCH] Fixing wraparound behavior for time-based sequential read jobs
Date: Wed, 15 Aug 2012 15:08:18 -0700
Message-Id: <1345068498-3732-1-git-send-email-dehrenberg@google.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: nauman@google.com, jhr@google.com, akashv@google.com, aschade@google.com, Dan Ehrenberg <dehrenberg@google.com>
List-ID: <fio@vger.kernel.org>

Previously, a buggy patch made sequential jobs wrap around when they
reached an offset of 'size'. However, the appropriate wraparound is at
size + initial offset. This patch restores the previous behavior.
---
 file.h      |    1 +
 filesetup.c |    9 +++++++--
 io_u.c      |    4 ++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/file.h b/file.h
index 51df839..68f9a6e 100644
--- a/file.h
+++ b/file.h
@@ -147,6 +147,7 @@ FILE_FLAG_FNS(partial_mmap);
 struct thread_data;
 extern void close_files(struct thread_data *);
 extern void close_and_free_files(struct thread_data *);
+extern unsigned long long get_start_offset(struct thread_data *);
 extern int __must_check setup_files(struct thread_data *);
 extern int __must_check file_invalidate_cache(struct thread_data *, struct fio_file *);
 extern int __must_check generic_open_file(struct thread_data *, struct fio_file *);
diff --git a/filesetup.c b/filesetup.c
index 6277f0f..3594a80 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -657,6 +657,12 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 	return ret;
 }
 
+unsigned long long get_start_offset(struct thread_data *td)
+{
+	return td->o.start_offset +
+		(td->thread_number - 1) * td->o.offset_increment;
+}
+
 /*
  * Open the files and setup files sizes, creating files if necessary.
  */
@@ -718,8 +724,7 @@ int setup_files(struct thread_data *td)
 	extend_size = total_size = 0;
 	need_extend = 0;
 	for_each_file(td, f, i) {
-		f->file_offset = td->o.start_offset +
-			(td->thread_number - 1) * td->o.offset_increment;
+		f->file_offset = get_start_offset(td);
 
 		if (!td->o.file_size_low) {
 			/*
diff --git a/io_u.c b/io_u.c
index 6646332..2f54562 100644
--- a/io_u.c
+++ b/io_u.c
@@ -256,7 +256,7 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 {
 	assert(ddir_rw(ddir));
 
-	if (f->last_pos >= f->io_size && td->o.time_based)
+	if (f->last_pos >= f->io_size + get_start_offset(td) && td->o.time_based)
 		f->last_pos = f->last_pos - f->io_size;
 
 	if (f->last_pos < f->real_file_size) {
@@ -377,7 +377,7 @@ static inline int io_u_fits(struct thread_data *td, struct io_u *io_u,
 {
 	struct fio_file *f = io_u->file;
 
-	return io_u->offset + buflen <= f->io_size + td->o.start_offset;
+	return io_u->offset + buflen <= f->io_size + get_start_offset(td);
 }
 
 static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u)
-- 
1.7.7.3


