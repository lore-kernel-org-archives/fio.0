Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36158 "EHLO
        mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934303AbcJEWPj (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Oct 2016 18:15:39 -0400
Received: by mail-pa0-f51.google.com with SMTP id ry6so615495pac.3
        for <fio@vger.kernel.org>; Wed, 05 Oct 2016 15:15:39 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 3/4] iolog: make write_*_log prefix optional
Date: Wed,  5 Oct 2016 15:15:28 -0700
Message-Id: <4d98d58f53f40f7f5d731ce6a8d4af8e2e793a44.1475705698.git.osandov@fb.com>
In-Reply-To: <334c09f8e51802e0d751b485fe9e3538c430e9b3.1475705698.git.osandov@fb.com>
References: <334c09f8e51802e0d751b485fe9e3538c430e9b3.1475705698.git.osandov@fb.com>
In-Reply-To: <334c09f8e51802e0d751b485fe9e3538c430e9b3.1475705698.git.osandov@fb.com>
References: <334c09f8e51802e0d751b485fe9e3538c430e9b3.1475705698.git.osandov@fb.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

Providing write_bw_log=jobname for every job in a jobfile gets pretty
tedious. This way, we can just do, e.g.,

[global]
write_bw_log

and all jobs will be logged. The documentation seems to suggest that
this is the intended behavior, and it looks like that used to be the
case.

Fixes: 203160d52b86 ("options: get rid of more .cb option usage we don't need")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cconv.c          |  8 ++++++++
 init.c           | 24 ++++++++++++++----------
 options.c        | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 server.h         |  2 +-
 thread_options.h | 12 ++++++++++++
 5 files changed, 87 insertions(+), 15 deletions(-)

diff --git a/cconv.c b/cconv.c
index 194e342..6e0f609 100644
--- a/cconv.c
+++ b/cconv.c
@@ -280,6 +280,10 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->replay_align = le32_to_cpu(top->replay_align);
 	o->replay_scale = le32_to_cpu(top->replay_scale);
 	o->per_job_logs = le32_to_cpu(top->per_job_logs);
+	o->write_bw_log = le32_to_cpu(top->write_bw_log);
+	o->write_lat_log = le32_to_cpu(top->write_lat_log);
+	o->write_iops_log = le32_to_cpu(top->write_iops_log);
+	o->write_hist_log = le32_to_cpu(top->write_hist_log);
 
 	o->trim_backlog = le64_to_cpu(top->trim_backlog);
 	o->rate_process = le32_to_cpu(top->rate_process);
@@ -460,6 +464,10 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->replay_align = cpu_to_le32(o->replay_align);
 	top->replay_scale = cpu_to_le32(o->replay_scale);
 	top->per_job_logs = cpu_to_le32(o->per_job_logs);
+	top->write_bw_log = cpu_to_le32(o->write_bw_log);
+	top->write_lat_log = cpu_to_le32(o->write_lat_log);
+	top->write_iops_log = cpu_to_le32(o->write_iops_log);
+	top->write_hist_log = cpu_to_le32(o->write_hist_log);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		top->bs[i] = cpu_to_le32(o->bs[i]);
diff --git a/init.c b/init.c
index eb6f4a6..f041acd 100644
--- a/init.c
+++ b/init.c
@@ -1389,7 +1389,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if (setup_rate(td))
 		goto err;
 
