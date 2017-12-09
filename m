Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38782 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751228AbdLINAY (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 9 Dec 2017 08:00:24 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eNeju-0007dm-Pm
        for fio@vger.kernel.org; Sat, 09 Dec 2017 13:00:23 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171209130001.F29AD2C00A1@kernel.dk>
Date: Sat,  9 Dec 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1aa39b0ce447f228460e6d0af601fee88fd5f4b4:

  rate: ensure IO issue restarts right after sleep (2017-12-07 09:06:04 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e80d780108fd33350f7c4a3032a8d2d06d7b102f:

  fio: kill td->nr_normal_files (2017-12-08 12:50:28 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      rate: fix bad math
      Remove old emails
      fio: kill td->nr_normal_files

 backend.c                  | 11 +++++++++--
 filesetup.c                |  3 ---
 fio.1                      |  3 +--
 fio.h                      |  1 -
 init.c                     |  4 +---
 tools/fio_generate_plots.1 |  3 +--
 6 files changed, 12 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 5304ddc..e248117 100644
--- a/backend.c
+++ b/backend.c
@@ -898,8 +898,15 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir)
 	 * start issuing immediately after the sleep.
 	 */
 	if (total && td->rate_bps[ddir] && td->o.rate_ign_think) {
-		td->rate_io_issue_bytes[ddir] += (td->rate_bps[ddir] * 1000000) / total;
-		td->rate_io_issue_bytes[ddir] -= td->o.min_bs[ddir];
+		uint64_t missed = (td->rate_bps[ddir] * total) / 1000000ULL;
+		uint64_t over;
+
+		if (total >= 1000000)
+			over = td->o.min_bs[ddir];
+		else
+			over = (td->o.min_bs[ddir] * total) / 1000000ULL;
+
+		td->rate_io_issue_bytes[ddir] += (missed - over);
 	}
 }
 
diff --git a/filesetup.c b/filesetup.c
index 1d586b1..30af085 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1628,8 +1628,6 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 	}
 
 	td->files_index++;
-	if (f->filetype == FIO_TYPE_FILE)
-		td->nr_normal_files++;
 
 	if (td->o.numjobs > 1)
 		set_already_allocated(file_name);
@@ -1855,7 +1853,6 @@ void free_release_files(struct thread_data *td)
 	td->o.nr_files = 0;
 	td->o.open_files = 0;
 	td->files_index = 0;
-	td->nr_normal_files = 0;
 }
 
 void fio_file_reset(struct thread_data *td, struct fio_file *f)
diff --git a/fio.1 b/fio.1
index 80abc14..57ab665 100644
--- a/fio.1
+++ b/fio.1
@@ -3559,8 +3559,7 @@ containing two hostnames `h1' and `h2' with IP addresses 192.168.10.120 and
 .RE
 .SH AUTHORS
 .B fio
-was written by Jens Axboe <jens.axboe@oracle.com>,
-now Jens Axboe <axboe@fb.com>.
+was written by Jens Axboe <axboe@kernel.dk>.
 .br
 This man page was written by Aaron Carroll <aaronc@cse.unsw.edu.au> based
 on documentation by Jens Axboe.
diff --git a/fio.h b/fio.h
index 6b184c2..8a65646 100644
--- a/fio.h
+++ b/fio.h
@@ -208,7 +208,6 @@ struct thread_data {
 	unsigned int files_index;
 	unsigned int nr_open_files;
 	unsigned int nr_done_files;
-	unsigned int nr_normal_files;
 	union {
 		unsigned int next_file;
 		struct frand_state next_file_state;
diff --git a/init.c b/init.c
index c34bd15..b77b299 100644
--- a/init.c
+++ b/init.c
@@ -2142,9 +2142,7 @@ static void usage(const char *name)
 	printf("  --trigger=cmd\t\tSet this command as local trigger\n");
 	printf("  --trigger-remote=cmd\tSet this command as remote trigger\n");
 	printf("  --aux-path=path\tUse this path for fio state generated files\n");
-	printf("\nFio was written by Jens Axboe <jens.axboe@oracle.com>");
-	printf("\n                   Jens Axboe <jaxboe@fusionio.com>");
-	printf("\n                   Jens Axboe <axboe@fb.com>\n");
+	printf("\nFio was written by Jens Axboe <axboe@kernel.dk>\n");
 }
 
 #ifdef FIO_INC_DEBUG
diff --git a/tools/fio_generate_plots.1 b/tools/fio_generate_plots.1
index 9e3c1ff..92b2421 100644
--- a/tools/fio_generate_plots.1
+++ b/tools/fio_generate_plots.1
@@ -38,8 +38,7 @@ generated in the current directory.
 The script takes the title of the plot as only argument. It does
 not offer any additional options.
 .SH AUTHOR
-fio_generate_plots was written by Jens Axboe <jens.axboe@oracle.com>,
-now Jens Axboe <jaxboe@fusionio.com>.
+fio_generate_plots was written by Jens Axboe <axboe@kernel.dk>
 .PP
 This manual page was written by Martin Steigerwald <ms@teamix.de>,
 for the Debian project (but may be used by others).
