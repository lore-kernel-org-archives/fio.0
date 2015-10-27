Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48268 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbbJ0MAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 27 Oct 2015 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Zr2v5-0006jy-C8
	for fio@vger.kernel.org; Tue, 27 Oct 2015 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151027120002.19B682C1E1B@kernel.dk>
Date: Tue, 27 Oct 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d2235e56057f54fc63ccbf789d4c54f9e99978af:

  client: remove duplicated code (2015-10-20 09:07:31 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 01cfefcc6255420a9e19d5774053ed2fb705b150:

  client/backend: fix incomplete output_format checks (2015-10-27 18:34:33 +0900)

----------------------------------------------------------------
Jens Axboe (12):
      Add support for multiple output formats
      Enable the use of multiple output formats
      Update fio man page
      Re-instate --append-terse
      Proper size return from output buffers
      Don't setup output buffers we are not going to use
      jobs_eta alloc padding
      log: abstract out and use generic buffer logger
      Unbreak output buffer logging over the network
      stat: collapse buf output flush and free
      stat: fix potential segfault for json output on network client
      client/backend: fix incomplete output_format checks

 Makefile            |   1 +
 backend.c           |   2 +-
 client.c            |  21 ++--
 diskutil.c          |  35 ++++---
 diskutil.h          |  11 +-
 eta.c               |   4 +-
 filesetup.c         |   2 +-
 fio.1               |   2 +
 fio.h               |  11 +-
 idletime.c          |  21 ++--
 idletime.h          |   3 +-
 init.c              |  50 +++++++---
 json.c              |  62 ++++++------
 json.h              |   5 +-
 lib/output_buffer.c |  48 +++++++++
 lib/output_buffer.h |  17 ++++
 log.c               |  50 ++++++----
 log.h               |  20 +++-
 parse.c             |   4 +-
 stat.c              | 282 +++++++++++++++++++++++++++-------------------------
 stat.h              |   5 +-
 21 files changed, 403 insertions(+), 253 deletions(-)
 create mode 100644 lib/output_buffer.c
 create mode 100644 lib/output_buffer.h

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 1507464..0b506e8 100644
--- a/Makefile
+++ b/Makefile
@@ -47,6 +47,7 @@ SOURCE :=	gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		lib/hweight.c lib/getrusage.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
 		lib/tp.c lib/bloom.c lib/gauss.c lib/mountcheck.c workqueue.c \
+		lib/output_buffer.c \
 		$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c))
 
 ifdef CONFIG_LIBHDFS
diff --git a/backend.c b/backend.c
index 8fd5535..b180196 100644
--- a/backend.c
+++ b/backend.c
@@ -1977,7 +1977,7 @@ static void run_threads(void)
 			nr_process++;
 	}
 
