Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B767CC54EE9
	for <fio@archiver.kernel.org>; Tue, 20 Sep 2022 12:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiITMAu (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiITMA1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Sep 2022 08:00:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C81026F1
        for <fio@vger.kernel.org>; Tue, 20 Sep 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=mCh6FhqCU+VGtuMhJLQyHtAGx/kmEHpjmNges61Ke2Y=; b=WintDAS8co8iLRxWLqcRtapIfU
        FXHiZbgL8jrtVBNLCMyJ59hLn2y7o3rB/wq17rHpTJ4c84Gz4vavSUC67UHmLVmBSLHY9RchlnKl4
        +pELabxCDQHo6lx618eEArLF8U5YBpJpHk1KvpZ3jFP+i8LGzjd94jwxVO7aSYjaPJvu8cxm721sR
        k/ANYsnEw1mtna63j9ufKWS2tz7viVPmTf+qiG08YA3x7W/hZfu9R877cWoRzgC/7z7xwN+jau0J5
        EWrA5uHG42e8FwrJOd5veS4B6fjVBoV1vkNZMRH1BsJJwVu4BA5LhKU4qvETf3la9dj4N1SyQJrqX
        vMkQtd/A==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oabv5-005UEe-NY
        for fio@vger.kernel.org; Tue, 20 Sep 2022 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id AAED71BC0162; Tue, 20 Sep 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220920120001.AAED71BC0162@kernel.dk>
Date:   Tue, 20 Sep 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 5932cf0f2a03396b5f3f0b4667f5e66f7d8477e5:

  Merge branch 'fix-example-disk-zone-profile' of github.com:cvubrugier/fio (2022-09-15 11:02:49 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d14687025c0c61d047e4252036d1b024d62cb0a6:

  configure: change grep -P to grep -E (2022-09-19 09:42:14 -0400)

----------------------------------------------------------------
Vincent Fu (2):
      gettime: cleanups
      configure: change grep -P to grep -E

 configure | 2 +-
 gettime.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 7741ef4f..546541a2 100755
--- a/configure
+++ b/configure
@@ -117,7 +117,7 @@ has() {
 }
 
 num() {
-  echo "$1" | grep -P -q "^[0-9]+$"
+  echo "$1" | grep -E -q "^[0-9]+$"
 }
 
 check_define() {
diff --git a/gettime.c b/gettime.c
index 14462420..8993be16 100644
--- a/gettime.c
+++ b/gettime.c
@@ -313,7 +313,7 @@ static int calibrate_cpu_clock(void)
 
 	max_ticks = MAX_CLOCK_SEC * cycles_per_msec * 1000ULL;
 	max_mult = ULLONG_MAX / max_ticks;
-	dprint(FD_TIME, "\n\nmax_ticks=%llu, __builtin_clzll=%d, "
+	dprint(FD_TIME, "max_ticks=%llu, __builtin_clzll=%d, "
 			"max_mult=%llu\n", max_ticks,
 			__builtin_clzll(max_ticks), max_mult);
 
@@ -335,7 +335,7 @@ static int calibrate_cpu_clock(void)
 
 	/*
 	 * Find the greatest power of 2 clock ticks that is less than the
-	 * ticks in MAX_CLOCK_SEC_2STAGE
+	 * ticks in MAX_CLOCK_SEC
 	 */
 	max_cycles_shift = max_cycles_mask = 0;
 	tmp = MAX_CLOCK_SEC * 1000ULL * cycles_per_msec;
