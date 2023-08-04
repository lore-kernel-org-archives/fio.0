Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39EA1C001DB
	for <fio@archiver.kernel.org>; Fri,  4 Aug 2023 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjHDMAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 4 Aug 2023 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjHDMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Aug 2023 08:00:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EB9187
        for <fio@vger.kernel.org>; Fri,  4 Aug 2023 05:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Q+jIQ0JxnnRm8zxQMEdmzPrS3bNWz336FOLhMaJajn4=; b=RTf8f3s168rBwBy9rwmEhf29QI
        i3zypVHEspDgKwDUiZ5z5Uz6qIOCXIfKrkD+iEkoVDUOaL1ppjMnBifdB9zOSoD8Xknd2LNV/QrzU
        vKRgQG+K2l4ofXD0wTMOPtJiVIfmLomcdHqAy/z8ofONMoIDH75kfJuY8Uhjh7LdzXVjpHg8OwZdN
        awKzGb/qAjqeNf4VQbNwg/cJtPK7s/lgtImYWZRiqBqO7uXFGSns0Ky4DZToz2Ola8xIOxvYZLaMn
        XjtRQFfO7DBX7vKRZTnjKvodpkFjUQ2Yrog9HB+XgUFexAfQTsI7un4AUB3RwRSP12t3XVKgKCdFy
        7ht3nTkg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qRtTQ-009i4H-6G
        for fio@vger.kernel.org; Fri, 04 Aug 2023 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 9415F1BC0161; Fri,  4 Aug 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230804120001.9415F1BC0161@kernel.dk>
Date:   Fri,  4 Aug 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 7b57011427a8204bd63671b08dde56cd9e879d68:

  t/fiotestlib: make recorded command prettier (2023-08-02 12:58:16 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 62f35562722f0c903567096d0f10a836d1ae2f60:

  eta: calculate aggregate bw statistics even when eta is disabled (2023-08-03 11:49:08 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      eta: calculate aggregate bw statistics even when eta is disabled

 eta.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/eta.c b/eta.c
index af4027e0..cc342461 100644
--- a/eta.c
+++ b/eta.c
@@ -375,6 +375,22 @@ bool eta_time_within_slack(unsigned int time)
 	return time > ((eta_interval_msec * 95) / 100);
 }
 
+/*
+ * These are the conditions under which we might be able to skip the eta
+ * calculation.
+ */
+static bool skip_eta()
+{
+	if (!(output_format & FIO_OUTPUT_NORMAL) && f_out == stdout)
+		return true;
+	if (temp_stall_ts || eta_print == FIO_ETA_NEVER)
+		return true;
+	if (!isatty(STDOUT_FILENO) && eta_print != FIO_ETA_ALWAYS)
+		return true;
+
+	return false;
+}
+
 /*
  * Print status of the jobs we know about. This includes rate estimates,
  * ETA, thread state, etc.
@@ -393,14 +409,12 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	static unsigned long long disp_io_iops[DDIR_RWDIR_CNT];
 	static struct timespec rate_prev_time, disp_prev_time;
 
-	if (!force) {
-		if (!(output_format & FIO_OUTPUT_NORMAL) &&
-		    f_out == stdout)
-			return false;
-		if (temp_stall_ts || eta_print == FIO_ETA_NEVER)
-			return false;
+	bool ret = true;
 
-		if (!isatty(STDOUT_FILENO) && (eta_print != FIO_ETA_ALWAYS))
+	if (!force && skip_eta()) {
+		if (write_bw_log)
+			ret = false;
+		else
 			return false;
 	}
 
@@ -534,7 +548,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	je->nr_threads = thread_number;
 	update_condensed_str(__run_str, run_str);
 	memcpy(je->run_str, run_str, strlen(run_str));
-	return true;
+	return ret;
 }
 
 static int gen_eta_str(struct jobs_eta *je, char *p, size_t left,
