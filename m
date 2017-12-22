Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47280 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751592AbdLVNAT (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 22 Dec 2017 08:00:19 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eSMvy-0007PK-UY
        for fio@vger.kernel.org; Fri, 22 Dec 2017 13:00:19 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171222130002.231C62C009A@kernel.dk>
Date: Fri, 22 Dec 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e3ccbdd5f93d33162a93000586461ac6bba5a7d3:

  Fio 3.3 (2017-12-19 13:16:36 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2fc703f639f1fac7d1f86917ba8bf4d0e81667b9:

  Merge branch 'eta_overflow' of https://github.com/sitsofe/fio (2017-12-21 08:22:39 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'eta_overflow' of https://github.com/sitsofe/fio

Sitsofe Wheeler (1):
      eta: fix buffer overflow in ETA output

 eta.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/eta.c b/eta.c
index 8b77daf..087f57d 100644
--- a/eta.c
+++ b/eta.c
@@ -585,7 +585,7 @@ void display_thread_status(struct jobs_eta *je)
 			iops_str[ddir] = num2str(je->iops[ddir], 4, 1, 0, N2S_NONE);
 		}
 
-		left = sizeof(output) - (p - output) - 1;
+		left = sizeof(output) - (p - output) - 2;
 
 		if (je->rate[DDIR_TRIM] || je->iops[DDIR_TRIM])
 			l = snprintf(p, left,
@@ -601,6 +601,8 @@ void display_thread_status(struct jobs_eta *je)
 				rate_str[DDIR_READ], rate_str[DDIR_WRITE],
 				iops_str[DDIR_READ], iops_str[DDIR_WRITE],
 				eta_str);
+		if (l > left)
+			l = left;
 		p += l;
 		if (l >= 0 && l < linelen_last)
 			p += sprintf(p, "%*s", linelen_last - l, "");
