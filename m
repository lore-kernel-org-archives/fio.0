Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83844C4332F
	for <fio@archiver.kernel.org>; Sat, 17 Dec 2022 13:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiLQNAM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 17 Dec 2022 08:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLQNAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 17 Dec 2022 08:00:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F75E15F30
        for <fio@vger.kernel.org>; Sat, 17 Dec 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=MuRRnI57Zzda9GhIE1es88m3el3FGe4Izx12L1qrHsY=; b=XQjrqXR4/M32X3qEx60sw1kKVr
        c7iui/HnpLnRBgF+2Fz596v2+qhN3Mizii3aWUvVyv7gEQp1U8MKE7V7pT1W5BWGCagxB44Di3CVi
        KkuoBi+kudVMaRoyuYyecF5LC/PyRtjFUmRFXp9YMPMt8p6ZeEq1xZtD5Mjn/8troPqyuAVyeCU04
        PBQJNafG6+ePLl1JdqdOwENA5ca/SC4s6XSwRcFRuXf3p8vQLTMlvGIrSFEikmXk1Mf4CZnF68abx
        S2RnlWwpc2dP81LDkbZ81407lFtbHCXA9QBHTU4RtwGv7vyo9cb50OkLzu791ZGBVykT604XsWcaS
        u/N24z3Q==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p6WnW-00GYvq-2Q
        for fio@vger.kernel.org; Sat, 17 Dec 2022 13:00:14 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 128401BC0126; Sat, 17 Dec 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221217130002.128401BC0126@kernel.dk>
