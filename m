Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36327 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdLCNAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 3 Dec 2017 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eLTsM-0005tK-3n
        for fio@vger.kernel.org; Sun, 03 Dec 2017 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171203130001.CCF2B2C0137@kernel.dk>
Date: Sun,  3 Dec 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e0409d5ffe6127961ddc4c495ec32b72a65e11bf:

  thread_options: drop fadvise_stream from thread_options (2017-12-01 14:54:49 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to af7fb4aa2835b82847701237783c9ebe8ec8239a:

  steadystate: style cleanup (2017-12-02 16:29:44 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      steadystate: add free helper
      steadystate: style cleanup

 backend.c       |  7 +------
 helper_thread.c |  3 +--
 steadystate.c   | 16 +++++++++++-----
 steadystate.h   |  1 +
 4 files changed, 14 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 10eb90e..6c805c7 100644
--- a/backend.c
+++ b/backend.c
@@ -2480,12 +2480,7 @@ int fio_backend(struct sk_out *sk_out)
 	}
 
 	for_each_td(td, i) {
-		if (td->ss.dur) {
-			if (td->ss.iops_data != NULL) {
-				free(td->ss.iops_data);
-				free(td->ss.bw_data);
-			}
-		}
+		steadystate_free(td);
 		fio_options_free(td);
 		if (td->rusage_sem) {
 			fio_mutex_remove(td->rusage_sem);
diff --git a/helper_thread.c b/helper_thread.c
index 9c6e0a2..64e5a3c 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -134,8 +134,7 @@ static void *helper_thread_main(void *data)
 					next_ss = STEADYSTATE_MSEC - (since_ss - STEADYSTATE_MSEC);
 				else
 					next_ss = STEADYSTATE_MSEC;
-			}
-			else
+			} else
 				next_ss = STEADYSTATE_MSEC - since_ss;
                 }
 
diff --git a/steadystate.c b/steadystate.c
index 05ce029..2017ca6 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -6,6 +6,14 @@
 
 bool steadystate_enabled = false;
 
+void steadystate_free(struct thread_data *td)
+{
+	free(td->ss.iops_data);
+	free(td->ss.bw_data);
+	td->ss.iops_data = NULL;
+	td->ss.bw_data = NULL;
+}
+
 static void steadystate_alloc(struct thread_data *td)
 {
 	td->ss.bw_data = calloc(td->ss.dur, sizeof(uint64_t));
@@ -16,8 +24,8 @@ static void steadystate_alloc(struct thread_data *td)
 
 void steadystate_setup(void)
 {
-	int i, prev_groupid;
 	struct thread_data *td, *prev_td;
+	int i, prev_groupid;
 
 	if (!steadystate_enabled)
 		return;
@@ -39,17 +47,15 @@ void steadystate_setup(void)
 		}
 
 		if (prev_groupid != td->groupid) {
-			if (prev_td != NULL) {
+			if (prev_td)
 				steadystate_alloc(prev_td);
-			}
 			prev_groupid = td->groupid;
 		}
 		prev_td = td;
 	}
 
-	if (prev_td != NULL && prev_td->o.group_reporting) {
+	if (prev_td && prev_td->o.group_reporting)
 		steadystate_alloc(prev_td);
-	}
 }
 
 static bool steadystate_slope(uint64_t iops, uint64_t bw,
diff --git a/steadystate.h b/steadystate.h
index eaba0d7..9fd88ee 100644
--- a/steadystate.h
+++ b/steadystate.h
@@ -5,6 +5,7 @@
 #include "thread_options.h"
 #include "lib/ieee754.h"
 
+extern void steadystate_free(struct thread_data *);
 extern void steadystate_check(void);
 extern void steadystate_setup(void);
 extern int td_steadystate_init(struct thread_data *);
