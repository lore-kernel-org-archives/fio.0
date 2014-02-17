Return-Path: <fio-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:51795 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752315AbaBQNNu (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 17 Feb 2014 08:13:50 -0500
From: Daniel Gollub <d.gollub@telekom.de>
Subject: [PATCH 3/3] add example job file for the RBD engine
Date: Mon, 17 Feb 2014 13:53:07 +0100
Message-Id: <1392641587-24803-3-git-send-email-d.gollub@telekom.de>
In-Reply-To: <1392641587-24803-1-git-send-email-d.gollub@telekom.de>
References: <1392641587-24803-1-git-send-email-d.gollub@telekom.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Danny Al-Gaaf <danny.al-gaaf@bisect.de>

From: Danny Al-Gaaf <danny.al-gaaf@bisect.de>

Signed-off-by: Danny Al-Gaaf <danny.al-gaaf@bisect.de>
---
 examples/rbd.fio |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 examples/rbd.fio

diff --git a/examples/rbd.fio b/examples/rbd.fio
new file mode 100644
index 0000000..fcb494a
--- /dev/null
+++ b/examples/rbd.fio
@@ -0,0 +1,23 @@
+######################################################################
+# Example test for the RBD engine.
+# 
+# Runs a 4k random write test agains a RBD via librbd  
+#
+# NOTE: Make sure you have either a RBD named 'fio_test' or change 
+#       the rbdname parameter.
+######################################################################
+[global]
+#logging
+#write_iops_log=write_iops_log
+#write_bw_log=write_bw_log
+#write_lat_log=write_lat_log
+ioengine=rbd
+clientname=admin
+pool=rbd
+rbdname=fio_test
+invalidate=0	# mandatory
+rw=randwrite
+bs=4k
+
+[rbd_iodepth32]
+iodepth=32
-- 
1.7.10.4

