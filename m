Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41554 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752360AbdF2MAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Jun 2017 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dQY7E-0003p4-Jf
        for fio@vger.kernel.org; Thu, 29 Jun 2017 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170629120002.0FEF12C2649@kernel.dk>
Date: Thu, 29 Jun 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 867f90e36d9d1458b20e5fab4542ce6c631f2633:

  blktrace: remove unused ioctl definitions (2017-06-27 19:59:49 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dd3503d365f87e68079fb3e443a410743688d53b:

  fio: make gauss a duplicate of normal for file_service_type (2017-06-28 22:58:08 +0100)

----------------------------------------------------------------
Sitsofe Wheeler (3):
      stat: further group percentage fixes
      doc: fix random_distribution Gaussian parameter name
      fio: make gauss a duplicate of normal for file_service_type

Tomohiro Kusumi (2):
      HOWTO/manpage: update percentage explanation using '%'
      add FD_PARSE debug print for size= option (which exists in offset=)

 HOWTO     | 15 +++++++++------
 fio.1     | 19 +++++++++++--------
 options.c |  8 +++++++-
 stat.c    | 16 ++++++++--------
 4 files changed, 35 insertions(+), 23 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 37caa3c..6e53cff 100644
--- a/HOWTO
+++ b/HOWTO
@@ -853,10 +853,13 @@ Target file/device
 		**pareto**
 			Use a *Pareto* distribution to decide what file to access.
 
-		**gauss**
+		**normal**
 			Use a *Gaussian* (normal) distribution to decide what file to
 			access.
 
+		**gauss**
+			Alias for normal.
+
 	For *random*, *roundrobin*, and *sequential*, a postfix can be appended to
 	tell fio how many I/Os to issue before switching to a new file. For example,
 	specifying ``file_service_type=random:8`` would cause fio to issue
@@ -1095,8 +1098,8 @@ I/O type
 	offset will be used. Data before the given offset will not be touched. This
 	effectively caps the file size at `real_size - offset`. Can be combined with
 	:option:`size` to constrain the start and end range of the I/O workload.
-	A percentage can be specified by the percentage number plus 1 with preceding '-'.
-	For example, -1 is parsed as 0%, -10 is parsed as 9%, -101 is parsed as 100%.
+	A percentage can be specified by a number between 1 and 100 followed by '%',
+	for example, ``offset=20%`` to specify 20%.
 
 .. option:: offset_increment=int
 
@@ -1204,7 +1207,7 @@ I/O type
 		**pareto**
 				Pareto distribution
 
-		**gauss**
+		**normal**
 				Normal (Gaussian) distribution
 
 		**zoned**
@@ -1217,8 +1220,8 @@ I/O type
 	values will yield in terms of hit rates.  If you wanted to use **zipf** with
 	a `theta` of 1.2, you would use ``random_distribution=zipf:1.2`` as the
 	option. If a non-uniform model is used, fio will disable use of the random
-	map. For the **gauss** distribution, a normal deviation is supplied as a
-	value between 0 and 100.
+	map. For the **normal** distribution, a normal (Gaussian) deviation is
+	supplied as a value between 0 and 100.
 
 	For a **zoned** distribution, fio supports specifying percentages of I/O
 	access that should fall within what range of the file or device. For
diff --git a/fio.1 b/fio.1
index ac87c9d..ab04208 100644
--- a/fio.1
+++ b/fio.1
@@ -1,4 +1,4 @@
-.TH fio 1 "May 2017" "User Manual"
+.TH fio 1 "June 2017" "User Manual"
 .SH NAME
 fio \- flexible I/O tester
 .SH SYNOPSIS
@@ -676,8 +676,11 @@ Use a zipfian distribution to decide what file to access.
 .B pareto
 Use a pareto distribution to decide what file to access.
 .TP
+.B normal
+Use a Gaussian (normal) distribution to decide what file to access.
+.TP
 .B gauss
-Use a gaussian (normal) distribution to decide what file to access.
+Alias for normal.
 .RE
 .P
 For \fBrandom\fR, \fBroundrobin\fR, and \fBsequential\fR, a postfix can be
@@ -916,8 +919,8 @@ bytes or a percentage. If a percentage is given, the next \fBblockalign\fR-ed
 offset will be used. Data before the given offset will not be touched. This
 effectively caps the file size at (real_size - offset). Can be combined with
 \fBsize\fR to constrain the start and end range of the I/O workload. A percentage
-can be specified by the percentage number plus 1 with preceding '-'. For example,
--1 is parsed as 0%, -10 is parsed as 9%, -101 is parsed as 100%.
+can be specified by a number between 1 and 100 followed by '%', for example,
+offset=20% to specify 20%.
 .TP
 .BI offset_increment \fR=\fPint
 If this is provided, then the real offset becomes the
@@ -1004,8 +1007,8 @@ Zipf distribution
 .B pareto
 Pareto distribution
 .TP
-.B gauss
-Normal (gaussian) distribution
+.B normal
+Normal (Gaussian) distribution
 .TP
 .B zoned
 Zoned random distribution
@@ -1017,8 +1020,8 @@ For \fBpareto\fR, it's the pareto power. Fio includes a test program, genzipf,
 that can be used visualize what the given input values will yield in terms of
 hit rates. If you wanted to use \fBzipf\fR with a theta of 1.2, you would use
 random_distribution=zipf:1.2 as the option. If a non-uniform model is used,
-fio will disable use of the random map. For the \fBgauss\fR distribution, a
-normal deviation is supplied as a value between 0 and 100.
+fio will disable use of the random map. For the \fBnormal\fR distribution, a
+normal (Gaussian) deviation is supplied as a value between 0 and 100.
 .P
 .RS
 For a \fBzoned\fR distribution, fio supports specifying percentages of IO
diff --git a/options.c b/options.c
index 7431ed8..09a21af 100644
--- a/options.c
+++ b/options.c
@@ -1410,6 +1410,8 @@ static int str_size_cb(void *data, unsigned long long *__val)
 	if (parse_is_percent(v)) {
 		td->o.size = 0;
 		td->o.size_percent = -1ULL - v;
+		dprint(FD_PARSE, "SET size_percent %d\n",
+					td->o.size_percent);
 	} else
 		td->o.size = v;
 
@@ -2267,9 +2269,13 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = FIO_FSERVICE_PARETO,
 			    .help = "Pareto randomized",
 			  },
