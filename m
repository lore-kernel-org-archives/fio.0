Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39566 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbeHXPes (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Aug 2018 11:34:48 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ftAlP-0000p4-Li
        for fio@vger.kernel.org; Fri, 24 Aug 2018 12:00:27 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180824120002.3FAF62C234E@kernel.dk>
Date: Fri, 24 Aug 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c08890d3a81cebb5b4bde14afb6c7778bb390ddf:

  Merge branch 'axmap' of https://github.com/bvanassche/fio (2018-08-22 20:13:45 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e7ff953f87d000d1de4c928493a6f67214cfcf8f:

  t/axmap: print explicit overlap ranges tested (2018-08-23 13:58:21 -0600)

----------------------------------------------------------------
Jens Axboe (5):
      parse: fix bssplit option
      Merge branch '20180823-terse-remote-fix' of https://github.com/mcgrof/fio
      axmap: return early of an overlap results in 0 settable bits
      t/axmap: add regression test for overlap case resulting in 0 settable bits
      t/axmap: print explicit overlap ranges tested

Luis Chamberlain (2):
      client: respect terse output on client <--> backend relationship
      init: add semantics for all types of backends running

 backend.c   |  2 ++
 client.c    | 16 +++++++++++++---
 diskutil.c  |  2 +-
 fio.h       |  6 ++++++
 init.c      |  1 +
 lib/axmap.c |  2 ++
 parse.c     |  4 +---
 stat.c      |  4 +++-
 t/axmap.c   | 15 +++++++++------
 9 files changed, 38 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 36bde6a..8fec1ce 100644
--- a/backend.c
+++ b/backend.c
@@ -2481,6 +2481,8 @@ int fio_backend(struct sk_out *sk_out)
 	}
 
 	startup_sem = fio_sem_init(FIO_SEM_LOCKED);
+	if (!sk_out)
+		is_local_backend = true;
 	if (startup_sem == NULL)
 		return 1;
 
diff --git a/client.c b/client.c
index e2525c8..bc0275b 100644
--- a/client.c
+++ b/client.c
@@ -1058,6 +1058,9 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 	struct flist_head *opt_list = NULL;
 	struct json_object *tsobj;
 
+	if (output_format & FIO_OUTPUT_TERSE)
+		return;
+
 	if (client->opt_lists && p->ts.thread_number <= client->jobs)
 		opt_list = &client->opt_lists[p->ts.thread_number - 1];
 
@@ -1094,6 +1097,9 @@ static void handle_gs(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct group_run_stats *gs = (struct group_run_stats *) cmd->payload;
 
+	if (output_format & FIO_OUTPUT_TERSE)
+		return;
+
 	if (output_format & FIO_OUTPUT_NORMAL)
 		show_group_stats(gs, NULL);
 }
@@ -1140,7 +1146,7 @@ static void handle_text(struct fio_client *client, struct fio_net_cmd *cmd)
 
 	name = client->name ? client->name : client->hostname;
 
-	if (!client->skip_newline)
+	if (!client->skip_newline && !(output_format & FIO_OUTPUT_TERSE))
 		fprintf(f_out, "<%s> ", name);
 	ret = fwrite(buf, pdu->buf_len, 1, f_out);
 	fflush(f_out);
@@ -1184,6 +1190,9 @@ static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct cmd_du_pdu *du = (struct cmd_du_pdu *) cmd->payload;
 
+	if (output_format & FIO_OUTPUT_TERSE)
+		return;
+
 	if (!client->disk_stats_shown) {
 		client->disk_stats_shown = true;
 		log_info("\nDisk stats (read/write):\n");
@@ -1195,8 +1204,6 @@ static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd)
 		duobj = json_array_last_value_object(du_array);
 		json_object_add_client_info(duobj, client);
 	}
-	if (output_format & FIO_OUTPUT_TERSE)
-		print_disk_util(&du->dus, &du->agg, 1, NULL);
 	if (output_format & FIO_OUTPUT_NORMAL)
 		print_disk_util(&du->dus, &du->agg, 0, NULL);
 }
@@ -1456,6 +1463,9 @@ static void handle_probe(struct fio_client *client, struct fio_net_cmd *cmd)
 	const char *os, *arch;
 	char bit[16];
 
+	if (output_format & FIO_OUTPUT_TERSE)
+		return;
+
 	os = fio_get_os_string(probe->os);
 	if (!os)
 		os = "unknown";
