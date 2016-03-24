Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42228 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbcCXMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 24 Mar 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aj3vn-0005Vm-Ku
	for fio@vger.kernel.org; Thu, 24 Mar 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160324120002.2EDA72C00C5@kernel.dk>
Date: Thu, 24 Mar 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e91ba49acb8ff9f2e82046fec4f42b790e8644b1:

  gen-rand: fix dependency on strcasestr.o (2016-03-20 09:38:57 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 546f51ce7a5667127f0ebb10fd4db8a4b817dea0:

  travis.yml: ensure we have libaio-dev and numa dev libs (2016-03-23 21:38:59 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Add .travis.yml
      Makefile: add empty 'test' target
      travis.yml: ensure we have libaio-dev and numa dev libs

 .travis.yml | 7 +++++++
 Makefile    | 2 ++
 2 files changed, 9 insertions(+)
 create mode 100644 .travis.yml

---

Diff of recent changes:

diff --git a/.travis.yml b/.travis.yml
new file mode 100644
index 0000000..9bef750
--- /dev/null
+++ b/.travis.yml
@@ -0,0 +1,7 @@
+language: c
+compiler:
+  - clang
+  - gcc
+before_install:
+  - sudo apt-get -qq update
+  - sudo apt-get install -y libaio-dev libnuma-dev
diff --git a/Makefile b/Makefile
index 749a508..1d761c9 100644
--- a/Makefile
+++ b/Makefile
@@ -424,6 +424,8 @@ doc: tools/plot/fio2gnuplot.1
 	@man -t tools/fio_generate_plots.1 | ps2pdf - fio_generate_plots.pdf
 	@man -t tools/plot/fio2gnuplot.1 | ps2pdf - fio2gnuplot.pdf
 
+test:
+
 install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
 	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
