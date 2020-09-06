Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728785AbgIFMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 6 Sep 2020 08:00:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1ABFC061573
        for <fio@vger.kernel.org>; Sun,  6 Sep 2020 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kEtL2-0006Mm-5P
        for fio@vger.kernel.org; Sun, 06 Sep 2020 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200906120001.8EEE71BC0121@kernel.dk>
Date: Sun,  6 Sep 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2dd96cc46fa83a73acc1c9238c3ac59203e10213:

  engines/io_uring: use the atomic load acquire instead of a barrier (2020-09-03 08:49:51 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8b38f40138047975ea7a59b9ce06681ffdd2c31d:

  fio: support io_size=N% (N <= 100) (2020-09-05 09:37:59 -0600)

----------------------------------------------------------------
Alexey Dobriyan (1):
      fio: support io_size=N% (N <= 100)

 cconv.c          |  2 ++
 filesetup.c      | 11 ++++++++++-
 options.c        | 17 +++++++++++++++++
 server.h         |  2 +-
 thread_options.h |  4 ++++
 5 files changed, 34 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/cconv.c b/cconv.c
index 5dc0569f..488dd799 100644
--- a/cconv.c
+++ b/cconv.c
@@ -102,6 +102,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->size = le64_to_cpu(top->size);
 	o->io_size = le64_to_cpu(top->io_size);
 	o->size_percent = le32_to_cpu(top->size_percent);
+	o->io_size_percent = le32_to_cpu(top->io_size_percent);
 	o->fill_device = le32_to_cpu(top->fill_device);
 	o->file_append = le32_to_cpu(top->file_append);
 	o->file_size_low = le64_to_cpu(top->file_size_low);
@@ -367,6 +368,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->iodepth_batch_complete_max = cpu_to_le32(o->iodepth_batch_complete_max);
 	top->serialize_overlap = cpu_to_le32(o->serialize_overlap);
 	top->size_percent = cpu_to_le32(o->size_percent);
+	top->io_size_percent = cpu_to_le32(o->io_size_percent);
 	top->fill_device = cpu_to_le32(o->fill_device);
 	top->file_append = cpu_to_le32(o->file_append);
 	top->ratecycle = cpu_to_le32(o->ratecycle);
diff --git a/filesetup.c b/filesetup.c
index d382fa24..e44f31c7 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1139,6 +1139,8 @@ int setup_files(struct thread_data *td)
 		if (f->io_size == -1ULL)
 			total_size = -1ULL;
 		else {
+			uint64_t io_size;
+
                         if (o->size_percent && o->size_percent != 100) {
 				uint64_t file_size;
 
@@ -1150,7 +1152,14 @@ int setup_files(struct thread_data *td)
 
 				f->io_size -= (f->io_size % td_min_bs(td));
 			}
-			total_size += f->io_size;
+
+			io_size = f->io_size;
+			if (o->io_size_percent && o->io_size_percent != 100) {
+				io_size *= o->io_size_percent;
+				io_size /= 100;
+			}
+
+			total_size += io_size;
 		}
 
 		if (f->filetype == FIO_TYPE_FILE &&
diff --git a/options.c b/options.c
index 0d64e7c0..e27bb9cb 100644
--- a/options.c
+++ b/options.c
@@ -1476,6 +1476,22 @@ static int str_size_cb(void *data, unsigned long long *__val)
 	return 0;
 }
 
+static int str_io_size_cb(void *data, unsigned long long *__val)
+{
+	struct thread_data *td = cb_data_to_td(data);
+	unsigned long long v = *__val;
+
+	if (parse_is_percent(v)) {
+		td->o.io_size = 0;
+		td->o.io_size_percent = -1ULL - v;
+		dprint(FD_PARSE, "SET io_size_percent %d\n",
+					td->o.io_size_percent);
+	} else
+		td->o.io_size = v;
+
+	return 0;
+}
+
 static int str_write_bw_log_cb(void *data, const char *str)
 {
 	struct thread_data *td = cb_data_to_td(data);
@@ -2043,6 +2059,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.alias	= "io_limit",
 		.lname	= "IO Size",
 		.type	= FIO_OPT_STR_VAL,
+		.cb	= str_io_size_cb,
 		.off1	= offsetof(struct thread_options, io_size),
 		.help	= "Total size of I/O to be performed",
 		.interval = 1024 * 1024,
diff --git a/server.h b/server.h
index 3cd60096..6d444749 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 85,
+	FIO_SERVER_VER			= 86,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 7c0a3158..97c400fe 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -83,6 +83,7 @@ struct thread_options {
 	unsigned long long size;
 	unsigned long long io_size;
 	unsigned int size_percent;
+	unsigned int io_size_percent;
 	unsigned int fill_device;
 	unsigned int file_append;
 	unsigned long long file_size_low;
@@ -381,6 +382,7 @@ struct thread_options_pack {
 	uint64_t size;
 	uint64_t io_size;
 	uint32_t size_percent;
+	uint32_t io_size_percent;
 	uint32_t fill_device;
 	uint32_t file_append;
 	uint32_t unique_filename;
@@ -460,6 +462,8 @@ struct thread_options_pack {
 	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
 	uint32_t zone_split_nr[DDIR_RWDIR_CNT];
 
+	uint8_t pad1[4];
+
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
 	fio_fp64_t gauss_dev;

