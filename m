Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgHKTos (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Aug 2020 15:44:48 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2FBC06174A
        for <fio@vger.kernel.org>; Tue, 11 Aug 2020 12:44:48 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id q4so9945894edv.13
        for <fio@vger.kernel.org>; Tue, 11 Aug 2020 12:44:48 -0700 (PDT)
Received: from localhost (ip-86-49-81-166.net.upcbroadband.cz. [86.49.81.166])
        by smtp.gmail.com with ESMTPSA id p21sm15160971edr.59.2020.08.11.12.44.45
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 12:44:46 -0700 (PDT)
Date: Tue, 11 Aug 2020 21:44:45 +0200
From: Martin Bukatovic <martin.bukatovic@gmail.com>
Subject: [PATCH] Add fill_quota option
Message-ID: <20200811194445.GA152146@dione.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Option fill_quota causes fio to write until EDQUOT occurs (assuming rw=write),
in the same way as fill_device option makes fio to write until ENOSPC.

Signed-off-by: Martin Bukatovic <martin.bukatovic@gmail.com>
---
 HOWTO            |  9 +++++++++
 backend.c        |  9 ++++++---
 cconv.c          |  2 ++
 eta.c            |  2 +-
 filesetup.c      | 17 +++++++++++------
 fio.1            |  8 ++++++++
 init.c           |  2 +-
 options.c        | 10 ++++++++++
 thread_options.h |  4 ++++
 9 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/HOWTO b/HOWTO
index e0403b08..4d0be15f 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1810,6 +1810,15 @@ I/O size
 	device node, since the size of that is already known by the file system.
 	Additionally, writing beyond end-of-device will not return ENOSPC there.
 
+.. option:: fill_quota=bool
+
+	Sets size to something really large and waits for EDQUOT (disk quota
+	exceeded) as the terminating condition. It is done in the same way as
+	:option:`fill_device` handles ENOSPC, so that the same assumptions and
+	limitations apply. If both options :option:`fill_device` and
+	:option:`fill_quota` are specified at the same time, fio will terminate
+	when either entire free space or quota is used, whichever comes first.
+
 
 I/O engine
 ~~~~~~~~~~
diff --git a/backend.c b/backend.c
index 0e454cdd..c61ed9b2 100644
--- a/backend.c
+++ b/backend.c
@@ -394,7 +394,8 @@ static bool break_on_this_error(struct thread_data *td, enum fio_ddir ddir,
 			td_clear_error(td);
 			*retptr = 0;
 			return false;
-		} else if (td->o.fill_device && err == ENOSPC) {
+		} else if ((td->o.fill_device && err == ENOSPC) ||
+		           (td->o.fill_quota && err == EDQUOT)) {
 			/*
 			 * We expect to hit this error if
 			 * fill_device option is set.
@@ -1101,7 +1102,8 @@ reap:
 	if (td->trim_entries)
 		log_err("fio: %lu trim entries leaked?\n", td->trim_entries);
 
-	if (td->o.fill_device && td->error == ENOSPC) {
+	if ((td->o.fill_device && td->error == ENOSPC) ||
+	    (td->o.fill_quota && td->error == EDQUOT)) {
 		td->error = 0;
 		fio_mark_td_terminate(td);
 	}
@@ -1116,7 +1118,8 @@ reap:
 
 		if (i) {
 			ret = io_u_queued_complete(td, i);
-			if (td->o.fill_device && td->error == ENOSPC)
+			if ((td->o.fill_device && td->error == ENOSPC) ||
+			    (td->o.fill_quota && td->error == EDQUOT))
 				td->error = 0;
 		}
 
diff --git a/cconv.c b/cconv.c
index 2469389b..8b148625 100644
--- a/cconv.c
+++ b/cconv.c
@@ -103,6 +103,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->io_size = le64_to_cpu(top->io_size);
 	o->size_percent = le32_to_cpu(top->size_percent);
 	o->fill_device = le32_to_cpu(top->fill_device);
+	o->fill_quota = le32_to_cpu(top->fill_quota);
 	o->file_append = le32_to_cpu(top->file_append);
 	o->file_size_low = le64_to_cpu(top->file_size_low);
 	o->file_size_high = le64_to_cpu(top->file_size_high);
@@ -369,6 +370,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->serialize_overlap = cpu_to_le32(o->serialize_overlap);
 	top->size_percent = cpu_to_le32(o->size_percent);
 	top->fill_device = cpu_to_le32(o->fill_device);
+	top->fill_quota = cpu_to_le32(o->fill_quota);
 	top->file_append = cpu_to_le32(o->file_append);
 	top->ratecycle = cpu_to_le32(o->ratecycle);
 	top->io_submit_mode = cpu_to_le32(o->io_submit_mode);
diff --git a/eta.c b/eta.c
index 13f61ba4..6c250348 100644
--- a/eta.c
+++ b/eta.c
@@ -170,7 +170,7 @@ static unsigned long thread_eta(struct thread_data *td)
 	if (td->flags & TD_F_NO_PROGRESS)
 		return -1;
 
-	if (td->o.fill_device && td->o.size  == -1ULL) {
+	if ((td->o.fill_device || td->o.fill_quota) && td->o.size  == -1ULL) {
 		if (!td->fill_device_size || td->fill_device_size == -1ULL)
 			return 0;
 
diff --git a/filesetup.c b/filesetup.c
index 49c54b81..90623188 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -57,7 +57,7 @@ static int native_fallocate(struct thread_data *td, struct fio_file *f)
 
 static void fallocate_file(struct thread_data *td, struct fio_file *f)
 {
-	if (td->o.fill_device)
+	if (td->o.fill_device || td->o.fill_quota)
 		return;
 
 	switch (td->o.fallocate_mode) {
@@ -187,7 +187,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 	 * The size will be -1ULL when fill_device is used, so don't truncate
 	 * or fallocate this file, just write it
 	 */
-	if (!td->o.fill_device) {
+	if (!td->o.fill_device && !td->o.fill_quota) {
 		dprint(FD_FILE, "truncate file %s, size %llu\n", f->file_name,
 					(unsigned long long) f->real_file_size);
 		if (ftruncate(f->fd, f->real_file_size) == -1) {
@@ -233,6 +233,10 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 						 "file, stopping\n");
 					break;
 				}
+				if (__e == EDQUOT) {
+					if (td->o.fill_quota)
+						break;
+				}
 				td_verror(td, errno, "write");
 			} else
 				td_verror(td, EIO, "write");
@@ -250,7 +254,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 			goto err;
 		}
 	}
