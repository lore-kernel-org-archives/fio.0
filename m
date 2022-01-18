Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52041C433F5
	for <fio@archiver.kernel.org>; Tue, 18 Jan 2022 13:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237282AbiARNAH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jan 2022 08:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiARNAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jan 2022 08:00:06 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFC6C061574
        for <fio@vger.kernel.org>; Tue, 18 Jan 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=FYEq/TocVMG5RoB6b4/wFLv2bEa3cgR/8Kj9yGzq1QQ=; b=srBzSwP32JA2nnli0LTsZDZYFo
        7n3IAcbKs9nKhJyWiFgAluvWm7tBJbyL6w697tv8cWaQnBMrYKHhjKnLrNdYOblrQXWJBl0Hyp7hf
        zIBPAA6BKE1NVchDIOYEAATE1Tf79pagVnmSoFi6GhYpai0vT26TaG3lmEwv3+YzHuqAitf/ifDyE
        8LyI3V9Qskr0DIknhcB6eLssOHekq0fL5TObYLz6NrkoVCOhHgdXP0vnX9RU+fBD5jFtnCIjzd3D4
        1W5B8x68CNYOYBwb8rtM8eVZrtniErHzvf6heNlEGaj3WAeSacw5FYZ7J63vhf3ZyqaPGkfaR49Th
        y6mHnaEg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n9o5j-009E0W-QG
        for fio@vger.kernel.org; Tue, 18 Jan 2022 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id B3BED1BC014B; Tue, 18 Jan 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220118130001.B3BED1BC014B@kernel.dk>
Date:   Tue, 18 Jan 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 016869bebe9bef7cae5a7f9dc0762162b0612226:

  stat: remove unnecessary bool parameter to sum_thread_stats() (2022-01-10 09:22:14 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ef37053efdfb8c3b8b6deef43c0969753e6adb44:

  init: do not create lat logs when not needed (2022-01-17 07:21:58 -0700)

----------------------------------------------------------------
Damien Le Moal (1):
      init: do not create lat logs when not needed

 init.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 5f069d9a..07daaa84 100644
--- a/init.c
+++ b/init.c
@@ -1586,17 +1586,23 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		else
 			suf = "log";
 
-		gen_log_name(logname, sizeof(logname), "lat", pre,
-				td->thread_number, suf, o->per_job_logs);
-		setup_log(&td->lat_log, &p, logname);
+		if (!o->disable_lat) {
+			gen_log_name(logname, sizeof(logname), "lat", pre,
+				     td->thread_number, suf, o->per_job_logs);
+			setup_log(&td->lat_log, &p, logname);
+		}
 
-		gen_log_name(logname, sizeof(logname), "slat", pre,
-				td->thread_number, suf, o->per_job_logs);
-		setup_log(&td->slat_log, &p, logname);
+		if (!o->disable_slat) {
+			gen_log_name(logname, sizeof(logname), "slat", pre,
+				     td->thread_number, suf, o->per_job_logs);
+			setup_log(&td->slat_log, &p, logname);
+		}
 
-		gen_log_name(logname, sizeof(logname), "clat", pre,
-				td->thread_number, suf, o->per_job_logs);
-		setup_log(&td->clat_log, &p, logname);
+		if (!o->disable_clat) {
+			gen_log_name(logname, sizeof(logname), "clat", pre,
+				     td->thread_number, suf, o->per_job_logs);
+			setup_log(&td->clat_log, &p, logname);
+		}
 
 	}
 
