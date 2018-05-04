Return-Path: <fio-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751527AbeEDTnl (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 May 2018 15:43:41 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9FD9881A88C3
        for <fio@vger.kernel.org>; Fri,  4 May 2018 19:43:40 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-121-14.rdu2.redhat.com [10.10.121.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EFDA83B91
        for <fio@vger.kernel.org>; Fri,  4 May 2018 19:43:40 +0000 (UTC)
From: Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH v2] make fio scripts python3-ready
Date: Fri,  4 May 2018 14:43:40 -0500
Message-Id: <20180504194340.1835-1-billodo@redhat.com>
In-Reply-To: <20180504143449.31934-1-billodo@redhat.com>
References: <20180504143449.31934-1-billodo@redhat.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Many distributions are moving to python3 by default.  Here's
an attempt to make the python scripts in fio python3-ready.

Conversion was facilitated with automated tools. A few areas
were hand fixed: remove superfluous parentheses introduced by
2to3 converter in print function calls, shebang modifications
to use environment variable for python version, and byte-string
decode correction in steadystate_tests.py following 2to3
conversion.

The modified scripts pass rudimentary testing when run under
python2.7 as well as python3.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
v2: Remove unnecessary changes to fiologparser_hist.py as
    its conversion has been covered in earlier patches.
    Keep shebangs at previous python2.7 state. Remove
    superfluous imports.


 doc/conf.py                     |  3 +++
 tools/fiologparser.py           |  3 +++
 unit_tests/steadystate_tests.py | 20 ++++++++++++--------
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/doc/conf.py b/doc/conf.py
index d4dd9d20..087a9a11 100644
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
index 8549859f..cc29f1c7 100755
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
index 5a74f956..50254dcc 100755
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
-- 
2.14.3