-	if (td->o.fill_device && !td_write(td)) {
+	if ((td->o.fill_device || td->o.fill_quota) && !td_write(td)) {
 		fio_file_clear_size_known(f);
 		if (td_io_get_file_size(td, f))
 			goto err;
@@ -1044,14 +1048,15 @@ int setup_files(struct thread_data *td)
 			total_size += f->real_file_size;
 	}
 
-	if (o->fill_device)
+	if (o->fill_device || o->fill_quota)
 		td->fill_device_size = get_fs_free_counts(td);
 
 	/*
 	 * device/file sizes are zero and no size given, punt
 	 */
 	if ((!total_size || total_size == -1ULL) && !o->size &&
-	    !td_ioengine_flagged(td, FIO_NOIO) && !o->fill_device &&
+	    !td_ioengine_flagged(td, FIO_NOIO) &&
+	    !o->fill_device && !o->fill_quota &&
 	    !(o->nr_files && (o->file_size_low || o->file_size_high))) {
 		log_err("%s: you need to specify size=\n", o->name);
 		td_verror(td, EINVAL, "total_file_size");
@@ -1221,7 +1226,7 @@ int setup_files(struct thread_data *td)
 
 			assert(f->filetype == FIO_TYPE_FILE);
 			fio_file_clear_extend(f);
-			if (!o->fill_device) {
+			if (!o->fill_device && !o->fill_quota) {
 				old_len = f->real_file_size;
 				extend_len = f->io_size + f->file_offset -
 						old_len;
diff --git a/fio.1 b/fio.1
index cdd105d7..b1ddf58c 100644
--- a/fio.1
+++ b/fio.1
@@ -1583,6 +1583,14 @@ write. For a read workload, the mount point will be filled first then I/O
 started on the result. This option doesn't make sense if operating on a raw
 device node, since the size of that is already known by the file system.
 Additionally, writing beyond end-of-device will not return ENOSPC there.
+.TP
+.BI fill_quota \fR=\fPbool
+Sets size to something really large and waits for EDQUOT (disk quota exceeded)
+as the terminating condition. It is done in the same way as fill_device option
+handles ENOSPC, so that the same assumptions and limitations apply. If both
+options fill_device and fill_quota are specified at the same time, fio will
+terminate when either entire free space or quota is used, whichever comes
+first.
 .SS "I/O engine"
 .TP
 .BI ioengine \fR=\fPstr
diff --git a/init.c b/init.c
index 84325f1e..cadaf689 100644
--- a/init.c
+++ b/init.c
@@ -781,7 +781,7 @@ static int fixup_options(struct thread_data *td)
 		ret |= warnings_fatal;
 	}
 
-	if (o->fill_device && !o->size)
+	if ((o->fill_device || o->fill_quota) && !o->size)
 		o->size = -1ULL;
 
 	if (o->verify != VERIFY_NONE) {
diff --git a/options.c b/options.c
index 251ad2c1..6f2356e0 100644
--- a/options.c
+++ b/options.c
@@ -2060,6 +2060,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "fill_quota",
+		.lname	= "Fill quota",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, fill_quota),
+		.help	= "Write until an EDQUOT error occurs",
+		.def	= "0",
+		.category = FIO_OPT_C_FILE,
+		.group	= FIO_OPT_G_INVALID,
+	},
 	{
 		.name	= "filesize",
 		.lname	= "File size",
diff --git a/thread_options.h b/thread_options.h
index 3fe48ecc..493d6beb 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -347,6 +347,8 @@ struct thread_options {
 	unsigned int job_max_open_zones;
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
+
+	unsigned int fill_quota;
 };
 
 #define FIO_TOP_STR_MAX		256
@@ -633,6 +635,8 @@ struct thread_options_pack {
 	uint32_t allow_mounted_write;
 
 	uint32_t zone_mode;
+
+	uint32_t fill_quota;
 } __attribute__((packed));
 
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
-- 
2.26.2

