Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52804 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbeHKOeM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 11 Aug 2018 10:34:12 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1foSZ3-000593-2j
        for fio@vger.kernel.org; Sat, 11 Aug 2018 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180811120001.9F5C32C007D@kernel.dk>
Date: Sat, 11 Aug 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ae48493039f833119126ef979dbe86aee2c05557:

  Merge branch 'realloc-io_u-buffers' of https://github.com/aclamk/fio (2018-08-09 09:31:26 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 73027fb9ad6728f5b066e25a9ec923459ceab8a2:

  eta: clean up ETA string printing (2018-08-10 09:33:44 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      eta: clean up ETA string printing

 eta.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 60 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/eta.c b/eta.c
index 9111f5e..970a67d 100644
--- a/eta.c
+++ b/eta.c
@@ -518,6 +518,63 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	return true;
 }
 
+static int gen_eta_str(struct jobs_eta *je, char *p, size_t left,
+		       char **rate_str, char **iops_str)
+{
+	bool has_r = je->rate[DDIR_READ] || je->iops[DDIR_READ];
+	bool has_w = je->rate[DDIR_WRITE] || je->iops[DDIR_WRITE];
+	bool has_t = je->rate[DDIR_TRIM] || je->iops[DDIR_TRIM];
+	int l = 0;
+
+	if (!has_r && !has_w && !has_t)
+		return 0;
+
+	if (has_r) {
+		l += snprintf(p + l, left - l, "[r=%s", rate_str[DDIR_READ]);
+		if (!has_w)
+			l += snprintf(p + l, left - l, "]");
+	}
+	if (has_w) {
+		if (has_r)
+			l += snprintf(p + l, left - l, ",");
+		else
+			l += snprintf(p + l, left - l, "[");
+		l += snprintf(p + l, left - l, "w=%s", rate_str[DDIR_WRITE]);
+		if (!has_t)
+			l += snprintf(p + l, left - l, "]");
+	}
+	if (has_t) {
+		if (has_r || has_w)
+			l += snprintf(p + l, left - l, ",");
+		else if (!has_r && !has_w)
+			l += snprintf(p + l, left - l, "[");
+		l += snprintf(p + l, left - l, "t=%s]", rate_str[DDIR_TRIM]);
+	}
+	if (has_r) {
+		l += snprintf(p + l, left - l, "[r=%s", iops_str[DDIR_READ]);
+		if (!has_w)
+			l += snprintf(p + l, left - l, " IOPS]");
+	}
+	if (has_w) {
+		if (has_r)
+			l += snprintf(p + l, left - l, ",");
+		else
+			l += snprintf(p + l, left - l, "[");
+		l += snprintf(p + l, left - l, "w=%s", iops_str[DDIR_WRITE]);
+		if (!has_t)
+			l += snprintf(p + l, left - l, " IOPS]");
+	}
+	if (has_t) {
+		if (has_r || has_w)
+			l += snprintf(p + l, left - l, ",");
+		else if (!has_r && !has_w)
+			l += snprintf(p + l, left - l, "[");
+		l += snprintf(p + l, left - l, "t=%s IOPS]", iops_str[DDIR_TRIM]);
+	}
+
+	return l;
+}
+
 void display_thread_status(struct jobs_eta *je)
 {
 	static struct timespec disp_eta_new_line;
@@ -592,21 +649,10 @@ void display_thread_status(struct jobs_eta *je)
 		}
 
 		left = sizeof(output) - (p - output) - 1;
+		l = snprintf(p, left, ": [%s][%s]", je->run_str, perc_str);
+		l += gen_eta_str(je, p + l, left - l, rate_str, iops_str);
+		l += snprintf(p + l, left - l, "[eta %s]", eta_str);
 
-		if (je->rate[DDIR_TRIM] || je->iops[DDIR_TRIM])
-			l = snprintf(p, left,
-				": [%s][%s][r=%s,w=%s,t=%s][r=%s,w=%s,t=%s IOPS][eta %s]",
-				je->run_str, perc_str, rate_str[DDIR_READ],
-				rate_str[DDIR_WRITE], rate_str[DDIR_TRIM],
-				iops_str[DDIR_READ], iops_str[DDIR_WRITE],
-				iops_str[DDIR_TRIM], eta_str);
-		else
-			l = snprintf(p, left,
-				": [%s][%s][r=%s,w=%s][r=%s,w=%s IOPS][eta %s]",
-				je->run_str, perc_str,
-				rate_str[DDIR_READ], rate_str[DDIR_WRITE],
-				iops_str[DDIR_READ], iops_str[DDIR_WRITE],
-				eta_str);
 		/* If truncation occurred adjust l so p is on the null */
 		if (l >= left)
 			l = left - 1;

