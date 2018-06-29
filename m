Return-Path: <josef@toxicpanda.com>
Return-Path: <josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 2/2] fio: add total_run_time to the thread json output
Date: Fri, 29 Jun 2018 09:33:35 -0400
Message-Id: <20180629133335.14618-2-josef@toxicpanda.com>
In-Reply-To: <20180629133335.14618-1-josef@toxicpanda.com>
References: <20180629133335.14618-1-josef@toxicpanda.com>
To: fio@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk
List-ID: <fio@vger.kernel.org>

I discovered that the 'elapsed' value of each job is the overall time
the whole fio run took, not the per-job elapsed time, despite it being
in the per-job section of the json output.  Rather than break everybody
by fixing this, just add a 'total_run_time' value to the job section and
include the time the thread ran in milliseconds.  This is handy for jobs
that want to compare runtime of two threads in different cgroups.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 stat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/stat.c b/stat.c
index d5240d96a25b..76553489d068 100644
--- a/stat.c
+++ b/stat.c
@@ -1288,6 +1288,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 		usr_cpu = 0;
 		sys_cpu = 0;
 	}
+	json_object_add_value_int(root, "total_run_time", ts->total_run_time);
 	json_object_add_value_float(root, "usr_cpu", usr_cpu);
 	json_object_add_value_float(root, "sys_cpu", sys_cpu);
 	json_object_add_value_int(root, "ctx", ts->ctx);
-- 
2.14.3


