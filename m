Return-Path: <yjhong@google.com>
From: Yu-ju Hong <yjhong@google.com>
Subject: [PATCH] stats: Fix computation of standard deviation
Date: Fri, 29 Jul 2011 15:23:43 -0700
Message-Id: <1311978223-15603-1-git-send-email-yjhong@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Nauman Rafique <nauman@google.com>, Eric Gouriou <egouriou@google.com>, Yu-ju Hong <yjhong@google.com>
List-ID: <fio@vger.kernel.org>

Fix the computation of standard deviation for a group
of jobs. Please see the below link for the
approximation formula used.
<http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance

The formula was originally presented here:
<ftp://reports.stanford.edu/pub/cstr/reports/cs/tr/79/773/
CS-TR-79-773.pdf>

Signed-off-by: Yu-ju Hong <yjhong@google.com>
---
 stat.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/stat.c b/stat.c
index 9f22c6e..8be4be5 100644
--- a/stat.c
+++ b/stat.c
@@ -474,21 +474,28 @@ static void sum_stat(struct io_stat *dst, struct io_stat *src, int nr)
 
 	dst->min_val = min(dst->min_val, src->min_val);
 	dst->max_val = max(dst->max_val, src->max_val);
-	dst->samples += src->samples;
 
 	/*
-	 * Needs a new method for calculating stddev, we cannot just
-	 * average them we do below for nr > 1
+	 * Compute new mean and S after the merge
+	 * <http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
+	 *  #Parallel_algorithm>
 	 */
 	if (nr == 1) {
 		mean = src->mean;
 		S = src->S;
 	} else {
-		mean = ((src->mean * (double) (nr - 1))
-				+ dst->mean) / ((double) nr);
-		S = ((src->S * (double) (nr - 1)) + dst->S) / ((double) nr);
+		double delta = src->mean - dst->mean;
+
+		mean = ((src->mean * src->samples) +
+			(dst->mean * dst->samples)) /
+			(dst->samples + src->samples);
+
+		S =  src->S + dst->S + pow(delta, 2.0) *
+			(dst->samples * src->samples) /
+			(dst->samples + src->samples);
 	}
 
+	dst->samples += src->samples;
 	dst->mean = mean;
 	dst->S = S;
 }
-- 
1.7.3.1


