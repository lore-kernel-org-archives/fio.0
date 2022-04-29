Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A45F1C433EF
	for <fio@archiver.kernel.org>; Fri, 29 Apr 2022 00:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347622AbiD2Auv (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 28 Apr 2022 20:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350209AbiD2Auu (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Apr 2022 20:50:50 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BDF888D2
        for <fio@vger.kernel.org>; Thu, 28 Apr 2022 17:47:34 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id D57787E7A8;
        Fri, 29 Apr 2022 00:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651193254;
        bh=U8G5duYVskdPcFW3R34mo5leHElh+vY/xmfQZdfl8AI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMOM8oSVKqMnv1G+NU6yOX1Bd6izsOdQ9mOt4wObAPTN+N1hlaOGyYkI5F81Z0Z/X
         5CVHc40Dy5g/BubVxHQFSkaytOmngHR53ZXRvTTpmuv9BLVgmIlcga83vnw7mTCY7D
         GEf21P0ZzOPTtDsx0fDM6SOM5bgvWtWTglCQUPEiKfzueOK71JSkmrE54I2znwV+Mo
         X4vEzbxirqg76KAhd1rHM6S+TKrpEB7gANEBIvbEeYEiqe1sAU+dHZhLq9QA5V3vho
         71PL0khbYk9nt//9P5633QOOXnKb+YJX1wRlLPolh1/FqTPzOUazhsHfLzAvQ2roBA
         Il5KuEInd+OhA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH v1 6/8] blktrace: Add ENOMEM handling in `trace_add_open_close_event()` and its callers
Date:   Fri, 29 Apr 2022 07:47:03 +0700
Message-Id: <20220429004705.260034-7-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
References: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

When this function hits ENOMEM, there is no way to notify the callers
that we fail to allocate the memory. This changes the return value of
`trace_add_open_close_event()` to `int` so we can tell the caller if
it hits ENOMEM. Also, fix the callers to handle this error case.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 blktrace.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/blktrace.c b/blktrace.c
index 95adf698..98ba25d1 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -80,14 +80,14 @@ bool is_blktrace(const char *filename, int *need_swap)
 #define FMAJOR(dev)	((unsigned int) ((dev) >> FMINORBITS))
 #define FMINOR(dev)	((unsigned int) ((dev) & FMINORMASK))
 
-static void trace_add_open_close_event(struct thread_data *td, int fileno,
-				       enum file_log_act action)
+static int trace_add_open_close_event(struct thread_data *td, int fileno,
+				      enum file_log_act action)
 {
 	struct io_piece *ipo;
 
 	ipo = calloc(1, sizeof(*ipo));
 	if (!ipo)
-		return;
+		return -ENOMEM;
 
 	init_ipo(ipo);
 
@@ -95,6 +95,7 @@ static void trace_add_open_close_event(struct thread_data *td, int fileno,
 	ipo->fileno = fileno;
 	ipo->file_action = action;
 	flist_add_tail(&ipo->list, &td->io_log_list);
+	return 0;
 }
 
 static int trace_add_file(struct thread_data *td, __u32 device,
@@ -124,6 +125,7 @@ static int trace_add_file(struct thread_data *td, __u32 device,
 	strcpy(dev, "/dev");
 	if (blktrace_lookup_device(td->o.replay_redirect, dev, maj, min)) {
 		int fileno;
+		int err;
 
 		if (td->o.replay_redirect)
 			dprint(FD_BLKTRACE, "device lookup: %d/%d\n overridden"
@@ -137,7 +139,9 @@ static int trace_add_file(struct thread_data *td, __u32 device,
 		td->o.open_files++;
 		td->files[fileno]->major = maj;
 		td->files[fileno]->minor = min;
-		trace_add_open_close_event(td, fileno, FIO_LOG_OPEN_FILE);
+		err = trace_add_open_close_event(td, fileno, FIO_LOG_OPEN_FILE);
+		if (err < 0)
+			return err;
 		cache->fileno = fileno;
 	}
 
@@ -217,12 +221,15 @@ static bool handle_trace_discard(struct thread_data *td,
 	if (td->o.replay_skip & (1u << DDIR_TRIM))
 		return false;
 
+	fileno = trace_add_file(td, t->device, cache);
+	if (fileno < 0)
+		return false;
+
 	ipo = calloc(1, sizeof(*ipo));
 	if (!ipo)
 		return false;
 
 	init_ipo(ipo);
-	fileno = trace_add_file(td, t->device, cache);
 
 	ios[DDIR_TRIM]++;
 	if (t->bytes > bs[DDIR_TRIM])
@@ -261,6 +268,8 @@ static bool handle_trace_fs(struct thread_data *td, struct blk_io_trace *t,
 	int fileno;
 
 	fileno = trace_add_file(td, t->device, cache);
+	if (fileno < 0)
+		return false;
 
 	rw = (t->action & BLK_TC_ACT(BLK_TC_WRITE)) != 0;
 
@@ -297,12 +306,15 @@ static bool handle_trace_flush(struct thread_data *td, struct blk_io_trace *t,
 	if (td->o.replay_skip & (1u << DDIR_SYNC))
 		return false;
 
+	fileno = trace_add_file(td, t->device, cache);
+	if (fileno < 0)
+		return false;
+
 	ipo = calloc(1, sizeof(*ipo));
 	if (!ipo)
 		return false;
 
 	init_ipo(ipo);
-	fileno = trace_add_file(td, t->device, cache);
 
 	ipo->delay = ttime / 1000;
 	ipo->ddir = DDIR_SYNC;
@@ -560,8 +572,14 @@ bool read_blktrace(struct thread_data* td)
 		return true;
 	}
 
-	for_each_file(td, fiof, i)
-		trace_add_open_close_event(td, fiof->fileno, FIO_LOG_CLOSE_FILE);
+	for_each_file(td, fiof, i) {
+		int err;
+
+		err = trace_add_open_close_event(td, fiof->fileno,
+						 FIO_LOG_CLOSE_FILE);
+		if (err < 0)
+			goto err;
+	}
 
 	fclose(td->io_log_rfile);
 	td->io_log_rfile = NULL;
-- 
Ammar Faizi

