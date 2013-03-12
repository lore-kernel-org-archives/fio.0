Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ia0-f173.google.com ([209.85.210.173]:37898 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3CLHE2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 12 Mar 2013 03:04:28 -0400
Received: by mail-ia0-f173.google.com with SMTP id h37so4542479iak.18
        for <fio@vger.kernel.org>; Tue, 12 Mar 2013 00:04:28 -0700 (PDT)
From: olegmatcovsky@gmail.com
Subject: [PATCH 1/2] Remove config-host.h on clean.
Date: Tue, 12 Mar 2013 00:04:16 -0700
Message-Id: <1363071856-7507-1-git-send-email-olegmatcovsky@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Oleg Matcovschi <olegmatcovsky@gmail.com>

From: Oleg Matcovschi <olegmatcovsky@gmail.com>

Signed-off-by: Oleg Matcovschi <olegmatcovsky@gmail.com>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 023557c..7a17555 100644
--- a/Makefile
+++ b/Makefile
@@ -217,7 +217,7 @@ fio: $(OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(OBJS) $(LIBS) $(LDFLAGS)
 
 clean: FORCE
-	-rm -f .depend $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core FIO-VERSION-FILE config-host.mak cscope.out *.d
+	-rm -f .depend $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core FIO-VERSION-FILE config-host.mak config-host.h cscope.out *.d
 
 cscope:
 	@cscope -b -R
-- 
1.7.5.4

