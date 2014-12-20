Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51863 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaLTNAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 20 Dec 2014 08:00:08 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y2Jde-0003Bi-HK
	for fio@vger.kernel.org; Sat, 20 Dec 2014 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141220130003.9D73540134@lyth.info>
Date: Sat, 20 Dec 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2243dfc796a8a6e137893a57a77949df7657dd71:

  options: add debug code for failure to lookup option names (2014-12-18 21:51:21 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8a2b393b00dc4b6a8ba129a0e7850a78114ac75e:

  gettime: hide fio_gtod_cpumask if not used (2014-12-19 15:04:10 -0700)

----------------------------------------------------------------
Jens Axboe (5):
      options: turn missing options into debug parse messages
      axmap: ensure we lock down the maps for shared access
      Fio 2.2.1
      gettime: only use CPU affinity if available
      gettime: hide fio_gtod_cpumask if not used

 FIO-VERSION-GEN        |    2 +-
 Makefile               |    2 +-
 gettime-thread.c       |    6 +++++-
 lib/axmap.c            |   54 +++++++++++++++++++++++++++++++++++++++---------
 options.c              |    4 +---
 options.h              |    6 ++++--
 os/windows/install.wxs |    2 +-
 t/axmap.c              |    1 +
 8 files changed, 58 insertions(+), 19 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index f0a0a45..d124e36 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.2.0
+DEF_VER=fio-2.2.1
 
 LF='
 '
diff --git a/Makefile b/Makefile
index 52e515b..d27ecaf 100644
--- a/Makefile
+++ b/Makefile
@@ -186,7 +186,7 @@ T_ZIPF_OBJS += t/log.o lib/ieee754.o lib/rand.o lib/zipf.o t/genzipf.o
 T_ZIPF_PROGS = t/fio-genzipf
 
 T_AXMAP_OBJS = t/axmap.o
-T_AXMAP_OBJS += lib/lfsr.o lib/axmap.o
+T_AXMAP_OBJS += lib/lfsr.o lib/axmap.o gettime.o mutex.o t/log.o t/debug.o
 T_AXMAP_PROGS = t/axmap
 
 T_LFSR_TEST_OBJS = t/lfsr-test.o
diff --git a/gettime-thread.c b/gettime-thread.c
index 73632d0..2dc976f 100644
--- a/gettime-thread.c
+++ b/gettime-thread.c
@@ -8,8 +8,10 @@
 
 struct timeval *fio_tv = NULL;
 int fio_gtod_offload = 0;
-static os_cpu_mask_t fio_gtod_cpumask;
 static pthread_t gtod_thread;
+#ifdef FIO_HAVE_CPU_AFFINITY
+static os_cpu_mask_t fio_gtod_cpumask;
+#endif
 
 void fio_gtod_init(void)
 {
@@ -95,5 +97,7 @@ err:
 
 void fio_gtod_set_cpu(unsigned int cpu)
 {
+#ifdef FIO_HAVE_CPU_AFFINITY
 	fio_cpu_set(&fio_gtod_cpumask, cpu);
+#endif
 }
diff --git a/lib/axmap.c b/lib/axmap.c
index 5b8cb30..e847a38 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -23,6 +23,7 @@
 #include "../arch/arch.h"
 #include "axmap.h"
 #include "../smalloc.h"
+#include "../mutex.h"
 #include "../minmax.h"
 
 #if BITS_PER_LONG == 64
@@ -45,6 +46,7 @@ struct axmap_level {
 };
 
 struct axmap {
+	struct fio_mutex lock;
 	unsigned int nr_levels;
 	struct axmap_level *levels;
 	uint64_t first_free;
@@ -63,6 +65,8 @@ void axmap_reset(struct axmap *axmap)
 {
 	int i;
 
+	fio_mutex_down(&axmap->lock);
+
 	for (i = 0; i < axmap->nr_levels; i++) {
 		struct axmap_level *al = &axmap->levels[i];
 
@@ -70,6 +74,7 @@ void axmap_reset(struct axmap *axmap)
 	}
 
 	axmap->first_free = 0;
+	fio_mutex_up(&axmap->lock);
 }
 
 void axmap_free(struct axmap *axmap)
@@ -83,6 +88,7 @@ void axmap_free(struct axmap *axmap)
 		sfree(axmap->levels[i].map);
 
 	sfree(axmap->levels);
+	__fio_mutex_remove(&axmap->lock);
 	sfree(axmap);
 }
 
@@ -95,6 +101,8 @@ struct axmap *axmap_new(unsigned long nr_bits)
 	if (!axmap)
 		return NULL;
 
+	__fio_mutex_init(&axmap->lock, FIO_MUTEX_UNLOCKED);
+
 	levels = 1;
 	i = (nr_bits + BLOCKS_PER_UNIT - 1) >> UNIT_SHIFT;
 	while (i > 1) {
@@ -126,6 +134,8 @@ err:
 			sfree(axmap->levels[i].map);
 
 	sfree(axmap->levels);
+	__fio_mutex_remove(&axmap->lock);
+	sfree(axmap);
 	return NULL;
 }
 
@@ -287,7 +297,9 @@ void axmap_set(struct axmap *axmap, uint64_t bit_nr)
 {
 	struct axmap_set_data data = { .nr_bits = 1, };
 
+	fio_mutex_down(&axmap->lock);
 	__axmap_set(axmap, bit_nr, &data);
+	fio_mutex_up(&axmap->lock);
 }
 
 unsigned int axmap_set_nr(struct axmap *axmap, uint64_t bit_nr, unsigned int nr_bits)
@@ -323,8 +335,14 @@ static int axmap_isset_fn(struct axmap_level *al, unsigned long offset,
 
 int axmap_isset(struct axmap *axmap, uint64_t bit_nr)
 {
-	if (bit_nr <= axmap->nr_bits)
-		return axmap_handler_topdown(axmap, bit_nr, axmap_isset_fn, NULL);
+	if (bit_nr <= axmap->nr_bits) {
+		int ret;
+
+		fio_mutex_down(&axmap->lock);
+		ret = axmap_handler_topdown(axmap, bit_nr, axmap_isset_fn, NULL);
+		fio_mutex_up(&axmap->lock);
+		return ret;
+	}
 
 	return 0;
 }
@@ -371,11 +389,17 @@ static uint64_t axmap_find_first_free(struct axmap *axmap, unsigned int level,
 
 uint64_t axmap_first_free(struct axmap *axmap)
 {
+	uint64_t ret;
+
 	if (firstfree_valid(axmap))
 		return axmap->first_free;
 
-	axmap->first_free = axmap_find_first_free(axmap, axmap->nr_levels - 1, 0);
-	return axmap->first_free;
+	fio_mutex_down(&axmap->lock);
+	ret = axmap_find_first_free(axmap, axmap->nr_levels - 1, 0);
+	axmap->first_free = ret;
+	fio_mutex_up(&axmap->lock);
+
+	return ret;
 }
 
 struct axmap_next_free_data {
@@ -411,11 +435,17 @@ uint64_t axmap_next_free(struct axmap *axmap, uint64_t bit_nr)
 	struct axmap_next_free_data data = { .level = -1U, .bit = bit_nr, };
 	uint64_t ret;
 
-	if (firstfree_valid(axmap) && bit_nr < axmap->first_free)
-		return axmap->first_free;
+	fio_mutex_down(&axmap->lock);
 
-	if (!axmap_handler(axmap, bit_nr, axmap_next_free_fn, &data))
-		return axmap_first_free(axmap);
+	if (firstfree_valid(axmap) && bit_nr < axmap->first_free) {
+		ret = axmap->first_free;
+		goto done;
+	}
+
+	if (!axmap_handler(axmap, bit_nr, axmap_next_free_fn, &data)) {
+		ret = axmap_first_free(axmap);
+		goto done;
+	}
 
 	assert(data.level != -1U);
 
@@ -425,8 +455,12 @@ uint64_t axmap_next_free(struct axmap *axmap, uint64_t bit_nr)
 	 * find the first free one, the map is practically full.
 	 */
 	ret = axmap_find_first_free(axmap, data.level, data.offset);
-	if (ret != -1ULL)
+	if (ret != -1ULL) {
+done:
+		fio_mutex_up(&axmap->lock);
 		return ret;
+	}
 
-	return axmap_first_free(axmap);
+	ret = axmap_first_free(axmap);
+	goto done;
 }
diff --git a/options.c b/options.c
index 6ceefbc..e3c9c87 100644
--- a/options.c
+++ b/options.c
@@ -4204,10 +4204,8 @@ int __fio_option_is_set(struct thread_options *o, unsigned int off1)
 		}
 	}
 
-	if (!opt) {
-		log_err("fio: no option found at offset %u\n", off1);
+	if (!opt)
 		return -1;
-	}
 
 	opt_off = opt - &fio_options[0];
 	index = opt_off / (8 * sizeof(uint64_t));
diff --git a/options.h b/options.h
index e830884..36fd35d 100644
--- a/options.h
+++ b/options.h
@@ -26,9 +26,11 @@ extern int __fio_option_is_set(struct thread_options *, unsigned int off);
 
 #define fio_option_is_set(__td, name)					\
 ({									\
-	int __r = __fio_option_is_set((__td), td_var_offset(name));	\
+	const unsigned int off = td_var_offset(name);			\
+	int __r = __fio_option_is_set((__td), off);			\
 	if (__r == -1) {						\
-		log_err("fio: wanted %s\n", __fio_stringify(name));	\
+		dprint(FD_PARSE, "option %s/%u not found in map\n",	\
+				__fio_stringify(name), off);		\
 		__r = 0;						\
 	}								\
 	__r;								\
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 26be597..5db099b 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.0">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.1">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/t/axmap.c b/t/axmap.c
index e32ff98..cc078aa 100644
--- a/t/axmap.c
+++ b/t/axmap.c
@@ -5,6 +5,7 @@
 #include <unistd.h>
 #include <inttypes.h>
 
+#include "../mutex.h"
 #include "../lib/lfsr.h"
 #include "../lib/axmap.h"
 
