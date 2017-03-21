Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:34805 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758063AbdCUVQu (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Mar 2017 17:16:50 -0400
Received: by mail-pg0-f51.google.com with SMTP id 21so65971693pgg.1
        for <fio@vger.kernel.org>; Tue, 21 Mar 2017 14:16:50 -0700 (PDT)
From: Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH] Ensure all json field keys do not have ' ' in them
Date: Tue, 21 Mar 2017 14:16:32 -0700
Message-Id: <20170321211632.38104-1-gwendal@chromium.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: axboe@fb.com
Cc: fio@vger.kernel.org

So far, fio key names use '_' instead of ' '.
Fix keys with 'job options' and 'global options' to match the naming
convention.

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
 stat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/stat.c b/stat.c
index fde7af29..ec130eeb 100644
--- a/stat.c
+++ b/stat.c
@@ -1192,7 +1192,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	}
 
 	if (opt_list)
-		json_add_job_opts(root, "job options", opt_list, true);
+		json_add_job_opts(root, "job_options", opt_list, true);
 
 	add_ddir_status_json(ts, rs, DDIR_READ, root);
 	add_ddir_status_json(ts, rs, DDIR_WRITE, root);
@@ -1771,7 +1771,7 @@ void __show_run_stats(void)
 		json_object_add_value_int(root, "timestamp_ms", ms_since_epoch);
 		json_object_add_value_string(root, "time", time_buf);
 		global = get_global_options();
-		json_add_job_opts(root, "global options", &global->opt_list, false);
+		json_add_job_opts(root, "global_options", &global->opt_list, false);
 		array = json_create_array();
 		json_object_add_value_array(root, "jobs", array);
 	}
-- 
2.12.1.500.gab5fba24ee-goog

