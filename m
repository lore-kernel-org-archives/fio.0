Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389553AbgKZNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 Nov 2020 08:00:07 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A13DC0613D4
        for <fio@vger.kernel.org>; Thu, 26 Nov 2020 05:00:06 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kiGsW-0007Co-2N
        for fio@vger.kernel.org; Thu, 26 Nov 2020 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201126130002.139B61BC0149@kernel.dk>
Date: Thu, 26 Nov 2020 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9107a641e67f27003fa6cbe7b55b1ec6a0239197:

  error out if ENOSPC during file layout (2020-11-22 09:54:44 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d04162b62c9d7d4f5e8ea70be9cb419abaced160:

  Merge branch 'update-fio-ioops-version' of https://github.com/diameter/fio (2020-11-25 11:01:00 -0700)

----------------------------------------------------------------
Ivan Andreyev (1):
      ioengines: increment FIO_IOOPS_VERSION

Jens Axboe (1):
      Merge branch 'update-fio-ioops-version' of https://github.com/diameter/fio

 ioengines.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/ioengines.h b/ioengines.h
index fbe52fa4..a928b211 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -8,7 +8,7 @@
 #include "io_u.h"
 #include "zbd_types.h"
 
-#define FIO_IOOPS_VERSION	26
+#define FIO_IOOPS_VERSION	27
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static

