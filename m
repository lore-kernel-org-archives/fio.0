Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AA5C433F5
	for <fio@archiver.kernel.org>; Tue,  8 Feb 2022 16:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238387AbiBHQHL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Feb 2022 11:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiBHQHK (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Feb 2022 11:07:10 -0500
X-Greylist: delayed 360 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 08:07:09 PST
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE82DC061576
        for <fio@vger.kernel.org>; Tue,  8 Feb 2022 08:07:09 -0800 (PST)
Received: by sandeen.net (Postfix, from userid 500)
        id BD4C178EF; Tue,  8 Feb 2022 10:00:39 -0600 (CST)
From:   Eric Sandeen <sandeen@redhat.com>
To:     fio@vger.kernel.org
Cc:     axboe@kernel.dk
Subject: [PATCH] fio: really use LDFLAGS when linking dynamic engines
Date:   Tue,  8 Feb 2022 10:00:39 -0600
Message-Id: <1644336039-12774-1-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Fix stupid braino on my part.

Fixes: 2b3d4a6a924e ("fio: use LDFLAGS when linking dynamic engines")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 2432f51..0ab4f82 100644
--- a/Makefile
+++ b/Makefile
@@ -295,7 +295,7 @@ define engine_template =
 $(1)_OBJS := $$($(1)_SRCS:.c=.o)
 $$($(1)_OBJS): CFLAGS := -fPIC $$($(1)_CFLAGS) $(CFLAGS)
 engines/fio-$(1).so: $$($(1)_OBJS)
-	$$(QUIET_LINK)$(CC) $(DYNAMIC) -shared -rdynamic -fPIC -Wl,-soname,fio-$(1).so.1 -o $$@ $$< $$($(1)_LIBS)
+	$$(QUIET_LINK)$(CC) $(LDFLAGS) -shared -rdynamic -fPIC -Wl,-soname,fio-$(1).so.1 -o $$@ $$< $$($(1)_LIBS)
 ENGS_OBJS += engines/fio-$(1).so
 endef
 else # !CONFIG_DYNAMIC_ENGINES
-- 
1.8.3.1