+			  { .ival = "normal",
+			    .oval = FIO_FSERVICE_GAUSS,
+			    .help = "Normal (Gaussian) randomized",
+			  },
 			  { .ival = "gauss",
 			    .oval = FIO_FSERVICE_GAUSS,
-			    .help = "Normal (Gaussian) distribution",
+			    .help = "Alias for normal",
 			  },
 			  { .ival = "roundrobin",
 			    .oval = FIO_FSERVICE_RR,
diff --git a/stat.c b/stat.c
index beec574..aebd107 100644
--- a/stat.c
+++ b/stat.c
@@ -475,6 +475,12 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		else
 			bw_str = "kB";
 
+		if (rs->agg[ddir]) {
+			p_of_agg = mean * 100 / (double) (rs->agg[ddir] / 1024);
+			if (p_of_agg > 100.0)
+				p_of_agg = 100.0;
+		}
+
 		if (rs->unit_base == 1) {
 			min *= 8.0;
 			max *= 8.0;
@@ -482,12 +488,6 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			dev *= 8.0;
 		}
 
-		if (rs->agg[ddir]) {
-			p_of_agg = mean * 100 / (double) (rs->agg[ddir] / 1024);
-			if (p_of_agg > 100.0)
-				p_of_agg = 100.0;
-		}
-
 		if (mean > fkb_base * fkb_base) {
 			min /= fkb_base;
 			max /= fkb_base;
@@ -924,7 +924,7 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 		double p_of_agg = 100.0;
 
 		if (rs->agg[ddir]) {
-			p_of_agg = mean * 100 / (double) rs->agg[ddir];
+			p_of_agg = mean * 100 / (double) (rs->agg[ddir] / 1024);
 			if (p_of_agg > 100.0)
 				p_of_agg = 100.0;
 		}
@@ -1055,7 +1055,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 
 	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
 		if (rs->agg[ddir]) {
-			p_of_agg = mean * 100 / (double) rs->agg[ddir];
+			p_of_agg = mean * 100 / (double) (rs->agg[ddir] / 1024);
 			if (p_of_agg > 100.0)
 				p_of_agg = 100.0;
 		}
