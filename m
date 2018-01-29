Return-Path: <zhangweiping@didichuxing.com>
Date: Tue, 30 Jan 2018 00:45:53 +0800
From: weiping zhang <zhangweiping@didichuxing.com>
Subject: [RFC PATCH] doc: add comments for the difference between iodepth and
 blkdev's inflight
Message-ID: <20180129164548.GA7056@localhost.didichuxing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Return-Path: zhangweiping@didichuxing.com
To: axboe@kernel.dk
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

If user want control the inflight IOs for the tested block device, for
example set iodepth=16, and we can get result like following:

IO depths: 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%

this result only means (16~31) IOs inflight, don't means requests inflight,
if max_sectors_kb = 64KB, and we set bs=256KB, the number of inflight
requests may reach to 64(if nr_request allow). So for user want to control
the number of inflight requests, bs should less than max_sectors_kb.

Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
---
 fio.1 | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fio.1 b/fio.1
index 54d1b0f..b7f4466 100644
--- a/fio.1
+++ b/fio.1
@@ -1814,7 +1814,10 @@ engines may impose OS restrictions causing the desired depth not to be
 achieved. This may happen on Linux when using libaio and not setting
 `direct=1', since buffered I/O is not async on that OS. Keep an
 eye on the I/O depth distribution in the fio output to verify that the
-achieved depth is as expected. Default: 1.
+achieved depth is as expected. The iodepth is not same as block device's
+inflight. If you want control block device's inflight number by this parameter,
+you should make sure bs less than max_sectors_kb of that block device, otherwise
+bs will be splitted into multiple requests at block layer. Default: 1.
 .TP
 .BI iodepth_batch_submit \fR=\fPint "\fR,\fP iodepth_batch" \fR=\fPint
 This defines how many pieces of I/O to submit at once. It defaults to 1
-- 
2.9.4


