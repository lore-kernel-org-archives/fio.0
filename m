Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50765 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbcCDNAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 4 Mar 2016 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1abpKt-0004OB-It
	for fio@vger.kernel.org; Fri, 04 Mar 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160304130002.2876D2C05EE@kernel.dk>
Date: Fri,  4 Mar 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2cafffbea5d2ed2f20d73efa0d82baa9046e0b12:

  Add support for preadv2/pwritev2 (2016-02-26 11:02:54 -0800)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8116fd24b737c9d878ccb6a4cc13cc4f974dc2dc:

  Update documentation for random_distribution=gauss (2016-03-03 14:00:54 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Update documentation for random_distribution=gauss

 HOWTO |  5 ++++-
 fio.1 | 16 ++++++++++------
 2 files changed, 14 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index c37a9e0..d70c9af 100644
--- a/HOWTO
+++ b/HOWTO
@@ -963,6 +963,7 @@ random_distribution=str:float	By default, fio will use a completely uniform
 		random		Uniform random distribution
 		zipf		Zipf distribution
 		pareto		Pareto distribution
+		gauss		Normal (guassian) distribution
 
 		When using a zipf or pareto distribution, an input value
 		is also needed to define the access pattern. For zipf, this
@@ -971,7 +972,9 @@ random_distribution=str:float	By default, fio will use a completely uniform
 		what the given input values will yield in terms of hit rates.
 		If you wanted to use zipf with a theta of 1.2, you would use
 		random_distribution=zipf:1.2 as the option. If a non-uniform
-		model is used, fio will disable use of the random map.
+		model is used, fio will disable use of the random map. For
+		the gauss distribution, a normal deviation is supplied as
+		a value between 0 and 100.
 
 percentage_random=int	For a random workload, set how big a percentage should
 		be random. This defaults to 100%, in which case the workload
diff --git a/fio.1 b/fio.1
index f98802a..81c266b 100644
--- a/fio.1
+++ b/fio.1
@@ -874,15 +874,19 @@ Zipf distribution
 .B pareto
 Pareto distribution
 .TP
+.B gauss
+Normal (gaussian) distribution
+.TP
 .RE
 .P
-When using a zipf or pareto distribution, an input value is also needed to
-define the access pattern. For zipf, this is the zipf theta. For pareto,
-it's the pareto power. Fio includes a test program, genzipf, that can be
-used visualize what the given input values will yield in terms of hit rates.
-If you wanted to use zipf with a theta of 1.2, you would use
+When using a \fBzipf\fR or \fBpareto\fR distribution, an input value is also
+needed to define the access pattern. For \fBzipf\fR, this is the zipf theta.
+For \fBpareto\fR, it's the pareto power. Fio includes a test program, genzipf,
+that can be used visualize what the given input values will yield in terms of
+hit rates. If you wanted to use \fBzipf\fR with a theta of 1.2, you would use
 random_distribution=zipf:1.2 as the option. If a non-uniform model is used,
-fio will disable use of the random map.
+fio will disable use of the random map. For the \fBgauss\fR distribution, a
+normal deviation is supplied as a value between 0 and 100.
 .TP
 .BI percentage_random \fR=\fPint
 For a random workload, set how big a percentage should be random. This defaults
