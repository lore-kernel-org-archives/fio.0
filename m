Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 3/9] Added support for printing of stats and estimate time
 for copy operation.
Date: Tue,  1 Dec 2020 17:10:28 +0530
Message-Id: <20201201114034.8307-4-krish.reddy@samsung.com>
In-Reply-To: <20201201114034.8307-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <20201201114034.8307-1-krish.reddy@samsung.com>
	<CGME20201201114057epcas5p1aa9d8e1a56197e55251191a0a5985e3d@epcas5p1.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

From: Ankit Kumar <ankit.kumar@samsung.com>

Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
---
 backend.c |  3 +++
 eta.c     | 31 ++++++++++++++++++++++---------
 stat.c    | 20 +++++++++++++++-----
 stat.h    |  1 -
 4 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/backend.c b/backend.c
index 2e6a377c..2f4d6ac4 100644
--- a/backend.c
+++ b/backend.c
@@ -1828,6 +1828,8 @@ static void *thread_main(void *data)
 			update_runtime(td, elapsed_us, DDIR_WRITE);
 		if (td_trim(td) && td->io_bytes[DDIR_TRIM])
 			update_runtime(td, elapsed_us, DDIR_TRIM);
+		if (td_copy(td) && td->io_bytes[DDIR_COPY])
+			update_runtime(td, elapsed_us, DDIR_COPY);
 		fio_gettime(&td->start, NULL);
 		fio_sem_up(stat_sem);
 
@@ -2491,6 +2493,7 @@ int fio_backend(struct sk_out *sk_out)
 		setup_log(&agg_io_log[DDIR_READ], &p, "agg-read_bw.log");
 		setup_log(&agg_io_log[DDIR_WRITE], &p, "agg-write_bw.log");
 		setup_log(&agg_io_log[DDIR_TRIM], &p, "agg-trim_bw.log");
+		setup_log(&agg_io_log[DDIR_COPY], &p, "agg-copy_bw.log");
 	}
 
 	startup_sem = fio_sem_init(FIO_SEM_LOCKED);
diff --git a/eta.c b/eta.c
index d1c9449f..cb89013c 100644
--- a/eta.c
+++ b/eta.c
@@ -82,6 +82,11 @@ static void check_str_update(struct thread_data *td)
 				c = 'w';
 			else
 				c = 'W';
