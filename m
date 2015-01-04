Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46566 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 4 Jan 2015 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y7kmq-0002Iq-8a
	for fio@vger.kernel.org; Sun, 04 Jan 2015 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150104130003.4434240191@lyth.info>
Date: Sun,  4 Jan 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit aad918e47d119eb2043311f1a2a45ce109c047d1:

  gettime: add basic init cpuclock test (2014-12-23 10:41:34 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fde90aadbbf223d4d9b553c8cda3b65b0b1140e2:

  Fio 2.2.4 (2015-01-03 19:46:55 -0700)

----------------------------------------------------------------
fio v2.2.4

----------------------------------------------------------------
Jens Axboe (5):
      Get rid of lockfile callback
      Revert "axmap: fix deadlock"
      Revert "axmap: ensure we lock down the maps for shared access"
      bloom: kill unused function
      Fio 2.2.4

Ming Lei (2):
      axmap: fix deadlock
      axmap: make axmap_first_free() static

 FIO-VERSION-GEN        |    2 +-
 Makefile               |    2 +-
 lib/axmap.c            |   56 ++++++++++--------------------------------------
 lib/axmap.h            |    1 -
 lib/bloom.c            |    5 -----
 lib/bloom.h            |    1 -
 options.c              |   13 -----------
 os/windows/install.wxs |    2 +-
 t/axmap.c              |    1 -
 9 files changed, 14 insertions(+), 69 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index a26eb2e..a8c8e65 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.2.3
+DEF_VER=fio-2.2.4
 
 LF='
 '
diff --git a/Makefile b/Makefile
index d27ecaf..52e515b 100644
--- a/Makefile
+++ b/Makefile
@@ -186,7 +186,7 @@ T_ZIPF_OBJS += t/log.o lib/ieee754.o lib/rand.o lib/zipf.o t/genzipf.o
 T_ZIPF_PROGS = t/fio-genzipf
 
 T_AXMAP_OBJS = t/axmap.o
-T_AXMAP_OBJS += lib/lfsr.o lib/axmap.o gettime.o mutex.o t/log.o t/debug.o
+T_AXMAP_OBJS += lib/lfsr.o lib/axmap.o
 T_AXMAP_PROGS = t/axmap
 
 T_LFSR_TEST_OBJS = t/lfsr-test.o
diff --git a/lib/axmap.c b/lib/axmap.c
index e847a38..68096d8 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -23,7 +23,6 @@
 #include "../arch/arch.h"
 #include "axmap.h"
 #include "../smalloc.h"
-#include "../mutex.h"
 #include "../minmax.h"
 
 #if BITS_PER_LONG == 64
@@ -46,7 +45,6 @@ struct axmap_level {
 };
 
 struct axmap {
-	struct fio_mutex lock;
 	unsigned int nr_levels;
 	struct axmap_level *levels;
 	uint64_t first_free;
@@ -65,8 +63,6 @@ void axmap_reset(struct axmap *axmap)
 {
 	int i;
 
-	fio_mutex_down(&axmap->lock);
-
 	for (i = 0; i < axmap->nr_levels; i++) {
 		struct axmap_level *al = &axmap->levels[i];
 
@@ -74,7 +70,6 @@ void axmap_reset(struct axmap *axmap)
 	}
 
 	axmap->first_free = 0;
-	fio_mutex_up(&axmap->lock);
 }
 
 void axmap_free(struct axmap *axmap)
@@ -88,7 +83,6 @@ void axmap_free(struct axmap *axmap)
 		sfree(axmap->levels[i].map);
 
 	sfree(axmap->levels);
-	__fio_mutex_remove(&axmap->lock);
 	sfree(axmap);
 }
 
@@ -101,8 +95,6 @@ struct axmap *axmap_new(unsigned long nr_bits)
 	if (!axmap)
 		return NULL;
 
-	__fio_mutex_init(&axmap->lock, FIO_MUTEX_UNLOCKED);
-
 	levels = 1;
 	i = (nr_bits + BLOCKS_PER_UNIT - 1) >> UNIT_SHIFT;
 	while (i > 1) {
@@ -134,8 +126,6 @@ err:
 			sfree(axmap->levels[i].map);
 
 	sfree(axmap->levels);
-	__fio_mutex_remove(&axmap->lock);
-	sfree(axmap);
 	return NULL;
 }
 
@@ -297,9 +287,7 @@ void axmap_set(struct axmap *axmap, uint64_t bit_nr)
 {
 	struct axmap_set_data data = { .nr_bits = 1, };
 
-	fio_mutex_down(&axmap->lock);
 	__axmap_set(axmap, bit_nr, &data);
-	fio_mutex_up(&axmap->lock);
 }
 
 unsigned int axmap_set_nr(struct axmap *axmap, uint64_t bit_nr, unsigned int nr_bits)
@@ -335,14 +323,8 @@ static int axmap_isset_fn(struct axmap_level *al, unsigned long offset,
 
 int axmap_isset(struct axmap *axmap, uint64_t bit_nr)
 {
-	if (bit_nr <= axmap->nr_bits) {
-		int ret;
-
-		fio_mutex_down(&axmap->lock);
-		ret = axmap_handler_topdown(axmap, bit_nr, axmap_isset_fn, NULL);
-		fio_mutex_up(&axmap->lock);
-		return ret;
-	}
+	if (bit_nr <= axmap->nr_bits)
+		return axmap_handler_topdown(axmap, bit_nr, axmap_isset_fn, NULL);
 
 	return 0;
 }
@@ -387,19 +369,13 @@ static uint64_t axmap_find_first_free(struct axmap *axmap, unsigned int level,
 	return (uint64_t) -1ULL;
 }
 
-uint64_t axmap_first_free(struct axmap *axmap)
+static uint64_t axmap_first_free(struct axmap *axmap)
 {
-	uint64_t ret;
-
 	if (firstfree_valid(axmap))
 		return axmap->first_free;
 
-	fio_mutex_down(&axmap->lock);
-	ret = axmap_find_first_free(axmap, axmap->nr_levels - 1, 0);
-	axmap->first_free = ret;
-	fio_mutex_up(&axmap->lock);
-
-	return ret;
+	axmap->first_free = axmap_find_first_free(axmap, axmap->nr_levels - 1, 0);
+	return axmap->first_free;
 }
 
 struct axmap_next_free_data {
@@ -435,17 +411,11 @@ uint64_t axmap_next_free(struct axmap *axmap, uint64_t bit_nr)
 	struct axmap_next_free_data data = { .level = -1U, .bit = bit_nr, };
 	uint64_t ret;
 
-	fio_mutex_down(&axmap->lock);
-
-	if (firstfree_valid(axmap) && bit_nr < axmap->first_free) {
-		ret = axmap->first_free;
-		goto done;
-	}
+	if (firstfree_valid(axmap) && bit_nr < axmap->first_free)
+		return axmap->first_free;
 
-	if (!axmap_handler(axmap, bit_nr, axmap_next_free_fn, &data)) {
-		ret = axmap_first_free(axmap);
-		goto done;
-	}
+	if (!axmap_handler(axmap, bit_nr, axmap_next_free_fn, &data))
+		return axmap_first_free(axmap);
 
 	assert(data.level != -1U);
 
@@ -455,12 +425,8 @@ uint64_t axmap_next_free(struct axmap *axmap, uint64_t bit_nr)
 	 * find the first free one, the map is practically full.
 	 */
 	ret = axmap_find_first_free(axmap, data.level, data.offset);
-	if (ret != -1ULL) {
-done:
-		fio_mutex_up(&axmap->lock);
+	if (ret != -1ULL)
 		return ret;
-	}
 
-	ret = axmap_first_free(axmap);
-	goto done;
+	return axmap_first_free(axmap);
 }
diff --git a/lib/axmap.h b/lib/axmap.h
index edfeba8..3705a1d 100644
--- a/lib/axmap.h
+++ b/lib/axmap.h
@@ -11,7 +11,6 @@ void axmap_clear(struct axmap *axmap, uint64_t bit_nr);
 void axmap_set(struct axmap *axmap, uint64_t bit_nr);
 unsigned int axmap_set_nr(struct axmap *axmap, uint64_t bit_nr, unsigned int nr_bits);
 int axmap_isset(struct axmap *axmap, uint64_t bit_nr);
-uint64_t axmap_first_free(struct axmap *axmap);
 uint64_t axmap_next_free(struct axmap *axmap, uint64_t bit_nr);
 void axmap_reset(struct axmap *axmap);
 
diff --git a/lib/bloom.c b/lib/bloom.c
index 33d093a..ee4ba0b 100644
--- a/lib/bloom.c
+++ b/lib/bloom.c
@@ -113,11 +113,6 @@ static int __bloom_check(struct bloom *b, uint32_t *data, unsigned int nwords,
 	return was_set == N_HASHES;
 }
 
-int bloom_check(struct bloom *b, uint32_t *data, unsigned int nwords)
-{
-	return __bloom_check(b, data, nwords, 0);
-}
-
 int bloom_set(struct bloom *b, uint32_t *data, unsigned int nwords)
 {
 	return __bloom_check(b, data, nwords, 1);
diff --git a/lib/bloom.h b/lib/bloom.h
index b3cde95..127ed9b 100644
--- a/lib/bloom.h
+++ b/lib/bloom.h
@@ -7,7 +7,6 @@ struct bloom;
 
 struct bloom *bloom_new(uint64_t entries);
 void bloom_free(struct bloom *b);
-int bloom_check(struct bloom *b, uint32_t *data, unsigned int nwords);
 int bloom_set(struct bloom *b, uint32_t *data, unsigned int nwords);
 
 #endif
diff --git a/options.c b/options.c
index 3e783c1..12ff621 100644
--- a/options.c
+++ b/options.c
@@ -884,18 +884,6 @@ out:
 	return ret;
 }
 
-static int str_lockfile_cb(void *data, const char fio_unused *str)
-{
-	struct thread_data *td = data;
-
-	if (td->files_index) {
-		log_err("fio: lockfile= option must precede filename=\n");
-		return 1;
-	}
-
-	return 0;
-}
-
 static int str_opendir_cb(void *data, const char fio_unused *str)
 {
 	struct thread_data *td = data;
@@ -1343,7 +1331,6 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.parent	= "filename",
 		.hide	= 0,
 		.def	= "none",
-		.cb	= str_lockfile_cb,
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_FILENAME,
 		.posval = {
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 405b05b..2f75d00 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.3">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.4">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/t/axmap.c b/t/axmap.c
index cc078aa..e32ff98 100644
--- a/t/axmap.c
+++ b/t/axmap.c
@@ -5,7 +5,6 @@
 #include <unistd.h>
 #include <inttypes.h>
 
-#include "../mutex.h"
 #include "../lib/lfsr.h"
 #include "../lib/axmap.h"
 
