Return-Path: <tkusumi@tuxera.com>
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: [PATCH 1/6] Rename thread_options' ->io_limit to io_size
Date: Sun, 19 Feb 2017 20:22:18 +0200
Message-ID: <20170219182223.120559-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

This is less confusing since io_size is the option name itself,
and not much reason to use io_limit which is an alias of io_size.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 backend.c        | 14 +++++++-------
 cconv.c          |  4 ++--
 filesetup.c      |  4 ++--
 options.c        |  2 +-
 thread_options.h |  4 ++--
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/backend.c b/backend.c
index 1c1f2f9..4bc00e6 100644
--- a/backend.c
+++ b/backend.c
@@ -776,8 +776,8 @@ static bool io_bytes_exceeded(struct thread_data *td, uint64_t *this_bytes)
 	else
 		bytes = this_bytes[DDIR_TRIM];
 
-	if (td->o.io_limit)
-		limit = td->o.io_limit;
+	if (td->o.io_size)
+		limit = td->o.io_size;
 	else
 		limit = td->o.size;
 
@@ -851,11 +851,11 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 
 	total_bytes = td->o.size;
 	/*
-	* Allow random overwrite workloads to write up to io_limit
+	* Allow random overwrite workloads to write up to io_size
 	* before starting verification phase as 'size' doesn't apply.
 	*/
 	if (td_write(td) && td_random(td) && td->o.norandommap)
-		total_bytes = max(total_bytes, (uint64_t) td->o.io_limit);
+		total_bytes = max(total_bytes, (uint64_t) td->o.io_size);
 	/*
 	 * If verify_backlog is enabled, we'll run the verify in this
 	 * handler as well. For that case, we may need up to twice the
@@ -1355,8 +1355,8 @@ static bool keep_running(struct thread_data *td)
 	if (exceeds_number_ios(td))
 		return false;
 
-	if (td->o.io_limit)
-		limit = td->o.io_limit;
+	if (td->o.io_size)
+		limit = td->o.io_size;
 	else
 		limit = td->o.size;
 
@@ -1371,7 +1371,7 @@ static bool keep_running(struct thread_data *td)
 		if (diff < td_max_bs(td))
 			return false;
 
-		if (fio_files_done(td) && !td->o.io_limit)
+		if (fio_files_done(td) && !td->o.io_size)
 			return false;
 
 		return true;
diff --git a/cconv.c b/cconv.c
index 0c11629..b329bf4 100644
--- a/cconv.c
+++ b/cconv.c
@@ -97,7 +97,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->iodepth_batch_complete_min = le32_to_cpu(top->iodepth_batch_complete_min);
 	o->iodepth_batch_complete_max = le32_to_cpu(top->iodepth_batch_complete_max);
 	o->size = le64_to_cpu(top->size);
-	o->io_limit = le64_to_cpu(top->io_limit);
+	o->io_size = le64_to_cpu(top->io_size);
 	o->size_percent = le32_to_cpu(top->size_percent);
 	o->fill_device = le32_to_cpu(top->fill_device);
 	o->file_append = le32_to_cpu(top->file_append);
@@ -521,7 +521,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	memcpy(top->buffer_pattern, o->buffer_pattern, MAX_PATTERN_SIZE);
 
 	top->size = __cpu_to_le64(o->size);
-	top->io_limit = __cpu_to_le64(o->io_limit);
+	top->io_size = __cpu_to_le64(o->io_size);
 	top->verify_backlog = __cpu_to_le64(o->verify_backlog);
 	top->start_delay = __cpu_to_le64(o->start_delay);
 	top->start_delay_high = __cpu_to_le64(o->start_delay_high);
diff --git a/filesetup.c b/filesetup.c
index e2585ee..74551a4 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -993,8 +993,8 @@ int setup_files(struct thread_data *td)
 	 * stored entries.
 	 */
 	if (!o->read_iolog_file) {
-		if (o->io_limit)
-			td->total_io_size = o->io_limit * o->loops;
+		if (o->io_size)
+			td->total_io_size = o->io_size * o->loops;
 		else
 			td->total_io_size = o->size * o->loops;
 	}
diff --git a/options.c b/options.c
index 1fa99b6..10a6e01 100644
--- a/options.c
+++ b/options.c
@@ -1882,7 +1882,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.alias	= "io_limit",
 		.lname	= "IO Size",
 		.type	= FIO_OPT_STR_VAL,
-		.off1	= offsetof(struct thread_options, io_limit),
+		.off1	= offsetof(struct thread_options, io_size),
 		.help	= "Total size of I/O to be performed",
 		.interval = 1024 * 1024,
 		.category = FIO_OPT_C_IO,
diff --git a/thread_options.h b/thread_options.h
index dd5b9ef..5e72867 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -68,7 +68,7 @@ struct thread_options {
 	unsigned int unique_filename;
 
 	unsigned long long size;
-	unsigned long long io_limit;
+	unsigned long long io_size;
 	unsigned int size_percent;
 	unsigned int fill_device;
 	unsigned int file_append;
@@ -338,7 +338,7 @@ struct thread_options_pack {
 	uint32_t __proper_alignment_for_64b;
 
 	uint64_t size;
-	uint64_t io_limit;
+	uint64_t io_size;
 	uint32_t size_percent;
 	uint32_t fill_device;
 	uint32_t file_append;
-- 
2.9.3


