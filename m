Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 2/2] Use fmt -w WIDTH option instead of -WIDTH
Date: Thu, 20 Oct 2016 23:03:18 +0900
Message-Id: <1476972198-5530-2-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1476972198-5530-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1476972198-5530-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Most systems support -WIDTH option which is an abbreviated form
of -w WIDTH or --width=WIDTH option, but some OS don't support
-WIDTH format.

As far as I've checked (on actual systems or online manpages),
Linux/FreeBSD/DragonFlyBSD/OpenBSD/Solaris/AIX/Cygwin support
-WIDTH format, but NetBSD doesn't support this (see below).
IRIX and HPUX may not support either according to online manpages.

-w WIDTH format is basically supported by all systems that have
fmt command, so this is probably better in terms of portability.

--
    CC crc/crc64.o
fmt: unknown option -- 1
Usage: fmt [-Cr] [-g <goal>] [-m|w <max>] [<files>..]
         fmt [-Cr] [<goal>] [<max>] [<files>]
    CC crc/md5.o
fmt: unknown option -- 1
Usage: fmt [-Cr] [-g <goal>] [-m|w <max>] [<files>..]
         fmt [-Cr] [<goal>] [<max>] [<files>]
...

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 6b5548a..b3a12dd 100644
--- a/Makefile
+++ b/Makefile
@@ -315,7 +315,7 @@ override CFLAGS += -DFIO_VERSION='"$(FIO_VERSION)"'
 	@$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SRCDIR)/$*.c > $*.d
 	@mv -f $*.d $*.d.tmp
 	@sed -e 's|.*:|$*.o:|' < $*.d.tmp > $*.d
-	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -1 | \
+	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -w 1 | \
 		sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
 	@rm -f $*.d.tmp
 
@@ -354,7 +354,7 @@ init.o: init.c FIO-VERSION-FILE
 	@$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SRCDIR)/$*.c > $*.d
 	@mv -f $*.d $*.d.tmp
 	@sed -e 's|.*:|$*.o:|' < $*.d.tmp > $*.d
-	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -1 | \
+	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -w 1 | \
 		sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
 	@rm -f $*.d.tmp
 
-- 
1.7.1


