Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7B6C433EF
	for <fio@archiver.kernel.org>; Wed, 27 Apr 2022 09:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiD0J1H (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 27 Apr 2022 05:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiD0J1G (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 27 Apr 2022 05:27:06 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB5029A665
        for <fio@vger.kernel.org>; Wed, 27 Apr 2022 02:22:51 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 668A27E77D;
        Wed, 27 Apr 2022 09:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651050722;
        bh=f3/cprhVa+0fY8ZeFnkVwx6VsxgnbaPqVGc+Dhs1qDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvXj2vphi1KwswIffEdiLq4g4sftTdVibePeUmpXKRQ90tIT7Jkz+aLD9Jki4hl9k
         W0sjfuObGo8g03eP8Wnxgpz1LkUxhUtyPQArjfZVK258ukit2xKXXlUsDREQy4NqpC
         g80RFzTcEGWB6urzsQrmQqXwv1RvBunByxs5y2TbGnaFpf0XCai+K0fHE/0ZIQxiti
         KpWBFAsYlUqQ5LdlABlcJARw/d3LkCmkShl//lMNzqhIgpa80tqb9YGHg+lWnBErmQ
         iF7R5nYYga8YicSs/Rl5V48uJtQv08/k7Hh/O2btJNzGBSp1NTQOM0uf3yYePXQBOD
         yui6FOR2qZUlw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v2 3/6] stat: Handle `ENOMEM` case in `__show_run_stats()`
Date:   Wed, 27 Apr 2022 16:11:22 +0700
Message-Id: <20220427091125.114146-4-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220427091125.114146-1-ammarfaizi2@gnuweeb.org>
References: <20220427091125.114146-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This handles memory allocation failure and several improvements.

1) Change `malloc(n * size)` to `calloc(n, size)`. This is to avoid
   multiplication on `malloc()` because it doesn't do overflow check.
   Also, `calloc()` zeroes the allocated memory, so we can omit the
   zeroing elements of the array inside the loop.

2) Make sure we are calling `free()` properly if we fail. Use goto to
   do this.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 stat.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/stat.c b/stat.c
index 949af5ed..cc9be02e 100644
--- a/stat.c
+++ b/stat.c
@@ -2429,7 +2429,11 @@ void __show_run_stats(void)
 	struct buf_output output[FIO_OUTPUT_NR];
 	struct flist_head **opt_lists;
 
-	runstats = malloc(sizeof(struct group_run_stats) * (groupid + 1));
+	runstats = calloc(groupid + 1, sizeof(*runstats));
+	if (!runstats) {
+		log_err("fio: failed to allocate runstats\n");
+		return;
+	}
 
 	for (i = 0; i < groupid + 1; i++)
 		init_group_run_stat(&runstats[i]);
@@ -2454,14 +2458,21 @@ void __show_run_stats(void)
 		nr_ts++;
 	}
 
-	threadstats = malloc(nr_ts * sizeof(struct thread_stat));
-	opt_lists = malloc(nr_ts * sizeof(struct flist_head *));
+	threadstats = calloc(nr_ts, sizeof(*threadstats));
+	if (!threadstats) {
+		log_err("fio: failed to allocate threadstats\n");
+		goto out_free_runstats;
+	}
 
-	for (i = 0; i < nr_ts; i++) {
-		init_thread_stat(&threadstats[i]);
-		opt_lists[i] = NULL;
+	opt_lists = calloc(nr_ts, sizeof(*opt_lists));
+	if (!opt_lists) {
+		log_err("fio: failed to allocate opt_lists\n");
+		goto out_free_threadstats;
 	}
 
+	for (i = 0; i < nr_ts; i++)
+		init_thread_stat(&threadstats[i]);
+
 	init_per_prio_stats(threadstats, nr_ts);
 
 	j = 0;
@@ -2709,15 +2720,18 @@ void __show_run_stats(void)
 	fio_idle_prof_cleanup();
 
 	log_info_flush();
-	free(runstats);
 
 	/* free arrays allocated by sum_thread_stats(), if any */
 	for (i = 0; i < nr_ts; i++) {
 		ts = &threadstats[i];
 		free_clat_prio_stats(ts);
 	}
-	free(threadstats);
+
 	free(opt_lists);
+out_free_threadstats:
+	free(threadstats);
+out_free_runstats:
+	free(runstats);
 }
 
 int __show_running_run_stats(void)
-- 
Ammar Faizi

