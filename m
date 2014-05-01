Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:48028 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaEAMHM (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 May 2014 08:07:12 -0400
Received: by mail-ee0-f52.google.com with SMTP id e53so2192437eek.11
        for <fio@vger.kernel.org>; Thu, 01 May 2014 05:07:11 -0700 (PDT)
From: Daniel Gollub <daniel.gollub@gmail.com>
Subject: [PATCH 2/4] distinguish internal/ext. builds with FIO_INTERNAL
Date: Thu,  1 May 2014 14:07:02 +0200
Message-Id: <1398946024-13566-2-git-send-email-daniel.gollub@gmail.com>
In-Reply-To: <1398946024-13566-1-git-send-email-daniel.gollub@gmail.com>
References: <1398946024-13566-1-git-send-email-daniel.gollub@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <daniel.gollub@gmail.com>

To distinguish between internal and external includes of
fio.h and other headers FIO_INTERNAL get applied only for
the fio (and gfio) internal build itself.

This helps to prevent double-declaration issues by making
ambigous declaration with common names coditional based on
the FIO_INTERNAL define.

Signed-off-by: Daniel Gollub <daniel.gollub@gmail.com>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index e7659c4..a0f0f71 100644
--- a/Makefile
+++ b/Makefile
@@ -15,7 +15,7 @@ include config-host.mak
 endif
 
 DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
-CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 $(DEBUGFLAGS)
+CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL $(DEBUGFLAGS)
 OPTFLAGS= -O3 -g -ffast-math
 CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS)
 LIBS	+= -lm $(EXTLIBS)
-- 
1.7.10.4

