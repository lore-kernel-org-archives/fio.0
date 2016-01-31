Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45429 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729AbcAaNAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 31 Jan 2016 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aPrbo-0006zi-1V
	for fio@vger.kernel.org; Sun, 31 Jan 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160131130001.F1A202C0117@kernel.dk>
Date: Sun, 31 Jan 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a89c77abb152277ca3731f4766a7f377f0fc99df:

  server: send trigger state inline (2016-01-28 13:41:18 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3bb85e8443d626ee71a4126dbe6ebcaf751527f1:

  Add a note of what is the default value for random_generator (2016-01-30 22:03:39 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Add a note of what is the default value for random_generator

 HOWTO | 4 +++-
 fio.1 | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 7c24c1b..4a910a1 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1013,7 +1013,9 @@ random_generator=str	Fio supports the following engines for generating
 		typically good enough. LFSR only works with single
 		block sizes, not with workloads that use multiple block
 		sizes. If used with such a workload, fio may read or write
-		some blocks multiple times.
+		some blocks multiple times. The default value is tausworthe,
+		unless the required space exceeds 2^32 blocks. If it does,
+		then tausworthe64 is selected automatically.
 
 nice=int	Run the job with the given nice value. See man nice(2).
 
diff --git a/fio.1 b/fio.1
index 7bdfea3..6cc6379 100644
--- a/fio.1
+++ b/fio.1
@@ -920,7 +920,9 @@ guarantees that we never generate the same offset twice, and it's also less
 computationally expensive. It's not a true random generator, however, though
 for IO purposes it's typically good enough. LFSR only works with single block
 sizes, not with workloads that use multiple block sizes. If used with such a
-workload, fio may read or write some blocks multiple times.
+workload, fio may read or write some blocks multiple times. The default
+value is tausworthe, unless the required space exceeds 2^32 blocks. If it does,
+then tausworthe64 is selected automatically.
 .TP
 .BI nice \fR=\fPint
 Run job with given nice value.  See \fBnice\fR\|(2).
