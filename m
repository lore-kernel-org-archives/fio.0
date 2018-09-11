Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33816 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbeIKQ7V (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Sep 2018 12:59:21 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fzhL9-0006XJ-9K
        for fio@vger.kernel.org; Tue, 11 Sep 2018 12:00:20 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180911120002.2FCD72C00A8@kernel.dk>
Date: Tue, 11 Sep 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ed06328df452330b7210db2558ae125f6e0d8fe2:

  Merge branch 'master' of https://github.com/bvanassche/fio (2018-09-09 17:42:10 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 39281024d26b5dbd4c70ce7620aeadc8933ac8c7:

  Merge branch 'no-unittest-dep' of https://github.com/parallel-fs-utils/fio (2018-09-10 09:56:11 -0600)

----------------------------------------------------------------
Ben England (1):
      remove dependency on unittest2 module

Jens Axboe (1):
      Merge branch 'no-unittest-dep' of https://github.com/parallel-fs-utils/fio

 tools/hist/fio-histo-log-pctiles.py | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/tools/hist/fio-histo-log-pctiles.py b/tools/hist/fio-histo-log-pctiles.py
index c398113..bb016ea 100755
--- a/tools/hist/fio-histo-log-pctiles.py
+++ b/tools/hist/fio-histo-log-pctiles.py
@@ -24,7 +24,12 @@
 import sys, os, math, copy
 from copy import deepcopy
 import argparse
-import unittest2
+
+unittest2_imported = True
+try:
+    import unittest2
+except ImportError:
+    unittest2_imported = False
 
 msec_per_sec = 1000
 nsec_per_usec = 1000
@@ -412,14 +417,14 @@ def compute_percentiles_from_logs():
 #end of MAIN PROGRAM
 
 
-
 ##### below are unit tests ##############
 
-import tempfile, shutil
-from os.path import join
-should_not_get_here = False
+if unittest2_imported:
+  import tempfile, shutil
+  from os.path import join
+  should_not_get_here = False
 
-class Test(unittest2.TestCase):
+  class Test(unittest2.TestCase):
     tempdir = None
 
     # a little less typing please
@@ -651,7 +656,10 @@ class Test(unittest2.TestCase):
 
 if __name__ == '__main__':
     if os.getenv('UNITTEST'):
-        sys.exit(unittest2.main())
+        if unittest2_imported:
+            sys.exit(unittest2.main())
+        else:
+            raise Exception('you must install unittest2 module to run unit test')
     else:
         compute_percentiles_from_logs()
 

