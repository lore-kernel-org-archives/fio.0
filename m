Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26965 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbgDHGrU (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Apr 2020 02:47:20 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 3/3] examples: add libzbc ioengine example scripts
Date: Wed,  8 Apr 2020 15:47:19 +0900
Message-Id: <20200408064719.1621911-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

Add two example script files (random write and sequential read)
illustrating the use of the libzbc ioengine with zonemode=zbd.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 examples/libzbc-rand-write.fio | 20 ++++++++++++++++++++
 examples/libzbc-seq-read.fio   | 19 +++++++++++++++++++
 2 files changed, 39 insertions(+)
 create mode 100644 examples/libzbc-rand-write.fio
 create mode 100644 examples/libzbc-seq-read.fio

diff --git a/examples/libzbc-rand-write.fio b/examples/libzbc-rand-write.fio
new file mode 100644
index 00000000..6f299bb4
--- /dev/null
+++ b/examples/libzbc-rand-write.fio
@@ -0,0 +1,20 @@
+; Using the libzbc ioengine, random write to a (zoned) block device,
+; writing at most 32 zones at a time. Target zones are chosen randomly
+; and writes directed at the write pointer of the chosen zones
+
+[global]
+name=zbd-rand-write
+group_reporting
+rw=randwrite
+zonemode=zbd
+zonesize=256M
+max_open_zones=32
+bs=512K
+direct=1
+numjobs=16
+time_based=1
+runtime=300
+
+[dev1]
+filename=/dev/sdj
+ioengine=libzbc
diff --git a/examples/libzbc-seq-read.fio b/examples/libzbc-seq-read.fio
new file mode 100644
index 00000000..f4d265a0
--- /dev/null
+++ b/examples/libzbc-seq-read.fio
@@ -0,0 +1,19 @@
+; Using the libzbc ioengine, sequentially read 40 zones of a (zoned)
+; block device, reading only written data from the 524th zone
+; (524 * 256M = 140660178944)
+
+[global]
+name=libzbc-seq-read
+rw=read
+bs=1M
+direct=1
+numjobs=1
+zonemode=zbd
+zonesize=256M
+read_beyond_wp=0
+
+[dev1]
+filename=/dev/sdd
+offset=140660178944
+size=10G
+ioengine=libzbc
-- 
2.25.1


