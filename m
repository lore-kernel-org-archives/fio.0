Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:38382 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab3J3ODL (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 30 Oct 2013 10:03:11 -0400
Received: by mail-pa0-f45.google.com with SMTP id kp14so986424pab.32
        for <fio@vger.kernel.org>; Wed, 30 Oct 2013 07:03:10 -0700 (PDT)
From: castor.fu@egocast.org
Subject: [PATCH] Add json output for client/server mode.
Date: Wed, 30 Oct 2013 07:03:00 -0700
Message-Id: <1383141780-20242-1-git-send-email-castor.fu@egocast.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Castor Fu <castor@alumni.caltech.edu>

From: Castor Fu <castor@alumni.caltech.edu>

In client/server mode, this adds support for json mode.  Each job's
details are gradually accumulated and upon completion the client
dumps the full json tree.  The tree is annotated with the server
host and port.  Also tweak configure script to allow explicitly
disabling libnuma.

Signed-off-by: Castor Fu <castor@alumni.caltech.edu>
---
 client.c   | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 configure  |  5 ++++-
 diskutil.c | 49 +++++++++++++++++++++++++++++--------------------
 diskutil.h |  5 ++++-
 json.h     |  3 +++
 stat.c     | 22 ++++++++++++++++++----
 stat.h     |  2 +-
 7 files changed, 116 insertions(+), 31 deletions(-)

diff --git a/client.c b/client.c
index 1fefda8..1557240 100644
--- a/client.c
+++ b/client.c
@@ -57,6 +57,9 @@ struct group_run_stats client_gs;
 int sum_stat_clients;
 
 static int sum_stat_nr;
+static struct json_object *root = NULL;
+static struct json_array *clients_array = NULL;
+static struct json_array *du_array = NULL;
 static int do_output_all_clients;
 
 #define FIO_CLIENT_HASH_BITS	7
@@ -86,6 +89,30 @@ static void fio_init fio_client_hash_init(void)
 		INIT_FLIST_HEAD(&client_hash[i]);
 }
 
+static void fio_client_json_init(void)
+{
+	if (output_format != FIO_OUTPUT_JSON)
+		return;
+	root = json_create_object();
+	json_object_add_value_string(root, "fio version", fio_version_string);
+	clients_array = json_create_array();
+	json_object_add_value_array(root, "client_stats", clients_array);
+	du_array = json_create_array();
+	json_object_add_value_array(root, "disk_util", du_array);
+}
+
+static void fio_client_json_fini(void)
+{
+	if (output_format != FIO_OUTPUT_JSON)
+		return;
+	json_print_object(root);
+	log_info("\n");
+	json_free_object(root);
+	root = NULL;
+	clients_array = NULL;
+	du_array = NULL;
+}
+
 static struct fio_client *find_client_by_fd(int fd)
 {
 	int bucket = hash_long(fd, FIO_CLIENT_HASH_BITS) & FIO_CLIENT_HASH_MASK;
@@ -557,6 +584,8 @@ int fio_start_all_clients(void)
 
 	dprint(FD_NET, "client: start all\n");
 
+	fio_client_json_init();
+
 	flist_for_each_safe(entry, tmp, &client_list) {
 		client = flist_entry(entry, struct fio_client, list);
 
@@ -684,7 +713,7 @@ int fio_client_update_options(struct fio_client *client,
 	pdu.thread_number = cpu_to_le32(client->thread_number);
 	pdu.groupid = cpu_to_le32(client->groupid);
 	convert_thread_options_to_net(&pdu.top, o);
-	
+
 	return fio_net_send_cmd(client->fd, FIO_NET_CMD_UPDATE_JOB, &pdu, sizeof(pdu), tag, &client->cmd_list);
 }
 
@@ -788,12 +817,24 @@ static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
 	dst->unified_rw_rep	= le32_to_cpu(src->unified_rw_rep);
 }
 
+static void json_object_add_client_info(struct json_object *obj,
+struct fio_client *client)
+{
+	json_object_add_value_string(obj, "hostname", client->hostname);
+	json_object_add_value_int(obj, "port", client->port);
+}
+
 static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct cmd_ts_pdu *p = (struct cmd_ts_pdu *) cmd->payload;
+	struct json_object *tsobj;
 
-	show_thread_status(&p->ts, &p->rs);
+	tsobj = show_thread_status(&p->ts, &p->rs);
 	client->did_stat = 1;
+	if (tsobj) {
+		json_object_add_client_info(tsobj, client);
+		json_array_add_value_object(clients_array, tsobj);
+	}
 
 	if (!do_output_all_clients)
 		return;
@@ -808,7 +849,11 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 
 	if (++sum_stat_nr == sum_stat_clients) {
 		strcpy(client_ts.name, "All clients");
-		show_thread_status(&client_ts, &client_gs);
+		tsobj = show_thread_status(&client_ts, &client_gs);
+		if (tsobj) {
+			json_object_add_client_info(tsobj, client);
+			json_array_add_value_object(clients_array, tsobj);
+		}
 	}
 }
 