Date:   Sat, 17 Dec 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit a5000c864aa8e7b5525f51fa6fecec75c518b013:

  example: add a zoned block device write example with GC by trim workload (2022-12-15 12:42:12 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 77c758db876d93022e8f2bb4fd4c1acbbf7e76ac:

  t/run-fio-tests: relax acceptance criteria for t0008 (2022-12-16 19:35:07 +0000)

----------------------------------------------------------------
Vincent Fu (3):
      tools/fiograph: update config file
      examples: add missing fiograph diagrams
      t/run-fio-tests: relax acceptance criteria for t0008

 examples/dedupe-global.png                | Bin 0 -> 55479 bytes
 examples/http-s3-crypto.png               | Bin 0 -> 131254 bytes
 examples/http-s3-storage-class.png        | Bin 0 -> 123771 bytes
 examples/libblkio-io_uring.png            | Bin 0 -> 57227 bytes
 examples/libblkio-virtio-blk-vfio-pci.png | Bin 0 -> 62398 bytes
 examples/sg_verify-fail.png               | Bin 0 -> 107581 bytes
 examples/sg_verify.png                    | Bin 0 -> 161969 bytes
 examples/uring-cmd-ng.png                 | Bin 0 -> 83761 bytes
 examples/uring-cmd-zoned.png              | Bin 0 -> 98231 bytes
 examples/xnvme-compare.png                | Bin 0 -> 44742 bytes
 examples/xnvme-zoned.png                  | Bin 0 -> 48340 bytes
 t/run-fio-tests.py                        |  13 ++++++++-----
 tools/fiograph/fiograph.conf              |  13 +++++++++++--
 13 files changed, 19 insertions(+), 7 deletions(-)
 create mode 100644 examples/dedupe-global.png
 create mode 100644 examples/http-s3-crypto.png
 create mode 100644 examples/http-s3-storage-class.png
 create mode 100644 examples/libblkio-io_uring.png
 create mode 100644 examples/libblkio-virtio-blk-vfio-pci.png
 create mode 100644 examples/sg_verify-fail.png
 create mode 100644 examples/sg_verify.png
 create mode 100644 examples/uring-cmd-ng.png
 create mode 100644 examples/uring-cmd-zoned.png
 create mode 100644 examples/xnvme-compare.png
 create mode 100644 examples/xnvme-zoned.png

---

Diff of recent changes:

diff --git a/examples/dedupe-global.png b/examples/dedupe-global.png
new file mode 100644
index 00000000..fd4602e3
Binary files /dev/null and b/examples/dedupe-global.png differ
diff --git a/examples/http-s3-crypto.png b/examples/http-s3-crypto.png
new file mode 100644
index 00000000..b452cf45
Binary files /dev/null and b/examples/http-s3-crypto.png differ
diff --git a/examples/http-s3-storage-class.png b/examples/http-s3-storage-class.png
new file mode 100644
index 00000000..b893a4eb
Binary files /dev/null and b/examples/http-s3-storage-class.png differ
diff --git a/examples/libblkio-io_uring.png b/examples/libblkio-io_uring.png
new file mode 100644
index 00000000..1bc6cc98
Binary files /dev/null and b/examples/libblkio-io_uring.png differ
diff --git a/examples/libblkio-virtio-blk-vfio-pci.png b/examples/libblkio-virtio-blk-vfio-pci.png
new file mode 100644
index 00000000..8a670cc2
Binary files /dev/null and b/examples/libblkio-virtio-blk-vfio-pci.png differ
diff --git a/examples/sg_verify-fail.png b/examples/sg_verify-fail.png
new file mode 100644
index 00000000..516e2d40
Binary files /dev/null and b/examples/sg_verify-fail.png differ
diff --git a/examples/sg_verify.png b/examples/sg_verify.png
new file mode 100644
index 00000000..f244a748
Binary files /dev/null and b/examples/sg_verify.png differ
diff --git a/examples/uring-cmd-ng.png b/examples/uring-cmd-ng.png
new file mode 100644
index 00000000..cd2ff162
Binary files /dev/null and b/examples/uring-cmd-ng.png differ
diff --git a/examples/uring-cmd-zoned.png b/examples/uring-cmd-zoned.png
new file mode 100644
index 00000000..a3dd199d
Binary files /dev/null and b/examples/uring-cmd-zoned.png differ
diff --git a/examples/xnvme-compare.png b/examples/xnvme-compare.png
new file mode 100644
index 00000000..2af92f62
Binary files /dev/null and b/examples/xnvme-compare.png differ
diff --git a/examples/xnvme-zoned.png b/examples/xnvme-zoned.png
new file mode 100644
index 00000000..2f850740
Binary files /dev/null and b/examples/xnvme-zoned.png differ
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index a06f8126..70ff4371 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -387,10 +387,13 @@ class FioJobTest_t0007(FioJobTest):
 class FioJobTest_t0008(FioJobTest):
     """Test consists of fio test job t0008
     Confirm that read['io_kbytes'] = 32768 and that
-                write['io_kbytes'] ~ 16568
+                write['io_kbytes'] ~ 16384
 
-    I did runs with fio-ae2fafc8 and saw write['io_kbytes'] values of
-    16585, 16588. With two runs of fio-3.16 I obtained 16568"""
+    This is a 50/50 seq read/write workload. Since fio flips a coin to
+    determine whether to issue a read or a write, total bytes written will not
+    be exactly 16384K. But total bytes read will be exactly 32768K because
+    reads will include the initial phase as well as the verify phase where all
+    the blocks originally written will be read."""
 
     def check_result(self):
         super(FioJobTest_t0008, self).check_result()
@@ -398,10 +401,10 @@ class FioJobTest_t0008(FioJobTest):
         if not self.passed:
             return
 
-        ratio = self.json_data['jobs'][0]['write']['io_kbytes'] / 16568
+        ratio = self.json_data['jobs'][0]['write']['io_kbytes'] / 16384
         logging.debug("Test %d: ratio: %f", self.testnum, ratio)
 
-        if ratio < 0.99 or ratio > 1.01:
+        if ratio < 0.97 or ratio > 1.03:
             self.failure_reason = "{0} bytes written mismatch,".format(self.failure_reason)
             self.passed = False
         if self.json_data['jobs'][0]['read']['io_kbytes'] != 32768:
diff --git a/tools/fiograph/fiograph.conf b/tools/fiograph/fiograph.conf
index cfd2fd8e..91c5fcfe 100644
--- a/tools/fiograph/fiograph.conf
+++ b/tools/fiograph/fiograph.conf
@@ -45,7 +45,7 @@ specific_options=stat_type
 specific_options=volume  brick
 
 [ioengine_http]
-specific_options=https  http_host  http_user  http_pass  http_s3_key  http_s3_keyid  http_swift_auth_token  http_s3_region  http_mode  http_verbose
+specific_options=https  http_host  http_user  http_pass  http_s3_key  http_s3_keyid  http_swift_auth_token  http_s3_region  http_mode  http_verbose  http_s3_storage_class  http_s3_sse_customer_key  http_s3_sse_customer_algorithm
 
 [ioengine_ime_aio]
 specific_options=ime_psync  ime_psyncv
@@ -53,9 +53,15 @@ specific_options=ime_psync  ime_psyncv
 [ioengine_io_uring]
 specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async
 
+[ioengine_io_uring_cmd]
+specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async  cmd_type
+
 [ioengine_libaio]
 specific_options=userspace_reap  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  nowait
 
+[ioengine_libblkio]
+specific_options=libblkio_driver  libblkio_path  libblkio_pre_connect_props  libblkio_num_entries  libblkio_queue_size  libblkio_pre_start_props  hipri  libblkio_vectored  libblkio_write_zeroes_on_trim  libblkio_wait_mode  libblkio_force_enable_completion_eventfd
+
 [ioengine_libcufile]
 specific_options=gpu_dev_ids  cuda_io
 
@@ -99,7 +105,10 @@ specific_options=clustername  rbdname  pool  clientname  busy_poll
 specific_options=hostname  bindname  port  verb
 
 [ioengine_sg]
-specific_options=hipri  readfua  writefua  sg_write_mode  sg
+specific_options=hipri  readfua  writefua  sg_write_mode  stream_id
 
 [ioengine_pvsync2]
 specific_options=hipri  hipri_percentage  uncached  nowait  sync  psync  vsync  pvsync
+
+[ioengine_xnvme]
+specific_options=hipri  sqthread_poll  xnvme_be  xnvme_async  xnvme_sync  xnvme_admin  xnvme_dev_nsid  xnvme_iovec
