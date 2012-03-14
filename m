Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:33795 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab2CNXT3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 14 Mar 2012 19:19:29 -0400
Received: by faaa19 with SMTP id a19so101080faa.1
        for <fio@vger.kernel.org>; Wed, 14 Mar 2012 16:19:28 -0700 (PDT)
From: Dan Ehrenberg <dehrenberg@google.com>
Subject: [PATCH] New offset_increment option
Date: Wed, 14 Mar 2012 16:19:23 -0700
Message-Id: <1331767163-26042-1-git-send-email-dehrenberg@google.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: egouriou@google.com, nauman@google.com, tirea@google.com, Dan Ehrenberg <dehrenberg@google.com>

This patch adds a new option to fio job files. It is described
in the HOWTO as follows:

offset_increment=int	If this is provided, then the real offset becomes
		the offset + offset_increment * thread_number, where the
		thread number is a counter that starts at 0 and is incremented
		for each job. This option is useful if there are several jobs
		which are intended to operate on a file in parallel in disjoint
		segments, with even spacing between the starting points.
---
 HOWTO       |    7 +++++++
 filesetup.c |    3 ++-
 fio.h       |    2 ++
 ioengines.c |    1 +
 options.c   |    7 +++++++
 5 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/HOWTO b/HOWTO
index 0a3351c..30e4059 100644
--- a/HOWTO
+++ b/HOWTO
@@ -636,6 +636,13 @@ offset=int	Start io at the given offset in the file. The data before
 		the given offset will not be touched. This effectively
 		caps the file size at real_size - offset.
 
+offset_increment=int	If this is provided, then the real offset becomes
+		the offset + offset_increment * thread_number, where the
+		thread number is a counter that starts at 0 and is incremented
+		for each job. This option is useful if there are several jobs
+		which are intended to operate on a file in parallel in disjoint
+		segments, with even spacing between the starting points.
+
 fsync=int	If writing to a file, issue a sync of the dirty data
 		for every number of blocks given. For example, if you give
 		32 as a parameter, fio will sync the file for every 32
diff --git a/filesetup.c b/filesetup.c
index 446eeaf..9acce64 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -713,7 +713,8 @@ int setup_files(struct thread_data *td)
 	extend_size = total_size = 0;
 	need_extend = 0;
 	for_each_file(td, f, i) {
-		f->file_offset = td->o.start_offset;
+		f->file_offset = td->o.start_offset +
+			td->thread_number * td->o.offset_increment;
 
 		if (!td->o.file_size_low) {
 			/*
diff --git a/fio.h b/fio.h
index 4afdd2d..f59265a 100644
--- a/fio.h
+++ b/fio.h
@@ -266,6 +266,8 @@ struct thread_options {
 	int flow_watermark;
 	unsigned int flow_sleep;
 
+	unsigned long long offset_increment;
+
 	unsigned int sync_file_range;
 };
 
diff --git a/ioengines.c b/ioengines.c
index 4c609f2..1a0898d 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -278,6 +278,7 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 	 */
 	if (io_u->error == EINVAL && td->io_issues[io_u->ddir & 1] == 1 &&
 	    td->o.odirect) {
+
 		log_info("fio: first direct IO errored. File system may not "
 			 "support direct IO, or iomem_align= is bad.\n");
 	}
diff --git a/options.c b/options.c
index 463b66d..e0f6422 100644
--- a/options.c
+++ b/options.c
@@ -2216,6 +2216,13 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		.def	= "0",
 	},
 	{
+		.name	= "offset_increment",
+		.type	= FIO_OPT_STR_VAL,
+		.off1	= td_var_offset(offset_increment),
+		.help	= "What is the increment from one offset to the next",
+		.def	= "0",
+	},
+	{
 		.name = NULL,
 	},
 };
-- 
1.7.7.3