-	if (output_format == FIO_OUTPUT_NORMAL) {
+	if (output_format & FIO_OUTPUT_NORMAL) {
 		log_info("Starting ");
 		if (nr_thread)
 			log_info("%d thread%s", nr_thread,
diff --git a/client.c b/client.c
index 005ddf4..db472c4 100644
--- a/client.c
+++ b/client.c
@@ -117,7 +117,7 @@ static int read_data(int fd, void *data, size_t size)
 
 static void fio_client_json_init(void)
 {
-	if (output_format != FIO_OUTPUT_JSON)
+	if (!(output_format & FIO_OUTPUT_JSON))
 		return;
 	root = json_create_object();
 	json_object_add_value_string(root, "fio version", fio_version_string);
@@ -129,9 +129,9 @@ static void fio_client_json_init(void)
 
 static void fio_client_json_fini(void)
 {
-	if (output_format != FIO_OUTPUT_JSON)
+	if (!(output_format & FIO_OUTPUT_JSON))
 		return;
-	json_print_object(root);
+	json_print_object(root, NULL);
 	log_info("\n");
 	json_free_object(root);
 	root = NULL;
@@ -936,7 +936,7 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 	struct cmd_ts_pdu *p = (struct cmd_ts_pdu *) cmd->payload;
 	struct json_object *tsobj;
 
-	tsobj = show_thread_status(&p->ts, &p->rs);
+	tsobj = show_thread_status(&p->ts, &p->rs, NULL);
 	client->did_stat = 1;
 	if (tsobj) {
 		json_object_add_client_info(tsobj, client);
@@ -956,7 +956,7 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 
 	if (++sum_stat_nr == sum_stat_clients) {
 		strcpy(client_ts.name, "All clients");
-		tsobj = show_thread_status(&client_ts, &client_gs);
+		tsobj = show_thread_status(&client_ts, &client_gs, NULL);
 		if (tsobj) {
 			json_object_add_client_info(tsobj, client);
 			json_array_add_value_object(clients_array, tsobj);
@@ -968,7 +968,7 @@ static void handle_gs(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct group_run_stats *gs = (struct group_run_stats *) cmd->payload;
 
-	show_group_stats(gs);
+	show_group_stats(gs, NULL);
 }
 
 static void handle_text(struct fio_client *client, struct fio_net_cmd *cmd)
@@ -1029,13 +1029,16 @@ static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd)
 		log_info("\nDisk stats (read/write):\n");
 	}
 
-	if (output_format == FIO_OUTPUT_JSON) {
+	if (output_format & FIO_OUTPUT_JSON) {
 		struct json_object *duobj;
 		json_array_add_disk_util(&du->dus, &du->agg, du_array);
 		duobj = json_array_last_value_object(du_array);
 		json_object_add_client_info(duobj, client);
-	} else
-		print_disk_util(&du->dus, &du->agg, output_format == FIO_OUTPUT_TERSE);
+	}
+	if (output_format & FIO_OUTPUT_TERSE)
+		print_disk_util(&du->dus, &du->agg, 1, NULL);
+	if (output_format & FIO_OUTPUT_NORMAL)
+		print_disk_util(&du->dus, &du->agg, 0, NULL);
 }
 
 static void convert_jobs_eta(struct jobs_eta *je)
diff --git a/diskutil.c b/diskutil.c
index 52d87f6..f83fc47 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -495,13 +495,14 @@ void init_disk_util(struct thread_data *td)
 		f->du = __init_disk_util(td, f);
 }
 
-static void show_agg_stats(struct disk_util_agg *agg, int terse)
+static void show_agg_stats(struct disk_util_agg *agg, int terse,
+			   struct buf_output *out)
 {
 	if (!agg->slavecount)
 		return;
 
 	if (!terse) {
-		log_info(", aggrios=%llu/%llu, aggrmerge=%llu/%llu, "
+		log_buf(out, ", aggrios=%llu/%llu, aggrmerge=%llu/%llu, "
 			 "aggrticks=%llu/%llu, aggrin_queue=%llu, "
 			 "aggrutil=%3.2f%%",
 			(unsigned long long) agg->ios[0] / agg->slavecount,
@@ -513,7 +514,7 @@ static void show_agg_stats(struct disk_util_agg *agg, int terse)
 			(unsigned long long) agg->time_in_queue / agg->slavecount,
 			agg->max_util.u.f);
 	} else {
-		log_info(";slaves;%llu;%llu;%llu;%llu;%llu;%llu;%llu;%3.2f%%",
+		log_buf(out, ";slaves;%llu;%llu;%llu;%llu;%llu;%llu;%llu;%3.2f%%",
 			(unsigned long long) agg->ios[0] / agg->slavecount,
 			(unsigned long long) agg->ios[1] / agg->slavecount,
 			(unsigned long long) agg->merges[0] / agg->slavecount,
@@ -578,7 +579,7 @@ void disk_util_prune_entries(void)
 }
 
 void print_disk_util(struct disk_util_stat *dus, struct disk_util_agg *agg,
-		     int terse)
+		     int terse, struct buf_output *out)
 {
 	double util = 0;
 
@@ -589,9 +590,9 @@ void print_disk_util(struct disk_util_stat *dus, struct disk_util_agg *agg,
 
 	if (!terse) {
 		if (agg->slavecount)
-			log_info("  ");
+			log_buf(out, "  ");
 
-		log_info("  %s: ios=%llu/%llu, merge=%llu/%llu, "
+		log_buf(out, "  %s: ios=%llu/%llu, merge=%llu/%llu, "
 			 "ticks=%llu/%llu, in_queue=%llu, util=%3.2f%%",
 				dus->name,
 				(unsigned long long) dus->s.ios[0],
@@ -603,7 +604,7 @@ void print_disk_util(struct disk_util_stat *dus, struct disk_util_agg *agg,
 				(unsigned long long) dus->s.time_in_queue,
 				util);
 	} else {
-		log_info(";%s;%llu;%llu;%llu;%llu;%llu;%llu;%llu;%3.2f%%",
+		log_buf(out, ";%s;%llu;%llu;%llu;%llu;%llu;%llu;%llu;%3.2f%%",
 				dus->name,
 				(unsigned long long) dus->s.ios[0],
 				(unsigned long long) dus->s.ios[1],
@@ -619,10 +620,10 @@ void print_disk_util(struct disk_util_stat *dus, struct disk_util_agg *agg,
 	 * If the device has slaves, aggregate the stats for
 	 * those slave devices also.
 	 */
-	show_agg_stats(agg, terse);
+	show_agg_stats(agg, terse, out);
 
 	if (!terse)
-		log_info("\n");
+		log_buf(out, "\n");
 }
 
 void json_array_add_disk_util(struct disk_util_stat *dus,
@@ -689,7 +690,8 @@ static void json_object_add_disk_utils(struct json_object *obj,
 	}
 }
 
-void show_disk_util(int terse, struct json_object *parent)
+void show_disk_util(int terse, struct json_object *parent,
+		    struct buf_output *out)
 {
 	struct flist_head *entry;
 	struct disk_util *du;
@@ -704,21 +706,22 @@ void show_disk_util(int terse, struct json_object *parent)
 		return;
 	}
 
-	if (output_format == FIO_OUTPUT_JSON)
+	if (output_format & FIO_OUTPUT_JSON)
 		assert(parent);
 
-	if (!terse && output_format != FIO_OUTPUT_JSON)
-		log_info("\nDisk stats (read/write):\n");
+	if (!terse && !(output_format & FIO_OUTPUT_JSON))
+		log_buf(out, "\nDisk stats (read/write):\n");
 
-	if (output_format == FIO_OUTPUT_JSON)
+	if (output_format & FIO_OUTPUT_JSON)
 		json_object_add_disk_utils(parent, &disk_list);
-	else
+	if (output_format & ~(FIO_OUTPUT_JSON)) {
 		flist_for_each(entry, &disk_list) {
 			du = flist_entry(entry, struct disk_util, list);
 
 			aggregate_slaves_stats(du);
-			print_disk_util(&du->dus, &du->agg, terse);
+			print_disk_util(&du->dus, &du->agg, terse, out);
 		}
+	}
 
 	fio_mutex_up(disk_util_mutex);
 }
diff --git a/diskutil.h b/diskutil.h
index c0ae0ed..25d0beb 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -3,6 +3,8 @@
 #include "json.h"
 #define FIO_DU_NAME_SZ		64
 
+#include "lib/output_buffer.h"
+
 extern volatile int helper_exit;
 
 struct disk_util_stats {
@@ -105,8 +107,8 @@ extern struct flist_head disk_list;
  * disk util stuff
  */
 #ifdef FIO_HAVE_DISK_UTIL
-extern void print_disk_util(struct disk_util_stat *, struct disk_util_agg *, int terse);
-extern void show_disk_util(int terse, struct json_object *parent);
+extern void print_disk_util(struct disk_util_stat *, struct disk_util_agg *, int terse, struct buf_output *);
+extern void show_disk_util(int terse, struct json_object *parent, struct buf_output *);
 extern void json_array_add_disk_util(struct disk_util_stat *dus,
 		struct disk_util_agg *agg, struct json_array *parent);
 extern void init_disk_util(struct thread_data *);
@@ -115,10 +117,11 @@ extern void setup_disk_util(void);
 extern void disk_util_prune_entries(void);
 #else
 static inline void print_disk_util(struct disk_util_stat *du,
-				   struct disk_util_agg *agg, int terse)
+				   struct disk_util_agg *agg, int terse,
+				   struct buf_output *out)
 {
 }
-#define show_disk_util(terse, parent)
+#define show_disk_util(terse, parent, out)
 #define disk_util_prune_entries()
 #define init_disk_util(td)
 #define setup_disk_util()
diff --git a/eta.c b/eta.c
index 3e8eb0b..7eb1c27 100644
--- a/eta.c
+++ b/eta.c
@@ -352,7 +352,7 @@ int calc_thread_status(struct jobs_eta *je, int force)
 	static struct timeval rate_prev_time, disp_prev_time;
 
 	if (!force) {
-		if (output_format != FIO_OUTPUT_NORMAL &&
+		if (!(output_format & FIO_OUTPUT_NORMAL) &&
 		    f_out == stdout)
 			return 0;
 		if (temp_stall_ts || eta_print == FIO_ETA_NEVER)
@@ -590,7 +590,7 @@ struct jobs_eta *get_jobs_eta(int force, size_t *size)
 	if (!thread_number)
 		return NULL;
 
-	*size = sizeof(*je) + THREAD_RUNSTR_SZ + 1;
+	*size = sizeof(*je) + THREAD_RUNSTR_SZ + 8;
 	je = malloc(*size);
 	if (!je)
 		return NULL;
diff --git a/filesetup.c b/filesetup.c
index e1dedcd..634d556 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -936,7 +936,7 @@ int setup_files(struct thread_data *td)
 	 */
 	if (need_extend) {
 		temp_stall_ts = 1;
-		if (output_format == FIO_OUTPUT_NORMAL)
+		if (output_format & FIO_OUTPUT_NORMAL)
 			log_info("%s: Laying out IO file(s) (%u file(s) /"
 				 " %lluMB)\n", o->name, need_extend,
 					extend_size >> 20);
diff --git a/fio.1 b/fio.1
index b049790..2ba36f9 100644
--- a/fio.1
+++ b/fio.1
@@ -22,6 +22,7 @@ Write output to \fIfilename\fR.
 .TP
 .BI \-\-output-format \fR=\fPformat
 Set the reporting format to \fInormal\fR, \fIterse\fR, or \fIjson\fR.
+Multiple formats can be selected, separate by a comma.
 .TP
 .BI \-\-runtime \fR=\fPruntime
 Limit run time to \fIruntime\fR seconds.
@@ -34,6 +35,7 @@ Print statistics in a terse, semicolon-delimited format.
 .TP
 .B \-\-append-terse
 Print statistics in selected mode AND terse, semicolon-delimited format.
+Deprecated, use \-\-output-format instead to select multiple formats.
 .TP
 .B \-\-version
 Display version information and exit.
diff --git a/fio.h b/fio.h
index adf879f..2dc445e 100644
--- a/fio.h
+++ b/fio.h
@@ -674,9 +674,14 @@ extern const char *fio_get_os_string(int);
 #endif
 
 enum {
-	FIO_OUTPUT_TERSE	= 0,
-	FIO_OUTPUT_JSON,
-	FIO_OUTPUT_NORMAL,
+	__FIO_OUTPUT_TERSE	= 0,
+	__FIO_OUTPUT_JSON	= 1,
+	__FIO_OUTPUT_NORMAL	= 2,
+	FIO_OUTPUT_NR		= 3,
+
+	FIO_OUTPUT_TERSE	= 1U << __FIO_OUTPUT_TERSE,
+	FIO_OUTPUT_JSON		= 1U << __FIO_OUTPUT_JSON,
+	FIO_OUTPUT_NORMAL	= 1U << __FIO_OUTPUT_NORMAL,
 };
 
 enum {
diff --git a/idletime.c b/idletime.c
index db272fe..5cc8b65 100644
--- a/idletime.c
+++ b/idletime.c
@@ -428,7 +428,7 @@ int fio_idle_prof_parse_opt(const char *args)
 		fio_idle_prof_init();
 		fio_idle_prof_start();
 		fio_idle_prof_stop();
-		show_idle_prof_stats(FIO_OUTPUT_NORMAL, NULL);
+		show_idle_prof_stats(FIO_OUTPUT_NORMAL, NULL, NULL);
 		return 1;
 	} else if (strcmp("system", args) == 0) {
 		ipc.opt = IDLE_PROF_OPT_SYSTEM;
@@ -446,7 +446,8 @@ int fio_idle_prof_parse_opt(const char *args)
 #endif
 }
 
-void show_idle_prof_stats(int output, struct json_object *parent)
+void show_idle_prof_stats(int output, struct json_object *parent,
+			  struct buf_output *out)
 {
 	int i, nr_cpus = ipc.nr_cpus;
 	struct json_object *tmp;
@@ -454,23 +455,23 @@ void show_idle_prof_stats(int output, struct json_object *parent)
 
 	if (output == FIO_OUTPUT_NORMAL) {
 		if (ipc.opt > IDLE_PROF_OPT_CALI)
-			log_info("\nCPU idleness:\n");
+			log_buf(out, "\nCPU idleness:\n");
 		else if (ipc.opt == IDLE_PROF_OPT_CALI)
-			log_info("CPU idleness:\n");
+			log_buf(out, "CPU idleness:\n");
 
 		if (ipc.opt >= IDLE_PROF_OPT_SYSTEM)
-			log_info("  system: %3.2f%%\n", fio_idle_prof_cpu_stat(-1));
+			log_buf(out, "  system: %3.2f%%\n", fio_idle_prof_cpu_stat(-1));
 
 		if (ipc.opt == IDLE_PROF_OPT_PERCPU) {
-			log_info("  percpu: %3.2f%%", fio_idle_prof_cpu_stat(0));
+			log_buf(out, "  percpu: %3.2f%%", fio_idle_prof_cpu_stat(0));
 			for (i = 1; i < nr_cpus; i++)
-				log_info(", %3.2f%%", fio_idle_prof_cpu_stat(i));
-			log_info("\n");
+				log_buf(out, ", %3.2f%%", fio_idle_prof_cpu_stat(i));
+			log_buf(out, "\n");
 		}
 
 		if (ipc.opt >= IDLE_PROF_OPT_CALI) {
-			log_info("  unit work: mean=%3.2fus,", ipc.cali_mean);
-			log_info(" stddev=%3.2f\n", ipc.cali_stddev);
+			log_buf(out, "  unit work: mean=%3.2fus,", ipc.cali_mean);
+			log_buf(out, " stddev=%3.2f\n", ipc.cali_stddev);
 		}
 
 		/* dynamic mem allocations can now be freed */
diff --git a/idletime.h b/idletime.h
index bd6dcef..84c1fbb 100644
--- a/idletime.h
+++ b/idletime.h
@@ -2,6 +2,7 @@
 #define FIO_IDLETIME_H
 
 #include "fio.h"
+#include "lib/output_buffer.h"
 
 #define CALIBRATE_RUNS  10
 #define CALIBRATE_SCALE 1000
@@ -54,6 +55,6 @@ extern void fio_idle_prof_init(void);
 extern void fio_idle_prof_start(void);
 extern void fio_idle_prof_stop(void);
 
-extern void show_idle_prof_stats(int, struct json_object *);
+extern void show_idle_prof_stats(int, struct json_object *, struct buf_output *);
 
 #endif
diff --git a/init.c b/init.c
index 3f72b36..4f5b7dc 100644
--- a/init.c
+++ b/init.c
@@ -48,7 +48,6 @@ static int nr_job_sections;
 
 int exitall_on_terminate = 0;
 int output_format = FIO_OUTPUT_NORMAL;
-int append_terse_output = 0;
 int eta_print = FIO_ETA_AUTO;
 int eta_new_line = 0;
 FILE *f_out = NULL;
@@ -1317,7 +1316,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if (!o->name)
 		o->name = strdup(jobname);
 
-	if (output_format == FIO_OUTPUT_NORMAL) {
+	if (output_format & FIO_OUTPUT_NORMAL) {
 		if (!job_add_num) {
 			if (is_backend && !recursed)
 				fio_server_send_add_job(td);
@@ -2009,6 +2008,35 @@ static void show_closest_option(const char *name)
 		log_err("Did you mean %s?\n", l_opts[best_option].name);
 }
 
+static int parse_output_format(const char *optarg)
+{
+	char *p, *orig, *opt;
+	int ret = 0;
+
+	p = orig = strdup(optarg);
+
+	output_format = 0;
+
+	while ((opt = strsep(&p, ",")) != NULL) {
+		if (!strcmp(opt, "minimal") ||
+		    !strcmp(opt, "terse") ||
+		    !strcmp(opt, "csv"))
+			output_format |= FIO_OUTPUT_TERSE;
+		else if (!strcmp(opt, "json"))
+			output_format |= FIO_OUTPUT_JSON;
+		else if (!strcmp(opt, "normal"))
+			output_format |= FIO_OUTPUT_NORMAL;
+		else {
+			log_err("fio: invalid output format %s\n", opt);
+			ret = 1;
+			break;
+		}
+	}
+
+	free(orig);
+	return ret;
+}
+
 int parse_cmd_line(int argc, char *argv[], int client_type)
 {
 	struct thread_data *td = NULL;
@@ -2070,17 +2098,15 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				do_exit++;
 				break;
 			}
-			if (!strcmp(optarg, "minimal") ||
-			    !strcmp(optarg, "terse") ||
-			    !strcmp(optarg, "csv"))
-				output_format = FIO_OUTPUT_TERSE;
-			else if (!strcmp(optarg, "json"))
-				output_format = FIO_OUTPUT_JSON;
-			else
-				output_format = FIO_OUTPUT_NORMAL;
+			if (parse_output_format(optarg)) {
+				log_err("fio: failed parsing output-format\n");
+				exit_val = 1;
+				do_exit++;
+				break;
+			}
 			break;
 		case 'f':
-			append_terse_output = 1;
+			output_format |= FIO_OUTPUT_TERSE;
 			break;
 		case 'h':
 			did_arg = 1;
@@ -2532,7 +2558,7 @@ int parse_options(int argc, char *argv[])
 		return 0;
 	}
 
-	if (output_format == FIO_OUTPUT_NORMAL)
+	if (output_format & FIO_OUTPUT_NORMAL)
 		log_info("%s\n", fio_version_string);
 
 	return 0;
diff --git a/json.c b/json.c
index 6145ee4..f3ec0bb 100644
--- a/json.c
+++ b/json.c
@@ -231,7 +231,7 @@ int json_object_add_value_type(struct json_object *obj, const char *name, int ty
 	return 0;
 }
 
-static void json_print_array(struct json_array *array);
+static void json_print_array(struct json_array *array, struct buf_output *);
 int json_array_add_value_type(struct json_array *array, int type, ...)
 {
 	struct json_value *value;
@@ -290,70 +290,70 @@ static int json_value_level(struct json_value *value)
 		return json_array_level(value->parent_array) + 1;
 }
 
-static void json_print_level(int level)
+static void json_print_level(int level, struct buf_output *out)
 {
 	while (level-- > 0)
-		log_info("  ");
+		log_buf(out, "  ");
 }
 
-static void json_print_pair(struct json_pair *pair);
-static void json_print_array(struct json_array *array);
-static void json_print_value(struct json_value *value);
-void json_print_object(struct json_object *obj)
+static void json_print_pair(struct json_pair *pair, struct buf_output *);
+static void json_print_array(struct json_array *array, struct buf_output *);
+static void json_print_value(struct json_value *value, struct buf_output *);
+void json_print_object(struct json_object *obj, struct buf_output *out)
 {
 	int i;
 
-	log_info("{\n");
+	log_buf(out, "{\n");
 	for (i = 0; i < obj->pair_cnt; i++) {
 		if (i > 0)
-			log_info(",\n");
-		json_print_pair(obj->pairs[i]);
+			log_buf(out, ",\n");
+		json_print_pair(obj->pairs[i], out);
 	}
-	log_info("\n");
-	json_print_level(json_object_level(obj));
-	log_info("}");
+	log_buf(out, "\n");
+	json_print_level(json_object_level(obj), out);
+	log_buf(out, "}");
 }
 
-static void json_print_pair(struct json_pair *pair)
+static void json_print_pair(struct json_pair *pair, struct buf_output *out)
 {
-	json_print_level(json_pair_level(pair));
-	log_info("\"%s\" : ", pair->name);
-	json_print_value(pair->value);
+	json_print_level(json_pair_level(pair), out);
+	log_buf(out, "\"%s\" : ", pair->name);
+	json_print_value(pair->value, out);
 }
 
-static void json_print_array(struct json_array *array)
+static void json_print_array(struct json_array *array, struct buf_output *out)
 {
 	int i;
 
-	log_info("[\n");
+	log_buf(out, "[\n");
 	for (i = 0; i < array->value_cnt; i++) {
 		if (i > 0)
-			log_info(",\n");
-		json_print_level(json_value_level(array->values[i]));
-		json_print_value(array->values[i]);
+			log_buf(out, ",\n");
+		json_print_level(json_value_level(array->values[i]), out);
+		json_print_value(array->values[i], out);
 	}
-	log_info("\n");
-	json_print_level(json_array_level(array));
-	log_info("]");
+	log_buf(out, "\n");
+	json_print_level(json_array_level(array), out);
+	log_buf(out, "]");
 }
 
-static void json_print_value(struct json_value *value)
+static void json_print_value(struct json_value *value, struct buf_output *out)
 {
 	switch (value->type) {
 	case JSON_TYPE_STRING:
-		log_info("\"%s\"", value->string);
+		log_buf(out, "\"%s\"", value->string);
 		break;
 	case JSON_TYPE_INTEGER:
-		log_info("%lld", value->integer_number);
+		log_buf(out, "%lld", value->integer_number);
 		break;
 	case JSON_TYPE_FLOAT:
-		log_info("%.2f", value->float_number);
+		log_buf(out, "%.2f", value->float_number);
 		break;
 	case JSON_TYPE_OBJECT:
-		json_print_object(value->object);
+		json_print_object(value->object, out);
 		break;
 	case JSON_TYPE_ARRAY:
-		json_print_array(value->array);
+		json_print_array(value->array, out);
 		break;
 	}
 }
diff --git a/json.h b/json.h
index 962c11c..d7017e0 100644
--- a/json.h
+++ b/json.h
@@ -1,5 +1,8 @@
 #ifndef __JSON__H
 #define __JSON__H
+
+#include "lib/output_buffer.h"
+
 struct json_object;
 struct json_array;
 struct json_pair;
@@ -76,5 +79,5 @@ int json_array_add_value_type(struct json_array *array, int type, ...);
 #define json_array_last_value_object(obj) \
 	(obj->values[obj->value_cnt - 1]->object)
 
-void json_print_object(struct json_object *obj);
+void json_print_object(struct json_object *obj, struct buf_output *out);
 #endif
diff --git a/lib/output_buffer.c b/lib/output_buffer.c
new file mode 100644
index 0000000..03cd848
--- /dev/null
+++ b/lib/output_buffer.c
@@ -0,0 +1,48 @@
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+
+#include "output_buffer.h"
+#include "../log.h"
+
+#define BUF_INC	1024
+
+void buf_output_init(struct buf_output *out)
+{
+	out->max_buflen = 0;
+	out->buflen = 0;
+	out->buf = NULL;
+}
+
+void buf_output_free(struct buf_output *out)
+{
+	free(out->buf);
+}
+
+size_t buf_output_add(struct buf_output *out, const char *buf, size_t len)
+{
+	while (out->max_buflen - out->buflen < len) {
+		size_t old_max = out->max_buflen;
+
+		out->max_buflen += BUF_INC;
+		out->buf = realloc(out->buf, out->max_buflen);
+		memset(&out->buf[old_max], 0, BUF_INC);
+	}
+
+	memcpy(&out->buf[out->buflen], buf, len);
+	out->buflen += len;
+	return len;
+}
+
+size_t buf_output_flush(struct buf_output *out)
+{
+	size_t ret = 0;
+
+	if (out->buflen) {
+		ret = log_info_buf(out->buf, out->buflen);
+		memset(out->buf, 0, out->max_buflen);
+		out->buflen = 0;
+	}
+
+	return ret;
+}
diff --git a/lib/output_buffer.h b/lib/output_buffer.h
new file mode 100644
index 0000000..396002f
--- /dev/null
+++ b/lib/output_buffer.h
@@ -0,0 +1,17 @@
+#ifndef FIO_OUTPUT_BUFFER_H
+#define FIO_OUTPUT_BUFFER_H
+
+#include <unistd.h>
+
+struct buf_output {
+	char *buf;
+	size_t buflen;
+	size_t max_buflen;
+};
+
+void buf_output_init(struct buf_output *out);
+void buf_output_free(struct buf_output *out);
+size_t buf_output_add(struct buf_output *out, const char *buf, size_t len);
+size_t buf_output_flush(struct buf_output *out);
+
+#endif
diff --git a/log.c b/log.c
index c4a3b52..8d511b5 100644
--- a/log.c
+++ b/log.c
@@ -6,25 +6,28 @@
 
 #include "fio.h"
 
-int log_valist(const char *str, va_list args)
+size_t log_info_buf(const char *buf, size_t len)
+{
+	if (is_backend)
+		return fio_server_text_output(FIO_LOG_INFO, buf, len);
+	else if (log_syslog) {
+		syslog(LOG_INFO, "%s", buf);
+		return len;
+	} else
+		return fwrite(buf, len, 1, f_out);
+}
+
+size_t log_valist(const char *str, va_list args)
 {
 	char buffer[1024];
 	size_t len;
 
 	len = vsnprintf(buffer, sizeof(buffer), str, args);
-	len = min(len, sizeof(buffer) - 1);
-
-	if (is_backend)
-		len = fio_server_text_output(FIO_LOG_INFO, buffer, len);
-	if (log_syslog)
-		syslog(LOG_INFO, "%s", buffer);
-	else
-		len = fwrite(buffer, len, 1, f_out);
 
-	return len;
+	return log_info_buf(buffer, min(len, sizeof(buffer) - 1));
 }
 
-int log_local_buf(const char *buf, size_t len)
+size_t log_local_buf(const char *buf, size_t len)
 {
 	if (log_syslog)
 		syslog(LOG_INFO, "%s", buf);
@@ -34,7 +37,20 @@ int log_local_buf(const char *buf, size_t len)
 	return len;
 }
 
-int log_info(const char *format, ...)
+size_t log_info(const char *format, ...)
+{
+	char buffer[1024];
+	va_list args;
+	size_t len;
+
+	va_start(args, format);
+	len = vsnprintf(buffer, sizeof(buffer), format, args);
+	va_end(args);
+
+	return log_info_buf(buffer, min(len, sizeof(buffer) - 1));
+}
+
+size_t __log_buf(struct buf_output *buf, const char *format, ...)
 {
 	char buffer[1024];
 	va_list args;
@@ -45,13 +61,7 @@ int log_info(const char *format, ...)
 	va_end(args);
 	len = min(len, sizeof(buffer) - 1);
 
-	if (is_backend)
-		return fio_server_text_output(FIO_LOG_INFO, buffer, len);
-	else if (log_syslog) {
-		syslog(LOG_INFO, "%s", buffer);
-		return len;
-	} else
-		return fwrite(buffer, len, 1, f_out);
+	return buf_output_add(buf, buffer, len);
 }
 
 int log_info_flush(void)
@@ -62,7 +72,7 @@ int log_info_flush(void)
 	return fflush(f_out);
 }
 
-int log_err(const char *format, ...)
+size_t log_err(const char *format, ...)
 {
 	char buffer[1024];
 	va_list args;
diff --git a/log.h b/log.h
index e509313..f1cf003 100644
--- a/log.h
+++ b/log.h
@@ -4,15 +4,27 @@
 #include <stdio.h>
 #include <stdarg.h>
 
+#include "lib/output_buffer.h"
+
 extern FILE *f_out;
 extern FILE *f_err;
 
-extern int log_err(const char *format, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
-extern int log_info(const char *format, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
-extern int log_valist(const char *str, va_list);
-extern int log_local_buf(const char *buf, size_t);
+extern size_t log_err(const char *format, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
+extern size_t log_info(const char *format, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
+extern size_t __log_buf(struct buf_output *, const char *format, ...) __attribute__ ((__format__ (__printf__, 2, 3)));
+extern size_t log_valist(const char *str, va_list);
+extern size_t log_local_buf(const char *buf, size_t);
+extern size_t log_info_buf(const char *buf, size_t len);
 extern int log_info_flush(void);
 
+#define log_buf(buf, format, args...)		\
+do {						\
+	if ((buf) != NULL)			\
+		__log_buf(buf, format, ##args);	\
+	else					\
+		log_info(format, ##args);	\
+} while (0)
+
 enum {
 	FIO_LOG_DEBUG	= 1,
 	FIO_LOG_INFO	= 2,
diff --git a/parse.c b/parse.c
index 3e94c7d..e330dea 100644
--- a/parse.c
+++ b/parse.c
@@ -52,7 +52,7 @@ static void posval_sort(struct fio_option *o, struct value_pair *vpmap)
 }
 
 static void show_option_range(struct fio_option *o,
-				int (*logger)(const char *format, ...))
+			      size_t (*logger)(const char *format, ...))
 {
 	if (o->type == FIO_OPT_FLOAT_LIST) {
 		if (o->minfp == DBL_MIN && o->maxfp == DBL_MAX)
@@ -109,7 +109,7 @@ static void show_option_help(struct fio_option *o, int is_err)
 		"no argument (opt)",
 		"deprecated",
 	};
-	int (*logger)(const char *format, ...);
+	size_t (*logger)(const char *format, ...);
 
 	if (is_err)
 		logger = log_err;
diff --git a/stat.c b/stat.c
index 00eb75d..2a65fed 100644
--- a/stat.c
+++ b/stat.c
@@ -14,6 +14,7 @@
 #include "lib/getrusage.h"
 #include "idletime.h"
 #include "lib/pow2.h"
+#include "lib/output_buffer.h"
 
 struct fio_mutex *stat_mutex;
 
@@ -183,7 +184,8 @@ unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
  * Find and display the p-th percentile of clat
  */
 static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
-				  fio_fp64_t *plist, unsigned int precision)
+				  fio_fp64_t *plist, unsigned int precision,
+				  struct buf_output *out)
 {
 	unsigned int len, j = 0, minv, maxv;
 	unsigned int *ovals;
@@ -200,10 +202,10 @@ static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 	 */
 	if (minv > 2000 && maxv > 99999) {
 		scale_down = 1;
-		log_info("    clat percentiles (msec):\n     |");
+		log_buf(out, "    clat percentiles (msec):\n     |");
 	} else {
 		scale_down = 0;
-		log_info("    clat percentiles (usec):\n     |");
+		log_buf(out, "    clat percentiles (usec):\n     |");
 	}
 
 	snprintf(fmt, sizeof(fmt), "%%1.%uf", precision);
@@ -214,7 +216,7 @@ static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 
 		/* for formatting */
 		if (j != 0 && (j % per_line) == 0)
-			log_info("     |");
+			log_buf(out, "     |");
 
 		/* end of the list */
 		is_last = (j == len - 1);
@@ -227,13 +229,13 @@ static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 		if (scale_down)
 			ovals[j] = (ovals[j] + 999) / 1000;
 
-		log_info(" %sth=[%5u]%c", fbuf, ovals[j], is_last ? '\n' : ',');
+		log_buf(out, " %sth=[%5u]%c", fbuf, ovals[j], is_last ? '\n' : ',');
 
 		if (is_last)
 			break;
 
 		if ((j % per_line) == per_line - 1)	/* for formatting */
-			log_info("\n");
+			log_buf(out, "\n");
 	}
 
 out:
@@ -261,13 +263,13 @@ int calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max,
 	return 1;
 }
 
-void show_group_stats(struct group_run_stats *rs)
+void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
 {
 	char *p1, *p2, *p3, *p4;
 	const char *str[] = { "   READ", "  WRITE" , "   TRIM"};
 	int i;
 
-	log_info("\nRun status group %d (all jobs):\n", rs->groupid);
+	log_buf(out, "\nRun status group %d (all jobs):\n", rs->groupid);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		const int i2p = is_power_of_2(rs->kb_base);
@@ -280,7 +282,7 @@ void show_group_stats(struct group_run_stats *rs)
 		p3 = num2str(rs->min_bw[i], 6, rs->kb_base, i2p, rs->unit_base);
 		p4 = num2str(rs->max_bw[i], 6, rs->kb_base, i2p, rs->unit_base);
 
-		log_info("%s: io=%s, aggrb=%s/s, minb=%s/s, maxb=%s/s,"
+		log_buf(out, "%s: io=%s, aggrb=%s/s, minb=%s/s, maxb=%s/s,"
 			 " mint=%llumsec, maxt=%llumsec\n",
 				rs->unified_rw_rep ? "  MIXED" : str[i],
 				p1, p2, p3, p4,
@@ -343,7 +345,7 @@ void stat_calc_lat_m(struct thread_stat *ts, double *io_u_lat)
 }
 
 static void display_lat(const char *name, unsigned long min, unsigned long max,
-			double mean, double dev)
+			double mean, double dev, struct buf_output *out)
 {
 	const char *base = "(usec)";
 	char *minp, *maxp;
@@ -354,7 +356,7 @@ static void display_lat(const char *name, unsigned long min, unsigned long max,
 	minp = num2str(min, 6, 1, 0, 0);
 	maxp = num2str(max, 6, 1, 0, 0);
 
-	log_info("    %s %s: min=%s, max=%s, avg=%5.02f,"
+	log_buf(out, "    %s %s: min=%s, max=%s, avg=%5.02f,"
 		 " stdev=%5.02f\n", name, base, minp, maxp, mean, dev);
 
 	free(minp);
@@ -362,7 +364,7 @@ static void display_lat(const char *name, unsigned long min, unsigned long max,
 }
 
 static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
-			     int ddir)
+			     int ddir, struct buf_output *out)
 {
 	const char *str[] = { "read ", "write", "trim" };
 	unsigned long min, max, runt;
@@ -386,7 +388,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	iops = (1000 * (uint64_t)ts->total_io_u[ddir]) / runt;
 	iops_p = num2str(iops, 6, 1, 0, 0);
 
-	log_info("  %s: io=%s, bw=%s/s, iops=%s, runt=%6llumsec\n",
+	log_buf(out, "  %s: io=%s, bw=%s/s, iops=%s, runt=%6llumsec\n",
 				rs->unified_rw_rep ? "mixed" : str[ddir],
 				io_p, bw_p, iops_p,
 				(unsigned long long) ts->runtime[ddir]);
@@ -396,17 +398,17 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	free(iops_p);
 
 	if (calc_lat(&ts->slat_stat[ddir], &min, &max, &mean, &dev))
-		display_lat("slat", min, max, mean, dev);
+		display_lat("slat", min, max, mean, dev, out);
 	if (calc_lat(&ts->clat_stat[ddir], &min, &max, &mean, &dev))
-		display_lat("clat", min, max, mean, dev);
+		display_lat("clat", min, max, mean, dev, out);
 	if (calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev))
-		display_lat(" lat", min, max, mean, dev);
+		display_lat(" lat", min, max, mean, dev, out);
 
 	if (ts->clat_percentiles) {
 		show_clat_percentiles(ts->io_u_plat[ddir],
 					ts->clat_stat[ddir].samples,
 					ts->percentile_list,
-					ts->percentile_precision);
+					ts->percentile_precision, out);
 	}
 	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
 		double p_of_agg = 100.0, fkb_base = (double)rs->kb_base;
@@ -433,14 +435,14 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			bw_str = (rs->unit_base == 1 ? "Mbit" : "MB");
 		}
 
-		log_info("    bw (%-4s/s): min=%5lu, max=%5lu, per=%3.2f%%,"
+		log_buf(out, "    bw (%-4s/s): min=%5lu, max=%5lu, per=%3.2f%%,"
 			 " avg=%5.02f, stdev=%5.02f\n", bw_str, min, max,
 							p_of_agg, mean, dev);
 	}
 }
 
 static int show_lat(double *io_u_lat, int nr, const char **ranges,
-		    const char *msg)
+		    const char *msg, struct buf_output *out)
 {
 	int new_line = 1, i, line = 0, shown = 0;
 
@@ -450,43 +452,43 @@ static int show_lat(double *io_u_lat, int nr, const char **ranges,
 		shown = 1;
 		if (new_line) {
 			if (line)
-				log_info("\n");
-			log_info("    lat (%s) : ", msg);
+				log_buf(out, "\n");
+			log_buf(out, "    lat (%s) : ", msg);
 			new_line = 0;
 			line = 0;
 		}
 		if (line)
-			log_info(", ");
-		log_info("%s%3.2f%%", ranges[i], io_u_lat[i]);
+			log_buf(out, ", ");
+		log_buf(out, "%s%3.2f%%", ranges[i], io_u_lat[i]);
 		line++;
 		if (line == 5)
 			new_line = 1;
 	}
 
 	if (shown)
-		log_info("\n");
+		log_buf(out, "\n");
 
 	return shown;
 }
 
-static void show_lat_u(double *io_u_lat_u)
+static void show_lat_u(double *io_u_lat_u, struct buf_output *out)
 {
 	const char *ranges[] = { "2=", "4=", "10=", "20=", "50=", "100=",
 				 "250=", "500=", "750=", "1000=", };
 
-	show_lat(io_u_lat_u, FIO_IO_U_LAT_U_NR, ranges, "usec");
+	show_lat(io_u_lat_u, FIO_IO_U_LAT_U_NR, ranges, "usec", out);
 }
 
-static void show_lat_m(double *io_u_lat_m)
+static void show_lat_m(double *io_u_lat_m, struct buf_output *out)
 {
 	const char *ranges[] = { "2=", "4=", "10=", "20=", "50=", "100=",
 				 "250=", "500=", "750=", "1000=", "2000=",
 				 ">=2000=", };
 
-	show_lat(io_u_lat_m, FIO_IO_U_LAT_M_NR, ranges, "msec");
+	show_lat(io_u_lat_m, FIO_IO_U_LAT_M_NR, ranges, "msec", out);
 }
 
-static void show_latencies(struct thread_stat *ts)
+static void show_latencies(struct thread_stat *ts, struct buf_output *out)
 {
 	double io_u_lat_u[FIO_IO_U_LAT_U_NR];
 	double io_u_lat_m[FIO_IO_U_LAT_M_NR];
@@ -494,8 +496,8 @@ static void show_latencies(struct thread_stat *ts)
 	stat_calc_lat_u(ts, io_u_lat_u);
 	stat_calc_lat_m(ts, io_u_lat_m);
 
-	show_lat_u(io_u_lat_u);
-	show_lat_m(io_u_lat_m);
+	show_lat_u(io_u_lat_u, out);
+	show_lat_m(io_u_lat_m, out);
 }
 
 static int block_state_category(int block_state)
@@ -604,7 +606,7 @@ static const char *block_state_names[] = {
 };
 
 static void show_block_infos(int nr_block_infos, uint32_t *block_infos,
-			     fio_fp64_t *plist)
+			     fio_fp64_t *plist, struct buf_output *out)
 {
 	int len, pos, i;
 	unsigned int *percentiles = NULL;
@@ -613,7 +615,7 @@ static void show_block_infos(int nr_block_infos, uint32_t *block_infos,
 	len = calc_block_percentiles(nr_block_infos, block_infos, plist,
 				     &percentiles, block_state_counts);
 
-	log_info("  block lifetime percentiles :\n   |");
+	log_buf(out, "  block lifetime percentiles :\n   |");
 	pos = 0;
 	for (i = 0; i < len; i++) {
 		uint32_t block_info = percentiles[i];
@@ -625,24 +627,25 @@ static void show_block_infos(int nr_block_infos, uint32_t *block_infos,
 		assert(strln < LINE_LENGTH);
 		if (pos + strln > LINE_LENGTH) {
 			pos = 0;
-			log_info("\n   |");
+			log_buf(out, "\n   |");
 		}
-		log_info("%s", str);
+		log_buf(out, "%s", str);
 		pos += strln;
 #undef LINE_LENGTH
 	}
 	if (percentiles)
 		free(percentiles);
 
-	log_info("        states               :");
+	log_buf(out, "        states               :");
 	for (i = 0; i < BLOCK_STATE_COUNT; i++)
-		log_info(" %s=%u%c",
+		log_buf(out, " %s=%u%c",
 			 block_state_names[i], block_state_counts[i],
 			 i == BLOCK_STATE_COUNT - 1 ? '\n' : ',');
 }
 
 static void show_thread_status_normal(struct thread_stat *ts,
-				      struct group_run_stats *rs)
+				      struct group_run_stats *rs,
+				      struct buf_output *out)
 {
 	double usr_cpu, sys_cpu;
 	unsigned long runtime;
@@ -657,27 +660,27 @@ static void show_thread_status_normal(struct thread_stat *ts,
 	os_ctime_r((const time_t *) &time_p, time_buf, sizeof(time_buf));
 
 	if (!ts->error) {
-		log_info("%s: (groupid=%d, jobs=%d): err=%2d: pid=%d: %s",
+		log_buf(out, "%s: (groupid=%d, jobs=%d): err=%2d: pid=%d: %s",
 					ts->name, ts->groupid, ts->members,
 					ts->error, (int) ts->pid, time_buf);
 	} else {
-		log_info("%s: (groupid=%d, jobs=%d): err=%2d (%s): pid=%d: %s",
+		log_buf(out, "%s: (groupid=%d, jobs=%d): err=%2d (%s): pid=%d: %s",
 					ts->name, ts->groupid, ts->members,
 					ts->error, ts->verror, (int) ts->pid,
 					time_buf);
 	}
 
 	if (strlen(ts->description))
-		log_info("  Description  : [%s]\n", ts->description);
+		log_buf(out, "  Description  : [%s]\n", ts->description);
 
 	if (ts->io_bytes[DDIR_READ])
-		show_ddir_status(rs, ts, DDIR_READ);
+		show_ddir_status(rs, ts, DDIR_READ, out);
 	if (ts->io_bytes[DDIR_WRITE])
-		show_ddir_status(rs, ts, DDIR_WRITE);
+		show_ddir_status(rs, ts, DDIR_WRITE, out);
 	if (ts->io_bytes[DDIR_TRIM])
-		show_ddir_status(rs, ts, DDIR_TRIM);
+		show_ddir_status(rs, ts, DDIR_TRIM, out);
 
-	show_latencies(ts);
+	show_latencies(ts, out);
 
 	runtime = ts->total_run_time;
 	if (runtime) {
@@ -690,32 +693,32 @@ static void show_thread_status_normal(struct thread_stat *ts,
 		sys_cpu = 0;
 	}
 
-	log_info("  cpu          : usr=%3.2f%%, sys=%3.2f%%, ctx=%llu,"
+	log_buf(out, "  cpu          : usr=%3.2f%%, sys=%3.2f%%, ctx=%llu,"
 		 " majf=%llu, minf=%llu\n", usr_cpu, sys_cpu,
 			(unsigned long long) ts->ctx,
 			(unsigned long long) ts->majf,
 			(unsigned long long) ts->minf);
 
 	stat_calc_dist(ts->io_u_map, ddir_rw_sum(ts->total_io_u), io_u_dist);
-	log_info("  IO depths    : 1=%3.1f%%, 2=%3.1f%%, 4=%3.1f%%, 8=%3.1f%%,"
+	log_buf(out, "  IO depths    : 1=%3.1f%%, 2=%3.1f%%, 4=%3.1f%%, 8=%3.1f%%,"
 		 " 16=%3.1f%%, 32=%3.1f%%, >=64=%3.1f%%\n", io_u_dist[0],
 					io_u_dist[1], io_u_dist[2],
 					io_u_dist[3], io_u_dist[4],
 					io_u_dist[5], io_u_dist[6]);
 
 	stat_calc_dist(ts->io_u_submit, ts->total_submit, io_u_dist);
-	log_info("     submit    : 0=%3.1f%%, 4=%3.1f%%, 8=%3.1f%%, 16=%3.1f%%,"
+	log_buf(out, "     submit    : 0=%3.1f%%, 4=%3.1f%%, 8=%3.1f%%, 16=%3.1f%%,"
 		 " 32=%3.1f%%, 64=%3.1f%%, >=64=%3.1f%%\n", io_u_dist[0],
 					io_u_dist[1], io_u_dist[2],
 					io_u_dist[3], io_u_dist[4],
 					io_u_dist[5], io_u_dist[6]);
 	stat_calc_dist(ts->io_u_complete, ts->total_complete, io_u_dist);
-	log_info("     complete  : 0=%3.1f%%, 4=%3.1f%%, 8=%3.1f%%, 16=%3.1f%%,"
+	log_buf(out, "     complete  : 0=%3.1f%%, 4=%3.1f%%, 8=%3.1f%%, 16=%3.1f%%,"
 		 " 32=%3.1f%%, 64=%3.1f%%, >=64=%3.1f%%\n", io_u_dist[0],
 					io_u_dist[1], io_u_dist[2],
 					io_u_dist[3], io_u_dist[4],
 					io_u_dist[5], io_u_dist[6]);
-	log_info("     issued    : total=r=%llu/w=%llu/d=%llu,"
+	log_buf(out, "     issued    : total=r=%llu/w=%llu/d=%llu,"
 				 " short=r=%llu/w=%llu/d=%llu,"
 				 " drop=r=%llu/w=%llu/d=%llu\n",
 					(unsigned long long) ts->total_io_u[0],
@@ -728,13 +731,13 @@ static void show_thread_status_normal(struct thread_stat *ts,
 					(unsigned long long) ts->drop_io_u[1],
 					(unsigned long long) ts->drop_io_u[2]);
 	if (ts->continue_on_error) {
-		log_info("     errors    : total=%llu, first_error=%d/<%s>\n",
+		log_buf(out, "     errors    : total=%llu, first_error=%d/<%s>\n",
 					(unsigned long long)ts->total_err_count,
 					ts->first_error,
 					strerror(ts->first_error));
 	}
 	if (ts->latency_depth) {
-		log_info("     latency   : target=%llu, window=%llu, percentile=%.2f%%, depth=%u\n",
+		log_buf(out, "     latency   : target=%llu, window=%llu, percentile=%.2f%%, depth=%u\n",
 					(unsigned long long)ts->latency_target,
 					(unsigned long long)ts->latency_window,
 					ts->latency_percentile.u.f,
@@ -743,11 +746,12 @@ static void show_thread_status_normal(struct thread_stat *ts,
 
 	if (ts->nr_block_infos)
 		show_block_infos(ts->nr_block_infos, ts->block_infos,
-				  ts->percentile_list);
+				  ts->percentile_list, out);
 }
 
 static void show_ddir_status_terse(struct thread_stat *ts,
-				   struct group_run_stats *rs, int ddir)
+				   struct group_run_stats *rs, int ddir,
+				   struct buf_output *out)
 {
 	unsigned long min, max;
 	unsigned long long bw, iops;
@@ -766,19 +770,19 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 		iops = (1000 * (uint64_t) ts->total_io_u[ddir]) / runt;
 	}
 
-	log_info(";%llu;%llu;%llu;%llu",
+	log_buf(out, ";%llu;%llu;%llu;%llu",
 		(unsigned long long) ts->io_bytes[ddir] >> 10, bw, iops,
 					(unsigned long long) ts->runtime[ddir]);
 
 	if (calc_lat(&ts->slat_stat[ddir], &min, &max, &mean, &dev))
-		log_info(";%lu;%lu;%f;%f", min, max, mean, dev);
+		log_buf(out, ";%lu;%lu;%f;%f", min, max, mean, dev);
 	else
-		log_info(";%lu;%lu;%f;%f", 0UL, 0UL, 0.0, 0.0);
+		log_buf(out, ";%lu;%lu;%f;%f", 0UL, 0UL, 0.0, 0.0);
 
 	if (calc_lat(&ts->clat_stat[ddir], &min, &max, &mean, &dev))
-		log_info(";%lu;%lu;%f;%f", min, max, mean, dev);
+		log_buf(out, ";%lu;%lu;%f;%f", min, max, mean, dev);
 	else
-		log_info(";%lu;%lu;%f;%f", 0UL, 0UL, 0.0, 0.0);
+		log_buf(out, ";%lu;%lu;%f;%f", 0UL, 0UL, 0.0, 0.0);
 
 	if (ts->clat_percentiles) {
 		len = calc_clat_percentiles(ts->io_u_plat[ddir],
@@ -790,16 +794,16 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
 		if (i >= len) {
-			log_info(";0%%=0");
+			log_buf(out, ";0%%=0");
 			continue;
 		}
-		log_info(";%f%%=%u", ts->percentile_list[i].u.f, ovals[i]);
+		log_buf(out, ";%f%%=%u", ts->percentile_list[i].u.f, ovals[i]);
 	}
 
 	if (calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev))
-		log_info(";%lu;%lu;%f;%f", min, max, mean, dev);
+		log_buf(out, ";%lu;%lu;%f;%f", min, max, mean, dev);
 	else
-		log_info(";%lu;%lu;%f;%f", 0UL, 0UL, 0.0, 0.0);
+		log_buf(out, ";%lu;%lu;%f;%f", 0UL, 0UL, 0.0, 0.0);
 
 	if (ovals)
 		free(ovals);
@@ -813,9 +817,9 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 				p_of_agg = 100.0;
 		}
 
-		log_info(";%lu;%lu;%f%%;%f;%f", min, max, p_of_agg, mean, dev);
+		log_buf(out, ";%lu;%lu;%f%%;%f;%f", min, max, p_of_agg, mean, dev);
 	} else
-		log_info(";%lu;%lu;%f%%;%f;%f", 0UL, 0UL, 0.0, 0.0, 0.0);
+		log_buf(out, ";%lu;%lu;%f%%;%f;%f", 0UL, 0UL, 0.0, 0.0, 0.0);
 }
 
 static void add_ddir_status_json(struct thread_stat *ts,
@@ -930,7 +934,8 @@ static void add_ddir_status_json(struct thread_stat *ts,
 }
 
 static void show_thread_status_terse_v2(struct thread_stat *ts,
-					struct group_run_stats *rs)
+					struct group_run_stats *rs,
+					struct buf_output *out)
 {
 	double io_u_dist[FIO_IO_U_MAP_NR];
 	double io_u_lat_u[FIO_IO_U_LAT_U_NR];
@@ -939,13 +944,13 @@ static void show_thread_status_terse_v2(struct thread_stat *ts,
 	int i;
 
 	/* General Info */
-	log_info("2;%s;%d;%d", ts->name, ts->groupid, ts->error);
+	log_buf(out, "2;%s;%d;%d", ts->name, ts->groupid, ts->error);
 	/* Log Read Status */
-	show_ddir_status_terse(ts, rs, DDIR_READ);
+	show_ddir_status_terse(ts, rs, DDIR_READ, out);
 	/* Log Write Status */
-	show_ddir_status_terse(ts, rs, DDIR_WRITE);
+	show_ddir_status_terse(ts, rs, DDIR_WRITE, out);
 	/* Log Trim Status */
-	show_ddir_status_terse(ts, rs, DDIR_TRIM);
+	show_ddir_status_terse(ts, rs, DDIR_TRIM, out);
 
 	/* CPU Usage */
 	if (ts->total_run_time) {
@@ -958,7 +963,7 @@ static void show_thread_status_terse_v2(struct thread_stat *ts,
 		sys_cpu = 0;
 	}
 
-	log_info(";%f%%;%f%%;%llu;%llu;%llu", usr_cpu, sys_cpu,
+	log_buf(out, ";%f%%;%f%%;%llu;%llu;%llu", usr_cpu, sys_cpu,
 						(unsigned long long) ts->ctx,
 						(unsigned long long) ts->majf,
 						(unsigned long long) ts->minf);
@@ -969,30 +974,31 @@ static void show_thread_status_terse_v2(struct thread_stat *ts,
 	stat_calc_lat_m(ts, io_u_lat_m);
 
 	/* Only show fixed 7 I/O depth levels*/
-	log_info(";%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%",
+	log_buf(out, ";%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%",
 			io_u_dist[0], io_u_dist[1], io_u_dist[2], io_u_dist[3],
 			io_u_dist[4], io_u_dist[5], io_u_dist[6]);
 
 	/* Microsecond latency */
 	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++)
-		log_info(";%3.2f%%", io_u_lat_u[i]);
+		log_buf(out, ";%3.2f%%", io_u_lat_u[i]);
 	/* Millisecond latency */
 	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
-		log_info(";%3.2f%%", io_u_lat_m[i]);
+		log_buf(out, ";%3.2f%%", io_u_lat_m[i]);
 	/* Additional output if continue_on_error set - default off*/
 	if (ts->continue_on_error)
-		log_info(";%llu;%d", (unsigned long long) ts->total_err_count, ts->first_error);
-	log_info("\n");
+		log_buf(out, ";%llu;%d", (unsigned long long) ts->total_err_count, ts->first_error);
+	log_buf(out, "\n");
 
 	/* Additional output if description is set */
 	if (strlen(ts->description))
-		log_info(";%s", ts->description);
+		log_buf(out, ";%s", ts->description);
 
-	log_info("\n");
+	log_buf(out, "\n");
 }
 
 static void show_thread_status_terse_v3_v4(struct thread_stat *ts,
-					   struct group_run_stats *rs, int ver)
+					   struct group_run_stats *rs, int ver,
+					   struct buf_output *out)
 {
 	double io_u_dist[FIO_IO_U_MAP_NR];
 	double io_u_lat_u[FIO_IO_U_LAT_U_NR];
@@ -1001,15 +1007,15 @@ static void show_thread_status_terse_v3_v4(struct thread_stat *ts,
 	int i;
 
 	/* General Info */
-	log_info("%d;%s;%s;%d;%d", ver, fio_version_string,
+	log_buf(out, "%d;%s;%s;%d;%d", ver, fio_version_string,
 					ts->name, ts->groupid, ts->error);
 	/* Log Read Status */
-	show_ddir_status_terse(ts, rs, DDIR_READ);
+	show_ddir_status_terse(ts, rs, DDIR_READ, out);
 	/* Log Write Status */
-	show_ddir_status_terse(ts, rs, DDIR_WRITE);
+	show_ddir_status_terse(ts, rs, DDIR_WRITE, out);
 	/* Log Trim Status */
 	if (ver == 4)
-		show_ddir_status_terse(ts, rs, DDIR_TRIM);
+		show_ddir_status_terse(ts, rs, DDIR_TRIM, out);
 
 	/* CPU Usage */
 	if (ts->total_run_time) {
@@ -1022,7 +1028,7 @@ static void show_thread_status_terse_v3_v4(struct thread_stat *ts,
 		sys_cpu = 0;
 	}
 
-	log_info(";%f%%;%f%%;%llu;%llu;%llu", usr_cpu, sys_cpu,
+	log_buf(out, ";%f%%;%f%%;%llu;%llu;%llu", usr_cpu, sys_cpu,
 						(unsigned long long) ts->ctx,
 						(unsigned long long) ts->majf,
 						(unsigned long long) ts->minf);
@@ -1033,29 +1039,29 @@ static void show_thread_status_terse_v3_v4(struct thread_stat *ts,
 	stat_calc_lat_m(ts, io_u_lat_m);
 
 	/* Only show fixed 7 I/O depth levels*/
-	log_info(";%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%",
+	log_buf(out, ";%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%",
 			io_u_dist[0], io_u_dist[1], io_u_dist[2], io_u_dist[3],
 			io_u_dist[4], io_u_dist[5], io_u_dist[6]);
 
 	/* Microsecond latency */
 	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++)
-		log_info(";%3.2f%%", io_u_lat_u[i]);
+		log_buf(out, ";%3.2f%%", io_u_lat_u[i]);
 	/* Millisecond latency */
 	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
-		log_info(";%3.2f%%", io_u_lat_m[i]);
+		log_buf(out, ";%3.2f%%", io_u_lat_m[i]);
 
 	/* disk util stats, if any */
-	show_disk_util(1, NULL);
+	show_disk_util(1, NULL, out);
 
 	/* Additional output if continue_on_error set - default off*/
 	if (ts->continue_on_error)
-		log_info(";%llu;%d", (unsigned long long) ts->total_err_count, ts->first_error);
+		log_buf(out, ";%llu;%d", (unsigned long long) ts->total_err_count, ts->first_error);
 
 	/* Additional output if description is set */
 	if (strlen(ts->description))
-		log_info(";%s", ts->description);
+		log_buf(out, ";%s", ts->description);
 
-	log_info("\n");
+	log_buf(out, "\n");
 }
 
 static struct json_object *show_thread_status_json(struct thread_stat *ts,
@@ -1070,7 +1076,6 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	int i;
 	size_t size;
 
-
 	root = json_create_object();
 	json_object_add_value_string(root, "jobname", ts->name);
 	json_object_add_value_int(root, "groupid", ts->groupid);
@@ -1078,9 +1083,10 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 
 	/* ETA Info */
 	je = get_jobs_eta(1, &size);
-	json_object_add_value_int(root, "eta", je->eta_sec);
-	json_object_add_value_int(root, "elapsed", je->elapsed_sec);
-
+	if (je) {
+		json_object_add_value_int(root, "eta", je->eta_sec);
+		json_object_add_value_int(root, "elapsed", je->elapsed_sec);
+	}
 
 	add_ddir_status_json(ts, rs, DDIR_READ, root);
 	add_ddir_status_json(ts, rs, DDIR_WRITE, root);
@@ -1198,26 +1204,31 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 }
 
 static void show_thread_status_terse(struct thread_stat *ts,
-				     struct group_run_stats *rs)
+				     struct group_run_stats *rs,
+				     struct buf_output *out)
 {
 	if (terse_version == 2)
-		show_thread_status_terse_v2(ts, rs);
+		show_thread_status_terse_v2(ts, rs, out);
 	else if (terse_version == 3 || terse_version == 4)
-		show_thread_status_terse_v3_v4(ts, rs, terse_version);
+		show_thread_status_terse_v3_v4(ts, rs, terse_version, out);
 	else
 		log_err("fio: bad terse version!? %d\n", terse_version);
 }
 
 struct json_object *show_thread_status(struct thread_stat *ts,
-				       struct group_run_stats *rs)
+				       struct group_run_stats *rs,
+				       struct buf_output *out)
 {
-	if (output_format == FIO_OUTPUT_TERSE)
-		show_thread_status_terse(ts, rs);
-	else if (output_format == FIO_OUTPUT_JSON)
-		return show_thread_status_json(ts, rs);
-	else
-		show_thread_status_normal(ts, rs);
-	return NULL;
+	struct json_object *ret = NULL;
+
+	if (output_format & FIO_OUTPUT_TERSE)
+		show_thread_status_terse(ts, rs,  out);
+	if (output_format & FIO_OUTPUT_JSON)
+		ret = show_thread_status_json(ts, rs);
+	if (output_format & FIO_OUTPUT_NORMAL)
+		show_thread_status_normal(ts, rs,  out);
+
+	return ret;
 }
 
 static void sum_stat(struct io_stat *dst, struct io_stat *src, int nr)
@@ -1386,6 +1397,8 @@ void __show_run_stats(void)
 	int unit_base_warned = 0;
 	struct json_object *root = NULL;
 	struct json_array *array = NULL;
+	struct buf_output output[FIO_OUTPUT_NR];
+
 	runstats = malloc(sizeof(struct group_run_stats) * (groupid + 1));
 
 	for (i = 0; i < groupid + 1; i++)
@@ -1545,12 +1558,15 @@ void __show_run_stats(void)
 		}
 	}
 
+	for (i = 0; i < FIO_OUTPUT_NR; i++)
+		buf_output_init(&output[i]);
+
 	/*
 	 * don't overwrite last signal output
 	 */
-	if (output_format == FIO_OUTPUT_NORMAL)
-		log_info("\n");
-	else if (output_format == FIO_OUTPUT_JSON) {
+	if (output_format & FIO_OUTPUT_NORMAL)
+		log_buf(&output[__FIO_OUTPUT_NORMAL], "\n");
+	if (output_format & FIO_OUTPUT_JSON) {
 		char time_buf[32];
 		time_t time_p;
 
@@ -1573,22 +1589,25 @@ void __show_run_stats(void)
 
 		if (is_backend)
 			fio_server_send_ts(ts, rs);
-		else if (output_format == FIO_OUTPUT_TERSE)
-			show_thread_status_terse(ts, rs);
-		else if (output_format == FIO_OUTPUT_JSON) {
-			struct json_object *tmp = show_thread_status_json(ts, rs);
-			json_array_add_value_object(array, tmp);
-		} else
-			show_thread_status_normal(ts, rs);
+		else {
+			if (output_format & FIO_OUTPUT_TERSE)
+				show_thread_status_terse(ts, rs, &output[__FIO_OUTPUT_TERSE]);
+			if (output_format & FIO_OUTPUT_JSON) {
+				struct json_object *tmp = show_thread_status_json(ts, rs);
+				json_array_add_value_object(array, tmp);
+			}
+			if (output_format & FIO_OUTPUT_NORMAL)
+				show_thread_status_normal(ts, rs, &output[__FIO_OUTPUT_NORMAL]);
+		}
 	}
-	if (output_format == FIO_OUTPUT_JSON) {
+	if (output_format & FIO_OUTPUT_JSON) {
 		/* disk util stats, if any */
-		show_disk_util(1, root);
+		show_disk_util(1, root, &output[__FIO_OUTPUT_JSON]);
 
-		show_idle_prof_stats(FIO_OUTPUT_JSON, root);
+		show_idle_prof_stats(FIO_OUTPUT_JSON, root, &output[__FIO_OUTPUT_JSON]);
 
-		json_print_object(root);
-		log_info("\n");
+		json_print_object(root, &output[__FIO_OUTPUT_JSON]);
+		log_buf(&output[__FIO_OUTPUT_JSON], "\n");
 		json_free_object(root);
 	}
 
@@ -1598,25 +1617,20 @@ void __show_run_stats(void)
 		rs->groupid = i;
 		if (is_backend)
 			fio_server_send_gs(rs);
-		else if (output_format == FIO_OUTPUT_NORMAL)
-			show_group_stats(rs);
+		else if (output_format & FIO_OUTPUT_NORMAL)
+			show_group_stats(rs, &output[__FIO_OUTPUT_NORMAL]);
 	}
 
 	if (is_backend)
 		fio_server_send_du();
-	else if (output_format == FIO_OUTPUT_NORMAL) {
-		show_disk_util(0, NULL);
-		show_idle_prof_stats(FIO_OUTPUT_NORMAL, NULL);
+	else if (output_format & FIO_OUTPUT_NORMAL) {
+		show_disk_util(0, NULL, &output[__FIO_OUTPUT_NORMAL]);
+		show_idle_prof_stats(FIO_OUTPUT_NORMAL, NULL, &output[__FIO_OUTPUT_NORMAL]);
 	}
 
-	if ( !(output_format == FIO_OUTPUT_TERSE) && append_terse_output) {
-		log_info("\nAdditional Terse Output:\n");
-
-		for (i = 0; i < nr_ts; i++) {
-			ts = &threadstats[i];
-			rs = &runstats[ts->groupid];
-			show_thread_status_terse(ts, rs);
-		}
+	for (i = 0; i < FIO_OUTPUT_NR; i++) {
+		buf_output_flush(&output[i]);
+		buf_output_free(&output[i]);
 	}
 
 	log_info_flush();
diff --git a/stat.h b/stat.h
index e87dae0..e289c2e 100644
--- a/stat.h
+++ b/stat.h
@@ -2,6 +2,7 @@
 #define FIO_STAT_H
 
 #include "iolog.h"
+#include "lib/output_buffer.h"
 
 struct group_run_stats {
 	uint64_t max_run[DDIR_RWDIR_CNT], min_run[DDIR_RWDIR_CNT];
@@ -246,8 +247,8 @@ extern struct jobs_eta *get_jobs_eta(int force, size_t *size);
 extern void stat_init(void);
 extern void stat_exit(void);
 
-extern struct json_object * show_thread_status(struct thread_stat *ts, struct group_run_stats *rs);
-extern void show_group_stats(struct group_run_stats *rs);
+extern struct json_object * show_thread_status(struct thread_stat *ts, struct group_run_stats *rs, struct buf_output *);
+extern void show_group_stats(struct group_run_stats *rs, struct buf_output *);
 extern int calc_thread_status(struct jobs_eta *je, int force);
 extern void display_thread_status(struct jobs_eta *je);
 extern void show_run_stats(void);
