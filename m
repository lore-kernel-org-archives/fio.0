Return-Path: <fio-owner@vger.kernel.org>
Received: from averel.grnet-hq.admin.grnet.gr ([195.251.29.3]:18650 "EHLO
	averel.grnet-hq.admin.grnet.gr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549Ab3HZVxN (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 26 Aug 2013 17:53:13 -0400
Received: from localhost.localdomain (ppp-94-66-119-230.home.otenet.gr [94.66.119.230])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: apyrgio@admin.grnet.gr)
	by smtps.admin.grnet.gr (Postfix) with ESMTPSA id 1CD0D180DE
	for <fio@vger.kernel.org>; Tue, 27 Aug 2013 00:53:09 +0300 (EEST)
From: Alex Pyrgiotis <apyrgio@grnet.gr>
Subject: [PATCH] LFSR: Do not ignore returning the seed
Date: Tue, 27 Aug 2013 00:52:22 +0300
Message-Id: <1377553942-6835-2-git-send-email-apyrgio@grnet.gr>
In-Reply-To: <1377553942-6835-1-git-send-email-apyrgio@grnet.gr>
References: <1377553942-6835-1-git-send-email-apyrgio@grnet.gr>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Fix a situation where we would spin prematurely and would hop over the
seed value.

Also, add some more comments to the code.

Signed-off-by: Alex Pyrgiotis <apyrgio@grnet.gr>

diff --git a/lib/lfsr.c b/lib/lfsr.c
index b10ba7a..927b2a1 100644
--- a/lib/lfsr.c
+++ b/lib/lfsr.c
@@ -87,7 +87,6 @@ static inline void __lfsr_next(struct fio_lfsr *fl, unsigned int spin)
 	 * this switch.
 	 */
 	switch (spin) {
-		case 16: __LFSR_NEXT(fl, fl->last_val);
 		case 15: __LFSR_NEXT(fl, fl->last_val);
 		case 14: __LFSR_NEXT(fl, fl->last_val);
 		case 13: __LFSR_NEXT(fl, fl->last_val);
@@ -126,21 +125,16 @@ static inline void __lfsr_next(struct fio_lfsr *fl, unsigned int spin)
  */
 int lfsr_next(struct fio_lfsr *fl, uint64_t *off, uint64_t last)
 {
-	unsigned int spin = fl->spin;
-
 	if (fl->num_vals++ > fl->max_val)
 		return 1;
 
 	do {
-		if (fl->cycle_length) {
-			fl->cycle_length--;
-			if (!fl->cycle_length) {
-				__lfsr_next(fl, fl->spin + 1);
-				fl->cycle_length = fl->cached_cycle_length;
-				goto check;
-			}
+		if (fl->cycle_length && !--fl->cycle_length) {
+			__lfsr_next(fl, fl->spin + 1);
+			fl->cycle_length = fl->cached_cycle_length;
+			goto check;
 		}
-		__lfsr_next(fl, spin);
+		__lfsr_next(fl, fl->spin);
 check: ;
 	} while (fl->last_val > fl->max_val);
 
@@ -163,8 +157,13 @@ static uint8_t *find_lfsr(uint64_t size)
 {
 	int i;
 
+	/*
+	 * For an LFSR, there is always a prohibited state (all ones).
+	 * Thus, if we need to find the proper LFSR for our size, we must take that
+	 * into account.
+	 */
 	for (i = 3; i < 64; i++)
-		if ((1UL << i) > size) /* TODO: Explain why. */
+		if ((1UL << i) > size)
 			return taps[i];
 
 	return NULL;
@@ -210,6 +209,12 @@ int prepare_spin(struct fio_lfsr *fl, unsigned int spin)
 	}
 	fl->cached_cycle_length = fl->cycle_length;
 
+	/*
+	 * Increment cycle length for the first time only since the stored value
+	 * will not be printed otherwise.
+	 */
+	fl->cycle_length++;
+
 	return 0;
 }
 
-- 
1.8.3.4

