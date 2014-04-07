Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43604 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbaDGMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 7 Apr 2014 08:00:03 -0400
Received: from kernel.dk ([54.225.238.116] helo=rt116.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WX8Db-0004Qp-Cg
	for fio@vger.kernel.org; Mon, 07 Apr 2014 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140407120002.E12744012E@rt116.dk>
Date: Mon,  7 Apr 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7788b76fe13059aa3610f592e58512cb5f4cdb28:

  Makefile: add doc target to generate PDFs from the man pages (2014-04-04 08:28:17 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bc4f5ef67d26ef98f4822d5f798cb8c4e2d2fce5:

  Support limited mixed command line options and job file (2014-04-06 10:10:32 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      Fix crash in setup_files() if no files are defined
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio
      Fixup --timeout command line option
      Support limited mixed command line options and job file

 filesetup.c |    2 +-
 init.c      |   25 ++++++++++++++++++++-----
 2 files changed, 21 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index fa09219..bf05b6f 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -806,7 +806,7 @@ int setup_files(struct thread_data *td)
 	 * Calculate per-file size and potential extra size for the
 	 * first files, if needed.
 	 */
-	if (!o->file_size_low) {
+	if (!o->file_size_low && o->nr_files) {
 		uint64_t all_fs;
 
 		fs = o->size / o->nr_files;
diff --git a/init.c b/init.c
index 910f2ba..e9e49eb 100644
--- a/init.c
+++ b/init.c
@@ -38,7 +38,7 @@ const char fio_version_string[] = FIO_VERSION;
 static char **ini_file;
 static int max_jobs = FIO_MAX_JOBS;
 static int dump_cmdline;
-static int def_timeout;
+static long long def_timeout;
 static int parse_only;
 
 static struct thread_data def_thread;
@@ -318,6 +318,14 @@ static int setup_thread_area(void)
 	return 0;
 }
 
+static void set_cmd_options(struct thread_data *td)
+{
+	struct thread_options *o = &td->o;
+
+	if (!o->timeout)
+		o->timeout = def_timeout;
+}
+
 /*
  * Return a free job structure.
  */
@@ -326,8 +334,10 @@ static struct thread_data *get_new_job(int global, struct thread_data *parent,
 {
 	struct thread_data *td;
 
-	if (global)
+	if (global) {
+		set_cmd_options(&def_thread);
 		return &def_thread;
+	}
 	if (setup_thread_area()) {
 		log_err("error: failed to setup shm segment\n");
 		return NULL;
@@ -357,6 +367,7 @@ static struct thread_data *get_new_job(int global, struct thread_data *parent,
 	if (!parent || !parent->o.group_reporting)
 		stat_number++;
 
+	set_cmd_options(td);
 	return td;
 }
 
@@ -1440,8 +1451,8 @@ static int fill_def_thread(void)
 	memset(&def_thread, 0, sizeof(def_thread));
 
 	fio_getaffinity(getpid(), &def_thread.o.cpumask);
-	def_thread.o.timeout = def_timeout;
 	def_thread.o.error_dump = 1;
+
 	/*
 	 * fill default options
 	 */
@@ -1695,7 +1706,11 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			smalloc_pool_size = atoi(optarg);
 			break;
 		case 't':
-			def_timeout = atoi(optarg);
+			if (check_str_time(optarg, &def_timeout, 1)) {
+				log_err("fio: failed parsing time %s\n", optarg);
+				do_exit++;
+				exit_val = 1;
+			}
 			break;
 		case 'l':
 			write_lat_log = 1;
@@ -2018,7 +2033,7 @@ int parse_options(int argc, char *argv[])
 
 	if (job_files > 0) {
 		for (i = 0; i < job_files; i++) {
-			if (fill_def_thread())
+			if (i && fill_def_thread())
 				return 1;
 			if (nr_clients) {
 				if (fio_clients_send_ini(ini_file[i]))
