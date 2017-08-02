Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48478 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753165AbdHBMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Aug 2017 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dcsJs-0006nC-R1
        for fio@vger.kernel.org; Wed, 02 Aug 2017 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170802120002.286FE2C1196@kernel.dk>
Date: Wed,  2 Aug 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2e2b80c58afa2da6cf2e6c792db16757b2244847:

  Merge branch 'master' of https://github.com/dublio/fio (2017-07-31 08:15:17 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2b455dbf8038ee5998f9280fac40f8089175adf7:

  HOWTO: minor fix and backport from man page (2017-08-01 13:55:09 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (3):
      HOWTO: fix wrong description of trim_backlog=
      HOWTO: fix wrong "here follows the complete list of fio job parameters" position
      HOWTO: minor fix and backport from man page

 HOWTO | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index caf6591..ee2b996 100644
--- a/HOWTO
+++ b/HOWTO
@@ -576,6 +576,8 @@ Parameter types
 **float_list**
 	A list of floating point numbers, separated by a ':' character.
 
+With the above in mind, here follows the complete list of fio job parameters.
+
 
 Units
 ~~~~~
@@ -622,9 +624,6 @@ Units
 		Bit based.
 
 
-With the above in mind, here follows the complete list of fio job parameters.
-
-
 Job description
 ~~~~~~~~~~~~~~~
 
@@ -1530,6 +1529,7 @@ Buffers and memory
 
 		**cudamalloc**
 			Use GPU memory as the buffers for GPUDirect RDMA benchmark.
+			The ioengine must be rdma.
 
 	The area allocated is a function of the maximum allowed bs size for the job,
 	multiplied by the I/O depth given. Note that for **shmhuge** and
@@ -1858,7 +1858,7 @@ caveat that when used on the command line, they must come after the
 
    [libhdfs]
 
-		the listening port of the HFDS cluster namenode.
+		The listening port of the HFDS cluster namenode.
 
 .. option:: interface=str : [netsplice] [net]
 
@@ -1931,7 +1931,7 @@ caveat that when used on the command line, they must come after the
 	**0**
 		Default. Preallocate donor's file on init.
 	**1**
-		Allocate space immediately inside defragment event,	and free right
+		Allocate space immediately inside defragment event, and free right
 		after event.
 
 .. option:: clustername=str : [rbd]
@@ -1963,7 +1963,7 @@ caveat that when used on the command line, they must come after the
 
 .. option:: chunk_size : [libhdfs]
 
-	the size of the chunk to use for each file.
+	The size of the chunk to use for each file.
 
 
 I/O depth
@@ -2487,7 +2487,7 @@ Verification
 
 .. option:: verifysort_nr=int
 
-   Pre-load and sort verify blocks for a read workload.
+	Pre-load and sort verify blocks for a read workload.
 
 .. option:: verify_offset=int
 
@@ -2595,7 +2595,7 @@ Verification
 
 .. option:: trim_backlog=int
 
-	Verify that trim/discarded blocks are returned as zeros.
+	Trim after this number of blocks are written.
 
 .. option:: trim_backlog_batch=int
 
