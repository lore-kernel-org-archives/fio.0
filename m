Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39043 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaFXMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 24 Jun 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WzPOP-0001YT-2H
	for fio@vger.kernel.org; Tue, 24 Jun 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140624120003.D17F1400D1@lyth.info>
Date: Tue, 24 Jun 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c89318761586dbd77b8f31ce0ed68ff4fc086c89:

  Add support for compiling for ESX (2014-06-18 15:30:09 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 111558579a2f1965ff3f6a67ecb8ee4b596a4f88:

  Ensure we have enough room for the ETA runstr (2014-06-23 19:07:12 -0600)

----------------------------------------------------------------
Andreas Gruenbacher (1):
      Fix two minor typos

Jens Axboe (2):
      README: update to include official mirrors for the git repo
      Ensure we have enough room for the ETA runstr

 HOWTO    |   10 +++++-----
 README   |   11 +++++++++++
 eta.c    |    6 +++---
 server.c |    2 +-
 stat.h   |    3 +++
 5 files changed, 23 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index cad175c..d9f3095 100644
--- a/HOWTO
+++ b/HOWTO
@@ -81,7 +81,7 @@ $ fio job_file
 and it will start doing what the job_file tells it to do. You can give
 more than one job file on the command line, fio will serialize the running
 of those files. Internally that is the same as using the 'stonewall'
-parameter described the the parameter section.
+parameter described in the parameter section.
 
 If the job file contains only one job, you may as well just give the
 parameters on the command line. The command line parameters are identical
@@ -424,10 +424,10 @@ size=int	The total size of file io for this job. Fio will run until
 		Unless specific nrfiles and filesize options are given,
 		fio will divide this size between the available files
 		specified by the job. If not set, fio will use the full
-		size of the given files or devices. If the the files
-		do not exist, size must be given. It is also possible to
-		give size as a percentage between 1 and 100. If size=20%
-		is given, fio will use 20% of the full size of the given
+		size of the given files or devices. If the files do not
+		exist, size must be given. It is also possible to give
+		size as a percentage between 1 and 100. If size=20% is
+		given, fio will use 20% of the full size of the given
 		files or devices.
 
 io_limit=int	Normally fio operates within the region set by 'size', which
diff --git a/README b/README
index 2be0bfd..5897339 100644
--- a/README
+++ b/README
@@ -26,6 +26,17 @@ Snapshots can download from:
 
 	http://brick.kernel.dk/snaps/
 
+There are also two official mirrors. Both of these are synced within
+an hour of commits landing at git.kernel.dk. So if the main repo is
+down for some reason, either one of those is safe to use:
+
+	git://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio.git
+	https://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio.git
+
+or
+
+	https://github.com/axboe/fio.git
+
 
 Binary packages
 ---------------
diff --git a/eta.c b/eta.c
index 0dd04be..dfe66f9 100644
--- a/eta.c
+++ b/eta.c
@@ -10,9 +10,9 @@
 static char __run_str[REAL_MAX_JOBS + 1];
 
 /*
- * Worst level condensing would be 1:4, so allow enough room for that
+ * Worst level condensing would be 1:5, so allow enough room for that
  */
-static char run_str[(4 * REAL_MAX_JOBS) + 1];
+static char run_str[__THREAD_RUNSTR_SZ(REAL_MAX_JOBS)];
 
 static void update_condensed_str(char *run_str, char *run_str_condensed)
 {
@@ -592,7 +592,7 @@ void print_thread_status(void)
 	if (!thread_number)
 		return;
 
-	size = sizeof(*je) + thread_number * sizeof(char) + 1;
+	size = sizeof(*je) + THREAD_RUNSTR_SZ;
 	je = malloc(size);
 	memset(je, 0, size);
 
diff --git a/server.c b/server.c
index 8865502..e20f592 100644
--- a/server.c
+++ b/server.c
@@ -673,7 +673,7 @@ static int handle_send_eta_cmd(struct fio_net_cmd *cmd)
 	if (!thread_number)
 		return 0;
 
-	size = sizeof(*je) + thread_number * sizeof(char) + 1;
+	size = sizeof(*je) + THREAD_RUNSTR_SZ;
 	je = malloc(size);
 	memset(je, 0, size);
 
diff --git a/stat.h b/stat.h
index 3f68305..2c2f1e1 100644
--- a/stat.h
+++ b/stat.h
@@ -241,4 +241,7 @@ static inline int usec_to_msec(unsigned long *min, unsigned long *max,
 	return 1;
 }
 
+#define __THREAD_RUNSTR_SZ(nr)	(((nr) * 5) + 1)
+#define THREAD_RUNSTR_SZ	__THREAD_RUNSTR_SZ(thread_number)
+
 #endif
