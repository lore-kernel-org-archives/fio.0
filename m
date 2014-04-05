Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48359 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaDEMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 5 Apr 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WWPGY-0003DO-9t
	for fio@vger.kernel.org; Sat, 05 Apr 2014 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140405120003.5C9CD400B1@strynoevaenget.dk>
Date: Sat,  5 Apr 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ee2e5717d1df0c37279eb94876777ee43d403e58:

  Fix JSON_INTEGER overflow on Windows by changing datatype to 'long long' (2014-04-03 12:22:35 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7788b76fe13059aa3610f592e58512cb5f4cdb28:

  Makefile: add doc target to generate PDFs from the man pages (2014-04-04 08:28:17 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Makefile: add doc target to generate PDFs from the man pages

 Makefile |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 231b4ab..3c9e0ee 100644
--- a/Makefile
+++ b/Makefile
@@ -277,7 +277,7 @@ clean: FORCE
 	-rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core gfio FIO-VERSION-FILE *.d config-host.mak config-host.h
 
 distclean: clean FORCE
-	@rm -f cscope.out
+	@rm -f cscope.out fio.pdf fio_generate_plots.pdf fio2gnuplot.pdf
 
 cscope:
 	@cscope -b -R
@@ -285,6 +285,11 @@ cscope:
 tools/plot/fio2gnuplot.1:
 	@cat tools/plot/fio2gnuplot.manpage | txt2man -t fio2gnuplot >  tools/plot/fio2gnuplot.1
 
+doc: tools/plot/fio2gnuplot.1
+	@man -t ./fio.1 | ps2pdf - fio.pdf
+	@man -t tools/fio_generate_plots.1 | ps2pdf - fio_generate_plots.pdf
+	@man -t tools/plot/fio2gnuplot.1 | ps2pdf - fio2gnuplot.pdf
+
 install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
 	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
