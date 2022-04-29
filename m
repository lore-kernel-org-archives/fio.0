Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26A3C433F5
	for <fio@archiver.kernel.org>; Fri, 29 Apr 2022 00:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiD2Aus (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 28 Apr 2022 20:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345895AbiD2Aur (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Apr 2022 20:50:47 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2C1BB91C
        for <fio@vger.kernel.org>; Thu, 28 Apr 2022 17:47:30 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 4207E7E778;
        Fri, 29 Apr 2022 00:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651193250;
        bh=3jPQSWSRrywjaNeIqf6loUidPvHnCh54K71hMTeUX/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ST2FAkK8/4X25ARRc+W3nyFznYpBIzHyixO4o+QUBjeBCZ2Aff0YZ6R7DxM6dVw4Z
         k3Gf1qK5MBxsrh3mMD1cjxLoeroBGkoEbBwOO//QT5zWdxiMorrWJv17y1cpyq21BL
         UCkpHcZcY2lv6ztO9chjCalvvScNRRpmi2fZDuWmvvBfZGlk/SVOqcPy5FeQGClAql
         7AEH8GFRxHJ3dpaHdx7duOddeyoVtZYSV0JBYw2O8rg7mUaWkWkY6sWGtEPXP93Vpv
         uBDg46bl5V6DX+P4vwqBum+xKZxFmLUVAy0ivHHHOYr16u6LeLjXAu55AghrN+Um4+
         vfk67ptqtRGKw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH v1 4/8] blktrace: Fix broken error handling in `merge_blktrace_iologs()`
Date:   Fri, 29 Apr 2022 07:47:01 +0700
Message-Id: <20220429004705.260034-5-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
References: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

There are several problems in this functions:

1) The error is handled inconsistently. (e.g. we have `ret = -errno`,
   but we don't alter the `ret` when memory allocation fails).

2) Missing ENOMEM handling when allocating @bcs.

3) Wrong `fclose()` on cleanup. We have:

     for (i = 0; i < nr_logs; i++)
         fclose(bcs[i].f);

   but at that point, the @nr_logs is already zero. Recall that
   @nr_logs is zeroed inside the `while (nr_logs)` loop. The
   merge_finish_file() decrements @nr_logs every loop cycle.

Fix and refactor them all.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 blktrace.c | 73 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 28 deletions(-)

diff --git a/blktrace.c b/blktrace.c
index 619121c7..776bd4ab 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -700,21 +700,25 @@ static int write_trace(FILE *fp, struct blk_io_trace *t)
 
 int merge_blktrace_iologs(struct thread_data *td)
 {
+	int nr_logs_iter;
 	int nr_logs = get_max_str_idx(td->o.read_iolog_file);
-	struct blktrace_cursor *bcs = malloc(sizeof(struct blktrace_cursor) *
-					     nr_logs);
+	struct blktrace_cursor *bcs;
 	struct blktrace_cursor *bc;
 	FILE *merge_fp;
 	char *str, *ptr, *name, *merge_buf;
 	int i, ret;
 
+	bcs = calloc(nr_logs, sizeof(struct blktrace_cursor));
+	if (!bcs)
+		return -ENOMEM;
+
 	ret = init_merge_param_list(td->o.merge_blktrace_scalars, bcs, nr_logs,
 				    100, offsetof(struct blktrace_cursor,
 						  scalar));
 	if (ret) {
 		log_err("fio: merge_blktrace_scalars(%d) != nr_logs(%d)\n",
 			ret, nr_logs);
-		goto err_param;
+		goto out_free_bcs;
 	}
 
 	ret = init_merge_param_list(td->o.merge_blktrace_iters, bcs, nr_logs,
@@ -723,83 +727,96 @@ int merge_blktrace_iologs(struct thread_data *td)
 	if (ret) {
 		log_err("fio: merge_blktrace_iters(%d) != nr_logs(%d)\n",
 			ret, nr_logs);
-		goto err_param;
+		goto out_free_bcs;
 	}
 
 	/* setup output file */
 	merge_fp = fopen(td->o.merge_blktrace_file, "w");
+	if (!merge_fp) {
+		ret = -errno;
+		goto out_free_bcs;
+	}
+
 	merge_buf = malloc(128 * 1024);
-	if (!merge_buf)
-		goto err_out_file;
+	if (!merge_buf) {
+		ret = -ENOMEM;
+		goto out_close_merge_fp;
+	}
+
 	ret = setvbuf(merge_fp, merge_buf, _IOFBF, 128 * 1024);
-	if (ret)
-		goto err_merge_buf;
+	if (ret) {
+		ret = -errno;
+		goto out_free_merge_buf;
+	}
 
 	/* setup input files */
 	str = ptr = strdup(td->o.read_iolog_file);
+	if (!str) {
+		ret = -ENOMEM;
+		goto out_free_merge_buf;
+	}
+
 	nr_logs = 0;
 	for (i = 0; (name = get_next_str(&ptr)) != NULL; i++) {
 		bcs[i].f = fopen(name, "rb");
 		if (!bcs[i].f) {
 			log_err("fio: could not open file: %s\n", name);
 			ret = -errno;
-			free(str);
-			goto err_file;
+			goto out_close_bcs_files;
 		}
 		nr_logs++;
 
 		if (!is_blktrace(name, &bcs[i].swap)) {
 			log_err("fio: file is not a blktrace: %s\n", name);
-			free(str);
-			goto err_file;
+			goto out_close_bcs_files;
 		}
 
 		ret = read_trace(td, &bcs[i]);
 		if (ret < 0) {
-			free(str);
-			goto err_file;
+			goto out_close_bcs_files;
 		} else if (!ret) {
 			merge_finish_file(bcs, i, &nr_logs);
 			i--;
 		}
 	}
-	free(str);
 
 	/* merge files */
-	while (nr_logs) {
-		i = find_earliest_io(bcs, nr_logs);
+	nr_logs_iter = nr_logs;
+	while (nr_logs_iter) {
+		i = find_earliest_io(bcs, nr_logs_iter);
 		bc = &bcs[i];
 		/* skip over the pdu */
 		ret = discard_pdu(bc->f, &bc->t);
 		if (ret < 0) {
 			td_verror(td, -ret, "blktrace lseek");
-			goto err_file;
+			goto out_close_bcs_files;
 		}
 
 		ret = write_trace(merge_fp, &bc->t);
 		ret = read_trace(td, bc);
 		if (ret < 0)
-			goto err_file;
+			goto out_close_bcs_files;
 		else if (!ret)
-			merge_finish_file(bcs, i, &nr_logs);
+			merge_finish_file(bcs, i, &nr_logs_iter);
 	}
 
 	/* set iolog file to read from the newly merged file */
 	td->o.read_iolog_file = td->o.merge_blktrace_file;
 	ret = 0;
 
-err_file:
-	/* cleanup */
-	for (i = 0; i < nr_logs; i++) {
+out_close_bcs_files:
+	for (i = 0; i < nr_logs; i++)
 		fclose(bcs[i].f);
-	}
-err_merge_buf:
+	free(str);
+
+out_free_merge_buf:
 	free(merge_buf);
-err_out_file:
+
+out_close_merge_fp:
 	fflush(merge_fp);
 	fclose(merge_fp);
-err_param:
-	free(bcs);
 
+out_free_bcs:
+	free(bcs);
 	return ret;
 }
-- 
Ammar Faizi

