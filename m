Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45608 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754356AbdCTPpc (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 20 Mar 2017 11:45:32 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cpvym-00053m-A0
        for fio@vger.kernel.org; Mon, 20 Mar 2017 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170320120002.74DC92C27A6@kernel.dk>
Date: Mon, 20 Mar 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d9bb03d475e918e08c38bd882032ff788daa297f:

  is_power_of_2() should return bool (2017-03-17 10:39:42 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cee3ddfee4d39ec9ba31b7329a343053af057914:

  Merge branch 'wip-fix-bs-title' of https://github.com/liupan1111/fio (2017-03-19 19:49:04 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'wip-fix-bs-title' of https://github.com/liupan1111/fio

Pan Liu (1):
      make the bs info output clearer.

 init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 54fdb92..b4b0974 100644
--- a/init.c
+++ b/init.c
@@ -1534,10 +1534,10 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 							ddir_str(o->td_ddir));
 
 				if (o->bs_is_seq_rand)
-					log_info("bs=%s-%s,%s-%s, bs_is_seq_rand, ",
+					log_info("bs=(R) %s-%s, (W) %s-%s, bs_is_seq_rand, ",
 							c1, c2, c3, c4);
 				else
-					log_info("bs=%s-%s,%s-%s,%s-%s, ",
+					log_info("bs=(R) %s-%s, (W) %s-%s, (T) %s-%s, ",
 							c1, c2, c3, c4, c5, c6);
 
 				log_info("ioengine=%s, iodepth=%u\n",
