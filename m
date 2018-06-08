Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37158 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbeFHMAW (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 8 Jun 2018 08:00:22 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fRG45-0006y1-75
        for fio@vger.kernel.org; Fri, 08 Jun 2018 12:00:21 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180608120001.C3B0E2C00CF@kernel.dk>
Date: Fri,  8 Jun 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a43f4461d5716c4c46018dd45cecf0a896d05dbd:

  Fix variable shadowing (2018-06-05 13:44:47 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7ceefc0914b9ff721047b4dc8be54625d43f577c:

  idle-prof: Fix segment fault issue when run with '--idle-prof' and multiple output format normal,json (2018-06-07 20:27:25 -0600)

----------------------------------------------------------------
Friendy.Su@sony.com (1):
      idle-prof: Fix segment fault issue when run with '--idle-prof' and multiple output format normal,json

 idletime.c | 8 +-------
 idletime.h | 2 ++
 stat.c     | 2 ++
 3 files changed, 5 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/idletime.c b/idletime.c
index 8762c85..2f59f51 100644
--- a/idletime.c
+++ b/idletime.c
@@ -397,7 +397,7 @@ static double fio_idle_prof_cpu_stat(int cpu)
 	return p * 100.0;
 }
 
-static void fio_idle_prof_cleanup(void)
+void fio_idle_prof_cleanup(void)
 {
 	if (ipc.ipts) {
 		free(ipc.ipts);
@@ -471,10 +471,6 @@ void show_idle_prof_stats(int output, struct json_object *parent,
 			log_buf(out, " stddev=%3.2f\n", ipc.cali_stddev);
 		}
 
-		/* dynamic mem allocations can now be freed */
-		if (ipc.opt != IDLE_PROF_OPT_NONE)
-			fio_idle_prof_cleanup();
-
 		return;
 	}
 
@@ -498,7 +494,5 @@ void show_idle_prof_stats(int output, struct json_object *parent,
 
 		json_object_add_value_float(tmp, "unit_mean", ipc.cali_mean);
 		json_object_add_value_float(tmp, "unit_stddev", ipc.cali_stddev);
-		
-		fio_idle_prof_cleanup();
 	}
 }
diff --git a/idletime.h b/idletime.h
index 6c1161a..91ca95f 100644
--- a/idletime.h
+++ b/idletime.h
@@ -58,4 +58,6 @@ extern void fio_idle_prof_stop(void);
 
 extern void show_idle_prof_stats(int, struct json_object *, struct buf_output *);
 
+extern void fio_idle_prof_cleanup(void);
+
 #endif
diff --git a/stat.c b/stat.c
index 5b49ddd..58edf04 100644
--- a/stat.c
+++ b/stat.c
@@ -1934,6 +1934,8 @@ void __show_run_stats(void)
 		buf_output_free(out);
 	}
 
+	fio_idle_prof_cleanup();
+
 	log_info_flush();
 	free(runstats);
 	free(threadstats);
