Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49110 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbbFXMAN (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 24 Jun 2015 08:00:13 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z7jLh-0000A6-AZ
	for fio@vger.kernel.org; Wed, 24 Jun 2015 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150624120002.4193A2C00CB@kernel.dk>
Date: Wed, 24 Jun 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 75dc383e9d05369c830559496afa382178905e39:

  Fix latency logging for io_submit_mode=offload (2015-06-20 13:21:48 -0400)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b01af66b13f0594617602b61d31b1495292e5fd2:

  add eta and elapsed to root of json output (2015-06-22 14:34:04 -0700)

----------------------------------------------------------------
Christopher Jacobs (1):
      add eta and elapsed to root of json output

 stat.c | 9 +++++++++
 1 file changed, 9 insertions(+)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 30a2c1e..00eb75d 100644
--- a/stat.c
+++ b/stat.c
@@ -1062,17 +1062,26 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 				    struct group_run_stats *rs)
 {
 	struct json_object *root, *tmp;
+	struct jobs_eta *je;
 	double io_u_dist[FIO_IO_U_MAP_NR];
 	double io_u_lat_u[FIO_IO_U_LAT_U_NR];
 	double io_u_lat_m[FIO_IO_U_LAT_M_NR];
 	double usr_cpu, sys_cpu;
 	int i;
+	size_t size;
+
 
 	root = json_create_object();
 	json_object_add_value_string(root, "jobname", ts->name);
 	json_object_add_value_int(root, "groupid", ts->groupid);
 	json_object_add_value_int(root, "error", ts->error);
 
+	/* ETA Info */
+	je = get_jobs_eta(1, &size);
+	json_object_add_value_int(root, "eta", je->eta_sec);
+	json_object_add_value_int(root, "elapsed", je->elapsed_sec);
+
+
 	add_ddir_status_json(ts, rs, DDIR_READ, root);
 	add_ddir_status_json(ts, rs, DDIR_WRITE, root);
 	add_ddir_status_json(ts, rs, DDIR_TRIM, root);
