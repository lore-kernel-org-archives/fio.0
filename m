Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D60C433EF
	for <fio@archiver.kernel.org>; Fri, 29 Apr 2022 00:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345895AbiD2Auu (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 28 Apr 2022 20:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347622AbiD2Aut (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Apr 2022 20:50:49 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2BE887B0
        for <fio@vger.kernel.org>; Thu, 28 Apr 2022 17:47:32 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 8ABF07E7B1;
        Fri, 29 Apr 2022 00:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651193252;
        bh=xuv9UHQ3dl9uY5uZq5uiEmja/JYNAyIYhwmi9uPWUzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADYHTCUmPg8SxGVsCiEqGoPsRHCU4js+jKfGfma/oZfBnHv9o+RobJZGXFpp9MstB
         dNzaSdN+CwFzpzAGFogbJIh1Gtawc+Nw4t7AXUyNAI8NzUSNIcDgBK7JVCcjZHqnbm
         ZgVD74pHEUaVgd4SOzWxl5cOWYenwhG/c8Spk/fuztlSW7XGa/QaX5HPrDNkCWyqCI
         xR09ox8Axx1LhvHRAO2HOGpbbRmPFqhG6epi2YDyI+8gP2pOEdUBAVBzAoCy0bPYHP
         kAHxQfiwYRREPXjA93pVQowoc8yxofdpVDkTeTjRRcOkW+LhRalsX6S+uPInyWqK3e
         e56DnaHiZUIbg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH v1 5/8] blktrace: Add ENOMEM handling when allocating @ipo
Date:   Fri, 29 Apr 2022 07:47:02 +0700
Message-Id: <20220429004705.260034-6-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
References: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

We have many places that do `ipo = calloc(1, sizeof(*ipo))` but don't
handle the ENOMEM case. Add it.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 blktrace.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/blktrace.c b/blktrace.c
index 776bd4ab..95adf698 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -80,11 +80,15 @@ bool is_blktrace(const char *filename, int *need_swap)
 #define FMAJOR(dev)	((unsigned int) ((dev) >> FMINORBITS))
 #define FMINOR(dev)	((unsigned int) ((dev) & FMINORMASK))
 
-static void trace_add_open_close_event(struct thread_data *td, int fileno, enum file_log_act action)
+static void trace_add_open_close_event(struct thread_data *td, int fileno,
+				       enum file_log_act action)
 {
 	struct io_piece *ipo;
 
 	ipo = calloc(1, sizeof(*ipo));
+	if (!ipo)
+		return;
+
 	init_ipo(ipo);
 
 	ipo->ddir = DDIR_INVAL;
@@ -158,6 +162,9 @@ static void store_ipo(struct thread_data *td, unsigned long long offset,
 	struct io_piece *ipo;
 
 	ipo = calloc(1, sizeof(*ipo));
+	if (!ipo)
+		return;
+
 	init_ipo(ipo);
 
 	ipo->offset = offset * 512;
@@ -211,6 +218,9 @@ static bool handle_trace_discard(struct thread_data *td,
 		return false;
 
 	ipo = calloc(1, sizeof(*ipo));
+	if (!ipo)
+		return false;
+
 	init_ipo(ipo);
 	fileno = trace_add_file(td, t->device, cache);
 
@@ -288,6 +298,9 @@ static bool handle_trace_flush(struct thread_data *td, struct blk_io_trace *t,
 		return false;
 
 	ipo = calloc(1, sizeof(*ipo));
+	if (!ipo)
+		return false;
+
 	init_ipo(ipo);
 	fileno = trace_add_file(td, t->device, cache);
 
-- 
Ammar Faizi

