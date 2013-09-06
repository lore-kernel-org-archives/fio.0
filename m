Return-Path: <jcasse@chromium.org>
From: Juan Casse <jcasse@chromium.org>
Subject: [PATCH] Adds verify_only option.
Date: Thu,  5 Sep 2013 20:12:32 -0700
Message-Id: <1378437152-11128-1-git-send-email-jcasse@chromium.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@chromium.org>, fio@vger.kernel.org, Juan Casse <jcasse@chromium.org>
List-ID: <fio@vger.kernel.org>

The verify_only option allows to correctly verify the numberio in each
block header that was written in a previous run of fio.
---
 HOWTO            | 10 +++++++++-
 README           |  1 +
 backend.c        |  9 ++++++++-
 engines/sync.c   |  8 ++++++--
 init.c           | 32 ++++++++++++++++++++++++++++++++
 options.c        |  9 +++++++++
 thread_options.h |  2 ++
 7 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/HOWTO b/HOWTO
index 005dac2..54f2332 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1039,6 +1039,12 @@ loops=int	Run the specified number of iterations of this job. Used
 		to repeat the same workload a given number of times. Defaults
 		to 1.
 
+verify_only	Run the workload without actually writing to disk and then
+		do a verify of the blocks on disk once after all iterations
+		have completed. Note that the blocks must be written by a
+		previous run of fio with the same workload. The verify_only
+		option implies do_verify=1 and verify=meta.
+
 do_verify=bool	Run the verify phase after a write phase. Only makes sense if
 		verify is set. Defaults to 1.
 
@@ -1077,7 +1083,9 @@ verify=str	If writing to a file, fio can verify the file contents
 
 			meta	Write extra information about each io
 				(timestamp, block number etc.). The block
-				number is verified. See also verify_pattern.
+				number is verified. The io sequence number is
+				verified for workloads that write data.
+				See also verify_pattern.
 
 			null	Only pretend to verify. Useful for testing
 				internals with ioengine=null, not for much
diff --git a/README b/README
index 15a0731..0c66335 100644
--- a/README
+++ b/README
@@ -141,6 +141,7 @@ $ fio
 	--latency-log		Generate per-job latency logs
 	--bandwidth-log		Generate per-job bandwidth logs
 	--minimal		Minimal (terse) output
+	--verifyonly		Do not write to disk, only verify blocks.
 	--output-format=type	Output format (terse,json,normal)
 	--terse-version=type	Terse version output format (default 3, or 2 or 4).
 	--version		Print version info and exit
diff --git a/backend.c b/backend.c
index b9c1c12..934795c 100644
--- a/backend.c
+++ b/backend.c
@@ -1340,7 +1340,14 @@ static void *thread_main(void *data)
 
 		fio_gettime(&td->start, NULL);
 
-		do_verify(td, verify_bytes);
+		/*
+		 * If verify_only is set, verify only once, in the last
+		 * iteration, when the state of numberio for each block is
+		 * consistent with what should have been written to disk
+		 * in a previous run.
+		 */
+		if (!o->verify_only || o->loops == 0)
+			do_verify(td, verify_bytes);
 
 		td->ts.runtime[DDIR_READ] += utime_since_now(&td->start);
 
diff --git a/engines/sync.c b/engines/sync.c
index 1329946..9dbd857 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -125,8 +125,12 @@ static int fio_syncio_queue(struct thread_data *td, struct io_u *io_u)
 
 	if (io_u->ddir == DDIR_READ)
 		ret = read(f->fd, io_u->xfer_buf, io_u->xfer_buflen);
-	else if (io_u->ddir == DDIR_WRITE)
-		ret = write(f->fd, io_u->xfer_buf, io_u->xfer_buflen);
+	else if (io_u->ddir == DDIR_WRITE) {
+		if (!td->o.verify_only)
+			ret = write(f->fd, io_u->xfer_buf, io_u->xfer_buflen);
+		else
+			ret = io_u->xfer_buflen;
+	}
 	else if (io_u->ddir == DDIR_TRIM) {
 		do_io_u_trim(td, io_u);
 		return FIO_Q_COMPLETED;
diff --git a/init.c b/init.c
index 1afc341..87da9fc 100644
--- a/init.c
+++ b/init.c
@@ -58,6 +58,7 @@ int log_syslog = 0;
 
 int write_bw_log = 0;
 int read_only = 0;
+int verify_only = 0;
 int status_interval = 0;
 
 static int write_lat_log;
@@ -139,6 +140,11 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.val		= 'r' | FIO_CLIENT_FLAG,
 	},
 	{
+		.name		= (char *) "verifyonly",
+		.has_arg	= no_argument,
+		.val		= 'y' | FIO_CLIENT_FLAG,
+	},
+	{
 		.name		= (char *) "eta",
 		.has_arg	= required_argument,
 		.val		= 'e' | FIO_CLIENT_FLAG,
@@ -928,6 +934,29 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	int numjobs, file_alloced;
 	struct thread_options *o = &td->o;
 
+	/* 
+	 * If the verify_only option is provided as a command-line argument,
+	 * set the job option as well.
+	 */
+	if (verify_only)
+		o->verify_only = 1;
+
+	/*
+	 * The verify_only option implies that we want to do a verify of the
+	 * meta data in each block written in a previous run using the
+	 * same workload. We still need to simulate the workload
+	 * (without actually writing) in order to compute the numberio that
+	 * would have been written to the meta section of each block.
+	 * We revert to the the synchronous io engine because there is already
+	 * code in place for the synchronous engine to compute the numberio
+	 * without writing to disk.
+	 */
+	if (o->verify_only) {
+		o->do_verify = 1;
+		o->verify = VERIFY_META;
+		strcpy(o->ioengine, "sync");
+	}
+
 	/*
 	 * the def_thread is just for options, it's not a real job
 	 */
@@ -1661,6 +1690,9 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 		case 'r':
 			read_only = 1;
 			break;
+		case 'y':
+			verify_only = 1;
+			break;
 		case 'v':
 			if (!cur_client) {
 				log_info("%s\n", fio_version_string);
diff --git a/options.c b/options.c
index caf89d3..e6b9ec9 100644
--- a/options.c
+++ b/options.c
@@ -1935,6 +1935,15 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_RUNTIME,
 	},
 	{
+		.name	= "verify_only",
+		.lname	= "Verify only",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= td_var_offset(verify_only),
+		.help	= "Verifies previously written data is still valid",
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_RUNTIME,
+	},
+	{
 		.name	= "ramp_time",
 		.lname	= "Ramp time",
 		.type	= FIO_OPT_STR_VAL_TIME,
diff --git a/thread_options.h b/thread_options.h
index 3f345c5..c9660b4 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -107,6 +107,8 @@ struct thread_options {
 	unsigned int fsync_on_close;
 	unsigned int bs_is_seq_rand;
 
+	unsigned int verify_only;
+
 	unsigned int random_distribution;
 
 	fio_fp64_t zipf_theta;
-- 
1.7.12.4


