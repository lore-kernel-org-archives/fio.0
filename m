Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 6/9] t/steadystate_tests: use null ioengine for tests
Date: Tue, 10 Dec 2019 12:54:39 -0500
Message-Id: <20191210175442.2975-7-vincentfu@gmail.com>
In-Reply-To: <20191210175442.2975-1-vincentfu@gmail.com>
References: <20191210175442.2975-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Instead of reading from /dev/zero just use the null ioengine. This
enables the script to run on Windows.
---
 t/steadystate_tests.py | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/t/steadystate_tests.py b/t/steadystate_tests.py
index 53b0f35e..9122a60f 100755
--- a/t/steadystate_tests.py
+++ b/t/steadystate_tests.py
@@ -31,12 +31,7 @@ from scipy import stats
 
 def parse_args():
     parser = argparse.ArgumentParser()
-    parser.add_argument('fio',
-                        help='path to fio executable')
-    parser.add_argument('--read',
-                        help='target for read testing')
-    parser.add_argument('--write',
-                        help='target for write testing')
+    parser.add_argument('fio', help='path to fio executable')
     args = parser.parse_args()
 
     return args
@@ -123,26 +118,16 @@ if __name__ == '__main__':
               {'s': True, 'timeout': 10, 'numjobs': 3, 'ss_dur': 10, 'ss_ramp': 500, 'iops': False, 'slope': True, 'ss_limit': 0.1, 'pct': True},
             ]
 
-    if args.read == None:
-        if os.name == 'posix':
-            args.read = '/dev/zero'
-            extra = [ "--size=128M" ]
-        else:
-            print("ERROR: file for read testing must be specified on non-posix systems")
-            sys.exit(1)
-    else:
-        extra = []
-
     jobnum = 0
     for job in reads:
 
         tf = "steadystate_job{0}.json".format(jobnum)
         parameters = [ "--name=job{0}".format(jobnum) ]
-        parameters.extend(extra)
         parameters.extend([ "--thread",
                             "--output-format=json",
                             "--output={0}".format(tf),
-                            "--filename={0}".format(args.read),
+                            "--ioengine=null",
+                            "--size=1G",
                             "--rw=randrw",
                             "--rwmixread=100",
                             "--stonewall",
-- 
2.17.1


