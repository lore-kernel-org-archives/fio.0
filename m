Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/4] Python style/portability fix
Date: Wed, 11 Jan 2017 02:39:47 +0900
Message-Id: <1484069987-13105-4-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1484069987-13105-1-git-send-email-tkusumi@tuxera.com>
References: <1484069987-13105-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

In practice, one would normally explicitly derive a class from
object class (was called new-style class back then).
https://docs.python.org/release/2.5.2/ref/node33.html
https://wiki.python.org/moin/NewClassVsClassicClass

print needs parentheses for portability with Python3.x.

xrange() only exists in Python2.x (i.e. breaks on Python3.x).
Using range() (which pre-allocates a whole list in Python2.x)
won't be a problem unless len(averages) is huge enough to give
any pressure to vm subsystem.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 tools/fiologparser.py | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/fiologparser.py b/tools/fiologparser.py
index 685f419..5a95009 100755
--- a/tools/fiologparser.py
+++ b/tools/fiologparser.py
@@ -45,7 +45,7 @@ def print_full(ctx, series):
     while (start < ftime):
         end = ftime if ftime < end else end
         results = [ts.get_value(start, end) for ts in series]
-        print "%s, %s" % (end, ', '.join(["%0.3f" % i for i in results]))
+        print("%s, %s" % (end, ', '.join(["%0.3f" % i for i in results])))
         start += ctx.interval
         end += ctx.interval
 
@@ -57,7 +57,7 @@ def print_sums(ctx, series):
     while (start < ftime):
         end = ftime if ftime < end else end
         results = [ts.get_value(start, end) for ts in series]
-        print "%s, %0.3f" % (end, sum(results))
+        print("%s, %0.3f" % (end, sum(results)))
         start += ctx.interval
         end += ctx.interval
 
@@ -69,7 +69,7 @@ def print_averages(ctx, series):
     while (start < ftime):
         end = ftime if ftime < end else end
         results = [ts.get_value(start, end) for ts in series]
-        print "%s, %0.3f" % (end, float(sum(results))/len(results))
+        print("%s, %0.3f" % (end, float(sum(results))/len(results)))
         start += ctx.interval
         end += ctx.interval
 
@@ -147,11 +147,11 @@ def print_default(ctx, series):
         end += ctx.interval
 
     total = 0
-    for i in xrange(0, len(averages)):
+    for i in range(0, len(averages)):
         total += averages[i]*weights[i]
-    print '%0.3f' % (total/sum(weights))
+    print('%0.3f' % (total/sum(weights)))
  
-class TimeSeries():
+class TimeSeries(object):
     def __init__(self, ctx, fn):
         self.ctx = ctx
         self.last = None 
@@ -185,7 +185,7 @@ class TimeSeries():
             value += sample.get_contribution(start, end)
         return value
 
-class Sample():
+class Sample(object):
     def __init__(self, ctx, start, end, value):
        self.ctx = ctx
        self.start = start
-- 
2.5.5


