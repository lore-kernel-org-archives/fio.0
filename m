Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Sat, 10 Oct 2020 17:35:10 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] simplify MB/s, IOPS interactive printout code
Message-ID: <20201010143510.GA1131765@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
To: axboe@kernel.dk
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Use loops(!) instead of hardcoded if-else pairs.

Make it easier to add DDIR_APPEND.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---

 eta.c |   70 ++++++++++++++++++++++++------------------------------------------
 1 file changed, 26 insertions(+), 44 deletions(-)

--- a/eta.c
+++ b/eta.c
@@ -534,56 +534,38 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 static int gen_eta_str(struct jobs_eta *je, char *p, size_t left,
 		       char **rate_str, char **iops_str)
 {
-	bool has_r = je->rate[DDIR_READ] || je->iops[DDIR_READ];
-	bool has_w = je->rate[DDIR_WRITE] || je->iops[DDIR_WRITE];
-	bool has_t = je->rate[DDIR_TRIM] || je->iops[DDIR_TRIM];
+	static const char c[DDIR_RWDIR_CNT] = {'r', 'w', 't'};
+	bool has[DDIR_RWDIR_CNT];
+	bool has_any = false;
+	const char *sep;
 	int l = 0;
 
-	if (!has_r && !has_w && !has_t)
+	for_each_rw_ddir(ddir) {
+		has[ddir] = (je->rate[ddir] || je->iops[ddir]);
+		has_any |= has[ddir];
+	}
+	if (!has_any)
 		return 0;
 
-	if (has_r) {
-		l += snprintf(p + l, left - l, "[r=%s", rate_str[DDIR_READ]);
-		if (!has_w)
-			l += snprintf(p + l, left - l, "]");
-	}
-	if (has_w) {
-		if (has_r)
-			l += snprintf(p + l, left - l, ",");
-		else
-			l += snprintf(p + l, left - l, "[");
-		l += snprintf(p + l, left - l, "w=%s", rate_str[DDIR_WRITE]);
-		if (!has_t)
-			l += snprintf(p + l, left - l, "]");
-	}
-	if (has_t) {
-		if (has_r || has_w)
-			l += snprintf(p + l, left - l, ",");
-		else if (!has_r && !has_w)
-			l += snprintf(p + l, left - l, "[");
-		l += snprintf(p + l, left - l, "t=%s]", rate_str[DDIR_TRIM]);
-	}
-	if (has_r) {
-		l += snprintf(p + l, left - l, "[r=%s", iops_str[DDIR_READ]);
-		if (!has_w)
-			l += snprintf(p + l, left - l, " IOPS]");
-	}
-	if (has_w) {
-		if (has_r)
-			l += snprintf(p + l, left - l, ",");
-		else
-			l += snprintf(p + l, left - l, "[");
-		l += snprintf(p + l, left - l, "w=%s", iops_str[DDIR_WRITE]);
-		if (!has_t)
-			l += snprintf(p + l, left - l, " IOPS]");
+	l += snprintf(p + l, left - l, "[");
+	sep = "";
+	for_each_rw_ddir(ddir) {
+		if (has[ddir]) {
+			l += snprintf(p + l, left - l, "%s%c=%s",
+					sep, c[ddir], rate_str[ddir]);
+			sep = ",";
+		}
 	}
-	if (has_t) {
-		if (has_r || has_w)
-			l += snprintf(p + l, left - l, ",");
-		else if (!has_r && !has_w)
-			l += snprintf(p + l, left - l, "[");
-		l += snprintf(p + l, left - l, "t=%s IOPS]", iops_str[DDIR_TRIM]);
+	l += snprintf(p + l, left - l, "][");
+	sep = "";
+	for_each_rw_ddir(ddir) {
+		if (has[ddir]) {
+			l += snprintf(p + l, left - l, "%s%c=%s",
+					sep, c[ddir], iops_str[ddir]);
+			sep = ",";
+		}
 	}
+	l += snprintf(p + l, left - l, " IOPS]");
 
 	return l;
 }

