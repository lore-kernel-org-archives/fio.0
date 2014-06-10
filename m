Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49083 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaFJMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 10 Jun 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WuKii-0007Ww-96
	for fio@vger.kernel.org; Tue, 10 Jun 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140610120003.184C5400C3@lyth.info>
Date: Tue, 10 Jun 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 78c8831e2ec211a293ccd8bd37c169719ca1ba4a:

  Add aarch64 support. (2014-06-08 21:17:49 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 70afff5949ccad1196256763aab69b2528b55d88:

  iolog: remember to add bytes to total IO size (2014-06-09 19:56:51 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      Fix regression introduced by commit 334185e
      Fix crash on loading unknown IO engine with --ioengine
      Reset file count when freeing files
      iolog: remember to add bytes to total IO size

 backend.c   |    5 -----
 filesetup.c |    2 ++
 init.c      |   20 ++++++++++++++++----
 iolog.c     |    1 +
 server.c    |    1 +
 5 files changed, 20 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index d1d5571..23fa345 100644
--- a/backend.c
+++ b/backend.c
@@ -1270,11 +1270,6 @@ static void *thread_main(void *data)
 	} else
 		td->pid = gettid();
 
-	/*
-	 * fio_time_init() may not have been called yet if running as a server
-	 */
-	fio_time_init();
-
 	fio_local_clock_init(o->use_thread);
 
 	dprint(FD_PROCESS, "jobs pid=%d started\n", (int) td->pid);
diff --git a/filesetup.c b/filesetup.c
index 84eaed6..2049fd6 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1524,6 +1524,8 @@ int get_fileno(struct thread_data *td, const char *fname)
 void free_release_files(struct thread_data *td)
 {
 	close_files(td);
+	td->o.nr_files = 0;
+	td->o.open_files = 0;
 	td->files_index = 0;
 	td->nr_normal_files = 0;
 }
diff --git a/init.c b/init.c
index a546861..74a02e0 100644
--- a/init.c
+++ b/init.c
@@ -1884,8 +1884,14 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 					continue;
 
 				td = get_new_job(global, &def_thread, 1);
-				if (!td || ioengine_load(td))
-					goto out_free;
+				if (!td || ioengine_load(td)) {
+					if (td) {
+						put_job(td);
+						td = NULL;
+					}
+					do_exit++;
+					break;
+				}
 				fio_options_set_ioengine_opts(l_opts, td);
 			}
 
@@ -1906,8 +1912,14 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 
 			if (!ret && !strcmp(opt, "ioengine")) {
 				free_ioengine(td);
-				if (ioengine_load(td))
-					goto out_free;
+				if (ioengine_load(td)) {
+					if (td) {
+						put_job(td);
+						td = NULL;
+					}
+					do_exit++;
+					break;
+				}
 				fio_options_set_ioengine_opts(l_opts, td);
 			}
 			break;
diff --git a/iolog.c b/iolog.c
index cac1aba..fd1e9e4 100644
--- a/iolog.c
+++ b/iolog.c
@@ -410,6 +410,7 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 				td->o.max_bs[rw] = bytes;
 			ipo->fileno = fileno;
 			ipo->file_action = file_action;
+			td->o.size += bytes;
 		}
 
 		queue_io_piece(td, ipo);
diff --git a/server.c b/server.c
index 077dce5..8865502 100644
--- a/server.c
+++ b/server.c
@@ -555,6 +555,7 @@ static int handle_run_cmd(struct flist_head *job_list, struct fio_net_cmd *cmd)
 	pid_t pid;
 	int ret;
 
+	fio_time_init();
 	set_genesis_time();
 
 	pid = fork();
