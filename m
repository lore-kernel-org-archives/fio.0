Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53700 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbfLQNAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 17 Dec 2019 08:00:04 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ihCSJ-0007H3-RE
        for fio@vger.kernel.org; Tue, 17 Dec 2019 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191217130002.0CCF51BC0CE2@kernel.dk>
Date: Tue, 17 Dec 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 41ceb6c79aea52bd46ea13c5036722a294bb719e:

  t/run-fio-tests: relax acceptance criterion for t0011 (2019-12-11 20:55:07 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 397dddce43664df92101350f1fe5cd4c9cd2a2c7:

  Merge branch 'travis-xcode11.2-python' of https://github.com/vincentkfu/fio (2019-12-16 16:08:35 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      t/io_uring: check for CONFIG_HAVE_GETTID
      Fio 3.17
      Merge branch 'travis-xcode11.2-python' of https://github.com/vincentkfu/fio

Vincent Fu (1):
      .travis.yml: xcode11.2 scipy issue

 .travis.yml     | 9 ++++-----
 FIO-VERSION-GEN | 2 +-
 t/io_uring.c    | 2 ++
 3 files changed, 7 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/.travis.yml b/.travis.yml
index 0017db56..eee31988 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -43,17 +43,16 @@ before_install:
         fi;
         sudo apt-get -qq update;
         sudo apt-get install --no-install-recommends -qq -y "${pkgs[@]}";
-    fi
+    fi;
   - if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
         brew update;
         brew install cunit;
         if [[ "$TRAVIS_OSX_IMAGE" == "xcode11.2" ]]; then
             pip3 install scipy;
-        else
-            pip install scipy;
         fi;
-    fi
+        pip install scipy;
+    fi;
 script:
   - ./configure --extra-cflags="${EXTRA_CFLAGS}" && make
   - make test
-  - sudo python3 t/run-fio-tests.py --skip 6 1007 1008
+  - sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug
diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index d5cec22e..13ce8c16 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.16
+DEF_VER=fio-3.17
 
 LF='
 '
diff --git a/t/io_uring.c b/t/io_uring.c
index 62dee805..c2e5e098 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -133,10 +133,12 @@ static int io_uring_enter(struct submitter *s, unsigned int to_submit,
 			min_complete, flags, NULL, 0);
 }
 
+#ifndef CONFIG_HAVE_GETTID
 static int gettid(void)
 {
 	return syscall(__NR_gettid);
 }
+#endif
 
 static unsigned file_depth(struct submitter *s)
 {

