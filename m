Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46680 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbfGBMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 2 Jul 2019 08:00:06 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hiHS9-0006ch-39
        for fio@vger.kernel.org; Tue, 02 Jul 2019 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190702120002.090372C005B@kernel.dk>
Date: Tue,  2 Jul 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 971341ad741db8d2ae57d8f9b368d75f6c02c1a9:

  Merge branch 'wip-tcmalloc' of https://github.com/dillaman/fio (2019-05-31 15:37:18 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 308aa5d011158d5f7fa533a60199066dd1858e4c:

  Merge branch 'optlenmax' of https://github.com/powernap/fio (2019-07-01 14:26:29 -0600)

----------------------------------------------------------------
Damien Le Moal (2):
      Fix string copy compilation warnings
      eta: Fix compiler warning

Jens Axboe (2):
      engines/rbd: hide rbd_io_u_seen() if not used
      Merge branch 'optlenmax' of https://github.com/powernap/fio

Nick Principe (1):
      Increase maximum length of line in jobs file to 8192

 engines/rbd.c           |  2 ++
 eta.c                   |  9 ++++++---
 exp/expression-parser.y |  6 +++---
 filesetup.c             |  3 ++-
 fio.1                   |  2 ++
 init.c                  | 11 ++++++-----
 parse.h                 |  2 +-
 server.c                |  9 ++++++---
 8 files changed, 28 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/engines/rbd.c b/engines/rbd.c
index 081b4a04..7d4d3faf 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -316,12 +316,14 @@ static inline int fri_check_complete(struct rbd_data *rbd, struct io_u *io_u,
 	return 0;
 }
 
+#ifndef CONFIG_RBD_POLL
 static inline int rbd_io_u_seen(struct io_u *io_u)
 {
 	struct fio_rbd_iou *fri = io_u->engine_data;
 
 	return fri->io_seen;
 }
+#endif
 
 static void rbd_io_u_wait_complete(struct io_u *io_u)
 {
diff --git a/eta.c b/eta.c
index b69dd194..647a1bdd 100644
--- a/eta.c
+++ b/eta.c
@@ -392,6 +392,9 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	static unsigned long long disp_io_iops[DDIR_RWDIR_CNT];
 	static struct timespec rate_prev_time, disp_prev_time;
 
+	void *je_rate = (void *) je->rate;
+	void *je_iops = (void *) je->iops;
+
 	if (!force) {
 		if (!(output_format & FIO_OUTPUT_NORMAL) &&
 		    f_out == stdout)
@@ -507,7 +510,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 
 	if (write_bw_log && rate_time > bw_avg_time && !in_ramp_time(td)) {
 		calc_rate(unified_rw_rep, rate_time, io_bytes, rate_io_bytes,
-				je->rate);
+				je_rate);
 		memcpy(&rate_prev_time, &now, sizeof(now));
 		add_agg_sample(sample_val(je->rate[DDIR_READ]), DDIR_READ, 0);
 		add_agg_sample(sample_val(je->rate[DDIR_WRITE]), DDIR_WRITE, 0);
@@ -519,8 +522,8 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	if (!force && !eta_time_within_slack(disp_time))
 		return false;
 
-	calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je->rate);
-	calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_iops, je->iops);
+	calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je_rate);
+	calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_iops, je_iops);
 
 	memcpy(&disp_prev_time, &now, sizeof(now));
 
