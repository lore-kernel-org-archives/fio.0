Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55040 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbaFYMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 25 Jun 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Wzlrw-0004xI-HQ
	for fio@vger.kernel.org; Wed, 25 Jun 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140625120003.3E92C400B9@lyth.info>
Date: Wed, 25 Jun 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 111558579a2f1965ff3f6a67ecb8ee4b596a4f88:

  Ensure we have enough room for the ETA runstr (2014-06-23 19:07:12 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a606a802173272002e37be6475802be8c37481d6:

  Cast input argument for json_object_add_value_int to long long (2014-06-24 19:31:22 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Add a get_jobs_eta() to return jobs eta information
      Ensure that job name is set before being used
      Get the crctest results properly aligned

Puthikorn Voravootivat (1):
      Cast input argument for json_object_add_value_int to long long

 crc/test.c |    2 +-
 eta.c      |   31 ++++++++++++++++++++-----------
 init.c     |   18 ++++++++++++------
 json.h     |    2 +-
 server.c   |   14 +++-----------
 stat.h     |    8 ++++++--
 6 files changed, 43 insertions(+), 32 deletions(-)

---

Diff of recent changes:

diff --git a/crc/test.c b/crc/test.c
index 3773b71..3ce717a 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -373,7 +373,7 @@ int fio_crctest(const char *type)
 		usec = t[i].fn();
 		mb_sec = (double) mb / (double) usec;
 		mb_sec /= (1.024 * 1.024);
-		printf("%s:\t%.2f MB/sec\n", t[i].name, mb_sec);
+		printf("%s:\t%8.2f MB/sec\n", t[i].name, mb_sec);
 	}
 
 	return 0;
diff --git a/eta.c b/eta.c
index dfe66f9..bdd5376 100644
--- a/eta.c
+++ b/eta.c
@@ -8,10 +8,6 @@
 #include "fio.h"
 
 static char __run_str[REAL_MAX_JOBS + 1];
-
-/*
- * Worst level condensing would be 1:5, so allow enough room for that
- */
 static char run_str[__THREAD_RUNSTR_SZ(REAL_MAX_JOBS)];
 
 static void update_condensed_str(char *run_str, char *run_str_condensed)
@@ -584,19 +580,32 @@ void display_thread_status(struct jobs_eta *je)
 	fflush(stdout);
 }
 
-void print_thread_status(void)
+struct jobs_eta *get_jobs_eta(int force, size_t *size)
 {
 	struct jobs_eta *je;
-	size_t size;
 
 	if (!thread_number)
-		return;
+		return NULL;
 
-	size = sizeof(*je) + THREAD_RUNSTR_SZ;
-	je = malloc(size);
-	memset(je, 0, size);
+	*size = sizeof(*je) + THREAD_RUNSTR_SZ;
+	je = malloc(*size);
+	memset(je, 0, *size);
+
+	if (!calc_thread_status(je, 0)) {
+		free(je);
+		return NULL;
+	}
+
+	return je;
+}
+
+void print_thread_status(void)
+{
+	struct jobs_eta *je;
+	size_t size;
 
-	if (calc_thread_status(je, 0))
+	je = get_jobs_eta(0, &size);
+	if (je)
 		display_thread_status(je);
 
 	free(je);
diff --git a/init.c b/init.c
index d44eb5b..6b29aa7 100644
--- a/init.c
+++ b/init.c
@@ -342,7 +342,7 @@ static void set_cmd_options(struct thread_data *td)
  * Return a free job structure.
  */
 static struct thread_data *get_new_job(int global, struct thread_data *parent,
-				       int preserve_eo)
+				       int preserve_eo, const char *jobname)
 {
 	struct thread_data *td;
 
@@ -376,6 +376,9 @@ static struct thread_data *get_new_job(int global, struct thread_data *parent,
 
 	td->thread_number = thread_number;
 
+	if (jobname)
+		td->o.name = strdup(jobname);
+
 	if (!parent->o.group_reporting)
 		stat_number++;
 
@@ -398,6 +401,9 @@ static void put_job(struct thread_data *td)
 	if (td->io_ops)
 		free_ioengine(td);
 
+	if (td->o.name)
+		free(td->o.name);
+
 	memset(&threads[td->thread_number - 1], 0, sizeof(*td));
 	thread_number--;
 }
@@ -1202,7 +1208,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	 */
 	numjobs = o->numjobs;
 	while (--numjobs) {
-		struct thread_data *td_new = get_new_job(0, td, 1);
+		struct thread_data *td_new = get_new_job(0, td, 1, jobname);
 
 		if (!td_new)
 			goto err;
@@ -1260,11 +1266,11 @@ void add_job_opts(const char **o, int client_type)
 			sprintf(jobname, "%s", o[i] + 5);
 		}
 		if (in_global && !td_parent)
-			td_parent = get_new_job(1, &def_thread, 0);
+			td_parent = get_new_job(1, &def_thread, 0, jobname);
 		else if (!in_global && !td) {
 			if (!td_parent)
 				td_parent = &def_thread;
-			td = get_new_job(0, td_parent, 0);
+			td = get_new_job(0, td_parent, 0, jobname);
 		}
 		if (in_global)
 			fio_options_parse(td_parent, (char **) &o[i], 1, 0);
@@ -1399,7 +1405,7 @@ int parse_jobs_ini(char *file, int is_buf, int stonewall_flag, int type)
 			first_sect = 0;
 		}
 
