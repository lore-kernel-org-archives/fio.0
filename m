Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729674AbgFHMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Jun 2020 08:00:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFDAC08C5C2
        for <fio@vger.kernel.org>; Mon,  8 Jun 2020 05:00:04 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jiGRg-00079z-6a
        for fio@vger.kernel.org; Mon, 08 Jun 2020 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200608120002.4A03A1BC017D@kernel.dk>
Date: Mon,  8 Jun 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 08541925ec1b5887fc91e59a4bc253d54757c4c6:

  Makefile: include linux-blkzoned.c for Android, if set (2020-06-05 07:06:46 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c9beb194ef608dc49dd2f7537b90951f3c8b432d:

  t/run-fio-tests.py: Accept a wider range of IOPS values (2020-06-07 17:30:42 -0600)

----------------------------------------------------------------
Bart Van Assche (4):
      .travis.yml: Move shell code out of .travis.yml
      ci/travis-install.sh: Install python3-six package
      Switch to Python3
      t/run-fio-tests.py: Accept a wider range of IOPS values

Vincent Fu (1):
      ci/travis-install.sh, MacOS: Install the Python 'six' package

 .travis.yml                         | 28 +++--------------------
 ci/travis-build.sh                  | 16 ++++++++++++++
 ci/travis-install.sh                | 44 +++++++++++++++++++++++++++++++++++++
 t/run-fio-tests.py                  |  2 +-
 t/sgunmap-perf.py                   |  2 +-
 t/sgunmap-test.py                   |  2 +-
 tools/fio_jsonplus_clat2csv         |  2 +-
 tools/fiologparser.py               |  3 ++-
 tools/hist/fio-histo-log-pctiles.py |  5 +++--
 tools/hist/fiologparser_hist.py     | 11 ++++------
 tools/hist/half-bins.py             |  2 +-
 tools/plot/fio2gnuplot              |  2 +-
 12 files changed, 78 insertions(+), 41 deletions(-)
 create mode 100755 ci/travis-build.sh
 create mode 100755 ci/travis-install.sh

---

Diff of recent changes:

diff --git a/.travis.yml b/.travis.yml
index eba16baa..b64f0a95 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -39,29 +39,7 @@ matrix:
       arch: arm64
 
 before_install:
-  - EXTRA_CFLAGS="-Werror"
-  - if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
-        pkgs=(libaio-dev libcunit1 libcunit1-dev libgoogle-perftools4 libibverbs-dev libiscsi-dev libnuma-dev librbd-dev librdmacm-dev libz-dev);
-        if [[ "$BUILD_ARCH" == "x86" ]]; then
-            pkgs=("${pkgs[@]/%/:i386}");
-            pkgs+=(gcc-multilib python3-scipy);
-            EXTRA_CFLAGS="${EXTRA_CFLAGS} -m32";
-        else
-            pkgs+=(glusterfs-common python3-scipy);
-        fi;
-        sudo apt-get -qq update;
-        sudo apt-get install --no-install-recommends -qq -y "${pkgs[@]}";
-    fi;
-  - if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
-        brew update;
-        brew install cunit;
-        pip3 install scipy;
-    fi;
+  - ci/travis-install.sh
+
 script:
-  - ./configure --extra-cflags="${EXTRA_CFLAGS}" && make
-  - make test
-  - if [[ "$TRAVIS_CPU_ARCH" == "arm64" ]]; then
-        sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug -p 1010:"--skip 15 16 17 18 19 20";
-    else
-        sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug;
-    fi;
+  - ci/travis-build.sh
diff --git a/ci/travis-build.sh b/ci/travis-build.sh
new file mode 100755
index 00000000..fff9c088
--- /dev/null
+++ b/ci/travis-build.sh
@@ -0,0 +1,16 @@
+#!/bin/bash
+
+EXTRA_CFLAGS="-Werror"
+
+if [[ "$BUILD_ARCH" == "x86" ]]; then
+    EXTRA_CFLAGS="${EXTRA_CFLAGS} -m32"
+fi
+
+./configure --extra-cflags="${EXTRA_CFLAGS}" &&
+    make &&
+    make test &&
+    if [[ "$TRAVIS_CPU_ARCH" == "arm64" ]]; then
+	sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug -p 1010:"--skip 15 16 17 18 19 20"
+    else
+	sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug
+    fi
diff --git a/ci/travis-install.sh b/ci/travis-install.sh
new file mode 100755
index 00000000..232ab6b1
--- /dev/null
+++ b/ci/travis-install.sh
@@ -0,0 +1,44 @@
+#!/bin/bash
+
+case "$TRAVIS_OS_NAME" in
+    "linux")
+	# Architecture-dependent packages.
+	pkgs=(
+	    libaio-dev
+	    libcunit1
+	    libcunit1-dev
+	    libgoogle-perftools4
+	    libibverbs-dev
+	    libiscsi-dev
+	    libnuma-dev
+	    librbd-dev
+	    librdmacm-dev
+	    libz-dev
+	)
+	if [[ "$BUILD_ARCH" == "x86" ]]; then
+	    pkgs=("${pkgs[@]/%/:i386}")
+	    pkgs+=(gcc-multilib)
+	else
+	    pkgs+=(glusterfs-common)
+	fi
+	# Architecture-independent packages and packages for which we don't
+	# care about the architecture.
+	pkgs+=(
+	    python3
+	    python3-scipy
+	    python3-six
+	)
+	sudo apt-get -qq update
+	sudo apt-get install --no-install-recommends -qq -y "${pkgs[@]}"
+	;;
+    "osx")
+	brew update >/dev/null 2>&1
+	brew install cunit
+	pip3 install scipy
+	pip3 install six
+	;;
+esac
+
+echo "Python version: $(/usr/bin/python -V 2>&1)"
+echo "Python3 path: $(which python3 2>&1)"
+echo "Python3 version: $(python3 -V 2>&1)"
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index e7063d3e..c2352d80 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -438,7 +438,7 @@ class FioJobTest_t0011(FioJobTest):
         logging.debug("Test %d: iops1: %f", self.testnum, iops1)
         logging.debug("Test %d: ratio: %f", self.testnum, ratio)
 
