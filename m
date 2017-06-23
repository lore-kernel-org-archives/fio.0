Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/8] Makefile: use fmt(1) rather than tr(1) on NetBSD/etc
Date: Sat, 24 Jun 2017 01:07:55 +0300
Message-Id: <20170623220801.38178-3-tkusumi@tuxera.com>
In-Reply-To: <20170623220801.38178-1-tkusumi@tuxera.com>
References: <20170623220801.38178-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

e291cff1 (Use fmt -w WIDTH option instead of -WIDTH) changed the
command option to a common one to suppress an error, but it only
fixed the unknown option error without being functional on NetBSD.

This change is taken from NetBSD's pkgsrc. It may work against
other platforms that don't work with fmt(1), but only enabled for
NetBSD at the moment. FreeBSD/DragonFlyBSD/OpenBSD work with fmt(1).

(This actually works on Linux too, but the existing one should be
kept for Linux (and other platforms) provided it has been used on
various distros for years)

https://github.com/NetBSD/pkgsrc/blob/trunk/benchmarks/fio/patches/patch-Makefile

> Convert the fmt(1) command to a tr(1) one (the fmt(1) old syntax
> command is not supported on all Unix systems).

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 Makefile | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Makefile b/Makefile
index 64fa97a..bef930f 100644
--- a/Makefile
+++ b/Makefile
@@ -327,8 +327,13 @@ override CFLAGS += -DFIO_VERSION='"$(FIO_VERSION)"'
 	@$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SRCDIR)/$*.c > $*.d
 	@mv -f $*.d $*.d.tmp
 	@sed -e 's|.*:|$*.o:|' < $*.d.tmp > $*.d
+ifeq ($(CONFIG_TARGET_OS), NetBSD)
+	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | tr -cs "[:graph:]" "\n" | \
+		sed -e 's/^ *//' -e '/^$$/ d' -e 's/$$/:/' >> $*.d
+else
 	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -w 1 | \
 		sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
+endif
 	@rm -f $*.d.tmp
 
 ifdef CONFIG_ARITHMETIC
@@ -366,8 +371,13 @@ init.o: init.c FIO-VERSION-FILE
 	@$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SRCDIR)/$*.c > $*.d
 	@mv -f $*.d $*.d.tmp
 	@sed -e 's|.*:|$*.o:|' < $*.d.tmp > $*.d
+ifeq ($(CONFIG_TARGET_OS), NetBSD)
+	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | tr -cs "[:graph:]" "\n" | \
+		sed -e 's/^ *//' -e '/^$$/ d' -e 's/$$/:/' >> $*.d
+else
 	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -w 1 | \
 		sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
+endif
 	@rm -f $*.d.tmp
 
 gcompat.o: gcompat.c gcompat.h
-- 
2.9.4


