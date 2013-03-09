Return-Path: <fio-owner@vger.kernel.org>
Received: from averel.grnet-hq.admin.grnet.gr ([195.251.29.3]:47710 "EHLO
	averel.grnet-hq.admin.grnet.gr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758462Ab3CINAa (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 9 Mar 2013 08:00:30 -0500
Received: from localhost.localdomain (unknown [195.251.29.103])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: apyrgio@admin.grnet.gr)
	by smtps.admin.grnet.gr (Postfix) with ESMTPSA id 6424318059
	for <fio@vger.kernel.org>; Sat,  9 Mar 2013 15:00:27 +0200 (EET)
From: Alex Pyrgiotis <apyrgio@grnet.gr>
Subject: [PATCH] Fix spin related bug
Date: Sat,  9 Mar 2013 15:00:43 +0200
Message-Id: <1362834043-6735-2-git-send-email-apyrgio@grnet.gr>
In-Reply-To: <1362834043-6735-1-git-send-email-apyrgio@grnet.gr>
References: <1362834043-6735-1-git-send-email-apyrgio@grnet.gr>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

On the previous patch on cycle detection, we would incremet spin value
when:

    num_vals % cycle_length == 0

which would evaluate always to true for the first iteration since we
start with num_vals = 0. Only one corner-case is affected by this bug
and this patch should fix it.

Signed-off-by: Alex Pyrgiotis <apyrgio@grnet.gr>

diff --git a/lib/lfsr.c b/lib/lfsr.c
index a835404..4c15c62 100644
--- a/lib/lfsr.c
+++ b/lib/lfsr.c
@@ -108,22 +108,28 @@ static inline void __lfsr_next(struct fio_lfsr *fl, unsigned int spin)
 	}
 }
 
+/*
+ * lfsr_next does the following:
+ *
+ * a. Return if the number of max values has been exceeded.
+ * b. Check if the next iteration(s) produce a cycle (due to spin) and add "1"
+ *    where necessary.
+ * c. Calculate the next value and return.
+ */
 int lfsr_next(struct fio_lfsr *fl, uint64_t *off, uint64_t last)
 {
 	int repeat;
 	unsigned int spin;
 
+	if (fl->num_vals++ > fl->max_val)
+		return 1;
+
 	repeat = fl->num_vals % fl->cycle_length;
 	if (repeat == 0)
 		spin = fl->spin + 1;
 	else
 		spin = fl->spin;
 
-	if (fl->num_vals > fl->max_val)
-		return 1;
-
-	fl->num_vals++;
-
 	do {
 		__lfsr_next(fl, spin);
 	} while (fl->last_val > fl->max_val);
-- 
1.8.1.4

