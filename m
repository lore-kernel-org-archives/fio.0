Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54267 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753358AbdJUMAV (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 21 Oct 2017 08:00:21 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e5sRx-0001Kq-7B
        for fio@vger.kernel.org; Sat, 21 Oct 2017 12:00:21 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171021120002.02FC52C0098@kernel.dk>
Date: Sat, 21 Oct 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7ad86b642b6c3962177064b85b4c055ae9455032:

  Merge branch 'cpuclock-test' (2017-10-17 12:59:40 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 71aa48eb4eed51adb719d159810ab0044b2a7154:

  doc: minor formatting fixes (2017-10-20 07:16:40 +0100)

----------------------------------------------------------------
Sitsofe Wheeler (1):
      doc: minor formatting fixes

 HOWTO | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index a1513e1..22a5849 100644
--- a/HOWTO
+++ b/HOWTO
@@ -218,7 +218,7 @@ Command line options
 
 	Set the maximum number of threads/processes to support to `nr`.
 	NOTE: On Linux, it may be necessary to increase the shared-memory
-	limit ('/proc/sys/kernel/shmmax') if fio runs into errors while
+	limit (:file:`/proc/sys/kernel/shmmax`) if fio runs into errors while
 	creating jobs.
 
 .. option:: --server=args
@@ -233,7 +233,7 @@ Command line options
 .. option:: --client=hostname
 
 	Instead of running the jobs locally, send and run them on the given `hostname`
-	or set of `hostname`s.  See `Client/Server`_ section.
+	or set of `hostname`\s.  See `Client/Server`_ section.
 
 .. option:: --remote-config=file
 
@@ -1715,7 +1715,7 @@ I/O engine
 			Doesn't transfer any data, but burns CPU cycles according to the
 			:option:`cpuload` and :option:`cpuchunks` options. Setting
 			:option:`cpuload`\=85 will cause that job to do nothing but burn 85%
-			of the CPU. In case of SMP machines, use :option:`numjobs`=<nr_of_cpu>
+			of the CPU. In case of SMP machines, use :option:`numjobs`\=<nr_of_cpu>
 			to get desired CPU usage, as the cpuload only loads a
 			single CPU at the desired rate. A job never finishes unless there is
 			at least one non-cpuio job.
