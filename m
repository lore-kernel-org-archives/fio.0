Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33816 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757907AbcH3MAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 30 Aug 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1behhz-0006LM-9N
        for fio@vger.kernel.org; Tue, 30 Aug 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160830120002.36A732C00B3@kernel.dk>
Date: Tue, 30 Aug 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 39d13e67ef1f4b327c68431f8daf033a03920117:

  backend: check if we need to update rusage stats, if stat_mutex is busy (2016-08-26 14:39:30 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 32bc83ddb4adb6b19500f2f6acec8c591feaae26:

  jesd219: fix alignment (2016-08-29 15:43:27 -0600)

----------------------------------------------------------------
Jeff Furlong (1):
      jesd219: fix alignment

Jens Axboe (3):
      trim: convert to bool
      filelock: bool conversion
      FIO-VERSION-GEN: fix dirty repo tracking

 FIO-VERSION-GEN      |  4 +---
 examples/jesd219.fio |  1 +
 filelock.c           | 14 +++++++-------
 filelock.h           |  4 +++-
 io_u.c               |  2 +-
 trim.c               | 14 +++++++-------
 trim.h               | 12 ++++++------
 7 files changed, 26 insertions(+), 25 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 7065a57..d19dcca 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -15,7 +15,7 @@ elif test -d .git -o -f .git &&
 	VN=`git describe --match "fio-[0-9]*" --abbrev=4 HEAD 2>/dev/null` &&
 	case "$VN" in
 	*$LF*) (exit 1) ;;
-	v[0-9]*)
+	fio-[0-9]*)
 		git update-index -q --refresh
 		test -z "`git diff-index --name-only HEAD --`" ||
 		VN="$VN-dirty" ;;
@@ -38,5 +38,3 @@ test "$VN" = "$VC" || {
 	echo >&2 "FIO_VERSION = $VN"
 	echo "FIO_VERSION = $VN" >$GVF
 }
-
-
diff --git a/examples/jesd219.fio b/examples/jesd219.fio
index ab2c40e..24f16f7 100644
--- a/examples/jesd219.fio
+++ b/examples/jesd219.fio
@@ -14,6 +14,7 @@ rwmixwrite=60
 iodepth=256
 numjobs=4
 bssplit=512/4:1024/1:1536/1:2048/1:2560/1:3072/1:3584/1:4k/67:8k/10:16k/7:32k/3:64k/3
+blockalign=4k
 random_distribution=zoned:50/5:30/15:20/80
 filename=/dev/nvme0n1
 group_reporting=1
diff --git a/filelock.c b/filelock.c
index b113007..6e84970 100644
--- a/filelock.c
+++ b/filelock.c
@@ -165,7 +165,7 @@ static struct fio_filelock *fio_hash_get(uint32_t hash, int trylock)
 	return ff;
 }
 
-static int __fio_lock_file(const char *fname, int trylock)
+static bool __fio_lock_file(const char *fname, int trylock)
 {
 	struct fio_filelock *ff;
 	uint32_t hash;
@@ -180,16 +180,16 @@ static int __fio_lock_file(const char *fname, int trylock)
 
 	if (!ff) {
 		assert(!trylock);
-		return 1;
+		return true;
 	}
 
 	if (!trylock) {
 		fio_mutex_down(&ff->lock);
-		return 0;
+		return false;
 	}
 
 	if (!fio_mutex_down_trylock(&ff->lock))
-		return 0;
+		return false;
 
 	fio_mutex_down(&fld->lock);
 
@@ -206,13 +206,13 @@ static int __fio_lock_file(const char *fname, int trylock)
 
 	if (ff) {
 		fio_mutex_down(&ff->lock);
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
-int fio_trylock_file(const char *fname)
+bool fio_trylock_file(const char *fname)
 {
 	return __fio_lock_file(fname, 1);
 }
diff --git a/filelock.h b/filelock.h
index 97d13b7..4551bb0 100644
--- a/filelock.h
+++ b/filelock.h
@@ -1,8 +1,10 @@
 #ifndef FIO_LOCK_FILE_H
 #define FIO_LOCK_FILE_H
 
+#include "lib/types.h"
+
 extern void fio_lock_file(const char *);
-extern int fio_trylock_file(const char *);
+extern bool fio_trylock_file(const char *);
 extern void fio_unlock_file(const char *);
 
 extern int fio_filelock_init(void);
diff --git a/io_u.c b/io_u.c
index dcf7a40..b6d530f 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1510,7 +1510,7 @@ static bool check_get_trim(struct thread_data *td, struct io_u *io_u)
 			get_trim = 1;
 		}
 
-		if (get_trim && !get_next_trim(td, io_u))
+		if (get_trim && get_next_trim(td, io_u))
 			return true;
 	}
 
