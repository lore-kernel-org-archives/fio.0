Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54959 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbbHSMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Aug 2015 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZS22F-0004xR-33
	for fio@vger.kernel.org; Wed, 19 Aug 2015 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150819120002.1A23B2C1D59@kernel.dk>
Date: Wed, 19 Aug 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0e1c454a80bc9f1516ebc910ceb257bc6733e6b4:

  mtd: expand configure check (2015-08-17 15:47:42 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ae156be6aadb7b4ca6db8584cf5c9e957df916ed:

  configure: cleanup strsep() test case (2015-08-18 11:26:00 -0700)

----------------------------------------------------------------
Dave (1):
      Correct handleing of rate_iops_min and ratemin

Jens Axboe (3):
      Merge branch 'master' of git://github.com/DaveGlen/fio
      configure: fixup using wrong var for endmntent()
      configure: cleanup strsep() test case

 backend.c | 3 ++-
 configure | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 9307667..76994d9 100644
--- a/backend.c
+++ b/backend.c
@@ -179,7 +179,7 @@ static int __check_min_rate(struct thread_data *td, struct timeval *now,
 		if (spent < td->o.ratecycle)
 			return 0;
 
-		if (td->o.rate[ddir]) {
+		if (td->o.rate[ddir] || td->o.ratemin[ddir]) {
 			/*
 			 * check bandwidth specified rate
 			 */
@@ -220,6 +220,7 @@ static int __check_min_rate(struct thread_data *td, struct timeval *now,
 					log_err("%s: min iops rate %u not met,"
 						" got %lu\n", td->o.name,
 							rate_iops_min, rate);
+					return 1;
 				}
 			}
 		}
diff --git a/configure b/configure
index 1a41fe5..ee096b3 100755
--- a/configure
+++ b/configure
@@ -939,7 +939,8 @@ cat > $TMPC << EOF
 #include <string.h>
 int main(int argc, char **argv)
 {
-  strsep(NULL, NULL);
+  static char *string = "This is a string";
+  strsep(&string, "needle");
   return 0;
 }
 EOF
@@ -1480,7 +1481,7 @@ int main(int argc, char **argv)
 {
   FILE *mtab = setmntent(NULL, "r");
   struct mntent *mnt = getmntent(mtab);
-  endmntent(mnt);
+  endmntent(mtab);
   return 0;
 }
 EOF
