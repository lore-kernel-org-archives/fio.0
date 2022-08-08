Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C15C00140
	for <fio@archiver.kernel.org>; Mon,  8 Aug 2022 12:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbiHHMAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 8 Aug 2022 08:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbiHHMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Aug 2022 08:00:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2602D25C7
        for <fio@vger.kernel.org>; Mon,  8 Aug 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Q0cMT8h9bUqHsKaCyFku1zOf4xS7uHVlS50N2GRWxbc=; b=nQvlvBvACb+lYfJwUOErN9f/Fo
        brnhpoR+W9SFvq2hO48CaPuE9WwdPoVRCPCjz93p+UvdYRKoiskJ4lVEVUT7fADcImTVJWoOYKfcg
        YsDPqrwS/bkZl5gPJcwo5a3v7GBRYi4vjzThTB7igiAHScpQKVo3vFVx/5lJJSmQ8d9M1sZPvgnuA
        Ck9pXdkc8X7bn4RRhhBvkKPFIYda1SZZ35z3em0Gmam96JwexaA/bISkuwTpqddha91hE1VuLbscH
        gu1uL1nzfQJbxs/OVsVf2Q2G9l+dK0JWtRZhxZmihianIWQqkOg+aC1uftuaWIAw4ULiT6nJekiNW
        v1wRAXyg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oL1QS-00DtDL-QU
        for fio@vger.kernel.org; Mon, 08 Aug 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 145581BC014F; Mon,  8 Aug 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220808120002.145581BC014F@kernel.dk>
Date:   Mon,  8 Aug 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c08f9533042e909d4b4b12fdb8d14f1bc8e23dff:

  filesetup: use correct random seed for non-uniform distributions (2022-08-03 16:18:53 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to de31fe9ab3dd6115cd0d5c77354f67f06595570d:

  testing: add test for slat + clat = tlat (2022-08-07 12:27:55 -0400)

----------------------------------------------------------------
Vincent Fu (3):
      testing: add test for slat + clat = tlat
      engines/null: add FIO_ASYNCIO_SETS_ISSUE_TIME flag
      testing: add test for slat + clat = tlat

 engines/null.c            |  2 ++
 t/jobs/t0015-e78980ff.fio |  7 +++++++
 t/jobs/t0016-259ebc00.fio |  7 +++++++
 t/run-fio-tests.py        | 41 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 57 insertions(+)
 create mode 100644 t/jobs/t0015-e78980ff.fio
 create mode 100644 t/jobs/t0016-259ebc00.fio

---

Diff of recent changes:

diff --git a/engines/null.c b/engines/null.c
index 2df56718..68759c26 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -113,9 +113,11 @@ static struct null_data *null_init(struct thread_data *td)
 	if (td->o.iodepth != 1) {
 		nd->io_us = (struct io_u **) malloc(td->o.iodepth * sizeof(struct io_u *));
 		memset(nd->io_us, 0, td->o.iodepth * sizeof(struct io_u *));
+		td->io_ops->flags |= FIO_ASYNCIO_SETS_ISSUE_TIME;
 	} else
 		td->io_ops->flags |= FIO_SYNCIO;
 
+	td_set_ioengine_flags(td);
 	return nd;
 }
 
diff --git a/t/jobs/t0015-e78980ff.fio b/t/jobs/t0015-e78980ff.fio
new file mode 100644
index 00000000..c650c0b2
--- /dev/null
+++ b/t/jobs/t0015-e78980ff.fio
@@ -0,0 +1,7 @@
+# Expected result: mean(slat) + mean(clat) = mean(lat)
+# Buggy result: equality does not hold
+
+[test]
+ioengine=libaio
+size=1M
+iodepth=16
diff --git a/t/jobs/t0016-259ebc00.fio b/t/jobs/t0016-259ebc00.fio
new file mode 100644
index 00000000..1b418e7c
--- /dev/null
+++ b/t/jobs/t0016-259ebc00.fio
@@ -0,0 +1,7 @@
+# Expected result: mean(slat) + mean(clat) = mean(lat)
+# Buggy result: equality does not hold
+
+[test]
+ioengine=null
+size=1M
+iodepth=16
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 32cdbc19..d77f20e0 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -527,6 +527,27 @@ class FioJobTest_t0014(FioJobTest):
             return
 
 
+class FioJobTest_t0015(FioJobTest):
+    """Test consists of fio test jobs t0015 and t0016
+    Confirm that mean(slat) + mean(clat) = mean(tlat)"""
+
+    def check_result(self):
+        super(FioJobTest_t0015, self).check_result()
+
+        if not self.passed:
+            return
+
+        slat = self.json_data['jobs'][0]['read']['slat_ns']['mean']
+        clat = self.json_data['jobs'][0]['read']['clat_ns']['mean']
+        tlat = self.json_data['jobs'][0]['read']['lat_ns']['mean']
+        logging.debug('Test %d: slat %f, clat %f, tlat %f', self.testnum, slat, clat, tlat)
+
+        if abs(slat + clat - tlat) > 1:
+            self.failure_reason = "{0} slat {1} + clat {2} = {3} != tlat {4},".format(
+                self.failure_reason, slat, clat, slat+clat, tlat)
+            self.passed = False
+
+
 class FioJobTest_iops_rate(FioJobTest):
     """Test consists of fio test job t0009
     Confirm that job0 iops == 1000
@@ -816,6 +837,26 @@ TEST_LIST = [
         'output_format':    'json',
         'requirements':     [],
     },
+    {
+        'test_id':          15,
+        'test_class':       FioJobTest_t0015,
+        'job':              't0015-e78980ff.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [Requirements.linux, Requirements.libaio],
+    },
+    {
+        'test_id':          16,
+        'test_class':       FioJobTest_t0015,
+        'job':              't0016-259ebc00.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
