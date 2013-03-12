Return-Path: <fio-owner@vger.kernel.org>
Received: from averel.grnet-hq.admin.grnet.gr ([195.251.29.3]:59152 "EHLO
	averel.grnet-hq.admin.grnet.gr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755150Ab3CLI3k (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 12 Mar 2013 04:29:40 -0400
Received: from localhost.localdomain (ppp-94-66-127-201.home.otenet.gr [94.66.127.201])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: apyrgio@admin.grnet.gr)
	by smtps.admin.grnet.gr (Postfix) with ESMTPSA id F1B4318057
	for <fio@vger.kernel.org>; Tue, 12 Mar 2013 10:29:36 +0200 (EET)
From: Alex Pyrgiotis <apyrgio@grnet.gr>
Subject: [PATCH] Fix verification and spin bugs
Date: Tue, 12 Mar 2013 10:28:35 +0200
Message-Id: <1363076915-1140-2-git-send-email-apyrgio@grnet.gr>
In-Reply-To: <1363076915-1140-1-git-send-email-apyrgio@grnet.gr>
References: <1363076915-1140-1-git-send-email-apyrgio@grnet.gr>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Changes:

1. Verification now works properly and reports for which value it fails
2. Fix a mishandling of spin incrementation which led to multiple
calculation of the same values

Signed-off-by: Alex Pyrgiotis <apyrgio@grnet.gr>

diff --git a/lib/lfsr.c b/lib/lfsr.c
index 4c15c62..b10ba7a 100644
--- a/lib/lfsr.c
+++ b/lib/lfsr.c
@@ -112,26 +112,36 @@ static inline void __lfsr_next(struct fio_lfsr *fl, unsigned int spin)
  * lfsr_next does the following:
  *
  * a. Return if the number of max values has been exceeded.
- * b. Check if the next iteration(s) produce a cycle (due to spin) and add "1"
- *    where necessary.
- * c. Calculate the next value and return.
+ * b. Check if we have a spin value that produces a repeating subsequence.
+ *    This is previously calculated in `prepare_spin` and cycle_length should
+ *    be > 0. If we do have such a spin:
+ *
+ *    i. Decrement the calculated cycle.
+ *    ii. If it reaches zero, add "+1" to the spin and reset the cycle_length
+ *        (we have it cached in the struct fio_lfsr)
+ *
+ *    In either case, continue with the calculation of the next value.
+ * c. Check if the calculated value exceeds the desirable range. In this case,
+ *    go back to b, else return.
  */
 int lfsr_next(struct fio_lfsr *fl, uint64_t *off, uint64_t last)
 {
-	int repeat;
-	unsigned int spin;
+	unsigned int spin = fl->spin;
 
 	if (fl->num_vals++ > fl->max_val)
 		return 1;
 
-	repeat = fl->num_vals % fl->cycle_length;
-	if (repeat == 0)
-		spin = fl->spin + 1;
-	else
-		spin = fl->spin;
-
 	do {
+		if (fl->cycle_length) {
+			fl->cycle_length--;
+			if (!fl->cycle_length) {
+				__lfsr_next(fl, fl->spin + 1);
+				fl->cycle_length = fl->cached_cycle_length;
+				goto check;
+			}
+		}
 		__lfsr_next(fl, spin);
+check: ;
 	} while (fl->last_val > fl->max_val);
 
 	*off = fl->last_val;
@@ -189,7 +199,7 @@ int prepare_spin(struct fio_lfsr *fl, unsigned int spin)
 
 	x = max / (spin + 1);
 	y = max % (spin + 1);
-	fl->cycle_length = max;	/* This is the expected cycle */
+	fl->cycle_length = 0;	/* No cycle occurs, other than the expected */
 	fl->spin = spin;
 
 	for (i = 1; i <= spin; i++) {
@@ -198,6 +208,7 @@ int prepare_spin(struct fio_lfsr *fl, unsigned int spin)
 			break;
 		}
 	}
+	fl->cached_cycle_length = fl->cycle_length;
 
 	return 0;
 }
diff --git a/lib/lfsr.h b/lib/lfsr.h
index bc16af9..187abf2 100644
--- a/lib/lfsr.h
+++ b/lib/lfsr.h
@@ -18,6 +18,7 @@ struct fio_lfsr {
 	uint64_t max_val;
 	uint64_t num_vals;
 	uint64_t cycle_length;
+	uint64_t cached_cycle_length;
 	unsigned int spin;
 };
 
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
index 193a7f9..d371087 100644
--- a/t/lfsr-test.c
+++ b/t/lfsr-test.c
@@ -94,13 +94,15 @@ int main(int argc, char *argv[])
 	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);
 	fprintf(stderr, "finished.\n");
 
+
 	/* Check if all expected numbers within range have been calculated */
 	r = 0;
 	if (verify) {
 		fprintf(stderr, "Verifying results... ");
 		for (i = 0; i < numbers; i++) {
-			if (*(uint8_t *)(v + 1) != 1) {
-				fprintf(stderr, "failed.\n");
+			if (*(uint8_t *)(v + i) != 1) {
+				fprintf(stderr, "failed (%lu = %d).\n",
+						i, *(uint8_t *)(v + i));
 				r = 1;
 				break;
 			}
-- 
1.8.1.4