@@ -877,7 +922,13 @@ static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd)
 		log_info("\nDisk stats (read/write):\n");
 	}
 
-	print_disk_util(&du->dus, &du->agg, output_format == FIO_OUTPUT_TERSE);
+	if (output_format == FIO_OUTPUT_JSON) {
+		struct json_object *duobj;
+		json_array_add_disk_util(&du->dus, &du->agg, du_array);
+		duobj = json_array_last_value_object(du_array);
+		json_object_add_client_info(duobj, client);
+	} else
+		print_disk_util(&du->dus, &du->agg, output_format == FIO_OUTPUT_TERSE);
 }
 
 static void convert_jobs_eta(struct jobs_eta *je)
@@ -1476,6 +1527,8 @@ int fio_handle_clients(struct client_ops *ops)
 		}
 	}
 
+	fio_client_json_fini();
+
 	free(pfds);
 	return retval;
 }
diff --git a/configure b/configure
index c00a3a4..b6bfe19 100755
--- a/configure
+++ b/configure
@@ -153,6 +153,8 @@ for opt do
   --enable-gfio)
   gfio="yes"
   ;;
+  --disable-numa) disable_numa="yes"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -169,6 +171,7 @@ if test "$show_help" = "yes" ; then
   echo "--extra-cflags=        Specify extra CFLAGS to pass to compiler"
   echo "--build-32bit-win      Enable 32-bit build on Windows"
   echo "--enable-gfio          Enable building of gtk gfio"
+  echo "--disable-numa         Disable libnuma even if found"
   exit $exit_val
 fi
 
@@ -835,7 +838,7 @@ int main(int argc, char **argv)
   return numa_available();
 }
 EOF
-if compile_prog "" "-lnuma" "libnuma"; then
+if test "$disable_numa" != "yes"  && compile_prog "" "-lnuma" "libnuma"; then
   libnuma="yes"
   LIBS="-lnuma $LIBS"
 fi
diff --git a/diskutil.c b/diskutil.c
index e29d1c3..bc12b02 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -605,21 +605,19 @@ void print_disk_util(struct disk_util_stat *dus, struct disk_util_agg *agg,
 		log_info("\n");
 }
 
-static void print_disk_util_json(struct disk_util *du, struct json_array *array)
+void json_array_add_disk_util(struct disk_util_stat *dus,
+		struct disk_util_agg *agg, struct json_array *array)
 {
-	double util = 0;
-	struct disk_util_stat *dus = &du->dus;
-	struct disk_util_agg *agg = &du->agg;
 	struct json_object *obj;
-
-	obj = json_create_object();
-	json_array_add_value_object(array, obj);
+	double util = 0;
 
 	if (dus->msec)
 		util = (double) 100 * dus->io_ticks / (double) dus->msec;
 	if (util > 100.0)
 		util = 100.0;
 
+	obj = json_create_object();
+	json_array_add_value_object(array, obj);
 
 	json_object_add_value_string(obj, "name", dus->name);
 	json_object_add_value_int(obj, "read_ios", dus->ios[0]);
@@ -654,11 +652,27 @@ static void print_disk_util_json(struct disk_util *du, struct json_array *array)
 	json_object_add_value_float(obj, "aggr_util", agg->max_util.u.f);
 }
 
+void json_object_add_disk_utils(struct json_object *obj,
+		struct flist_head *head)
+{
+	struct json_array *array = json_create_array();
+	struct flist_head *entry;
+	struct disk_util *du;
+
+	json_object_add_value_array(obj, "disk_util", array);
+
+	flist_for_each(entry, head) {
+		du = flist_entry(entry, struct disk_util, list);
+
+		aggregate_slaves_stats(du);
+		json_array_add_disk_util(&du->dus, &du->agg, array);
+	}
+}
+
 void show_disk_util(int terse, struct json_object *parent)
 {
 	struct flist_head *entry;
 	struct disk_util *du;
-	struct json_array *array = NULL;
 
 	fio_mutex_down(disk_util_mutex);
 
@@ -667,23 +681,18 @@ void show_disk_util(int terse, struct json_object *parent)
 		return;
 	}
 
-	if (!terse)
+	if (!terse && !parent)
 		log_info("\nDisk stats (read/write):\n");
 
 	if (output_format == FIO_OUTPUT_JSON) {
-		array = json_create_array();
-		json_object_add_value_array(parent, "disk_util", array);
-	}
-
-	flist_for_each(entry, &disk_list) {
-		du = flist_entry(entry, struct disk_util, list);
+		json_object_add_disk_utils(parent, &disk_list);
+	} else
+		flist_for_each(entry, &disk_list) {
+			du = flist_entry(entry, struct disk_util, list);
 
-		aggregate_slaves_stats(du);
-		if (output_format == FIO_OUTPUT_JSON)
-			print_disk_util_json(du, array);
-		else
+			aggregate_slaves_stats(du);
 			print_disk_util(&du->dus, &du->agg, terse);
-	}
+		}
 
 	fio_mutex_up(disk_util_mutex);
 }
