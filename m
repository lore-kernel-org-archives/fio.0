Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59576 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752844AbcKCMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Nov 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c2Ggd-0003fZ-BP
        for fio@vger.kernel.org; Thu, 03 Nov 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161103120001.6DA982C03BA@kernel.dk>
Date: Thu,  3 Nov 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4e795a3e0940509bd991682ec029000b6aa8881b:

  Remove extra space in tausworthe32 warning message (2016-11-01 14:24:50 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4e7a881493790a3a2b970988aef4bd3603877fab:

  Fix duplicated typos from 42d97b5c in fio(1) (2016-11-02 08:05:49 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (1):
      Fix duplicated typos from 42d97b5c in fio(1)

 fio.1     | 6 +++---
 options.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/fio.1 b/fio.1
index 48c2060..07480f0 100644
--- a/fio.1
+++ b/fio.1
@@ -764,7 +764,7 @@ Example #1:
 \fBiodepth_batch_complete_max\fR=<iodepth>
 .RE
 
-which means that we will retrieve at leat 1 IO and up to the
+which means that we will retrieve at least 1 IO and up to the
 whole submitted queue depth. If none of IO has been completed
 yet, we will wait.
 
@@ -1324,7 +1324,7 @@ fio will fill 1/2/3/4 bytes of the buffer at the time(it can be either a
 decimal or a hex number). The verify_pattern if larger than a 32-bit quantity
 has to be a hex number that starts with either "0x" or "0X". Use with
 \fBverify\fP=str. Also, verify_pattern supports %o format, which means that for
-each block offset will be written and then verifyied back, e.g.:
+each block offset will be written and then verified back, e.g.:
 .RS
 .RS
 \fBverify_pattern\fR=%o
@@ -2325,7 +2325,7 @@ IO is a TRIM
 The \fIoffset\fR is the offset, in bytes, from the start of the file, for that
 particular IO. The logging of the offset can be toggled with \fBlog_offset\fR.
 
-If windowed logging is enabled though \fBlog_avg_msec\fR, then fio doesn't log
+If windowed logging is enabled through \fBlog_avg_msec\fR, then fio doesn't log
 individual IOs. Instead of logs the average values over the specified
 period of time. Since \fIdata direction\fR and \fIoffset\fR are per-IO values,
 they aren't applicable if windowed logging is enabled. If windowed logging
diff --git a/options.c b/options.c
index 3c9adfb..5937eb6 100644
--- a/options.c
+++ b/options.c
@@ -2157,7 +2157,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  },
 			  { .ival = "gauss",
 			    .oval = FIO_FSERVICE_GAUSS,
-			    .help = "Normal (guassian) distribution",
+			    .help = "Normal (gaussian) distribution",
 			  },
 			  { .ival = "roundrobin",
 			    .oval = FIO_FSERVICE_RR,
