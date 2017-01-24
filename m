Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55220 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdAXNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 Jan 2017 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cW0hi-0005Xt-Ph
        for fio@vger.kernel.org; Tue, 24 Jan 2017 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170124130002.58B2A2C00E0@kernel.dk>
Date: Tue, 24 Jan 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9cf163b0b3f69df8ef70d5a0799d9452e80ee2c4:

  Add missing opt/cat group entries (2017-01-20 10:50:16 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bd4d9bdc5097c3b35b5172508e1a2828296e01c2:

  Remove/Move Linux specific sysfs_root field from thread_data (2017-01-23 08:26:12 -0700)

----------------------------------------------------------------
Tomohiro Kusumi (8):
      Define pointer alignment macro in fio.h
      Use ARRAY_SIZE()
      Fix wrong comment on exit condition of threads/processes
      Remove unused io_u's priv union field
      Remove unused disk_util's name field
      Add missing free(td->sysfs_root);
      Fix bad pointer du->sysfs_root
      Remove/Move Linux specific sysfs_root field from thread_data

 backend.c      | 14 ++++++++------
 diskutil.c     | 12 +++---------
 diskutil.h     |  1 -
 fio.h          |  7 +++++--
 gclient.c      |  2 +-
 gfio.c         |  2 +-
 ioengine.h     |  1 -
 lib/memalign.c |  4 +---
 lib/num2str.c  |  4 +---
 smalloc.c      |  3 ++-
 10 files changed, 22 insertions(+), 28 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 4570d8d..1c1f2f9 100644
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
 
@@ -1264,6 +1261,10 @@ static int init_io_u(struct thread_data *td)
 	return 0;
 }
 
+/*
+ * This function is Linux specific.
+ * FIO_HAVE_IOSCHED_SWITCH enabled currently means it's Linux.
+ */
 static int switch_ioscheduler(struct thread_data *td)
 {
 #ifdef FIO_HAVE_IOSCHED_SWITCH
@@ -1274,7 +1275,8 @@ static int switch_ioscheduler(struct thread_data *td)
 	if (td_ioengine_flagged(td, FIO_DISKLESSIO))
 		return 0;
 
-	sprintf(tmp, "%s/queue/scheduler", td->sysfs_root);
+	assert(td->files && td->files[0]);
+	sprintf(tmp, "%s/queue/scheduler", td->files[0]->du->sysfs_root);
 
 	f = fopen(tmp, "r+");
 	if (!f) {
@@ -1362,7 +1364,7 @@ static bool keep_running(struct thread_data *td)
 		uint64_t diff;
 
 		/*
-		 * If the difference is less than the minimum IO size, we
+		 * If the difference is less than the maximum IO size, we
 		 * are done.
 		 */
 		diff = limit - ddir_rw_sum(td->io_bytes);
diff --git a/diskutil.c b/diskutil.c
index 27ddb46..c3bcec9 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -37,6 +37,7 @@ static void disk_util_free(struct disk_util *du)
 	}
 
 	fio_mutex_remove(du->lock);
+	free(du->sysfs_root);
 	sfree(du);
 }
 
@@ -305,7 +306,7 @@ static struct disk_util *disk_util_add(struct thread_data *td, int majdev,
 		return NULL;
 	}
 	strncpy((char *) du->dus.name, basename(path), FIO_DU_NAME_SZ - 1);
-	du->sysfs_root = path;
+	du->sysfs_root = strdup(path);
 	du->major = majdev;
 	du->minor = mindev;
 	INIT_FLIST_HEAD(&du->slavelist);
@@ -430,9 +431,6 @@ static struct disk_util *__init_per_file_disk_util(struct thread_data *td,
 		sprintf(path, "%s", tmp);
 	}
 
-	if (td->o.ioscheduler && !td->sysfs_root)
-		td->sysfs_root = strdup(path);
-
 	return disk_util_add(td, majdev, mindev, path);
 }
 
