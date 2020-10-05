Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgJERJK (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 5 Oct 2020 13:09:10 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA73C0613CE
        for <fio@vger.kernel.org>; Mon,  5 Oct 2020 10:09:10 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l17so10188663edq.12
        for <fio@vger.kernel.org>; Mon, 05 Oct 2020 10:09:09 -0700 (PDT)
From: Yigal Korman <ykorman@gmail.com>
Subject: [PATCH] fio: fix dynamic engines soname definition
Date: Mon,  5 Oct 2020 20:08:54 +0300
Message-Id: <20201005170854.25544-1-ykorman@gmail.com>
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Yigal Korman <ykorman@gmail.com>

The SONAME of the engines should not match the name of the dependent
library. Otherwise it confuses the dynamic loader into thinking the
dependency is already resolved.

Prefixing the name with fio make more sense here.

Signed-off-by: Yigal Korman <ykorman@gmail.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.17.1