-        if iops1 < 998 or iops1 > 1002:
+        if iops1 < 997 or iops1 > 1003:
             self.failure_reason = "{0} iops value mismatch,".format(self.failure_reason)
             self.passed = False
 
diff --git a/t/sgunmap-perf.py b/t/sgunmap-perf.py
index fadbb859..962d187d 100755
--- a/t/sgunmap-perf.py
+++ b/t/sgunmap-perf.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2.7
+#!/usr/bin/env python3
 #
 # sgunmap-test.py
 #
diff --git a/t/sgunmap-test.py b/t/sgunmap-test.py
index f8f10ab3..4960a040 100755
--- a/t/sgunmap-test.py
+++ b/t/sgunmap-test.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2.7
+#!/usr/bin/env python3
 # Note: this script is python2 and python 3 compatible.
 #
 # sgunmap-test.py
diff --git a/tools/fio_jsonplus_clat2csv b/tools/fio_jsonplus_clat2csv
index 9544ab74..7f310fcc 100755
--- a/tools/fio_jsonplus_clat2csv
+++ b/tools/fio_jsonplus_clat2csv
@@ -1,4 +1,4 @@
-#!/usr/bin/python2.7
+#!/usr/bin/env python3
 # Note: this script is python2 and python3 compatible.
 
 """
diff --git a/tools/fiologparser.py b/tools/fiologparser.py
index cc29f1c7..054f1f60 100755
--- a/tools/fiologparser.py
+++ b/tools/fiologparser.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2.7
+#!/usr/bin/env python3
 # Note: this script is python2 and python 3 compatible.
 #
 # fiologparser.py
@@ -18,6 +18,7 @@ from __future__ import absolute_import
 from __future__ import print_function
 import argparse
 import math
+from functools import reduce
 
 def parse_args():
     parser = argparse.ArgumentParser()
diff --git a/tools/hist/fio-histo-log-pctiles.py b/tools/hist/fio-histo-log-pctiles.py
index f9df2a3d..08e7722d 100755
--- a/tools/hist/fio-histo-log-pctiles.py
+++ b/tools/hist/fio-histo-log-pctiles.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 
 # module to parse fio histogram log files, not using pandas
 # runs in python v2 or v3
@@ -24,6 +24,7 @@
 import sys, os, math, copy, time
 from copy import deepcopy
 import argparse
+from functools import reduce
 
 unittest2_imported = True
 try:
@@ -82,7 +83,7 @@ def parse_hist_file(logfn, buckets_per_interval, log_hist_msec):
         except ValueError as e:
             raise FioHistoLogExc('non-integer value %s' % exception_suffix(k+1, logfn))
 
-        neg_ints = list(filter( lambda tk : tk < 0, int_tokens ))
+        neg_ints = list([tk for tk in int_tokens if tk < 0])
         if len(neg_ints) > 0:
             raise FioHistoLogExc('negative integer value %s' % exception_suffix(k+1, logfn))
 
diff --git a/tools/hist/fiologparser_hist.py b/tools/hist/fiologparser_hist.py
index 8910d5fa..159454b1 100755
--- a/tools/hist/fiologparser_hist.py
+++ b/tools/hist/fiologparser_hist.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2.7
+#!/usr/bin/env python3
 """ 
     Utility for converting *_clat_hist* files generated by fio into latency statistics.
     
