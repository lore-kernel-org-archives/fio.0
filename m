Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49304 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbbHRMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 18 Aug 2015 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZRfYg-0004WP-OZ
	for fio@vger.kernel.org; Tue, 18 Aug 2015 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150818120001.C19DB2C0179@kernel.dk>
Date: Tue, 18 Aug 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 75f90d5f9859e985feee8b6aca7b913d15fd2296:

  filesetup: make random generator block auto-switch on huge files (2015-08-14 12:25:20 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0e1c454a80bc9f1516ebc910ceb257bc6733e6b4:

  mtd: expand configure check (2015-08-17 15:47:42 -0600)

----------------------------------------------------------------
DaveGlen (1):
      allow for ratemin to be used without setting rate

Jens Axboe (3):
      Merge branch 'master' of git://github.com/DaveGlen/fio
      gettime: silence bogus gcc warnings
      mtd: expand configure check

 configure |  3 +++
 gettime.c |  2 ++
 init.c    | 12 ++++++------
 3 files changed, 11 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 4fb65e6..1a41fe5 100755
--- a/configure
+++ b/configure
@@ -1409,11 +1409,14 @@ echo "HDFS engine                   $libhdfs"
 # Check whether we have MTD
 mtd="no"
 cat > $TMPC << EOF
+#include <string.h>
 #include <mtd/mtd-user.h>
 #include <sys/ioctl.h>
 int main(int argc, char **argv)
 {
+  struct mtd_write_req ops;
   struct mtd_info_user info;
+  memset(&ops, 0, sizeof(ops));
   info.type = MTD_MLCNANDFLASH;
   return ioctl(0, MEMGETINFO, &info);
 }
diff --git a/gettime.c b/gettime.c
index ac54111..8d99900 100644
--- a/gettime.c
+++ b/gettime.c
@@ -640,6 +640,8 @@ int fio_monotonic_clocktest(int debug)
 
 	qsort(entries, tentries, sizeof(struct clock_entry), clock_cmp);
 
+	/* silence silly gcc */
+	prev = NULL;
 	for (failed = i = 0; i < tentries; i++) {
 		this = &entries[i];
 
diff --git a/init.c b/init.c
index 8e1f295..6d8dcff 100644
--- a/init.c
+++ b/init.c
@@ -636,12 +636,12 @@ static int fixup_options(struct thread_data *td)
 		log_err("fio: rate and rate_iops are mutually exclusive\n");
 		ret = 1;
 	}
-	if ((o->rate[DDIR_READ] < o->ratemin[DDIR_READ]) ||
-	    (o->rate[DDIR_WRITE] < o->ratemin[DDIR_WRITE]) ||
-	    (o->rate[DDIR_TRIM] < o->ratemin[DDIR_TRIM]) ||
-	    (o->rate_iops[DDIR_READ] < o->rate_iops_min[DDIR_READ]) ||
-	    (o->rate_iops[DDIR_WRITE] < o->rate_iops_min[DDIR_WRITE]) ||
-	    (o->rate_iops[DDIR_TRIM] < o->rate_iops_min[DDIR_TRIM])) {
+	if ((o->rate[DDIR_READ] && (o->rate[DDIR_READ] < o->ratemin[DDIR_READ])) ||
+	    (o->rate[DDIR_WRITE] && (o->rate[DDIR_WRITE] < o->ratemin[DDIR_WRITE])) ||
+	    (o->rate[DDIR_TRIM] && (o->rate[DDIR_TRIM] < o->ratemin[DDIR_TRIM])) ||
+	    (o->rate_iops[DDIR_READ] && (o->rate_iops[DDIR_READ] < o->rate_iops_min[DDIR_READ])) ||
+	    (o->rate_iops[DDIR_WRITE] && (o->rate_iops[DDIR_WRITE] < o->rate_iops_min[DDIR_WRITE])) ||
+	    (o->rate_iops[DDIR_TRIM] && (o->rate_iops[DDIR_TRIM] < o->rate_iops_min[DDIR_TRIM]))) {
 		log_err("fio: minimum rate exceeds rate\n");
 		ret = 1;
 	}
