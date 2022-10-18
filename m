Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C72C4332F
	for <fio@archiver.kernel.org>; Tue, 18 Oct 2022 04:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiJRERf (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Oct 2022 00:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiJRERc (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Oct 2022 00:17:32 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3199296221
        for <fio@vger.kernel.org>; Mon, 17 Oct 2022 21:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666066651; x=1697602651;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A+A+sb6FnZES4YlfGJkYzdAzbi/Mpyn2YEvGKv2KBF4=;
  b=Mq8Q4Q6Ki9kdnMbWfikMIVYrgxm7uc43UBtJVxzWKArX1WlEnLyBthcN
   riCQkGdAIefvpka/2bSIyOoUPapsZ9cjyqqjGVquI6tRTSod7WZugAl+Q
   SwFenjXN9PNWKlLmfKN4yyeG7GpADZQl7ekmQwY1vyWK3kak5B1K40RRN
   E0J2vbiJv2yFllvb8XlTfzAXOTpG/dbOvGe7CFfOdV1Hh8nJf7S/2OuwI
   WTB4p/1IfKIKy96AemBssXXxqcARPhFU0/AjMJ2uDXMbBCy/d1MOap6s1
   uenXwDOtrQjQUZVbrk01EhF5BHZ/cGz0oGP12sitpGC95fMhqgZ2x0Wzl
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,193,1661788800"; 
   d="scan'208";a="214084031"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Oct 2022 12:17:30 +0800
IronPort-SDR: alPI1Xn8I8O1Whp7VbktnTnY7O7AeRT1RSv2df6u4N8lL4Q0vaAPm5CZEzv8qt9XX+cyK46cYE
 oMvC4QLuEW6b5vovqZC0Vk6vWSJWdjTTGOwER29+n3jiu0HejagvSzLyKl+2J5I9kK3F85x+Aq
 yvGvzGlo/qMAYvtAvkrpXhr3+U4vLyglkAxD6v8S4Uvfef7WhsBg1nnkO+i3T9Z0UMQELa16k8
 9VTpj8RCLYtKmh6O8Vb0XvnGNZBHLzxIvy3+TVet7XxgsufgPc6qMj7bA1Dm+TbyAJj6sRs8nB
 Ui80QKwZqI+CC1D2ZfS/uW01
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Oct 2022 20:37:02 -0700
IronPort-SDR: WIunYQgYot+6cJsf5qlsPD2FdLE42CLpN/BdK626FS+Uqyu3yhp38ta/8vCT5iLEgIa2ng+f60
 frw5FULX7gj13iymSAQY9obECGiDNhleA0fMAWpQx/4IvcQM9OQ7bCnVscQPVb9OYPZgebfv5H
 kF14otI75i3IZZH9h1mxutumI3VsxTyac9NbzwUlUS+sPizfXXbFkscoqHt7w1fFNOYSZDYdjt
 VrCAijbf9SfdhSDzIJM49+GPUCROHBaT7h29CPO9VhhGTdksm+OFjHH4tmWFsCvI0WxSPjjIzd
 GKc=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 17 Oct 2022 21:17:30 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 3/4] test: add test for verify read back of experimental verify
Date:   Tue, 18 Oct 2022 13:17:24 +0900
Message-Id: <20221018041725.807940-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
References: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add a test case to confirm fix of bytes_done accounting issue of
experimental verify. The test job runs a simple workload with
experimental verify and confirm read amount is not zero.

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
index df87ae72..0e15068d 100755
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
+        if self.json_data['jobs'][0]['read']['io_kbytes'] == 0:
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

