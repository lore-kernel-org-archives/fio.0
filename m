Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgENMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 14 May 2020 08:00:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B32C061A0C
        for <fio@vger.kernel.org>; Thu, 14 May 2020 05:00:03 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZCWx-0002yo-81
        for fio@vger.kernel.org; Thu, 14 May 2020 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200514120001.890BC1BC01AD@kernel.dk>
Date: Thu, 14 May 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9bc878ed59deb6c4a031f4f3a8d1ff3bbdbbd14d:

  Merge branch 'btrace2fio' of https://github.com/liu-song-6/fio (2020-05-11 12:09:31 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3ac77f9f5f7e3f2a5f9dababae810565f4c72eb7:

  Merge branch 'helper-thread-select' of https://github.com/vincentkfu/fio (2020-05-13 08:10:32 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'helper-thread-select' of https://github.com/vincentkfu/fio

Vincent Fu (1):
      helper_thread: better handle select() return value

 helper_thread.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/helper_thread.c b/helper_thread.c
index ad1a08f3..a2fb7c29 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -194,10 +194,11 @@ static void *helper_thread_main(void *data)
 			FD_SET(hd->pipe[0], &rfds);
 			FD_ZERO(&efds);
 			FD_SET(hd->pipe[0], &efds);
-			ret = select(1, &rfds, NULL, &efds, &timeout);
-			if (ret < 0)
+			if (select(1, &rfds, NULL, &efds, &timeout) < 0) {
 				log_err("fio: select() call in helper thread failed: %s",
 					strerror(errno));
+				ret = 1;
+			}
 			if (read_from_pipe(hd->pipe[0], &action, sizeof(action)) <
 			    0)
 				action = 0;

