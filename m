Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbhGHMCs (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jul 2021 08:02:48 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6A7C061574
        for <fio@vger.kernel.org>; Thu,  8 Jul 2021 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m1ShI-00FeKj-Dj
        for fio@vger.kernel.org; Thu, 08 Jul 2021 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210708120001.D71201BC0166@kernel.dk>
Date: Thu,  8 Jul 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 77c72e0f504364adf6a0e8f1155fdf3fd68ef248:

  Merge branch 'dedupe_bugfix' of https://github.com/bardavid/fio (2021-07-01 13:27:39 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7a9cc9c93c1384f72ac16d1d7980e158ec5f9f0a:

  Makefile: use override directive on engine CFLAGS (2021-07-07 07:05:08 -0600)

----------------------------------------------------------------
Stefan Hajnoczi (1):
      Makefile: use override directive on engine CFLAGS

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index f57569d5..510e07fc 100644
--- a/Makefile
+++ b/Makefile
@@ -293,7 +293,7 @@ else # !CONFIG_DYNAMIC_ENGINES
 define engine_template =
 SOURCE += $$($(1)_SRCS)
 LIBS += $$($(1)_LIBS)
-CFLAGS += $$($(1)_CFLAGS)
+override CFLAGS += $$($(1)_CFLAGS)
 endef
 endif
 

