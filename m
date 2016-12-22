Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:8419 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754179AbcLVGHa (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 01:07:30 -0500
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g2t1383g.austin.hpe.com (Postfix) with ESMTPS id F4091136C
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:07:29 +0000 (UTC)
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g9t5008.houston.hpe.com (Postfix) with ESMTP id F379976
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:06:35 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 10/12] Clean up unit prefixes for binary multiples in comments and prints
Date: Thu, 22 Dec 2016 00:08:51 -0600
Message-Id: <20161222060853.64104-11-elliott@hpe.com>
In-Reply-To: <20161222060853.64104-1-elliott@hpe.com>
References: <20161222060853.64104-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

From: Robert Elliott <elliott@hpe.com>

Change comments and prints that are referring to values based on
binary multiples to use IEC 80000-13 prefixes for binary
multiples rather than SI prefixes for decimal multiples (e.g.,
KiB, MiB, and GiB rather than KB, MB, and GB).

Includes a fix for the rate_min print that was printing "KB/s"
although it was really printing bytes per second.
---
 README            |  2 +-
 backend.c         | 18 ++++++++----------
 engines/dev-dax.c |  2 +-
 engines/mmap.c    |  2 +-
 eta.c             |  2 +-
 filesetup.c       |  5 ++---
 goptions.c        |  2 +-
 memory.c          |  4 ++--
 stat.c            |  6 +++---
 9 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/README b/README
index a8a4fdf..98884e2 100644
--- a/README
+++ b/README
@@ -233,7 +233,7 @@ sections.  The reserved 'global' section is always parsed and used.
 The --alloc-size switch allows one to use a larger pool size for smalloc.
 If running large jobs with randommap enabled, fio can run out of memory.
 Smalloc is an internal allocator for shared structures from a fixed size
-memory pool. The pool size defaults to 16M and can grow to 8 pools.
+memory pool. The pool size defaults to 16MiB and can grow to 8 pools.
 
 NOTE: While running .fio_smalloc.* backing store files are visible in /tmp.
 
