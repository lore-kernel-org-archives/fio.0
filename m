Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36454 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbcDSMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 19 Apr 2016 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1asUK5-00031v-7U
	for fio@vger.kernel.org; Tue, 19 Apr 2016 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160419120002.883CB2C18E7@kernel.dk>
Date: Tue, 19 Apr 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit eeea64a6ad6c1fed6c477a49bd5398559cf667d3:

  t/fio-verify-state: show completions in order (2016-04-15 09:03:34 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4b1ddb7afd332431e83ef5f1b9ee0216aef197c4:

  Documentation: it's 'log_max_value', not 'log_max' (2016-04-18 16:54:12 -0400)

----------------------------------------------------------------
Jens Axboe (1):
      Documentation: it's 'log_max_value', not 'log_max'

 HOWTO | 11 ++++++-----
 fio.1 |  4 ++--
 2 files changed, 8 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 6e052f5..2be1648 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1596,12 +1596,13 @@ log_avg_msec=int By default, fio will log an entry in the iops, latency,
 		disk log, that can quickly grow to a very large size. Setting
 		this option makes fio average the each log entry over the
 		specified period of time, reducing the resolution of the log.
-		See log_max as well. Defaults to 0, logging all entries.
+		See log_max_value as well. Defaults to 0, logging all entries.
+
+log_max_value=bool	If log_avg_msec is set, fio logs the average over that
+		window. If you instead want to log the maximum value, set this
+		option to 1. Defaults to 0, meaning that averaged values are
+		logged.
 
-log_max=bool	If log_avg_msec is set, fio logs the average over that window.
-		If you instead want to log the maximum value, set this option
-		to 1. Defaults to 0, meaning that averaged values are logged.
-.
 log_offset=int	If this is set, the iolog options will include the byte
 		offset for the IO entry as well as the other data values.
 
diff --git a/fio.1 b/fio.1
index b54f568..e502dfe 100644
--- a/fio.1
+++ b/fio.1
@@ -1465,9 +1465,9 @@ By default, fio will log an entry in the iops, latency, or bw log for every
 IO that completes. When writing to the disk log, that can quickly grow to a
 very large size. Setting this option makes fio average the each log entry
 over the specified period of time, reducing the resolution of the log. See
-\fBlog_max\fR as well.  Defaults to 0, logging all entries.
+\fBlog_max_value\fR as well.  Defaults to 0, logging all entries.
 .TP
-.BI log_max \fR=\fPbool
+.BI log_max_value \fR=\fPbool
 If \fBlog_avg_msec\fR is set, fio logs the average over that window. If you
 instead want to log the maximum value, set this option to 1.  Defaults to
 0, meaning that averaged values are logged.
