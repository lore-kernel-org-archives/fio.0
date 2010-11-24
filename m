Return-Path: <fio-owner@vger.kernel.org>
Received: from vserver01.sebastiankayser.de ([85.88.7.146]:41481 "EHLO
	vserver01.sebastiankayser.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754425Ab0KXMZy (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 24 Nov 2010 07:25:54 -0500
Date: Wed, 24 Nov 2010 13:16:11 +0100
From: Sebastian Kayser <sebastian@skayser.de>
Subject: [PATCH] Makefile.solaris: install man pages
Message-ID: <20101124121611.GI28050@sebastiankayser.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

this patch brings Makefile.solaris in sync with the other Makefiles:
also install man pages on Solaris.

---
 Makefile.solaris |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Makefile.solaris b/Makefile.solaris
index d48453b..76b2ed5 100644
--- a/Makefile.solaris
+++ b/Makefile.solaris
@@ -51,3 +51,6 @@ cscope:
 install: $(PROGS) $(SCRIPTS)
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
+	$(INSTALL) -m 755 -d $(DESTDIR)$(mandir)/man1
+	$(INSTALL) -m 644 fio.1 $(DESTDIR)$(mandir)/man1
+	$(INSTALL) -m 644 fio_generate_plots.1 $(DESTDIR)$(mandir)/man1
-- 
1.7.3

Sebastian
