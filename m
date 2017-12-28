Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46144 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753512AbdL1NAY (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Dec 2017 08:00:24 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eUXnL-0003DQ-Uw
        for fio@vger.kernel.org; Thu, 28 Dec 2017 13:00:24 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171228130002.93CE32C009F@kernel.dk>
Date: Thu, 28 Dec 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2fc703f639f1fac7d1f86917ba8bf4d0e81667b9:

  Merge branch 'eta_overflow' of https://github.com/sitsofe/fio (2017-12-21 08:22:39 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f7c305464667b118b62aff9b846d1a939fbc1547:

  Merge branch 'eta_display' of https://github.com/sitsofe/fio (2017-12-27 14:05:46 -0700)

----------------------------------------------------------------
Barak Pinhas (1):
      fix verify_only when using ioengine=mmap

Jens Axboe (2):
      Merge branch 'barak/mmap_verify_only' of https://github.com/barakp/fio
      Merge branch 'eta_display' of https://github.com/sitsofe/fio

Sitsofe Wheeler (5):
      eta: adjust truncation case
      eta: fix run_str_condensed overflow with maximum jobs
      eta: skip clearing of remainder of line when starting a new line
      eta: fix previous line length calculation
      eta: show complete status line with max job states

 engines/mmap.c |  4 ++--
 eta.c          | 20 ++++++++++++--------
 2 files changed, 14 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/engines/mmap.c b/engines/mmap.c
index bc038f4..51606e1 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -33,9 +33,9 @@ static int fio_mmap_file(struct thread_data *td, struct fio_file *f,
 	struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
 	int flags = 0;
 
-	if (td_rw(td))
+	if (td_rw(td) && !td->o.verify_only)
 		flags = PROT_READ | PROT_WRITE;
-	else if (td_write(td)) {
+	else if (td_write(td) && !td->o.verify_only) {
 		flags = PROT_WRITE;
 
 		if (td->o.verify != VERIFY_NONE)
diff --git a/eta.c b/eta.c
index 087f57d..0b79526 100644
--- a/eta.c
+++ b/eta.c
@@ -9,7 +9,7 @@
 #include "lib/pow2.h"
 
 static char __run_str[REAL_MAX_JOBS + 1];
-static char run_str[__THREAD_RUNSTR_SZ(REAL_MAX_JOBS)];
+static char run_str[__THREAD_RUNSTR_SZ(REAL_MAX_JOBS) + 1];
 
 static void update_condensed_str(char *rstr, char *run_str_condensed)
 {
@@ -520,7 +520,7 @@ void display_thread_status(struct jobs_eta *je)
 	static int eta_new_line_init, eta_new_line_pending;
 	static int linelen_last;
 	static int eta_good;
-	char output[REAL_MAX_JOBS + 512], *p = output;
+	char output[__THREAD_RUNSTR_SZ(REAL_MAX_JOBS) + 512], *p = output;
 	char eta_str[128];
 	double perc = 0.0;
 
@@ -531,6 +531,7 @@ void display_thread_status(struct jobs_eta *je)
 
 	if (eta_new_line_pending) {
 		eta_new_line_pending = 0;
+		linelen_last = 0;
 		p += sprintf(p, "\n");
 	}
 
@@ -564,6 +565,7 @@ void display_thread_status(struct jobs_eta *je)
 		size_t left;
 		int l;
 		int ddir;
+		int linelen;
 
 		if ((!je->eta_sec && !eta_good) || je->nr_ramp == je->nr_running ||
 		    je->eta_sec == -1)
@@ -585,7 +587,7 @@ void display_thread_status(struct jobs_eta *je)
 			iops_str[ddir] = num2str(je->iops[ddir], 4, 1, 0, N2S_NONE);
 		}
 
-		left = sizeof(output) - (p - output) - 2;
+		left = sizeof(output) - (p - output) - 1;
 
 		if (je->rate[DDIR_TRIM] || je->iops[DDIR_TRIM])
 			l = snprintf(p, left,
@@ -601,12 +603,14 @@ void display_thread_status(struct jobs_eta *je)
 				rate_str[DDIR_READ], rate_str[DDIR_WRITE],
 				iops_str[DDIR_READ], iops_str[DDIR_WRITE],
 				eta_str);
-		if (l > left)
-			l = left;
+		/* If truncation occurred adjust l so p is on the null */
+		if (l >= left)
+			l = left - 1;
 		p += l;
-		if (l >= 0 && l < linelen_last)
-			p += sprintf(p, "%*s", linelen_last - l, "");
-		linelen_last = l;
+		linelen = p - output;
+		if (l >= 0 && linelen < linelen_last)
+			p += sprintf(p, "%*s", linelen_last - linelen, "");
+		linelen_last = linelen;
 
 		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 			free(rate_str[ddir]);