diff --git a/trim.c b/trim.c
index 4345541..78cf672 100644
--- a/trim.c
+++ b/trim.c
@@ -11,7 +11,7 @@
 #include "trim.h"
 
 #ifdef FIO_HAVE_TRIM
-int get_next_trim(struct thread_data *td, struct io_u *io_u)
+bool get_next_trim(struct thread_data *td, struct io_u *io_u)
 {
 	struct io_piece *ipo;
 
@@ -19,9 +19,9 @@ int get_next_trim(struct thread_data *td, struct io_u *io_u)
 	 * this io_u is from a requeue, we already filled the offsets
 	 */
 	if (io_u->file)
-		return 0;
+		return true;
 	if (flist_empty(&td->trim_list))
-		return 1;
+		return false;
 
 	assert(td->trim_entries);
 	ipo = flist_first_entry(&td->trim_list, struct io_piece, trim_list);
@@ -53,7 +53,7 @@ int get_next_trim(struct thread_data *td, struct io_u *io_u)
 		if (r) {
 			dprint(FD_VERIFY, "failed file %s open\n",
 					io_u->file->file_name);
-			return 1;
+			return false;
 		}
 	}
 
@@ -64,17 +64,17 @@ int get_next_trim(struct thread_data *td, struct io_u *io_u)
 	io_u->xfer_buflen = io_u->buflen;
 
 	dprint(FD_VERIFY, "get_next_trim: ret io_u %p\n", io_u);
-	return 0;
+	return true;
 }
 
-int io_u_should_trim(struct thread_data *td, struct io_u *io_u)
+bool io_u_should_trim(struct thread_data *td, struct io_u *io_u)
 {
 	unsigned long long val;
 	uint64_t frand_max;
 	unsigned long r;
 
 	if (!td->o.trim_percentage)
-		return 0;
+		return false;
 
 	frand_max = rand_max(&td->trim_state);
 	r = __rand(&td->trim_state);
diff --git a/trim.h b/trim.h
index 6584606..37f5d7c 100644
--- a/trim.h
+++ b/trim.h
@@ -4,8 +4,8 @@
 #include "fio.h"
 
 #ifdef FIO_HAVE_TRIM
-extern int __must_check get_next_trim(struct thread_data *td, struct io_u *io_u);
-extern int io_u_should_trim(struct thread_data *td, struct io_u *io_u);
+extern bool __must_check get_next_trim(struct thread_data *td, struct io_u *io_u);
+extern bool io_u_should_trim(struct thread_data *td, struct io_u *io_u);
 
 /*
  * Determine whether a given io_u should be logged for verify or
@@ -20,13 +20,13 @@ static inline void remove_trim_entry(struct thread_data *td, struct io_piece *ip
 }
 
 #else
-static inline int get_next_trim(struct thread_data *td, struct io_u *io_u)
+static inline bool get_next_trim(struct thread_data *td, struct io_u *io_u)
 {
-	return 1;
+	return false;
 }
-static inline int io_u_should_trim(struct thread_data *td, struct io_u *io_u)
+static inline bool io_u_should_trim(struct thread_data *td, struct io_u *io_u)
 {
-	return 0;
+	return false;
 }
 static inline void remove_trim_entry(struct thread_data *td, struct io_piece *ipo)
 {
