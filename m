Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 15/17] Define struct file_name as a file local structure
Date: Tue,  7 Mar 2017 22:13:06 +0200
Message-Id: <20170307201308.66814-16-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This is just an one-off structure for filesetup.c to walk through
all the files (among all jobs), so it can be file local.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 file.h      | 5 -----
 filesetup.c | 8 ++++++++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/file.h b/file.h
index 611470c..c403b17 100644
--- a/file.h
+++ b/file.h
@@ -151,11 +151,6 @@ struct fio_file {
 #define FILE_SET_ENG_DATA(f, data)	\
 	((f)->engine_data = (uintptr_t) (data))
 
-struct file_name {
-	struct flist_head list;
-	char *filename;
-};
-
 #define FILE_FLAG_FNS(name)						\
 static inline void fio_file_set_##name(struct fio_file *f)		\
 {									\
diff --git a/filesetup.c b/filesetup.c
index b240891..68a3ab9 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -24,6 +24,14 @@ static int root_warn;
 
 static FLIST_HEAD(filename_list);
 
+/*
+ * List entry for filename_list
+ */
+struct file_name {
+	struct flist_head list;
+	char *filename;
+};
+
 static inline void clear_error(struct thread_data *td)
 {
 	td->error = 0;
-- 
2.9.3