@@ -451,12 +449,8 @@ static struct disk_util *init_per_file_disk_util(struct thread_data *td,
 			mindev);
 
 	du = disk_util_exists(majdev, mindev);
-	if (du) {
-		if (td->o.ioscheduler && !td->sysfs_root)
-			td->sysfs_root = strdup(du->sysfs_root);
-
+	if (du)
 		return du;
-	}
 
 	/*
 	 * for an fs without a device, we will repeatedly stat through
diff --git a/diskutil.h b/diskutil.h
index ff8a5b0..04fdde2 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -46,7 +46,6 @@ struct disk_util {
 	 */
 	struct flist_head slavelist;
 
-	char *name;
 	char *sysfs_root;
 	char path[PATH_MAX];
 	int major, minor;
diff --git a/fio.h b/fio.h
index b2dade9..19ac0af 100644
--- a/fio.h
+++ b/fio.h
@@ -205,8 +205,6 @@ struct thread_data {
 	void *iolog_buf;
 	FILE *iolog_f;
 
-	char *sysfs_root;
-
 	unsigned long rand_seeds[FIO_RAND_NR_OFFS];
 
 	struct frand_state bsrange_state;
@@ -619,6 +617,11 @@ extern int __must_check allocate_io_mem(struct thread_data *);
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
diff --git a/gclient.c b/gclient.c
index 5ce33d0..928a1b7 100644
--- a/gclient.c
+++ b/gclient.c
@@ -48,7 +48,7 @@ static GtkActionEntry results_menu_items[] = {
 	{ "PrintFile", GTK_STOCK_PRINT, "Print", "<Control>P", NULL, G_CALLBACK(results_print) },
 	{ "CloseFile", GTK_STOCK_CLOSE, "Close", "<Control>W", NULL, G_CALLBACK(results_close) },
 };
-static gint results_nmenu_items = sizeof(results_menu_items) / sizeof(results_menu_items[0]);
+static gint results_nmenu_items = ARRAY_SIZE(results_menu_items);
 
 static const gchar *results_ui_string = " \
 	<ui> \
diff --git a/gfio.c b/gfio.c
index 9ccf78c..9c917cb 100644
--- a/gfio.c
+++ b/gfio.c
@@ -1271,7 +1271,7 @@ static GtkActionEntry menu_items[] = {
 	{ "Quit", GTK_STOCK_QUIT, NULL,   "<Control>Q", NULL, G_CALLBACK(quit_clicked) },
 	{ "About", GTK_STOCK_ABOUT, NULL,  NULL, NULL, G_CALLBACK(about_dialog) },
 };
-static gint nmenu_items = sizeof(menu_items) / sizeof(menu_items[0]);
+static gint nmenu_items = ARRAY_SIZE(menu_items);
 
 static const gchar *ui_string = " \
 	<ui> \
diff --git a/ioengine.h b/ioengine.h
index 89873e7..7249df6 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -123,7 +123,6 @@ struct io_u {
 		struct ibv_mr *mr;
 #endif
 		void *mmap_data;
-		uint64_t null;
 	};
 };
 
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
diff --git a/lib/num2str.c b/lib/num2str.c
index 940d4a5..ed3545d 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -4,8 +4,6 @@
 
 #include "../fio.h"
 
-#define ARRAY_LENGTH(arr)	sizeof(arr) / sizeof((arr)[0])
-
 /**
  * num2str() - Cheesy number->string conversion, complete with carry rounding error.
  * @num: quantity (e.g., number of blocks, bytes or bits)
@@ -75,7 +73,7 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, int units)
 
 	if (modulo == -1U) {
 done:
-		if (post_index >= ARRAY_LENGTH(sistr))
+		if (post_index >= ARRAY_SIZE(sistr))
 			post_index = 0;
 
 		sprintf(buf, "%llu%s%s", (unsigned long long) num,
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
