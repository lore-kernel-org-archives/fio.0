Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56377 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750925AbeBINAV (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Feb 2018 08:00:21 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1ek8Hs-00078x-M6
        for fio@vger.kernel.org; Fri, 09 Feb 2018 13:00:20 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180209130002.580772C00B7@kernel.dk>
Date: Fri,  9 Feb 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c69f6bf3ed1b413562d7aab1aa9c476101348726:

  mmap: don't include MADV_FREE in fadvise_hint check (2018-02-07 11:30:59 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0cf542af81751d7b318afe4429001c1aab6baee5:

  Include 'numjobs' in global options output (2018-02-08 15:46:46 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Include 'numjobs' in global options output

 stat.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index a980a1d..bd2c27d 100644
--- a/stat.c
+++ b/stat.c
@@ -1226,7 +1226,7 @@ static void show_thread_status_terse_all(struct thread_stat *ts,
 }
 
 static void json_add_job_opts(struct json_object *root, const char *name,
-			      struct flist_head *opt_list, bool num_jobs)
+			      struct flist_head *opt_list)
 {
 	struct json_object *dir_object;
 	struct flist_head *entry;
@@ -1242,8 +1242,6 @@ static void json_add_job_opts(struct json_object *root, const char *name,
 		const char *pos = "";
 
 		p = flist_entry(entry, struct print_option, list);
-		if (!num_jobs && !strcmp(p->name, "numjobs"))
-			continue;
 		if (p->value)
 			pos = p->value;
 		json_object_add_value_string(dir_object, p->name, pos);
@@ -1277,7 +1275,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	}
 
 	if (opt_list)
-		json_add_job_opts(root, "job options", opt_list, true);
+		json_add_job_opts(root, "job options", opt_list);
 
 	add_ddir_status_json(ts, rs, DDIR_READ, root);
 	add_ddir_status_json(ts, rs, DDIR_WRITE, root);
@@ -1878,7 +1876,7 @@ void __show_run_stats(void)
 		json_object_add_value_int(root, "timestamp_ms", ms_since_epoch);
 		json_object_add_value_string(root, "time", time_buf);
 		global = get_global_options();
-		json_add_job_opts(root, "global options", &global->opt_list, false);
+		json_add_job_opts(root, "global options", &global->opt_list);
 		array = json_create_array();
 		json_object_add_value_array(root, "jobs", array);
 	}
