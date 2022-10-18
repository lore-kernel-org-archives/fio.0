Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB37EC433FE
	for <fio@archiver.kernel.org>; Tue, 18 Oct 2022 04:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiJRERg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Oct 2022 00:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJRERd (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Oct 2022 00:17:33 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639D597D76
        for <fio@vger.kernel.org>; Mon, 17 Oct 2022 21:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666066652; x=1697602652;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eAZYUB3zze6J043ZjktW1vErx1X7tBNEpRoZXSz4a5M=;
  b=X3TobifJzz3KQbs7Kc0AANZX8H3YVfwlzLdHZTtyj1RM4Dcz92Kj3Lv3
   Acm6AVc/JVFqirjZlWC3hcPYNeR4EE7Ht6t5/gKKbn/w1VbBC/rkLtOki
   cDHLeeKkkbywgxa8TSR/eRBro8k2PPRwt340GB6GRzbTm2u2cMbX3c/JX
   q+lP/0Ym8BolFRP0fyP5hPAWwcjDyJSBMAHeUTuXG6QrRyEL18yXDPA8g
   7O1LHOBdO3WHWa5IkDtBD7Z6C25BZeCYNVVRqfLw9NVy0EptB5FjJCrha
   jJuIkh16aes9m4jvlzT6o91jToN42IRMsCQkc3cztb1rXBFp/5KrntBJZ
   g==;
X-IronPort-AV: E=Sophos;i="5.95,193,1661788800"; 
   d="scan'208";a="214084032"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Oct 2022 12:17:32 +0800
IronPort-SDR: eGDny+q78DaWFlbjKNwZOPO7lx07xfqSalJ1ideBl4+vymLfKLlsxjc6Q8TwWzh604CDWE/ZPQ
 laOxfbklBP7akYSoTLko9mhTJI94TsEVcE3HgcAhCarQPxH7gM3SUVoPwL4hqOo2SKX2yD2QJC
 EomB+NFWDlBw2J435/WLidpTTpvPMk1fGNHYOMQXqgRcW6K7XeSrnQZSBe16nirO84eL35Z5m6
 gcsy/Vnkzmz7woAzB6/06KSAfaEA+VtnFSRSx6tcA5QDrUjTPO6Xd8JKc1vosDTvRAHcuU6Qcy
 MnKPJmgOc5z+Nx5+ff4uiML+
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Oct 2022 20:37:03 -0700
IronPort-SDR: oy8N6U09ZmFLSxrpOG+E4r4rltL8JYj6Zgy2tkfQLFJvXk504GwUr/M/bEJEafe0CF7MXOjYUS
 TcEXvyOKBeF7Z13FHDqqI/l1ieLZs9YhBL+Rb2MPqzhF9HXP2MiK7XjDlo9VCauTUbPXRkYUQZ
 oH2G0XKbQ1fpm5sfHU1+zMmR+/DoQb7T3+fUK7qfRnhs/Y/Fyus7HkB/ruK3oSAqXGQYxbP8F7
 CE5awRb31prxmsjgtYSPT2Bf+slRSCoOrFpMi5+5+EjGr2jEnjPRNUPDOAVOD+Z3U12HTvCgDX
 Ci0=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 17 Oct 2022 21:17:31 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 4/4] test: add test for experimental verify with loops and time_based options
Date:   Tue, 18 Oct 2022 13:17:25 +0900
Message-Id: <20221018041725.807940-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
References: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add a test case to confirm fix of numberio accounting issue of
experimental verify using loops and time_based options.

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
index 0e15068d..436042b1 100755
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
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
-- 
2.37.1

