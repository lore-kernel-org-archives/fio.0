Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829B9C433FE
	for <fio@archiver.kernel.org>; Tue, 26 Apr 2022 21:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352497AbiDZVYa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241799AbiDZVY3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 26 Apr 2022 17:24:29 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A6814B2F6
        for <fio@vger.kernel.org>; Tue, 26 Apr 2022 14:21:20 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 61D477E787;
        Tue, 26 Apr 2022 21:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651008080;
        bh=MaGPjasqSG9QqM7/MZaOYOC2oaT0SuNkl59u/q4vUmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WETOftIcNiADW2LcCp0uz2JcEuMxyzwebXv1yR/6mOPoLLjSe5bLzH5PN4+nlN+I1
         b0JwJIbDDZ+84itUqyEBVMPK+JMqkZvE0YJS9NBLpmEJX66Cm9reRKscHSg3BHjNgz
         WzphXCFRhfi3+rJHKLouDjYEmNL5+MyRbzIO8jIDz5b0T401GSNX60p2oHuQ3qn3ZL
         yNyf7JJjQP/Vjh/D6sqVNCpKUEXuOOGKtKY3eVEMnaYkydlvBkDc9QfP7kxJWgGkQP
         JaTmgZcCcEfjG7/Sm6gPG/A6xLuQN5LXUKq0VaFOIomMIhwH+NdWN49FaOQbrCJqaH
         L0YTV9mj1VLhw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v1 3/6] stat: Handle `ENOMEM` case on `malloc()` call
Date:   Wed, 27 Apr 2022 04:20:41 +0700
Message-Id: <20220426212044.78898-4-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220426212044.78898-1-ammarfaizi2@gnuweeb.org>
References: <20220426212044.78898-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Add error handling on malloc() call to prevent a NULL pointer
dereference.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 stat.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/stat.c b/stat.c
index 949af5ed..2d74c3b0 100644
--- a/stat.c
+++ b/stat.c
@@ -2430,6 +2430,10 @@ void __show_run_stats(void)
 	struct flist_head **opt_lists;
 
 	runstats = malloc(sizeof(struct group_run_stats) * (groupid + 1));
+	if (!runstats) {
+		log_err("fio: failed to allocate runstats\n");
+		return;
+	}
 
 	for (i = 0; i < groupid + 1; i++)
 		init_group_run_stat(&runstats[i]);
@@ -2455,7 +2459,16 @@ void __show_run_stats(void)
 	}
 
 	threadstats = malloc(nr_ts * sizeof(struct thread_stat));
+	if (!threadstats) {
+		log_err("fio: failed to allocate threadstats\n");
+		return;
+	}
+
 	opt_lists = malloc(nr_ts * sizeof(struct flist_head *));
+	if (!opt_lists) {
+		log_err("fio: failed to allocate opt_lists\n");
+		return;
+	}
 
 	for (i = 0; i < nr_ts; i++) {
 		init_thread_stat(&threadstats[i]);
-- 
Ammar Faizi

