Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:8416 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757145AbcLVGHa (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 01:07:30 -0500
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g2t1383g.austin.hpe.com (Postfix) with ESMTPS id F1092D3E
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:07:28 +0000 (UTC)
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g9t5009.houston.hpe.com (Postfix) with ESMTP id 2171E7D
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:06:28 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 03/12] Document trim workload choices and other nits
Date: Thu, 22 Dec 2016 00:08:44 -0600
Message-Id: <20161222060853.64104-4-elliott@hpe.com>
In-Reply-To: <20161222060853.64104-1-elliott@hpe.com>
References: <20161222060853.64104-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

Add some missing trim workloads (rw=trim, randtrim) to HOWTO,
improve some wording about trims in HOWTO, fio.1 (the manpage),
and the help text in options.c.
---
 HOWTO     |  7 ++++---
 fio.1     | 12 ++++++------
 options.c |  4 ++--
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/HOWTO b/HOWTO
index 7274c0e..181e94c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -398,12 +398,13 @@ rw=str		Type of io pattern. Accepted values are:
 
 			read		Sequential reads
 			write		Sequential writes
+			trim		Sequential trims
 			randwrite	Random writes
 			randread	Random reads
+			randtrim	Random trims
 			rw,readwrite	Sequential mixed reads and writes
 			randrw		Random mixed reads and writes
-			trimwrite	Mixed trims and writes. Blocks will be
-					trimmed first, then written to.
+			trimwrite	Sequential trim+write sequences
 
 		Fio defaults to read if the option is not specified.
 		For the mixed io types, the default is to split them 50/50.
@@ -444,7 +445,7 @@ kb_base=int	The base unit for a kilobyte. The defacto base is 2^10, 1024.
 		1024 or 1000, with 1024 being the default.
 
 unified_rw_reporting=bool	Fio normally reports statistics on a per
-		data direction basis, meaning that read, write, and trim are
+		data direction basis, meaning that reads, writes, and trims are
 		accounted and reported separately. If this option is set,
 		the fio will sum the results and report them as "mixed"
 		instead.
diff --git a/fio.1 b/fio.1
index 6161760..7363a37 100644
--- a/fio.1
+++ b/fio.1
@@ -287,7 +287,7 @@ Sequential reads.
 Sequential writes.
 .TP
 .B trim
-Sequential trim (Linux block devices only).
+Sequential trims (Linux block devices only).
 .TP
 .B randread
 Random reads.
@@ -296,7 +296,7 @@ Random reads.
 Random writes.
 .TP
 .B randtrim
-Random trim (Linux block devices only).
+Random trims (Linux block devices only).
 .TP
 .B rw, readwrite
 Mixed sequential reads and writes.
@@ -305,8 +305,8 @@ Mixed sequential reads and writes.
 Mixed random reads and writes.
 .TP
 .B trimwrite
-Trim and write mixed workload. Blocks will be trimmed first, then the same
-blocks will be written to.
+Sequential trim and write mixed workload. Blocks will be trimmed first, then
+the same blocks will be written to.
 .RE
 .P
 Fio defaults to read if the option is not specified.
@@ -353,7 +353,7 @@ reasons. Allowed values are 1024 or 1000, with 1024 being the default.
 .TP
 .BI unified_rw_reporting \fR=\fPbool
 Fio normally reports statistics on a per data direction basis, meaning that
-read, write, and trim are accounted and reported separately. If this option is
+reads, writes, and trims are accounted and reported separately. If this option is
 set fio sums the results and reports them as "mixed" instead.
 .TP
 .BI randrepeat \fR=\fPbool
@@ -735,7 +735,7 @@ properly.
 Read, write and erase an MTD character device (e.g., /dev/mtd0). Discards are
 treated as erases. Depending on the underlying device type, the I/O may have
 to go in a certain pattern, e.g., on NAND, writing sequentially to erase blocks
-and discarding before overwriting. The writetrim mode works well for this
+and discarding before overwriting. The trimwrite mode works well for this
 constraint.
 .TP
 .B pmemblk
diff --git a/options.c b/options.c
index 45c85a2..3830521 100644
--- a/options.c
+++ b/options.c
@@ -2885,7 +2885,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= offsetof(struct thread_options, trim_percentage),
 		.minval = 0,
 		.maxval = 100,
-		.help	= "Number of verify blocks to discard/trim",
+		.help	= "Number of verify blocks to trim (i.e., discard)",
 		.parent	= "verify",
 		.def	= "0",
 		.interval = 1,
@@ -2897,7 +2897,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "trim_verify_zero",
 		.lname	= "Verify trim zero",
 		.type	= FIO_OPT_BOOL,
-		.help	= "Verify that trim/discarded blocks are returned as zeroes",
+		.help	= "Verify that trimmed (i.e., discarded) blocks are returned as zeroes",
 		.off1	= offsetof(struct thread_options, trim_zero),
 		.parent	= "trim_percentage",
 		.hide	= 1,
-- 
2.9.3

