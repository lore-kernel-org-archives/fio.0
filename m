Return-Path: <josef@toxicpanda.com>
Return-Path: <josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH] add FIO_FILENOHASH ioengine flag
Date: Mon,  9 Oct 2017 16:31:02 -0400
Message-Id: <1507581062-27315-1-git-send-email-josef@toxicpanda.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
List-ID: <fio@vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

filecreate doesn't use the file hash table, so don't bother doing shared
memory allocations for the file objects, ye olde malloc will work just
fine.  This way we can create millions of files without jacking up
--alloc-size.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 engines/filecreate.c |  2 +-
 filesetup.c          | 26 +++++++++++++++++++++-----
 ioengines.h          |  1 +
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/engines/filecreate.c b/engines/filecreate.c
index 00562c861c2b..c6b659713c49 100644
--- a/engines/filecreate.c
+++ b/engines/filecreate.c
@@ -76,7 +76,7 @@ static struct ioengine_ops ioengine = {
 	.open_file	= open_file,
 	.close_file	= generic_close_file,
 	.flags		= FIO_DISKLESSIO | FIO_SYNCIO | FIO_FAKEIO |
-				FIO_NOSTATS,
+				FIO_NOSTATS | FIO_NOFILEHASH,
 };
 
 static void fio_init fio_filecreate_register(void)
diff --git a/filesetup.c b/filesetup.c
index 789f0ed29ea5..0631a01f96a6 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1342,6 +1342,7 @@ void close_and_free_files(struct thread_data *td)
 {
 	struct fio_file *f;
 	unsigned int i;
+	bool use_free = td_ioengine_flagged(td, FIO_NOFILEHASH);
 
 	dprint(FD_FILE, "close files\n");
 
@@ -1361,13 +1362,19 @@ void close_and_free_files(struct thread_data *td)
 			td_io_unlink_file(td, f);
 		}
 
-		sfree(f->file_name);
+		if (use_free)
+			free(f->file_name);
+		else
+			sfree(f->file_name);
 		f->file_name = NULL;
 		if (fio_file_axmap(f)) {
 			axmap_free(f->io_axmap);
 			f->io_axmap = NULL;
 		}
-		sfree(f);
+		if (use_free)
+			free(f);
+		else
+			sfree(f);
 	}
 
 	td->o.filename = NULL;
@@ -1481,7 +1488,10 @@ static struct fio_file *alloc_new_file(struct thread_data *td)
 {
 	struct fio_file *f;
 
-	f = smalloc(sizeof(*f));
+	if (td_ioengine_flagged(td, FIO_NOFILEHASH))
+		f = calloc(1, sizeof(*f));
+	else
+		f = smalloc(sizeof(*f));
 	if (!f) {
 		assert(0);
 		return NULL;
@@ -1564,7 +1574,10 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 	if (td->io_ops && td_ioengine_flagged(td, FIO_DISKLESSIO))
 		f->real_file_size = -1ULL;
 
-	f->file_name = smalloc_strdup(file_name);
+	if (td_ioengine_flagged(td, FIO_NOFILEHASH))
+		f->file_name = strdup(file_name);
+	else
+		f->file_name = smalloc_strdup(file_name);
 	if (!f->file_name)
 		assert(0);
 
@@ -1769,7 +1782,10 @@ void dup_files(struct thread_data *td, struct thread_data *org)
 		__f = alloc_new_file(td);
 
 		if (f->file_name) {
-			__f->file_name = smalloc_strdup(f->file_name);
+			if (td_ioengine_flagged(td, FIO_NOFILEHASH))
+				__f->file_name = strdup(f->file_name);
+			else
+				__f->file_name = smalloc_strdup(f->file_name);
 			if (!__f->file_name)
 				assert(0);
 
diff --git a/ioengines.h b/ioengines.h
index e744f3f84d3c..32b18edadf1f 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -60,6 +60,7 @@ enum fio_ioengine_flags {
 	FIO_BIT_BASED	= 1 << 10,	/* engine uses a bit base (e.g. uses Kbit as opposed to KB) */
 	FIO_FAKEIO	= 1 << 11,	/* engine pretends to do IO */
 	FIO_NOSTATS	= 1 << 12,	/* don't do IO stats */
+	FIO_NOFILEHASH	= 1 << 13,	/* doesn't hash the files for lookup later. */
 };
 
 /*
-- 
2.7.4