diff --git a/exp/expression-parser.y b/exp/expression-parser.y
index 04a6e07a..8619025c 100644
--- a/exp/expression-parser.y
+++ b/exp/expression-parser.y
@@ -204,9 +204,9 @@ static void setup_to_parse_string(const char *string)
 {
 	unsigned int len;
 
-	len = strlen(string);
-	if (len > sizeof(lexer_input_buffer) - 3)
-		len = sizeof(lexer_input_buffer) - 3;
+	len = sizeof(lexer_input_buffer) - 3;
+	if (len > strlen(string))
+		len = strlen(string);
 
 	strncpy(lexer_input_buffer, string, len);
 	lexer_input_buffer[len] = '\0'; 
diff --git a/filesetup.c b/filesetup.c
index 24e6fb07..17fa31fb 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -829,7 +829,8 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 			continue;
 
 		fm = calloc(1, sizeof(*fm));
-		strncpy(fm->__base, buf, sizeof(fm->__base) - 1);
+		strncpy(fm->__base, buf, sizeof(fm->__base));
+		fm->__base[255] = '\0'; 
 		fm->base = basename(fm->__base);
 		fm->key = sb.st_dev;
 		flist_add(&fm->list, &list);
diff --git a/fio.1 b/fio.1
index 84b80eee..156201ad 100644
--- a/fio.1
+++ b/fio.1
@@ -201,6 +201,8 @@ argument, \fB\-\-cmdhelp\fR will detail the given \fIcommand\fR.
 See the `examples/' directory for inspiration on how to write job files. Note
 the copyright and license requirements currently apply to
 `examples/' files.
+
+Note that the maximum length of a line in the job file is 8192 bytes.
 .SH "JOB FILE PARAMETERS"
 Some parameters take an option of a given type, such as an integer or a
 string. Anywhere a numeric value is required, an arithmetic expression may be
diff --git a/init.c b/init.c
index 73834279..c9f6198e 100644
--- a/init.c
+++ b/init.c
@@ -1438,7 +1438,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		   int recursed, int client_type)
 {
 	unsigned int i;
-	char fname[PATH_MAX];
+	char fname[PATH_MAX + 1];
 	int numjobs, file_alloced;
 	struct thread_options *o = &td->o;
 	char logname[PATH_MAX + 32];
@@ -1887,7 +1887,7 @@ static int __parse_jobs_ini(struct thread_data *td,
 		}
 	}
 
-	string = malloc(4096);
+	string = malloc(OPT_LEN_MAX);
 
 	/*
 	 * it's really 256 + small bit, 280 should suffice
@@ -1920,7 +1920,7 @@ static int __parse_jobs_ini(struct thread_data *td,
 			if (is_buf)
 				p = strsep(&file, "\n");
 			else
-				p = fgets(string, 4096, f);
+				p = fgets(string, OPT_LEN_MAX, f);
 			if (!p)
 				break;
 		}
@@ -1989,7 +1989,7 @@ static int __parse_jobs_ini(struct thread_data *td,
 				if (is_buf)
 					p = strsep(&file, "\n");
 				else
-					p = fgets(string, 4096, f);
+					p = fgets(string, OPT_LEN_MAX, f);
 				if (!p)
 					break;
 				dprint(FD_PARSE, "%s", p);
@@ -2040,7 +2040,8 @@ static int __parse_jobs_ini(struct thread_data *td,
 					strncpy(full_fn,
 						file, (ts - file) + 1);
 					strncpy(full_fn + (ts - file) + 1,
-						filename, strlen(filename));
+						filename,
+						len - (ts - file) - 1);
 					full_fn[len - 1] = 0;
 					filename = full_fn;
 				}
diff --git a/parse.h b/parse.h
index b47a02c7..9b4e2f32 100644
--- a/parse.h
+++ b/parse.h
@@ -37,7 +37,7 @@ struct value_pair {
 	void *cb;			/* sub-option callback */
 };
 
-#define OPT_LEN_MAX 	4096
+#define OPT_LEN_MAX 	8192
 #define PARSE_MAX_VP	24
 
 /*
diff --git a/server.c b/server.c
index 2a337707..23e549a5 100644
--- a/server.c
+++ b/server.c
@@ -1470,9 +1470,12 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 
 	memset(&p, 0, sizeof(p));
 
-	strncpy(p.ts.name, ts->name, FIO_JOBNAME_SIZE - 1);
-	strncpy(p.ts.verror, ts->verror, FIO_VERROR_SIZE - 1);
-	strncpy(p.ts.description, ts->description, FIO_JOBDESC_SIZE - 1);
+	strncpy(p.ts.name, ts->name, FIO_JOBNAME_SIZE);
+	p.ts.name[FIO_JOBNAME_SIZE - 1] = '\0';
+	strncpy(p.ts.verror, ts->verror, FIO_VERROR_SIZE);
+	p.ts.verror[FIO_VERROR_SIZE - 1] = '\0';
+	strncpy(p.ts.description, ts->description, FIO_JOBDESC_SIZE);
+	p.ts.description[FIO_JOBDESC_SIZE - 1] = '\0';
 
 	p.ts.error		= cpu_to_le32(ts->error);
 	p.ts.thread_number	= cpu_to_le32(ts->thread_number);

