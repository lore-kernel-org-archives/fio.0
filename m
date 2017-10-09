Return-Path: <josef@toxicpanda.com>
Return-Path: <josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH] add an filecreate example file to examples/
Date: Mon,  9 Oct 2017 16:35:51 -0400
Message-Id: <1507581351-27797-1-git-send-email-josef@toxicpanda.com>
To: axboe@kernel.dk, kernel-team@fb.com, fio@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
List-ID: <fio@vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

This adds an example with some documentation on how to use
ioengine=filecreate.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 examples/filecreate-ioengine.fio | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 examples/filecreate-ioengine.fio

diff --git a/examples/filecreate-ioengine.fio b/examples/filecreate-ioengine.fio
new file mode 100644
index 000000000000..e1eb06cecb15
--- /dev/null
+++ b/examples/filecreate-ioengine.fio
@@ -0,0 +1,36 @@
+# Example filecreate job
+#
+# create_on_open is needed so that the open happens during the run and not the
+# setup.
+#
+# openfiles needs to be set so that you do not exceed the maximum allowed open
+# files.
+#
+# filesize needs to be set to a non zero value so fio will actually run, but the
+# IO will not really be done and the write latency numbers will only reflect the
+# open times.
+[global]
+create_on_open=1
+nrfiles=31250
+readwrite=write
+ioengine=filecreate
+fallocate=none
+filesize=4k
+openfiles=1
+
+[t0]
+[t1]
+[t2]
+[t3]
+[t4]
+[t5]
+[t6]
+[t7]
+[t8]
+[t9]
+[t10]
+[t11]
+[t12]
+[t13]
+[t14]
+[t15]
-- 
2.7.4