+		} else if (td_copy(td)) {
+			if (td_random(td))
+				c = 'q';
+			else
+				c = 'Q';
 		} else {
 			if (td_random(td))
 				c = 'd';
@@ -292,6 +297,8 @@ static unsigned long thread_eta(struct thread_data *td)
 			rate_bytes += td->o.rate[DDIR_WRITE];
 		if (td_trim(td))
 			rate_bytes += td->o.rate[DDIR_TRIM];
+		if (td_copy(td))
+			rate_bytes += td->o.rate[DDIR_COPY];
 
 		if (rate_bytes) {
 			r_eta = bytes_total / rate_bytes;
@@ -445,6 +452,12 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 				je->m_rate[2] += td->o.ratemin[DDIR_TRIM];
 				je->m_iops[2] += td->o.rate_iops_min[DDIR_TRIM];
 			}
+			if (td_copy(td)) {
+				je->t_rate[3] += td->o.rate[DDIR_COPY];
+				je->t_iops[3] += td->o.rate_iops[DDIR_COPY];
+				je->m_rate[3] += td->o.ratemin[DDIR_COPY];
+				je->m_iops[3] += td->o.rate_iops_min[DDIR_COPY];
+			}
 
 			je->files_open += td->nr_open_files;
 		} else if (td->runstate == TD_RAMP) {
@@ -534,7 +547,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 static int gen_eta_str(struct jobs_eta *je, char *p, size_t left,
 		       char **rate_str, char **iops_str)
 {
-	static const char c[DDIR_RWDIR_CNT] = {'r', 'w', 't'};
+	static const char c[DDIR_RWDIR_CNT] = {'r', 'w', 't', 'c'};
 	bool has[DDIR_RWDIR_CNT];
 	bool has_any = false;
 	const char *sep;
@@ -594,23 +607,23 @@ void display_thread_status(struct jobs_eta *je)
 	p += sprintf(p, "Jobs: %d (f=%d)", je->nr_running, je->files_open);
 
 	/* rate limits, if any */
-	if (je->m_rate[0] || je->m_rate[1] || je->m_rate[2] ||
-	    je->t_rate[0] || je->t_rate[1] || je->t_rate[2]) {
+	if (je->m_rate[0] || je->m_rate[1] || je->m_rate[2] || je->m_rate[3] ||
+	    je->t_rate[0] || je->t_rate[1] || je->t_rate[2] || je->t_rate[3]) {
 		char *tr, *mr;
 
-		mr = num2str(je->m_rate[0] + je->m_rate[1] + je->m_rate[2],
+		mr = num2str(je->m_rate[0] + je->m_rate[1] + je->m_rate[2] + je->m_rate[3],
 				je->sig_figs, 0, je->is_pow2, N2S_BYTEPERSEC);
-		tr = num2str(je->t_rate[0] + je->t_rate[1] + je->t_rate[2],
+		tr = num2str(je->t_rate[0] + je->t_rate[1] + je->t_rate[2] + je->t_rate[3],
 				je->sig_figs, 0, je->is_pow2, N2S_BYTEPERSEC);
 
 		p += sprintf(p, ", %s-%s", mr, tr);
 		free(tr);
 		free(mr);
-	} else if (je->m_iops[0] || je->m_iops[1] || je->m_iops[2] ||
-		   je->t_iops[0] || je->t_iops[1] || je->t_iops[2]) {
+	} else if (je->m_iops[0] || je->m_iops[1] || je->m_iops[2] || je->m_iops[3] ||
+		   je->t_iops[0] || je->t_iops[1] || je->t_iops[2] || je->t_iops[3]) {
 		p += sprintf(p, ", %d-%d IOPS",
-					je->m_iops[0] + je->m_iops[1] + je->m_iops[2],
-					je->t_iops[0] + je->t_iops[1] + je->t_iops[2]);
+					je->m_iops[0] + je->m_iops[1] + je->m_iops[2] + je->m_iops[3],
+					je->t_iops[0] + je->t_iops[1] + je->t_iops[2] + je->t_iops[3]);
 	}
 
 	/* current run string, % done, bandwidth, iops, eta */
diff --git a/stat.c b/stat.c
index eb40bd7f..0e348bf6 100644
--- a/stat.c
+++ b/stat.c
@@ -286,7 +286,7 @@ void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
 {
 	char *io, *agg, *min, *max;
 	char *ioalt, *aggalt, *minalt, *maxalt;
-	const char *str[] = { "   READ", "  WRITE" , "   TRIM"};
+	const char *str[] = { "   READ", "  WRITE" , "   TRIM", "   COPY"};
 	int i;
 
 	log_buf(out, "\nRun status group %d (all jobs):\n", rs->groupid);
@@ -1124,19 +1124,22 @@ static void show_thread_status_normal(struct thread_stat *ts,
 					io_u_dist[1], io_u_dist[2],
 					io_u_dist[3], io_u_dist[4],
 					io_u_dist[5], io_u_dist[6]);
-	log_buf(out, "     issued rwts: total=%llu,%llu,%llu,%llu"
-				 " short=%llu,%llu,%llu,0"
-				 " dropped=%llu,%llu,%llu,0\n",
+	log_buf(out, "     issued rwts: total=%llu,%llu,%llu,%llu,%llu"
+				 " short=%llu,%llu,%llu,%llu,0"
+				 " dropped=%llu,%llu,%llu,%llu,0\n",
 					(unsigned long long) ts->total_io_u[0],
 					(unsigned long long) ts->total_io_u[1],
 					(unsigned long long) ts->total_io_u[2],
 					(unsigned long long) ts->total_io_u[3],
+					(unsigned long long) ts->total_io_u[4],
 					(unsigned long long) ts->short_io_u[0],
 					(unsigned long long) ts->short_io_u[1],
 					(unsigned long long) ts->short_io_u[2],
+					(unsigned long long) ts->short_io_u[3],
 					(unsigned long long) ts->drop_io_u[0],
 					(unsigned long long) ts->drop_io_u[1],
-					(unsigned long long) ts->drop_io_u[2]);
+					(unsigned long long) ts->drop_io_u[2],
+					(unsigned long long) ts->drop_io_u[3]);
 	if (ts->continue_on_error) {
 		log_buf(out, "     errors    : total=%llu, first_error=%d/<%s>\n",
 					(unsigned long long)ts->total_err_count,
@@ -1442,6 +1445,8 @@ static void show_thread_status_terse_all(struct thread_stat *ts,
 	/* Log Trim Status */
 	if (ver == 2 || ver == 4 || ver == 5)
 		show_ddir_status_terse(ts, rs, DDIR_TRIM, ver, out);
+	/* Log Copy Status */
+	show_ddir_status_terse(ts, rs, DDIR_COPY, ver, out);
 
 	/* CPU Usage */
 	if (ts->total_run_time) {
@@ -1545,6 +1550,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	add_ddir_status_json(ts, rs, DDIR_READ, root);
 	add_ddir_status_json(ts, rs, DDIR_WRITE, root);
 	add_ddir_status_json(ts, rs, DDIR_TRIM, root);
+	add_ddir_status_json(ts, rs, DDIR_COPY, root);
 	add_ddir_status_json(ts, rs, DDIR_SYNC, root);
 
 	/* CPU Usage */
@@ -2325,6 +2331,8 @@ int __show_running_run_stats(void)
 			td->ts.runtime[DDIR_WRITE] += rt[i];
 		if (td_trim(td) && td->ts.io_bytes[DDIR_TRIM])
 			td->ts.runtime[DDIR_TRIM] += rt[i];
+		if (td_copy(td) && td->ts.io_bytes[DDIR_COPY])
+			td->ts.runtime[DDIR_COPY] += rt[i];
 	}
 
 	for_each_td(td, i) {
@@ -2346,6 +2354,8 @@ int __show_running_run_stats(void)
 			td->ts.runtime[DDIR_WRITE] -= rt[i];
 		if (td_trim(td) && td->ts.io_bytes[DDIR_TRIM])
 			td->ts.runtime[DDIR_TRIM] -= rt[i];
+		if (td_copy(td) && td->ts.io_bytes[DDIR_COPY])
+			td->ts.runtime[DDIR_COPY] -= rt[i];
 	}
 
 	free(rt);
diff --git a/stat.h b/stat.h
index 6dd5ef74..3d439e24 100644
--- a/stat.h
+++ b/stat.h
@@ -281,7 +281,6 @@ struct thread_stat {
 	uint32_t m_iops[DDIR_RWDIR_CNT];				\
 	uint32_t t_iops[DDIR_RWDIR_CNT];				\
 	uint32_t iops[DDIR_RWDIR_CNT];					\
-	uint32_t pad;							\
 	uint64_t elapsed_sec;						\
 	uint64_t eta_sec;						\
 	uint32_t is_pow2;						\
-- 
2.17.1


