Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37135 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbaJUMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 21 Oct 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XgY6e-0000Ed-MN
	for fio@vger.kernel.org; Tue, 21 Oct 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141021120003.54C854017D@lyth.info>
Date: Tue, 21 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0f9940ad60550da5198e2d1e63e11803f5aef914:

  BSD Yacc doesn't understand --no-lines, so use -l instead (2014-10-15 14:16:35 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 24ffb6f85058a95d4647541283c94c9e27520f1b:

  Add alignment to thread_options_pack for proper fp alignment (2014-10-20 10:56:46 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      Add some build assert macros
      stat: ensure that the fp fields are 64-bit aligned
      fio: add alignment check for fp fields
      Add alignment to thread_options_pack for proper fp alignment

 compiler/compiler.h |   22 ++++++++++++++++++++++
 libfio.c            |   12 ++++++++++++
 server.h            |    2 +-
 stat.h              |    1 +
 thread_options.h    |    1 +
 5 files changed, 37 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/compiler/compiler.h b/compiler/compiler.h
index e1afcb4..40e857c 100644
--- a/compiler/compiler.h
+++ b/compiler/compiler.h
@@ -33,4 +33,26 @@
 	1; \
 })
 
+#ifndef __compiletime_error
+#define __compiletime_error(message)
+#endif
+#ifndef __compiletime_error_fallback
+#define __compiletime_error_fallback(condition)	do { } while (0)
+#endif
+
+#define __compiletime_assert(condition, msg, prefix, suffix)		\
+	do {								\
+		int __cond = !(condition);				\
+		extern void prefix ## suffix(void) __compiletime_error(msg); \
+		if (__cond)						\
+			prefix ## suffix();				\
+		__compiletime_error_fallback(__cond);			\
+	} while (0)
+
+#define _compiletime_assert(condition, msg, prefix, suffix) \
+	__compiletime_assert(condition, msg, prefix, suffix)
+
+#define compiletime_assert(condition, msg) \
+	_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
+
 #endif
diff --git a/libfio.c b/libfio.c
index 5a996f9..523cc36 100644
--- a/libfio.c
+++ b/libfio.c
@@ -297,6 +297,18 @@ int initialize_fio(char *envp[])
 {
 	long ps;
 
+	/*
+	 * We need these to be properly 64-bit aligned, otherwise we
+	 * can run into problems on archs that fault on unaligned fp
+	 * access (ARM).
+	 */
+	compiletime_assert((offsetof(struct thread_stat, percentile_list) % 8) == 0, "stat percentile_list");
+	compiletime_assert((offsetof(struct thread_stat, latency_percentile) % 8) == 0, "stat latency_percentile");
+	compiletime_assert((offsetof(struct thread_options_pack, zipf_theta) % 8) == 0, "zipf_theta");
+	compiletime_assert((offsetof(struct thread_options_pack, pareto_h) % 8) == 0, "pareto_h");
+	compiletime_assert((offsetof(struct thread_options_pack, percentile_list) % 8) == 0, "percentile_list");
+	compiletime_assert((offsetof(struct thread_options_pack, percentile_list) % 8) == 0, "latency_percentile");
+
 	if (endian_check()) {
 		log_err("fio: endianness settings appear wrong.\n");
 		log_err("fio: please report this to fio@vger.kernel.org\n");
diff --git a/server.h b/server.h
index 67ba38d..46d05a6 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 37,
+	FIO_SERVER_VER			= 38,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.h b/stat.h
index 1727c0c..d834cff 100644
--- a/stat.h
+++ b/stat.h
@@ -180,6 +180,7 @@ struct thread_stat {
 
 	uint32_t latency_depth;
 	uint64_t latency_target;
+	uint16_t pad;
 	fio_fp64_t latency_percentile;
 	uint64_t latency_window;
 } __attribute__((packed));
diff --git a/thread_options.h b/thread_options.h
index a45d7b7..5c9910a 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -349,6 +349,7 @@ struct thread_options_pack {
 	uint32_t bs_is_seq_rand;
 
 	uint32_t random_distribution;
+	uint32_t pad;
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
 