-	if (o->lat_log_file) {
+	if (o->write_lat_log) {
 		struct log_params p = {
 			.td = td,
 			.avg_msec = o->log_avg_msec,
@@ -1400,6 +1400,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
+		const char *pre = o->lat_log_file ? o->lat_log_file : o->name;
 		const char *suf;
 
 		if (p.log_gz_store)
@@ -1407,20 +1408,20 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		else
 			suf = "log";
 
-		gen_log_name(logname, sizeof(logname), "lat", o->lat_log_file,
+		gen_log_name(logname, sizeof(logname), "lat", pre,
 				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->lat_log, &p, logname);
 
-		gen_log_name(logname, sizeof(logname), "slat", o->lat_log_file,
+		gen_log_name(logname, sizeof(logname), "slat", pre,
 				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->slat_log, &p, logname);
 
-		gen_log_name(logname, sizeof(logname), "clat", o->lat_log_file,
+		gen_log_name(logname, sizeof(logname), "clat", pre,
 				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->clat_log, &p, logname);
 	}
 
-	if (o->hist_log_file) {
+	if (o->write_hist_log) {
 		struct log_params p = {
 			.td = td,
 			.avg_msec = o->log_avg_msec,
@@ -1431,6 +1432,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
+		const char *pre = o->hist_log_file ? o->hist_log_file : o->name;
 		const char *suf;
 
 #ifndef CONFIG_ZLIB
@@ -1445,12 +1447,12 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		else
 			suf = "log";
 
-		gen_log_name(logname, sizeof(logname), "clat_hist", o->hist_log_file,
+		gen_log_name(logname, sizeof(logname), "clat_hist", pre,
 				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->clat_hist_log, &p, logname);
 	}
 
-	if (o->bw_log_file) {
+	if (o->write_bw_log) {
 		struct log_params p = {
 			.td = td,
 			.avg_msec = o->log_avg_msec,
@@ -1461,6 +1463,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
+		const char *pre = o->bw_log_file ? o->bw_log_file : o->name;
 		const char *suf;
 
 		if (fio_option_is_set(o, bw_avg_time))
@@ -1476,11 +1479,11 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		else
 			suf = "log";
 
-		gen_log_name(logname, sizeof(logname), "bw", o->bw_log_file,
+		gen_log_name(logname, sizeof(logname), "bw", pre,
 				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->bw_log, &p, logname);
 	}
-	if (o->iops_log_file) {
+	if (o->write_iops_log) {
 		struct log_params p = {
 			.td = td,
 			.avg_msec = o->log_avg_msec,
@@ -1491,6 +1494,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
+		const char *pre = o->iops_log_file ? o->iops_log_file : o->name;
 		const char *suf;
 
 		if (fio_option_is_set(o, iops_avg_time))
@@ -1506,7 +1510,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		else
 			suf = "log";
 
-		gen_log_name(logname, sizeof(logname), "iops", o->iops_log_file,
+		gen_log_name(logname, sizeof(logname), "iops", pre,
 				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->iops_log, &p, logname);
 	}
diff --git a/options.c b/options.c
index 50b4d09..bcda556 100644
--- a/options.c
+++ b/options.c
@@ -1311,6 +1311,50 @@ static int str_size_cb(void *data, unsigned long long *__val)
 	return 0;
 }
 
+static int str_write_bw_log_cb(void *data, const char *str)
+{
+	struct thread_data *td = cb_data_to_td(data);
+
+	if (str)
+		td->o.bw_log_file = strdup(str);
+
+	td->o.write_bw_log = 1;
+	return 0;
+}
+
+static int str_write_lat_log_cb(void *data, const char *str)
+{
+	struct thread_data *td = cb_data_to_td(data);
+
+	if (str)
+		td->o.lat_log_file = strdup(str);
+
+	td->o.write_lat_log = 1;
+	return 0;
+}
+
+static int str_write_iops_log_cb(void *data, const char *str)
+{
+	struct thread_data *td = cb_data_to_td(data);
+
+	if (str)
+		td->o.iops_log_file = strdup(str);
+
+	td->o.write_iops_log = 1;
+	return 0;
+}
+
+static int str_write_hist_log_cb(void *data, const char *str)
+{
+	struct thread_data *td = cb_data_to_td(data);
+
+	if (str)
+		td->o.hist_log_file = strdup(str);
+
+	td->o.write_hist_log = 1;
+	return 0;
+}
+
 static int rw_verify(struct fio_option *o, void *data)
 {
 	struct thread_data *td = cb_data_to_td(data);
@@ -3507,8 +3551,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "write_bw_log",
 		.lname	= "Write bandwidth log",
-		.type	= FIO_OPT_STR_STORE,
+		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, bw_log_file),
+		.cb	= str_write_bw_log_cb,
 		.help	= "Write log of bandwidth during run",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
@@ -3516,8 +3561,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "write_lat_log",
 		.lname	= "Write latency log",
-		.type	= FIO_OPT_STR_STORE,
+		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, lat_log_file),
+		.cb	= str_write_lat_log_cb,
 		.help	= "Write log of latency during run",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
@@ -3525,8 +3571,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "write_iops_log",
 		.lname	= "Write IOPS log",
-		.type	= FIO_OPT_STR_STORE,
+		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, iops_log_file),
+		.cb	= str_write_iops_log_cb,
 		.help	= "Write log of IOPS during run",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
@@ -3566,8 +3613,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "write_hist_log",
 		.lname	= "Write latency histogram logs",
-		.type	= FIO_OPT_STR_STORE,
+		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, hist_log_file),
+		.cb	= str_write_hist_log_cb,
 		.help	= "Write log of latency histograms during run",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
diff --git a/server.h b/server.h
index 6c572a1..3b592c7 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 57,
+	FIO_SERVER_VER			= 58,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 1b4590f..5e379e3 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -233,6 +233,12 @@ struct thread_options {
 
 	char *read_iolog_file;
 	char *write_iolog_file;
+
+	unsigned int write_bw_log;
+	unsigned int write_lat_log;
+	unsigned int write_iops_log;
+	unsigned int write_hist_log;
+
 	char *bw_log_file;
 	char *lat_log_file;
 	char *iops_log_file;
@@ -492,6 +498,12 @@ struct thread_options_pack {
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
 	uint8_t write_iolog_file[FIO_TOP_STR_MAX];
+
+	uint32_t write_bw_log;
+	uint32_t write_lat_log;
+	uint32_t write_iops_log;
+	uint32_t write_hist_log;
+
 	uint8_t bw_log_file[FIO_TOP_STR_MAX];
 	uint8_t lat_log_file[FIO_TOP_STR_MAX];
 	uint8_t iops_log_file[FIO_TOP_STR_MAX];
-- 
2.10.0

