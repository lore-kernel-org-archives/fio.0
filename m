Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8F5C4332F
	for <fio@archiver.kernel.org>; Thu, 20 Oct 2022 06:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiJTGjI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 20 Oct 2022 02:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiJTGjH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Oct 2022 02:39:07 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDA81C25D6
        for <fio@vger.kernel.org>; Wed, 19 Oct 2022 23:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666247941; x=1697783941;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ucCl0wLFmJiM/uGAfkzSYX1iGnddcKOU8vjjZKCdAwM=;
  b=ieDrVH5T1WbNkJLRIkzE2gHNmkHS/90pNSKXdyAmYc4uvP/9wk6yEvXx
   0eP3jvLhEi6UzvNBZGH2VH0/a622Zzf+2X2qZQdBTZ/aCnNJldZNxQ9lP
   YTvJc/BMmL0H3JL5RlPaYxDxPK8M2KQN4wEymSl5E8mSEDmUZLmzlZQoI
   eD1FLWKaQmvEL6PRbIGdC7eHLH9Cxr6TCvrc3+E0FZvZfkVZNkAQ/S6jA
   PQQTomZ7fyjF/GTDlhLcURQhgy/oPsydzSDRMb9kj+ZVJS/553YSplwZj
   +4HwXuceKRYRso/TQoDNh96HuNZS5h4iZm1XDmQLB/1zuKb6af28dx/Xu
   A==;
X-IronPort-AV: E=Sophos;i="5.95,198,1661788800"; 
   d="scan'208";a="212615963"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Oct 2022 14:39:00 +0800
IronPort-SDR: ldte/T6XUE3CSaIp9w/fpOG18KN7wpdQUAgebe8NBGLC8vvra5+HLSOPEIKlo9Wsh1kb8Xe4+F
 U25kfyHT2wnMJTMlhPS9VBwh8O/fAi7bq9I9BPd8oAOiEEKf9QBIYwNBbworu1WzFBEVu2vMAf
 5i6vuMKzisSPd6nD2AisoVWmZQz8PVnZEHAUZ9tibH3Pyk7LI9EsvBcHw/8GS5UahfFzL53f0E
 l0NilwFHX4lt/zslnyzVud+FrMaYgaVvHt7G1O3RnG6rsly8xNadhT6jXf0cKrZnsYvuzM4k65
 wKXiFmMqdXL0TUTx6kaVStak
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Oct 2022 22:58:29 -0700
IronPort-SDR: MUBnKmZF4OSkPb8Qfo9SYK+tQLhKvH9rAse8RcckIoRZbpetPVisfLIKOC7+e/tjorvrGnXxe5
 nJGBUw2Qmbhv/0fo0vzZGxFRL/cNJAVHt0IpRsX2hf0A41p7KCO9c2fnJ9IV+J5ElYa2jcBwzI
 1WWdjr1hnMEcYOyenN7Pa6ymJCGWr/ARupCONZ2opwSUqF0APTrAjy1g7WHEwFo+U9r6FaOfMF
 3sxkjVPK3DWaDMuNCEkxaYkKWAkI8MXfNjUw0BL37km+Dt9Gnw94mswDNw9iAiQPU9ak5pPJ7e
 xLI=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 19 Oct 2022 23:39:00 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 3/4] test: add test for verify read back of experimental verify
Date:   Thu, 20 Oct 2022 15:38:53 +0900
Message-Id: <20221020063854.839158-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221020063854.839158-1-shinichiro.kawasaki@wdc.com>
References: <20221020063854.839158-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add a test case to confirm fix of bytes_done accounting issue of
experimental verify. The test job runs a simple workload with
experimental verify and confirm verify read amount is the file size.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/jobs/t0025.fio   |  8 ++++++++
 t/run-fio-tests.py | 22 ++++++++++++++++++++++
 2 files changed, 30 insertions(+)
 create mode 100644 t/jobs/t0025.fio

diff --git a/t/jobs/t0025.fio b/t/jobs/t0025.fio
new file mode 100644
index 00000000..2b35a9ac
--- /dev/null
+++ b/t/jobs/t0025.fio
@@ -0,0 +1,8 @@
+[job]
+filename=t0025file
+size=128k
+readwrite=write
+do_verify=1
+verify=md5
+experimental_verify=1
+
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index df87ae72..439991a1 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -788,6 +788,18 @@ class FioJobTest_t0024(FioJobTest_t0023):
         self.check_all_offsets("bssplit_bw.log", 512, filesize)
 
 
+class FioJobTest_t0025(FioJobTest):
+    """Test experimental verify read backs written data pattern."""
+    def check_result(self):
+        super(FioJobTest_t0025, self).check_result()
+
+        if not self.passed:
+            return
+
+        if self.json_data['jobs'][0]['read']['io_kbytes'] != 128:
+            self.passed = False
+
+
 class FioJobTest_iops_rate(FioJobTest):
     """Test consists of fio test job t0009
     Confirm that job0 iops == 1000
@@ -1183,6 +1195,16 @@ TEST_LIST = [
         'pre_success':      None,
         'requirements':     [],
     },
+    {
+        'test_id':          25,
+        'test_class':       FioJobTest_t0025,
+        'job':              't0025.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
-- 
2.37.1

