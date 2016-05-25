Return-Path: <ms@merkaba.lichtvoll.de>
From: Martin Steigerwald <martin.steigerwald@teamix.de>
Subject: [PATCH] Allow build software to inject further C build flags
Date: Wed, 25 May 2016 10:53:51 +0200
Message-Id: <1464166431-31610-1-git-send-email-martin.steigerwald@teamix.de>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Martin Steigerwald <martin.steigerwald@teamix.de>
List-ID: <fio@vger.kernel.org>

This is useful for dpkg and oder packaging software to inject hardening
options like -fPIE -pie for position independent builds which allow for
address space randomization.
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 108e6ee..19fd72c 100644
--- a/Makefile
+++ b/Makefile
@@ -23,7 +23,7 @@ endif
 DEBUGFLAGS = -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
 CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL $(DEBUGFLAGS)
 OPTFLAGS= -g -ffast-math
-CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
+CFLAGS	+= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
 LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
 SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py)
-- 
2.8.1


