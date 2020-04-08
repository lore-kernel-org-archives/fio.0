Return-Path: <prvs=360af864b=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/3] examples: add zonemode=zbd example scripts
Date: Wed,  8 Apr 2020 15:46:59 +0900
Message-Id: <20200408064659.1621850-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Add two example script files (random write and sequential read)
illustrating the use of zonemode=zbd with the psync and libaio
ioengines.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 examples/zbd-rand-write.fio | 20 ++++++++++++++++++++
 examples/zbd-seq-read.fio   | 19 +++++++++++++++++++
 2 files changed, 39 insertions(+)
 create mode 100644 examples/zbd-rand-write.fio
 create mode 100644 examples/zbd-seq-read.fio

diff --git a/examples/zbd-rand-write.fio b/examples/zbd-rand-write.fio
new file mode 100644
index 00000000..1b3f2088
--- /dev/null
+++ b/examples/zbd-rand-write.fio
@@ -0,0 +1,20 @@
+; Using the libaio ioengine, random write to a (zoned) block device,
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
+runtime=180
+
+[dev1]
+filename=/dev/sdj
+ioengine=psync
diff --git a/examples/zbd-seq-read.fio b/examples/zbd-seq-read.fio
new file mode 100644
index 00000000..82f2b1db
--- /dev/null
+++ b/examples/zbd-seq-read.fio
@@ -0,0 +1,19 @@
+; Sequentially read 40 zones of a (zoned) block device, reading only
+; written data from the 524th zone (524 * 256M = 140660178944)
+
+[global]
+name=zbd-seq-read
+rw=read
+bs=256K
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
+ioengine=libaio
+iodepth=16
-- 
2.25.1


