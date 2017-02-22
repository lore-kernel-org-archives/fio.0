Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35300 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754170AbdBVNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Feb 2017 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cgWWa-000628-Bk
        for fio@vger.kernel.org; Wed, 22 Feb 2017 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170222130002.9954C2C0086@kernel.dk>
Date: Wed, 22 Feb 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 349cdc89ffebb8f3a9cf3ff5be6a9934b94f1b05:

  appveyor: add CI building of the Windows version of fio (2017-02-20 07:19:20 +0000)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8983ce71bc3aa4076cb0c9f2b5c3b73ab7c7de93:

  init: use 'bool' for get_new_job() (2017-02-21 20:53:48 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      init: exit on failure to add all jobs
      init: use 'bool' for get_new_job()

 init.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 0a2ace1..fabc887 100644
--- a/init.c
+++ b/init.c
@@ -435,8 +435,8 @@ static void copy_opt_list(struct thread_data *dst, struct thread_data *src)
 /*
  * Return a free job structure.
  */
-static struct thread_data *get_new_job(int global, struct thread_data *parent,
-				       int preserve_eo, const char *jobname)
+static struct thread_data *get_new_job(bool global, struct thread_data *parent,
+				       bool preserve_eo, const char *jobname)
 {
 	struct thread_data *td;
 
@@ -1560,7 +1560,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	 */
 	numjobs = o->numjobs;
 	while (--numjobs) {
-		struct thread_data *td_new = get_new_job(0, td, 1, jobname);
+		struct thread_data *td_new = get_new_job(false, td, true, jobname);
 
 		if (!td_new)
 			goto err;
@@ -1621,11 +1621,11 @@ void add_job_opts(const char **o, int client_type)
 			sprintf(jobname, "%s", o[i] + 5);
 		}
 		if (in_global && !td_parent)
-			td_parent = get_new_job(1, &def_thread, 0, jobname);
+			td_parent = get_new_job(true, &def_thread, false, jobname);
 		else if (!in_global && !td) {
 			if (!td_parent)
 				td_parent = &def_thread;
-			td = get_new_job(0, td_parent, 0, jobname);
+			td = get_new_job(false, td_parent, false, jobname);
 		}
 		if (in_global)
 			fio_options_parse(td_parent, (char **) &o[i], 1);
@@ -1677,7 +1677,7 @@ static int __parse_jobs_ini(struct thread_data *td,
 		char *file, int is_buf, int stonewall_flag, int type,
 		int nested, char *name, char ***popts, int *aopts, int *nopts)
 {
-	unsigned int global = 0;
+	bool global = false;
 	char *string;
 	FILE *f;
 	char *p;
@@ -1786,7 +1786,7 @@ static int __parse_jobs_ini(struct thread_data *td,
 				first_sect = 0;
 			}
 
-			td = get_new_job(global, &def_thread, 0, name);
+			td = get_new_job(global, &def_thread, false, name);
 			if (!td) {
 				ret = 1;
 				break;
@@ -2475,7 +2475,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				if (is_section && skip_this_section(val))
 					continue;
 
-				td = get_new_job(global, &def_thread, 1, NULL);
+				td = get_new_job(global, &def_thread, true, NULL);
 				if (!td || ioengine_load(td)) {
 					if (td) {
 						put_job(td);
@@ -2713,7 +2713,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 		if (!ret) {
 			ret = add_job(td, td->o.name ?: "fio", 0, 0, client_type);
 			if (ret)
-				did_arg = 1;
+				exit(1);
 		}
 	}
 
