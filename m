Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/5] Move {is,load}_blktrace() to a new header blktrace.h
Date: Tue, 23 May 2017 21:44:45 +0300
Message-Id: <20170523184449.48134-2-tkusumi@tuxera.com>
In-Reply-To: <20170523184449.48134-1-tkusumi@tuxera.com>
References: <20170523184449.48134-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This commit does exactly the same as what cgroup.h does for cgroup
support.

Since blktrace is Linux specific feature and api compiled only on
Linux and Android, these two could be defined in blktrace.h rather
than in os/os.h which is basically intended to be something generic
whose implementation vary depending on supported platforms.

The reason for adding a new header blktrace.h instead of using
blktrace_api.h is because blktrace_api.h seems to have been added
for blktrace.c to include which gets compiled only on Linux where
blktrace apis are basically guaranteed to exist (unless really old
kernels), whereas these prototypes or inline functions are needed
by all platforms.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 blktrace.c |  1 +
 blktrace.h | 23 +++++++++++++++++++++++
 fio.h      |  8 --------
 iolog.c    |  1 +
 os/os.h    | 13 -------------
 5 files changed, 25 insertions(+), 21 deletions(-)
 create mode 100644 blktrace.h

diff --git a/blktrace.c b/blktrace.c
index a3474cb..65b600f 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -10,6 +10,7 @@
 
 #include "flist.h"
 #include "fio.h"
+#include "blktrace.h"
 #include "blktrace_api.h"
 #include "oslib/linux-dev-lookup.h"
 
diff --git a/blktrace.h b/blktrace.h
new file mode 100644
index 0000000..8656a95
--- /dev/null
+++ b/blktrace.h
@@ -0,0 +1,23 @@
+#ifndef FIO_BLKTRACE_H
+#define FIO_BLKTRACE_H
+
+#ifdef FIO_HAVE_BLKTRACE
+
+int is_blktrace(const char *, int *);
+int load_blktrace(struct thread_data *, const char *, int);
+
+#else
+
+static inline int is_blktrace(const char *fname, int *need_swap)
+{
+	return 0;
+}
+
+static inline int load_blktrace(struct thread_data *td, const char *fname,
+				int need_swap)
+{
+	return 1;
+}
+
+#endif
+#endif
diff --git a/fio.h b/fio.h
index ed631bc..963cf03 100644
--- a/fio.h
+++ b/fio.h
@@ -640,14 +640,6 @@ extern void free_threads_shm(void);
  */
 extern void reset_all_stats(struct thread_data *);
 
-/*
- * blktrace support
- */
-#ifdef FIO_HAVE_BLKTRACE
-extern int is_blktrace(const char *, int *);
-extern int load_blktrace(struct thread_data *, const char *, int);
-#endif
-
 extern int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 		   enum fio_ddir ddir, uint64_t *bytes_issued, int from_verify,
 		   struct timeval *comp_time);
diff --git a/iolog.c b/iolog.c
index 31d674c..01b82e8 100644
--- a/iolog.c
+++ b/iolog.c
@@ -19,6 +19,7 @@
 #include "trim.h"
 #include "filelock.h"
 #include "smalloc.h"
+#include "blktrace.h"
 
 static int iolog_flush(struct io_log *log);
 
diff --git a/os/os.h b/os/os.h
index 5e3c813..c25cc36 100644
--- a/os/os.h
+++ b/os/os.h
@@ -253,19 +253,6 @@ static inline uint64_t fio_swap64(uint64_t val)
 	__cpu_to_le64(val);			\
 })
 
-#ifndef FIO_HAVE_BLKTRACE
-static inline int is_blktrace(const char *fname, int *need_swap)
-{
-	return 0;
-}
-struct thread_data;
-static inline int load_blktrace(struct thread_data *td, const char *fname,
-				int need_swap)
-{
-	return 1;
-}
-#endif
-
 #define FIO_DEF_CL_SIZE		128
 
 static inline int os_cache_line_size(void)
-- 
2.9.4


