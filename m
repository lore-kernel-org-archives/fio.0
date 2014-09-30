Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:43806 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaI3MAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 30 Sep 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XYw68-0003QG-4n
	for fio@vger.kernel.org; Tue, 30 Sep 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140930120002.A515F40152@lyth.info>
Date: Tue, 30 Sep 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 86d59660ca54dd2e3e2457f3683198afc2b2701c:

  Fix typo in bs_is_seq_ran option help (2014-09-28 16:25:49 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0bc27b0b7019e4c386f83258430fb6b3ac34cc06:

  filesetup: fix a bug where we overwrite the set size (2014-09-29 21:23:51 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      t/dedupe: silence 'some_done' unused warning on some compilers
      Fix compile of t/btrace2fio on RHEL5/CentOS5
      filesetup: fix a bug where we overwrite the set size

 filesetup.c   |    2 +-
 os/os-linux.h |   13 +++++++++++++
 t/dedupe.c    |    2 +-
 3 files changed, 15 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 29a76c0..43146ba 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -898,7 +898,7 @@ int setup_files(struct thread_data *td)
 		}
 	}
 
-	if (!o->size || o->size > total_size)
+	if (!o->size || (total_size && o->size > total_size))
 		o->size = total_size;
 
 	if (o->size < td_min_bs(td)) {
diff --git a/os/os-linux.h b/os/os-linux.h
index 81d0402..e193634 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -15,6 +15,7 @@
 #include <linux/unistd.h>
 #include <linux/raw.h>
 #include <linux/major.h>
+#include <byteswap.h>
 
 #include "binject.h"
 #include "../file.h"
@@ -208,9 +209,21 @@ static inline int fio_lookup_raw(dev_t dev, int *majdev, int *mindev)
 #define FIO_MADV_FREE	MADV_REMOVE
 #endif
 
+#if defined(__builtin_bswap16)
+#define fio_swap16(x)	__builtin_bswap16(x)
+#else
 #define fio_swap16(x)	__bswap_16(x)
+#endif
+#if defined(__builtin_bswap32)
+#define fio_swap32(x)	__builtin_bswap32(x)
+#else
 #define fio_swap32(x)	__bswap_32(x)
+#endif
+#if defined(__builtin_bswap64)
+#define fio_swap64(x)	__builtin_bswap64(x)
+#else
 #define fio_swap64(x)	__bswap_64(x)
+#endif
 
 #define CACHE_LINE_FILE	\
 	"/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size"
diff --git a/t/dedupe.c b/t/dedupe.c
index f9fb8c4..69ebc8a 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -342,7 +342,7 @@ static void show_progress(struct worker_thread *threads, unsigned long total)
 		unsigned long nitems = 0;
 		uint64_t tdiff;
 		float perc;
-		int some_done;
+		int some_done = 0;
 		int i;
 
 		for (i = 0; i < num_threads; i++) {
