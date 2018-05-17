Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57450 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeEQMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 17 May 2018 08:00:11 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fJHZq-0005lV-7x
        for fio@vger.kernel.org; Thu, 17 May 2018 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180517120001.C92C92C00DE@kernel.dk>
Date: Thu, 17 May 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 540e235dcd276e63c57ca4bd35f70a0651e2d00e:

  Merge branch 'master' of https://github.com/majianpeng/fio (2018-05-14 19:40:32 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5eac3b00238b450ac0679121a76f1e566ca8f468:

  make fio scripts python3-ready (2018-05-16 11:17:55 -0600)

----------------------------------------------------------------
Bill O'Donnell (1):
      make fio scripts python3-ready

 doc/conf.py                     |  3 +++
 tools/fiologparser.py           |  3 +++
 unit_tests/steadystate_tests.py | 20 ++++++++++++--------
 3 files changed, 18 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/doc/conf.py b/doc/conf.py
index d4dd9d2..087a9a1 100644
--- a/doc/conf.py
+++ b/doc/conf.py
@@ -22,6 +22,9 @@
 
 # -- General configuration ------------------------------------------------
 
+from __future__ import absolute_import
+from __future__ import print_function
+
 # If your documentation needs a minimal Sphinx version, state it here.
 #
 # needs_sphinx = '1.0'
diff --git a/tools/fiologparser.py b/tools/fiologparser.py
index 8549859..cc29f1c 100755
--- a/tools/fiologparser.py
+++ b/tools/fiologparser.py
@@ -1,4 +1,5 @@
 #!/usr/bin/python2.7
+# Note: this script is python2 and python 3 compatible.
 #
 # fiologparser.py
 #
@@ -13,6 +14,8 @@
 #
 # to see per-interval average completion latency.
 
+from __future__ import absolute_import
+from __future__ import print_function
 import argparse
 import math
 
diff --git a/unit_tests/steadystate_tests.py b/unit_tests/steadystate_tests.py
index 5a74f95..50254dc 100755
--- a/unit_tests/steadystate_tests.py
+++ b/unit_tests/steadystate_tests.py
@@ -1,4 +1,5 @@
 #!/usr/bin/python2.7
+# Note: this script is python2 and python 3 compatible.
 #
 # steadystate_tests.py
 #
@@ -18,6 +19,8 @@
 # if ss attained: min runtime = ss_dur + ss_ramp
 # if not attained: runtime = timeout
 
+from __future__ import absolute_import
+from __future__ import print_function
 import os
 import sys
 import json
@@ -26,11 +29,12 @@ import pprint
 import argparse
 import subprocess
 from scipy import stats
+from six.moves import range
 
 def parse_args():
     parser = argparse.ArgumentParser()
     parser.add_argument('fio',
-                        help='path to fio executable');
+                        help='path to fio executable')
     parser.add_argument('--read',
                         help='target for read testing')
     parser.add_argument('--write',
@@ -45,7 +49,7 @@ def check(data, iops, slope, pct, limit, dur, criterion):
     data = data[measurement]
     mean = sum(data) / len(data)
     if slope:
-        x = range(len(data))
+        x = list(range(len(data)))
         m, intercept, r_value, p_value, std_err = stats.linregress(x,data)
         m = abs(m)
         if pct:
@@ -89,11 +93,11 @@ if __name__ == '__main__':
                   'output': "set steady state BW threshold to 12" },
               ]
     for test in parsing:
-        output = subprocess.check_output([args.fio] + test['args']);
-        if test['output'] in output:
-            print "PASSED '{0}' found with arguments {1}".format(test['output'], test['args'])
+        output = subprocess.check_output([args.fio] + test['args'])
+        if test['output'] in output.decode():
+            print("PASSED '{0}' found with arguments {1}".format(test['output'], test['args']))
         else:
-            print "FAILED '{0}' NOT found with arguments {1}".format(test['output'], test['args'])
+            print("FAILED '{0}' NOT found with arguments {1}".format(test['output'], test['args']))
 
 #
 # test some read workloads
@@ -117,7 +121,7 @@ if __name__ == '__main__':
             args.read = '/dev/zero'
             extra = [ "--size=134217728" ]  # 128 MiB
         else:
-            print "ERROR: file for read testing must be specified on non-posix systems"
+            print("ERROR: file for read testing must be specified on non-posix systems")
             sys.exit(1)
     else:
         extra = []
@@ -216,7 +220,7 @@ if __name__ == '__main__':
                 else:
                     result = 'FAILED '
                 line = result + line + ' no ss, expected runtime {0} ~= actual runtime {1}'.format(expected, actual)
-            print line
+            print(line)
             if 'steadystate' in jsonjob:
                 pp.pprint(jsonjob['steadystate'])
         jobnum += 1
