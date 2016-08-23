Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48161 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758019AbcHWMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 23 Aug 2016 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bcANA-0002Cx-Py
        for fio@vger.kernel.org; Tue, 23 Aug 2016 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160823120003.766532C0286@kernel.dk>
Date: Tue, 23 Aug 2016 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a86f6d07f12141a32ccad2007d4568e612e0df10:

  verify: use proper include for PATH_MAX (2016-08-20 10:28:57 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9e4438fecd1d92b4d5221f35d5e73546f52c6ebf:

  stat: don't trust per_unit_log() if log is NULL (2016-08-22 13:23:29 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      stat: don't trust per_unit_log() if log is NULL

 stat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 552d88d..74c2686 100644
--- a/stat.c
+++ b/stat.c
@@ -2457,12 +2457,12 @@ int calc_log_samples(void)
 			next = min(td->o.iops_avg_time, td->o.bw_avg_time);
 			continue;
 		}
-		if (!per_unit_log(td->bw_log)) {
+		if (td->bw_log && !per_unit_log(td->bw_log)) {
 			tmp = add_bw_samples(td, &now);
 			if (tmp < next)
 				next = tmp;
 		}
-		if (!per_unit_log(td->iops_log)) {
+		if (td->iops_log && !per_unit_log(td->iops_log)) {
 			tmp = add_iops_samples(td, &now);
 			if (tmp < next)
 				next = tmp;
