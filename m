Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgHMMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Aug 2020 08:00:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18316C061757
        for <fio@vger.kernel.org>; Thu, 13 Aug 2020 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k6Btt-0003TF-1w
        for fio@vger.kernel.org; Thu, 13 Aug 2020 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200813120001.6FBC91BC01B3@kernel.dk>
Date: Thu, 13 Aug 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0d578085cc7b97b783e1719b205dd563b406ecbc:

  t/zbd: check log file for failed assertions (2020-08-11 10:42:43 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 84abeef7d9f2f5cded36dcfc127b3f33db89ea57:

  io_u: calculate incremental residuals correctly (2020-08-12 11:48:15 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      io_u: calculate incremental residuals correctly

 io_u.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index dbb0a6f8..2ef5acec 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1977,7 +1977,7 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 	td->last_ddir = ddir;
 
 	if (!io_u->error && ddir_rw(ddir)) {
-		unsigned long long bytes = io_u->buflen - io_u->resid;
+		unsigned long long bytes = io_u->xfer_buflen - io_u->resid;
 		int ret;
 
 		/*

