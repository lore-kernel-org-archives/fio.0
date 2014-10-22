Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36555 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002AbaJVMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 22 Oct 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XguaD-00053w-4W
	for fio@vger.kernel.org; Wed, 22 Oct 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141022120003.E3182401D8@lyth.info>
Date: Wed, 22 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 24ffb6f85058a95d4647541283c94c9e27520f1b:

  Add alignment to thread_options_pack for proper fp alignment (2014-10-20 10:56:46 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 60a5a18b811cd60430d2912b49fa3970df0d5077:

  t/dedupe: fix init of all thread variables (2014-10-21 13:02:29 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      compiler: improve gcc 4.x compile time check
      t/dedupe: fix init of all thread variables

Shu-Yu Fu (1):
      Fix typo in alignment check

 compiler/compiler-gcc4.h |    9 +++++++++
 libfio.c                 |    2 +-
 t/dedupe.c               |    4 +---
 thread_options.h         |    1 +
 4 files changed, 12 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/compiler/compiler-gcc4.h b/compiler/compiler-gcc4.h
index f136611..e8701cf 100644
--- a/compiler/compiler-gcc4.h
+++ b/compiler/compiler-gcc4.h
@@ -5,4 +5,13 @@
 #define __must_check		__attribute__((warn_unused_result))
 #endif
 
+#define GCC_VERSION (__GNUC__ * 10000		\
+			+ __GNUC_MINOR__ * 100	\
+			+ __GNUC_PATCHLEVEL__)
+
+#if GCC_VERSION >= 40300
+#define __compiletime_warning(message)	__attribute__((warning(message)))
+#define __compiletime_error(message)	__attribute__((error(message)))
+#endif
+
 #endif
diff --git a/libfio.c b/libfio.c
index 523cc36..9ed802a 100644
--- a/libfio.c
+++ b/libfio.c
@@ -307,7 +307,7 @@ int initialize_fio(char *envp[])
 	compiletime_assert((offsetof(struct thread_options_pack, zipf_theta) % 8) == 0, "zipf_theta");
 	compiletime_assert((offsetof(struct thread_options_pack, pareto_h) % 8) == 0, "pareto_h");
 	compiletime_assert((offsetof(struct thread_options_pack, percentile_list) % 8) == 0, "percentile_list");
-	compiletime_assert((offsetof(struct thread_options_pack, percentile_list) % 8) == 0, "latency_percentile");
+	compiletime_assert((offsetof(struct thread_options_pack, latency_percentile) % 8) == 0, "latency_percentile");
 
 	if (endian_check()) {
 		log_err("fio: endianness settings appear wrong.\n");
diff --git a/t/dedupe.c b/t/dedupe.c
index b43b677..5b88fcb 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -387,10 +387,8 @@ static int run_dedupe_threads(struct fio_file *f, uint64_t dev_size,
 
 	threads = malloc(num_threads * sizeof(struct worker_thread));
 	for (i = 0; i < num_threads; i++) {
+		memset(&threads[i], 0, sizeof(struct worker_thread));
 		threads[i].fd = f->fd;
-		threads[i].items = 0;
-		threads[i].err = 0;
-		threads[i].done = 0;
 
 		err = pthread_create(&threads[i].thread, NULL, thread_fn, &threads[i]);
 		if (err) {
diff --git a/thread_options.h b/thread_options.h
index 5c9910a..ecf4e47 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -477,6 +477,7 @@ struct thread_options_pack {
 	uint64_t number_ios;
 
 	uint32_t sync_file_range;
+	uint32_t pad2;
 
 	uint64_t latency_target;
 	uint64_t latency_window;
