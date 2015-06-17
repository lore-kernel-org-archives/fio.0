Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41729 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbbFQMAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 17 Jun 2015 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z5C0l-0004V6-C8
	for fio@vger.kernel.org; Wed, 17 Jun 2015 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150617120001.9124E2C00C7@kernel.dk>
Date: Wed, 17 Jun 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1116dc04bec6df8f0857fceaf1cbf9032644e643:

  Enable FIO_HAVE_CHARDEV_SIZE on DragonFlyBSD (2015-06-12 23:16:26 +0900)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d86ae56c2995f90b5ac38de981d6f46114dabdf3:

  HOWTO: make it clear that deviation is standard deviation (2015-06-16 09:30:59 -0600)

----------------------------------------------------------------
Chris Worley (1):
      HOWTO: make it clear that deviation is standard deviation

 HOWTO | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 61ebe5e..b823eae 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1956,18 +1956,18 @@ Split up, the format is as follows:
 	terse version, fio version, jobname, groupid, error
 	READ status:
 		Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
-		Submission latency: min, max, mean, deviation (usec)
-		Completion latency: min, max, mean, deviation (usec)
+		Submission latency: min, max, mean, stdev (usec)
+		Completion latency: min, max, mean, stdev (usec)
 		Completion latency percentiles: 20 fields (see below)
-		Total latency: min, max, mean, deviation (usec)
-		Bw (KB/s): min, max, aggregate percentage of total, mean, deviation
+		Total latency: min, max, mean, stdev (usec)
+		Bw (KB/s): min, max, aggregate percentage of total, mean, stdev
 	WRITE status:
 		Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
-		Submission latency: min, max, mean, deviation (usec)
-		Completion latency: min, max, mean, deviation (usec)
+		Submission latency: min, max, mean, stdev (usec)
+		Completion latency: min, max, mean, stdev(usec)
 		Completion latency percentiles: 20 fields (see below)
-		Total latency: min, max, mean, deviation (usec)
-		Bw (KB/s): min, max, aggregate percentage of total, mean, deviation
+		Total latency: min, max, mean, stdev (usec)
+		Bw (KB/s): min, max, aggregate percentage of total, mean, stdev
 	CPU usage: user, system, context switches, major faults, minor faults
 	IO depths: <=1, 2, 4, 8, 16, 32, >=64
 	IO latencies microseconds: <=2, 4, 10, 20, 50, 100, 250, 500, 750, 1000