diff --git a/backend.c b/backend.c
index a048452..c8c6de6 100644
--- a/backend.c
+++ b/backend.c
@@ -180,8 +180,8 @@ static bool __check_min_rate(struct thread_data *td, struct timeval *now,
 			 * check bandwidth specified rate
 			 */
 			if (bytes < td->rate_bytes[ddir]) {
-				log_err("%s: min rate %u not met\n", td->o.name,
-								ratemin);
+				log_err("%s: rate_min=%uB/s not met, only transferred %lluB\n",
+					td->o.name, ratemin, bytes);
 				return true;
 			} else {
 				if (spent)
@@ -191,9 +191,8 @@ static bool __check_min_rate(struct thread_data *td, struct timeval *now,
 
 				if (rate < ratemin ||
 				    bytes < td->rate_bytes[ddir]) {
-					log_err("%s: min rate %u not met, got"
-						" %luKB/sec\n", td->o.name,
-							ratemin, rate);
+					log_err("%s: rate_min=%uB/s not met, got %luB/s\n",
+						td->o.name, ratemin, rate);
 					return true;
 				}
 			}
@@ -202,8 +201,8 @@ static bool __check_min_rate(struct thread_data *td, struct timeval *now,
 			 * checks iops specified rate
 			 */
 			if (iops < rate_iops) {
-				log_err("%s: min iops rate %u not met\n",
-						td->o.name, rate_iops);
+				log_err("%s: rate_iops_min=%u not met, only performed %lu IOs\n",
+						td->o.name, rate_iops, iops);
 				return true;
 			} else {
 				if (spent)
@@ -213,9 +212,8 @@ static bool __check_min_rate(struct thread_data *td, struct timeval *now,
 
 				if (rate < rate_iops_min ||
 				    iops < td->rate_blocks[ddir]) {
-					log_err("%s: min iops rate %u not met,"
-						" got %lu\n", td->o.name,
-							rate_iops_min, rate);
+					log_err("%s: rate_iops_min=%u not met, got %lu IOPS\n",
+						td->o.name, rate_iops_min, rate);
 					return true;
 				}
 			}
diff --git a/engines/dev-dax.c b/engines/dev-dax.c
index 6372576..2516bca 100644
--- a/engines/dev-dax.c
+++ b/engines/dev-dax.c
@@ -58,7 +58,7 @@
 #include "../verify.h"
 
 /*
- * Limits us to 1GB of mapped files in total to model after
+ * Limits us to 1GiB of mapped files in total to model after
  * mmap engine behavior
  */
 #define MMAP_TOTAL_SZ	(1 * 1024 * 1024 * 1024UL)
diff --git a/engines/mmap.c b/engines/mmap.c
index c479ed3..99e1d6a 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -15,7 +15,7 @@
 #include "../verify.h"
 
 /*
- * Limits us to 1GB of mapped files in total
+ * Limits us to 1GiB of mapped files in total
  */
 #define MMAP_TOTAL_SZ	(1 * 1024 * 1024 * 1024UL)
 
diff --git a/eta.c b/eta.c
index 19afad5..68dc0c9 100644
--- a/eta.c
+++ b/eta.c
@@ -308,7 +308,7 @@ static void calc_rate(int unified_rw_rep, unsigned long mtime,
 
 		diff = io_bytes[i] - prev_io_bytes[i];
 		if (mtime)
-			this_rate = ((1000 * diff) / mtime) / 1024;
+			this_rate = ((1000 * diff) / mtime) / 1024; /* KiB/s */
 		else
 			this_rate = 0;
 
diff --git a/filesetup.c b/filesetup.c
index 969e7cc..ef94bd2 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -948,9 +948,8 @@ int setup_files(struct thread_data *td)
 	if (need_extend) {
 		temp_stall_ts = 1;
 		if (output_format & FIO_OUTPUT_NORMAL)
-			log_info("%s: Laying out IO file(s) (%u file(s) /"
-				 " %lluMB)\n", o->name, need_extend,
-					extend_size >> 20);
+			log_info("%s: Laying out IO file(s) (%u file(s) / %lluMiB)\n",
+				 o->name, need_extend, extend_size >> 20);
 
 		for_each_file(td, f, i) {
 			unsigned long long old_len = -1ULL, extend_len = -1ULL;
diff --git a/goptions.c b/goptions.c
index b3d3684..be49248 100644
--- a/goptions.c
+++ b/goptions.c
@@ -826,7 +826,7 @@ static struct gopt *gopt_new_str_val(struct gopt_job_view *gjv,
 				     unsigned long long *p, unsigned int idx)
 {
 	struct gopt_str_val *g;
-	const gchar *postfix[] = { "B", "KB", "MB", "GB", "PB", "TB", "" };
+	const gchar *postfix[] = { "B", "KiB", "MiB", "GiB", "PiB", "TiB", "" };
 	GtkWidget *label;
 	int i;
 
diff --git a/memory.c b/memory.c
index 9124117..9e73f10 100644
--- a/memory.c
+++ b/memory.c
@@ -33,13 +33,13 @@ int fio_pin_memory(struct thread_data *td)
 	dprint(FD_MEM, "pinning %llu bytes\n", td->o.lockmem);
 
 	/*
-	 * Don't allow mlock of more than real_mem-128MB
+	 * Don't allow mlock of more than real_mem-128MiB
 	 */
 	phys_mem = os_phys_mem();
 	if (phys_mem) {
 		if ((td->o.lockmem + 128 * 1024 * 1024) > phys_mem) {
 			td->o.lockmem = phys_mem - 128 * 1024 * 1024;
-			log_info("fio: limiting mlocked memory to %lluMB\n",
+			log_info("fio: limiting mlocked memory to %lluMiB\n",
 							td->o.lockmem >> 20);
 		}
 	}
diff --git a/stat.c b/stat.c
index f014e60..8562ab4 100644
--- a/stat.c
+++ b/stat.c
@@ -812,7 +812,7 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 	if (ts->runtime[ddir]) {
 		uint64_t runt = ts->runtime[ddir];
 
-		bw = ((1000 * ts->io_bytes[ddir]) / runt) / 1024;
+		bw = ((1000 * ts->io_bytes[ddir]) / runt) / 1024; /* KiB/s */
 		iops = (1000 * (uint64_t) ts->total_io_u[ddir]) / runt;
 	}
 
@@ -896,7 +896,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	if (ts->runtime[ddir]) {
 		uint64_t runt = ts->runtime[ddir];
 
-		bw = ((1000 * ts->io_bytes[ddir]) / runt) / 1024;
+		bw = ((1000 * ts->io_bytes[ddir]) / runt) / 1024; /* KiB/s */
 		iops = (1000.0 * (uint64_t) ts->total_io_u[ddir]) / runt;
 	}
 
@@ -2431,7 +2431,7 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 			continue; /* No entries for interval */
 
 		if (spent)
-			rate = delta * 1000 / spent / 1024;
+			rate = delta * 1000 / spent / 1024; /* KiB/s */
 		else
 			rate = 0;
 
-- 
2.9.3

