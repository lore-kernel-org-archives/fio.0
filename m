Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37309 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1CUPA2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 21 Mar 2011 11:00:28 -0400
Received: by eyx24 with SMTP id 24so1533337eyx.19
        for <fio@vger.kernel.org>; Mon, 21 Mar 2011 08:00:26 -0700 (PDT)
From: =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@gmail.com>
Subject: [PATCH] Fix linking of fio executable.
Date: Mon, 21 Mar 2011 15:59:49 +0100
Message-Id: <1300719589-7779-1-git-send-email-flameeyes@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@gmail.com>

First of all make sure that $(LDFLAGS) are used during linking so that the
user can set the linker's flags.

Then also make sure that libraries are listed after the objects, so that
GNU ld's --as-needed option will not cause fio linking to fail.
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 07e011e..1d81562 100644
--- a/Makefile
+++ b/Makefile
@@ -70,9 +70,9 @@ mandir = $(prefix)/man
 
 .c.o:
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(CPPFLAGS) $<
-	
+
 fio: $(OBJS)
-	$(QUIET_CC)$(CC) $(CFLAGS) -o $@ $(LIBS) $(OBJS)
+	$(QUIET_CC)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(OBJS) $(LIBS)
 
 depend:
 	$(QUIET_DEP)$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SOURCE) 1> .depend
-- 
1.7.4.1

