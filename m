Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH] Fix duplicated typos from 42d97b5c in fio(1)
Date: Wed,  2 Nov 2016 20:51:30 +0900
Message-Id: <1478087490-6800-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Some typos are duplicated since fio(1) is written based on HOWTO,
(but not the same since commits that update HOWTO aren't always
in sync with fio(1)).

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 fio.1     |    6 +++---
 options.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

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
-- 
1.7.1


