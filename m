Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36664 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbeJES6g (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 5 Oct 2018 14:58:36 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g8OmA-0004AW-EX
        for fio@vger.kernel.org; Fri, 05 Oct 2018 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181005120001.8A9402C288F@kernel.dk>
Date: Fri,  5 Oct 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8772acb0435c6a378951458d8fd9b18e1ab1add0:

  Fio 3.11 (2018-10-03 12:30:40 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f1867a7f9e588acf67cf8fa96eab8a6e2fdedcf6:

  Bool conversions (2018-10-04 09:07:01 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Bool conversions

 backend.c |  4 ++--
 fio.h     | 10 +++++-----
 gfio.c    | 10 +++++-----
 init.c    | 32 ++++++++++++++++----------------
 options.c |  2 +-
 server.c  |  8 ++++----
 server.h  |  2 +-
 stat.h    |  2 +-
 8 files changed, 35 insertions(+), 35 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index bb8bd13..76e456f 100644
--- a/backend.c
+++ b/backend.c
@@ -53,7 +53,7 @@ static struct fio_sem *startup_sem;
 static struct flist_head *cgroup_list;
 static struct cgroup_mnt *cgroup_mnt;
 static int exit_value;
-static volatile int fio_abort;
+static volatile bool fio_abort;
 static unsigned int nr_process = 0;
 static unsigned int nr_thread = 0;
 
@@ -2371,7 +2371,7 @@ reap:
 			if (fio_sem_down_timeout(startup_sem, 10000)) {
 				log_err("fio: job startup hung? exiting.\n");
 				fio_terminate_threads(TERMINATE_ALL);
-				fio_abort = 1;
+				fio_abort = true;
 				nr_started--;
 				free(fd);
 				break;
diff --git a/fio.h b/fio.h
index 9e99da1..7b6611a 100644
--- a/fio.h
+++ b/fio.h
@@ -503,7 +503,7 @@ enum {
 #define __fio_stringify_1(x)	#x
 #define __fio_stringify(x)	__fio_stringify_1(x)
 
-extern int exitall_on_terminate;
+extern bool exitall_on_terminate;
 extern unsigned int thread_number;
 extern unsigned int stat_number;
 extern int shm_id;
@@ -512,7 +512,7 @@ extern int output_format;
 extern int append_terse_output;
 extern int temp_stall_ts;
 extern uintptr_t page_mask, page_size;
-extern int read_only;
+extern bool read_only;
 extern int eta_print;
 extern int eta_new_line;
 extern unsigned int eta_interval_msec;
@@ -523,10 +523,10 @@ extern enum fio_cs fio_clock_source;
 extern int fio_clock_source_set;
 extern int warnings_fatal;
 extern int terse_version;
-extern int is_backend;
-extern int is_local_backend;
+extern bool is_backend;
+extern bool is_local_backend;
 extern int nr_clients;
-extern int log_syslog;
+extern bool log_syslog;
 extern int status_interval;
 extern const char fio_version_string[];
 extern char *trigger_file;
diff --git a/gfio.c b/gfio.c
index f59238c..2805396 100644
--- a/gfio.c
+++ b/gfio.c
@@ -38,7 +38,7 @@
 #include "gclient.h"
 #include "graph.h"
 
-static int gfio_server_running;
+static bool gfio_server_running;
 static unsigned int gfio_graph_limit = 100;
 
 GdkColor gfio_color_white;
@@ -461,10 +461,10 @@ static int send_job_file(struct gui_entry *ge)
 static void *server_thread(void *arg)
 {
 	fio_server_create_sk_key();
-	is_backend = 1;
-	gfio_server_running = 1;
+	is_backend = true;
+	gfio_server_running = true;
 	fio_start_server(NULL);
-	gfio_server_running = 0;
+	gfio_server_running = false;
 	fio_server_destroy_sk_key();
 	return NULL;
 }
@@ -472,7 +472,7 @@ static void *server_thread(void *arg)
 static void gfio_start_server(struct gui *ui)
 {
 	if (!gfio_server_running) {
-		gfio_server_running = 1;
+		gfio_server_running = true;
 		pthread_create(&ui->server_t, NULL, server_thread, NULL);
 		pthread_detach(ui->server_t);
 	}
diff --git a/init.c b/init.c
index 560da8f..1eddc6f 100644
--- a/init.c
+++ b/init.c
@@ -45,16 +45,16 @@ const char fio_version_string[] = FIO_VERSION;
 
 static char **ini_file;
 static int max_jobs = FIO_MAX_JOBS;
-static int dump_cmdline;
-static int parse_only;
-static int merge_blktrace_only;
+static bool dump_cmdline;
+static bool parse_only;
+static bool merge_blktrace_only;
 
 static struct thread_data def_thread;
 struct thread_data *threads = NULL;
 static char **job_sections;
 static int nr_job_sections;
 
-int exitall_on_terminate = 0;
+bool exitall_on_terminate = false;
 int output_format = FIO_OUTPUT_NORMAL;
 int eta_print = FIO_ETA_AUTO;
 unsigned int eta_interval_msec = 1000;
@@ -64,13 +64,13 @@ FILE *f_err = NULL;
 char *exec_profile = NULL;
 int warnings_fatal = 0;
 int terse_version = 3;
-int is_backend = 0;
-int is_local_backend = 0;
+bool is_backend = false;
+bool is_local_backend = false;
 int nr_clients = 0;
-int log_syslog = 0;
+bool log_syslog = false;
 
-int write_bw_log = 0;
-int read_only = 0;
+bool write_bw_log = false;
+bool read_only = false;
 int status_interval = 0;
 
 char *trigger_file = NULL;
@@ -2487,7 +2487,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 	char *ostr = cmd_optstr;
 	char *pid_file = NULL;
 	void *cur_client = NULL;
-	int backend = 0;
+	bool backend = false;
 
 	/*
 	 * Reset optind handling, since we may call this multiple times
@@ -2513,7 +2513,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			exit_val = 1;
 			break;
 		case 'b':
-			write_bw_log = 1;
+			write_bw_log = true;
 			break;
 		case 'o': {
 			FILE *tmp;
@@ -2568,7 +2568,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			break;
 		case 's':
 			did_arg = true;
-			dump_cmdline = 1;
+			dump_cmdline = true;
 			break;
 		case 'r':
 			read_only = 1;
@@ -2634,7 +2634,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			break;
 		case 'P':
 			did_arg = true;
-			parse_only = 1;
+			parse_only = true;
 			break;
 		case 'x': {
 			size_t new_size;
@@ -2759,8 +2759,8 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			}
 			if (optarg)
 				fio_server_set_arg(optarg);
-			is_backend = 1;
-			backend = 1;
+			is_backend = true;
+			backend = true;
 #else
 			log_err("fio: client/server requires SHM support\n");
 			do_exit++;
@@ -2908,7 +2908,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 
 		case 'A':
 			did_arg = true;
-			merge_blktrace_only = 1;
+			merge_blktrace_only = true;
 			break;
 		case '?':
 			log_err("%s: unrecognized option '%s'\n", argv[0],
diff --git a/options.c b/options.c
index 9b27730..66fb580 100644
--- a/options.c
+++ b/options.c
@@ -482,7 +482,7 @@ static int str_rwmix_write_cb(void *data, unsigned long long *val)
 
 static int str_exitall_cb(void)
 {
-	exitall_on_terminate = 1;
+	exitall_on_terminate = true;
 	return 0;
 }
 
diff --git a/server.c b/server.c
index 1c07501..90d3396 100644
--- a/server.c
+++ b/server.c
@@ -28,7 +28,7 @@
 
 int fio_net_port = FIO_NET_PORT;
 
-int exit_backend = 0;
+bool exit_backend = false;
 
 enum {
 	SK_F_FREE	= 1,
@@ -995,7 +995,7 @@ static int handle_command(struct sk_out *sk_out, struct flist_head *job_list,
 		ret = 0;
 		break;
 	case FIO_NET_CMD_EXIT:
-		exit_backend = 1;
+		exit_backend = true;
 		return -1;
 	case FIO_NET_CMD_LOAD_FILE:
 		ret = handle_load_file_cmd(cmd);
@@ -2492,7 +2492,7 @@ void fio_server_got_signal(int signal)
 		sk_out->sk = -1;
 	else {
 		log_info("\nfio: terminating on signal %d\n", signal);
-		exit_backend = 1;
+		exit_backend = true;
 	}
 }
 
@@ -2574,7 +2574,7 @@ int fio_start_server(char *pidfile)
 
 	setsid();
 	openlog("fio", LOG_NDELAY|LOG_NOWAIT|LOG_PID, LOG_USER);
-	log_syslog = 1;
+	log_syslog = true;
 	close(STDIN_FILENO);
 	close(STDOUT_FILENO);
 	close(STDERR_FILENO);
diff --git a/server.h b/server.h
index 40b9eac..371e51e 100644
--- a/server.h
+++ b/server.h
@@ -232,7 +232,7 @@ extern int fio_net_send_quit(int sk);
 extern int fio_server_create_sk_key(void);
 extern void fio_server_destroy_sk_key(void);
 
-extern int exit_backend;
+extern bool exit_backend;
 extern int fio_net_port;
 
 #endif
diff --git a/stat.h b/stat.h
index 98de281..b4ba71e 100644
--- a/stat.h
+++ b/stat.h
@@ -326,7 +326,7 @@ extern void add_sync_clat_sample(struct thread_stat *ts,
 extern int calc_log_samples(void);
 
 extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
-extern int write_bw_log;
+extern bool write_bw_log;
 
 static inline bool nsec_to_usec(unsigned long long *min,
 				unsigned long long *max, double *mean,

