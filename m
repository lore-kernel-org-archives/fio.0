Return-Path: <jcasse@chromium.org>
From: Juan Casse <jcasse@chromium.org>
Subject: [PATCH 1/2] Adds check for numberio during verify phase.
Date: Mon, 26 Aug 2013 14:22:41 -0700
Message-Id: <1377552162-31741-1-git-send-email-jcasse@chromium.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@chromium.org>, fio@vger.kernel.org, Juan Casse <jcasse@chromium.org>
List-ID: <fio@vger.kernel.org>

We check numberio to detect stale blocks.

Signed-off-by: Juan Casse <jcasse@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
---
 HOWTO            |  7 +++++++
 init.c           | 33 +++++++++++++++++++++++++++++++++
 ioengine.h       |  1 +
 iolog.c          |  1 +
 iolog.h          |  1 +
 libfio.c         |  3 ++-
 options.c        |  9 +++++++++
 thread_options.h |  2 ++
 verify.c         | 10 ++++++++--
 9 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/HOWTO b/HOWTO
index 005dac2..14ff8b5 100644
--- a/HOWTO
+++ b/HOWTO
@@ -657,6 +657,13 @@ ioengine=str	Defines how the job issues io to the file. The following
 				filename, eg ioengine=external:/tmp/foo.o
 				to load ioengine foo.o in /tmp.
 
+data_integrity_check
+		If this option is given, fio will check the i/o number of
+		each block read back during the verification phase. Fio
+		checks numberio to detect stale blocks. Currently, this
+		option requires synchronous i/o, and equal-sized read and
+		write blocks. This option requires workloads that write data.
+
 iodepth=int	This defines how many io units to keep in flight against
 		the file. The default is 1 for each file defined in this
 		job, can be overridden with a larger value for higher
diff --git a/init.c b/init.c
index 1afc341..8e2e1ae 100644
--- a/init.c
+++ b/init.c
@@ -915,6 +915,35 @@ static char *make_filename(char *buf, struct thread_options *o,
 
 	return buf;
 }
+
+int data_integrity_ini(struct thread_data *td)
+{
+	if (td->o.td_ddir != TD_DDIR_WRITE &&
+		td->o.td_ddir != TD_DDIR_RW &&
+		td->o.td_ddir != TD_DDIR_RANDRW &&
+		td->o.td_ddir != TD_DDIR_RANDWRITE) {
+		fprintf(stderr,
+			"Option data_integrity_check requires a workload that "
+			"writes data\n");
+		return 1;
+	}
+
+	if (td->o.bs[DDIR_READ] != td->o.bs[DDIR_WRITE]) {
+		fprintf(stderr,
+			"Currently, option data_integrity_check requires "
+			"equal-sized read and write blocks\n");
+		return 1;
+	}
+
+	if (strcmp(td->o.ioengine, "sync")) {
+		log_err("Currently, option data_integrity_check requires "
+			"synchronous i/o\n");
+		return 1;
+	}
+
+	return 0;
+}
+
 /*
  * Adds a job to the list of things todo. Sanitizes the various options
  * to make sure we don't have conflicts, and initializes various
@@ -944,6 +973,10 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		return 0;
 	}
 
+	if (o->data_integrity_check)
+		if (data_integrity_ini(td))
+			goto err;
+
 	td->client_type = client_type;
 
 	if (profile_td_init(td))
diff --git a/ioengine.h b/ioengine.h
index 31662eb..812febd 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -50,6 +50,7 @@ struct io_u {
 	 */
 	unsigned long buflen;
 	unsigned long long offset;
+	unsigned short numberio;
 	void *buf;
 
 	/*
diff --git a/iolog.c b/iolog.c
index 9bcf0d8..6459d3b 100644
--- a/iolog.c
+++ b/iolog.c
@@ -188,6 +188,7 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 	ipo->file = io_u->file;
 	ipo->offset = io_u->offset;
 	ipo->len = io_u->buflen;
+	ipo->numberio = io_u->numberio;
 
 	if (io_u_should_trim(td, io_u)) {
 		flist_add_tail(&ipo->trim_list, &td->trim_list);
diff --git a/iolog.h b/iolog.h
index 8fedc19..94e0fc1 100644
--- a/iolog.h
+++ b/iolog.h
@@ -78,6 +78,7 @@ struct io_piece {
 		struct fio_file *file;
 	};
 	unsigned long long offset;
+	unsigned short numberio;
 	unsigned long len;
 	unsigned int flags;
 	enum fio_ddir ddir;
diff --git a/libfio.c b/libfio.c
index c26d6a3..f003945 100644
--- a/libfio.c
+++ b/libfio.c
@@ -83,7 +83,8 @@ static void reset_io_counters(struct thread_data *td)
 		td->this_io_blocks[ddir] = 0;
 		td->rate_bytes[ddir] = 0;
 		td->rate_blocks[ddir] = 0;
-		td->io_issues[ddir] = 0;
+		if (!td->o.data_integrity_check)
+			td->io_issues[ddir] = 0;
 	}
 	td->zone_bytes = 0;
 
diff --git a/options.c b/options.c
index caf89d3..569cdf7 100644
--- a/options.c
+++ b/options.c
@@ -1935,6 +1935,15 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_RUNTIME,
 	},
 	{
+		.name	= "data_integrity_check",
+		.lname	= "Data integrity check",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= td_var_offset(data_integrity_check),
+		.help	= "Checks numberio during verify phase",
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_RUNTIME,
+	},
+	{
 		.name	= "ramp_time",
 		.lname	= "Ramp time",
 		.type	= FIO_OPT_STR_VAL_TIME,
diff --git a/thread_options.h b/thread_options.h
index 3f345c5..8666cd1 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -107,6 +107,8 @@ struct thread_options {
 	unsigned int fsync_on_close;
 	unsigned int bs_is_seq_rand;
 
+	unsigned int data_integrity_check;
+
 	unsigned int random_distribution;
 
 	fio_fp64_t zipf_theta;
diff --git a/verify.c b/verify.c
index 9e88d61..83c5735 100644
--- a/verify.c
+++ b/verify.c
@@ -369,6 +369,10 @@ static int verify_io_u_meta(struct verify_header *hdr, struct vcont *vc)
 	if (td->o.verify_pattern_bytes)
 		ret |= verify_io_u_pattern(hdr, vc);
 
+	if (td->o.data_integrity_check)
+		if (vh->numberio != io_u->numberio)
+			ret = EILSEQ;
+
 	if (!ret)
 		return 0;
 
@@ -768,8 +772,7 @@ static void fill_meta(struct verify_header *hdr, struct thread_data *td,
 	vh->time_sec = io_u->start_time.tv_sec;
 	vh->time_usec = io_u->start_time.tv_usec;
 
-	vh->numberio = td->io_issues[DDIR_WRITE];
-
+	vh->numberio = io_u->numberio;
 	vh->offset = io_u->offset + header_num * td->o.verify_interval;
 }
 
@@ -942,6 +945,8 @@ void populate_verify_io_u(struct thread_data *td, struct io_u *io_u)
 	if (td->o.verify == VERIFY_NULL)
 		return;
 
+	io_u->numberio = td->io_issues[DDIR_WRITE];
+
 	fill_pattern_headers(td, io_u, 0, 0);
 }
 
@@ -974,6 +979,7 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 
 		io_u->offset = ipo->offset;
 		io_u->buflen = ipo->len;
+		io_u->numberio = ipo->numberio;
 		io_u->file = ipo->file;
 		io_u->flags |= IO_U_F_VER_LIST;
 
-- 
1.7.12.4


