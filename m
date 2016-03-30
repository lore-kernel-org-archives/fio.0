Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45507 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbcC3MAL (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 30 Mar 2016 08:00:11 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1alEnB-00049m-5u
	for fio@vger.kernel.org; Wed, 30 Mar 2016 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160330120004.57C202C0114@kernel.dk>
Date: Wed, 30 Mar 2016 06:00:04 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 53280a1dc785ef0447aa5cf8e32e899ecfc22978:

  t/read-to-pipe-async: use gettimeofday() instead of clock_gettime() (2016-03-25 09:40:41 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 23a8e176c3725f3640eaaf31a0a4c7497366c40f:

  HOWTO/man: clarify that the usr/sys utilization numbers are averages (2016-03-29 08:34:06 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Fix crash with group_reporting and one group member that never started
      HOWTO/man: clarify that the usr/sys utilization numbers are averages

 HOWTO  | 4 +++-
 fio.1  | 4 +++-
 stat.c | 2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 0d3d2fb..6e052f5 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1987,7 +1987,9 @@ runt=		The runtime of that thread
 cpu=		CPU usage. User and system time, along with the number
 		of context switches this thread went through, usage of
 		system and user time, and finally the number of major
-		and minor page faults.
+		and minor page faults. The CPU utilization numbers are
+		averages for the jobs in that reporting group, while the
+		context and fault counters are summed.
 IO depths=	The distribution of io depths over the job life time. The
 		numbers are divided into powers of 2, so for example the
 		16= entries includes depths up to that value but higher
diff --git a/fio.1 b/fio.1
index df140cf..b54f568 100644
--- a/fio.1
+++ b/fio.1
@@ -1873,7 +1873,9 @@ and standard deviation.
 .TP
 .B cpu
 CPU usage statistics. Includes user and system time, number of context switches
-this thread went through and number of major and minor page faults.
+this thread went through and number of major and minor page faults. The CPU
+utilization numbers are averages for the jobs in that reporting group, while
+the context and fault counters are summed.
 .TP
 .B IO depths
 Distribution of I/O depths.  Each depth includes everything less than (or equal)
diff --git a/stat.c b/stat.c
index d2720a4..6d8d4d0 100644
--- a/stat.c
+++ b/stat.c
@@ -1580,6 +1580,8 @@ void __show_run_stats(void)
 		unsigned long long bw;
 
 		ts = &threadstats[i];
+		if (ts->groupid == -1)
+			continue;
 		rs = &runstats[ts->groupid];
 		rs->kb_base = ts->kb_base;
 		rs->unit_base = ts->unit_base;