@@ -124,7 +124,7 @@ def gen_output_columns(ctx):
         columns = ["end-time", "dir", "samples", "min", "avg", "median"]
     else:
         columns = ["end-time", "samples", "min", "avg", "median"]
-    columns.extend(list(map(lambda x: x+'%', strpercs)))
+    columns.extend(list([x+'%' for x in strpercs]))
     columns.append("max")
 
 def fmt_float_list(ctx, num=1):
@@ -339,7 +339,7 @@ def guess_max_from_bins(ctx, hist_cols):
     else:
         bins = [1216,1280,1344,1408,1472,1536,1600,1664]
     coarses = range(max_coarse + 1)
-    fncn = lambda z: list(map(lambda x: z/2**x if z % 2**x == 0 else -10, coarses))
+    fncn = lambda z: list([z/2**x if z % 2**x == 0 else -10 for x in coarses])
     
     arr = np.transpose(list(map(fncn, bins)))
     idx = np.where(arr == hist_cols)
@@ -470,10 +470,7 @@ def output_interval_data(ctx,directions):
 def main(ctx):
 
     if ctx.job_file:
-        try:
-            from configparser import SafeConfigParser, NoOptionError
-        except ImportError:
-            from ConfigParser import SafeConfigParser, NoOptionError
+        from configparser import SafeConfigParser, NoOptionError
 
         cp = SafeConfigParser(allow_no_value=True)
         with open(ctx.job_file, 'r') as fp:
diff --git a/tools/hist/half-bins.py b/tools/hist/half-bins.py
index 1bba8ff7..42af9540 100755
--- a/tools/hist/half-bins.py
+++ b/tools/hist/half-bins.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2.7
+#!/usr/bin/env python3
 """ Cut the number bins in half in fio histogram output. Example usage:
 
         $ half-bins.py -c 2 output_clat_hist.1.log > smaller_clat_hist.1.log
diff --git a/tools/plot/fio2gnuplot b/tools/plot/fio2gnuplot
index 69aa791e..78ee82fb 100755
--- a/tools/plot/fio2gnuplot
+++ b/tools/plot/fio2gnuplot
@@ -1,4 +1,4 @@
-#!/usr/bin/python2.7
+#!/usr/bin/env python3
 # Note: this script is python2 and python3 compatible.
 #
 #  Copyright (C) 2013 eNovance SAS <licensing@enovance.com>

