Return-Path: <dehrenberg@google.com>
Return-Path: <dehrenberg@google.com>
Sender: Daniel Ehrenberg <dehrenberg@google.com>
From: Dan Ehrenberg <dehrenberg@chromium.org>
Subject: [PATCH v2 7/7] mtd: example job file
Date: Wed, 15 Apr 2015 10:41:35 -0700
Message-Id: <1429119695-22425-8-git-send-email-dehrenberg@chromium.org>
In-Reply-To: <1429119695-22425-1-git-send-email-dehrenberg@chromium.org>
References: <1429119695-22425-1-git-send-email-dehrenberg@chromium.org>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: gwendal@chromium.org, Dan Ehrenberg <dehrenberg@chromium.org>
List-ID: <fio@vger.kernel.org>

This job file shows how one can write sequentially to an MTD device,
erase (with trim), and do a looped write/trim workload. Ignoring EIO
errors allows operations to continue as bad blocks are skipped.
The block histogram counts P/E cycles and can be used to assess
NAND flash lifetime and failure characteristics. This job file is
written to work with the nandsim fake NAND device.

Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>
---
 examples/mtd.fio | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 examples/mtd.fio

diff --git a/examples/mtd.fio b/examples/mtd.fio
new file mode 100644
index 0000000..e5dcea4
--- /dev/null
+++ b/examples/mtd.fio
@@ -0,0 +1,21 @@
+[global]
+gtod_reduce=1
+filename=/dev/mtd0
+ioengine=mtd
+ignore_error=,EIO
+blocksize=512,512,16384
+skip_bad=1
+
+[write]
+stonewall
+rw=trim
+
+[write]
+stonewall
+rw=write
+
+[write]
+stonewall
+block_error_percentiles=1
+rw=trimwrite
+loops=4
-- 
2.2.0.rc0.207.ga3a616c


