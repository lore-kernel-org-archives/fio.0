Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49540 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbbKZNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 26 Nov 2015 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1a1aYw-0006b2-GK
	for fio@vger.kernel.org; Wed, 25 Nov 2015 13:56:46 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151126130001.A9FB42C00ED@kernel.dk>
Date: Thu, 26 Nov 2015 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit aab8901041d1bb548d58e3cb1038a19d73ecd094:

  Fio 2.2.12 (2015-11-24 21:13:34 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6a6b11f436c822cac154da5a60c4cc6baa6a8008:

  Makefile: generate .d dep file for init.c (2015-11-25 21:24:01 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Makefile: generate .d dep file for init.c

 Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 0b506e8..e30273c 100644
--- a/Makefile
+++ b/Makefile
@@ -324,7 +324,14 @@ parse.o: lex.yy.o y.tab.o
 endif
 
 init.o: init.c FIO-VERSION-FILE
+	@mkdir -p $(dir $@)
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
+	@$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SRCDIR)/$*.c > $*.d
+	@mv -f $*.d $*.d.tmp
+	@sed -e 's|.*:|$*.o:|' < $*.d.tmp > $*.d
+	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -1 | \
+		sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
+	@rm -f $*.d.tmp
 
 gcompat.o: gcompat.c gcompat.h
 	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c $<
