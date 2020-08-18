Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHRMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Aug 2020 08:00:06 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E139C061389
        for <fio@vger.kernel.org>; Tue, 18 Aug 2020 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k80Hb-0006My-Of
        for fio@vger.kernel.org; Tue, 18 Aug 2020 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200818120001.882791BC01C9@kernel.dk>
Date: Tue, 18 Aug 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dde39f8c356158207eb2fc8ff6c9d2daad910a84:

  fio: add for_each_rw_ddir() macro (2020-08-16 21:01:22 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 09c1aa8b322765afae56ea1ebc9eaa06f94da6a6:

  engines/windowsaio: only set IOCP thread affinity if specified (2020-08-17 15:42:16 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      engines/windowsaio: only set IOCP thread affinity if specified

 engines/windowsaio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index 13d7f194..ff8b6e1b 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -107,7 +107,8 @@ static int fio_windowsaio_init(struct thread_data *td)
 			ctx->wd = wd;
 			wd->iothread = CreateThread(NULL, 0, IoCompletionRoutine, ctx, 0, &threadid);
 
-			if (wd->iothread != NULL)
+			if (wd->iothread != NULL &&
+			    fio_option_is_set(&td->o, cpumask))
 				fio_setaffinity(threadid, td->o.cpumask);
 			else
 				log_err("windowsaio: failed to create io completion thread\n");

