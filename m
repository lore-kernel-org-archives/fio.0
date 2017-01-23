Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/8] Define pointer alignment macro in fio.h
Date: Tue, 24 Jan 2017 00:13:04 +0900
Message-Id: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Define PTR_ALIGN() as a common utility within the entire fio,
but inside FIO_INTERNAL guard since it could be a common name.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 backend.c      | 5 +----
 fio.h          | 5 +++++
 lib/memalign.c | 4 +---
 smalloc.c      | 3 ++-
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/backend.c b/backend.c
index 4570d8d..fc64709 100644
--- a/backend.c
+++ b/backend.c
@@ -76,9 +76,6 @@ int shm_id = 0;
 int temp_stall_ts;
 unsigned long done_secs = 0;
 
-#define PAGE_ALIGN(buf)	\
-	(char *) (((uintptr_t) (buf) + page_mask) & ~page_mask)
-
 #define JOB_START_TIMEOUT	(5 * 1000)
 
 static void sig_int(int sig)
@@ -1198,7 +1195,7 @@ static int init_io_u(struct thread_data *td)
 
 	if (td->o.odirect || td->o.mem_align || td->o.oatomic ||
 	    td_ioengine_flagged(td, FIO_RAWIO))
-		p = PAGE_ALIGN(td->orig_buffer) + td->o.mem_align;
+		p = PTR_ALIGN(td->orig_buffer, page_mask) + td->o.mem_align;
 	else
 		p = td->orig_buffer;
 
diff --git a/fio.h b/fio.h
index b2dade9..14950fc 100644
--- a/fio.h
+++ b/fio.h
@@ -619,6 +619,11 @@ extern int __must_check allocate_io_mem(struct thread_data *);
 extern void free_io_mem(struct thread_data *);
 extern void free_threads_shm(void);
 
+#ifdef FIO_INTERNAL
+#define PTR_ALIGN(ptr, mask)	\
+	(char *) (((uintptr_t) (ptr) + (mask)) & ~(mask))
+#endif
+
 /*
  * Reset stats after ramp time completes
  */
diff --git a/lib/memalign.c b/lib/memalign.c
index cfd6e46..1d1ba9b 100644
--- a/lib/memalign.c
+++ b/lib/memalign.c
@@ -3,14 +3,12 @@
 #include <inttypes.h>
 
 #include "memalign.h"
+#include "../fio.h"
 
 struct align_footer {
 	unsigned int offset;
 };
 
-#define PTR_ALIGN(ptr, mask)	\
-	(char *) (((uintptr_t) ((ptr) + (mask)) & ~(mask)))
-
 void *fio_memalign(size_t alignment, size_t size)
 {
 	struct align_footer *f;
diff --git a/smalloc.c b/smalloc.c
index d038ac6..e48cfe8 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -13,6 +13,7 @@
 #include <limits.h>
 #include <fcntl.h>
 
+#include "fio.h"
 #include "mutex.h"
 #include "arch/arch.h"
 #include "os/os.h"
@@ -248,7 +249,7 @@ static void *postred_ptr(struct block_hdr *hdr)
 	uintptr_t ptr;
 
 	ptr = (uintptr_t) hdr + hdr->size - sizeof(unsigned int);
-	ptr = (ptr + int_mask) & ~int_mask;
+	ptr = (uintptr_t) PTR_ALIGN(ptr, int_mask);
 
 	return (void *) ptr;
 }
-- 
2.5.5


