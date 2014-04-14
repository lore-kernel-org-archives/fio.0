Return-Path: <axboe@kernel.dk>
Message-ID: <534C40D7.3060406@kernel.dk>
Date: Mon, 14 Apr 2014 14:11:03 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Writing an amount of data less than capacity at random to offsets
 from whole address range
References: <534BD74E.1080205@informatik.uni-rostock.de>
In-Reply-To: <534BD74E.1080205@informatik.uni-rostock.de>
Content-Type: multipart/mixed;
 boundary="------------050202080808020305000407"
To: Nikolaus Jeremic <jeremic@informatik.uni-rostock.de>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050202080808020305000407
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 04/14/2014 06:40 AM, Nikolaus Jeremic wrote:
> Hello,
>
> how can I nudge fio to write a certain amount of data (less than
> capacity of block device) to randomly generated offsets covering the
> whole address space of a block device (e.g. MD RAID device)?
>
> Using the size parameter yields offsets from 0 to size (thus, not
> covering the whole address range). Using a time based job leads to the
> desired result, but I would like two write a defined amount of data. I
> have already tried this with fio 2.0.14, 2.1.6.1, 2.1.17, and 2.1.18
> without success. I am using Gentoo Linux with kernel 3.13.6 and libaio
> 0.3.109. The job description looks as follows:

Fio doesn't currently support that. Can you try the attached? It adds an 
option to separately define an io limit, io_limit. If io_limit is not 
set, size= behaves as it did before: if you don't give a size, size is 
defined by the files added. With this patch, if you do

filename=/dev/md9
size=40g

fio would read 40g between 0..40G

If you do:

filename=/dev/md9

fio would access the entire device.

If you do:

filename=/dev/md9
io_limit=10g

fio would access the entire device, quit when 10G of IO was done. Etc.

-- 
Jens Axboe


--------------050202080808020305000407
Content-Type: text/x-patch;
 name="fio-io-limit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fio-io-limit.patch"

diff --git a/backend.c b/backend.c
index 62bca29194ed..47c4d32e8862 100644
--- a/backend.c
+++ b/backend.c
@@ -641,7 +641,7 @@ static unsigned int exceeds_number_ios(struct thread_data *td)
 
 static int io_bytes_exceeded(struct thread_data *td)
 {
-	unsigned long long bytes;
+	unsigned long long bytes, limit;
 
 	if (td_rw(td))
 		bytes = td->this_io_bytes[DDIR_READ] + td->this_io_bytes[DDIR_WRITE];
@@ -652,7 +652,12 @@ static int io_bytes_exceeded(struct thread_data *td)
 	else
 		bytes = td->this_io_bytes[DDIR_TRIM];
 
-	return bytes >= td->o.size || exceeds_number_ios(td);
+	if (td->o.io_limit)
+		limit = td->o.io_limit;
+	else
+		limit = td->o.size;
+
+	return bytes >= limit || exceeds_number_ios(td);
 }
 
 /*
@@ -1137,6 +1142,8 @@ static int switch_ioscheduler(struct thread_data *td)
 
 static int keep_running(struct thread_data *td)
 {
+	unsigned long long limit;
+
 	if (td->done)
 		return 0;
 	if (td->o.time_based)
@@ -1148,14 +1155,19 @@ static int keep_running(struct thread_data *td)
 	if (exceeds_number_ios(td))
 		return 0;
 
-	if (td->o.size != -1ULL && ddir_rw_sum(td->io_bytes) < td->o.size) {
+	if (td->o.io_limit)
+		limit = td->o.io_limit;
+	else
+		limit = td->o.size;
+
+	if (limit != -1ULL && ddir_rw_sum(td->io_bytes) < limit) {
 		uint64_t diff;
 
 		/*
 		 * If the difference is less than the minimum IO size, we
 		 * are done.
 		 */
-		diff = td->o.size - ddir_rw_sum(td->io_bytes);
+		diff = limit - ddir_rw_sum(td->io_bytes);
 		if (diff < td_max_bs(td))
 			return 0;
 
diff --git a/cconv.c b/cconv.c
index 5b9c3be2590c..a87f431c8c92 100644
--- a/cconv.c
+++ b/cconv.c
@@ -77,6 +77,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->iodepth_batch = le32_to_cpu(top->iodepth_batch);
 	o->iodepth_batch_complete = le32_to_cpu(top->iodepth_batch_complete);
 	o->size = le64_to_cpu(top->size);
+	o->io_limit = le64_to_cpu(top->io_limit);
 	o->size_percent = le32_to_cpu(top->size_percent);
 	o->fill_device = le32_to_cpu(top->fill_device);
 	o->file_append = le32_to_cpu(top->file_append);
@@ -425,6 +426,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	memcpy(top->buffer_pattern, o->buffer_pattern, MAX_PATTERN_SIZE);
 
 	top->size = __cpu_to_le64(o->size);
+	top->io_limit = __cpu_to_le64(o->io_limit);
 	top->verify_backlog = __cpu_to_le64(o->verify_backlog);
 	top->start_delay = __cpu_to_le64(o->start_delay);
 	top->start_delay_high = __cpu_to_le64(o->start_delay_high);
diff --git a/filesetup.c b/filesetup.c
index 490f0fc2101b..b614dbacabaa 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -939,8 +939,12 @@ int setup_files(struct thread_data *td)
 	 * iolog already set the total io size, if we read back
 	 * stored entries.
 	 */
-	if (!o->read_iolog_file)
-		td->total_io_size = o->size * o->loops;
+	if (!o->read_iolog_file) {
+		if (o->io_limit)
+			td->total_io_size = o->io_limit * o->loops;
+		else
+			td->total_io_size = o->size * o->loops;
+	}
 
 done:
 	if (o->create_only)
diff --git a/options.c b/options.c
index 50af7b499f4b..163c5fc92985 100644
--- a/options.c
+++ b/options.c
@@ -1595,6 +1595,15 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
+		.name	= "io_limit",
+		.lname	= "IO Limit",
+		.type	= FIO_OPT_STR_VAL,
+		.off1	= td_var_offset(io_limit),
+		.interval = 1024 * 1024,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= "fill_device",
 		.lname	= "Fill device",
 		.alias	= "fill_fs",
diff --git a/server.h b/server.h
index 2958e7306c3e..4f09f2848b93 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 33,
+	FIO_SERVER_VER			= 34,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 46421205cdf9..41b6e54e7372 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -52,6 +52,7 @@ struct thread_options {
 	unsigned int iodepth_batch_complete;
 
 	unsigned long long size;
+	unsigned long long io_limit;
 	unsigned int size_percent;
 	unsigned int fill_device;
 	unsigned int file_append;
@@ -280,6 +281,7 @@ struct thread_options_pack {
 	uint32_t iodepth_batch_complete;
 
 	uint64_t size;
+	uint64_t io_limit;
 	uint32_t size_percent;
 	uint32_t fill_device;
 	uint32_t file_append;

--------------050202080808020305000407--

