Return-Path: <fio-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31926 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751701AbdJJV1N (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 10 Oct 2017 17:27:13 -0400
From: Andrzej Jakowski <andrzej.jakowski@intel.com>
Subject: [PATCH] Fix overflow in percentile calculation for Windows
Date: Tue, 10 Oct 2017 14:27:10 -0700
Message-Id: <20171010212710.12526-1-andrzej.jakowski@intel.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Andrzej Jakowski <andrzej.jakowski@intel.com>

This patch fixes percentile calculation for Windows where overflow
on 32 bit type happened while calculating actual percentiles.

Signed-off-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
---
 stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/stat.c b/stat.c
index c5a68ad5..5c758680 100644
--- a/stat.c
+++ b/stat.c
@@ -139,7 +139,7 @@ unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 				   fio_fp64_t *plist, unsigned long long **output,
 				   unsigned long long *maxv, unsigned long long *minv)
 {
-	unsigned long sum = 0;
+	unsigned long long sum = 0;
 	unsigned int len, i, j = 0;
 	unsigned int oval_len = 0;
 	unsigned long long *ovals = NULL;
-- 
2.13.6

