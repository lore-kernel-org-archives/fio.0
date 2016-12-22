Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t3425.houston.hpe.com ([15.241.140.78]:51631 "EHLO
        g4t3425.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936319AbcLVUrr (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 15:47:47 -0500
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g4t3425.houston.hpe.com (Postfix) with ESMTP id ABB3B74
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 20:47:46 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH v2 07/12] gclient: Delete unused code
Date: Thu, 22 Dec 2016 14:50:46 -0600
Message-Id: <20161222205051.4677-7-elliott@hpe.com>
In-Reply-To: <20161222205051.4677-1-elliott@hpe.com>
References: <20161222060853.64104-1-elliott@hpe.com>
 <20161222205051.4677-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

Delete two #if 0 blocks from pre-2012 that have old calls to
num2str without the current number of arguments and hardcode
"KB/s" units.
---
 gclient.c | 40 ----------------------------------------
 1 file changed, 40 deletions(-)

diff --git a/gclient.c b/gclient.c
index 23b0899..451d81c 100644
--- a/gclient.c
+++ b/gclient.c
@@ -364,26 +364,6 @@ static void gfio_update_client_eta(struct fio_client *client, struct jobs_eta *j
 	sprintf(tmp, "%u", je->files_open);
 	gtk_entry_set_text(GTK_ENTRY(ge->eta.files), tmp);
 
-#if 0
-	if (je->m_rate[0] || je->m_rate[1] || je->t_rate[0] || je->t_rate[1]) {
-	if (je->m_rate || je->t_rate) {
-		char *tr, *mr;
-
-		mr = num2str(je->m_rate, 4, 0, i2p);
-		tr = num2str(je->t_rate, 4, 0, i2p);
-		gtk_entry_set_text(GTK_ENTRY(ge->eta);
-		p += sprintf(p, ", CR=%s/%s KB/s", tr, mr);
-		free(tr);
-		free(mr);
-	} else if (je->m_iops || je->t_iops)
-		p += sprintf(p, ", CR=%d/%d IOPS", je->t_iops, je->m_iops);
-
-	gtk_entry_set_text(GTK_ENTRY(ge->eta.cr_bw), "---");
-	gtk_entry_set_text(GTK_ENTRY(ge->eta.cr_iops), "---");
-	gtk_entry_set_text(GTK_ENTRY(ge->eta.cw_bw), "---");
-	gtk_entry_set_text(GTK_ENTRY(ge->eta.cw_iops), "---");
-#endif
-
 	if (je->eta_sec != INT_MAX && je->nr_running) {
 		char *iops_str[DDIR_RWDIR_CNT];
 		char *rate_str[DDIR_RWDIR_CNT];
@@ -457,26 +437,6 @@ static void gfio_update_all_eta(struct jobs_eta *je)
 		eta_to_str(eta_str, je->eta_sec);
 	}
 
-#if 0
-	if (je->m_rate[0] || je->m_rate[1] || je->t_rate[0] || je->t_rate[1]) {
-	if (je->m_rate || je->t_rate) {
-		char *tr, *mr;
-
-		mr = num2str(je->m_rate, 4, 0, i2p);
-		tr = num2str(je->t_rate, 4, 0, i2p);
-		gtk_entry_set_text(GTK_ENTRY(ui->eta);
-		p += sprintf(p, ", CR=%s/%s KB/s", tr, mr);
-		free(tr);
-		free(mr);
-	} else if (je->m_iops || je->t_iops)
-		p += sprintf(p, ", CR=%d/%d IOPS", je->t_iops, je->m_iops);
-
-	gtk_entry_set_text(GTK_ENTRY(ui->eta.cr_bw), "---");
-	gtk_entry_set_text(GTK_ENTRY(ui->eta.cr_iops), "---");
-	gtk_entry_set_text(GTK_ENTRY(ui->eta.cw_bw), "---");
-	gtk_entry_set_text(GTK_ENTRY(ui->eta.cw_iops), "---");
-#endif
-
 	entry_set_int_value(ui->eta.jobs, je->nr_running);
 
 	if (je->eta_sec != INT_MAX && je->nr_running) {
-- 
2.9.3

