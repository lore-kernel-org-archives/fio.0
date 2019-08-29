Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57780 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfH2MAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Aug 2019 08:00:16 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i3J67-0002AM-8c
        for fio@vger.kernel.org; Thu, 29 Aug 2019 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190829120002.31A162C028B@kernel.dk>
Date: Thu, 29 Aug 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4e8c82b4e9804c52bf2c78327cc5bfca9d8aedfc:

  nbd: Update for libnbd 0.9.8 (2019-08-15 10:42:01 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0b288ba164c10009ea9f4a2c737bd29863ebc60c:

  options: allow offset_increment to understand percentages (2019-08-28 13:45:37 -0600)

----------------------------------------------------------------
Vincent Fu (2):
      docs: small HOWTO fixes
      options: allow offset_increment to understand percentages

 HOWTO            | 12 ++++++++++--
 cconv.c          |  2 ++
 filesetup.c      | 32 ++++++++++++++++++++++----------
 fio.1            |  4 +++-
 options.c        | 17 +++++++++++++++++
 server.h         |  2 +-
 thread_options.h |  3 +++
 7 files changed, 58 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 41b959d1..4201e2e9 100644
--- a/HOWTO
+++ b/HOWTO
@@ -93,6 +93,12 @@ Command line options
 			Dump info related to I/O rate switching.
 	*compress*
 			Dump info related to log compress/decompress.
+	*steadystate*
+			Dump info related to steadystate detection.
+	*helperthread*
+			Dump info related to the helper thread.
+	*zbd*
+			Dump info related to support for zoned block devices.
 	*?* or *help*
 			Show available debug options.
 
@@ -1246,7 +1252,9 @@ I/O type
 	is incremented for each sub-job (i.e. when :option:`numjobs` option is
 	specified). This option is useful if there are several jobs which are
 	intended to operate on a file in parallel disjoint segments, with even
-	spacing between the starting points.
+	spacing between the starting points. Percentages can be used for this option.
+	If a percentage is given, the generated offset will be aligned to the minimum
+	``blocksize`` or to the value of ``offset_align`` if provided.
 
 .. option:: number_ios=int
 
@@ -2388,7 +2396,7 @@ I/O depth
 	this option can reduce both performance and the :option:`iodepth` achieved.
 
 	This option only applies to I/Os issued for a single job except when it is
-	enabled along with :option:`io_submit_mode`=offload. In offload mode, fio
+	enabled along with :option:`io_submit_mode`\=offload. In offload mode, fio
 	will check for overlap among all I/Os submitted by offload jobs with :option:`serialize_overlap`
 	enabled.
 
diff --git a/cconv.c b/cconv.c
index 0e657246..bff5e34f 100644
--- a/cconv.c
+++ b/cconv.c
@@ -226,6 +226,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->zone_skip = le64_to_cpu(top->zone_skip);
 	o->zone_mode = le32_to_cpu(top->zone_mode);
 	o->lockmem = le64_to_cpu(top->lockmem);
+	o->offset_increment_percent = le32_to_cpu(top->offset_increment_percent);
 	o->offset_increment = le64_to_cpu(top->offset_increment);
 	o->number_ios = le64_to_cpu(top->number_ios);
 
@@ -566,6 +567,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->start_offset_align = __cpu_to_le64(o->start_offset_align);
 	top->start_offset_percent = __cpu_to_le32(o->start_offset_percent);
 	top->trim_backlog = __cpu_to_le64(o->trim_backlog);
+	top->offset_increment_percent = __cpu_to_le32(o->offset_increment_percent);
 	top->offset_increment = __cpu_to_le64(o->offset_increment);
 	top->number_ios = __cpu_to_le64(o->number_ios);
 	top->rate_process = cpu_to_le32(o->rate_process);
diff --git a/filesetup.c b/filesetup.c
index 57eca1bf..7904d187 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -852,16 +852,37 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 
 uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
 {
+	bool align = false;
 	struct thread_options *o = &td->o;
 	unsigned long long align_bs;
 	unsigned long long offset;
+	unsigned long long increment;
 
 	if (o->file_append && f->filetype == FIO_TYPE_FILE)
 		return f->real_file_size;
 
+	if (o->offset_increment_percent) {
+		assert(!o->offset_increment);
+		increment = o->offset_increment_percent * f->real_file_size / 100;
+		align = true;
+	} else
+		increment = o->offset_increment;
+
 	if (o->start_offset_percent > 0) {
+		/* calculate the raw offset */
+		offset = (f->real_file_size * o->start_offset_percent / 100) +
+			(td->subjob_number * increment);
+
+		align = true;
+	} else {
+		/* start_offset_percent not set */
+		offset = o->start_offset +
+				td->subjob_number * increment;
+	}
+
+	if (align) {
 		/*
-		 * if offset_align is provided, set initial offset
+		 * if offset_align is provided, use it
 		 */
 		if (fio_option_is_set(o, start_offset_align)) {
 			align_bs = o->start_offset_align;
@@ -870,20 +891,11 @@ uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
 			align_bs = td_min_bs(td);
 		}
 
-		/* calculate the raw offset */
-		offset = (f->real_file_size * o->start_offset_percent / 100) +
-			(td->subjob_number * o->offset_increment);
-
 		/*
 		 * block align the offset at the next available boundary at
 		 * ceiling(offset / align_bs) * align_bs
 		 */
 		offset = (offset / align_bs + (offset % align_bs != 0)) * align_bs;
-
-	} else {
-		/* start_offset_percent not set */
-		offset = o->start_offset +
-				td->subjob_number * o->offset_increment;
 	}
 
 	return offset;
diff --git a/fio.1 b/fio.1
index 97371d77..a06a12da 100644
--- a/fio.1
+++ b/fio.1
@@ -1015,7 +1015,9 @@ If this is provided, then the real offset becomes `\fBoffset\fR + \fBoffset_incr
 is incremented for each sub\-job (i.e. when \fBnumjobs\fR option is
 specified). This option is useful if there are several jobs which are
 intended to operate on a file in parallel disjoint segments, with even
-spacing between the starting points.
+spacing between the starting points. Percentages can be used for this option.
+If a percentage is given, the generated offset will be aligned to the minimum
+\fBblocksize\fR or to the value of \fBoffset_align\fR if provided.
 .TP
 .BI number_ios \fR=\fPint
 Fio will normally perform I/Os until it has exhausted the size of the region
diff --git a/options.c b/options.c
index 447f231e..2c5bf5e0 100644
--- a/options.c
+++ b/options.c
@@ -1434,6 +1434,22 @@ static int str_offset_cb(void *data, unsigned long long *__val)
 	return 0;
 }
 
+static int str_offset_increment_cb(void *data, unsigned long long *__val)
+{
+	struct thread_data *td = cb_data_to_td(data);
+	unsigned long long v = *__val;
+
+	if (parse_is_percent(v)) {
+		td->o.offset_increment = 0;
+		td->o.offset_increment_percent = -1ULL - v;
+		dprint(FD_PARSE, "SET offset_increment_percent %d\n",
+					td->o.offset_increment_percent);
+	} else
+		td->o.offset_increment = v;
+
+	return 0;
+}
+
 static int str_size_cb(void *data, unsigned long long *__val)
 {
 	struct thread_data *td = cb_data_to_td(data);
@@ -2084,6 +2100,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "offset_increment",
 		.lname	= "IO offset increment",
 		.type	= FIO_OPT_STR_VAL,
+		.cb	= str_offset_increment_cb,
 		.off1	= offsetof(struct thread_options, offset_increment),
 		.help	= "What is the increment from one offset to the next",
 		.parent = "offset",
diff --git a/server.h b/server.h
index ac713252..de1d7f9b 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 79,
+	FIO_SERVER_VER			= 80,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 14c6969f..ee6e4d6d 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -313,6 +313,7 @@ struct thread_options {
 	int flow_watermark;
 	unsigned int flow_sleep;
 
+	unsigned int offset_increment_percent;
 	unsigned long long offset_increment;
 	unsigned long long number_ios;
 
@@ -599,6 +600,8 @@ struct thread_options_pack {
 	int32_t flow_watermark;
 	uint32_t flow_sleep;
 
+	uint32_t offset_increment_percent;
+	uint32_t pad4;
 	uint64_t offset_increment;
 	uint64_t number_ios;
 