diff --git a/diskutil.h b/diskutil.h
index 6ae4aee..7207c73 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -104,6 +104,8 @@ extern void wait_for_disk_thread_exit(void);
 #ifdef FIO_HAVE_DISK_UTIL
 extern void print_disk_util(struct disk_util_stat *, struct disk_util_agg *, int terse);
 extern void show_disk_util(int terse, struct json_object *parent);
+extern void json_array_add_disk_util(struct disk_util_stat *dus,
+		struct disk_util_agg *agg, struct json_array *parent);
 extern void init_disk_util(struct thread_data *);
 extern int update_io_ticks(void);
 extern void setup_disk_util(void);
@@ -117,6 +119,8 @@ static inline void print_disk_util(struct disk_util_stat *du,
 #define disk_util_prune_entries()
 #define init_disk_util(td)
 #define setup_disk_util()
+#define json_array_add_disk_util(dus, agg, parent)
+
 static inline int update_io_ticks(void)
 {
 	return disk_util_exit;
@@ -127,5 +131,4 @@ static inline void disk_util_start_exit(void)
 {
 	disk_util_exit = 1;
 }
-
 #endif
diff --git a/json.h b/json.h
index 4d05e82..2a798ce 100644
--- a/json.h
+++ b/json.h
@@ -73,5 +73,8 @@ int json_array_add_value_type(struct json_array *array, int type, ...);
 #define json_array_add_value_array(obj, val) \
 	json_array_add_value_type((obj), JSON_TYPE_ARRAY, (val))
 
+#define json_array_last_value_object(obj) \
+	(obj->values[obj->value_cnt - 1]->object)
+
 void json_print_object(struct json_object *obj);
 #endif
diff --git a/stat.c b/stat.c
index fec3639..ac5ff16 100644
--- a/stat.c
+++ b/stat.c
@@ -497,7 +497,8 @@ static void show_latencies(struct thread_stat *ts)
 	show_lat_m(io_u_lat_m);
 }
 
-void show_thread_status(struct thread_stat *ts, struct group_run_stats *rs)
+
+void show_thread_status_normal(struct thread_stat *ts, struct group_run_stats *rs)
 {
 	double usr_cpu, sys_cpu;
 	unsigned long runtime;
@@ -883,7 +884,8 @@ static void show_thread_status_terse_v3_v4(struct thread_stat *ts,
 		log_info(";%3.2f%%", io_u_lat_m[i]);
 
 	/* disk util stats, if any */
-	show_disk_util(1, NULL);
+	if (is_backend)
+		show_disk_util(1, NULL);
 
 	/* Additional output if continue_on_error set - default off*/
 	if (ts->continue_on_error)
@@ -970,7 +972,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	/* Additional output if continue_on_error set - default off*/
 	if (ts->continue_on_error) {
 		json_object_add_value_int(root, "total_err", ts->total_err_count);
-		json_object_add_value_int(root, "total_err", ts->first_error);
+		json_object_add_value_int(root, "first_error", ts->first_error);
 	}
 
 	/* Additional output if description is set */
@@ -991,6 +993,18 @@ static void show_thread_status_terse(struct thread_stat *ts,
 		log_err("fio: bad terse version!? %d\n", terse_version);
 }
 
+struct json_object *show_thread_status(struct thread_stat *ts,
+				       struct group_run_stats *rs)
+{
+	if (output_format == FIO_OUTPUT_TERSE)
+		show_thread_status_terse(ts, rs);
+	else if (output_format == FIO_OUTPUT_JSON)
+		return(show_thread_status_json(ts, rs));
+	else
+		show_thread_status_normal(ts, rs);
+	return NULL;
+}
+
 static void sum_stat(struct io_stat *dst, struct io_stat *src, int nr)
 {
 	double mean, S;
@@ -1324,7 +1338,7 @@ static void __show_run_stats(void)
 			struct json_object *tmp = show_thread_status_json(ts, rs);
 			json_array_add_value_object(array, tmp);
 		} else
-			show_thread_status(ts, rs);
+			show_thread_status_normal(ts, rs);
 	}
 	if (output_format == FIO_OUTPUT_JSON) {
 		/* disk util stats, if any */
diff --git a/stat.h b/stat.h
index 541b77e..8190d1e 100644
--- a/stat.h
+++ b/stat.h
@@ -202,7 +202,7 @@ struct jobs_eta {
 extern void stat_init(void);
 extern void stat_exit(void);
 
-extern void show_thread_status(struct thread_stat *ts, struct group_run_stats *rs);
+extern struct json_object * show_thread_status(struct thread_stat *ts, struct group_run_stats *rs);
 extern void show_group_stats(struct group_run_stats *rs);
 extern int calc_thread_status(struct jobs_eta *je, int force);
 extern void display_thread_status(struct jobs_eta *je);
-- 
1.7.11.5

