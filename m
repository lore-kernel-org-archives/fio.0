Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36830 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932553AbcJUMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2016 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bxYUU-0003WN-RU
        for fio@vger.kernel.org; Fri, 21 Oct 2016 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161021120001.E0DF72C302E@kernel.dk>
Date: Fri, 21 Oct 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 99350ae471e1271cae7bb3ef68b5ee0e11c21828:

  Merge branch 'rbd-poll' (2016-10-19 09:24:04 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e291cff14e97feb3cff711f5a5cbcb63b32f9c72:

  Use fmt -w WIDTH option instead of -WIDTH (2016-10-20 08:10:10 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (2):
      Remove getopt_long_only macro from NetBSD header
      Use fmt -w WIDTH option instead of -WIDTH

 Makefile       | 4 ++--
 os/os-netbsd.h | 3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

---

Diff of recent changes:

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
 
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index 4c629dd..1ef5866 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -74,7 +74,4 @@ static inline unsigned long long get_fs_free_size(const char *path)
 #define FIO_MADV_FREE	MADV_FREE
 #endif
 
-/* XXX NetBSD doesn't have getopt_long_only */
-#define	getopt_long_only	getopt_long
-
 #endif
