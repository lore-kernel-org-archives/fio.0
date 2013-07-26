Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qe0-f45.google.com ([209.85.128.45]:32980 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760166Ab3GZXQu (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 26 Jul 2013 19:16:50 -0400
Received: by mail-qe0-f45.google.com with SMTP id w7so1274422qeb.32
        for <fio@vger.kernel.org>; Fri, 26 Jul 2013 16:16:50 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 26 Jul 2013 17:16:49 -0600
Message-ID: <CAOtMX2if0xLLNngOm4uGgWcrze_61M+jCmHcv0pgNisYsWr_Dg@mail.gmail.com>
Subject: --minimal does not work in client/server mode
From: asomers@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

When I use fio in client/server mode, no matter how I try to specify
--minimal, I always get the normal output.  I've tried all of these
methods, and their combinations:

server# fio --server
client#  fio --minimal --client=localhost /tmp/cpuio.fio

server# fio --server
client#  fio --client=localhost --minimal /tmp/cpuio.fio

server# fio --minimal --server
client# fio --client=localhost  /tmp/cpuio.fio

The following patch fixes the problem, though I can't promise it won't
break anything else:

--- fio-2.1.1/client.c	2013-06-05 08:55:53.000000000 -0600
+++ fio-2.1.1.new/client.c	2013-07-26 17:13:18.504740214 -0600
@@ -788,11 +788,15 @@
 	dst->unified_rw_rep	= le32_to_cpu(src->unified_rw_rep);
 }

+
 static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct cmd_ts_pdu *p = (struct cmd_ts_pdu *) cmd->payload;

-	show_thread_status(&p->ts, &p->rs);
+	if (output_format == FIO_OUTPUT_TERSE)
+		show_thread_status_terse(&p->ts, &p->rs);
+	else
+		show_thread_status(&p->ts, &p->rs);
 	client->did_stat = 1;

 	if (!do_output_all_clients)
@@ -808,7 +812,10 @@

 	if (++sum_stat_nr == sum_stat_clients) {
 		strcpy(client_ts.name, "All clients");
-		show_thread_status(&client_ts, &client_gs);
+		if (output_format == FIO_OUTPUT_TERSE)
+			show_thread_status_terse(&client_ts, &client_gs);
+		else
+			show_thread_status(&client_ts, &client_gs);
 	}
 }

diff -dur fio-2.1.1/stat.c fio-2.1.1.new/stat.c
--- fio-2.1.1/stat.c	2013-06-05 08:55:53.000000000 -0600
+++ fio-2.1.1.new/stat.c	2013-07-26 17:03:05.332755580 -0600
@@ -885,7 +885,8 @@
 		log_info(";%3.2f%%", io_u_lat_m[i]);

 	/* disk util stats, if any */
-	show_disk_util(1, NULL);
+	if (is_backend)
+		show_disk_util(1, NULL);

 	/* Additional output if continue_on_error set - default off*/
 	if (ts->continue_on_error)
@@ -982,7 +983,7 @@
 	return root;
 }

-static void show_thread_status_terse(struct thread_stat *ts,
+void show_thread_status_terse(struct thread_stat *ts,
 				     struct group_run_stats *rs)
 {
 	if (terse_version == 2)
diff -dur fio-2.1.1/stat.h fio-2.1.1.new/stat.h
--- fio-2.1.1/stat.h	2013-06-05 08:55:53.000000000 -0600
+++ fio-2.1.1.new/stat.h	2013-07-26 16:46:12.972780950 -0600
@@ -203,6 +203,7 @@
 extern void stat_exit(void);

 extern void show_thread_status(struct thread_stat *ts, struct
group_run_stats *rs);
+extern void show_thread_status_terse(struct thread_stat *ts, struct
group_run_stats *rs);
 extern void show_group_stats(struct group_run_stats *rs);
 extern int calc_thread_status(struct jobs_eta *je, int force);
 extern void display_thread_status(struct jobs_eta *je);
