Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhEIMBM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 9 May 2021 08:01:12 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2B3C061573
        for <fio@vger.kernel.org>; Sun,  9 May 2021 05:00:08 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lfi6P-00BYC2-RK
        for fio@vger.kernel.org; Sun, 09 May 2021 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210509120001.EF1E61BC013D@kernel.dk>
Date: Sun,  9 May 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit cffe80a41cbf9b26446c803177a27f7695f94a31:

  configure: fix check_min_lib_version() eval (2021-05-06 10:24:58 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 79f488cbd95ca6989031a7ace5ec382313d31b3c:

  don't access dlclose'd dynamic ioengine object after close (2021-05-08 22:13:16 -0600)

----------------------------------------------------------------
Eric Sandeen (1):
      don't access dlclose'd dynamic ioengine object after close

 ioengines.c | 1 -
 1 file changed, 1 deletion(-)

---

Diff of recent changes:

diff --git a/ioengines.c b/ioengines.c
index 3561bb4e..dd61af07 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -234,7 +234,6 @@ void free_ioengine(struct thread_data *td)
 	if (td->io_ops->dlhandle) {
 		dprint(FD_IO, "dlclose ioengine %s\n", td->io_ops->name);
 		dlclose(td->io_ops->dlhandle);
-		td->io_ops->dlhandle = NULL;
 	}
 
 	td->io_ops = NULL;

