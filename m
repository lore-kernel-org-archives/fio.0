Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH v2 7/7] Use 0 instead of DDIR_READ to iterate from 0 to DDIR_RWDIR_CNT
Date: Tue, 14 Feb 2017 17:19:48 +0200
Message-Id: <20170214151948.16460-8-tkusumi@tuxera.com>
In-Reply-To: <20170214151948.16460-1-tkusumi@tuxera.com>
References: <20170214151948.16460-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

I think this is better since we want to count up DDIR_RWDIR_CNT,
but not specifically (count - something) even if something is 0,
and that's basically what DDIR_RWDIR_CNT is there for to equal
SYNC=3 after READ/WRITE/TRIM in io_ddir.h.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 eta.c         | 6 +++---
 io_u.c        | 6 +++---
 stat.c        | 4 ++--
 steadystate.c | 2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/eta.c b/eta.c
index 1d66163..adf7f94 100644
--- a/eta.c
+++ b/eta.c
@@ -440,7 +440,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 		if (td->runstate > TD_SETTING_UP) {
 			int ddir;
 
-			for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
+			for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 				if (unified_rw_rep) {
 					io_bytes[0] += td->io_bytes[ddir];
 					io_iops[0] += td->io_blocks[ddir];
@@ -574,7 +574,7 @@ void display_thread_status(struct jobs_eta *je)
 			sprintf(perc_str, "%3.1f%%", perc);
 		}
 
-		for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
+		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 			rate_str[ddir] = num2str(je->rate[ddir], 4,
 						1024, je->is_pow2, je->unit_base);
 			iops_str[ddir] = num2str(je->iops[ddir], 4, 1, 0, N2S_NONE);
@@ -601,7 +601,7 @@ void display_thread_status(struct jobs_eta *je)
 			p += sprintf(p, "%*s", linelen_last - l, "");
 		linelen_last = l;
 
-		for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
+		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 			free(rate_str[ddir]);
 			free(iops_str[ddir]);
 		}
diff --git a/io_u.c b/io_u.c
index 1daaf7b..f1a3916 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1902,7 +1902,7 @@ static void init_icd(struct thread_data *td, struct io_completion_data *icd,
 	icd->nr = nr;
 
 	icd->error = 0;
-	for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++)
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
 		icd->bytes_done[ddir] = 0;
 }
 
@@ -1941,7 +1941,7 @@ int io_u_sync_complete(struct thread_data *td, struct io_u *io_u)
 		return -1;
 	}
 
-	for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++)
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
 		td->bytes_done[ddir] += icd.bytes_done[ddir];
 
 	return 0;
@@ -1980,7 +1980,7 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
 		return -1;
 	}
 
-	for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++)
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
 		td->bytes_done[ddir] += icd.bytes_done[ddir];
 
 	return ret;
diff --git a/stat.c b/stat.c
index f1d468c..0bb21d0 100644
--- a/stat.c
+++ b/stat.c
@@ -2442,7 +2442,7 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 	/*
 	 * Compute both read and write rates for the interval.
 	 */
-	for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 		uint64_t delta;
 
 		delta = td->this_io_bytes[ddir] - td->stat_io_bytes[ddir];
@@ -2517,7 +2517,7 @@ static int add_iops_samples(struct thread_data *td, struct timeval *t)
 	/*
 	 * Compute both read and write rates for the interval.
 	 */
-	for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 		uint64_t delta;
 
 		delta = td->this_io_blocks[ddir] - td->stat_io_blocks[ddir];
diff --git a/steadystate.c b/steadystate.c
index 43c715c..98f027c 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -231,7 +231,7 @@ void steadystate_check(void)
 		}
 
 		td_io_u_lock(td);
-		for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
+		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 			td_iops += td->io_blocks[ddir];
 			td_bytes += td->io_bytes[ddir];
 		}
-- 
2.9.3