-		td = get_new_job(global, &def_thread, 0);
+		td = get_new_job(global, &def_thread, 0, name);
 		if (!td) {
 			ret = 1;
 			break;
@@ -1895,7 +1901,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				if (is_section && skip_this_section(val))
 					continue;
 
-				td = get_new_job(global, &def_thread, 1);
+				td = get_new_job(global, &def_thread, 1, NULL);
 				if (!td || ioengine_load(td)) {
 					if (td) {
 						put_job(td);
diff --git a/json.h b/json.h
index 081afd6..962c11c 100644
--- a/json.h
+++ b/json.h
@@ -52,7 +52,7 @@ void json_free_object(struct json_object *obj);
 
 int json_object_add_value_type(struct json_object *obj, const char *name, int type, ...);
 #define json_object_add_value_int(obj, name, val) \
-	json_object_add_value_type((obj), name, JSON_TYPE_INTEGER, (val))
+	json_object_add_value_type((obj), name, JSON_TYPE_INTEGER, (long long) (val))
 #define json_object_add_value_float(obj, name, val) \
 	json_object_add_value_type((obj), name, JSON_TYPE_FLOAT, (val))
 #define json_object_add_value_string(obj, name, val) \
diff --git a/server.c b/server.c
index e20f592..76b6b54 100644
--- a/server.c
+++ b/server.c
@@ -666,21 +666,13 @@ static int handle_probe_cmd(struct fio_net_cmd *cmd)
 static int handle_send_eta_cmd(struct fio_net_cmd *cmd)
 {
 	struct jobs_eta *je;
-	size_t size;
 	uint64_t tag = cmd->tag;
+	size_t size;
 	int i;
 
-	if (!thread_number)
-		return 0;
-
-	size = sizeof(*je) + THREAD_RUNSTR_SZ;
-	je = malloc(size);
-	memset(je, 0, size);
-
-	if (!calc_thread_status(je, 1)) {
-		free(je);
+	je = get_jobs_eta(1, &size);
+	if (!je)
 		return 0;
-	}
 
 	dprint(FD_NET, "server sending status\n");
 
diff --git a/stat.h b/stat.h
index 2c2f1e1..6f9d82a 100644
--- a/stat.h
+++ b/stat.h
@@ -205,6 +205,8 @@ struct jobs_eta {
 	uint8_t run_str[];
 };
 
+extern struct jobs_eta *get_jobs_eta(int force, size_t *size);
+
 extern void stat_init(void);
 extern void stat_exit(void);
 
@@ -240,8 +242,10 @@ static inline int usec_to_msec(unsigned long *min, unsigned long *max,
 
 	return 1;
 }
-
-#define __THREAD_RUNSTR_SZ(nr)	(((nr) * 5) + 1)
+/*
+ * Worst level condensing would be 1:5, so allow enough room for that
+ */
+#define __THREAD_RUNSTR_SZ(nr)	((nr) * 5)
 #define THREAD_RUNSTR_SZ	__THREAD_RUNSTR_SZ(thread_number)
 
 #endif
