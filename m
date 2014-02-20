Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:44231 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbaBTNU5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 20 Feb 2014 08:20:57 -0500
Received: from /spool/local
	by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Thu, 20 Feb 2014 13:20:56 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 06E7E1B08069
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 13:20:32 +0000 (GMT)
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s1KDKfgQ64749664
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 13:20:41 GMT
Received: from d06av03.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s1KDKqGh014661
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 06:20:53 -0700
Message-Id: <20140220132051.261584863@linux.vnet.ibm.com>
Date: Thu, 20 Feb 2014 14:20:04 +0100
From: ehrhardt@linux.vnet.ibm.com
Subject: [patch 6/9] fio: allow to combine terse output with any selected output type
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

*Resend with hopefully non mangled patches*
References: <20140220131958.965092001@linux.vnet.ibm.com>
Content-Disposition: inline; filename=combined-output-v2.diff

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

This patch adds the option --append-terse to be able to request a combination
of any given selected output format AND terse output based on the same data.

This will help all users that want to parse the terse data for further use,
but need to look into the logs every now and then which then should be
readable.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
 fio.1  |   10 +++++++---
 fio.h  |    1 +
 init.c |    9 +++++++++
 stat.c |   10 ++++++++++
 4 files changed, 27 insertions(+), 3 deletions(-)

[diff]

--- a/fio.1
+++ b/fio.1
@@ -32,6 +32,9 @@ Generate per-job bandwidth logs.
 .B \-\-minimal
 Print statistics in a terse, semicolon-delimited format.
 .TP
+.B \-\-append-terse
+Print statistics in selected mode AND terse, semicolon-delimited format.
+.TP
 .B \-\-version
 Display version information and exit.
 .TP
@@ -1578,9 +1581,10 @@ It is also possible to get fio to dump t
 running, without terminating the job. To do that, send fio the \fBUSR1\fR
 signal.
 .SH TERSE OUTPUT
-If the \fB\-\-minimal\fR option is given, the results will be printed in a
-semicolon-delimited format suitable for scripted use - a job description
-(if provided) follows on a new line.  Note that the first
+If the \fB\-\-minimal\fR / \fB\-\-append-terse\fR options are given, the
+results will be printed/appended in a semicolon-delimited format suitable for
+scripted use.
+A job description (if provided) follows on a new line.  Note that the first
 number in the line is the version number. If the output has to be changed
 for some reason, this number will be incremented by 1 to signify that
 change.  The fields are:
--- a/fio.h
+++ b/fio.h
@@ -373,6 +373,7 @@ extern unsigned int stat_number;
 extern int shm_id;
 extern int groupid;
 extern int output_format;
+extern int append_terse_output;
 extern int temp_stall_ts;
 extern uintptr_t page_mask, page_size;
 extern int read_only;
--- a/init.c
+++ b/init.c
@@ -43,6 +43,7 @@ struct thread_data *threads = NULL;
 
 int exitall_on_terminate = 0;
 int output_format = FIO_OUTPUT_NORMAL;
+int append_terse_output = 0;
 int eta_print = FIO_ETA_AUTO;
 int eta_new_line = 0;
 FILE *f_out = NULL;
@@ -109,6 +110,11 @@ static struct option l_opts[FIO_NR_OPTIO
 		.val		= 'F' | FIO_CLIENT_FLAG,
 	},
 	{
+		.name		= (char *) "append-terse",
+		.has_arg	= optional_argument,
+		.val		= 'f',
+	},
+	{
 		.name		= (char *) "version",
 		.has_arg	= no_argument,
 		.val		= 'v' | FIO_CLIENT_FLAG,
@@ -1716,6 +1722,9 @@ int parse_cmd_line(int argc, char *argv[
 			else
 				output_format = FIO_OUTPUT_NORMAL;
 			break;
+		case 'f':
+			append_terse_output = 1;
+			break;
 		case 'h':
 			if (!cur_client) {
 				usage(argv[0]);
--- a/stat.c
+++ b/stat.c
@@ -1386,6 +1386,16 @@ static void __show_run_stats(void)
 		show_idle_prof_stats(FIO_OUTPUT_NORMAL, NULL);
 	}
 
+	if ( !(output_format == FIO_OUTPUT_TERSE) && append_terse_output) {
+		log_info("\nAdditional Terse Output:\n");
+
+		for (i = 0; i < nr_ts; i++) {
+			ts = &threadstats[i];
+			rs = &runstats[ts->groupid];
+			show_thread_status_terse(ts, rs);
+		}
+	}
+
 	log_info_flush();
 	free(runstats);
 	free(threadstats);

