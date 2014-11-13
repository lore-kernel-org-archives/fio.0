Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46804 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650AbaKMNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 13 Nov 2014 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xou0L-0007wJ-Do
	for fio@vger.kernel.org; Thu, 13 Nov 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141113130003.8740340162@lyth.info>
Date: Thu, 13 Nov 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e499aedc141da35cf778116d0abcb9cfcd53470c:

  verify: verify_state_gen_name() should check size (2014-11-11 20:51:37 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 42da5c8b2cdd53427145b623293bc5b915fb5f05:

  Fix some shadow warnings for some gcc variants (2014-11-12 11:11:20 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fix some shadow warnings for some gcc variants

 filesetup.c |   10 +++++-----
 io_ddir.h   |    8 ++++----
 stat.c      |    8 ++++----
 3 files changed, 13 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 4026f4d..cc6d440 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -991,12 +991,12 @@ static int __init_rand_distribution(struct thread_data *td, struct fio_file *f)
 {
 	unsigned int range_size, seed;
 	unsigned long nranges;
-	uint64_t file_size;
+	uint64_t fsize;
 
 	range_size = min(td->o.min_bs[DDIR_READ], td->o.min_bs[DDIR_WRITE]);
-	file_size = min(f->real_file_size, f->io_size);
+	fsize = min(f->real_file_size, f->io_size);
 
-	nranges = (file_size + range_size - 1) / range_size;
+	nranges = (fsize + range_size - 1) / range_size;
 
 	seed = jhash(f->file_name, strlen(f->file_name), 0) * td->thread_number;
 	if (!td->o.rand_repeatable)
@@ -1041,9 +1041,9 @@ int init_random_map(struct thread_data *td)
 		return 0;
 
 	for_each_file(td, f, i) {
-		uint64_t file_size = min(f->real_file_size, f->io_size);
+		uint64_t fsize = min(f->real_file_size, f->io_size);
 
-		blocks = file_size / (unsigned long long) td->o.rw_min_bs;
+		blocks = fsize / (unsigned long long) td->o.rw_min_bs;
 
 		if (td->o.random_generator == FIO_RAND_GEN_LFSR) {
 			unsigned long seed;
diff --git a/io_ddir.h b/io_ddir.h
index 795cecc..269768e 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -57,11 +57,11 @@ static inline int ddir_rw(enum fio_ddir ddir)
 
 static inline const char *ddir_str(enum td_ddir ddir)
 {
-	const char *ddir_str[] = { NULL, "read", "write", "rw", NULL,
-				   "randread", "randwrite", "randrw",
-				   "trim", NULL, NULL, NULL, "randtrim" };
+	const char *__str[] = { NULL, "read", "write", "rw", NULL,
+				"randread", "randwrite", "randrw",
+				"trim", NULL, NULL, NULL, "randtrim" };
 
-	return ddir_str[ddir];
+	return __str[ddir];
 }
 
 #define ddir_rw_sum(arr)	\
diff --git a/stat.c b/stat.c
index 1bfbbeb..9d816d4 100644
--- a/stat.c
+++ b/stat.c
@@ -263,7 +263,7 @@ int calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max,
 void show_group_stats(struct group_run_stats *rs)
 {
 	char *p1, *p2, *p3, *p4;
-	const char *ddir_str[] = { "   READ", "  WRITE" , "   TRIM"};
+	const char *str[] = { "   READ", "  WRITE" , "   TRIM"};
 	int i;
 
 	log_info("\nRun status group %d (all jobs):\n", rs->groupid);
@@ -281,7 +281,7 @@ void show_group_stats(struct group_run_stats *rs)
 
 		log_info("%s: io=%s, aggrb=%s/s, minb=%s/s, maxb=%s/s,"
 			 " mint=%llumsec, maxt=%llumsec\n",
-				rs->unified_rw_rep ? "  MIXED" : ddir_str[i],
+				rs->unified_rw_rep ? "  MIXED" : str[i],
 				p1, p2, p3, p4,
 				(unsigned long long) rs->min_run[i],
 				(unsigned long long) rs->max_run[i]);
@@ -363,7 +363,7 @@ static void display_lat(const char *name, unsigned long min, unsigned long max,
 static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			     int ddir)
 {
-	const char *ddir_str[] = { "read ", "write", "trim" };
+	const char *str[] = { "read ", "write", "trim" };
 	unsigned long min, max, runt;
 	unsigned long long bw, iops;
 	double mean, dev;
@@ -386,7 +386,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	iops_p = num2str(iops, 6, 1, 0, 0);
 
 	log_info("  %s: io=%s, bw=%s/s, iops=%s, runt=%6llumsec\n",
-				rs->unified_rw_rep ? "mixed" : ddir_str[ddir],
+				rs->unified_rw_rep ? "mixed" : str[ddir],
 				io_p, bw_p, iops_p,
 				(unsigned long long) ts->runtime[ddir]);
 
