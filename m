Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51468 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933787AbdBQNAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 17 Feb 2017 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cei8p-0005hU-6b
        for fio@vger.kernel.org; Fri, 17 Feb 2017 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170217130001.91BE42C0218@kernel.dk>
Date: Fri, 17 Feb 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5c8e84cab3bca39de54a69092473f000f8a57f40:

  Explicitly check td_trim(td) for the direction of next io_u (2017-02-15 13:52:24 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b3e7e59290577696dc76c08651cce1e121cff64a:

  Merge branch 'travis_osx' of https://github.com/sitsofe/fio (2017-02-16 09:00:08 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'travis_osx' of https://github.com/sitsofe/fio

Sitsofe Wheeler (4):
      Makefile: add test using the null ioengine
      travis: run parallel make jobs
      travis: prepare for additional builds
      travis: add OS X builds

 .travis.yml | 25 +++++++++++++++++++++++--
 Makefile    |  5 +++--
 2 files changed, 26 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/.travis.yml b/.travis.yml
index bf0433d..ca50e22 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -1,7 +1,28 @@
 language: c
+os:
+  - linux
 compiler:
   - clang
   - gcc
+env:
+  global:
+    - MAKEFLAGS="-j 2"
+matrix:
+  include:
+    - os: osx
+      compiler: clang # Workaround travis setting CC=["clang", "gcc"]
+    # Build using the 10.12 SDK but target and run on OSX 10.11
+#   - os: osx
+#     compiler: clang
+#     osx_image: xcode8
+#     env: SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk MACOSX_DEPLOYMENT_TARGET=10.11
+    #��Build on the latest OSX version (will eventually become��obsolete)
+    - os: osx
+      compiler: clang
+      osx_image: xcode8.2
+  exclude:
+    - os: osx
+      compiler: gcc
 before_install:
-  - sudo apt-get -qq update
-  - sudo apt-get install -qq -y libaio-dev libnuma-dev libz-dev
+  - if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then sudo apt-get -qq update; fi
+  - if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then sudo apt-get install -qq -y libaio-dev libnuma-dev libz-dev; fi
diff --git a/Makefile b/Makefile
index a2842a0..4112410 100644
--- a/Makefile
+++ b/Makefile
@@ -303,7 +303,7 @@ endif
 
 all: $(PROGS) $(T_TEST_PROGS) $(SCRIPTS) FORCE
 
-.PHONY: all install clean
+.PHONY: all install clean test
 .PHONY: FORCE cscope
 
 FIO-VERSION-FILE: FORCE
@@ -448,7 +448,8 @@ doc: tools/plot/fio2gnuplot.1
 	@man -t tools/plot/fio2gnuplot.1 | ps2pdf - fio2gnuplot.pdf
 	@man -t tools/hist/fiologparser_hist.py.1 | ps2pdf - fiologparser_hist.pdf
 
-test:
+test: fio
+	./fio --minimal --ioengine=null --runtime=1s --name=nulltest --rw=randrw --iodepth=2 --norandommap --random_generator=tausworthe64 --size=16T --name=verifynulltest --rw=write --verify=crc32c --verify_state_save=0 --size=100M
 
 install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
 	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
