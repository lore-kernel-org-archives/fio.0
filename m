Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33804 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbeCFNAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 6 Mar 2018 08:00:14 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1etCCT-0001Ii-M0
        for fio@vger.kernel.org; Tue, 06 Mar 2018 13:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180306130001.C900F2C0085@kernel.dk>
Date: Tue,  6 Mar 2018 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 316bc2d48fefa6f9dbf01e83948dfe847cf3ea0e:

  Merge branch 'mpath_nvme_diskutil' of https://github.com/sitsofe/fio (2018-03-02 12:02:08 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b979af5cba25e31dc2a8f2fd89ac5e40c24b6519:

  Merge branch 'howto_typos' of https://github.com/dirtyharrycallahan/fio (2018-03-05 10:29:39 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'manpage_typos' of https://github.com/dirtyharrycallahan/fio
      Merge branch 'howto_typos' of https://github.com/dirtyharrycallahan/fio

Patrick Callahan (2):
      doc: fix typos in fio man page
      doc: fix typos in HOWTO

 HOWTO | 8 ++++----
 fio.1 | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index f91a22e..acb9e97 100644
--- a/HOWTO
+++ b/HOWTO
@@ -672,7 +672,7 @@ Time related parameters
 	Tell fio to terminate processing after the specified period of time.  It
 	can be quite hard to determine for how long a specified job will run, so
 	this parameter is handy to cap the total runtime to a given time.  When
-	the unit is omitted, the value is intepreted in seconds.
+	the unit is omitted, the value is interpreted in seconds.
 
 .. option:: time_based
 
@@ -1775,7 +1775,7 @@ I/O engine
 			at least one non-cpuio job.
 
 		**guasi**
-			The GUASI I/O engine is the Generic Userspace Asyncronous Syscall
+			The GUASI I/O engine is the Generic Userspace Asynchronous Syscall
 			Interface approach to async I/O. See
 
 			http://www.xmailserver.org/guasi-lib.html
@@ -2413,7 +2413,7 @@ Threads, processes and job synchronization
 
 		<mode>[:<nodelist>]
 
-	``mode`` is one of the following memory poicies: ``default``, ``prefer``,
+	``mode`` is one of the following memory policies: ``default``, ``prefer``,
 	``bind``, ``interleave`` or ``local``. For ``default`` and ``local`` memory
 	policies, no node needs to be specified.  For ``prefer``, only one node is
 	allowed.  For ``bind`` and ``interleave`` the ``nodelist`` may be as
@@ -2537,7 +2537,7 @@ Verification
 			each block. This will automatically use hardware acceleration
 			(e.g. SSE4.2 on an x86 or CRC crypto extensions on ARM64) but will
 			fall back to software crc32c if none is found. Generally the
-			fatest checksum fio supports when hardware accelerated.
+			fastest checksum fio supports when hardware accelerated.
 
 		**crc32c-intel**
 			Synonym for crc32c.
diff --git a/fio.1 b/fio.1
index e488b01..f955167 100644
--- a/fio.1
+++ b/fio.1
@@ -454,7 +454,7 @@ See \fB\-\-max\-jobs\fR. Default: 1.
 Tell fio to terminate processing after the specified period of time. It
 can be quite hard to determine for how long a specified job will run, so
 this parameter is handy to cap the total runtime to a given time. When
-the unit is omitted, the value is intepreted in seconds.
+the unit is omitted, the value is interpreted in seconds.
 .TP
 .BI time_based
 If set, fio will run for the duration of the \fBruntime\fR specified
@@ -1552,7 +1552,7 @@ single CPU at the desired rate. A job never finishes unless there is
 at least one non\-cpuio job.
 .TP
 .B guasi
-The GUASI I/O engine is the Generic Userspace Asyncronous Syscall
+The GUASI I/O engine is the Generic Userspace Asynchronous Syscall
 Interface approach to async I/O. See \fIhttp://www.xmailserver.org/guasi\-lib.html\fR
 for more info on GUASI.
 .TP
@@ -2134,7 +2134,7 @@ arguments:
 <mode>[:<nodelist>]
 .RE
 .P
-`mode' is one of the following memory poicies: `default', `prefer',
+`mode' is one of the following memory policies: `default', `prefer',
 `bind', `interleave' or `local'. For `default' and `local' memory
 policies, no node needs to be specified. For `prefer', only one node is
 allowed. For `bind' and `interleave' the `nodelist' may be as
@@ -2244,7 +2244,7 @@ Use a crc32c sum of the data area and store it in the header of
 each block. This will automatically use hardware acceleration
 (e.g. SSE4.2 on an x86 or CRC crypto extensions on ARM64) but will
 fall back to software crc32c if none is found. Generally the
-fatest checksum fio supports when hardware accelerated.
+fastest checksum fio supports when hardware accelerated.
 .TP
 .B crc32c\-intel
 Synonym for crc32c.
