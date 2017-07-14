Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41442 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753472AbdGNMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Jul 2017 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dVzGN-0007YR-4F
        for fio@vger.kernel.org; Fri, 14 Jul 2017 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170714120002.06EE42C009B@kernel.dk>
Date: Fri, 14 Jul 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 43f466e667a8bcfc58c1c69b0897fe0345c34841:

  parse: enable options to be marked dont-free (2017-07-12 16:44:07 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8f4b9f2475a4524067b6a0662aff006783919922:

  Update documentation for write_hint (2017-07-13 09:39:01 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Update documentation for write_hint

 HOWTO | 26 ++++++++++++++++++++++----
 fio.1 | 28 ++++++++++++++++++++++++----
 2 files changed, 46 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 0b80a62..e544634 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1093,11 +1093,29 @@ I/O type
 		**random**
 			Advise using **FADV_RANDOM**.
 
-.. option:: fadvise_stream=int
+.. option:: write_hint=str
 
-	Use :manpage:`posix_fadvise(2)` to advise the kernel what stream ID the
-	writes issued belong to. Only supported on Linux. Note, this option may
-	change going forward.
+	Use :manpage:`fcntl(2)` to advise the kernel what life time to expect
+	from a write. Only supported on Linux, as of version 4.13. Accepted
+	values are:
+
+		**none**
+			No particular life time associated with this file.
+
+		**short**
+			Data written to this file has a short life time.
+
+		**medium**
+			Data written to this file has a medium life time.
+
+		**long**
+			Data written to this file has a long life time.
+
+		**extreme**
+			Data written to this file has a very long life time.
+
+	The values are all relative to each other, and no absolute meaning
+	should be associated with them.
 
 .. option:: offset=int
 
diff --git a/fio.1 b/fio.1
index bc477a2..5da9ecf 100644
--- a/fio.1
+++ b/fio.1
@@ -564,10 +564,30 @@ Advise using \fBFADV_RANDOM\fR
 .RE
 .RE
 .TP
-.BI fadvise_stream \fR=\fPint
-Use \fBposix_fadvise\fR\|(2) to advise the kernel what stream ID the
-writes issued belong to. Only supported on Linux. Note, this option
-may change going forward.
+.BI write_hint \fR=\fPstr
+Use \fBfcntl\fR|(2) to advise the kernel what life time to expect from a write.
+Only supported on Linux, as of version 4.13. The values are all relative to
+each other, and no absolute meaning should be associated with them. Accepted
+values are:
+.RS
+.RS
+.TP
+.B none
+No particular life time associated with this file.
+.TP
+.B short
+Data written to this file has a short life time.
+.TP
+.B medium
+Data written to this file has a medium life time.
+.TP
+.B long
+Data written to this file has a long life time.
+.TP
+.B extreme
+Data written to this file has a very long life time.
+.RE
+.RE
 .TP
 .BI size \fR=\fPint
 Total size of I/O for this job.  \fBfio\fR will run until this many bytes have
