Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 1/2] stat: use long doubles to identify latency percentiles
Date: Tue, 19 Feb 2019 16:44:07 -0500
Message-Id: <20190219214408.14207-2-vincentfu@gmail.com>
In-Reply-To: <20190219214408.14207-1-vincentfu@gmail.com>
References: <20190219214408.14207-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

In some cases, the 100th percentile latency is not correctly identified
because of problems with double precision floating point arithmetic.
Use long doubles instead in the while loop condition to reduce the
likelihood of encountering this problem.

Also, print an error message when latency percentiles are not
successfully identified.
---
 stat.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/stat.c b/stat.c
index c1f46e1d..66a13bca 100644
--- a/stat.c
+++ b/stat.c
@@ -170,7 +170,7 @@ unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 	is_last = false;
 	for (i = 0; i < FIO_IO_U_PLAT_NR && !is_last; i++) {
 		sum += io_u_plat[i];
-		while (sum >= (plist[j].u.f / 100.0 * nr)) {
+		while (sum >= ((long double) plist[j].u.f / 100.0 * nr)) {
 			assert(plist[j].u.f <= 100.0);
 
 			ovals[j] = plat_idx_to_val(i);
@@ -187,6 +187,9 @@ unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 		}
 	}
 
+	if (!is_last)
+		log_err("fio: error calculating latency percentiles\n");
+
 	*output = ovals;
 	return len;
 }
-- 
2.17.1


