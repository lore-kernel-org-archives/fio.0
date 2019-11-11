Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 3/3] t/run-fio-tests: improve error handling
Date: Mon, 11 Nov 2019 11:30:55 -0500
Message-Id: <20191111163055.7358-4-vincentfu@gmail.com>
In-Reply-To: <20191111163055.7358-1-vincentfu@gmail.com>
References: <20191111163055.7358-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

More gracefully handle errors when running a test. Also change the
EXAMPLE to refer to fio's canonical git repository.
---
 t/run-fio-tests.py | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 1b8ca0a2..cf8de093 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -14,7 +14,7 @@
 #
 #
 # EXAMPLE
-# # git clone [fio-repository]
+# # git clone git://git.kernel.dk/fio.git
 # # cd fio
 # # make -j
 # # python3 t/run-fio-tests.py
@@ -123,6 +123,7 @@ class FioExeTest(FioTest):
         stderr_file = open(self.stderr_file, "w+")
         exticode_file = open(self.exticode_file, "w+")
         try:
+            proc = None
             # Avoid using subprocess.run() here because when a timeout occurs,
             # fio will be stopped with SIGKILL. This does not give fio a
             # chance to clean up and means that child processes may continue
@@ -142,9 +143,10 @@ class FioExeTest(FioTest):
             assert proc.poll()
             self.output['failure'] = 'timeout'
         except Exception:
-            if not proc.poll():
-                proc.terminate()
-                proc.communicate()
+            if proc:
+                if not proc.poll():
+                    proc.terminate()
+                    proc.communicate()
             self.output['failure'] = 'exception'
             self.output['exc_info'] = sys.exc_info()
         finally:
-- 
2.17.1


