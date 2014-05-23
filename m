Return-Path: <fio-owner@vger.kernel.org>
Received: from ipo2.fzu.cz ([147.231.27.21]:19073 "EHLO ipo2.fzu.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbaEWM63 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 23 May 2014 08:58:29 -0400
Received: from [192.168.33.46] (unknown [91.213.143.252])
	by freja.fzu.cz (Postfix) with ESMTPSA id BB5E93DA9D
	for <fio@vger.kernel.org>; Fri, 23 May 2014 14:48:30 +0200 (CEST)
Message-ID: <537F439E.9040904@gmail.com>
Date: Fri, 23 May 2014 14:48:30 +0200
From: Jiri Horky <jiri.horky@gmail.com>
MIME-Version: 1.0
Subject: [PATCH] Allow to reset offset_increment counter
Content-Type: multipart/mixed;
 boundary="------------040701010204040701070801"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is a multi-part message in MIME format.
--------------040701010204040701070801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi all,

because I got bitten by this multiple times I decided to give this patch
a try :)

Current implementation of offset calculation when offset_increment is in
effect uses global thread_number as follows:
    f->file_offset = td->o.start_offset + (td->thread_number - 1) *
td->o.offset_increment;

The thread number gets incremented for every job (subjob) so even you
have multiple jobs with different filenames, the offset calculation is
shared. I find this very unintuitive, especially in cases the offsets
gets past the device/file. For example, if one wants to run sequential
read test in 16 threads of multiple devices (/dev/sd{b,c,d}) in one
group, which are of  1TB size, and to eliminate caching effect he wants
each read to start at different offset, the config could look like
following:

[seq-read-16threads-/dev/sdb]
rw=read
numjobs=16
offset_increment=50g
bs=512k
filename=/dev/sdb

[seq-read-16threads-/dev/sdc]
rw=read
numjobs=16
offset_increment=50g
bs=512k
filename=/dev/sdc

[seq-read-16threads-/dev/sdd]
rw=read
numjobs=16
offset_increment=50g
bs=512k
filename=/dev/sdd

The result will be that only /dev/sdb is full tested, three threads will
be run against /dev/sdc and /dev/sdd does not receive any IO at all.

The proposed patch add new option "reset_offset_increment" that causes
the offset calculation to be started again from zero. The idea behind is
similar to patch proposed here
(http://www.spinics.net/lists/fio/msg01213.html) but is more flexible.
The patch applies against 2.1.9 tag.

Regards
Jiri Horky

--------------040701010204040701070801
Content-Type: text/x-patch;
 name="reset_offset.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="reset_offset.patch"

diff -Nru fio-2.1.9/filesetup.c fio-2.1.9.patched/filesetup.c
--- fio-2.1.9/filesetup.c	2014-05-20 09:39:25.000000000 +0200
+++ fio-2.1.9.patched/filesetup.c	2014-05-23 13:22:31.069984999 +0200
@@ -750,7 +750,7 @@
 		return f->real_file_size;
 
 	return td->o.start_offset +
-		(td->thread_number - 1) * td->o.offset_increment;
+		(td->offset_thread_number - 1) * td->o.offset_increment;
 }
 
 /*
diff -Nru fio-2.1.9/fio.1 fio-2.1.9.patched/fio.1
--- fio-2.1.9/fio.1	2014-05-20 09:39:25.000000000 +0200
+++ fio-2.1.9.patched/fio.1	2014-05-23 13:40:02.154049921 +0200
@@ -647,10 +647,19 @@
 .TP
 .BI offset_increment \fR=\fPint
 If this is provided, then the real offset becomes the
-offset + offset_increment * thread_number, where the thread number is a counter
-that starts at 0 and is incremented for each job. This option is useful if
-there are several jobs which are intended to operate on a file in parallel in
-disjoint segments, with even spacing between the starting points.
+offset + offset_increment * offset_thread_number, where the offset thread number is a
+counter that starts at 0 and is incremented for each job unless reset_offset_increment
+is specified. This option is useful if there are several jobs which are intended to
+operate  on a file in parallel in disjoint segments, with even spacing between the 
+starting points.
+.TP
+.BI reset_offset_increment \fR=\fPbool
+By default, fio uses global thread numbers when computing offset with offset_increment.
+This may be often confusing as different jobs/threads may operate on different files
+but still share the same offset_increment. This option resets the offset_thread_number
+to 0. If your jobs operate on different files, use this option for every file
+to get offset_increment-per-file behavior. If you use subjobs (numbjobs=X), the 
+reset will be done only once before the first subjob starts.
 .TP
 .BI number_ios \fR=\fPint
 Fio will normally perform IOs until it has exhausted the size of the region
diff -Nru fio-2.1.9/fio.h fio-2.1.9.patched/fio.h
--- fio-2.1.9/fio.h	2014-05-20 09:39:07.000000000 +0200
+++ fio-2.1.9.patched/fio.h	2014-05-23 12:57:43.263971178 +0200
@@ -101,6 +101,7 @@
 	char verror[FIO_VERROR_SIZE];
 	pthread_t thread;
 	unsigned int thread_number;
+	unsigned int offset_thread_number;
 	unsigned int groupid;
 	struct thread_stat ts;
 
diff -Nru fio-2.1.9/init.c fio-2.1.9.patched/init.c
--- fio-2.1.9/init.c	2014-05-20 09:39:07.000000000 +0200
+++ fio-2.1.9.patched/init.c	2014-05-23 13:26:00.969989815 +0200
@@ -43,6 +43,7 @@
 
 static struct thread_data def_thread;
 struct thread_data *threads = NULL;
+static int offset_thread_number = 0;
 static char **job_sections;
 static int nr_job_sections;
 
@@ -1116,6 +1117,11 @@
 		groupid++;
 	}
 
+	if (o->reset_offset_increment) {
+		offset_thread_number = 0;
+	}
+
+	td->offset_thread_number = ++offset_thread_number;
 	td->groupid = groupid;
 	prev_group_jobs++;
 
@@ -1198,6 +1204,7 @@
 		td_new->o.numjobs = 1;
 		td_new->o.stonewall = 0;
 		td_new->o.new_group = 0;
+		td_new->o.reset_offset_increment = 0;
 
 		if (file_alloced) {
 			if (td_new->files) {
diff -Nru fio-2.1.9/options.c fio-2.1.9.patched/options.c
--- fio-2.1.9/options.c	2014-05-20 09:39:25.000000000 +0200
+++ fio-2.1.9.patched/options.c	2014-05-23 13:00:24.929232053 +0200
@@ -1669,6 +1669,18 @@
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
+		.name	= "reset_offset_increment",
+		.lname	= "Reset offset increment counter",
+		.type	= FIO_OPT_STR_VAL,
+		.off1	= td_var_offset(reset_offset_increment),
+		.help	= "Resets increment counter to 0",
+		.parent = "offset",
+		.hide	= 1,
+		.def	= "0",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= "number_ios",
 		.lname	= "Number of IOs to perform",
 		.type	= FIO_OPT_STR_VAL,
diff -Nru fio-2.1.9/thread_options.h fio-2.1.9.patched/thread_options.h
--- fio-2.1.9/thread_options.h	2014-05-20 09:39:07.000000000 +0200
+++ fio-2.1.9.patched/thread_options.h	2014-05-23 12:58:38.012721048 +0200
@@ -247,6 +247,7 @@
 	unsigned int flow_sleep;
 
 	unsigned long long offset_increment;
+	unsigned int reset_offset_increment;
 	unsigned long long number_ios;
 
 	unsigned int sync_file_range;

--------------040701010204040701070801--
