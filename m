Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F790C433FE
	for <fio@archiver.kernel.org>; Thu, 20 Oct 2022 06:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbiJTGjJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 20 Oct 2022 02:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiJTGjH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Oct 2022 02:39:07 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF971911F6
        for <fio@vger.kernel.org>; Wed, 19 Oct 2022 23:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666247942; x=1697783942;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rEZDmwB5AAeXTZY9DJzKVu9Bfm6ZNoR8rwi8EH+0H2E=;
  b=n3a6KwhOtZ89CjR7MLZ86MHmZ9WLzRmHkdbRmDr89Y5Ausfhhk5BONl0
   DeFShrsR7GlaG6AYWJBybDEnC1cUCz2X+tHCAsDEa9NcJwOnoNdtZ93zu
   r0ytXq+/dDFnS5v/iIKAc52XqY4H7IZixRiqrWClW+zj+9zIuTX/zU0Mp
   4ygbaEWe6G/ffomy/s6hcYbe9TF2nq9WXGTsB/SLuPqZczv3ikl6iFvrn
   szmYNUrlbL/soBu9TRUJlTqO/xuxylGZ2OwGDAcWve/ZCgmuTqh2VkC6y
   3qOL1Dy0Gqtdtz9GilRK0Kt4XIb49/mhpXp5Ic7LaDtCDnNVoo6FFM8qb
   w==;
X-IronPort-AV: E=Sophos;i="5.95,198,1661788800"; 
   d="scan'208";a="212615969"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Oct 2022 14:39:01 +0800
IronPort-SDR: 6jMWTz2LbBJ0/VxHKgegZMAOhYleofYngqqo7p31to2biDftjdNBu+uiF4t/8xeYsqIlVDv9Dg
 MylONVkvTV7bSaYSR0LSD1kScymVQdYILMsONiEV77jWyF57twRhr78PnB7QiurTck7hREfR1j
 oocEvfkN/YzykL7utcXBzVbkg+4cU44MjLl8JMURwJD1k72emgp/L68h6EE7sGVV5D1qTBXfwo
 Gpik8hWxK7lWO6N0dMcHJfKCyNbb94srQ4P5QcIZBbFgyLTaqr4ayV1wbuicdi85KYBQlUAqye
 xJWKpFjMBCFRqAmfx6zctjOc
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Oct 2022 22:58:31 -0700
IronPort-SDR: F32I8qSuPjyujxGx8GJIzcG3iVxOjryDgn9e/Vgd4vesCcBrM+K7sKyleRpUd7cxxZ6bkqrfP1
 StRLa5u0nA2OEFS8iG5qVZd4RNKllujaxJJ+ydb2Z76oBfZqOoOkr0e3DSMGKMv1EZcF6VmYvQ
 Eaw2LZ3kn2tzH47sHH7es8y+iOuQBjuwNN4sSvhzos4izZBgdr5PrxYI2CKjriJEMUGWDY3avw
 jC3T1KyDMS4ZDG/HFtmY/Q+UNFAwwX+SUzyrZth+p3Gnl5P/Fj8wr7Y+vkJXBWjd3y98xjsSsv
 nxE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 19 Oct 2022 23:39:01 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 4/4] test: add test for experimental verify with loops and time_based options
Date:   Thu, 20 Oct 2022 15:38:54 +0900
Message-Id: <20221020063854.839158-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221020063854.839158-1-shinichiro.kawasaki@wdc.com>
References: <20221020063854.839158-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add a test case to confirm fix of numberio accounting issue of
experimental verify using loops and time_based options.

Of note is that this case fails on Windows with error "bad header
rand_seed". Until it gets fixed, require to non-Windows OS for this test
case so that CI does not report the known failure.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/jobs/t0026.fio   | 20 ++++++++++++++++++++
 t/run-fio-tests.py |  9 +++++++++
 2 files changed, 29 insertions(+)
 create mode 100644 t/jobs/t0026.fio

diff --git a/t/jobs/t0026.fio b/t/jobs/t0026.fio
new file mode 100644
index 00000000..4436392f
--- /dev/null
+++ b/t/jobs/t0026.fio
@@ -0,0 +1,20 @@
+[job1]
+filename=t0026file
+size=1M
+readwrite=randwrite
+loops=8
+do_verify=1
+verify=md5
+experimental_verify=1
+
+[job2]
+stonewall=1
+filename=t0026file
+size=1M
+readwrite=randrw
+time_based
+runtime=5
+do_verify=1
+verify=md5
+experimental_verify=1
+
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 439991a1..e5b307ac 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1205,6 +1205,15 @@ TEST_LIST = [
         'output_format':    'json',
         'requirements':     [],
     },
+    {
+        'test_id':          26,
+        'test_class':       FioJobTest,
+        'job':              't0026.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [Requirements.not_windows],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
-- 
2.37.1

