Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 7/9] fio: parse "io_size=1%"
Date: Tue,  5 May 2020 20:56:33 +0300
Message-Id: <20200505175634.2517-7-adobriyan@gmail.com>
In-Reply-To: <20200505175634.2517-1-adobriyan@gmail.com>
References: <20200505175634.2517-1-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, damien.lemoal@wdc.com, Alexey Dobriyan <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

The following config:

	size=1%
	io_size=1%

will generate essentially infinite loop, because io_size is set to (2^64-1)-1.

Parse io_size as percentage to avoid the bug.

Note: if size% != io_size%, io_size is ignored but it is separate bug.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---
 cconv.c          |  2 ++
 options.c        | 17 +++++++++++++++++
 server.h         |  2 +-
 thread_options.h |  4 ++++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/cconv.c b/cconv.c
index 48218dc4..48b0db9e 100644
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
@@ -366,6 +367,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->iodepth_batch_complete_max = cpu_to_le32(o->iodepth_batch_complete_max);
 	top->serialize_overlap = cpu_to_le32(o->serialize_overlap);
 	top->size_percent = cpu_to_le32(o->size_percent);
+	top->io_size_percent = cpu_to_le32(o->io_size_percent);
 	top->fill_device = cpu_to_le32(o->fill_device);
 	top->file_append = cpu_to_le32(o->file_append);
 	top->ratecycle = cpu_to_le32(o->ratecycle);
diff --git a/options.c b/options.c
index 47b3b765..3d0c3a84 100644
--- a/options.c
+++ b/options.c
@@ -1475,6 +1475,22 @@ static int str_size_cb(void *data, unsigned long long *__val)
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
@@ -2042,6 +2058,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.alias	= "io_limit",
 		.lname	= "IO Size",
 		.type	= FIO_OPT_STR_VAL,
+		.cb	= str_io_size_cb,
 		.off1	= offsetof(struct thread_options, io_size),
 		.help	= "Total size of I/O to be performed",
 		.interval = 1024 * 1024,
diff --git a/server.h b/server.h
index 279b6917..de01a5c8 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 82,
+	FIO_SERVER_VER			= 83,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index b0b493e4..4979ed79 100644
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
@@ -377,6 +378,7 @@ struct thread_options_pack {
 	uint64_t size;
 	uint64_t io_size;
 	uint32_t size_percent;
+	uint32_t io_size_percent;
 	uint32_t fill_device;
 	uint32_t file_append;
 	uint32_t unique_filename;
@@ -456,6 +458,8 @@ struct thread_options_pack {
 	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
 	uint32_t zone_split_nr[DDIR_RWDIR_CNT];
 
+	uint8_t pad1[4];
+
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
 	fio_fp64_t gauss_dev;
-- 
2.26.2


