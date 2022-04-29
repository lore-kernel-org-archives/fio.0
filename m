Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079D0C433FE
	for <fio@archiver.kernel.org>; Fri, 29 Apr 2022 00:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbiD2Aum (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 28 Apr 2022 20:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiD2Aul (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Apr 2022 20:50:41 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5886BB925
        for <fio@vger.kernel.org>; Thu, 28 Apr 2022 17:47:25 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 395537E78A;
        Fri, 29 Apr 2022 00:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651193245;
        bh=7g9MXzrYaznBdVE16Gc83OPJ8wzIHFXHmwxIMByhmG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8cPZENtEq2J2qBVEGALJHcJ/Tm0h9rFBhR/A8/u0A8mrQME1qfj9UmdzvCoZYZHl
         JB7tCJRmvTkFCYbqVmSD7bn5+BnaVkvgG8frVP/lCSG/hJYcZDmubBCUKPr06nQbct
         UTTq5hsg42altSWbHtdrOSirnpjKOibaGaLf0GNIRSmo7NQZ/saRuqW8T4DROq7mpg
         QaUlrE6Aj1Y33vo0E0ZXfrei7yn0M5CiWZNlLOZJbGQQEkyRIfCtPz6RK8xVk0+ffO
         c+LVgy4iNEb2gIkz+ZqP8zUxEFjop4d1OeGTbQnwk+pETgm+/6lQR8BLPf9xqX5TxL
         /cP0yUqlHdAwg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH v1 2/8] stat: Add ENOMEM handling on `malloc()` / `calloc()` calls
Date:   Fri, 29 Apr 2022 07:46:59 +0700
Message-Id: <20220429004705.260034-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
References: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Avoid a NULL pointer dereference bug when `ENOMEM`.

This adds missing `ENOMEM` handling in these function:
  - __show_run_stats()
  - __show_running_run_stats()
  - add_clat_sample()
  - calc_block_percentiles()

While in there, extra changes in `__show_run_stats()`:
  - Replace `malloc()` + set NULL with `calloc()` for simplicity.
  - Call `free()` properly when allocation fails to avoid memory leak.
  - Use `sizeof(*var)` instead of `sizeof(struct x)` for simplicity.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 stat.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/stat.c b/stat.c
index 949af5ed..29b58606 100644
--- a/stat.c
+++ b/stat.c
@@ -858,6 +858,8 @@ static int calc_block_percentiles(int nr_block_infos, uint32_t *block_infos,
 		return 0;
 
 	*percentiles = calloc(len, sizeof(**percentiles));
+	if (!*percentiles)
+		return 0;
 
 	for (i = 0; i < len; i++) {
 		int idx = (plist[i].u.f * (nr_block_infos - nr_uninit) / 100)
@@ -2429,7 +2431,11 @@ void __show_run_stats(void)
 	struct buf_output output[FIO_OUTPUT_NR];
 	struct flist_head **opt_lists;
 
-	runstats = malloc(sizeof(struct group_run_stats) * (groupid + 1));
+	runstats = malloc((groupid + 1) * sizeof(*runstats));
+	if (!runstats) {
+		log_err("fio: failed to allocate runstats\n");
+		return;
+	}
 
 	for (i = 0; i < groupid + 1; i++)
 		init_group_run_stat(&runstats[i]);
@@ -2454,13 +2460,20 @@ void __show_run_stats(void)
 		nr_ts++;
 	}
 
-	threadstats = malloc(nr_ts * sizeof(struct thread_stat));
-	opt_lists = malloc(nr_ts * sizeof(struct flist_head *));
+	threadstats = malloc(nr_ts * sizeof(*threadstats));
+	if (!threadstats) {
+		log_err("fio: failed to allocate threadstats\n");
+		goto out_free_runstats;
+	}
+
+	opt_lists = calloc(nr_ts, sizeof(*opt_lists));
+	if (!opt_lists) {
+		log_err("fio: failed to allocate opt_lists\n");
+		goto out_free_threadstats;
+	}
 
-	for (i = 0; i < nr_ts; i++) {
+	for (i = 0; i < nr_ts; i++)
 		init_thread_stat(&threadstats[i]);
-		opt_lists[i] = NULL;
-	}
 
 	init_per_prio_stats(threadstats, nr_ts);
 
@@ -2709,15 +2722,18 @@ void __show_run_stats(void)
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
@@ -2729,7 +2745,10 @@ int __show_running_run_stats(void)
 
 	fio_sem_down(stat_sem);
 
-	rt = malloc(thread_number * sizeof(unsigned long long));
+	rt = malloc(thread_number * sizeof(*rt));
+	if (!rt)
+		return 1;
+
 	fio_gettime(&ts, NULL);
 
 	for_each_td(td, i) {
@@ -3331,6 +3350,8 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 			 */
 			io_u_plat = (uint64_t *) td->ts.io_u_plat[FIO_CLAT][ddir];
 			dst = malloc(sizeof(struct io_u_plat_entry));
+			if (!dst)
+				goto out;
 			memcpy(&(dst->io_u_plat), io_u_plat,
 				FIO_IO_U_PLAT_NR * sizeof(uint64_t));
 			flist_add(&dst->list, &hw->list);
@@ -3347,6 +3368,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		}
 	}
 
+out:
 	if (needs_lock)
 		__td_io_u_unlock(td);
 }
-- 
Ammar Faizi