diff --git a/diskutil.c b/diskutil.c
index 5b4eb46..7be4c02 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -701,7 +701,7 @@ void show_disk_util(int terse, struct json_object *parent,
 	struct disk_util *du;
 	bool do_json;
 
-	if (!disk_util_sem)
+	if (!is_running_backend())
 		return;
 
 	fio_sem_down(disk_util_sem);
diff --git a/fio.h b/fio.h
index b58057f..83654bb 100644
--- a/fio.h
+++ b/fio.h
@@ -522,6 +522,7 @@ extern int fio_clock_source_set;
 extern int warnings_fatal;
 extern int terse_version;
 extern int is_backend;
+extern int is_local_backend;
 extern int nr_clients;
 extern int log_syslog;
 extern int status_interval;
@@ -534,6 +535,11 @@ extern char *aux_path;
 
 extern struct thread_data *threads;
 
+static inline bool is_running_backend(void)
+{
+	return is_backend || is_local_backend;
+}
+
 extern bool eta_time_within_slack(unsigned int time);
 
 static inline void fio_ro_check(const struct thread_data *td, struct io_u *io_u)
diff --git a/init.c b/init.c
index 06f6971..3ed5757 100644
--- a/init.c
+++ b/init.c
@@ -63,6 +63,7 @@ char *exec_profile = NULL;
 int warnings_fatal = 0;
 int terse_version = 3;
 int is_backend = 0;
+int is_local_backend = 0;
 int nr_clients = 0;
 int log_syslog = 0;
 
diff --git a/lib/axmap.c b/lib/axmap.c
index e194e80..03e712f 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -241,6 +241,8 @@ static bool axmap_set_fn(struct axmap_level *al, unsigned long offset,
 
 	if (overlap) {
 		nr_bits = ffz(~overlap) - bit;
+		if (!nr_bits)
+			return true;
 		mask = bit_masks[nr_bits] << bit;
 	}
 
diff --git a/parse.c b/parse.c
index 194ad59..952118c 100644
--- a/parse.c
+++ b/parse.c
@@ -959,6 +959,7 @@ static int handle_option(const struct fio_option *o, const char *__ptr,
 		if (ptr &&
 		    (o->type != FIO_OPT_STR_STORE) &&
 		    (o->type != FIO_OPT_STR) &&
+		    (o->type != FIO_OPT_STR_ULL) &&
 		    (o->type != FIO_OPT_FLOAT_LIST)) {
 			ptr2 = strchr(ptr, ',');
 			if (ptr2 && *(ptr2 + 1) == '\0')
@@ -1372,9 +1373,6 @@ static void option_init(struct fio_option *o)
 		o->category = FIO_OPT_C_GENERAL;
 		o->group = FIO_OPT_G_INVALID;
 	}
-	if (o->type == FIO_OPT_STR || o->type == FIO_OPT_STR_STORE ||
-	    o->type == FIO_OPT_STR_MULTI)
-		return;
 }
 
 /*
diff --git a/stat.c b/stat.c
index 82e79df..6cb704e 100644
--- a/stat.c
+++ b/stat.c
@@ -1205,7 +1205,7 @@ static void show_thread_status_terse_all(struct thread_stat *ts,
 		log_buf(out, ";%3.2f%%", io_u_lat_m[i]);
 
 	/* disk util stats, if any */
-	if (ver >= 3)
+	if (ver >= 3 && is_running_backend())
 		show_disk_util(1, NULL, out);
 
 	/* Additional output if continue_on_error set - default off*/
@@ -1922,6 +1922,8 @@ void __show_run_stats(void)
 		if (is_backend) {
 			fio_server_send_job_options(opt_lists[i], i);
 			fio_server_send_ts(ts, rs);
+			if (output_format & FIO_OUTPUT_TERSE)
+				show_thread_status_terse(ts, rs, &output[__FIO_OUTPUT_TERSE]);
 		} else {
 			if (output_format & FIO_OUTPUT_TERSE)
 				show_thread_status_terse(ts, rs, &output[__FIO_OUTPUT_TERSE]);
diff --git a/t/axmap.c b/t/axmap.c
index 1752439..a2e6fd6 100644
--- a/t/axmap.c
+++ b/t/axmap.c
@@ -352,6 +352,11 @@ static int test_overlap(void)
 			.ret	= 14,
 		},
 		{
+			.start	= 22670,
+			.nr	= 60,
+			.ret	= 0,
+		},
+		{
 			.start	= -1U,
 		},
 	};
@@ -366,7 +371,7 @@ static int test_overlap(void)
 			entries = this;
 	}
 
-	printf("Test overlaps...");
+	printf("Test overlaps...\n");
 	fflush(stdout);
 
 	map = axmap_new(entries);
@@ -374,18 +379,16 @@ static int test_overlap(void)
 	for (i = 0; tests[i].start != -1U; i++) {
 		struct overlap_test *t = &tests[i];
 
+		printf("\tstart=%6u, nr=%3u: ", t->start, t->nr);
 		ret = axmap_set_nr(map, t->start, t->nr);
 		if (ret != t->ret) {
-			printf("fail\n");
-			printf("start=%u, nr=%d, ret=%d: %d\n", t->start, t->nr,
-								t->ret, ret);
+			printf("%3d (FAIL, wanted %d)\n", ret, t->ret);
 			err = 1;
 			break;
 		}
+		printf("%3d (PASS)\n", ret);
 	}
 
-	if (!err)
-		printf("pass!\n");
 	axmap_free(map);
 	return err;
 }

