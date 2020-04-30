Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 6/7] fio: parse "io_size=1%"
Date: Thu, 30 Apr 2020 15:40:49 +0300
Message-Id: <20200430124050.20146-6-adobriyan@gmail.com>
In-Reply-To: <20200430124050.20146-1-adobriyan@gmail.com>
References: <20200430124050.20146-1-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: axboe@kernel.dk
Cc: adobriyan@gmail.com, damien.lemoal@wdc.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

The following config:

	zonemode=zbd
	size=1%
	io_size=1%

will generate essentially infinite loop, because io_size is (2^64-1)-1.

Parse io_size as percentage to avoid it.

Note: there is different bug if size% != io_size% and io_size is ignored
but it will be separate patch.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---
 cconv.c          |  1 +
 options.c        | 17 +++++++++++++++++
 thread_options.h |  4 ++++
 3 files changed, 22 insertions(+)

diff --git a/cconv.c b/cconv.c
index 48218dc4..d547ae11 100644
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
diff --git a/options.c b/options.c
index 306874ea..c5d33d1a 100644
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
diff --git a/thread_options.h b/thread_options.h
index 4078d46f..197d2ec2 100644
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


