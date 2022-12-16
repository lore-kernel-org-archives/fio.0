Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83A5C4332F
	for <fio@archiver.kernel.org>; Fri, 16 Dec 2022 13:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiLPNAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 16 Dec 2022 08:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiLPNAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 16 Dec 2022 08:00:09 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D5752177
        for <fio@vger.kernel.org>; Fri, 16 Dec 2022 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=26lrG5nxAf8GHz6HPVuBhL7OhwBhTFGdoJA1OGOhRDQ=; b=BqqR/pGOd8Am5BMQi6g8R3Iojj
        tNgvEB4RF6ysCpTFxSqsxR/WqisiIPAOZ+5F9ax/q/9VIyQUcWhsrwH4FW+EF5dlwdtwU69VZ3APr
        KHMQo0i7oYDpkrW+j8pysL/1I0Mjf9Itz9f2id/xQiZ4rBoeg5NIM8QaYkntSDtijpcrjD046wkGJ
        wtURh5AAxRaROadx0J19wr8oJqWDEmeZ7CMsr6s0TdSTpxmmjdQShCr+o75KL9l/7mO5NUq/86YYn
        siTo2UT3VDG2D3xVnn4mKBsmCJlp33cq0C4WhkCCz4qbBYtRswTSLYwsvGoHQ/Fn50ARb5CrfKK0X
        2XuGvtmw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p6AJp-00BATC-6l
        for fio@vger.kernel.org; Fri, 16 Dec 2022 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id D95C51BC0130; Fri, 16 Dec 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221216130001.D95C51BC0130@kernel.dk>
