Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77411C43217
	for <fio@archiver.kernel.org>; Fri, 18 Nov 2022 23:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbiKRX2p (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 18 Nov 2022 18:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235729AbiKRX2M (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Nov 2022 18:28:12 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622E7C050E
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 15:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=P23pSFUMqQzXGoMBvRg/QxDGb4sZJGujlQp1hZZEtJQ=; b=ag4FOtaiL7MunHCsl8OdqyIphm
        RijqNDw6DRFHZVt5GX/uzyg9M1dYPa6X9LQLJ27a8CaumRIyJOK1uRa7QC/jIVtJhOP05my1mEwxW
        oYAr3BjfctcCElJLTKnOvMBspI6LzlE9FOAF8FdXw/18KlDaJ5uWyk56dgEzuT/oe12Eo68/75QHp
        gqu96M5xzhOjZPtRslJwJCzd03N/hKorrfbr2o9OCMfpKJZ4PslsbIOOGe34bd/BmvsTlN5eTCqJj
        riHfPiGVBLnN6TQtUtiEkUY5hgZE/ludYNkL1oAil4BXger66WHNI8al6UV5Sn0UgRta/xV1/qN0S
        x0rv+bfA==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1owAab-005chr-Ik; Fri, 18 Nov 2022 16:16:06 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1owAaZ-000MLd-DO; Fri, 18 Nov 2022 16:16:03 -0700
From:   Logan Gunthorpe <logang@deltatee.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Fri, 18 Nov 2022 16:16:01 -0700
Message-Id: <20221118231601.85837-7-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221118231601.85837-1-logang@deltatee.com>
References: <20221118231601.85837-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v3 6/6] test: add large pattern test
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add a test which writes a file with a 16KB buffer pattern, then
verify the file with the same pattern.

The test writes a single 16KB block and thus should be the same as
the patttern file. Verify that this is the case after the test is
run.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 t/jobs/t0027.fio   | 14 ++++++++++++++
 t/run-fio-tests.py | 29 +++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)
 create mode 100644 t/jobs/t0027.fio

diff --git a/t/jobs/t0027.fio b/t/jobs/t0027.fio
new file mode 100644
index 000000000000..b5b97a30d3d7
--- /dev/null
+++ b/t/jobs/t0027.fio
@@ -0,0 +1,14 @@
+[global]
+filename=t0027file
+size=16k
+bs=16k
+
+[write_job]
+readwrite=write
+buffer_pattern='t0027.pattern'
+
+[read_job]
+stonewall=1
+readwrite=read
+verify=pattern
+verify_pattern='t0027.pattern'
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index e5b307ac0db8..a06f812683cb 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -799,6 +799,26 @@ class FioJobTest_t0025(FioJobTest):
         if self.json_data['jobs'][0]['read']['io_kbytes'] != 128:
             self.passed = False
 
+class FioJobTest_t0027(FioJobTest):
+    def setup(self, *args, **kws):
+        super(FioJobTest_t0027, self).setup(*args, **kws)
+        self.pattern_file = os.path.join(self.test_dir, "t0027.pattern")
+        self.output_file = os.path.join(self.test_dir, "t0027file")
+        self.pattern = os.urandom(16 << 10)
+        with open(self.pattern_file, "wb") as f:
+            f.write(self.pattern)
+
+    def check_result(self):
+        super(FioJobTest_t0027, self).check_result()
+
+        if not self.passed:
+            return
+
+        with open(self.output_file, "rb") as f:
+            data = f.read()
+
+        if data != self.pattern:
+            self.passed = False
 
 class FioJobTest_iops_rate(FioJobTest):
     """Test consists of fio test job t0009
@@ -1214,6 +1234,15 @@ TEST_LIST = [
         'pre_success':      None,
         'requirements':     [Requirements.not_windows],
     },
+    {
+        'test_id':          27,
+        'test_class':       FioJobTest_t0027,
+        'job':              't0027.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
-- 
2.30.2

