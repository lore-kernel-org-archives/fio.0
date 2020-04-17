Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46976 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730483AbgDQMAY (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 17 Apr 2020 08:00:24 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPPfB-0007H8-Lp
        for fio@vger.kernel.org; Fri, 17 Apr 2020 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200417120002.132981BC0187@kernel.dk>
Date: Fri, 17 Apr 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f5501dd2e466e53cd606e304f1cb6b0a49b481dc:

  Merge branch 'appveyor-artifacts' of https://github.com/vincentkfu/fio (2020-04-15 08:29:01 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8dbd327fbaa267eef862843a270fac61d06df00b:

  Merge branch 'patch-1' of https://github.com/aakarshg/fio (2020-04-16 14:04:26 -0600)

----------------------------------------------------------------
Aakarsh Gopi (1):
      Add fio-histo-log-pctiles to make file

Jens Axboe (1):
      Merge branch 'patch-1' of https://github.com/aakarshg/fio

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index cb9e1775..f1e984f5 100644
--- a/Makefile
+++ b/Makefile
@@ -25,7 +25,7 @@ OPTFLAGS= -g -ffast-math
 CFLAGS	:= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR) $(CFLAGS)
 LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
-SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/hist/fiologparser_hist.py tools/fio_jsonplus_clat2csv)
+SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/hist/fiologparser_hist.py tools/hist/fio-histo-log-pctiles.py tools/fio_jsonplus_clat2csv)
 
 ifndef CONFIG_FIO_NO_OPT
   CFLAGS := -O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 $(CFLAGS)

