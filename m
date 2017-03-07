Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 16/17] Use union for per file engine private data storage
Date: Tue,  7 Mar 2017 22:13:07 +0200
Message-Id: <20170307201308.66814-17-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

fio_file::engine_data has been used by i/o engines to either keep
the offset or point to engine specific private data with casts.

This commit changes it to a union consists of void* and uint64_t
so get/set of offset/pointer can be done without casts (which is
a common technique used even within this same struct).

This may break external engines on compile time, but fio generally
doesn't care about breakage on external engines (no guarantees on
api/abi compatibility) anyway.

Also confirmed this compiles with pmemblk enabled.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/glusterfs_sync.c |  2 +-
 engines/pmemblk.c        | 16 ++++++----------
 engines/sync.c           |  2 +-
 file.h                   | 12 +++++++-----
 filesetup.c              |  2 +-
 5 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/engines/glusterfs_sync.c b/engines/glusterfs_sync.c
index 05e184c..25d05b2 100644
--- a/engines/glusterfs_sync.c
+++ b/engines/glusterfs_sync.c
@@ -7,7 +7,7 @@
 
 #include "gfapi.h"
 
-#define LAST_POS(f)	((f)->engine_data)
+#define LAST_POS(f)	((f)->engine_pos)
 static int fio_gf_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index e8476f9..52af9ed 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -86,10 +86,6 @@ struct fio_pmemblk_file {
 	size_t pmb_bsize;
 	size_t pmb_nblocks;
 };
-#define FIOFILEPMBSET(_f, _v)  do {                 \
-	(_f)->engine_data = (uint64_t)(uintptr_t)(_v);  \
-} while(0)
-#define FIOFILEPMBGET(_f)  ((fio_pmemblk_file_t)((_f)->engine_data))
 
 static fio_pmemblk_file_t Cache;
 
@@ -304,26 +300,26 @@ static int fio_pmemblk_open_file(struct thread_data *td, struct fio_file *f)
 	if (!pmb)
 		return 1;
 
-	FIOFILEPMBSET(f, pmb);
+	FILE_SET_ENG_DATA(f, pmb);
 	return 0;
 }
 
 static int fio_pmemblk_close_file(struct thread_data fio_unused *td,
 				  struct fio_file *f)
 {
-	fio_pmemblk_file_t pmb = FIOFILEPMBGET(f);
+	fio_pmemblk_file_t pmb = FILE_ENG_DATA(f);
 
 	if (pmb)
 		pmb_close(pmb, false);
 
-	FIOFILEPMBSET(f, NULL);
+	FILE_SET_ENG_DATA(f, NULL);
 	return 0;
 }
 
 static int fio_pmemblk_get_file_size(struct thread_data *td, struct fio_file *f)
 {
 	uint64_t flags = 0;
-	fio_pmemblk_file_t pmb = FIOFILEPMBGET(f);
+	fio_pmemblk_file_t pmb = FILE_ENG_DATA(f);
 
 	if (fio_file_size_known(f))
 		return 0;
@@ -340,7 +336,7 @@ static int fio_pmemblk_get_file_size(struct thread_data *td, struct fio_file *f)
 
 	fio_file_set_size_known(f);
 
-	if (!FIOFILEPMBGET(f))
+	if (!FILE_ENG_DATA(f))
 		pmb_close(pmb, true);
 
 	return 0;
@@ -349,7 +345,7 @@ static int fio_pmemblk_get_file_size(struct thread_data *td, struct fio_file *f)
 static int fio_pmemblk_queue(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
-	fio_pmemblk_file_t pmb = FIOFILEPMBGET(f);
+	fio_pmemblk_file_t pmb = FILE_ENG_DATA(f);
 
 	unsigned long long off;
 	unsigned long len;
diff --git a/engines/sync.c b/engines/sync.c
index 1726b8e..e76bbbb 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -18,7 +18,7 @@
 /*
  * Sync engine uses engine_data to store last offset
  */
-#define LAST_POS(f)	((f)->engine_data)
+#define LAST_POS(f)	((f)->engine_pos)
 
 struct syncio_data {
 	struct iovec *iovecs;
diff --git a/file.h b/file.h
index c403b17..9801bb5 100644
--- a/file.h
+++ b/file.h
@@ -113,9 +113,12 @@ struct fio_file {
 	unsigned int last_write_idx;
 
 	/*
-	 * For use by the io engine
+	 * For use by the io engine for offset or private data storage
 	 */
-	uint64_t engine_data;
+	union {
+		uint64_t engine_pos;
+		void *engine_data;
+	};
 
 	/*
 	 * if io is protected by a semaphore, this is set
@@ -147,9 +150,8 @@ struct fio_file {
 	struct disk_util *du;
 };
 
-#define FILE_ENG_DATA(f)	((void *) (uintptr_t) (f)->engine_data)
-#define FILE_SET_ENG_DATA(f, data)	\
-	((f)->engine_data = (uintptr_t) (data))
+#define FILE_ENG_DATA(f)		((f)->engine_data)
+#define FILE_SET_ENG_DATA(f, data)	((f)->engine_data = (data))
 
 #define FILE_FLAG_FNS(name)						\
 static inline void fio_file_set_##name(struct fio_file *f)		\
diff --git a/filesetup.c b/filesetup.c
index 68a3ab9..4d0b127 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -519,7 +519,7 @@ int generic_close_file(struct thread_data fio_unused *td, struct fio_file *f)
 		f->shadow_fd = -1;
 	}
 
-	f->engine_data = 0;
+	f->engine_pos = 0;
 	return ret;
 }
 
-- 
2.9.3


