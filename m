Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbgKBNAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 2 Nov 2020 08:00:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DC5C0617A6
        for <fio@vger.kernel.org>; Mon,  2 Nov 2020 05:00:06 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kZZRM-0000bn-3Q
        for fio@vger.kernel.org; Mon, 02 Nov 2020 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201102130002.057231BC011D@kernel.dk>
Date: Mon,  2 Nov 2020 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8c17a6248bd227a9f3cc3da52bd1cb922dc6cf81:

  t/zbd: Fix test target size of test case #48 (2020-10-30 07:24:59 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 08a3f6fef1fe6c9fcd18d5ed40ca81097922bb14:

  fio: fix dynamic engines soname definition (2020-11-01 07:16:16 -0700)

----------------------------------------------------------------
Yigal Korman (1):
      fio: fix dynamic engines soname definition

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 5ed8a808..48788f24 100644
--- a/Makefile
+++ b/Makefile
@@ -569,7 +569,7 @@ endif
 
 ifdef CONFIG_DYNAMIC_ENGINES
 engines/lib$(1).so: $$($(1)_OBJS)
-	$$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,lib$(1).so.1 $$($(1)_LIBS) -o $$@ $$<
+	$$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,fio-$(1).so.1 $$($(1)_LIBS) -o $$@ $$<
 endif
 
 clean: FORCE

