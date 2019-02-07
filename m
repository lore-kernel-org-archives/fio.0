Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 1/2] stat: clean up calc_clat_percentiles
Date: Thu,  7 Feb 2019 10:51:06 -0500
Message-Id: <20190207155107.7148-2-vincentfu@gmail.com>
In-Reply-To: <20190207155107.7148-1-vincentfu@gmail.com>
References: <20190207155107.7148-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

We already know the size of the buffer needed. So there
is no need to do anything fancy when allocating it.
---
 stat.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/stat.c b/stat.c
index 351c49cc..7c843e6b 100644
--- a/stat.c
+++ b/stat.c
@@ -139,7 +139,6 @@ unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 {
 	unsigned long long sum = 0;
 	unsigned int len, i, j = 0;
-	unsigned int oval_len = 0;
 	unsigned long long *ovals = NULL;
 	bool is_last;
 
@@ -161,6 +160,10 @@ unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 	if (len > 1)
 		qsort((void *)plist, len, sizeof(plist[0]), double_cmp);
 
+	ovals = malloc(len * sizeof(*ovals));
+	if (!ovals)
+		return 0;
+
 	/*
 	 * Calculate bucket values, note down max and min values
 	 */
@@ -170,11 +173,6 @@ unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 		while (sum >= (plist[j].u.f / 100.0 * nr)) {
 			assert(plist[j].u.f <= 100.0);
 
-			if (j == oval_len) {
-				oval_len += 100;
-				ovals = realloc(ovals, oval_len * sizeof(*ovals));
-			}
-
 			ovals[j] = plat_idx_to_val(i);
 			if (ovals[j] < *minv)
 				*minv = ovals[j];
-- 
2.17.1