Date:   Fri, 16 Dec 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 70eb71e682b90078db6f361936933b88f71ad5fd:

  t/io_uring: adjust IORING_REGISTER_MAP_BUFFERS value (2022-12-12 16:58:32 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a5000c864aa8e7b5525f51fa6fecec75c518b013:

  example: add a zoned block device write example with GC by trim workload (2022-12-15 12:42:12 -0700)

----------------------------------------------------------------
Shin'ichiro Kawasaki (4):
      man: fix troff warning
      HOWTO/man: improve descriptions of max open zones options
      example: add a zoned block device write example with GC by zone resets
      example: add a zoned block device write example with GC by trim workload

 HOWTO.rst                                 |  27 ++++++++++++++-----
 examples/zbd-rand-write-trim-gc.fio       |  43 ++++++++++++++++++++++++++++++
 examples/zbd-rand-write-trim-gc.png       | Bin 0 -> 104661 bytes
 examples/zbd-rand-write-zone-reset-gc.fio |  27 +++++++++++++++++++
 examples/zbd-rand-write-zone-reset-gc.png | Bin 0 -> 59186 bytes
 fio.1                                     |  25 ++++++++++++-----
 6 files changed, 108 insertions(+), 14 deletions(-)
 create mode 100644 examples/zbd-rand-write-trim-gc.fio
 create mode 100644 examples/zbd-rand-write-trim-gc.png
 create mode 100644 examples/zbd-rand-write-zone-reset-gc.fio
 create mode 100644 examples/zbd-rand-write-zone-reset-gc.png

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 5a5263c3..97fe5350 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1052,16 +1052,29 @@ Target file/device
 
 .. option:: max_open_zones=int
 
-	When running a random write test across an entire drive many more
-	zones will be open than in a typical application workload. Hence this
-	command line option that allows one to limit the number of open zones. The
-	number of open zones is defined as the number of zones to which write
-	commands are issued.
+	A zone of a zoned block device is in the open state when it is partially
+	written (i.e. not all sectors of the zone have been written). Zoned
+	block devices may have a limit on the total number of zones that can
+	be simultaneously in the open state, that is, the number of zones that
+	can be written to simultaneously. The :option:`max_open_zones` parameter
+	limits the number of zones to which write commands are issued by all fio
+	jobs, that is, limits the number of zones that will be in the open
+	state. This parameter is relevant only if the :option:`zonemode` =zbd is
+	used. The default value is always equal to maximum number of open zones
+	of the target zoned block device and a value higher than this limit
+	cannot be specified by users unless the option
+	:option:`ignore_zone_limits` is specified. When
+	:option:`ignore_zone_limits` is specified or the target device has no
+	limit on the number of zones that can be in an open state,
+	:option:`max_open_zones` can specify 0 to disable any limit on the
+	number of zones that can be simultaneously written to by all jobs.
 
 .. option:: job_max_open_zones=int
 
-	Limit on the number of simultaneously opened zones per single
-	thread/process.
+	In the same manner as :option:`max_open_zones`, limit the number of open
+	zones per fio job, that is, the number of zones that a single job can
+	simultaneously write to. A value of zero indicates no limit.
+	Default: zero.
 
 .. option:: ignore_zone_limits=bool
 
diff --git a/examples/zbd-rand-write-trim-gc.fio b/examples/zbd-rand-write-trim-gc.fio
new file mode 100644
index 00000000..139d2c43
--- /dev/null
+++ b/examples/zbd-rand-write-trim-gc.fio
@@ -0,0 +1,43 @@
+; Using the libaio ioengine, random write to a (zoned) block device. Write
+; target zones are chosen randomly among the first 128 zones starting from
+; device offset corresponding to the 524th zone of the device (524 x 256 MB).
+; For first 3 seconds, run only random write. After that, run random write job
+; and garbage collection simulation job in parallel. The garbage collection
+; simulation job runs trim workload to reset the 128 zones randomly. Use flow
+; option to make the zone resets happen every 128 blocks writes by the other
+; job. This example does not specify max_open_zones. The limit of maximum
+; open zones is obtained from the target block device.
+
+[global]
+group_reporting
+zonemode=zbd
+zonesize=256M
+direct=1
+time_based
+runtime=30
+
+filename=/dev/sdb
+offset=524z
+
+[warmup]
+rw=randwrite
+bs=2M
+size=128z
+ioengine=libaio
+runtime=3
+
+[wjob]
+wait_for=warmup
+rw=randwrite
+bs=2M
+size=128z
+ioengine=libaio
+flow=128
+
+[trimjob]
+wait_for=warmup
+rw=randtrim
+bs=256M
+size=128z
+ioengine=psync
+flow=1
diff --git a/examples/zbd-rand-write-trim-gc.png b/examples/zbd-rand-write-trim-gc.png
new file mode 100644
index 00000000..f58dd412
Binary files /dev/null and b/examples/zbd-rand-write-trim-gc.png differ
diff --git a/examples/zbd-rand-write-zone-reset-gc.fio b/examples/zbd-rand-write-zone-reset-gc.fio
new file mode 100644
index 00000000..8f77baf3
--- /dev/null
+++ b/examples/zbd-rand-write-zone-reset-gc.fio
@@ -0,0 +1,27 @@
+; Using the psync ioengine, random write to a (zoned) block device. Write
+; target zones are chosen randomly among the first 8 zones starting from device
+; offset corresponding to the 524th zone of the device (524 x 256 MB). Simulate
+; garbage collection operation using zone_reset_threshold and
+; zone_reset_frequency options. The zone resets happen when total written data
+; bytes is beyond 70% of 8 zones, and 8 = 1 / 0.125 blocks are written. This
+; example does not specify max_open_zones. The limit of maximum open zones is
+; obtained from the target block device.
+
+[global]
+name=zbd-rand-write-gc
+group_reporting
+rw=randwrite
+zonemode=zbd
+zonesize=256M
+bs=32M
+direct=1
+time_based
+runtime=40
+
+[dev1]
+filename=/dev/sdb
+size=8z
+offset=524z
+ioengine=psync
+zone_reset_threshold=0.7
+zone_reset_frequency=0.125
diff --git a/examples/zbd-rand-write-zone-reset-gc.png b/examples/zbd-rand-write-zone-reset-gc.png
new file mode 100644
index 00000000..b10acc80
Binary files /dev/null and b/examples/zbd-rand-write-zone-reset-gc.png differ
diff --git a/fio.1 b/fio.1
index 7a153731..1074b52a 100644
--- a/fio.1
+++ b/fio.1
@@ -828,14 +828,25 @@ numbers fio only reads beyond the write pointer if explicitly told to do
 so. Default: false.
 .TP
 .BI max_open_zones \fR=\fPint
-When running a random write test across an entire drive many more zones will be
-open than in a typical application workload. Hence this command line option
-that allows one to limit the number of open zones. The number of open zones is
-defined as the number of zones to which write commands are issued by all
-threads/processes.
+A zone of a zoned block device is in the open state when it is partially written
+(i.e. not all sectors of the zone have been written). Zoned block devices may
+have limit a on the total number of zones that can be simultaneously in the
+open state, that is, the number of zones that can be written to simultaneously.
+The \fBmax_open_zones\fR parameter limits the number of zones to which write
+commands are issued by all fio jobs, that is, limits the number of zones that
+will be in the open state. This parameter is relevant only if the
+\fBzonemode=zbd\fR is used. The default value is always equal to maximum number
+of open zones of the target zoned block device and a value higher than this
+limit cannot be specified by users unless the option \fBignore_zone_limits\fR is
+specified. When \fBignore_zone_limits\fR is specified or the target device has
+no limit on the number of zones that can be in an open state,
+\fBmax_open_zones\fR can specify 0 to disable any limit on the number of zones
+that can be simultaneously written to by all jobs.
 .TP
 .BI job_max_open_zones \fR=\fPint
-Limit on the number of simultaneously opened zones per single thread/process.
+In the same manner as \fBmax_open_zones\fR, limit the number of open zones per
+fio job, that is, the number of zones that a single job can simultaneously write
+to. A value of zero indicates no limit. Default: zero.
 .TP
 .BI ignore_zone_limits \fR=\fPbool
 If this option is used, fio will ignore the maximum number of open zones limit
@@ -2544,7 +2555,7 @@ replaced by the name of the job
 .BI (exec)grace_time\fR=\fPint
 Defines the time between the SIGTERM and SIGKILL signals. Default is 1 second.
 .TP
-.BI (exec)std_redirect\fR=\fbool
+.BI (exec)std_redirect\fR=\fPbool
 If set, stdout and stderr streams are redirected to files named from the job name. Default is true.
 .TP
 .BI (xnvme)xnvme_async\fR=\fPstr
